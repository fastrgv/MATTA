--
-- Copyright (C) 2020  <fastrgv@gmail.com>
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

--NOTE: WAV data is Little-Endian

procedure wav2txt is

-- this app requires a mono 16-bit 8000Hz WAV file as input.
-- (use audacity or sox if necessary to get this format).
-- Output is a textfile with one float value per line,
-- normalized  to be in [-1.0 ... +1.0],
-- with one line per time slice,

	type ubyte is mod 2**8; -- 1-byte

	package wio is new ada.direct_io(ubyte);
	use wio;
	use text_io;

	ifid: wio.file_type;
	sz: wio.count;

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
	sindx: chrng := 0;
	type msgtype is array(chrng) of character;
	morse, english: msgtype;

	nlines,iwpm: integer;

	procedure parse(wpm: integer) is separate;
	-- 1) converts data to morse
	-- 2) converts morse to english






begin

	-- large allocation here:
	data := new datatype;

	--put("ubyte'size=");
	--put(integer'image(ubyte'size)); --8
	--new_line;

	if ubyte'size /= 8 then
		put("ubyte is NOT 1 byte");
		raise program_error;
	end if;


if ada.command_line.argument_count = 2 then

	declare --outer
		filename : string := Ada.Command_Line.Argument(1);--File
		wstr : string := Ada.Command_Line.Argument(2);--#wpm
	begin --declare

		ada.integer_text_io.get(wstr,iwpm,last);

----------- read WAV file -------------------------
		wio.open(ifid, wio.in_file, filename);
		sz := wio.size(ifid);

		wio.set_index(ifid,rateoffset+1);
		wio.read(ifid,r1);
			wio.read(ifid,r2);
				wio.read(ifid,r3);
					wio.read(ifid,r4);
		srate :=
			integer(r1)+256*(integer(r2)
				+256*(integer(r3)+256*integer(r4)));

		put("input WAV file has sampleRate=");
		put( integer'image(srate) );
		put(", i.e. deltaTime="&float'image( 1.0/float(srate) ));
		new_line;

		put("input WAV file has byte-size=");
		put( wio.count'image(sz) ); --234284
		new_line;

		--each wav-data item is 2-bytes long
		nlines := integer((sz-dataoffset)/2);
		if nlines>mxlines then
			put_line("#lines > mxlines="&integer'image(mxlines));
			raise program_error;
		end if;



------- read & store WAV data -----------------------
			wio.set_index(ifid,dataoffset+1);
			for i in 1..nlines loop

				--grab 2 bytes
				wio.read(ifid,elt1);
					wio.read(ifid,elt2);

				--convert to float in [-1.0 ... +1.0]:
				f:= (float(elt2)*256.0+float(elt1))/32768.0;
				if elt2>128 then f:=f-2.0; end if;

				data(i):=f;

			end loop;
			wio.close(ifid);
-------------------------------------------------------

		parse(iwpm);


	end; --declare outer

else -- other than 1 parm
	put("expecting 2 parms: 1) name of input WAV file; 2) WPM");
	new_line;
end if;

end wav2txt;

