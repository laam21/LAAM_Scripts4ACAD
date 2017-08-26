#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Summary_stats for Whole genome analyses
##  This script creates a table with all the summary information per dataset.
##  The columns include:

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b
module list

#echo -ne "Method\tDivergence\tType\tDeamination\tMapper\tTotalReads\tMappedReads\t%MappedReads\tCoverage\tDepthCov\n">>Summaries.txt;
#echo -ne "Divergence\tContamination\tDeamination\tTypeReads\tMethod\tTool\tTotalReads\tMappedReads\tPercMappedReads\tMQ30MappedReads\tMQ30Endogenous\tMQ30Coverage\tMQ30DepthCov\tMQ30EndoCorrect\tMQ30EndoWrong\tMQ30EndoCorrectNWrong\n">>Summaries.txt;
echo -ne "Divergence\tContamination\tDeamination\tTypeReads\tMethod\tTool\tTotalReads\tMappedReads\tPercMappedReads\tMQ30MappedReads\tMQ30Endogenous\tMQ30Coverage\tMQ30DepthCov\tTotalEndogenous\n">>Summaries.txt;
for FILE in *.bam; do
  Col1=$(echo $FILE | cut -d"_" -f1); #Divergence
  Col2=$(echo $FILE | cut -d"_" -f2); #ContaminationLevel
  Col3=$(echo $FILE | cut -d"_" -f3); #DeaminationLevel
  Col4=$(echo $FILE | cut -d"_" -f4); #TypeReads
  Col5=$(echo $FILE | cut -d"_" -f5); #Method
  Col6=$(echo $FILE | cut -d"_" -f6 | cut -d"." -f1) #Tool (Mapper)
  Col7=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1); #TotalReads
  Col8=$(head $FILE.stats | grep "mapped (" | cut -d"+" -f1); #MappedReads
  Col9=$(head $FILE.stats | grep "mapped (" | cut -d"(" -f2 | cut -d"%" -f1); #PercentMappedReads
  Col10=$(head $FILE.MQ30stats | grep "mapped (" | cut -d"+" -f1); #MQ30MappedReads
  Col11=$(samtools view $FILE.MQ30 | grep -c "GCA_000007465.2:Chromosome:1:2032925"); #MQ30Endogenous
  Col12=$(samtools depth $FILE.MQ30 | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum)}'); #MQ30Coverage
  Col13=$(samtools depth $FILE.MQ30 | awk '{sum+=$3} END { if ( NR>0 ) {print (sum/NR)} else {print 0}}');#MQ30DepthCov
  Col14=$(samtools view $FILE | grep -c "GCA_000007465.2:Chromosome:1:2032925"); #TotalEndogenous
  Col15=$(samtools view $FILE.MQ30.mask | grep -c "GCA_000007465.2:Chromosome:1:2032925"); #MQ30EndogenousReadsMasked
  #Col15=$(samtools view -bh $FILE.MQ30 | bedtools bamtobed -i /dev/stdin | awk '{print $2":"$3":"$4}' | awk -F ":" 'BEGIN{TrueCount=0;FalseCount=0;}{if(($1 <= $10) && ($2 >= $11)){TrueCount++;}else{FalseCount++;}}END{print TrueCount"\t"FalseCount"\t"TrueCount+FalseCount}'); #MQ30EndoCorrect MQ30EndoWrong MQ30EndoCorrectNWrong
  #echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10\t$Col11\t$Col12\t$Col13\t$Col14\t$Col15" >>Summaries.txt;
  echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10\t$Col11\t$Col12\t$Col13\t$Col14\t$Col15\t$Col16" >>Summaries.txt;
done
