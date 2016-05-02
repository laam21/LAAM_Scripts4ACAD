#!/bin/bash

############################################################
#
# NGS analytical pipeline
#
# B. LLAMAS - J. SOUBRIER - October 2013
# Modified by B. LLAMAS - April 2014
# Modified by L. ARRIOLA - April 2016
#
#////////////////////\\\\\\\\\\\\\\\\\\\\
# STEP 1 - Barcode demultiplexing with Sabre
#\\\\\\\\\\\\\\\\\\\\////////////////////
#
############################################################

### Need
# fastq.gz files in ./Data folder
# pigz (parallel gzip for mac)
# sabre
# barcodes.txt  :       list of all barcodes used for the run and the barcodes (tab separated: BarcodeName      ATCCGTC), in ./Data

#####USER INPUT######
#PATH_SABRE='/Users/bastien/bin_app/sabre-master'
module load sabre
module list

if [ -f Data/barcodes_R1* ]; then # If there is a left barcode file

        if [ -d 1_Barcode_sabre ]; then # If Barcode folder exists, go in, if not, make one and go in
                cd 1_Barcode_sabre
        else
                mkdir 1_Barcode_sabre
                cd 1_Barcode_sabre
        fi

        echo -e "\nBarcode demultiplexing in process..."

        for BC_R1 in ../Data/barcodes_R1.txt; do # Loop on barcode files for R1 reads
                for R1FQGZ in ../Data/*R1*.fastq.gz; do # Loop on fastq files
                       sabre pe -f <(unpigz -c $R1FQGZ) -r <(unpigz -c ${R1FQGZ/R1/R2}) -b $BC_R1 -u unknown_rBCR1.fastq -w unknown_rBCR2.fastq > Report_$(basename "${BC_R1/\.txt/}")_$(basename "${R1FQGZ/\.fastq.gz/.txt}")
                       pigz *.fastq
                done
        done
        for R2FQGZ in *_R2*.fastq.gz; do
                lBC=`echo $(basename "$R2FQGZ") | cut -d "_" -f 1`
                for BC_R2 in ../Data/barcodes_R2_$lBC.txt; do
                       sabre pe -f <(unpigz -c $R2FQGZ) -r <(unpigz -c ${R2FQGZ/R2/R1}) -b $BC_R2 -u unknown_rBCR2_$lBC.fastq -w unknown_rBCR1_$lBC.fastq > Report_$(basename "${BC_R2/\.txt/}")_$(basename "${R2FQGZ/\.fastq\.gz/.txt}")
                done
                rm $rBC*
        done
        pigz *.fastq
fi