#!/bin/bash -l
##########################################################
#
#       DIAMOND ANALYSIS
#
#       Luis Arriola
#       Last Update: 3rd August 2015
#
##########################################################
#
#
###  Requires:
#
#       -Diamond indexed database
#
###

if [ $# == 0 ]; then
        echo    "       Usage: run_diamond.sh <input files Directory>
                inputfiledir: Directory containingfastq.GZ input files"
else
        echo -e "Starting Diamond analysis..."

INPUTDIR=$1
DB="/localscratch/larriola/DIAMOND/nr_150527"
if [ -d diamond_temp ]; then
        TEMPDIR="diamond_temp"
else
        echo "Creating temporary directory..."
        mkdir diamond_temp
        TEMPDIR="diamond_temp"
        echo "Done"
fi

for READS in $INPUTDIR/*.fastq.gz; do
        echo -e "/home/users/larriola/software/Diamond/diamond blastx -d $DB -q $READS -a $(basename ${READS/.fastq.gz/})_DMND -t $TEMPDIR -p 48"
        /home/users/larriola/software/Diamond/diamond blastx -d $DB -q $READS -a $(basename ${READS/.fastq.gz/})_DMND -t $TEMPDIR -p 48
        echo -e "/home/users/larriola/software/Diamond/diamond view -a $(basename ${READS/.fastq.gz/})_DMND.daa -o $(basename ${READS/.fastq.gz/})_DMND.sam -p 48\n"
        /home/users/larriola/software/Diamond/diamond view -a $(basename ${READS/.fastq.gz/})_DMND.daa -f sam -o $(basename ${READS/.fastq.gz/})_DMND.sam -p 48
        echo -e "~/software/megan/tools/sam2rma -i $(basename ${READS/.fastq.gz/})_DMND.sam -o $(basename ${READS/.fastq.gz/})_DMND.rma3 -k -s -c -g2t /home/users/larriola/software/malt/data/gi_taxid_prot-2014Jan04.bin -g2k /home/users/larriola/software/malt/data/gi2kegg-new.map.gz -r2k /home/users/larriola/software/malt/data/ref2kegg.map.gz -g2s /home/users/larriola/software/malt/data/gi2seed-new.map.gz -r2s /home/users/larriola/software/malt/data/ref2seed.map.gz -r2c /home/users/larriola/software/malt/data/ref2cog.map.gz -v"
        ~/software/megan/tools/sam2rma -i $(basename ${READS/.fastq.gz/})_DMND.sam -o $(basename ${READS/.fastq.gz/})_DMND.rma3 -k -s -c -g2t /home/users/larriola/software/malt/data/gi_taxid_prot-2014Jan04.bin -g2k /home/users/larriola/software/malt/data/gi2kegg-new.map.gz -r2k /home/users/larriola/software/malt/data/ref2kegg.map.gz -g2s /home/users/larriola/software/malt/data/gi2seed-new.map.gz -r2s /home/users/larriola/software/malt/data/ref2seed.map.gz -r2c /home/users/larriola/software/malt/data/ref2cog.map.gz -v

done
fi