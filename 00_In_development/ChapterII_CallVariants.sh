### Calling  consensus sequences

# Load modules for cluster
#module load samtools/1.2 \
#bcftools/1.2 \
#zlib/testing \
#gnu/4.9.2 \
#tabix/0.2.6-gnu_4.8.0 \
#paleomix/1.1.0-20150914-git~65f59ee \
#python/4.4.3/2.7.2 \
#pysam/0.7.5

#module load SAMtools/1.2-foss-2015b \
#BCFtools/1.3.1-GCC-5.3.0-binutils-2.25

#module list

# Input files and parameters
#REF="/fast/users/a1654837/CHAPTER_2/SMUT_GENOME/SmutansUA159.fasta"
#BED="/fast/users/a1654837/CHAPTER_2/SmutansUA159.WG.bed"

REF="/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/SMUTANS_MAPPING_TEST/SMUT_GENOME/SmutansUA159.fasta"
BED="/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/SMUTANS_MAPPING_TEST/SMgenome_Chromosome.txt"


DEPTH=2

# Loop through BAM files
DPMax=`expr $DEPTH - 1`
for x in `ls *.bam`; do
  y=${x/.bam/}
  echo "Processing $y..."
  samtools mpileup -EAu $y.bam -f $REF -Q 30 -O | bcftools call -m | bcftools view -i "DP>$DPMax" | bgzip > $y.BQ30_DP$DEPTH.vcf.bgz
  tabix -p vcf $y.BQ30_DP$DEPTH.vcf.bgz -f
  #echo ">$y.BQ30_DP$DEPTH" > $y.BQ30_DP$DEPTH.fasta
  #paleomix vcf_to_fasta --genotype $y.BQ30_DP$DEPTH.vcf.bgz --intervals $BED | grep -v '>' >> $y.BQ30_DP$DEPTH.fasta
done
