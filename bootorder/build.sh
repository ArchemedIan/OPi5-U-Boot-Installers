#!/bin/bash
rootdir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"


ubootRef=$1
ubootRepo=$2
boardconfig=$3
order=$4

"${{ inputs.uboot_ref }}" "${{ inputs.uboot_repo }}" "${{ matrix.boards.config }}" "${{ matrix.boards.bootorder }}" "${{ inputs.uboot_ref_custom }}" "${{ inputs.uboot_repo_custom}}" "${{ inputs.bootorder_custom }}" "${{ matrix.boards.name }}"

if [[ "$ubootRef" == *"custom_"* ]]; then
  ubootRef=$5
fi
if [[ "$ubootRepo" == *"custom_"* ]]; then
  ubootRepo=$6
fi
if [[ "$order" == *"custom_"* ]]; then
  order="$7"
  if [ -z "$7" ]; then
    order="sd usb nvme sata emmc"
  fi
fi

boardName=$8

orderUnder="${order// /_}"
bootorder="${order//_/ }"
#bootorder="${bootorder//sd/mmc1}"
bootorder="${bootorder//sd/mmc@fe2c0000.bootdev mmc@fe2d0000.bootdev}"
#bootorder="${bootorder//emmc/mmc0}"
bootorder="${bootorder//emmc/mmc@fe2e0000.bootdev}"
bootorder="${bootorder//sata/scsi}"

#sleep 30
echo BOOT ORDER IS $bootorder
#sleep 30

sudo apt-get update
sudo apt-get install gcc-12 gcc-12-aarch64-linux-gnu python3-pyelftools confget

sudo ln -sf cpp-12 /usr/bin/cpp
sudo ln -sf gcc-12 /usr/bin/gcc
sudo ln -sf gcc-ar-12 /usr/bin/gcc-ar
sudo ln -sf gcc-nm-12 /usr/bin/gcc-nm
sudo ln -sf gcc-ranlib-12 /usr/bin/gcc-ranlib
sudo ln -sf gcov-12 /usr/bin/gcov
sudo ln -sf gcov-dump-12 /usr/bin/gcov-dump
sudo ln -sf gcov-tool-12 /usr/bin/gcov-tool

sudo ln -sf aarch64-linux-gnu-cpp-12 /usr/bin/aarch64-linux-gnu-cpp
sudo ln -sf aarch64-linux-gnu-gcc-12 /usr/bin/aarch64-linux-gnu-gcc
sudo ln -sf aarch64-linux-gnu-gcc-ar-12 /usr/bin/aarch64-linux-gnu-gcc-ar
sudo ln -sf aarch64-linux-gnu-gcc-nm-12 /usr/bin/aarch64-linux-gnu-gcc-nm
sudo ln -sf aarch64-linux-gnu-gcc-ranlib-12 /usr/bin/aarch64-linux-gnu-gcc-ranlib
sudo ln -sf aarch64-linux-gnu-gcov-12 /usr/bin/aarch64-linux-gnu-gcov
sudo ln -sf aarch64-linux-gnu-gcov-dump-12 /usr/bin/aarch64-linux-gnu-gcov-dump
sudo ln -sf aarch64-linux-gnu-gcov-tool-12 /usr/bin/aarch64-linux-gnu-gcov-tool

git clone --branch master "https://github.com/rockchip-linux/rkbin.git" rkbin

git clone --branch ${ubootRef} "${ubootRepo}" u-boot
[ -f $rootdir/u-boot/configs/${boardconfig} ] || exit 1
grep "CONFIG_ROCKCHIP_SPI_IMAGE=y" $rootdir/u-boot/configs/${boardconfig} >/dev/null || echo -e "CONFIG_ROCKCHIP_SPI_IMAGE=y" >> $rootdir/u-boot/configs/${boardconfig}
echo -e "CONFIG_USE_PREBOOT=y" >> $rootdir/u-boot/configs/${boardconfig}
echo -e "CONFIG_PREBOOT=\"setenv boot_targets \\\"${bootorder}\\\"\"" >> $rootdir/u-boot/configs/${boardconfig}
echo -e "CONFIG_BOOTCOMMAND=\"bootflow scan -Gb\"" >> $rootdir/u-boot/configs/${boardconfig} #pci enum; nvme scan;
echo -e "CONFIG_BOOTSTD_FULL=y" >> $rootdir/u-boot/configs/${boardconfig}

cp $rootdir/v2-1-4-rockchip-rk3588-Fix-boot-from-SPI-flash.diff $rootdir/u-boot/

tail $rootdir/u-boot/configs/${boardconfig}

mkdir $rootdir/out

export ROCKCHIP_TPL=$rootdir/rkbin/$(confget -f $rootdir/rkbin/RKBOOT/RK3588MINIALL.ini -s LOADER_OPTION FlashData)
export BL31=$rootdir/rkbin/$(confget -f $rootdir/rkbin/RKTRUST/RK3588TRUST.ini -s BL31_OPTION PATH)
echo $ROCKCHIP_TPL
echo $BL31
cd u-boot
make mrproper
make ${boardconfig}
grep "BROM_BOOTSOURCE_SPINOR_RK3588 = 6" arch/arm/include/asm/arch-rockchip/bootrom.h && patch -p1 < v2-1-4-rockchip-rk3588-Fix-boot-from-SPI-flash.diff 
make KCFLAGS="-fno-peephole2" CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
ls $rootdir/out
#set -x
#ls u-boot*>/dev/null && cp u-boot* $rootdir/out
#[ -f idbloader.img ] && cp idbloader.img $rootdir/out
#[ -f idbloader-spi.img ] && cp idbloader-spi.img $rootdir/out
cp u-boot-rockchip-spi.bin   $rootdir/out/u-boot-$ubootRef-$boardName-spi__$orderUnder.bin
cp u-boot-rockchip.bin       $rootdir/out/u-boot-$ubootRef-${boardName}__$orderUnder.bin
exit 0
