#!/bin/bash -l
##########################################################
#
#       Chapter II - Mapping Check
#
#       Luis Arriola
#       Last Update: 19 June 2017
#               v.0.1
#
##########################################################
#
# This script checks how many reads were mapped within the correct slidding window
### sort -k4,4 SIM_50.readStartIndexes_COORD_HEADER.bed >  SIM_50.readStartIndexes_COORD_HEADER.SORT4.bed

#Produce BEDfiles from BAMs
for MQUAL in 0 5 10 15 20 25 30 35 40 ; do \
samtools view -q $MQUAL -bh -F0x4 SIM_150.DAMAGED.0_bwapssm.sort.bam \
| bedtools bamtobed -i /dev/stdin \
| sort -k4,4 \
| join -1 4 -2 4 SIM_150.readStartIndexes_COORD_HEADER.SORT4.bed /dev/stdin | awk -v MQ=$MQUAL '
BEGIN{
  TrueCount=0;
  FalseCount=0;
}
{
  if((($3-1) <= $6) && (($4-1)>=$7)){
    TrueCount++;
  }else{
    FalseCount++;
  }
}
END{
  print MQ"\t"TrueCount"\t"FalseCount
} ' ; done
