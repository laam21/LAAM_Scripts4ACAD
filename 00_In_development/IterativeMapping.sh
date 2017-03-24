#!/bin/bash -l
module load bwa tabix vcftools
module list
date

REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/bowtie2/SmutansUA159
COUNTER=0
OUTDIR=IterativeMap_BWAaln_30
mkdir $OUTDIR

while [ $COUNTER -lt 30 ]; do
        echo "Using Reference File: $REF"


for FQZ in *fasta
do
FQ=`basename $FQZ`
bowtie2 -p16 -f -x $REF -U $FQZ -S ${FQ}.sam
( samtools view -uSh ${FQ}.sam \
| samtools sort - ${FQ}_bowtie2.sort
rm ${FQ}.sam ) &
done
wait
for BAM in *_bowtie2.sort.bam ; do samtools index $BAM & done
for BAM in *_bowtie2.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & done
wait
