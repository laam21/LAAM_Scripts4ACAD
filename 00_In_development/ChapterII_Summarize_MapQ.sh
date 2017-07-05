#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Summary_stats
##  This script creates a table with all the summary information per dataset.
##  The columns include Mapping Quality filter

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
#module list

echo -ne "Filename\tFragmentSize\tType\tMutationNum\tMutationType\tMapper\tTotalReads\tMappedReads\tPercMappedReads\tCoverage\tDepthCov\tMapQ\tTrueMap\tFalseMap\tTotalMapFilt\n">>MappingSummaries_MapQ_outputTable.txt;
for FILE in *.bam; do Col1=$(echo `basename $FILE .sort.bam`); #Filename
  Col2=$(echo $FILE | cut -d"." -f1 | cut -d"_" -f2); #FragmentSize
  Col3=$(echo $FILE | cut -d"." -f2); #Type
  Col4=$(echo $FILE | cut -d"." -f3 | cut -d"_" -f1); #MutationNumber
  Col4_1=$(echo $FILE | cut -d"." -f3 | cut -d"_" -f2); #MutationType
  Col5=$(echo $FILE | cut -d"." -f3 | cut -d"_" -f3); #Mapper
  Col6=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1); #TotalReads
  Col7=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1); #MappedReads
  Col8=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d"%" -f1); #PercentMappedReads
  Col9=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum/2032925)*100}'); #Coverage
  Col10=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print (sum/NR)} else {print 0}}');#DepthCov

  SUMMARY=`echo "$Col1\t$Col2\t$Col3\t$Col4\t$Col4_1\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10"`

  if [ $Col2 == 50 ]; then
    REF="SIM_50.readStartIndexes_COORD_HEADER.SORT4.bed";
  elif [ $Col2 == 75 ]; then
    REF="SIM_75.readStartIndexes_COORD_HEADER.SORT4.bed";
  else
    REF="SIM_150.readStartIndexes_COORD_HEADER.SORT4.bed";
  fi;

  for MQUAL in 0 5 10 15 20 25 30 35 40 ; do
    samtools view -q $MQUAL -bh -F0x4 $FILE \
    | bedtools bamtobed -i /dev/stdin \
    | sort -k4,4 \
    | sed -E s/\\/1// \
    | join -1 4 -2 4 $REF /dev/stdin \
    | awk -v MQ=$MQUAL -v SUMMARY=$SUMMARY '
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
          print SUMMARY"\t"MQ"\t"TrueCount"\t"FalseCount"\t"TrueCount+FalseCount"\t"
        } ';
    done
done >> MappingSummaries_MapQ_outputTable.txt
