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
export VER="-011"
export CROSS_COMPILE=$PARENT_DIR/Neo-toolchain/arm-linux-gnueabihf-4.8-2013.08-neo/bin/arm-linux-gnueabihf-
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=ramgear
export KBUILD_BUILD_HOST="ubuntu"

cd $KERNEL_DIR

echo 
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

echo "Enter build version:"
options=("ALL" "JSS" "JWR")
select opt in "${options[@]}"
do
 case $opt in
        "ALL")
            echo "you chose choice 1";
            echo "";

	    make clean
            export EXTRA=JSS;
	    sh build_common.sh

	    make clean
            EXTRA=JWR;
	    sh build_common.sh
	    break;
            ;;
        "JSS")
            echo "you chose choice 2";
            echo "";
            export EXTRA=JSS;
	    sh build_common.sh
	    break;
            ;;
        "JWR")
            echo "you chose choice 3";
            echo "";
            export EXTRA=JWR;
	    sh build_common.sh
	    break;
            ;;
        *)
            echo "invalid option";
            exit 1;
            ;;
    esac
done

