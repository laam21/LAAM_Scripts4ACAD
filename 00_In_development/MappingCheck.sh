#!/bin/bash -l
##########################################################
#
#       Chapter II - Mapping Check
#
#       Luis Arriola
#       Last Update: 19 June 2017
#               v.0
#
##########################################################
#
# This script checks how many reads were mapped within the correct slidding window

#Produce BEDfiles from BAMs
#bedtools bamtobed -i SIM_150.DAMAGED.0_bwapssm.sort.bam | head
#bedtools bamtobed -i SIM_150.DAMAGED.0_bwapssm.sort.QM0.bam | join -1 4 -2 4 /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/SMUTANS_MAPPING_TEST/1_Input_Datasets/SMUT_GENOME/0_AllDatasets/Ground_Truth/SIM_150.readStartIndexes_COORD_HEADER.bed /dev/stdin
#Join file with original coordinates  with the mappedReads Bedfiles  and calculate
join -1 4 -2 4 file1 file2 |awk '
BEGIN{
  print "HEADER\tChrOri\tStOri\tEndOri\tChrMap\tStMap\tEndMap\tStrand\tMAP";
  TrueCount=0;
  FalseCount=0;
}
{
  if((($3-1) <= $6) && (($4-1)>=$7)){
    TrueCount++;
    print $0"\tTRUE\t"$3-1-$6"\t"$4-1-$7;
  }else{
    FalseCount++;
    print $0"\tFALSE\t"$3-1-$6"\t"$4-1-$7;
  }
}
END{
  print TrueCount"\t"FalseCount
} '
