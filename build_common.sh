#!/bin/bash

BUILD_VER=$BASE_VER$VER"-"$EXTRA

export FB_MSM_JWR_BUILD=$EXTRA
export LOCALVERSION="~"`echo $BUILD_VER`

DATE_START=$(date +"%s")

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

DATE_END=$(date +"%s")
echo
DIFF=$(($DATE_END - $DATE_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
