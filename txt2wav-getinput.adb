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

procedure getinput(
	instr: out strtype;
	last: out natural ) is
begin

	if ada.command_line.argument_count=2 then

		declare
			istr: string := Ada.Command_Line.Argument(1);
			wstr : string := Ada.Command_Line.Argument(2);--#wpm
		begin
		
			ada.integer_text_io.get(wstr,iwpm,last);

			last := istr'length;

			if last<= strng'last then
				instr(1..last) := istr;
			else
				put("increase strng'last");
				raise program_error;
			end if;
		end; --declare


	elsif ada.command_line.argument_count=1 then

		declare
			istr: string := Ada.Command_Line.Argument(1);
		begin
			last := istr'length;

			if last<= strng'last then
				instr(1..last) := istr;
			else
				put("increase strng'last");
				raise program_error;
			end if;
		end; --declare

	end if;

end;

