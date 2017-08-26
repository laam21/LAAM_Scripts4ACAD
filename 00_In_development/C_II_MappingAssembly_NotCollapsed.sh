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
module load BWA/0.7.15-foss-2016b Bowtie2/2.2.9-foss-2016b SAMtools/1.3.1-foss-2016b
##  Loading Modules on PHOENIX cluster
#module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25 BWA/0.7.12-foss-2015b Bowtie2/2.2.6-foss-2015b
module list
date

### Reference sequences PHOENIX
#REF_BWA=/fast/users/a1654837/CHAPTER_2/SMUT_GENOME/SmutansUA159.fasta
#REF_Bowtie=/fast/users/a1654837/CHAPTER_2/SMUT_GENOME/bowtie2/SmutansUA159
### Reference sequences ACAD1
REF_BWA=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/SmutansUA159.fasta
REF_Bowtie=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST/0_Raw_data/SMUT_GENOME/bowtie2/SmutansUA159

for FQZ in *s1_ARnotcollapsed.fq.gz; do
        echo $FQZ
        #BWA
        #BWA-aln
        bwa aln -t 40 $REF_BWA $FQZ > ${FQZ/s1_ARnotcollapsed\.fq\.gz/}1aln.sai
        bwa aln -t 40 $REF_BWA ${FQZ/s1/s2} > ${FQZ/s1_ARnotcollapsed\.fq\.gz/}2aln.sai
        bwa sampe $REF_BWA  ${FQZ/s1_ARnotcollapsed\.fq\.gz/}1aln.sai ${FQZ/s1_ARnotcollapsed\.fq\.gz/}2aln.sai $FQZ ${FQZ/s1/s2} \
        | samtools view -uSh - \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bwaaln.sort.bam

        #BWA-aDNA
        bwa aln -t 40 -l 1024 -n 0.01 -o 2 $REF_BWA $FQZ > ${FQZ/s1_ARnotcollapsed\.fq\.gz/}1aDNA.sai
        bwa aln -t 40 -l 1024 -n 0.01 -o 2 $REF_BWA ${FQZ/s1/s2} > ${FQZ/s1_ARnotcollapsed\.fq\.gz/}2aDNA.sai
        bwa sampe $REF_BWA ${FQZ/s1_ARnotcollapsed\.fq\.gz/}1aDNA.sai ${FQZ/s1_ARnotcollapsed\.fq\.gz/}2aDNA.sai $FQZ ${FQZ/s1/s2}\
        | samtools view -uSh - \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bwaaDNA.sort.bam

        #BWA-mem
        bwa mem -t 40 $REF_BWA $FQZ ${FQZ/s1/s2} \
        | samtools view -uSh - \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bwamem.sort.bam

        #BWA-pssm
        #bwa pssm -t 32 $REF_BWA $FQZ \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
        #| samtools view -uSh - \
        #| samtools sort - $(basename "${FQZ/\.fq\.gz/}")_MAPPING_bwapssm.sort

        #BWA-pssm-aDNA
        #bwa pssm -t 32 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
        #| samtools view -uSh - \
        #| samtools sort - $(basename "${FQZ/\.fq\.gz/}")_MAPPING_bwapssmaDNA.sort

        #BWA-pssm-EVO
        #bwa pssm -t 16 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
        #| samtools view -uSh - \
        #| samtools sort - $(basename "${FQZ/\.fq\.gz/}")_MAPPING_bwapssmEVO.sort

        #BWA-pssm-EVOaDNA
        #bwa pssm -t 16 $REF_BWA $FQZ -G error_model.txt  \
        #| bwa samse $REF_BWA - $(basename $FQZ) \
        #| samtools view -uSh - \
        #| samtools sort - $(basename "${FQZ/\.fq\.gz/}")_MAPPING_bwapssmEVOaDNA.sort

        #Bowtie2
        #Bowtie2
        echo -e "bowtie2 \n"
        bowtie2 -p40 -q -x $REF_Bowtie -1 <(gzip -dc $FQZ) -2 <(gzip -dc ${FQZ/s1/s2}) -S $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")a.sam
        ( samtools view -uSh $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")a.sam \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bowtie2.sort.bam) &

        #Bowtie2-aDNA
        echo -e "bowtie2aDNA \n"
        bowtie2 -p40 -q --mp 1,1 --ignore-quals --score-min L,0,-0.03 -x $REF_Bowtie -1 <(gzip -dc $FQZ) -2 <(gzip -dc ${FQZ/s1/s2}) -S $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")b.sam
        ( samtools view -uSh $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")b.sam \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bowtie2aDNA.sort.bam) &

        #Bowtie2-Vsens
        echo -e "bowtie2VSens \n"
        bowtie2 -p40 -q --very-sensitive -x $REF_Bowtie -1 <(gzip -dc $FQZ) -2 <(gzip -dc ${FQZ/s1/s2}) -S $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")c.sam
        ( samtools view -uSh $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")c.sam \
        | samtools sort - -o $(basename "${FQZ/s1_ARnotcollapsed\.fq\.gz/}")ARnotcollapsed_MAPPING_bowtie2Vsens.sort.bam) &
done
wait

rm *.sam
for BAM in *.sort.bam ; do samtools index $BAM & done
for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & done
#for BAM in *.sort.bam; do samtools view -q30 -bh -F0x4 $BAM | samtools flagstat - > $BAM.MQ30stats & done
wait
