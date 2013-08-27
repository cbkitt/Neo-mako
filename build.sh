#!/bin/bash

clear

BASE_VER="Neo"
VER="-003"
BUILD_VER=$BASE_VER$VER

export LOCALVERSION="~"`echo $BUILD_VER`
export CROSS_COMPILE=/opt/toolchain/arm-eabihf-4.8-2013.08/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ramgear
export KBUILD_BUILD_HOST="ubuntu"

DATE_START=$(date +"%s")

KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/Custom-Kernel
ZIMAGE_DIR=$KERNEL_DIR/arch/arm/boot
RAMDISK_DIR=$KERNEL_DIR/../Neo-Ramdisk
INITRD_DIR=$RAMDISK_DIR/initrd
CWM_DIR=$RAMDISK_DIR/cwm
CWM_ANY_DIR=$RAMDISK_DIR/cwm_any
MODULES_DIR=$CWM_DIR/system/lib/modules
MODULES_ANY_DIR=$CWM_ANY_DIR/system/lib/modules

echo 
echo "Kernel: "$BUILD_VER
echo
echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "SUBARCH="$SUBARCH
echo "KBUILD_BUILD_USER="$KBUILD_BUILD_USER
echo "KBUILD_BUILD_HOST="$KBUILD_BUILD_HOST
echo
echo "KERNEL_DIR="$KERNEL_DIR
echo "RAMDISK_DIR="$RAMDISK_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo

echo 
echo "Making defconfig"
echo

# make
make "mako_defconfig"
make -j3 > ~/make.log

# copy output files
rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
cp -vr $ZIMAGE_DIR/zImage $RAMDISK_DIR

# create ramdisk
cd $INITRD_DIR
#find . | cpio -o -H newc | gzip > ../ramdisk.cpio.gz
#find . | cpio -o -H newc | xz --check=crc32 --lzma2=dict=8MiB > ../initrd.img

# create boot.img
cd $RAMDISK_DIR
./mkbootimg --kernel zImage --ramdisk ramdisk-002.cpio.gz --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677' --base 0x80200000 --pagesize 2048 --ramdiskaddr 0x81800000 -o boot.img

# create flashable zip
echo
echo "Create flashable zip"
echo
mv boot.img $CWM_DIR
cd $CWM_DIR
zip -r `echo $BUILD_VER`.zip *
mv  `echo $BUILD_VER`.zip $OUTPUT_DIR

# create flashable zip
echo
echo "Create ANY flashable zip"
echo
cp zImage $CWM_ANY_DIR/kernel
cp $MODULES_DIR/* $MODULES_ANY_DIR/
cd $CWM_ANY_DIR
zip -r `echo $BUILD_VER`-ANY.zip *
mv  `echo $BUILD_VER`-ANY.zip $OUTPUT_DIR

# clean 
rm -rf $RAMDISK_DIR/zImage
rm -rf $RAMDISK_DIR/initrd.img
rm -rf $CWM_DIR/boot.img
rm -rf $CWM_ANY_DIR/kernel/zImage

echo
echo "Build completed at "$OUTPUT_DIR"/"$BUILD_VER".zip"

cd $KERNEL_DIR

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
