#!/bin/bash

# delete exist file
if [ -e "$2" ]; then
	rm -rf $2;
fi

BUILD_OPT_H=$2

# generate new build opt

echo "#ifndef _BUILD_OPT_H_" >> $BUILD_OPT_H
echo "#define _BUILD_OPT_H_" >> $BUILD_OPT_H
echo "" >> $BUILD_OPT_H

echo "#define CONFIG_FB_MSM_$1 1" >> $BUILD_OPT_H

echo "" >> $BUILD_OPT_H
echo "#endif" >> $BUILD_OPT_H
echo "" >> $BUILD_OPT_H

