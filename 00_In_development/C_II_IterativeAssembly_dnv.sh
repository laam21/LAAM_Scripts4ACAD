#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Iterative Mapping using MIRA(MITOBIM)
##  This script runs MIRA on a set of samples
##  The columns include:

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
#module list
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b

# 1 Format to fastq for mira
for FILE in *.fq.gz; do
 zcat $FILE | awk '{if ($1 ~ /^@M_*:*/ ) {print $1"_"NR-1} else{ print}}' > ${FILE/\.fq\.gz/}_FNR.fastq
done

# Collapsed reads mapping with mira
for FQZ in *_FNR.fastq; do
  ## Initial mapping assembly using MIRA 4
  # Create manifest.conf files
  echo -e "\n#Manifest file for basic mapping assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fastq/}_MappingAssembly\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=24 -NW:mrnl=0 -NW:cdrn=no -AS:nop=1 SOLEXA_SETTINGS -CO:msr=no\n\nreadgroup\nis_reference\ndata = /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/REFERENCE/SmutansUA159.fna\nstrain = Streptococcus_mutans_UA159\n\nreadgroup = reads\ndata = $FQZ\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/\.fastq/}_manifest.conf

  mira ${FQZ/\.fastq/}_manifest.conf
done

# Create Stat files:
# 1) SAM file from MAF
# 2) BAM file from SAM
#module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b
for FQZ in *_FNR.fastq; do
  miraconvert ${FQZ/\.fastq/}_MappingAssembly_assembly/${FQZ/\.fastq/}_MappingAssembly_d_results/${FQZ/\.fastq/}_MappingAssembly_out.maf ${FQZ/FNR\.fastq/}MAPPING_mira.sam
  wait
  samtools view -uSh ${FQZ/FNR\.fastq/}MAPPING_mira.sam | samtools sort - -o ${FQZ/FNR\.fastq/}MAPPING_mira.sort.bam
  wait
done

  # 3) index BAI; STATS; MQ30; MQ30.stats; MQ30.mask
  BED=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/MisincorporationData/SmUA159_RNAmaskChr.bed
  for BAM in *.sort.bam ; do samtools index $BAM & wait; done
  for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & wait; done
  for BAM in *.sort.bam; do samtools view -q30 -bh -F0x4 $BAM > $BAM.MQ30 & wait; done
  for BAM in *.sort.bam.MQ30; do samtools flagstat $BAM > $BAM.stats & wait; done
  for BAM in *sort.bam; do samtools view -q30 -bh -F0x4 $BAM | bedtools intersect -a /dev/stdin -b $BED -v > $BAM.MQ30.mask & wait; done




  ## Initial mapping assembly using MIRA 4 pair-end reads
  # Create manifest.conf files
#  echo -e "\n#Manifest file for basic mapping assembly (pair-end reads) with illumina data using MIRA 4\n\nproject = ${FQZ/\.fastq/}_MappingAssembly\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=36 -NW:mrnl=0 -AS:nop=1 SOLEXA_SETTINGS -CO:msr=no\n\nreadgroup\nis_reference\ndata = /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/REFERENCE/SmutansUA159.fna\nstrain = Streptococcus_mutans_UA159\n\nreadgroup = reads\ndata = ${FQZ/s1_ARnotcollapsed\.fastq/}s*_ARnotcollapsed.fastq\nautopairing\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/s1_ARnotcollapsed\.fastq/}ARnotcollapsed_manifest.conf




  ## Initial De Novo assembly using MIRA 4
  # Create manifest.conf files
#  echo -e "\n#Manifest file for de novo assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fq\.gz/}_DeNovoAssembly\n\njob=genome,denovo,accurate\n\nparameters = -GE:not=36

#  \n\nreadgroup\nis_reference\ndata = reference.fa\nstrain = Salpinus-mt-genome\n\nreadgroup = reads\ndata = reads.fastq\ntechnology = solexa\nstrain = testpool\n" > manifest.conf

 #./MITObim.pl -start 1 -end 5 -sample StrainX -ref reference-mt -readpool illumina_readpool.fastq -maf initial_assembly.maf
# ./MITObim.pl -end 10 -quick reference.fasta -sample StrainY -ref reference-mt -readpool illumina_readpool.fastq
