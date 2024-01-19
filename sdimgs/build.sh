#!/bin/bash

rootdir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
bootorderDir=$rootdir/../bootorder
bootorderSpiDir=$rootdir/../spi-inst
sdimgOutDir=$rootdir/sdmimgout
sdimgSpiOutDir=$rootdir/sdmimgspiout
mkdir $sdimgOutDir
mkdir $sdimgSpiOutDir
ubootRef=$1
ubootRepo=$2
boardconfig=$3
order=$4
ubootCustRef=$5
ubootCustRepo=$6
custOrder="$7"
boardName=$8

sudo apt update
sudo apt install parted

#build bootordered
cd $bootorderDir
chmod a+x ./build.sh 
./build.sh "${ubootRef}" "${ubootRepo}" "${boardconfig}" "${order}" "${ubootCustRef}" "${ubootCustRepo}" "${custOrder}" "${boardName}"
cd $rootdir

#make bootordered sdmimg
mkdir sdimg
cd sdimg
mv $bootorderDir/out/u-boot-${ubootRef}-${boardName}__${order}.bin .
mv $bootorderDir/out/u-boot-${ubootRef}-${boardName}-spi__${order}.bin .

fallocate -l 16M sdimg-u-boot-${ubootRef}-${boardName}__${order}.img
dd if=u-boot-${ubootRef}-${boardName}__${order}.bin of=sdimg-u-boot-${ubootRef}-${boardName}__${order}.img seek=1 bs=32k conv=fsync

mv sdimg-u-boot-${ubootRef}-${boardName}__${order}.img $sdimgOutDir/
mv u-boot-${ubootRef}-${boardName}__${order}.bin $sdimgOutDir/
mv u-boot-${ubootRef}-${boardName}-spi__${order}.bin $sdimgOutDir/
#rm $bootorderDir/out/u-boot-${ubootRef}-${boardName}__${order}.bin
cd $rootdir

#build bootordered sdimg SPI installer
cd $bootorderSpiDir
chmod a+x ./build.sh 
./build.sh "${ubootRef}" "${ubootRepo}" "${boardconfig}" "${order}" "${ubootCustRef}" "${ubootCustRepo}" "${custOrder}" "${boardName}"
cd $rootdir

#make bootordered sdimg SPI installer
mkdir sdimgspi
cd sdimgspi
mv $bootorderSpiDir/out/u-boot-spi-inst-$ubootRef-${boardName}__${order}.bin .
fallocate -l 128M sdimg-u-boot-spi-inst-${ubootRef}-${boardName}__${order}.img

sudo losetup -f sdimg-u-boot-spi-inst-${ubootRef}-${boardName}__${order}.img || exit 1
NewImgloopdev=`losetup |grep sdimg-u-boot-spi-inst-${ubootRef}-${boardName}__${order} | awk '{print $1}'`
echo NewImgloopdev is $NewImgloopdev
sudo dd if=/dev/zero of=${NewImgloopdev} count=4096 bs=512
sudo parted --script ${NewImgloopdev} -- \
mklabel gpt \
mkpart primary ext4 16MiB -32768s \
name 1 SpiInst
sudo partprobe $NewImgloopdev
#sudo mkfs.ext4 -L SpiInst ${NewImgloopdev}p1
sudo mkfs.fat -F 32 -n SpiInst ${NewImgloopdev}p1
sudo partprobe $NewImgloopdev
#sudo tune2fs -O ^metadata_csum ${NewImgloopdev}p1
sudo dd if=u-boot-spi-inst-$ubootRef-${boardName}__${order}.bin of=$NewImgloopdev seek=1 bs=32k conv=fsync
sync
mkdir 1
sudo mount ${NewImgloopdev}p1 1
#sudo cp $sdimgOutDir/u-boot-${ubootRef}-${boardName}__${order}.bin 1
sudo cp $sdimgOutDir/u-boot-${ubootRef}-${boardName}-spi__${order}.bin 1
sudo mkdir 1/post-spi-operations
sudo tee
echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_usb0_to_emmc.txt
echo "CloneFromDev=usb" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_emmc.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_emmc.txt
echo "CloneToDev=mmc" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_emmc.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_emmc.txt

echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_usb0_to_nvme.txt
echo "CloneFromDev=usb" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_nvme.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_nvme.txt
echo "CloneToDev=nvme" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_nvme.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_usb0_to_nvme.txt

echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_emmc_to_usb0.txt
echo "CloneFromDev=mmc" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_usb0.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_usb0.txt
echo "CloneToDev=usb" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_usb0.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_usb0.txt

echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_nvme_to_usb0.txt
echo "CloneFromDev=nvme" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_usb0.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_usb0.txt
echo "CloneToDev=usb" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_usb0.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_usb0.txt

echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_emmc_to_nvme.txt
echo "CloneFromDev=mmc" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_nvme.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_nvme.txt
echo "CloneToDev=nvme" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_nvme.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_emmc_to_nvme.txt

echo "CloneBytes=0" |sudo tee 1/post-spi-operations/Clone_nvme_to_emmc.txt
echo "CloneFromDev=nvme" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_emmc.txt
echo "CloneFromNum=0" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_emmc.txt
echo "CloneToDev=mmc" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_emmc.txt
echo "CloneToNum=0" |sudo tee -a 1/post-spi-operations/Clone_nvme_to_emmc.txt

sudo umount ${NewImgloopdev}p1
sudo partx -d ${NewImgloopdev}p1
sudo losetup -d ${NewImgloopdev}
sync
sleep 5
mv sdimg-u-boot-spi-inst-${ubootRef}-${boardName}__${order}.img $sdimgOutDir/
mv u-boot-spi-inst-$ubootRef-${boardName}__${order}.bin $sdimgOutDir/
#rm $bootorderDir/out/u-boot-spi-inst-${ubootRef}-${boardName}__${order}.bin
cd $rootdir

#upload 
ls $sdimgOutDir/
