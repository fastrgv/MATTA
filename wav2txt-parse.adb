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



separate( wav2txt )

procedure parse(wpm: integer) is


-- begin 31jul21 addendum
	silence, avgSilence, numSilence: float := 0.0;
-- end 31jul21 addendum

	ch: character;
	on: boolean;
	lwpm, iavg, nw, decay, numon, numoff, nword : integer;
	v0: float;

	procedure decode is separate;
	-- morse(1..sindx) is converted to english(1..?)

	morseout: boolean := true; --false;

	-- original values:
	-- @ 8000 Hz [and step=1] @ 40 wpm:
	--dit: integer := 160; --150; --duration of 1 "unit" (dit/dit-space)
	--dah: integer := 400; --450; --Dash
	--eol: integer := 400; --450; --EndOfLetter
	--eow: integer := 920; --1050; --EndOfWord

	-- ideal values:
	-- @ 8000 Hz [and step=1] @ 40 wpm:
	dit: integer := 150; --duration of 1 "unit" (dit/dit-space)
	dah: integer := 450; --Dash
	eol: integer := 450; --EndOfLetter
	eow: integer := 1050; --EndOfWord

	fade: integer; -- # data values below threshold before assuming silence

	--
	-- International Morse Code...
	-- Ideal Ratios:
	-- dot								1
	-- dash								3
	-- space after dot or dash		1
	-- space after a letter			3
	-- space after a word			7
	--
	-- => 3 silence lengths expected: 1,3,7
	-- => 2 beep lengths expected: 1,3
	--
	-- Such info might be usable to deduce WPM speed.


	function linearWPM(x: float) return integer is
		y: integer := integer(2.0+17000.0/x);
	begin
		if y<10 then return 10;
		elsif y>40 then return 40;
		else return y;
		end if;
	end;


begin --parse

	dit := dit * 40/wpm; --minimum length of valid DOT
	dah := dah * 40/wpm; --minimum length of valid DASH
	eow := eow * 40/wpm;
	eol := eol * 40/wpm;

	fade := dit/2;

	numon:=0;
	numoff:=0;
	on:=false;
	nword:=0;
	decay:=0;

	for i in 1..nlines loop

		v0 := data(i);
		if v0 > 0.5 then -- signal detected...dot or dash?
			decay := fade;
		end if;
		decay:=decay-1;

		if 
			-- condition for begin/continued beep
			decay>0
		then
		-- significant audio

			if not on then

				numon:=0;
				on:=true;

				silence := float(numoff);
				avgSilence := (avgSilence*numSilence+silence)/(numSilence+1.0);
				numSilence := numSilence + 1.0;

				if numoff > eow then --end of word

					nword:=nword+1;

					sindx:=sindx+1;
					morse(sindx) := '/'; --EndOfWord marker

				elsif numoff>eol then 
				-- end of letter (Char)

					sindx:=sindx+1;
					morse(sindx) := '|'; --EndOfLetter marker

				--NOTE: 0<numoff<eol is assumed endOf a dit or dah

				end if;


			end if; -- not on

			numon := numon+1;

		else -- quiet audio

			if on then --turn off

				on:=false;

				if numon > dah then --dash
					sindx:=sindx+1;
					morse(sindx):='-';
				else --dot
					sindx:=sindx+1;
					morse(sindx):='.';
				end if;

				numoff:=fade;

			end if; --on

			numoff := numoff+1;

		end if;

	end loop; --for i


	sindx:=sindx+1;
	morse(sindx) := '/'; --add EndOfWord marker @ EndOfMessage

	decode; -- morse(1..sindx) is converted to english(1..?)

if morseout then
	--fttb only print first 5 words:
	new_line;

	--iavg:=integer(avgSilence);
	--put("avg=");
	--put(integer'image(iavg));
	--put(", ");


	--lwpm := linearWpm(avgSilence);
	--put("estimated WPM=");
	--put(integer'image(lwpm));
	--new_line;

	--put("avg_silence="&float'image(avgSilence));
	--put_line("; sindx="&integer'image(sindx));

	put_line("FTTB:  first 5 words:");
	new_line;
	nw:=0;
	for i in 1..sindx loop
		ch:=morse(i);
		put(ch);
		if ch='/' then -- end of word symbol
			new_line; nw:=nw+1;
		end if;
		exit when nw=5;
	end loop;
	new_line;
end if;

end parse;

