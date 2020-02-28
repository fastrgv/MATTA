# MATTA
Morse Audio to Text Translator using Ada



**ver 1.0.0 -- 29feb2020**

* Initial version.

## Description

This is a commandline utility that converts a WAV sound file containing morse code to English text.  Pre-built binaries run on OSX, MsWindows, & GNU/linux.  It is written in Ada, so can be rebuilt on any platform with an Ada compiler.

The input wav file must be monaural, with a 16-bit signed integer encoding, and a sample rate of 8000 Hz.  Either sox or audacity can easily transform to this format.  The wav file is expected to be international morse code, preferrably clean and properly spaced.  Tonal frequency or wpm-speed does not seem to matter.

--------------------------------------------------------
## Usage Example

The user command requires the WAV file name, and integer-WPM estimate as input:

	wav2txt 40wpmAZ.wav 40

English text is then printed out to the screen.

Note that the precompiled executables use suffixes that indicates the system:
.) _osx (MacOSX)
.) _gnu (linux)
.) .exe (MsWin)

========================================================
## How It Works:

A clean morse code sound file contains tonal beeps separated by periods of silence.  After normalization, the sound wave peak amplitude is one, while the periods of silence have near zero peaks.  The simple approach used here seeks to detect those changes in peak amplitude that signal dots, dashes, and spaces.

The (ideal) international morse code relative timings are defined as:
.) length of a dot = 1
.) length of a dash = 3
.) space after dot or dash = 1
.) space after a letter = 3
.) space after a word = 7

MATTA is not perfect, but computer-generated sound files can be reliably decoded.

See also the inline code comments.

Final note:  many good apps can easily be found to generate morse code sound files from text.

--------------------------
## Legal Mumbo Jumbo:

Covered by the GNU GPL v3 as indicated in the sources:

 Copyright (C) 2020  <fastrgv@gmail.com>

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may read the full text of the GNU General Public License
 at <http://www.gnu.org/licenses/>.

