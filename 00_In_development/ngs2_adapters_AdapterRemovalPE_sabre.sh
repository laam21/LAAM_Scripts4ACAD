#!/bin/bash

############################################################
#
# NGS analytical pipeline
#       Oliver Wooley- October 2013
#
# MODIFIED BY B. LLAMAS - March 2014
#
#  (based on 'ngs2_Adapter_AdapterRemovalPE_sabreRemoval.sh' - J. SOUBRIER - B. LLAMAS - February 2013
#       and with help from Stinus Lindgreen )
#
#
#////////////////////\\\\\\\\\\\\\\\\\\\\
# STEP 2 - Remove 5' and 3' adapters
#\\\\\\\\\\\\\\\\\\\\////////////////////
#
############################################################

### Need
# fastq.gz files either in 1_Barcode_sabre/ (if applicable) or ./Data folder
# adapters.txt file in ./Data folder with list of adapters, first line = 5' - second line = 3'RC
# pigz (parallel gzip for mac)
# FastQC
# Cutadapt installed
# Check following parameters:


##### USER INPUT #####
MM="0.1" # default is 0.33 for SE data and 0.1 for PE data
MINLENGTH="25" # default is 15 nt
MINQUAL="4" # default is 2
OVERLAP="11" # Only in PE mode. Default is 11 nt

module load gnu/4.9.2 \
fastQC/0.11.2 \
AdapterRemoval \
module list

#path on cluster of AdapterRemoval
#ARPATH="/opt/local"
#path on local machine

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
                                AdapterRemoval --file1 <(unpigz -p 1 -c $FQGZ) --file2 <(unpigz -p 1 -c ${FQGZ/R1/R2}) --collapse --stats --trimns --trimqualities --minlength $MINLENGTH --qualitybase 33 --minquality $MINQUAL --minalignmentlength $OVERLAP --pcr1 $ADAPTBC_P7 --pcr2 $ADAPTBC_P5 --mm $MM --output1 >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1_Truncated.fastq.gz}")) --output2 >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R2_Truncated.fastq.gz}")) --outputstats >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_OutputStats.txt.gz}")) --singleton >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Singleton_Truncated.fastq.gz}")) --singletonstats >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_SingletonStats.txt.gz}")) --outputcollapsed >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed.fastq.gz}")) --outputcollapsedtruncated >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_R1R2_Collapsed_Truncated.fastq.gz}")) --discarded >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Discarded.fastq.gz}")) --settings >(pigz -p 1 > 2_Adapter_AdapterRemovalPE_sabre/2NoAdapt_$(basename "${FQGZ/_R1*/_Settings.txt.gz}"))

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
                done;
        fi
fi
