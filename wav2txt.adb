--
-- Copyright (C) 2021  <fastrgv@gmail.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You may read the full text of the GNU General Public License
-- at <http://www.gnu.org/licenses/>.
--




with text_io; use text_io;
with ada.strings.fixed;
with ada.strings.unbounded;
with ada.containers.ordered_maps;
with ada.command_line;
with ada.integer_text_io;
with ada.direct_io;
with ada.numerics.generic_elementary_functions;


--NOTE: WAV data is Little-Endian

procedure wav2txt is

-- this app requires a mono 16-bit 8000Hz WAV file as input.
-- (use audacity or sox if necessary to get this format).
-- Output is a textfile with one float value per line,
-- normalized  to be in [-1.0 ... +1.0],
-- with one line per time slice,

	package math is new ada.numerics.generic_elementary_functions(float);
	use math;

	type ubyte is mod 2**8; -- 1-byte

	package wio is new ada.direct_io(ubyte);
	use wio;
	use text_io;

	ifid: wio.file_type;
	sz: wio.count;

	sizeoffset: constant wio.positive_count := 40;
	dataoffset: constant wio.positive_count := 44;
	rateoffset: constant wio.positive_count := 24;

	srate: integer;
	f: float;

	elt1,elt2, r1,r2,r3,r4: ubyte;

	ofid: text_io.file_type;

	last: natural;



	package myfloat_io is new text_io.float_io(float);

----------------------------------------------------
	mxlines: constant integer := 25_000_000; 
	type datatype is array(1..mxlines) of float;
	type dataptr is access datatype;
	data : dataptr;
----------------------------------------------------
	-- integer: upto: 2_147_483_647
----------------------------------------------------
	nchars: constant integer := 500_000;
	subtype chrng is integer range 0..nchars;
	sindx: chrng := 0; -- total # dots + dashes
	type msgtype is array(chrng) of character;
	morse, english: msgtype;

	nlines,iwpm, ewpm: integer;

	function prepre return integer is separate;
	function preparse(ewpm: integer) return integer is separate;

	procedure parse(wpm: integer) is separate;
	-- 1) converts data to morse
	-- 2) converts morse to english



---------------------------------------------------------------------
	-- to littleEndians
	procedure bytesFromInt( i: natural; b1,b2,b3,b4: out ubyte ) is
	begin
		b1 := ubyte(                 i mod 256 );
		b2 := ubyte(         ( i/256 ) mod 256 );
		b3 := ubyte(     ( i/256/256 ) mod 256 );
		b4 := ubyte( ( i/256/256/256 ) mod 256 );
	end;

	-- from littleEndians
	function intFrom4Bytes(b1,b2,b3,b4: ubyte) return integer is
	begin
		return integer(b1)+256*(integer(b2)
			+256*(integer(b3)+256*integer(b4)));
	end;

---------------------------------------------------------------------

	function floatFrom2Bytes(b1,b2: ubyte) return float is
		i: integer;
		f: float;
		ib1: constant integer := integer(b1);
		ib2: constant integer := integer(b2);
	begin

		if b2>=128 then
			i := (255-ib2)*256+ib1;
			f := -float(i)/32767.0; -- !now! ok within .0001
		else
			i := ib2*256+ib1;
			f := float(i)/32767.0; --Ok within .0001 !
		end if;

		return f;
	end;

	-- [unused here] 
	procedure bytesFromFloat(f: float; b1,b2: out ubyte) is
		x: float;
		cf : float := f; --Clamped f
		i: integer;
		neg: constant boolean := (f<0.0);
	begin

		if cf>=1.0 then cf:=1.0;
		elsif cf<=-1.0 then cf:=-1.0; end if;

		x  := cf*32767.0;
		i := integer(x); -- -32767 ... +32767

		if i>=0 then
			b1 := ubyte( i mod 256 );
			b2 := ubyte( (i/256) mod 256 );
		else
			b1 := ubyte( (-i) mod 256 );
			b2 := 255 - ubyte( (-i/256) mod 256 );
		end if;

	end;

---------------------------------------------------------------------


begin

	-- large allocation here:
	data := new datatype;


	if ubyte'size /= 8 then
		put("Error: ubyte is NOT 1 byte");
		raise program_error;
	end if;

if ada.command_line.argument_count = 1 then

	declare --outer
		filename : string := Ada.Command_Line.Argument(1);--File
	begin --declare

----------- read WAV file -------------------------
		wio.open(ifid, wio.in_file, filename);
		sz := wio.size(ifid);


--begin size insert--------------------------------------------

--when writing a WAV file, this must be defined:
--wio.set_index(ifid,sizeoffset+1);
--wio.read(ifid,r1);
--wio.read(ifid,r2);
--wio.read(ifid,r3);
--wio.read(ifid,r4);
--ssize := intFrom4Bytes(r1,r2,r3,r4);
--bytesFromInt(ssize, b1,b2,b3,b4);
--put("ssize=");
--put( integer'image(ssize) );
--new_line; --234240 == sz-44 == sz-dataoffset

--end size insert----------------------------------------------


		wio.set_index(ifid,rateoffset+1);
		wio.read(ifid,r1);
			wio.read(ifid,r2);
				wio.read(ifid,r3);
					wio.read(ifid,r4);
		srate := intFrom4Bytes(r1,r2,r3,r4);
			--integer(r1)+256*(integer(r2)
			--	+256*(integer(r3)+256*integer(r4)));

		put("input WAV file has sampleRate="); --8000
		put( integer'image(srate) );
		put(", i.e. deltaTime="&float'image( 1.0/float(srate) ));
		new_line;

		put("input WAV file has byte-size=");
		put( integer'image( integer(sz) ) );
		new_line;

		--each wav-data item is 2-bytes long
		nlines := integer((sz-dataoffset)/2);
		if nlines>mxlines then
			put_line("Error: #lines > mxlines="&integer'image(mxlines));
			raise program_error;
		end if;



------- read & store WAV data -----------------------
			wio.set_index(ifid,dataoffset+1);
			for i in 1..nlines loop

				--grab 2 bytes
				wio.read(ifid,elt1);
					wio.read(ifid,elt2);

				--convert to float in [-1.0 ... +1.0]:
				f:=floatFrom2bytes(elt1,elt2);

				data(i):=f;

			end loop;
			wio.close(ifid);
-------------------------------------------------------

		ewpm := prepre; -- initial estimated WPM
		iwpm := preparse(ewpm); --improved estimated WPM
		parse(iwpm);

	end; --declare outer


elsif ada.command_line.argument_count = 2 then

	declare --outer
		filename : string := Ada.Command_Line.Argument(1);--File
		wstr : string := Ada.Command_Line.Argument(2);--#wpm
	begin --declare

		ada.integer_text_io.get(wstr,iwpm,last);

		--fudgeFactor to adjust input WPM parm downward:
		iwpm := 4*iwpm/5;

----------- read WAV file -------------------------
		wio.open(ifid, wio.in_file, filename);
		sz := wio.size(ifid);


--begin size insert--------------------------------------------

--when writing a WAV file, this must be defined:
--wio.set_index(ifid,sizeoffset+1);
--wio.read(ifid,r1);
--wio.read(ifid,r2);
--wio.read(ifid,r3);
--wio.read(ifid,r4);
--ssize := intFrom4Bytes(r1,r2,r3,r4);
--bytesFromInt(ssize, b1,b2,b3,b4);
--put("ssize=");
--put( integer'image(ssize) );
--new_line; --234240 == sz-44 == sz-dataoffset

--end size insert----------------------------------------------


		wio.set_index(ifid,rateoffset+1);
		wio.read(ifid,r1);
			wio.read(ifid,r2);
				wio.read(ifid,r3);
					wio.read(ifid,r4);
		srate := intFrom4Bytes(r1,r2,r3,r4);
			--integer(r1)+256*(integer(r2)
			--	+256*(integer(r3)+256*integer(r4)));

		put("input WAV file has sampleRate="); --8000
		put( integer'image(srate) );
		put(", i.e. deltaTime="&float'image( 1.0/float(srate) ));
		new_line;

		put("input WAV file has byte-size=");
		put( integer'image( integer(sz) ) );
		new_line;

		--each wav-data item is 2-bytes long
		nlines := integer((sz-dataoffset)/2);
		if nlines>mxlines then
			put_line("Error: #lines > mxlines="&integer'image(mxlines));
			raise program_error;
		end if;



------- read & store WAV data -----------------------
			wio.set_index(ifid,dataoffset+1);
			for i in 1..nlines loop

				--grab 2 bytes
				wio.read(ifid,elt1);
					wio.read(ifid,elt2);

				--convert to float in [-1.0 ... +1.0]:
				f:=floatFrom2bytes(elt1,elt2);

				data(i):=f;

			end loop;
			wio.close(ifid);
-------------------------------------------------------

		parse(iwpm);

		--ewpm := preparse;
		--parse(ewpm);

	end; --declare outer

else -- other than 1 parm
	put("Error: expecting 1 or 2 parms: 1) name of input WAV file; 2) WPM");
	new_line;
end if;

end wav2txt;

