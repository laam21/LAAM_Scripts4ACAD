#!/bin/bash

if [ $# == 0 ]; then
		echo "Usage: BAMtoBedGraph_BigWig.sh <CHROMSIZE_File> <BAM_Directory> 
			CHROMSIZE_File:	File with the chromosome sizes for JCircos (e.g. Sm.chrom.sizes)
			BAM_Directory:	Directory that contains the BAM files"
	
else
	CHROMSIZE=$1
	DIR=$2
	cd $DIR
	
	for BAM in *.bam;
		do
		ROOT=$(basename "${BAM/\.*/}")
	
		bedtools bamtobed -i $BAM > $ROOT.bed
		sort -k1,1 $ROOT.bed > $ROOT.sorted
	
	#	cat $ROOT.sorted | sed 's/gi|347750429|ref|NC_004350.2|/NC_004350.2/g' > $ROOT.sorted_mod
	
		genomeCoverageBed -bga -i $ROOT.sorted_mod -g $CHROMSIZE > $ROOT.bedGraph
	
		bedGraphToBigWig $ROOT.bedGraph $CHROMSIZE $ROOT.bw
	
		done
	
	rm *.sorted *.sorted_mod 

fi
