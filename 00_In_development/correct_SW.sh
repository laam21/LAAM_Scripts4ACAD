#!/bin/bash -l

##########################################################
#
#       Correct SIMWRECK Output
#
#       Luis Arriola
#       Last Update: Tue 23 June 2015
#		v.0.0
#
##########################################################
#
#	Used to correct for similar names in different file
#	output from SW
###  Requires:
#       -
#		-Reads (FQ)
#		-Reference sequence (FASTA)
#
###

# Input files and variable declaration
if [ $# == 0 ]; then
	echo    "	Usage: correct_SW.sh <Directory> <OutputName>
        	Directory: Contains FASTA (.fa) files created by simwreck
        	OutputName: Output File Names"
else
	DIR=$1
	echo "Reference File:	$DIR"
	OUTfile=$2
	echo "Output File:		$OUTfile"

	if [ -d $DIR ]; then
		for FILE in $DIR/*.fa; do
			TEMP=`basename $FILE | cut -d'_' -f1`_
			cat $FILE | sed s/\>/\>$TEMP/g > $DIR/MOD_$(basename ${FILE})
			echo "MOD_$(basename ${FILE})"
		done
	fi
	cat `ls $DIR/MOD_*` > $DIR/$OUTfile
fi
