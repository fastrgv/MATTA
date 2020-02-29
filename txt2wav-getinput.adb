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

procedure getinput(
	instr: out strtype;
	last: out natural ) is
begin

	if ada.command_line.argument_count=1 then

		declare
			istr: string := Ada.Command_Line.Argument(1);
		begin
			last := istr'length;
			instr(1..last) := istr;
		end; --declare

	end if;

end;

