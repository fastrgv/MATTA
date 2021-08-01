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

	ch: character;
	on: boolean;
	lwpm, iavg, nw, decay, numon, numoff, nword : integer;
	v0: float;


	-- @ 8000 Hz [and step=1] @ 40 wpm:
	min_dit: integer := 160; --duration of 1 "unit" (dit/dit-space)
	min_dah: integer := 400; --Dash
	min_eow: integer := 920; --EndOfWord
	min_eol: integer := 400; --EndOfLetter



	function linearWPM(x: float) return integer is
		--y: integer := integer(48.0 - x/25.0); --good
		y: integer := integer(49.0 - x/25.0); --better
	begin
		if y<10 then return 10;
		elsif y>40 then return 40;
		else return y;
		end if;
	end;


begin --parse

	min_dit := min_dit * 40/ewpm;
	min_dah := min_dah * 40/ewpm;
	min_eow := min_eow * 40/ewpm;
	min_eol := min_eol * 40/ewpm;


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
				silence := float(numoff);
				avgSilence := (avgSilence*numSilence+silence)/(numSilence+1.0);
				numSilence := numSilence + 1.0;

				--put_line(integer'image(numoff));

			end if;
			numon := numon+1;

		else -- quiet audio => v0<0.5 for a while now

			if on then --turn off
				on:=false;
				numoff:=0;
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

