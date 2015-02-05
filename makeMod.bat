del z_tacticalops.iwd
del mod.ff

xcopy ui_mp ..\..\raw\ui_mp /SY
copy /Y mod.csv ..\..\zone_source
cd ..\..\bin
linker_pc.exe -language english -compress -cleanup mod
cd ..\mods\tacticalops
copy ..\..\zone\english\mod.ff
7za a -r -tzip z_tacticalops.iwd images
7za a -r -tzip z_tacticalops.iwd weapons
7za a -r -tzip z_tacticalops.iwd sound
7za a -r -tzip z_tacticalops.iwd maps
7za a -r -tzip z_tacticalops.iwd mp

pause