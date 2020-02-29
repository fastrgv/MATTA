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




--with interfaces.c;
with ada.numerics.generic_elementary_functions;


package mathtypes is

	-- use this for serious work:
	--type real is new interfaces.c.double;
	--type real is new interfaces.c.c_float;

	package math_lib is new 
		ada.numerics.generic_elementary_functions(float);

end mathtypes;

