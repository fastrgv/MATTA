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



separate( txt2wav )

procedure txt2morse(
	tstr: string;
	morsestr: out strtype;
	last: out natural ) is

	ch: character;
	m: strng := 1;

begin

	for i in tstr'first .. tstr'last loop

		ch:=tstr(i);
		case ch is
		when 'a' =>
			morsestr(m..m+1):=".-"; m:=m+2;
			morsestr(m):='|'; m:=m+1;
		when 'b' =>
			morsestr(m..m+3):="-..."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'c' =>
			morsestr(m..m+3):="-.-."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'd' =>
			morsestr(m..m+2):="-.."; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'e' =>
			morsestr(m):='.'; m:=m+1;
			morsestr(m):='|'; m:=m+1;
		when 'f' =>
			morsestr(m..m+3):="..-."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'g' =>
			morsestr(m..m+2):="--."; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'h' =>
			morsestr(m..m+3):="...."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'i' =>
			morsestr(m..m+1):=".."; m:=m+2;
			morsestr(m):='|'; m:=m+1;
		when 'j' =>
			morsestr(m..m+3):=".---"; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'k' =>
			morsestr(m..m+2):="-.-"; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'l' =>
			morsestr(m..m+3):=".-.."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'm' =>
			morsestr(m..m+1):="--"; m:=m+2;
			morsestr(m):='|'; m:=m+1;
		when 'n' =>
			morsestr(m..m+1):="-."; m:=m+2;
			morsestr(m):='|'; m:=m+1;
		when 'o' =>
			morsestr(m..m+2):="---"; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'p' =>
			morsestr(m..m+3):=".--."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'q' =>
			morsestr(m..m+3):="--.-"; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'r' =>
			morsestr(m..m+2):=".-."; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 's' =>
			morsestr(m..m+2):="..."; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 't' =>
			morsestr(m):='-'; m:=m+1;
			morsestr(m):='|'; m:=m+1;
		when 'u' =>
			morsestr(m..m+2):="..-"; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'v' =>
			morsestr(m..m+3):="...-"; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'w' =>
			morsestr(m..m+2):=".--"; m:=m+3;
			morsestr(m):='|'; m:=m+1;
		when 'x' =>
			morsestr(m..m+3):="-..-"; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'y' =>
			morsestr(m..m+3):="-.--"; m:=m+4;
			morsestr(m):='|'; m:=m+1;
		when 'z' =>
			morsestr(m..m+3):="--.."; m:=m+4;
			morsestr(m):='|'; m:=m+1;
----------------------------------------------
		when '1' =>
			morsestr(m..m+4):=".----"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '2' =>
			morsestr(m..m+4):="..---"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '3' =>
			morsestr(m..m+4):="...--"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '4' =>
			morsestr(m..m+4):="....-"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '5' =>
			morsestr(m..m+4):="....."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '6' =>
			morsestr(m..m+4):="-...."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '7' =>
			morsestr(m..m+4):="--..."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '8' =>
			morsestr(m..m+4):="---.."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '9' =>
			morsestr(m..m+4):="----."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '0' =>
			morsestr(m..m+4):="-----"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		------ special characters:
		when '.' =>
			morsestr(m..m+5):=".-.-.-"; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when ',' =>
			morsestr(m..m+5):="--..--"; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when ''' =>
			morsestr(m..m+5):=".----."; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when '=' =>
			morsestr(m..m+4):="-...-"; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when ':' =>
			morsestr(m..m+5):="---..."; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when '/' =>
			morsestr(m..m+4):="-..-."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '+' =>
			morsestr(m..m+4):=".-.-."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when '-' =>
			morsestr(m..m+5):="-....-"; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when '(' =>
			morsestr(m..m+4):="-.--."; m:=m+5;
			morsestr(m):='|'; m:=m+1;
		when ')' =>
			morsestr(m..m+5):="-.--.-"; m:=m+6;
			morsestr(m):='|'; m:=m+1;
		when ';' =>
			morsestr(m..m+5):="-.-.-."; m:=m+6;
			morsestr(m):='|'; m:=m+1;

		when ' ' =>
			morsestr(m):='/'; m:=m+1;

		when others =>
			null;

		end case;

	end loop;
	last := natural(m);
end;

