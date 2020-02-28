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



separate( wav2txt )

procedure parse(wpm: integer) is

	ch: character;
	on: boolean;

	nw, decay, numon, numoff, nword : integer;

	v0: float;


	procedure decode is separate;
	-- morse(1..sindx) is converted to english(1..?)

	morseout: boolean := true; --false;


	-- @ 8000 Hz [and step=1] @ 40 wpm:
	min_dit: integer := 160; --duration of 1 "unit" (dit/dit-space)
	min_dah: integer := 400; --Dash
	min_eow: integer := 920; --EndOfWord
	min_eol: integer := 400; --EndOfLetter

	-- @ 8000 Hz [and step=1] @ 20 wpm (works for 25):
	--min_dit: constant integer := 320; --duration of 1 "unit" (dit/dit-space)
	--min_dah: constant integer := 800; --Dash
	--min_eow: constant integer :=1840; --EndOfWord
	--min_eol: constant integer := 800; --EndOfLetter

	-- @ 8000 Hz [and step=1] @ 15 wpm (works for xx):
	--min_dit: constant integer := 427; --duration of 1 "unit" (dit/dit-space)
	--min_dah: constant integer :=1067; --Dash
	--min_eow: constant integer :=2453; --EndOfWord
	--min_eol: constant integer :=1067; --EndOfLetter

begin

	min_dit := min_dit * 40/wpm;
	min_dah := min_dah * 40/wpm;
	min_eow := min_eow * 40/wpm;
	min_eol := min_eol * 40/wpm;


	numon:=0;
	numoff:=0;
	on:=false;
	nword:=0;
	decay:=0;

	for i in 1..nlines loop

		v0 := data(i);
		if v0 > 0.5 then
			decay := min_dit;
		end if;
		decay:=decay-1;

		if 
			--some condition for begin/continued beep
			decay>0
		then
		-- significant audio

			if not on then
				on:=true;

				if numoff>min_eow then --end of word

					nword:=nword+1;

					sindx:=sindx+1;
					morse(sindx) := '/'; --EndOfWord marker

				elsif numoff>min_eol then -- end of letter (Char)

					sindx:=sindx+1;
					morse(sindx) := '|'; --EndOfLetter marker

				--NOTE: 0<numoff<min_eol is assumed endOf a dit or dah

				end if;

				numon:=0;

			end if; -- not on

			numon := numon+1;

		else -- quiet audio

			if on then --turn off

				on:=false;

				if numon>=min_dah then --dash
					sindx:=sindx+1;
					morse(sindx):='-';
				else --dot
					sindx:=sindx+1;
					morse(sindx):='.';
				end if;

				numoff:=0;

			end if; --on

			numoff := numoff+1;

		end if;

	end loop; --for i


	sindx:=sindx+1;
	morse(sindx) := '/'; --add EndOfWord marker @ EndOfMessage

	decode; -- morse(1..sindx) is converted to english(1..?)

if morseout then
	--fttb only print first 4 words:
	new_line;
	put_line("sindx="&integer'image(sindx));
put_line("FTTB:  first 4 lines:");
	new_line;
	nw:=0;
	for i in 1..sindx loop
		ch:=morse(i);
		put(ch);
		if ch='/' then new_line; nw:=nw+1;
		end if;
		exit when nw=4;
	end loop;
	new_line;
end if;

end parse;

