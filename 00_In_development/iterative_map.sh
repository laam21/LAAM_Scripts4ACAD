#!/bin/bash -l

##########################################################
#
#       Reiterative Mapping
#
#       Luis Arriola
#       Last Update: Mon 22nd June 2015
#               v.0.1.1
#
##########################################################
#
#
###  Requires:
#       -Modules:
#               -samtools
#               -seqtk
#               -bcftools
#               -vcfutils
#       -Reads (FQ)
#       -Reference sequence (FASTA)
#
###

# Input files and variable declaration
if [ $# == 0 ]; then
        echo    "       Usage: iterative_map.sh <REFfile> <READSfile> <iterations>
                REFfile: Initial Reference file (FASTA)
                READSfile: File containing the reads (FASTQ.GZ)
                Iterations: Number of iterative cycles"
else
        REFfile=$1
                echo "Reference File:           $REFfile"
        READSfile=$2
                echo "Input File:               $READSfile"
        Iterations=$3
                echo "Iterationss:              $Iterations"

        # Loading Modules
        module load bwa tabix vcftools
        module list
        date
        # Full path to the folder where the FilterUniqueSAMCons.py program is, e.g. "/Users/julien/bin/FilterUniqueSAMCons.py"
        FILTER_PATH="/home/users/larriola/bin/"

        COUNTER=0
        while [ $COUNTER -lt $Iterations ] ; do
                echo "Using Reference File: $REFfile"
                if [ -e $REFfile ]; then
                        OUTDIR=BWAmapping_$Iterations
                        if [ -d $OUTDIR ]; then
                                echo "Output Directory exist already"
                        else
                                echo "Creating Output Directory: $OUTDIR"
                                mkdir $OUTDIR
                        fi
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

                        # Mapping (BWA)
                        OUTNAME=$(basename "${REFfile/\.*/}")_$(basename "${READSfile/\.fastq\.gz/}")_$COUNTER
                        bwa aln -t 16 -l 1024 -n 0.01 -o 2 $REFfile $READSfile > $OUTDIR/$OUTNAME.sai
                        bwa samse $REFfile $OUTDIR/$OUTNAME.sai $READSfile | samtools view -bSh -F0x4 -> $OUTDIR/$OUTNAME.bam
                        ## Quality filter
                        samtools view -q 30 -bh $OUTDIR/$OUTNAME.bam > $OUTDIR/$OUTNAME\_QualMap30.bam
                        samtools sort $OUTDIR/$OUTNAME\_QualMap30.bam $OUTDIR/$OUTNAME\_QualMap30_Sort
                        samtools view -h $OUTDIR/$OUTNAME\_QualMap30_Sort.bam | $FILTER_PATH/FilterUniqueSAMCons.py | samtools view -Sbh -> $OUTDIR/$OUTNAME\_QualMap30_Sort_Uniq.bam

                        # Call Consensus (MpileUp et al)
                        MAPPED=$OUTDIR/$OUTNAME\_QualMap30_Sort_Uniq
                        ## Consensus and  Fastq to Fasta
                        samtools index $MAPPED.bam
                        samtools mpileup -uf $REFfile $MAPPED.bam | bcftools view -cg - | vcfutils.pl vcf2fq | seqtk fq2fa - > $MAPPED\_consensus.fasta
                        #awk 'BEGIN{P=1}{if(P==1||P==2){gsub(/^[@]/,">");print}; if(P==4)P=0; P++}' $MAPPED\_consensus.vcf > $MAPPED\_consensus.fasta

                        cp $MAPPED\_consensus.fasta ./REFfile_consensus_$COUNTER.fasta
                        REFfile=REFfile_consensus_$COUNTER.fasta
                 fi
        let COUNTER=COUNTER+1
        done
date
fi