#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Summary_stats for Whole genome analyses
##  This script creates a table with all the summary information per dataset.
##  The columns include:

### Modules
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
#module list

echo -ne "Method\tDivergence\tType\tDeamination\tMapper\tTotalReads\tMappedReads\t%MappedReads\tCoverage\tDepthCov\n">>Summaries.txt;
for FILE in *.bam; do Col1=$(echo "$FILE" | cut -d"_" -f1); #Method
  Col2=$(echo "$FILE" | cut -d"_" -f2); #Divergence
  Col3=$(echo "$FILE" | cut -d"_" -f3); #Type
  Col4=$(echo "$FILE" | cut -d"_" -f4); #Deamination
  Col5=$(echo "$FILE" | cut -d"_" -f5 | cut -d"." -f1); #Mapper
  Col6=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1); #TotalReads
  Col7=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1); #MappedReads
  Col8=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d":" -f1); #PercentMappedReads
  Col9=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum)}'); #Coverage
  Col10=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print (sum/NR)} else {print 0}}');#DepthCov
  echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10" >>Summaries.txt;
done
