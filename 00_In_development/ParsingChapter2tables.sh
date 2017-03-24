#!/bin/bash
File=$1
#for size in $(echo "50 75 150"); do
for size in $(echo "50"); do
#for error in $(echo "SNP Insertion Deletion"); do
for error in $(echo "SNP"); do
cat ${File} | awk -F "," -v Size=${size} -v Error=${error} 'OFS="\t" \
{if ($3==Size && ( $4==Error || $4=="none") )\
  { BWA[$5]=$6; BWA_aDNA[$5]=$9;BWA_mem[$5]=$12;BWA_DeNovo[$5]=$15; BWA_aDNA_DeNovo[$5]=$18;BWA_mem_DeNovo[$5]=$21;BWA_DMGE[$5]=$26;BWA_aDNA_DMGE[$5]=$29;BWA_mem_DMGE[$5]=$32;BWA_DMGE_DeNovo[$5]=$35;BWA_aDNA_DMGE_DeNovo[$5]=$38;BWA_mem_DMGE_DeNovo[$5]=$41}}\
END { array[1]=0;array[2]=1;array[3]=2;array[4]=4;array[5]=8;array[6]=16;array[7]=32; \
    print "Genomic Coverage (%) with reads of size "Size" by "Error" as error type"  ; print "No.Errors","BWA", "BWA_aDNA","BWA_mem","BWA_DeNovo", "BWA_aDNA_DeNovo","BWA_mem_DeNovo","BWA_DMGE","BWA_aDNA_DMGE","BWA_mem_DMGE","BWA_DMGE_DeNovo","BWA_aDNA_DMGE_DeNovo","BWA_mem_DMGE_DeNovo";for (x=1 ; x<8 ; x++) {print array[x],BWA[array[x]],BWA_aDNA[array[x]],BWA_mem[array[x]],BWA_DeNovo[array[x]],BWA_aDNA_DeNovo[array[x]],BWA_mem_DeNovo[array[x]],BWA_DMGE[array[x]],BWA_aDNA_DMGE[array[x]],BWA_mem_DMGE[array[x]],BWA_DMGE_DeNovo[array[x]],BWA_aDNA_DMGE_DeNovo[array[x]],BWA_mem_DMGE_DeNovo[array[x]]} }'

done;
done
