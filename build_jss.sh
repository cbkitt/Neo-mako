#!/bin/bash

BASE_VER="Neo"
VER="-011"
EXTRA="JSS"
BUILD_VER=$BASE_VER$VER"-"$EXTRA

export FB_MSM_JWR_BUILD=$EXTRA
export LOCALVERSION="~"`echo $BUILD_VER`
export CROSS_COMPILE=/opt/toolchain/arm-linux-gnueabihf-4.8-2013.08-neo/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ramgear
export KBUILD_BUILD_HOST="ubuntu"

DATE_START=$(date +"%s")

KERNEL_DIR=`pwd`
OUTPUT_DIR=${HOME}/Custom-Kernel
ZIMAGE_DIR=$KERNEL_DIR/arch/arm/boot
RAMDISK_DIR=$KERNEL_DIR/../Neo-Ramdisk
CWM_DIR=$KERNEL_DIR/../Neo-Ramdisk/cwm_any
CWM_KERNEL_DIR=$CWM_DIR/kernel
CWM_INITD_DIR=$CWM_DIR/system/etc/init.d
MODULES_DIR=$CWM_DIR/system/lib/modules
ADDIN_MODULE_DIR=$RAMDISK_DIR/modules

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

# make build
make "mako_defconfig"
make -j4 > ~/build_jss.log

# copy output files
rm -rf $MODULES_DIR/*
find $KERNEL_DIR -name '*.ko' -exec cp -v {} $MODULES_DIR \;
cp $ADDIN_MODULE_DIR/* $MODULES_DIR/
cp -vr $ZIMAGE_DIR/zImage $CWM_KERNEL_DIR

# create flashable zip
echo
echo "Create flashable zip"
echo
cd $CWM_DIR
zip -r `echo $BUILD_VER`-ANY.zip *
mv  `echo $BUILD_VER`-ANY.zip $OUTPUT_DIR

# clean 
rm -rf $CWM_KERNEL_DIR/zImage
rm -rf $MODULES_DIR/*

echo
echo "Build completed at "$OUTPUT_DIR"/"$BUILD_VER"-ANY.zip"

cd $KERNEL_DIR

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
