#!/bin/bash -l

##########################################################
#
#       Prepare BEDfiles for CIRCOS
#
#       Luis Arriola
#       Last Update: Wed 1st July 2015
#		v.0.0
#
##########################################################
#
#	Used to create bed files of the reads for images in Circos
#	
###  Requires:
#       -Samtools
#		-BAM files
#		-Reference sequence (FASTA)
#
###

# Input files and variable declaration
if [ $# == 0 ]; then
	echo    "	Usage: bedfiles4circos.sh <Directory> 
        	Directory: Contains Alignment files (.bam)"
else
	DIR=$1
	echo "Directory:	$DIR"
	
	if [ -d $DIR ]; then
		for FILE in $DIR/*QualMap30_Sort_Uniq*.bam; do
			OUTDIR=`basename "${FILE/\.bam/}"`.bed
			#bedtools bamtobed -i $FILE |awk '{print $1"\t"$2"\t"$3}'| sed s/gi\|347750429\|ref\|NC_004350\.2\|/NC_004350\.2/g > $DIR/$OUTDIR
						bedtools bamtobed -i $FILE |awk '{print $1"\t"$2"\t"$3}'| sed s/gi\|148642060\|ref\|NC_009515\.1\|/NC_009515\.1/g > $DIR/$OUTDIR
			echo "BEDfile:	$OUTDIR"
		done
	fi
fi