# Quick Bash one-linners

#Change multiple names on MoL samples
  for filename in ./*; do mv "$filename" $(basename "$filename" | awk -F "_l" '{print $1".rma3"}'); done

#rename
for i in *.fasta; do mv "$i" ${i::-31}_merged.fasta; done
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


## Filter by Quality
for BAM in *.sort.bam ; do samtools view -q 25 -bh -F0x4 $BAM > ${BAM/\.bam/}.MQ25.bam & done


#QIIME
##Load Modules

module load qiime/1.9.1-Python-2.7.11 BLAST/2.2.26-Linux_x86_64 Python/2.7.11-foss-2016uofa HDF5/1.8.16-foss-2016uofa
-> core dumped fixed by adding HDF5 and python modules
Test on Seqs


#Works on closed and open
module load QIIME/1.9.1 BLAST/2.2.26-Linux_x86_64
#test on 3_outputdata

### Filter BAM using bedfile with coordinates
module load BEDTools/2.26.0-foss-2016b
for FILE in *.MQ30; do
bedtools intersect -a $FILE -b SmUA159_RNAmaskChr.bed -v >$FILE.mask ;
done

#2
for BAM in *sort.bam; do
  samtools view -q30 -bh -F0x4 $BAM | bedtools intersect -a /dev/stdin -b SmUA159_RNAmaskChr.bed -v > $BAM.MQ30.mask &
  wait
done

### Test
samtools view -bh MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_bwamem.sort.bam.MQ30 | bedtools bamtobed -i /dev/stdin | awk '{print $2":"$3":"$4}' | awk -F ":" 'BEGIN{TrueCount=0;FalseCount=0;}{if(($1 <= $10) && ($2 >= $11)){TrueCount++;}else{FalseCount++;}}END{print TrueCount"\t"FalseCount"\t"TrueCount+FalseCount}' | head



###
#Bowtie2
#Bowtie2
echo -e "bowtie2 \n"
gzip -dc $FQZ \
| bowtie2 -p32 -f -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fa}")a.sam
( samtools view -uSh $(basename "${FQZ/\.fa/}")a.sam \
| samtools sort - -o $(basename "${FQZ/\.fa/}")_REFGUIDED_bowtie2.sort.bam) &

#Bowtie2-aDNA
echo -e "bowtie2aDNA \n"
gzip -dc $FQZ \
| bowtie2 -p32 -f --mp 1,1 --ignore-quals --score-min L,0,-0.03 -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fa/}")b.sam
( samtools view -uSh $(basename "${FQZ/\.fa/}")b.sam \
| samtools sort - -o $(basename "${FQZ/\.fa/}")_REFGUIDED_bowtie2aDNA.sort.bam) &

#Bowtie2-Vsens
echo -e "bowtie2VSens \n"
gzip -dc $FQZ \
| bowtie2 -p32 -f --very-sensitive -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fa/}")c.sam
( samtools view -uSh $(basename "${FQZ/\.fa/}")c.sam \
| samtools sort - -o $(basename "${FQZ/\.fa/}")_REFGUIDED_bowtie2Vsens.sort.bam) &



#CHANGE NAME to fastqfiles to avoid repeated reads
for FILE in *.fq.gz; do
 zcat $FILE | awk '{if ($1 ~ /^@M_*:*/ ) {print $1"_"NR-1} else{ print}}' > ${FILE/\.fq\.gz/}_FNR.fastq
done

RunName=170517_IMS_MAb_16SAfricanPygmies_Demu_ACAD

bbmerge.sh in1=not_demultiplexed_NoIndex_R1.fastq.gz in2=not_demultiplexed_NoIndex_R3.fastq.gz out="$RunName"_merged.fastq.gz outu1="$RunName"_unmerged1.fastq.gz outu2=SequenceO"$RunName"_unmerged2.fastq.gz



### Calculate number of reads in fq files
for FILE in DATASET*/2_NOADAPTER_READS*/COLLAPSED/*ARcollapsed.fq.gz; do echo -e "$FILE\t" `zcat $FILE | seqtk seq -A - | grep -c "^>"`; done
#endogenous
for FILE in DATASET*/2_NOADAPTER_READS*/COLLAPSED/*ARcollapsed.fq.gz; do echo -e "$FILE\t" `zcat $FILE | grep -c "GCA_000007465.2"`; done


#### ITERATIVE MAPPING ASSEMBLY CHECK
#1) Get the MAF file and transform it to SAM file
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b

for DIR in *FNR_ITERATIVEASSEMBLY; do
  for ITERATION in $DIR/iteration*; do
    echo -e "$DIR $ITERATION "
    MAF=$ITERATION/testpool-Streptococcus_mutans_UA159_assembly/testpool-Streptococcus_mutans_UA159_d_results/testpool-Streptococcus_mutans_UA159_out.maf
    miraconvert $MAF ${DIR}_ITERMAP_mbim.sam
    wait
    samtools view -uSh ${DIR}_ITERMAP_mbim.sam | samtools sort - -o ${DIR}_ITERMAP_mbim.sort.bam
    wait
  done
done

#For the different mismatch values
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b

for DIR in *FNR_ITERATIVEASSEMBLY_*; do
  for ITERATION in $DIR/iteration*; do
    echo -e "$DIR $ITERATION "
    MAF=$ITERATION/testpool-Streptococcus_mutans_UA159_assembly/testpool-Streptococcus_mutans_UA159_d_results/testpool-Streptococcus_mutans_UA159_out.maf
    miraconvert $MAF ${DIR}_ITERMAP_mbim.sam
    wait
    samtools view -uSh ${DIR}_ITERMAP_mbim.sam | samtools sort - -o ${DIR}_ITERMAP_mbim.sort.bam
    wait
  done
done


#manual test
java -jar ${EBROOTPICARD}/picard.jar MarkDuplicates I=MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.bam O=MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP.bam AS=TRUE M=/dev/null REMOVE_DUPLICATES=TRUE VALIDATION_STRINGENCY=LENIENT
samtools index MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP.bam
samtools mpileup -uf $REF MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq | seqtk seq -A - > MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP_consensus.fasta
cat MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP_consensus.fasta | seqtk cutN -n 5 - > MUTATEDNONE0_90C10E_DEAM5_ARcollapsed_MAPPING_mira.sort.RMDUP_consensus_contigs.fa


#) Run summary ANALYSIS


#Consensus scaffolds for Iterative Mapping
#module load seqtk
for DIR in *FNR_ITERATIVEASSEMBLY; do
  FASTA=$DIR/iteration*/*_noIUPAC.fasta
  if [ -e $FASTA ]; then
    cp $DIR/iteration*/*_noIUPAC.fasta ../ITERATIVE_COLLAPSED_FINAL_SCAFFOLDS/${DIR}_consensus.fa
  fi
done



# Obtain consensus scaffold and contigs from MIRA
for FQZ in *_FNR.fastq; do
  miraconvert -f maf ${FQZ/\.fastq/}_MappingAssembly_assembly/${FQZ/\.fastq/}_MappingAssembly_d_results/${FQZ/\.fastq/}_MappingAssembly_out.maf ${FQZ/FNR\.fastq/}MAPPING_mira_consensus.fasta
  wait
  cat ${FQZ/FNR\.fastq/}MAPPING_mira_consensus.fasta | seqtk cutN -n 5 - > ${FQZ/FNR\.fastq/}MAPPING_mira_consensus_contigs.fa
  wait
done

for FQZ in *_FNR.fastq; do
  cp ${FQZ/\.fastq/}_MappingAssembly_assembly/${FQZ/\.fastq/}_MappingAssembly_d_results/${FQZ/\.fastq/}_MappingAssembly_out_Streptococcus_mutans_UA159.unpadded.fasta ${FQZ/FNR\.fastq/}MAPPING_mira_consensus.fasta
  wait
  cat ${FQZ/FNR\.fastq/}MAPPING_mira_consensus.fasta | seqtk cutN -n 5 - > ${FQZ/FNR\.fastq/}MAPPING_mira_consensus_contigs.fa
  wait
done


####COnsensus without removing duplications
for BAM in *mira.sort.bam.MQ30 ; do
  samtools mpileup -uf $REF $BAM | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq | seqtk seq -A - > ${BAM/\.bam/}_consensus.fasta
  cat ${BAM/\.bam/}_consensus.fasta | seqtk cutN -n 5 - > ${BAM/\.bam/}_consensus_contigs.fa
done



# Collapsed reads mapping with mira test 2
for FQZ in *_FNR.fastq; do
  ## Initial mapping assembly using MIRA 4
  # Create manifest.conf files
  echo -e "\n#Manifest file for basic mapping assembly with illumina data using MIRA 4\n\nproject = ${FQZ/\.fastq/}_MappingAssembly\n\njob=genome,mapping,accurate\n\nparameters = -GE:not=24 -NW:mrnl=0 -NW:cdrn=no -AS:nop=2 \n\nreadgroup\nis_reference\ndata = /localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/REFERENCE/SmutansUA159.fna\nstrain = Streptococcus_mutans_UA159\n\nreadgroup = reads\ndata = $FQZ\ntechnology = solexa\nstrain = testpool\n" > ${FQZ/\.fastq/}_manifest.conf

  mira ${FQZ/\.fastq/}_manifest.conf
done



#### Mbim denovo > BAM and summary files > Consensus scaffold and contigs
module load SAMtools/1.3.1-foss-2016b BEDTools/2.26.0-foss-2016b seqtk

for DIR in *FNR_ITERMAP_mbimDenovo*; do
  echo $DIR
  for ITERATION in $DIR/iteration*; do
    echo $ITERATION
    if [ -e $ITERATION/testpool_Streptococcus_mutans_UA159-it*_noIUPAC.fasta ]; then
      #obtain fasta Consensus
      cp $ITERATION/testpool_Streptococcus_mutans_UA159-it*_noIUPAC.fasta ./${DIR/_FNR/}_consensus.fasta
      #obtain fasta consensus contigs
      cat $ITERATION/testpool_Streptococcus_mutans_UA159-it*_noIUPAC.fasta | seqtk cutN -n 5 - > ${DIR/_FNR/}_consensus_contigs.fa
      #obtain sam from final maf
      MAF=$ITERATION/testpool-Streptococcus_mutans_UA159_assembly/testpool-Streptococcus_mutans_UA159_d_results/testpool-Streptococcus_mutans_UA159_out.maf
      miraconvert $MAF ${DIR/_FNR}.sam
      wait
    fi
  done
done

for SAM in *.sam; do samtools view -uSh $SAM | samtools sort - -o ${SAM/\.sam/}.sort.bam & wait; done
for BAM in *.sort.bam ; do samtools index $BAM & wait; done
for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & wait; done
for BAM in *.sort.bam; do samtools view -q30 -bh -F0x4 $BAM > $BAM.MQ30 & wait; done
for BAM in *.sort.bam.MQ30; do samtools flagstat $BAM > $BAM.stats & wait; done
#BED=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/1_Input_Datasets/MisincorporationData/SmUA159_RNAmaskChr.bed
#for BAM in *sort.bam; do samtools view -q30 -bh -F0x4 $BAM | bedtools intersect -a /dev/stdin -b $BED -v > $BAM.MQ30.mask & wait; done



### Masked Mapped
for FILE in *.bam; do
  Col1=$(echo $FILE | cut -d"_" -f1);
  Col2=$(echo $FILE | cut -d"_" -f2);
  Col3=$(echo $FILE | cut -d"_" -f3);
  Col4=$(echo $FILE | cut -d"_" -f4);
  Col5=$(echo $FILE | cut -d"_" -f5);
  Col6=$(echo $FILE | cut -d"_" -f6 | cut -d"." -f1);
  Col8=$( samtools view $FILE.MQ30.mask | grep -c "GCA_000007465.2:Chromosome:1:2032925");
  Col7=$( cat $FILE.MQ30.mask.stats | grep "mapped (" | cut -d"+" -f1 );
  echo -e "$Col1\t$Col2\t$Col3\t$Col4\t$Col5\t$Col6\t$Col7\t$Col8" >Masked_summary.txt;
done
