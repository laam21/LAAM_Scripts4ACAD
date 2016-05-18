#!/bin/bash -l

##########################################################
#
#       MALT ANALYSIS (v0.1.2)
#
#       Luis Arriola
#       Last Update: 24th Feb 2016
#
##########################################################
#
#
###  Requires:
#       -modules:
#               -Java
#               -Java jdk
#               
#       -index from malt-build
#
###

if [ $# == 0 ]; then
        echo    "	Usage: malt_multi_0_1_2.sh <INPUT_DATA_DIR/FILE> <MALT_INDEX_DIR>
		INPUT_DATA_DIR: Directory with the input data files or FILE in FASTQ or FASTQ.GZ format
		MALT_INDEX_DIR: Directory with the INDEX generated by malt-build"
else
# Loading Modules, and defining index/license
module load /opt/shared/system/Modules/modulefiles/java/java-1.7.09 /opt/shared/system/Modules/modulefiles/java/java-jdk-1.7.051
module list

INDEX=$2
LICENSE="/home/users/larriola/software/malt/MEGAN5-academic-license.txt"
export PATH=/home/users/larriola/software/malt:$PATH

# MALT
echo -e "Starting Analysis...\n"
# Input File or directory
if [[ -d $1 ]]; then
	SEQS=`ls -dm $1/* | tr "," " "| tr "\\n" " "`
	OUT_SEQS=`echo $(ls -m $1| tr "," " "| tr "\\n" " "| sed 's/\.\w*\.*\w*/_MALT\.sam/g')`
else
	SEQS=$1
	OUT_SEQS=$(basename "$SEQS" | cut -d. -f1)_MALT.sam
fi

echo "malt-run -t 40 -i $SEQS -a $OUT_SEQS -d $INDEX -m BlastX -L $LICENSE -v"
malt-run -t 16 -i $SEQS -a $OUT_SEQS -d $INDEX -m BlastX -L $LICENSE -v



# SAM2RMA
mkdir SAM_"$1"
mv *.sam.gz SAM_"$1"
unpigz SAM_"$1"/*
echo "running SAM2RMA"
~/Scripts/run_SAM2RMA.sh SAM_"$1"
#~/Scripts/run_SAM2RMA.sh $1

echo "END"
date

fi
