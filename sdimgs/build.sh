#!/bin/bash

rootdir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
bootorderDir=$rootdir/../bootorder
bootorderSpiDir=$rootdir/../bootorder-spi-inst
sdimgOutDir=$rootdir/sdmimgout
sdimgSpiOutDir=$rootdir/sdmimgspiout

ubootRef=$1
ubootRepo=$2
boardconfig=$3
order=$4
ubootCustRef=$5
ubootCustRepo=$6
custOrder="$7"
boardName=$8



#build bootordered
cd $bootorderDir
chmod a+x ./build.sh 
./build.sh "${ubootRef}" "${ubootRepo}" "${boardconfig}" "${order}" "${ubootCustRef}" "${ubootCustRepo}" "${custOrder}" "${boardName}"
cd $rootdir

#make bootordered sdmimg
mkdir sdimg
cd sdimg
mv $bootorderDir/out/u-boot-${ubootRef}-${boardName}__${order}.bin .
fallocate -l 16M sdimg-u-boot-${ubootRef}-${boardName}__${order}.img
dd if=u-boot-${ubootRef}-${boardName}__${order}.bin of=sdimg-u-boot-${ubootRef}-${boardName}__${order}.img seek=1 bs=32k conv=fsync
mv sdimg-u-boot-${ubootRef}-${boardName}__${order}.img $sdimgOutDir/
rm $bootorderDir/out/u-boot-${ubootRef}-${boardName}__${order}.bin
cd $rootdir

#build bootordered sdimg SPI installer

#make bootordered sdimg SPI installer
#cp $bootorderDir/out/u-boot-${ubootRef}-${boardName}-spi__${order}.bin .
#upload 
