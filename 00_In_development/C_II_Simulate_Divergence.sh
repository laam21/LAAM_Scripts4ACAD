#!/bin/bash
##########################################################
#
#       Chapter II - Genomic Divergence Simulation
#
#       Luis Arriola
#       Last Update: 14 August 2017
#               v.0
#
##########################################################

FQ=$1
for COUNT in 1120 3790 6092 60928
do
  BASE=`basename $FQ`
  echo $COUNT
  msbar -sequence $FQ -count $COUNT -point 1 -block 1 -codon 1 -outseq /dev/stdout | pigz > ${BASE}_${COUNT}.fasta.gz

  wait
done
