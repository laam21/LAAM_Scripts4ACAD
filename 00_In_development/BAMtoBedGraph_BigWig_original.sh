#!/bin/bash

CHROMSIZE='/Users/Annarielh/Desktop/04_Workshops-Courses-Conferences/J-Circos/Data/Sm.chrom.sizes'

for BAM in *.bam;
	do
	ROOT=$(basename "${BAM/\.*/}")
	
	bedtools bamtobed -i $BAM > $ROOT.bed
	
	sort -k1,1 $ROOT.bed > $ROOT.sorted
	
	cat $ROOT.sorted | sed 's/gi|347750429|ref|NC_004350.2|/NC_004350.2/g' > $ROOT.sorted_mod
	
	genomeCoverageBed -bga -i $ROOT.sorted_mod -g $CHROMSIZE > $ROOT.bedGraph
	
	bedGraphToBigWig $ROOT.bedGraph $CHROMSIZE $ROOT.bw
	
	done
	
rm *.sorted *.sorted_mod 

