Mega Man X MSU-1 hack
Version 0.9 (Beta)
by DarkShock

This hack adds CD quality audio to Mega Man X using the MSU-1 chip invented by byuu.

The hack is made for the 1.1 version of the game. Tested on SD2SNES, higan 094. BSNES 075 still have issues (probably a wrong setting in the xml file).

The patched ROM needs to be named mmx_msu1.sfc.

===============
= Using higan =
===============
1. Patch the ROM
2. Launch it using higan
3. Go to %USERPROFILE%\Emulation\Super Famicom\mmx_msu1.sfc in Windows Explorer.
4. Copy manifest.bml and the .pcm file there
5. Run the game

===============
= Using BSNES =
===============
NOTE: The patch still have issues with BSNES.

Just patch the ROM and launch the game. The pcm file needs to be in the same folder.

====================
= Using on SD2SNES =
====================
Drop the ROM file, mmx_msu1.msu and the .pcm files in any folder. (I really suggest creating a folder)
Launch the game and voilà, enjoy !

=============
= Compiling =
=============
Source is availabe on GitHub: https://github.com/mlarouche/MegamanX-MSU1

To compile the hack you need

* asar 1.36 (http://www.smwcentral.net/?p=section&a=details&id=6000)
* wav2msu (http://helmet.kafuka.org/thepile/Wav2msu)

The rom needs to be named mmx_msu1.sfc and be the version 1.1 of the game.

To distribute the hack you need

* uCON64 (http://ucon64.sourceforge.net/)
* 7-Zip (http://www.7-zip.org/)

make.bat assemble the patch
create_pcm.bat create the .pcm from the WAV files
distribute.bat distribute the patch
make_all.bat does everything

===============
= Music files =
===============
00 = Capcom Jingle (No Loop)
01 = Intro Stage
02 = Sting Cameleon
03 = Launch Octopus
04 = Armored Armadillo
05 = Flame Mammoth
06 = Boomer Kuwanger
07 = Chill Penguin
08 = Spark Mandrill
09 = Storm Eagle
10 = Sigma Stage 1
11 = Simga Stage 2
12 = Simga Stage 3
13 = Simga Stage 4
14 = Boss Battle 1
15 = Title Screen (No Loop)
16 = Stage Select
17 = Victory Jingle ! (No Loop)
18 = Stage Selected Jingle (No Loop)
19 = Boss Battle 2 Intro tension
20 = Boss Battle 2
21 = Zero Appears
22 = Zero Talks
23 = Got a Weapon (No Loop)
24 = Password
25 = Simga Stage Select
26 = Simga Battle 1
27 = Sigma Battle 2
28 = Ending Theme 1
29 = Ending Theme 2
30 = Boss Battle 1 Intro tension
31 = Sigma Battle 2 Intro
32 = Game Credits

For my personal tests I'm using a mix of OC ReMix and music from the PSP version for the upgraded audio. I would really love to release the final version of the hack with only music from the fans.

========
= TODO =
========
* Have a final music pack
* Fix issues with BSNES manifest file