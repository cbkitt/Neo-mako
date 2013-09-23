#!/bin/bash

# generate new build opt, skip when choose same as previous build option
found=$(find $2 -type f | xargs grep -oh "$1");
if [ "$found" != "$1" ]; then

	# delete exist file
	if [ -e "$2" ]; then
		echo "Delete file $2"
		rm -rf $2;
	fi

	BUILD_OPT_H=$2

	echo "Generate file $BUILD_OPT_H"

	echo "#ifndef _BUILD_OPT_H_" >> $BUILD_OPT_H
	echo "#define _BUILD_OPT_H_" >> $BUILD_OPT_H
	echo "" >> $BUILD_OPT_H

	echo "#define CONFIG_FB_MSM_$1 1" >> $BUILD_OPT_H

	echo "" >> $BUILD_OPT_H
	echo "#endif" >> $BUILD_OPT_H
	echo "" >> $BUILD_OPT_H
fi

