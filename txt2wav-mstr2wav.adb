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



separate( txt2wav )


procedure mstr2wav(morsestr: string) is

	samplerate: constant float := 8000.0; -- data rate
	frequency : constant float := 500.0; -- Hz tone

	--these spacings suitable for 20 WPM @ 8000 Hz:
	dit: constant integer := 400;
	dah: constant integer :=1200;
	eod: constant integer := 400;
	eol: constant integer :=1200;
	eow: constant integer :=2800;

	subtype beeprng is natural range 0..100_000;
	type beeptype is array(beeprng) of integer;
	type bptr is access beeptype;

	oni, ofi : beeprng := 0;
	onn, off : bptr;

	function countSamples( msg: string ) return integer is
		k: integer := eol;
		ch: character;
	begin
		off(0):=0; ofi:=ofi+1;
		onn(0):=0; oni:=oni+1;
		for i in msg'first .. msg'last loop
			ch:=msg(i);

			if ch='.' then
				onn(oni):=k; oni:=oni+1;
				k := k+dit;
				off(ofi):=k; ofi:=ofi+1;
				k := k+eod;
			elsif ch='-' then
				onn(oni):=k; oni:=oni+1;
				k := k+dah;
				off(ofi):=k; ofi:=ofi+1;
				k := k+eod;
			elsif ch='|' then
				k := k+eol;
			elsif ch='/' then
				k := k+eow;
			end if;

		end loop;
		oni:=oni-1;
		ofi:=ofi-1;

		return k;
	end countSamples;


---------------------------------------------------------------------


	type ubyte is mod 2**8; -- 1-byte

	b1,b2,b3,b4: ubyte;

	package wio is new ada.direct_io(ubyte);
	use wio;
	use text_io;

	fin,fout: wio.file_type;

	sizeoffset: constant wio.positive_count := 40;
	dataoffset: constant wio.positive_count := 44;
	rateoffset: constant wio.positive_count := 24;


---------------------------------------------------------------------
	-- to littleEndians
	procedure bytesFromInt( i: natural; b1,b2,b3,b4: out ubyte ) is
	begin
		b1 := ubyte(                 i mod 256 );
		b2 := ubyte(         ( i/256 ) mod 256 );
		b3 := ubyte(     ( i/256/256 ) mod 256 );
		b4 := ubyte( ( i/256/256/256 ) mod 256 );
	end;

	-- [unused here] from littleEndians
	function intFrom4Bytes(b1,b2,b3,b4: ubyte) return integer is
	begin
		return integer(b1)+256*(integer(b2)
			+256*(integer(b3)+256*integer(b4)));
	end;

---------------------------------------------------------------------

	--unused here
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

 
----------------------------------------------------------

	numSamples: integer;
	sample: float;

begin

	onn:=new beeptype;
	off:=new beeptype;

wio.create(fout, wio.out_file, "new20wpm.wav");

--read sos_20wpm.wav; copy its header into new20wpm.wav; then close
wio.open(fin, wio.in_file, "sos_20wpm.wav");
for i in 1..sizeoffset loop
	wio.read(fin,b1);
	wio.write(fout,b1);
end loop;


	numSamples := countSamples(morsestr); -- (2-byte samples)
text_io.put_line("numSamples="&integer'image(numSamples));

	bytesFromInt(numSamples*2, b1,b2,b3,b4);
	wio.write(fout,b1);
	wio.write(fout,b2);
	wio.write(fout,b3);
	wio.write(fout,b4); --numSamples

wio.set_index(fin,rateoffset+1);
wio.read(fin,b1);
wio.read(fin,b2); --read sampleRate
wio.read(fin,b3);
wio.read(fin,b4);
wio.close(fin); --finished with prototype

	wio.write(fout,b1); --write sampleRate (8000Hz)
	wio.write(fout,b2);
	wio.write(fout,b3);
	wio.write(fout,b4);



------- end of header;  now write data ----------------------------

	for k in 0..oni-1 loop

		-- write silence between beeps
		for i in off(k)..onn(k+1)-1 loop
			sample:=0.0;
			bytesFromFloat(sample, b1, b2);
			wio.write(fout,b1);
			wio.write(fout,b2);
		end loop;


		-- write beep
		for i in onn(k+1)..off(k+1)-1 loop
			sample:=sin(twopi*float(i)*frequency/sampleRate);
			bytesFromFloat(sample, b1, b2);
			wio.write(fout,b1);
			wio.write(fout,b2);
		end loop; --i

	end loop; --k

	-- write final silence
	for i in off(oni)..numsamples loop
		sample:=0.0;
		bytesFromFloat(sample, b1, b2);
		wio.write(fout,b1);
		wio.write(fout,b2);
	end loop;

	wio.close(fout);


end mstr2wav;

