#!/bin/bash

clear

# Prepare build folder
export KERNEL_DIR=`pwd`

cd ..
export PARENT_DIR=`pwd`
export OUTPUT_DIR=${HOME}
export ZIMAGE_DIR=$KERNEL_DIR/arch/arm/boot
export PACKAGE_DIR=$PARENT_DIR/Neo-package
export CWM_DIR=$PACKAGE_DIR/Neo-ANY
export CWM_KERNEL_DIR=$CWM_DIR/kernel
export CWM_INITD_DIR=$CWM_DIR/system/etc/init.d
export MODULES_DIR=$CWM_DIR/system/lib/modules
export ADDIN_MODULE_DIR=$PACKAGE_DIR/modules

# Prepare build env
export BASE_VER="Neo-Newborn"
export VER="-V1"
export CROSS_COMPILE=/home/flyfrog/android/arm-unknown-linux-gnueabi-linaro_4.8.2-2013.09/bin/arm-unknown-linux-gnueabi-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ramgear
export KBUILD_BUILD_HOST="ubuntu"

cd $KERNEL_DIR

echo 
echo "Building "$BASE_VER$VER
echo "---------------------------------------"
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH
echo "SUBARCH="$SUBARCH
echo "KBUILD_BUILD_USER="$KBUILD_BUILD_USER
echo "KBUILD_BUILD_HOST="$KBUILD_BUILD_HOST
echo
echo "KERNEL_DIR="$KERNEL_DIR
echo "PACKAGE_DIR="$PACKAGE_DIR
echo "OUTPUT_DIR="$OUTPUT_DIR
echo

DATE_START=$(date +"%s")

sh build_common.sh "JWR"

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

