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
for FILE in *.fq.gz; do
  echo $FILE
  VelvetOptimiser.pl -s 21 -e 45 -f "-short -fastq $(basename $FILE)" -p ${FILE/\.fq\.gz/}
  cp ${FILE/\.fq\.gz/}_data_*/contigs.fa FINAL_CONTIGS/${FILE/\.fq\.gz/}_contigs.fa
  mv ${FILE/\.fq\.gz/}_logfile.txt LOGFILES
  rm -r ${FILE/\.fq\.gz/}_data_*
done
