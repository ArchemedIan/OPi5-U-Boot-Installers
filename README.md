# Bootordered Mainline Orangepi 5/5B/5Plus U-Boot SPI builds
## Now with SD image installers that can also install images or clone your EMMC to NVME. 

### the easiest way to install an os to your opi5's NVME from Windows.
(linux and that other one too.)


## Downloads
### for opi5/5b, use an `u-boot-spi-inst-v2024.01-rk3588s-orangepi-5` file, 
### for opi5plus, use an `u-boot-spi-inst-v2024.01-rk3588-orangepi-5-plus` image
- NON-SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered)
- SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-spi)
- SDcard Images with SPI installer/cloner: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-SPI-Installer-SDimages)

# Installer Instructions

## Install to SPI only
1) grab a u-boot installer with the desired bootorder from the link above
2) flash it to an SDCARD. and insert it into the opi5
3) boot the device, wait a few moments for the LED to come on. on opi5Plus, the LED is blue, but it may be green on other variants. if there is any error, the led will not come on. this should not take more than 5 mins.
4) thats it, take the sdcard out, and reboot

## Install to SPI and clone USB or EMMC to NVME ( or dump NVME or EMMC to USB)
1) grab a u-boot installer with the desired bootorder from the link above
2) flash it to an SDCARD.
3) grab an image youd like to install to the nvme, and flash it to a usb stick. take note of the images uncompressed size for step 6. if you're cloning your EMMC to you NVME, skip this step.
4) go to the SDCARD's root (you may have to unplug/replug the card,) and go into the folder named `post-spi-operations`
5) in this folder, there are txt files that represent clone operations to perform. copy the desired operation and paste it to the root of the sdcard.
6) open the operation txt file with text editor, and modify the line `CloneBytes=0` to a size slightly bigger than the image you want to install. for example, if your image is `1.6G` set the line to `CloneBytes=2G` if you want to clone a whole drive, keep this setting `0`
7) put the SDCARD into the opi5, and the usb stick into a USB 2.0 port (the white ones). if you're cloning your EMMC to you NVME, skip the usb
8) boot the pi, and wait a few moments for the LED to come on. on opi5Plus, the LED is blue, but it may be green on other variants. This means u-boot has finished flashing, and is ready for the cloning stage. if there is any error, the led will not come on. this should not take more than 5 mins.
9) reboot the opi5. if you have a fan installed to the fan header (at least on the 5plus) it should now come on. wait a while for the cloning operation to finish, and the led should come on when it completes succesfully. this could take hours if you're cloning a whole drive.
10) thats it, take the sdcard out, and reboot


## Clone USB or EMMC to NVME ( or dump NVME or EMMC to USB) without installing SPI u-boot
1) grab any u-boot installer from the link above
2) flash it to an SDCARD.
3) grab an image youd like to install to the nvme, and flash it to a usb stick. take note of the images uncompressed size for step 6.
4) go to the SDCARD's root (you may have to unplug/replug the card,) and make a folder named `success` and move the `u-boot-*.bin` to that directory. (NOTE: move not copy, the file should no longer be on the cards root) 
5) go into the folder named `post-spi-operations`
6) in this folder, there are txt files that represent clone operations to perform. copy the desired operation and paste it to the root of the sdcard.
7) open the operation txt file with text editor, and modify the line `CloneBytes=0` to a size slightly bigger than the image you want to install. for example, if your image is `1.6G` set the line to `CloneBytes=2G` if you want to clone a whole drive, keep this setting `0`
8) put the SDCARD into the opi5, and the usb stick into a USB 2.0 port (the white ones)
9) boot the opi5. if you have a fan installed to the fan header it should now come on (at least on the 5plus, tell me if it doesnt come on for the 5/5b.) Wait a while for the cloning operation to finish, and the led should come on when it completes succesfully. this could take hours if you're cloning a whole drive.
11) thats it, take the sdcard out, and reboot.
