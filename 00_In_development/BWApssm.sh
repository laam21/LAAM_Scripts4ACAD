#!/bin/bash
REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/SMUTANS_MAPPING_TEST/SMUT_GENOME/SmutansUA159.fasta
for FQZ in ./*fasta.gz
do
#FQ=`basename $FQZ`
/Users/Annarielh/bin_app/bwa-pssm/bwa aln -t 2 $REF $FQZ | /Users/Annarielh/bin_app/bwa-pssm/bwa samse $REF - $(basename $FQZ) \
| samtools view -uSh - \
| samtools sort - $(basename "${FQZ/\.fasta\.gz/}")_bwapssm.sort
done
for BAM in *.sort.bam ; do samtools index $BAM & done
for BAM in *.sort.bam ; do samtools flagstat $BAM > ${BAM}.stats & done
wait
