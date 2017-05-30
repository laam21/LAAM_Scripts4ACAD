#!/bin/bash

#### METHODS in Palaeomicrobiology
#### Luis Arriola

### DATASET Generation
##  Using Artificial FastqGenerator and the genome reference of S. mutans, we
##  generate 3 sets of artificial reads with different read size (50,75,150 bp).




##  Using EMBOSS msbar we add different levels of mutation to the datasets
##  creating files with 0,1,2,4,8,16,32 SNPs, insertions and deletions

#Script "mutate_reads.sh"
#@acad.ersa.edu.au:/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST

for FQ in /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/SIM_READS/*.1.fastq
do
 for COUNT in 1 2 4 8 16 32
 do

 BASE=`echo $FQ | sed 's/.fastq//'`

 cat ${FQ} \
 | msbar -sequence /dev/stdin -count $COUNT \
 -point 4 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}snp.fastq &

 cat ${FQ} \
 | msbar -sequence /dev/stdin -count $COUNT \
 -point 2 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}ins.fastq &

 cat ${FQ} \
 | msbar -sequence /dev/stdin -point 3 -count $COUNT \
 -block 0 -codon 0 -outseq /dev/stdout 2>/dev/null \
 | sed -n '/^>/!{H;$!b};s/$/ /;x;1b;s/\n//g;p' \
 | sed 's/ /\n/' | pigz > ${BASE}_${COUNT}del.fastq &

 wait
 done
done
