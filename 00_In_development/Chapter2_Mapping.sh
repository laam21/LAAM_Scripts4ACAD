#!/bin/bash -l
#### METHODS in Palaeomicrobiology
#### Luis Arriola

### Mapping
##  This is a wrapper to run all the reads datasets present in a folder using a specified
##  reference and a variety of mapping algorithms with specific parameters:
##    -BWA:           Default [v0.7.9a]
##    -BWAaDNA:       -l1024 -n .01 -o 2  [v0.7.9a]
##    -BWAmem:        Default [v0.7.9a]
##    -Bowtie2:       Default [v2-2.1.0]
##    -Bowtie2aDNA:   --mo 1,1 --ignore-quals --score-min L,0,-0.03 [v2-2.1.0]
##    -Bowtie2vsens:  [v2-2.1.0] [v2.2.9]

### Modules
##  Loading Modules on ACAD1 cluster
#module load BWA/0.7.15-foss-2016a Bowtie2/2.2.9-foss-2016b SAMtools/1.3.1-foss-2016a
##  Loading Modules on PHOENIX cluster
module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25 BWA/0.7.12-foss-2015b Bowtie2/2.2.6-foss-2015b
module list
date

### Reference sequences PHOENIX
REF_BWA=/fast/users/a1654837/CHAPTER_2/SMUT_GENOME/SmutansUA159.fasta
REF_Bowtie=/fast/users/a1654837/CHAPTER_2/SMUT_GENOME/bowtie2/SmutansUA159
### Reference sequences ACAD1
#REF_BWA=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/SmutansUA159.fasta
#REF_Bowtie=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/bowtie2/SmutansUA159

for FQZ in *.fasta.gz; do
        echo $FQZ
        #BWA
        #BWA-aln
        bwa aln -t 32 $REF_BWA $FQZ \
        | bwa samse $REF_BWA - $(basename $FQZ)\
        | samtools view -uSh - \
        | samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwaaln.sort

        #BWA-aDNA
      	bwa aln -t 32 -l 1024 -n 0.01 -o 2 $REF_BWA $FQZ \
        | bwa samse $REF_BWA - $(basename $FQZ)\
      	| samtools view -uSh - \
      	| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwaaDNA.sort

      	#BWA-mem
      	bwa mem -t 32 $REF_BWA $FQZ \
      	| samtools view -uSh - \
      	| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwamem.sort

      	#BWA-pssm
      	#bwa pssm -t 32 $REF_BWA $FQZ \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
      	#| samtools view -uSh - \
      	#| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwapssm.sort

        #BWA-pssm-aDNA
      	#bwa pssm -t 32 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
      	#| samtools view -uSh - \
      	#| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwa_pssmaDNA.sort

      	#BWA-pssm-EVO
      	#bwa pssm -t 16 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
      	#| samtools view -uSh - \
      	#| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwa_pssmEVO.sort

      	#BWA-pssm-EVOaDNA
      	#bwa pssm -t 16 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
      	#| samtools view -uSh - \
      	#| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwa_pssmEVOaDNA.sort

        #Bowtie2
        #Bowtie2
        echo -e "bowtie2 \n"
        gzip -dc $FQZ \
        | bowtie2 -p32 -f -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fasta\.gz/}")a.sam
        ( samtools view -uSh $(basename "${FQZ/\.fasta\.gz/}")a.sam \
        | samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bowtie2.sort) &

        #Bowtie2-aDNA
        echo -e "bowtie2aDNA \n"
        gzip -dc $FQZ \
        | bowtie2 -p32 -f --mp 1,1 --ignore-quals --score-min L,0,-0.03 -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fasta\.gz/}")b.sam
        ( samtools view -uSh $(basename "${FQZ/\.fasta\.gz/}")b.sam \
        | samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bowtie2aDNA.sort) &

        #Bowtie2-Vsens
        echo -e "bowtie2VSens \n"
        gzip -dc $FQZ \
        | bowtie2 -p32 -f --very-sensitive -x $REF_Bowtie -U /dev/stdin -S $(basename "${FQZ/\.fasta\.gz/}")c.sam
        ( samtools view -uSh $(basename "${FQZ/\.fasta\.gz/}")c.sam \
        | samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bowtie2Vsens.sort) &
done
wait

rm *.sam
for BAM in *.sort.bam ; do samtools index $BAM & done
for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & done
wait
