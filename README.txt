Mega Man X MSU-1 hack
by DarkShock

This hack adds support for the MSU-1 chip invented by byuu that supports CD quality audio and streaming 4Gb of data. This hack only uses the audio part of the chip.

The hack is made for the 1.1 version of the game. Tested on SD2SNES, higan 094.
bsnes 075 still have issues with the game (probably a wrong .xml file).

=============
= Compiling =
=============
To compile the hack you need

* asar 1.36 (http://www.smwcentral.net/?p=section&a=details&id=6000)
* wav2msu (http://helmet.kafuka.org/thepile/Wav2msu)

The rom needs to be named mmx_msu1.sfc and be the version 1.1 of the game.

For the name of the .wav files, look in the make.bat file. Right now I'm using a mix of OC ReMix and music from the PSP version for the upgraded audio. I would really love to release the final version of the hack with only music from the fans.

========
= TODO =
========
* Find a suitable RAM location for my two variables
* Complete a full game on higan
* Fix issues with bsnes manifest file