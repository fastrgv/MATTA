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



with mathtypes;
with ada.numerics;
with ada.direct_io;
with ada.directories;
with ada.command_line;
with text_io;


procedure txt2wav is

	use text_io;
	use mathtypes.math_lib;
	onepi: constant := ada.numerics.pi;
	twopi: constant := 2.0*onepi;

	subtype strng is integer range 1..555;
	subtype strtype is string(strng);
	txstr, mostr: strtype;
	lst1, lst2: natural;

	procedure getinput( 
		instr: out strtype; 
		last: out natural ) is separate;

	procedure txt2morse( 
		tstr: string; 
		morsestr: out strtype; 
		last: out natural ) is separate;

	procedure mstr2wav(morsestr: string) is separate;

begin

	if ada.directories.Exists("sos_20wpm.wav") then

		getinput( txstr, lst1 );

		txt2morse( txstr(1..lst1), mostr, lst2 );

		mstr2wav( mostr(1..lst2) );

	else --header file has gone missing
		put("The file sos_20wpm.wav is required but was not found!");
		new_line;
	end if;

end txt2wav;
