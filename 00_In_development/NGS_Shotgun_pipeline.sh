#!/bin/bash -l

###############               Neandertal Pipeline               ###############
# NGS analytical pipeline + MALT
# by Luis Arriola
# Last Update: September 2016 by larriola
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#////////////////////\\\\\\\\\\\\\\\\\\\\
# STEP 1 - Barcode demultiplexing with Sabre
# B. LLAMAS - J. SOUBRIER - October 2013
# Modified by B. LLAMAS - April 2014
#\\\\\\\\\\\\\\\\\\\\////////////////////

# Requirements:
#     ./Data folder containing:
#             - fastq.gz files
#             - barcodes files (R1 and R2)
#     System: pigz, sabre

module load sabre/20131121-gnu_4.8.0

if [ -f Data/barcodes_R2* ]; then # If there is a right barcode file

        if [ -d 1_Barcode_sabre ]; then # If Barcode folder exists, go in, if not, make one and go in
                cd 1_Barcode_sabre
        else
                mkdir 1_Barcode_sabre
                cd 1_Barcode_sabre
        fi
        echo -e "\nBarcode demultiplexing in process..."
        for BC_R2 in ../Data/barcodes_R2.txt; do # Loop on barcode files for R2 reads
                for R2FQGZ in ../Data/*R2*.fastq.gz; do # Loop on fastq files

                        sabre pe -f <(unpigz -c $R2FQGZ) -r <(unpigz -c ${R2FQGZ/R2/R1}) \
                        -b $BC_R2 -u unknown_rBCR2.fastq -w unknown_rBCR1.fastq \
                        > Report_$(basename "${BC_R2/\.txt/}")_$(basename "${R2FQGZ/\.fastq\.gz/.txt}")
                        pigz *.fastq
                done
        done
        for R1FQGZ in *_R1*.fastq.gz; do
                rBC=`echo $(basename "$R1FQGZ") | cut -d "_" -f 1`
                for BC_R1 in ../Data/barcodes_R1_$rBC.txt; do

                        sabre pe -f <(unpigz -c $R1FQGZ) -r <(unpigz -c ${R1FQGZ/R1/R2}) \
                        -b $BC_R1 -u unknown_lBCR1_$rBC.fastq -w unknown_lBCR2_$rBC.fastq \
                        > Report_$(basename "${BC_R1/\.txt/}")_$(basename "${R2FQGZ/\.fastq\.gz/.txt}")
                done
                rm $rBC*
        done
        pigz *.fastq
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#////////////////////\\\\\\\\\\\\\\\\\\\\
# STEP 2 - Remove 5' and 3' adapters
#       Julien Soubrier - Bastien Llamas - Oliver Wooley - February 2013
#\\\\\\\\\\\\\\\\\\\\////////////////////

# Requirements:
#     1_Barcode_sabre folder containing:
#             - fastq.gz files
#     ./Data folder containing:
#             - adapters file
#     System: pigz, FastQC, AdapterRemoval

##### USER INPUT #####
MM="0.1" # default is 0.33 for SE data and 0.1 for PE data
MINLENGTH="25" # default is 15 nt
MINQUAL="4" # default is 2
OVERLAP="11" # Only in PE mode. Default is 11 nt

module load AdapterRemoval/1.5.2-gnu_4.8.0 fastQC/0.11.2

# Check presence of adapter file + if there is a barcode folder (-> use deconvoluted fastq)
if [ -f Data/adapters_AdapterRemoval.txt ] && [ -d 1_Barcode_sabre ]; then
        if [ ! -d 2_Adapter_AdapterRemovalPE_sabre ]; then # If Adapter folder doesn't exist, make one
                mkdir 2_Adapter_AdapterRemovalPE_sabre
        fi

        # Get adapters from the adapter file
        ADAPT_P7=$(head -n 1 Data/adapters_AdapterRemoval.txt)
        ADAPT_P5=$(head -n 2 Data/adapters_AdapterRemoval.txt | tail -n 1)

        R2_PAIREDEND=(1_Barcode_sabre/*_R2.fastq.gz)
        #if there is an R2 file, do R1 and R2 processing on each pair
        if [ -e ${R2_PAIREDEND[0]} ];
                then

                for FQGZ in 1_Barcode_sabre/*_R1.fastq.gz; do # Loop on fastq files
                        if  [[ $FQGZ != unknown* ]]; then
                                echo -e "\nAdapterRemoval processing $(basename $FQGZ)..."

                                #pcr1 in AdapterRemoval is reverse complement of (barcoded) P7 adapter
                                BC_P7=`echo "$FQGZ" | sed -n 's/.*_r\([ACGT]*\)_.*/\1/p'`
                                BC_P7REVCOMP=`echo $BC_P7 | tr "[ATGC]" "[TACG]" | rev`
                                ADAPTBC_P7=$BC_P7REVCOMP$ADAPT_P7
                                echo -e "Reverse complement P7 adapter is $ADAPT_P7"
                                echo -e "P7 barcode is $BC_P7"
                                echo -e "Reverse complement P7 barcode is $BC_P7REVCOMP"
                                echo -e "Parameter pcr1 is $ADAPTBC_P7"

                                #pcr2 in AdapterRemoval is barcoded P5 adapter
                                BC_P5=`echo "$FQGZ" | sed -n 's/.*_l\([ACGT]*\)_.*/\1/p'`
                                ADAPTBC_P5=$ADAPT_P5$BC_P5
                                echo -e "P5 adapter is $ADAPT_P5"
                                echo -e "P5 barcode is $BC_P5"
                                echo -e "Parameter pcr2 is $ADAPTBC_P5"

                                #trimns, trimqualities, remove adapters, collapse, compress results, output stats (mm hardcoded as 3)
                                AdapterRemoval --file1 <(unpigz -p 1 -c $FQGZ) --file2 <(unpigz -p 1 -c ${FQGZ/R1/R2}) --collapse --stats --trimns --trimqualities --minlength $MINLENGTH  --qualitybase 33 --minquality $MINQUAL --minalignmentlength $OVERLAP --pcr1 $ADAPTBC_P7 --pcr2 $ADAPTBC_P5 --mm $MM \
                                --output1 >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1_Truncated.fastq.gz}")) \
                                --output2 >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R2_Truncated.fastq.gz}")) \
                                --outputstats >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_OutputStats.txt.gz}")) \
                                --singleton >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Singleton_Truncated.fastq.gz}")) \
                                --singletonstats >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_SingletonStats.txt.gz}")) \
                                --outputcollapsed >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed.fastq.gz}")) \
                                --outputcollapsedtruncated >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed_Truncated.fastq.gz}")) \
                                --discarded >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Discarded.fastq.gz}")) \
                                --settings >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Settings.txt.gz}"))

                                echo -e "\nAdapterRemoval done for $(basename $FQGZ)\n";

                                # QC in background
                                sleep 3s
                                (fastqc 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Singleton_Truncated.fastq.gz}") -o 2_Adapter_AdapterRemovalPE_sabre/ &)
                                (fastqc 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed.fastq.gz}") -o 2_Adapter_AdapterRemovalPE_sabre/ &)
                                (fastqc 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed_Truncated.fastq.gz}") -o 2_Adapter_AdapterRemovalPE_sabre/ &)
                                (fastqc 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1_Truncated.fastq.gz}") -o 2_Adapter_AdapterRemovalPE_sabre/ &)
                                (fastqc 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R2_Truncated.fastq.gz}") -o 2_Adapter_AdapterRemovalPE_sabre/ &)
                                echo -e "\nFastQC done"

                                # Number of reads in Report file
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1_Truncated.fastq.gz}") | echo -e "Paired\t"$((`wc -l`/4)) >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed.fastq.gz}") | echo -e "Collapsed\t"$((`wc -l`/4)) >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed_Truncated.fastq.gz}") | echo -e "CollapsedTruncated\t"$((`wc -l`/4)) >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Singleton_Truncated.fastq.gz}") | echo -e "Singletons\t"$((`wc -l`/4)) >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Discarded.fastq.gz}") | echo -e "Discarded\t"$((`wc -l`/4)) >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");

                                # Head output fastq in Report file
                                echo -e "\n____________________\n--- First 25 reads - Paired Read1\n" >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1_Truncated.fastq.gz}") | head -100 >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                echo -e "\n____________________\n--- First 25 reads - Paired Read2\n" >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R2_Truncated.fastq.gz}") | head -100 >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                echo -e "\n____________________\n--- First 25 reads - Singletons\n" >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Singleton_Truncated.fastq.gz}") | head -100 >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                echo -e "\n____________________\n--- First 25 reads - Collapsed\n" >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed.fastq.gz}") | head -100 >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                echo -e "\n____________________\n--- First 25 reads - CollapsedTruncated\n" >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                                unpigz -c 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed_Truncated.fastq.gz}") | head -100 >> 2_Adapter_AdapterRemovalPE_sabre/Report_$(basename "${FQGZ/_R1*/.txt}");
                        fi
                done
        fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#////////////////////\\\\\\\\\\\\\\\\\\\\
# STEP 3 - MALT ANALYSIS (v0.1.2)
#       Luis Arriola - 18th May 2016
#\\\\\\\\\\\\\\\\\\\\////////////////////

# Requirements:
#     2_Adapter_AdapterRemovalPE_sabreFolder with fastq/fastq.gz files to be analized
#     MALT v0.1.2
#       - modules: Java
#       - index (generated with malt-build)

##### USER INPUT #####
INDEX="/rdsi/acad/Luis_DC_backup/MALT/151103_index_RefSeqAll2014"
LICENSE="/data/acad/Luis_DC_backup/MALT/00_License/MEGAN5-academic-license.txt"
THREADS="32"
module load java/java-1.7.09

export PATH=/home/users/larriola/software/malt:$PATH
echo -e "Starting Analysis...\n"; date
# Input File or directory
if [[ -d 2_Adapter_AdapterRemovalPE_sabre ]]; then
        SEQS=`ls -dm 2_Adapter_AdapterRemovalPE_sabre/*R1R2_Collapsed.fastq.gz | tr "," " "| tr "\\n" " "`
        OUT_SEQS=`echo $(ls -m 2_Adapter_AdapterRemovalPE_sabre/*R1R2_Collapsed.fastq.gz| tr "," " "| tr "\\n" " "| sed 's/\.\w*\.*\w*/_MALT\.sam/g')` \
fi

echo "malt-run -t $THREADS -i $SEQS -a $OUT_SEQS -d $INDEX -m BlastX -L $LICENSE -v"
malt-run -t $THREADS -i $SEQS -a $OUT_SEQS -d $INDEX -m BlastX -L $LICENSE -v

# SAM2RMA
mkdir SAMfiles_MALT
mv *.sam.gz SAMfiles_MALT
unpigz SAMfiles_MALT/*
echo "running SAM2RMA"
for FILE in SAMfiles_MALT/*.sam; do
        ~/software/megan/tools/sam2rma -i $FILE -o $(basename ${FILE/.sam/}).rma3 -k -s -c \
        -g2t /home/users/larriola/software/malt/data/gi_taxid_prot-2014Jan04.bin \
        -g2k /home/users/larriola/software/malt/data/gi2kegg-new.map.gz \
        -r2k /home/users/larriola/software/malt/data/ref2kegg.map.gz \
        -g2s /home/users/larriola/software/malt/data/gi2seed-new.map.gz \
        -r2s /home/users/larriola/software/malt/data/ref2seed.map.gz \
        -r2c /home/users/larriola/software/malt/data/ref2cog.map.gz -v
done

echo "END"; date
