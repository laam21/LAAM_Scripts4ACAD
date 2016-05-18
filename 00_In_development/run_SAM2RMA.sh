#!/bin/bash -l
##########################################################
#
#       Convert SAM to RMA (Wrapper)
#
#       Luis Arriola
#       Last Update: 18th of May 2015
#
##########################################################
#
#
###  Requires:
#
#       - Folder with SAM file(s)
#		- Megan tools (sam2rma)
#		- MALT/data files
#
###

if [ $# == 0 ]; then
        echo    "       Usage: run_SAM2RMA.sh <input files Directory>
                inputfiledir:  directory with SAM files"
else
        echo -e "Converting SAM files to RMA3..."

INPUTDIR=$1
for FILE in $INPUTDIR/*.sam; do

echo -e "~/software/megan/tools/sam2rma -i $FILE -o $(basename ${FILE/.sam/}).rma3 -k -s -c -g2t /home/users/larriola/software/malt/data/gi_taxid_prot-2014Jan04.bin -g2k /home/users/larriola/software/malt/data/gi2kegg-new.map.gz -r2k /home/users/larriola/software/malt/data/ref2kegg.map.gz -g2s /home/users/larriola/software/malt/data/gi2seed-new.map.gz -r2s /home/users/larriola/software/malt/data/ref2seed.map.gz -r2c /home/users/larriola/software/malt/data/ref2cog.map.gz -v"
        ~/software/megan/tools/sam2rma -i $FILE -o $(basename ${FILE/.sam/}).rma3 -k -s -c -g2t /home/users/larriola/software/malt/data/gi_taxid_prot-2014Jan04.bin -g2k /home/users/larriola/software/malt/data/gi2kegg-new.map.gz -r2k /home/users/larriola/software/malt/data/ref2kegg.map.gz -g2s /home/users/larriola/software/malt/data/gi2seed-new.map.gz -r2s /home/users/larriola/software/malt/data/ref2seed.map.gz -r2c /home/users/larriola/software/malt/data/ref2cog.map.gz -v

done
fi
