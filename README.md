
# PlatformIO platform package for ArteryTek AT32 MCUs

### Remarks

It is a fork from original (1.0.3) with bugfixes.
Done:
1. *.svd files fixed
2. boards changed, if there is no FPU chip names "cortex-m4+nofp", it prevents compiler from using FPU
3. builder *.py fixed and changed
4. platform.json updated, toolchain version 12.3.1

and if one needs
5. f413 example is changed. It demonstrates .ini file with a choice of debugging from FLASH or RAM, rename output files (instead of "firmware"), ld script separating FLASH to Zero-Wait and slow, freertos in libdeps

### Installation:
1. Click "PlatformIO Core CLI" from VSCode PlatformIO Panel -> Quick Access -> Miscellaneous.
2. Enter below install commands:
```
#pio pkg install -g -p https://github.com/ArteryTek/platform-arterytekat32
pio pkg install -g -p https://github.com/Stas-Len/platform-arterytekat32
```

### When you are using under Linux, before using, you need to install the udev rules for OpenOCD
1. Copy the 60-openocd.rules file under tool-openocd-at32 package to /etc/udev/rules.d/ directory.
```
sudo cp ~/.platformio/packages/tool-openocd-at32/contrib/60-openocd.rules  /etc/udev/rules.d/
```
2. Refresh the udev rules.
```
sudo udevadm control --reload-rules && sudo udevadm trigger
```
