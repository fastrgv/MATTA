![screenshot](https://github.com/fastrgv/MATTA/blob/master/cq.png)

# MATTA
Morse Audio to Text Translator using Ada


This link contains all source, data, & pre-built executables:

https://github.com/fastrgv/MATTA/releases/download/v1.0.2/mor3aug21.7z

Type "7z x filename" to extract the archive.







# Morse Audio to Text Translator Using Ada: MATTA


**ver 1.0.3 -- 05aug2021**

* Improved txt2wav with optional WPM parm;
* Improved wav2txt to better analyze input WAV files in absence of WPM parm.

**ver 1.0.1 -- 03aug2021**

* The commandline parameter estimated WPM may now be [optionally] omitted if the morse code message is long enough to get meaningful timing statistics.


**ver 1.0.0 -- 29feb2020**

* Initial version.


### GitHub Note: Please ignore the "Source code" zip & tar.gz files. (They are auto-generated by GitHub). Click on the large 7z file under releases to download all source & binaries (Windows,Mac & Linux). Then, type "7z x filename" to extract the archive. 


## Description

This is a commandline utility that converts a WAV sound file containing morse code to English text.  Pre-built binaries run on OSX, MsWindows, & GNU/linux.  It is written in Ada, so can be rebuilt on any platform with an Ada compiler.

The input wav file must be monaural, with a 16-bit signed integer encoding, and a sample rate of 8000 Hz.  Either sox or audacity can easily transform a WAV file to this format.  The wav file is expected to be international morse code, preferrably clean and properly spaced.  Tonal frequency or wpm-speed does not seem to matter.

Includes an inverse commandline app, txt2wav that creates a morse code WAV file from English text.

--------------------------------------------------------
## Usage Examples

The user command requires the WAV file name, and integer-WPM estimate as input:

	wav2txt 40wpmAZ.wav 40

English text is then printed out to the screen.

### Addendum1: WPM-estimate-parameter may now be optionally omitted IF the message is long enough to analyze.

	EG. wav2txt 40wpmAZ.wav

### Addendum2: for unknown messages, simply try various WPM-estimates. Most messages are between 10 and 40 wpm.

### Addendum3: the Windows executable will work on your linux box if wine is installed.

Note that the precompiled executables use suffixes that indicates the system:
.) _osx (MacOSX)
.) _gnu (linux)
.) .exe (MsWin)

For example, let's say you use a Mac and have a friend with a Windows computer.

	* txt2wav_osx "stop radioactivity"	creates a WAV file from text on OSX (20wpm.wav)

	* txt2wav_osx 30 "stop radioactivity" creates a WAV file from text on OSX (30wpm.wav)

Then your friend can decipher it with the command:

	* wav2txt.exe 20wpm.wav deciphers the WAV file on Windows.

--------------------------------------------------------------------------
The inverse app txt2wav takes a commandline string, which must be quoted to include spaces, optionally followed by an integer from the set {10,15,20,25,30,35,40}, and creates an output WAV file, named "xxwpm.wav", with the morse code equivalent.  This output file can be renamed and manipulated using "sox", as follows.

To slow it down try:
	sox new20wpm.wav new10wpm.wav speed 0.5

This lowers the tone (from 500 to 250 Hz) so to restore the tone try:
	sox new10wpm.wav hi10wpm.wav pitch +250

Too loud?  Try
	sox -v 0.8 hi10wpm.wav quiet10wpm.wav

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
## License:

Covered by the GNU GPL v3 as indicated in the sources:

 Copyright (C) 2021  <fastrgv@gmail.com>

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


