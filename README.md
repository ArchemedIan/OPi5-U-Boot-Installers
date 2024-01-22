# Bootordered Mainline Orangepi 5/5B/5Plus U-Boot SPI builds
## Now with SD image installers that can also install images or clone your EMMC to NVME. 

### the easiest way to install an os to your opi5's NVME from Windows.
(linux and that other one too.)


## Downloads
### for opi5/5b, use an `rk3588s-orangepi-5` file 
### for opi5plus, use an `rk3588-orangepi-5-plus` file
- NON-SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered)
- SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-spi)
- SDcard Images with SPI installer/cloner: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-SPI-Installer-SDimages)

# Installer Instructions

## Install to SPI only
1) grab a u-boot installer with the desired bootorder from the link above
2) flash it to an SDCARD. and insert it into the opi5
3) boot the device, wait a few moments for the LED to come on. (on 5plus the led is blue, on 5/5b it may be green.) if there is any error, the led will not come on. this should not take more than 5 mins.
4) thats it, take the sdcard out, and reboot

## Install to SPI and clone USB/SD/EMMC to NVME (or any other combination)
1) grab a u-boot installer with the desired bootorder from the link above

1) flash it to an SDCARD. if you want to clone the os on an SDCARD youre already booting from, youll need to flash the installer to a second SDCARD.
1) go to the SDCARD's root (you may have to unplug/replug the card,) and edit CloneOptions.txt
1) change `EnableClone=0` to `EnableClone=1`
1) if you want to clone the whole device, leave `CloneBytes=0` as is. if you've flashed a fresh image to an sdcard or USB you want to clone, set this a bit above the size of the uncompressed image. for isntance, if the image was `1.6G` set this to `2000M` or `2G` 
1) for `CloneFrom=` and `CloneTo=` put the desired devices. the options are `sd`, `emmc`, `usb` , and `nvme`
1) with the opi5 off, put the SDCARD into the opi5, if youre using a usb stick, plug it into a USB 2.0 port (the white ones). if your cloning from/to an sdcard, have it ready.
1) boot the opi5. if youre not cloning from/to an sdcard, just wait for the led to come on. if it does, the clone succeded, and the spi has been flashed. (on 5plus the led is blue, on 5/5b it may be green.) otherwise continue to the next step
1) if you clone operation uses an sdcard, wait for the led to blink once every 2 seconds. its now safe to remove the spi installer sdcard
1) once youve removed the card, the led will blink twice every 2 seconds. its now safe to insert the sdcard you want to clone from/to. be aware this will accept any card as the clone source/destination , including the spi installer. 
1) the led should now stop blinking and the fan will start if it is connected to the fan header (at least on the 5plus, create a github issue if it does not on the 5/5b) this means the cloning process has started.
1) if you cloned to/from an SDcard, the led will start blinking again. remove the sdcard used for cloning, and re-insert the SPI installer SDcard.
1) now wait for the led to be lit solid. if it does, the clone succeded, and the spi has been flashed.

## Clone USB or EMMC to NVME ( or dump NVME or EMMC to USB) without installing SPI u-boot
1) same as above, except create a folder called `success` after step to and move (not copy) the u-boot .bin file to it.
