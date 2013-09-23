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
export BASE_VER="Neo"
export VER="-012"
export CROSS_COMPILE=$PARENT_DIR/Neo-toolchain/arm-linux-4.8.2-2013.09-neo/bin/arm-linux-gnueabihf-
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

echo "Host CC: " `gcc -v 2>&1 | tail -1`
echo "Cross CC: " `${CROSS_COMPILE}gcc -v 2>&1 | tail -1`
echo

DATE_START=$(date +"%s")

echo "Enter build version:"
options=("ALL" "JSS" "JWR")

select opt in "${options[@]}"
do
 case $opt in
        "ALL")
	    make clean
	    sh build_common.sh "JSS"

	    make clean
	    sh build_common.sh "JWR"
	    break;
            ;;
        "JSS")
	    sh build_common.sh "JSS"
	    break;
            ;;
        "JWR")
	    sh build_common.sh "JWR"
	    break;
            ;;
        *)
            echo "invalid option";
            exit 1;
            ;;
    esac
done

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

