@ECHO OFF

del /q mmx_msu1.ips
del /q MegaManMSU1.zip
rmdir /s /q MegaManX_MSU1

mkdir MegaManX_MSU1
ucon64 -q --snes --chk mmx_msu1.sfc
ucon64 -q --mki=mmx_original.sfc mmx_msu1.sfc
copy mmx_msu1.ips MegaManX_MSU1
copy README.txt MegaManX_MSU1
copy mmx_msu1.msu MegaManX_MSU1
copy mmx_msu1.xml MegaManX_MSU1
copy manifest.bml MegaManX_MSU1
"C:\Program Files\7-Zip\7z" a -r MegaManMSU1.zip MegaManX_MSU1

"C:\Program Files\7-Zip\7z" a MegaManMSU1_Music.7z *.pcm