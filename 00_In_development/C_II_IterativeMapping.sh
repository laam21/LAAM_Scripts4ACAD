#!/bin/bash -l
##########################################################
#
#       Chapter II - Iterative Mapping
#
#       Luis Arriola
#       Last Update: 14 February 2017
#               v.0
#
##########################################################

#Loading Modules
module load tabix vcftools bwa
module list
date

# Usage:
if [ $# == 0 ]; then
  echo "  Usage: C_II_IterativeMapping.sh
          REFfile: Initial Reference file (FASTA)
          READSfile: File containing the reads (FASTQ.GZ)
          Iterations: Number of iterative cycles"

else
  REFfile=$1
      echo "Reference File:   $REFfile"
  READSfile=$2
      echo "Input File:       $READSfile"
 Iterations=$3
      echo "Iterations:       $Iterations"

#  #Full path to folder containing FilterUniqueSAMCons.py program
  FILTER_PATH="/home/users/larriola/bin/"

  COUNTER=0
  while [ $COUNTER -lt $Iterations ]; do
      echo "Using Reference File: $REFfile"
      if [ -e $REFfile ]; then
        OUTDIR=IterativMapping_cycles_$Iterations
        if [ -d OUTDIR ]; then
          echo "Output Directory already exists"
        else
          echo "Creating Output Directory: $OUTDIR"
          mkdir $OUTDIR
        fi
        SUBDIR=Cycle_`printf "%04d" $COUNTER`
        mkdir $OUTDIR/$SUBDIR

        # Indexation of the reference genomes
        REFfileSize=$(ls -l $REFfile | awk '{ print $5}')
        if [ -f $REFfile.amb ]; then
                echo -e "\n##### Reference already indexed #####\n"
        else
        ## Indexing algorithmcd /loc
                if [ $REFfileSize -lt 2000000000 ]; then
                        bwa index -a is $REFfile #short genome
                else
                        bwa index -a bwtsw $REFfile #large genome
                fi
        fi

        # Mapping (BWA aDNA)
        OUTNAME=BWAaDNA_$(basename "${REFfile/\.*/}")_$(basename "${READSfile/\.fastq\.gz/}")_$COUNTER
        bwa aln -t 16 -l 1024 -n 0.01 -o 2 $REFfile $READSfile | bwa samse $REFfile - $READSfile \
        | samtools view -uSh - \
        | samtools view -q 30 -bh - \
        | samtools sort - $OUTDIR/$SUBDIR/$OUTNAME\_QualMap30_Sort

        samtools view -h $OUTDIR/$SUBDIR/$OUTNAME\_QualMap30_Sort.bam | $FILTER_PATH/FilterUniqueSAMCons.py | samtools view -Sbh -> $OUTDIR/$SUBDIR/$OUTNAME\_QualMap30_Sort_Uniq.bam

        # Call Consensus (MpileUp et al)
        MAPPED=$OUTDIR/$SUBDIR/$OUTNAME\_QualMap30_Sort_Uniq
        ## Consensus and  Fastq to Fasta
        samtools index $MAPPED.bam | samtools mpileup -uf $REFfile - | bcftools view -cg - | vcfutils.pl vcf2fq | seqtk fq2fa - > $MAPPED\_consensus.fasta

        cp $MAPPED\_consensus.fasta ./REFfile_consensus_$COUNTER.fasta
        REFfile=REFfile_consensus_$COUNTER.fasta
      fi
      let COUNTER=COUNTER+1
  done
date
fi
