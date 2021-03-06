![screenshot](https://github.com/fastrgv/MATTA/blob/master/cq.png)

# MATTA
Morse Audio to Text Translator using Ada


This link contains all source, data, & pre-built executables:

https://github.com/fastrgv/MATTA/releases/download/v1.0.1/mat29feb20.7z

Type "7z x filename" to extract the archive.





# Morse Audio to Text Translator Using Ada: MATTA


**ver 1.0.1 -- 29feb2020**
* Added txt2wav
* Improved coding
* Initial version.

## Description

This is a commandline utility that converts a WAV sound file containing morse code to English text.  Pre-built binaries run on OSX, MsWindows, & GNU/linux.  It is written in Ada, so can be rebuilt on any platform with an Ada compiler.

The input wav file must be monaural, with a 16-bit signed integer encoding, and a sample rate of 8000 Hz.  Either sox or audacity can easily transform to this format.  The wav file is expected to be international morse code, preferrably clean and properly spaced.  Tonal frequency or wpm-speed does not seem to matter.

Now includes an inverse commandline app, txt2wav that creates a morse code WAV file from English text.

The proper command to extract the archive and maintain the directory structure is "7z x filename".

--------------------------------------------------------
## Usage Examples

The user command requires the WAV file name, and integer-WPM estimate as input:

	wav2txt 40wpmAZ.wav 40

English text is then printed out to the screen.

Note that the precompiled executables use suffixes that indicates the system:

.) _osx (MacOSX)

.) _gnu (linux)

.) .exe (MsWin)

For example, let's say you use a Mac and have a friend with a Windows computer.

	* txt2wav_osx	creates a WAV file from given text on OSX;
	
	* wav2txt.exe	deciphers the WAV file on Windows.

--------------------------------------------------------------------------
The new inverse app takes a commandline string, which must be quoted to include spaces thusly:

	txt2wav "the quick brown fox"

and creates an output WAV file, named "new20wpm.wav", with the morse code equivalent.  This output file can be renamed and manipulated using sox.

To slow it down try:

	sox new20wpm.wav new10wpm.wav speed 0.5

This also lowers the tone (from 500 to 250 Hz) so to restore the tone try:

	sox new10wpm.wav hi10wpm.wav pitch +250

Too loud?  Try

	sox -v 0.8 hi10wpm.wav quiet10wpm.wav
	
Note that txt2wav is a cheap & dirty tool to create minimal test input files for wav2txt.  The WAV headers might be illegal since they are blatantly copied from an existing WAV file.  Nevertheless, "sox" and "soxi" seem to accept them.  And if you are going to manipulate them with sox, the output of sox is probably legal.

========================================================
## How wav2txt Works:

A clean morse code sound file contains tonal beeps separated by periods of silence.  After normalization, the sound wave peak amplitude is one, while the periods of silence have near zero peaks.  The simple approach used here seeks to detect those changes in peak amplitude that signal dots, dashes, and spaces.

The (ideal) international morse code relative timings are defined as:

.) length of a dot = 1

.) length of a dash = 3

.) space after dot or dash = 1

.) space after a letter = 3

.) space after a word = 7

wav2txt is not perfect, but computer-generated sound files can be reliably decoded.

See also the inline code comments.

Final note:  many good apps can easily be found to generate morse code sound files from text.  One simple one is included (txt2wav) merely for the sake of completeness.

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
