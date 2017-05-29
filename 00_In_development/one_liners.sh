# Quick Bash one-linners

#Change multiple names on MoL samples
  for filename in ./*; do mv "$filename" $(basename "$filename" | awk -F "_l" '{print $1".rma3"}'); done

##chec sizes of fastq files
for i in *fastq.gz; do zcat $i | grep -c "^@M02262" ;done
##Renaming files
for filename in ./*; do mv "$filename" $(basename "$filename" | awk -F "_" '{print $1"."$2"."$3"_"$NF}'); done
### Running bbmerge
for i in *_R1.fastq.gz; do
  bbmerge.sh in1=$i in2=${i/_R1/_R2} out=${i/_R1.fastq.gz/_merged.fastq} outu1=${i/_R1.fastq.gz/_unmerged_R1.fastq} outu2=${i/_R1.fastq.gz/_unmerged_R2.fastq}
done


## FASTQ to fasta
for i in *.fastq; do cat $i | awk 'NR % 4 == 1 {print ">" $0 } NR % 4 == 2 {print $0}' > ${i/fastq/fasta}; done

#Stats
for FILE in ./*.stats; do echo "$FILE">>SUMMARY_STATS.txt; cat $FILE | awk 'NR==3' >>SUMMARY_STATS.txt;done

#Summarize DeNovo % mapped reads
for FILE in ./*.stats; do echo "$FILE"; head "$FILE" | awk 'NR==3' | cut -d"(" -f2 |cut -d":" -f1; done

#MeganServer
./start.sh --name ACAD_DC --max-memory 8G

#To get the unmapped reads from a bam file use :
samtools view -f 4 file.bam > unmapped.sam, the output will be in sam

#to get the output in bam use :
samtools view -b -f 4 file.bam > unmapped.bam

#To get only the mapped reads use the parameter 'F', which works like -v of grep and skips the alignments for a specific flag.
samtools view -b -F 4 file.bam > mapped.bam



#To get the genome size from a BAM file
samtools view -H SmutansUA159_SIM150.1_1snp_bwaaln.sort.bam | grep -P '^@SQ' | cut -f 3 -d ':' |  awk '{sum+=$1} END {print sum}'

#To get the Percentage Covered from BAM file of SmutansUA159_SIM150
samtools depth SmutansUA159_SIM150.1_1snp_bwaaln.sort.bam | awk '{if ( $3>=1 ) sum+=1 } END { print "Percentage Covered = ", sum/2032925}'

#To get the Percentage Covered and Avg depth of Cov
for FILE in ./*.bam; do echo "$FILE"; \
samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print "Percentage Covered = ", (sum/2032925)*100}';\
samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print "Avg Depth of Cov  = ",sum/NR}}';\
echo -e "\n";\
done

#To calculate the number of "endogenous" reads  Test1
for FILE in ./*.bam; do echo "$FILE"; \
  AvSize=$(echo "$FILE" | cut -d"." -f2 | cut -d"_" -f2);\
  if [ "$AvSize" == "50" ]; then IDtag="0044"; \
  elif [ "$AvSize" == "75" ]; then IDtag="0091"; \
  else  IDtag="0138"; \
  fi ; \
  echo "Endogenous Reads: $(samtools view $FILE | awk '{if($2!=4) print $1}'| grep -c "HWI-ST745_$IDtag")"; \
  echo "Total Reads: $(samtools view $FILE | grep -c "^HWI-ST745")"; \
done




#To get the Total reads, Mapped Reads, Endogenous Reads, Percentage Covered and Avg depth of Metagenomic data
for FILE in *.bam; do echo "$FILE"; \
  AvSize=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f2);\
  Mapper=$(echo "$FILE" | cut -d"." -f2 | sed s/fastq_//);\
  echo "$Mapper $AvSize";\
  if [ "$AvSize" == "50" ]; then IDtag="0044"; \
  elif [ "$AvSize" == "75" ]; then IDtag="0091"; \
  else  IDtag="0138"; \
  fi ; \
  echo "Total Reads: $(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1)"; \
  echo "Mapped Reads: $(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1)"; \
  echo "Endogenous Reads: $(samtools view $FILE | awk '{if($2!=4) print $1}'| grep -c "HWI-ST745_$IDtag")"; \
  samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print "Percentage Covered = ", (sum/2032925)*100}';\
  samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print "Avg Depth of Cov  = ",sum/NR}}';\
done

#Same as previous but tab delimited files NoneMutated
echo -ne "Mapper\tAvSize\tTotalReads\tMappedReads\tEndogenousReads\tPercentageCovered\tAvDepthCov\n";\
for FILE in *.bam; do \
  AvSize=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f2);\
  Mapper=$(echo "$FILE" | cut -d"." -f2 | sed s/fastq_//);\
  echo -ne "$Mapper\t$AvSize\t";\
  if [ "$AvSize" == "50" ]; then IDtag="0044"; \
  elif [ "$AvSize" == "75" ]; then IDtag="0091"; \
  else  IDtag="0138"; \
  fi ; \
  echo -ne "$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1)\t"; \
  echo -ne "$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1)\t"; \
  echo -ne "$(samtools view $FILE | awk '{if($2!=4) print $1}'| grep -c "HWI-ST745_$IDtag")\t"; \
  echo -ne "$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print (sum/2032925)*100}')%\t";\
  echo -ne "$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}')\n";\
done

#Same as previous but tab delimited files Mutated
echo "$(basename $PWD)";\
echo -ne "Mutation\tAvSize\tTotalReads\tMappedReads\tEndogenousReads\tPercentageCovered\tAvDepthCov\n";\
for FILE in *.bam; do \
  AvSize=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f2);\
  Mutation=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f3);\
  echo -ne "$Mutation\t$AvSize\t";\
  if [ "$AvSize" == "50" ]; then IDtag="0044"; \
  elif [ "$AvSize" == "75" ]; then IDtag="0091"; \
  else  IDtag="0138"; \
  fi ; \
  echo -ne "$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1)\t"; \
  echo -ne "$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1)\t"; \
  echo -ne "$(samtools view $FILE | awk '{if($2!=4) print $1}'| grep -c "HWI-ST745_$IDtag")\t"; \
  echo -ne "$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print (sum/2032925)*100}')%\t";\
  echo -ne "$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}')\n";\
done > $(basename $PWD)_SummaryStats.txt

#Same as previous but tab delimited files Mutated DAMAGED
echo "$(basename $PWD)";\
echo -ne "Mutation\tAvSize\tTotalReads\tMappedReads\tEndogenousReads\tPercentageCovered\tAvDepthCov\n";\
for FILE in *.bam; do \
  AvSize=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f2);\
  Mutation=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f4);\
  echo -ne "$Mutation\t$AvSize\t";\
  if [ "$AvSize" == "50" ]; then IDtag="0044"; \
  elif [ "$AvSize" == "75" ]; then IDtag="0091"; \
  else  IDtag="0138"; \
  fi ; \
  echo -ne "$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1)\t"; \
  echo -ne "$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1)\t"; \
  echo -ne "$(samtools view $FILE | awk '{if($2!=4) print $1}'| grep -c "HWI-ST745_$IDtag")\t"; \
  echo -ne "$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print (sum/2032925)*100}')%\t";\
  echo -ne "$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}')\n";\
done > $(basename $PWD)_SummaryStats.txt


#Same as previous but tab delimited files Mutated DAMAGED
echo -ne "Mutated\tDeamination\tMapper\tTotalReads\tMappedReads\tPercentageCovered\tAvDepthCov\n";\
for FILE in *.bam; do \
  echo -ne "$(basename $FILE | cut -d"." -f1 | cut -d"_" -f2)\t";\
  echo -ne "$(basename $FILE | cut -d"." -f1 | cut -d"_" -f4)\t";\
  echo -ne "$(basename $FILE | cut -d"." -f3 | sed s/fa_//)\t";\
  echo -ne "$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1)\t"; \
  echo -ne "$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1)\t"; \
  echo -ne "$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print (sum/2032925)*100}')%\t";\
  echo -ne "$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}')\n";\
done > $(basename $PWD)_SummaryStats.txt

###Summary_stats on Iterative
for FILE in *.bam; do Col1=$(echo "$FILE"); \ #File name
  Col2=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f3);\ #Divergence "MutatedNone"
  Col3=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f1);\ #Mapper
  Col4=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1);\ #TotalReads
  Col5=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1);\ #MappedReads
  Col6=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d":" -f1);\ #%MappedReads
  Col7=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum/2032925)*100}');\ #PercentageCovered
  Col8=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}');\ #AvergageDepthofCoverage
  echo "$Col1 $Col2 $Col3 $Col4 $Col5 $Col6 $Col7 $Col8" >Summaries.txt;\
done

echo -ne "FileName\tDivergence\tMapper\tTotalReads\tMappedReads\tPercentMappedreads\t"
for FILE in *.bam; do Col1=$(echo "$FILE"); \
  Col2=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f3);\
  Col3=$(echo "$FILE" | cut -d"." -f1 | cut -d"_" -f1);\
  Col4=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1);\
  Col5=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1);\
  Col6=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d":" -f1);\
  Col7=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum/2032925)*100}');\
  Col8=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print sum/NR}}');\
  echo "$Col1 $Col2 $Col3 $Col4 $Col5 $Col6 $Col7 $Col8" >>Summaries.txt;\
done

#Summary statistics Iterative level0
echo -ne "Method\tDivergence\tType\tDeamination\tMapper\tTotalReads\tMappedReads\t%MappedReads\tCoverage\tDepthCov\n">>Summaries_itera0.txt;
for FILE in *.bam; do Col1=$(echo "$FILE" | cut -d"_" -f5); #Method
  Col2=$(echo "$FILE" | cut -d"_" -f2); #Divergence
  Col3=$(echo "$FILE" | cut -d"_" -f3); #Type
  Col4=$(echo "$FILE" | cut -d"_" -f4); #Deamination
  Col5=$(echo "$FILE" | cut -d"_" -f1); #Mapper
  Col6=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1); #TotalReads
  Col7=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1); #MappedReads
  Col8=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d":" -f1); #PercentMappedReads
  Col9=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum)}'); #Coverage
  Col10=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print (sum/NR)} else {print 0}}');#DepthCov
  echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10" >>Summaries_itera0.txt;
done

echo -ne "Method\tDivergence\tType\tDeamination\tMapper\tTotalReads\tMappedReads\t%MappedReads\tCoverage\tDepthCov\n">>Summaries_itera0.txt;
for FILE in *.bam; do Col1=$(echo "$FILE" | cut -d"_" -f5); \
  Col2=$(echo "$FILE" | cut -d"_" -f2); \
  Col3=$(echo "$FILE" | cut -d"_" -f3); \
  Col4=$(echo "$FILE" | cut -d"_" -f4); \
  Col5=$(echo "$FILE" | cut -d"_" -f1); \
  Col6=$(head $FILE.stats | awk 'NR==1' | cut -d"+" -f1); \
  Col7=$(head $FILE.stats | awk 'NR==3' | cut -d"+" -f1); \
  Col8=$(head $FILE.stats | awk 'NR==3' | cut -d"(" -f2 | cut -d":" -f1); \
  Col9=$(samtools depth $FILE | awk '{if ( $3>=1 ) sum+=1 } END { print  (sum)}'); \
  Col10=$(samtools depth $FILE | awk '{sum+=$3} END { if ( NR>0 ) {print (sum/NR)} else {print 0}}'); \
  echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8\t$Col9\t$Col10" >>Summaries_itera0.txt; \
done








#Find from which organisms is the contamination comming from?
for FILE in *.bam; do \
  echo -ne "$FILE\nNumReads\tOrganism";\
  echo -ne "$(samtools view $FILE | awk '{print $1}' | cut -d":" -f1 | sort | uniq -c)\n";\
done > $(basename $PWD)_NonEndogenousList.txt &

#Non-endogenous Test 2
for FILE in *.bam; do \
  echo -ne "$FILE\nNumReads\tOrganism";\
  echo -ne "$(samtools view $FILE | awk '{if($2!=4) print $1}'| cut -d":" -f1 | sort | uniq -c)\n";\
done > $(basename $PWD)_NonEndogenousList2.txt &


#Calculate genomeCoverageBED
for BAMFILE in *.bam; do \
  ROOT=$(basename "${BAM/\.*/}") \
  bedtools bamtobed -i $BAM > $ROOT.bed

#Coverage bedgraph format
bedtools bamtobed -i SmutansUA159_SIM150.1.fastq_bowtie2_aDNA.sort.bam | sort -k1,1 | genomeCoverageBed -bga -i - -g /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/SMgenome_Chromosome.txt | head -20
#Coverage per position
bedtools bamtobed -i SmutansUA159_SIM150.1.fastq_bowtie2_aDNA.sort.bam | sort -k1,1 | genomeCoverageBed -i - -g /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/SMgenome_Chromosome.txt -d | head -20




#find non-endogenous files
find ./ -type f -iname "*NonEndogenousList2.txt"
#Find and move
find ./ -type f -iname "*NonEndogenousList2.txt" -exec mv --backup=numbered -t NONENDOGENOUS_Summaries/ {} +




bedtools coverage -hist -abam 3REFSmutansUA159_SMEcomb_BRO_8890_Collapsed_QualMap30_Sort_Uniq.bam -b NC_004350long_SmuUA159_genelist.bed > BRO_8890_GENEcoverage.hist.txt
 
awk '$4 < 1' BRO_8890_GENEcoverage.hist.txt
 
awk '{print $1"\t"$2"\t"$3"\t"(1 - $7)}' BRO_8890_GENEcoverage0.hist.txt 
 
	cat BRO_8891_GENEcoverage.hist.txt | awk '$4 < 1' | awk '{print $1"_"$2"_"$3"\t"(1 - $7)}' > BRO_8	891_GENEcoverageNO0_1.hist.txt  

	cat IR_13224_GENEcoverage.hist.txt  |awk '$4 < 1' | awk '{print $1"_"$2"_"$3"\t"(1 - $7)}' | sort > 	IR_13224_GENEcoverageNO0_1sorted.hist.txt


	cat MED_8332_GENEcoverage.hist.txt | sed -e "s/NC_004350/gi|347750429|ref|NC_004350.2|/g" | awk '$4 < 1' | awk 	'{print $1"_"$2"_"$3"\t"(1 - $7)}' > MED_8332_GENEcoverageNO0_1.hist.txt

bedtools intersect -a BRO_8890_GENEcoverageNO0.hist.txt -b NC_004350_SmuUA159_genelist_ALLnamesSIMPLE.bed -wb | awk -v OFS="\t" '{print $1,$2,$3,$8,$4}' | head
 

bedtools intersect -a BRO_8890_GENEcoverageNO0.hist.txt -b NC_004350_SmuUA159_genelist_ALLnamesSIMPLE.bed -wb | awk -v OFS="\t" '{print $1,$2,$3,$8,$4}' > BRO_8890_GENEcoverageNO0_NAMES.hist.txt 


join  ../NC_004350_SmuUA159_genelist_ALLnames_1sorted.bed IR_13224_GENEcoverageNO0_2sorted.hist.txt | awk '{print $1","$2","$3}' > IR_13224_GENEcoverageNO0_1sortedNAMES.hist.txt


##SOAPdenovo2 on cluster
# module load SOAPdenovo2
# choose configfile
SOAPdenovo-63mer all -s SOAPdenovo_SmNone.config -R -p 16 -o SOAPdenovo_SmNone1 1>ass_SmNone1.log 2>ass_SmNone1.err

##SOAPdenovo_SmHigh1D5.config

##SOAPdenovo config file Smut_MutHigh1 DEAM 0.5
##max_rd_len=180

##[LIB]
##f=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/1_Input_Datasets/SMUT_GENOME/WHOLE_GENOME/SmutansUA159_MutatedHigh1_SWRECKED_Deam5.fasta
