#!/bin/bash -l
#       FASTQ2pOTUS.sh
#       by Luis Arriola
#       Last Update: Mon 1 Aug 2016

# This scripts takes fastq files from a directory and perform OTU picking analysis on them

# Modules necessary for script
#module load java/java-jdk-1.7.051   Qiime/1.8.0
module load java/java-1.7.09 Qiime/1.8.0
module list

# 1) Merge reads
# We use "bbmerge" (a program from the bbmap package:  http://sourceforge.net/projects/bbmap/)
# to merge the R1 and R2 reads for each sample.

DIR=$1

for i in $(ls $DIR/*_R1.fastq.gz); do
  /opt/local/bbmap/bbmerge.sh in1=$i in2=${i/_R1/_R2} out=${i/_R1.fastq.gz/_merged.fastq} outu1=${i/_R1.fastq.gz/_unmerged_R1.fastq} outu2=${i/_R1.fastq.gz/_unmerged_R2.fastq}
done

mkdir OTU_picking
mv $DIR/*merged.fastq  OTU_picking
rm $DIR/*unmerged*

# 2) Create "seqs.fna" for OTU picking
# We transform the merged fastq files into fasta files
for i in OTU_picking/*.fastq; do
  seqtk fq2fa $i > ${i/fastq/fasta}
done

# We use the  perl script (fastatofna.pl) to create the seqs.fna file with the format needed for Qiime.
# The file seqs.fna is the input file for the OTU picking analysis,
# it contains all the reads with a sequence identifier containing the sampleID.
cp fastatofna.pl OTU_picking
cd OTU_picking
./fastatofna.pl

# 3) Pick OTUs
echo -e "OTU picking: Closed References… \n"
echo  "pick_closed_reference_otus.py -i seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 8 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax "
pick_closed_reference_otus.py -i seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 8 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax

echo -e "OTU picking: Open References… \n"
echo "pick_open_reference_otus.py -i seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 8 -o open97_gg13_8 "
pick_open_reference_otus.py -i seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 8 -o open97_gg13_8

date
