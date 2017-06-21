#!/bin/bash -l
##########################################################
#
#       Chapter II - Iterative Mapping
#
#       Luis Arriola
#       Last Update: 13 June 2017
#               v.2
#
##########################################################

#Date Start
date

##ACAD1
#module load Bowtie2/2.2.9-foss-2016b seqtk/1.2-foss-2016a SAMtools/1.3.1-foss-2016a VCFtools/0.1.14-foss-2016a-Perl-5.22.1 BCFtools/1.3-foss-2016a

#PHOENIX
module load Bowtie2/2.2.9-GCC-5.3.0-binutils-2.25 \
seqtk/1.2-foss-2017a \
SAMtools/0.1.19-GCC-5.3.0-binutils-2.25 \
BCFtools/1.4.1-foss-2016b \
BCFtools/1.3.1-GCC-5.3.0-binutils-2.25

vcftools/0.1.12a-GCC-5.3.0-binutils-2.25

module list

# Usage:
for READSfile in *_RefAIter.fasta
      echo "Input File:       $READSfile"
      REFfile=${READSfile/_RefAIter.fasta/}_DeNovo_BWAmem_ConsensusREF.fasta
      echo "Reference File:   $REFfile"
      Iterations=$1
      echo "Iterations:       $Iterations"

      COUNTER=0
      while [ $COUNTER -lt $Iterations ]; do
        echo "Using Reference File: $REFfile"
        if [ -e $REFfile ]; then
          OUTDIR=iterativeMapping_cycles_$Iterations

          if [ -d OUTDIR ]; then
            echo "Output Directory already exists"
          else
            echo "Creating Output Directory: $OUTDIR"
            mkdir $OUTDIR
          fi
          SUBDIR=Cycle_`printf "%04d" $COUNTER`
          mkdir $OUTDIR/$SUBDIR
          mv $REFfile $OUTDIR
          # Indexation of the reference genomes
          bowtie2-build $OUTDIR/$REFfile $OUTDIR/$(basename "${REFfile/\.*/}")
        fi

        # Mapping (BWA aDNA)
        OUTNAME=Bowtie2_$(basename "${READSfile/\.fasta/}")_$COUNTER
        bowtie2 -p32 -f -x $OUTDIR/${REFfile/.fasta/} -U $READSfile -S $OUTDIR/${OUTNAME}.sam
        samtools view -uSh $OUTDIR/${OUTNAME}.sam \
        | samtools sort - $OUTDIR/${OUTNAME}\_sort

        # Call Consensus (MpileUp et al)
        MAPPED=$OUTDIR/$OUTNAME\_sort
        ## Consensus and  Fastq to Fasta
        samtools index $MAPPED.bam
        samtools mpileup -uf $OUTDIR/$REFfile $MAPPED.bam | bcftools view -cg - | vcfutils.pl vcf2fq | seqtk fq2fa - > $MAPPED\_consensus.fasta

        cp $MAPPED\_consensus.fasta ./REFfile_consensus_$COUNTER.fasta
        REFfile=REFfile_consensus_$COUNTER.fasta
      fi
      let COUNTER=COUNTER+1
  done
echo "Cleaning things up..."
rm REFfile_consensus_*
date
