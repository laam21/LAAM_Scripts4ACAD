#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Reference Assisted Assembly
# This is a wrapper to run all the datasets present in a folder and create contigs using Velvet
# Versions
# VelvetOptimiser 2.2.4
# Velvet 1.2.10

## Modules
module load VelvetOptimiser/2.2.4
module list

mkdir FINAL_CONTIGS
mkdir LOGFILES
for FILE in *s1_ARnotcollapsed.fq.gz; do
  echo $FILE
  VelvetOptimiser.pl -s 21 -e 45 -f "-shortPaired -separate -fastq.gz $FILE ${FILE/s1/s2}" -p ${FILE/s1_ARnotcollapsed\.fq\.gz/}ARnotcollapsed
  cp ${FILE/s1_ARnotcollapsed\.fq\.gz/}ARnotcollapsed_data_*/contigs.fa FINAL_CONTIGS/${FILE/s1_ARnotcollapsed\.fq\.gz/}ARnotcollapsed_contigs.fa
  mv ${FILE/s1_ARnotcollapsed\.fq\.gz/}ARnotcollapsed_logfile.txt LOGFILES
  rm -r ${FILE/s1_ARnotcollapsed\.fq\.gz/}ARnotcollapsed_data_*
done
