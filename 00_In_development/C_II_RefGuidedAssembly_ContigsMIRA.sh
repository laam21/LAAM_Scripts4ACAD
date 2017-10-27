#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

# This scripts maps contigs with mira (reference guided)

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b
#module list

for FQZ in *.fa; do
  # Create manifest.conf files
  echo -e "\n#Manifest file for basic mapping assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fa/}_MappingAssembly\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=24 -NW:mrnl=0 -NW:cdrn=no -AS:nop=1 SOLEXA_SETTINGS -CO:msr=no -AS:epoq=no\n\nreadgroup\nis_reference\ndata = /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/REFERENCE/SmutansUA159.fna\nstrain = Streptococcus_mutans_UA159\n\nreadgroup = reads\ndata = $FQZ\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/\.fa/}_manifest.conf

  mira ${FQZ/\.fa/}_manifest.conf
done

## Mira convert MAF-> SAM -> BAM
for FQZ in *.fa; do
  miraconvert ${FQZ/\.fa/}_MappingAssembly_assembly/${FQZ/\.fa/}_MappingAssembly_d_results/${FQZ/\.fa/}_MappingAssembly_out.maf ${FQZ/\.fa/}REFGUIDED_mira.sam
  wait
  samtools view -uSh ${FQZ/\.fa/}REFGUIDED_mira.sam | samtools sort - -o ${FQZ/\.fa/}REFGUIDED_mira.sort.bam
  wait
done

# 3) index BAI; STATS; MQ30; MQ30.stats; MQ30.mask
  BED=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/MisincorporationData/SmUA159_RNAmaskChr.bed
  for BAM in *.sort.bam ; do samtools index $BAM & wait; done
  for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & wait; done
  for BAM in *.sort.bam; do samtools view -q30 -bh -F0x4 $BAM > $BAM.MQ30 & wait; done
  for BAM in *.sort.bam.MQ30; do samtools flagstat $BAM > ${BAM}stats & wait; done
  for BAM in *sort.bam; do samtools view -q30 -bh -F0x4 $BAM | bedtools intersect -a /dev/stdin -b $BED -v > $BAM.MQ30.mask & wait; done
