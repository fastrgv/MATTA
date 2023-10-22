![screenshot](https://github.com/fastrgv/MATTA/blob/master/cq.png)

# MATTA
Morse Audio to Text Translator using Ada


This link contains all source, data, & pre-built executables:

https://github.com/fastrgv/MATTA/releases/download/v1.0.6/mo6oct23.7z

Type "7z x filename" to extract the archive.

* On OSX, Keka works well for 7Z files. The command-line for Keka is:
	* /Applications/Keka.app/Contents/MacOS/Keka --cli 7z x (filename.7z)




#### GitHub Note: Please ignore the "Source code" zip & tar.gz files. (They are auto-generated by GitHub). Click on the large 7z file under releases to download all source & binaries (Windows,Mac & Linux). Then, type "7z x filename" to extract the archive. 







# Morse Audio to Text Translator Using Ada: MATTA



**ver 1.0.6 -- 06oct2023**

* Added a Mac/OSX build.


**ver 1.0.5 -- 07nov2022**

* Updated txt2wav so that it does not require the presence of a wav file from which a sample header is copied; i.e. the executable can be moved as needed, just like wav2txt.




## Description

This is a commandline utility that outputs English text when given a WAV sound file containing morse code. It includes pre-built binaries that run on MsWindows, OSX, & GNU/linux.  It is written in Ada, and can be rebuilt on any platform with an Ada compiler.

Unzip the archive.  

* On Linux & Windows, 7z [www.7-zip.org] works well for this. The proper command to extract the archive and maintain the directory structure is "7z x filename".

* On OSX, Keka works well for 7Z files. The command-line for Keka is:
	* /Applications/Keka.app/Contents/MacOS/Keka --cli 7z x (filename.7z)

After the archive is unzipped...

Then cd to the "base" directory named "morse". There are 3 executables, 1 for each system in the morse directory:

	wav2txt.exe, txt2wav.exe (Windows)
	wav2txt_gnu, txt2wav_gnu (Linux)
	wav2txt_osx, txt2wav_osx (OSX)

The input wav file must be monaural, with a 16-bit signed integer encoding, and a sample rate of 8000 Hz. (decoding factors depend on these assumptions.)

Either sox or audacity can easily transform a WAV file to this format.  The wav file is expected to be international morse code, preferrably clean and properly spaced.  Tonal frequency or wpm-speed does not seem to matter, but volume seems to be important.

Includes an inverse commandline app, txt2wav that creates a morse code WAV file from English text.

--------------------------------------------------------
## Usage Examples

The user command requires the WAV file name, and integer-WPM estimate as input:

	wav2txt testFiles/15wpm.wav 15

English text is then printed out to the screen.

### Addendum1: WPM-estimate-parameter may now be optionally omitted IF the message is long enough to analyze.

	EG. wav2txt testFiles/15wpm.wav

### Addendum2: for unknown messages, simply try various WPM-estimates. Most messages are between 10 and 40 wpm.

### Addendum3: the Windows executable will work on linux if wine is installed.


The inverse function "txt2wav" is even simpler to use...simply type:

	* txt2wav "message within quotes"

to create a file named "20wpm.wav", which can then be renamed & used as input for wav2txt.

Note that "txt2wav" & "wav2txt" may be moved to any convenient directory and will still work.


For example, let's say you use linux and have a friend with a Windows computer.

	* txt2wav "stop radioactivity" 20	

creates a WAV file from text (20wpm.wav)


Then your friend can decipher it with the command:

	* wav2txt.exe 20wpm.wav 

deciphers the WAV file on Windows.

--------------------------------------------------------------------------
The inverse function txt2wav takes a commandline string, **which must be quoted**, optionally followed by an integer from the set {10,15,20,25,30,35,40}, and creates an output WAV file, named "xxwpm.wav", with the morse code equivalent.  This output file can be renamed and manipulated using "sox", as follows.

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

* length of a dot = 1
* length of a dash = 3
* space after dot or dash = 1
* space after a letter = 3
* space after a word = 7

wav2txt is not perfect, but computer-generated sound files can be reliably decoded.

See also the inline code comments.

Final note:  many good apps can easily be found to generate morse code sound files from text.  One simple one is included (txt2wav) merely for the sake of completeness.


## Useful sox commands:

soxi file.wav (gives properties of wav file)

sox 20wpm8bit.wav -b 16 20wpm16bit.wav 
(convert from 8 bits to 16 bits)

sox 24bit44k.wav -b 16 16bit8k.wav channels 1 rate 8k
(convert from stereo 44.1k to mono 8k)

sox -v 1.5 quiet.wav louder.wav
(the beeps in the WAV file need to be loud enough [near maximal volume] for wav2txt to "hear" it!)

===================================================================

Open source Ada developers are welcome to help improve or extend this app.
Developer or not, send comments, suggestions or questions to:
fastrgv@gmail.com


## Build Instructions (for developers who wish to modify this code)

Prebuilt executables for 3 platforms are delivered. But if you want or need
to rebuild, you must first install GNU Ada. 

I suggest going to the following website to find an appropriate version of gnat:

	https://github.com/alire-project/GNAT-FSF-builds/releases

Then proceed to the ~/build/ subdirectory and modify one of the scripts below to match your system and GNU Ada installation directory:

	* lcmp.sh (linux)
	* w64cmp.bat (Windows)
	* ocmp.sh (OSX)

Make sure your script is executable, then simply type its name to rebuild.

--------------------------
## License:

Covered by the GNU GPL v3 as indicated in the sources:

 Copyright (C) 2023  <fastrgv@gmail.com>

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



## Revision History:

**ver 1.0.4 -- 05nov2022**

* Updated to use GNU Ada rather than defunct AdaCore.
* Simplified the directory structure for easier understanding.
* Updated documentation.

**ver 1.0.3 -- 05aug2021**

* Improved txt2wav with optional WPM parm;
* Improved wav2txt to better analyze input WAV files in absence of WPM parm.

**ver 1.0.1 -- 03aug2021**

* The commandline parameter estimated WPM may now be [optionally] omitted if the morse code message is long enough to get meaningful timing statistics.


**ver 1.0.0 -- 29feb2020**

* Initial version.



