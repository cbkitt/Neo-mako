#!/bin/bash

# check build option
if [ "$1" != "JSS" -a "$1" != "JWR" ]; then
	echo "Support only JSS/JWR building!!!"
	exit 1;
fi

EXTRA=$1;
BUILD_VER=$BASE_VER$VER"-"$EXTRA
BUILD_OPT_H=include/generated/build_opt.h

export LOCALVERSION="~"`echo $BUILD_VER`

# generate build option
sh build_opt.sh $EXTRA $BUILD_OPT_H

# make build
echo "Building $EXTRA version"

make "mako_defconfig"
make -j4 > $OUTPUT_DIR/$EXTRA-make.log

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

echo
echo "Building $EXTRA compelted."

cd $KERNEL_DIR

