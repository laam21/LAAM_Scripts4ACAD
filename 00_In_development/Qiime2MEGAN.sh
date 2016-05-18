#!/bin/bash
# Created on Wed 11 2016
# By L. Arriola
# Script takes Qiime output and format it to work in MEGAN5
# Usage: Qiime2MEGAN.sh <Directory>
#		<Directory> Directory containing Qiime files
#		

if [ $# == 0 ]; then
	echo    "       Qiime2MEGAN.sh <Directory>
			<Directory> Directory containing Qiime files"
else
	DIR=$1
	cd $DIR
	mkdir Output
	for QIIMEFILE in *.txt; do
		cat $QIIMEFILE |sed 1,2d | awk -F "\t" '{print $3"\t"$2 }' > Output/MEGAN5_$QIIMEFILE
	done	
fi	