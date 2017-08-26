#!/bin/bash

##########################################################
#
#       Chapter II - Adapter Removal Merged/Not Merged
#
#       Luis Arriola
#       Last Update: 14 August 2017
#               v.0
#
##########################################################

### Need
# fastq.gz files either in 1_Barcode_sabre/ (if applicable) or ./Data folder
# adapters.txt file in ./Data folder with list of adapters, first line = 5' - second line = 3'RC
# pigz (parallel gzip for mac)
# FastQC
# Cutadapt installed
# Check following parameters:


##### USER INPUT #####
MM="0.1" # default is 0.33 for SE data and 0.1 for PE data
MINLENGTH="25" # default is 15 nt
MINQUAL="4" # default is 2
OVERLAP="11" # Only in PE mode. Default is 11 nt

#module load gnu/4.9.2 \
#fastQC/0.11.2 \
#AdapterRemoval \
#module list
#adptSim  -f AGATCGGAAGAGCACACGTCTGAACTCCAGTCACCGATTCGATCTCGTATGCCGTCTTCTGCTTG  -s AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATTT


#path on cluster of AdapterRemoval
#ARPATH="/opt/local"
#path on local machine
AdapterRemoval --version

for FQGZ in *_s1.fq.gz; do # Loop on fastq files
  echo  "AdapterRemoval --file1 <(unpigz -p 1 -c $FQGZ) --file2 <(unpigz -p 1 -c ${FQGZ/s1/s2}) --collapse --trimns --trimqualities --minlength $MINLENGTH --qualitybase 33 --minquality $MINQUAL --minalignmentlength $OVERLAP --mm $MM --output1 ${FQGZ/_s1*/_s1_ARtruncated.fq.gz} --output2 ${FQGZ/_s1*/_s2_ARtruncated.fq.gz} --outputcollapsed ${FQGZ/_s1*/_ARcollapsed.fq.gz} --outputcollapsedtruncated ${FQGZ/_s1*/_ARcollapsedtruncated.fq.gz} --gzip "

  AdapterRemoval --file1 $FQGZ --file2 ${FQGZ/s1/s2} --collapse --trimns --trimqualities --minlength $MINLENGTH --qualitybase 33 --minquality $MINQUAL --minalignmentlength $OVERLAP --mm $MM --output1 ${FQGZ/_s1*/_s1_ARtruncated.fq.gz} --output2 ${FQGZ/_s1*/_s2_ARtruncated.fq.gz} --outputcollapsed ${FQGZ/_s1*/_ARcollapsed.fq.gz} --outputcollapsedtruncated ${FQGZ/_s1*/_ARcollapsedtruncated.fq.gz} --gzip

  AdapterRemoval --file1 $FQGZ --file2 ${FQGZ/s1/s2} --trimns --trimqualities --minlength $MINLENGTH --qualitybase 33 --minquality $MINQUAL --mm $MM --output1 ${FQGZ/_s1*/_s1_ARnotcollapsed.fq.gz} --output2 ${FQGZ/_s1*/_s2_ARnotcollapsed.fq.gz} --gzip

done
