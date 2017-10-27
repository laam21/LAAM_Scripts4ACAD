#!/bin/bash -l
####  CHAPTER_2
####  Consensus calling
#### Luis Arriola

module load SAMtools/1.3.1-foss-2016b BCFtools/1.3.1-foss-2016b HTSlib/1.3.1-foss-2016b picard/2.1.1-Java-1.8.0_101 seqtk
REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/SmutansUA159.fasta

#Consensus Calling for Reference mapping assembly and Reference guided de novo assembly
for BAM in MUTATEDLOW1_90C10E*.bam MUTATEDLOW1_90C10E*.bam.MQ30 *.bam.MQ30.mask; do
  #Remove Duplicates
  java -jar ${EBROOTPICARD}/picard.jar MarkDuplicates I=$BAM O=${BAM/\.bam/}.RMDUP.bam AS=TRUE M=/dev/null REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
  samtools index ${BAM/\.bam/}.RMDUP.bam
  samtools mpileup -uf $REF ${BAM/\.bam/}.RMDUP.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq | seqtk seq -A - > ${BAM/\.bam/}.RMDUP_consensus.fasta
  cat ${BAM/\.bam/}.RMDUP_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}.RMDUP_consensus_contigs.fa
done

#Consensus Calling for Iterative Mapping
#module load seqtk
for DIR in *FNR_ITERATIVEASSEMBLY_*; do
  FASTA=$DIR/iteration*/*_noIUPAC.fasta
  if [ -e $FASTA ]; then
  #  cat $DIR/iteration*/*_noIUPAC.fasta | seqtk cutN -n 5 - > ${DIR}_consensus_contigs.fa
    cp $DIR/iteration*/*_noIUPAC.fasta ../${DIR/FNR_ITERATIVEASSEMBLY_/}ITERMAP_mbim_consensus.fasta
  fi
done

#for FASTQ in *.fastq; do
#  ${BAM/\.bam/}.RMDUP_consensus.fastq | seqtk seq -A - > ${BAM/\.bam/}.RMDUP_consensus.fa
#  cat $FASTA | seqtk cutN -n 5 - > ${FASTA/\.fasta/}_contigs.fa
#done
#MUTATEDNONE0*.bam.MQ30 MUTATEDNONE0*.bam.MQ30.mask MUTATEDNONE0


for BAM in MUTATEDLOW1_0C100E*.bam.MQ30 ; do
  #Remove Duplicates
  java -jar ${EBROOTPICARD}/picard.jar MarkDuplicates I=$BAM O=${BAM/\.bam/}.RMDUP.bam AS=TRUE M=/dev/null REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
  samtools index ${BAM/\.bam/}.RMDUP.bam
  samtools mpileup -uf $REF ${BAM/\.bam/}.RMDUP.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq >${BAM/\.bam/}.RMDUP_consensus.fastq
  seqtk seq -A ${BAM/\.bam/}.RMDUP_consensus.fastq > ${BAM/\.bam/}.RMDUP_consensus.fasta
  cat ${BAM/\.bam/}.RMDUP_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}.RMDUP_consensus_contigs.fa &
done

#Remove duplicates and consensus calling mira mapping
for BAM in *mira.sort.bam *mira.sort.bam.MQ30 *mira.sort.bam.MQ30.mask; do
  #Remove Duplicates
  java -jar ${EBROOTPICARD}/picard.jar MarkDuplicates I=$BAM O=${BAM/\.bam/}.RMDUP.bam AS=TRUE M=/dev/null REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
  samtools index ${BAM/\.bam/}.RMDUP.bam
  samtools mpileup -uf $REF ${BAM/\.bam/}.RMDUP.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq | seqtk seq -A - > ${BAM/\.bam/}.RMDUP_consensus.fasta
  cat ${BAM/\.bam/}.RMDUP_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}.RMDUP_consensus_contigs.fa
done


for BAM in *mira.sort.bam.MQ30 ; do
  #Remove Duplicates
  java -jar ${EBROOTPICARD}/picard.jar MarkDuplicates I=$BAM O=${BAM/\.bam/}.RMDUP.bam AS=TRUE M=/dev/null REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
  samtools index ${BAM/\.bam/}.RMDUP.bam
  samtools mpileup -uf $REF ${BAM/\.bam/}.RMDUP.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq | seqtk seq -A - > ${BAM/\.bam/}.RMDUP_consensus.fasta
  cat ${BAM/\.bam/}.RMDUP_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}.RMDUP_consensus_contigs.fa
done


#for BAM in MUTATEDLOW1_0C100E*.bam.MQ30; do
#  samtools index $BAM
#  samtools mpileup -uf $REF $BAM | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq >${BAM/\.bam/}_consensus.fastq
#  seqtk seq -A ${BAM/\.bam/}_consensus.fastq > ${BAM/\.bam/}_consensus.fasta
#  cat ${BAM/\.bam/}_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}_consensus_contigs.fa &
#done
