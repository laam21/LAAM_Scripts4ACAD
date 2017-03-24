#!/bin/sh -l
module load mapDamage/2.0.2 java/java-jdk-1.8.020 python/4.4.3/2.7.2 R/3.2.2-src
module list

REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/SmutansUA159.fasta
for FILE in `ls -1 *.bam`;
  do
  BAM=`basename $BAM`
  mapDamage -i $FILE -r $REF -d ${BAM}_mapDamage
done
wait
