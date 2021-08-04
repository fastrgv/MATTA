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

function preparse(ewpm: integer) return integer is

-- begin 31jul21 addendum
	silence, avgSilence, numSilence: float := 0.0;
-- end 31jul21 addendum

	--ch: character;
	on: boolean;
	lwpm, iavg, decay, numon, numoff, nword : integer;
	v0: float;


	-- @ 8000 Hz [and step=1] @ 40 wpm:
	fade,dit: integer := 150; --duration of 1 "unit" (dit/dit-space)
	dah: integer := 450; --Dash
	eow: integer :=1050; --EndOfWord
	eol: integer := 450; --EndOfLetter
	--
	-- Ideal Ratios:
	-- dot								1
	-- dash								3
	-- space after dot or dash		1
	-- space after a letter			3
	-- space after a word			7




	function linearWPM(x: float) return integer is
		y: integer := integer(2.0+17000.0/x);
	begin
		if y<5 then return 5;
		elsif y>50 then return 50;
		else return y;
		end if;
	end;


begin --parse

	dit := dit * 40/ewpm;
	dah := dah * 40/ewpm;
	eow := eow * 40/ewpm;
	eol := eol * 40/ewpm;

	fade:=dit/2; --# data values below threshold before assuming silence


	numon:=0;
	numoff:=0;
	on:=false;
	nword:=0;
	decay:=0;

	for i in 1..nlines loop

		v0 := data(i);
		if v0 > 0.5 then -- signal detected...dot or dash
			decay := fade;
		end if;
		decay:=decay-1;

		if 
			--some condition for begin/continued beep
			decay>0
		then
		-- significant audio

			if not on then
				numon:=0;
				on:=true;

--if numoff>eol then

				silence := float(numoff);
				avgSilence := (avgSilence*numSilence+silence)/(numSilence+1.0);
				numSilence := numSilence + 1.0;
--end if;

				--put_line(integer'image(numoff));

			end if;
			numon := numon+1;

		else -- quiet audio => v0<0.5 for a while now

			if on then --turn off
				on:=false;
				--numoff:=0;
				numoff:=fade;
			end if; --on
			numoff := numoff+1;

		end if;

	end loop; --for i


	--sindx:=sindx+1;
	--morse(sindx) := '/'; --add EndOfWord marker @ EndOfMessage


	--fttb only print first 5 words:
	--new_line;

	new_line;

	iavg:=integer(avgSilence);
	put("avg=");
	put(integer'image(iavg));
	put(", ");


	lwpm := linearWpm(avgSilence);
	put("PREestimated WPM=");
	put(integer'image(lwpm));
	new_line;

	return lwpm;



end preparse;

