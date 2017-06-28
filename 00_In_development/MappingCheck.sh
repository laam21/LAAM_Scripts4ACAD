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
for BAM in *.bam ; do
  if [ $(echo $BAM | cut -d"." -f1 | cut -d"_" -f2) == 50 ]; then
    REF="SIM_50.readStartIndexes_COORD_HEADER.SORT4.bed";
  elif [ $(echo $BAM | cut -d"." -f1 | cut -d"_" -f2) == 75 ]; then
    REF="SIM_75.readStartIndexes_COORD_HEADER.SORT4.bed";
  else
    REF="SIM_150.readStartIndexes_COORD_HEADER.SORT4.bed";
  fi;

  for MQUAL in 0 5 10 15 20 25 30 35 40 ; do
    samtools view -q $MQUAL -bh -F0x4 $BAM \
    | bedtools bamtobed -i /dev/stdin \
    | sort -k4,4 \
    | sed -E s/\\/1// \
    | join -1 4 -2 4 $REF /dev/stdin \
    | awk -v MQ=$MQUAL -v FILE=$BAM '
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
          print FILE"\t"MQ"\t"TrueCount"\t"FalseCount"\t"TrueCount+FalseCount"\t"
        } ';
    done
done > MappingCheck_OutputTable.txt
