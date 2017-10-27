#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Iterative Mapping using MIRA(MITOBIM)
##  This script runs MIRA on a set of samples and maps the reads to a reference to create a "SEED template"
##  then, using MITOBIM, it performs a iterative mapping analysis

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b
#module list

# I.- Format to fastq for mira (duplicated headers cause problems and it need the posfix fastq)
for FILE in *.fq.gz; do
 zcat $FILE | awk '{if ($1 ~ /^@M_*:*/ ) {print $1"_"NR-1} else{ print}}' > ${FILE/\.fq\.gz/}_FNR.fastq
done

# II.- Collapsed reads mapping with mira
## Initial mapping assembly using MIRA 4
for FQZ in *_FNR.fastq; do
  # Create manifest.conf files
  echo -e "\n#Manifest file for basic mapping assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fastq/}_MappingAssembly\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=24 -NW:mrnl=0 -NW:cdrn=no -AS:nop=1 SOLEXA_SETTINGS -CO:msr=no\n\nreadgroup\nis_reference\ndata = /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/REFERENCE/SmutansUA159.fna\nstrain = Streptococcus_mutans_UA159\n\nreadgroup = reads\ndata = $FQZ\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/\.fastq/}_manifest.conf

  mira ${FQZ/\.fastq/}_manifest.conf
done

###########################################  THIS SECTION IS FOR THE MAPPING ANALYSIS OF MIRA ################################
# II.1 Create Stat files:
# 1) SAM file from MAF
# 2) BAM file from SAM
#module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b
for FQZ in *_FNR.fastq; do
  miraconvert ${FQZ/\.fastq/}_MappingAssembly_assembly/${FQZ/\.fastq/}_MappingAssembly_d_results/${FQZ/\.fastq/}_MappingAssembly_out.maf ${FQZ/FNR\.fastq/}MAPPING_mira.sam
  wait
  samtools view -uSh ${FQZ/FNR\.fastq/}MAPPING_mira.sam | samtools sort - -o ${FQZ/FNR\.fastq/}MAPPING_mira.sort.bam
  wait
done
#############################################################################################################################
# III.1 Baiting and iterative mapping using the MITOBIM.pl script
for FQZ in *_FNR.fastq; do
  /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Software/MITObim/MITObim.pl -start 1 -end 20 -sample testpool -ref Streptococcus_mutans_UA159 -readpool $FQZ -maf ${FQZ/\.fastq/}_MappingAssembly_assembly/${FQZ/\.fastq/}_MappingAssembly_d_results/${FQZ/\.fastq/}_MappingAssembly_out.maf &> ${FQZ/\.fastq/}.log
  wait
  mkdir ${FQZ/\.fastq/}_ITERATIVEASSEMBLY
  mv iteration* ${FQZ/\.fastq/}_ITERATIVEASSEMBLY
done

###########################################  THIS SECTION IS FOR THE CREATION OF STAT FILES from BAMS #########################
# 3) index BAI; STATS; MQ30; MQ30.stats; MQ30.mask
  BED=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/MisincorporationData/SmUA159_RNAmaskChr.bed
  for BAM in *.sort.bam ; do samtools index $BAM & wait; done
  for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & wait; done
  for BAM in *.sort.bam; do samtools view -q30 -bh -F0x4 $BAM > $BAM.MQ30 & wait; done
  for BAM in *.sort.bam.MQ30; do samtools flagstat $BAM > ${BAM}stats & wait; done
  for BAM in *sort.bam; do samtools view -q30 -bh -F0x4 $BAM | bedtools intersect -a /dev/stdin -b $BED -v > $BAM.MQ30.mask & wait; done
