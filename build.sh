#!/bin/bash

clear

BASE_VER="Neo"
VER="-000"
BUILD_VER=$BASE_VER$VER

export LOCALVERSION="~"`echo $BUILD_VER`
#export CROSS_COMPILE=/opt/toolchain/arm-eabihf-4.7-2013.04/bin/arm-linux-gnueabihf-
export CROSS_COMPILE=/opt/toolchain/arm-eabihf-4.8-2013.08/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ramgear
export KBUILD_BUILD_HOST="ubuntu"

DATE_START=$(date +"%s")

KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/Custom-Kernel
ZIMAGE_DIR=$KERNEL_DIR/arch/arm/boot
CWM_DIR=../NEO_CWM
CWM_KERNEL_DIR=$CWM_DIR/kernel
MODULES_DIR=$CWM_DIR/system/lib/modules

echo 
echo "Kernel: "$BUILD_VER
echo
echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "KERNEL_DIR="$KERNEL_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo "ZIMAGE_DIR="$ZIMAGE_DIR
echo "MODULES_DIR="$MODULES_DIR
echo

echo 
echo "Making defconfig"
echo

make "mako_defconfig"
make -j3 > ~/make.log

rm `echo $MODULES_DIR"/*"`
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;

# cd $CWM_KERNEL_DIR
cp -vr $ZIMAGE_DIR/zImage $CWM_KERNEL_DIR
# use randisk modification script in CWM folder
#./mkbootimg --kernel zImage --ramdisk initrd.img --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=mako lpj=67677' --base 0x80200000 --pagesize 2048 --ramdiskaddr 0x81800000 -o boot.img

#cp -vr boot.img $CWM_DIR
cd $CWM_DIR
zip -r `echo $BUILD_VER`.zip *
mv  `echo $BUILD_VER`.zip $OUTPUT_DIR

# rm -rf $RAM_DIR/zImage
# rm -rf $RAM_DIR/initrd.img
# rm -rf $RAM_DIR/boot.img

echo
echo "Build completed at "$OUTPUT_DIR"/"$BUILD_VER".zip"

cd $KERNEL_DIR

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
