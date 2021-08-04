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



separate( wav2txt.parse )


procedure decode is 
-- morse(1..sindx) is converted to english(1..?)

	use ada.strings.unbounded;

	endOfWord : constant character := '/';
	endOfLetr : constant character := '|';

	package AssoChar is new 
		Ada.Containers.Ordered_Maps(Unbounded_String, Character);
	use AssoChar;

	mc: Map;
	ok: boolean;
	cur: Cursor;

	token: unbounded_string;
	mch,ech: character;
	a,b,pindx: chrng := 0;

	msgout : boolean := true; --false;

begin

	-- "Train" the Map:
	mc.insert( to_unbounded_string(".-"),   'A', cur, Ok );
	mc.insert( to_unbounded_string("-..."), 'B', cur, Ok );
	mc.insert( to_unbounded_string("-.-."), 'C', cur, Ok );
	mc.insert( to_unbounded_string("-.."),  'D', cur, Ok );
	mc.insert( to_unbounded_string("."),    'E', cur, Ok );

	mc.insert( to_unbounded_string("..-."), 'F', cur, Ok );
	mc.insert( to_unbounded_string("--."),  'G', cur, Ok );
	mc.insert( to_unbounded_string("...."), 'H', cur, Ok );
	mc.insert( to_unbounded_string(".."),   'I', cur, Ok );
	mc.insert( to_unbounded_string(".---"), 'J', cur, Ok );

	mc.insert( to_unbounded_string("-.-"),  'K', cur, Ok );
	mc.insert( to_unbounded_string(".-.."), 'L', cur, Ok );
	mc.insert( to_unbounded_string("--"),   'M', cur, Ok );
	mc.insert( to_unbounded_string("-."),   'N', cur, Ok );
	mc.insert( to_unbounded_string("---"),  'O', cur, Ok );

	mc.insert( to_unbounded_string(".--."), 'P', cur, Ok );
	mc.insert( to_unbounded_string("--.-"), 'Q', cur, Ok );
	mc.insert( to_unbounded_string(".-."),  'R', cur, Ok );
	mc.insert( to_unbounded_string("..."),  'S', cur, Ok );
	mc.insert( to_unbounded_string("-"),    'T', cur, Ok );

	mc.insert( to_unbounded_string("..-"),  'U', cur, Ok );
	mc.insert( to_unbounded_string("...-"), 'V', cur, Ok );
	mc.insert( to_unbounded_string(".--"),  'W', cur, Ok );
	mc.insert( to_unbounded_string("-..-"), 'X', cur, Ok );
	mc.insert( to_unbounded_string("-.--"), 'Y', cur, Ok );
	mc.insert( to_unbounded_string("--.."), 'Z', cur, Ok );

	mc.insert( to_unbounded_string(".----"), '1', cur, Ok );
	mc.insert( to_unbounded_string("..---"), '2', cur, Ok );
	mc.insert( to_unbounded_string("...--"), '3', cur, Ok );
	mc.insert( to_unbounded_string("....-"), '4', cur, Ok );
	mc.insert( to_unbounded_string("....."), '5', cur, Ok );
	mc.insert( to_unbounded_string("-...."), '6', cur, Ok );
	mc.insert( to_unbounded_string("--..."), '7', cur, Ok );
	mc.insert( to_unbounded_string("---.."), '8', cur, Ok );
	mc.insert( to_unbounded_string("----."), '9', cur, Ok );
	mc.insert( to_unbounded_string("-----"), '0', cur, Ok );

	mc.insert( to_unbounded_string(".-.-.-"), '.', cur, Ok ); --period
	mc.insert( to_unbounded_string("--..--"),  ',', cur, Ok );--comma
	mc.insert( to_unbounded_string(".----."),  ''', cur, Ok );--apostr
	mc.insert( to_unbounded_string("-...-"),  '=', cur, Ok );--equal
	mc.insert( to_unbounded_string("---..."),  ':', cur, Ok );--colon

	mc.insert( to_unbounded_string("-..-."),  '/', cur, Ok );--slash

	mc.insert( to_unbounded_string(".-.-."),  '+', cur, Ok );--plus
	mc.insert( to_unbounded_string("-....-"),  '-', cur, Ok );--minus

	mc.insert( to_unbounded_string("-.--."),  '(', cur, Ok );--openP
	mc.insert( to_unbounded_string("-.--.-"),  ')', cur, Ok );--closeP

	mc.insert( to_unbounded_string("-.-.-."),  ';', cur, Ok );--semiCol

-------- thru training;  now process --------------------------

	a:=1;
	outer:
	loop -- thru each letter of message

		set_unbounded_string(token,"");
		b:=a;
		inner:
		loop
			mch:=morse(b);
			exit inner when mch=endOfWord;
			exit inner when mch=endOfLetr;
			append(token, mch );
			b:=b+1;
			exit inner when b>=sindx;
		end loop inner;

		declare
		begin
			ech := element(mc,token);
		exception
			when others =>
				ech:='~'; --symbol for Unknown
		end; --declare

		if length(token)>0 then
			pindx:=pindx+1;
			english(pindx):=ech;
		end if;

		if mch=endOfWord then
			pindx:=pindx+1;
			english(pindx):=' ';
		end if;

		exit outer when b>=sindx;

		a:=b+1; --a should point to next VALID char

	end loop outer;

if msgout then
	new_line;
	put_line("Message in English:");
	for i in 1..pindx loop
		put(english(i));
	end loop;
	new_line;
end if;

end decode;

