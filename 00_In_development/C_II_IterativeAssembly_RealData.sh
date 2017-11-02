#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Iterative Mapping using MIRA(MITOBIM)
##  This script runs MIRA on a set of samples
##  --REAL-DATA-TEST

for FQZ in *.fastq; do
  for REF in RefSeqs/*.fna; do
    ## Initial mapping assembly using MIRA 4
    # Create manifest.conf files
    echo -e "\n#Manifest file for basic mapping assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=24 -NW:mrnl=0 -NW:cdrn=no -AS:nop=1 SOLEXA_SETTINGS -CO:msr=no\n\nreadgroup\nis_reference\ndata = ${REF}\nstrain = $(basename ${REF/\.fna/})\n\nreadgroup = reads\ndata = $FQZ\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_manifest.conf

    mira ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_manifest.conf
  done
done

#############################################################################################################################
# III.1 Baiting and iterative mapping using the MITOBIM.pl script
MM=3
for FQZ in *.fastq; do
  for REF in RefSeqs/*.fna; do
    echo -e "Sample ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_assembly \n$MM "
    /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Software/MITObim/MITObim.pl -start 1 -end 50 -sample testpool -ref ${REF} -readpool $FQZ -maf ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_assembly/${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_d_results/${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_out.maf --mismatch $MM --clean &> ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_${MM}.log
    wait
    mkdir ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_ITERMAP_mbim${MM}
    mv iteration* ${FQZ/\.fastq/}_$(basename ${REF/\.fna/})_ITERMAP_mbim${MM}
  done
done
