# Bootordered Mainline Orangepi 5/5B/5Plus U-Boot SPI builds
## Now with SD image installers that can also install images or clone your EMMC to NVME. 

### the easiest way to install an OS to your OPi5's NVME from Windows.
(linux and that other one too.)


## Downloads:


### for OPi5/5b, use an `rk3588s-orangepi-5` file 
### for opi5plus, use an `rk3588-orangepi-5-plus` file

- SDcard Images with SPI installer/cloner: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-SPI-Installer-SDimages)
- SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered-spi)
- NON-SPI Bootorderd mainline Downloads: [v2024.01](https://github.com/ArchemedIan/Opi5-u-boot-custom/releases/tag/v2024.01-bootordered)

# Installer Instructions:

## Install U-Boot to SPI only:
0) Grab a u-boot installer with the desired bootorder from the link above.
1) Flash it to an SDcard. and insert it into the OPi5.
2) Boot the device, wait a few moments for the LED to come on. (on 5plus the led is blue, on 5/5b it may be green.) if there is any error, the led will not come on. this should not take more than 10 mins.
3) Thats it, take the SDcard out, and reboot.

## Install U-Boot to SPI and clone USB/SD/EMMC to NVME (or any other combination):
0) Grab a u-boot installer with the desired bootorder from the link above.
1) Flash it to an SDcard. if you want to clone the os on an SDcard youre already booting from, youll need to flash the installer to a second SDcard.
2) Go to the SDcard's root (you may have to unplug/replug the card,) and edit `CloneOptions.txt`.
3) Change `EnableClone=0` to `EnableClone=1`.
4) If you want to clone the whole device, leave `CloneBytes=0` as is. if you've flashed a fresh image to an SDcard or USB you want to clone, set this a bit above the size of the uncompressed image. for isntance, if the image was `1.6G` set this to `2000M` or `2G`.
5) For `CloneFrom=` and `CloneTo=` put the desired devices. the options are `sd`, `emmc`, `usb` , and `nvme`.
6) With the OPi5 off, put the SDcard into the OPi5, if youre using a usb stick, plug it into a USB 2.0 port (the white ones). if your cloning from/to an SDcard, have it ready.
7) Boot the OPi5. if youre not cloning from/to an SDcard, just wait for the led to come on. if it does, the clone succeded, and the spi has been flashed. (on 5plus the led is blue, on 5/5b it may be green.) otherwise continue to the next step.
8) If you clone operation uses an SDcard, wait for the led to blink once every 2 seconds. its now safe to remove the spi installer SDcard.
9) Once youve removed the card, the led will blink twice every 2 seconds. its now safe to insert the SDcard you want to clone from/to. be aware this will accept any card as the clone source/destination , including the spi installer. 
10) The led should now stop blinking and the fan will start if it is connected to the fan header (at least on the 5plus, create a github issue if it does not on the 5/5b) this means the cloning process has started.
11) If you cloned to/from an SDcard, the led will start blinking again. remove the SDcard used for cloning, and re-insert the SPI installer SDcard.
12) Now wait for the led to be lit solid. if it does, the clone succeded, and the spi has been flashed.

