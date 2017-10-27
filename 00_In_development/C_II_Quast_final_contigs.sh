#!/bin/bash -l
####  CHAPTER_2
####  QUAST on final contigs
#### Luis Arriola

#Test
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/3_FINAL_CONTIGS/3A_MUTATEDNONE

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta

quast.py -R $REF  `ls MUTATEDNONE0*` -o quast_results_MUTATEDNONE_ALL --gage --min-contig 100




# # # # # # # # # # RUN as contigs
#MUTATEDNONE0
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3A_MUTATEDNONE

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta

quast.py -R $REF  `ls MUTATEDNONE0*` -o quast_results_MUTATEDNONE_ALL

#MUTATEDLOW1
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3B_MUTATEDLOW1

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
quast.py -R $REF  `ls MUTATEDLOW1*` -o quast_results_MUTATEDLOW1_ALL

#MUTATEDLOW2
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3C_MUTATEDLOW2

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
quast.py -R $REF  `ls MUTATEDLOW2*` -o quast_results_MUTATEDLOW2_ALL

#MUTATEDHIGH1
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3D_MUTATEDHIGH1
REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
quast.py -R $REF  `ls MUTATEDHIGH1*` -o quast_results_MUTATEDHIGH1_ALL


#MUTATEDHIGH2
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3E_MUTATEDHIGH2
REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
quast.py -R $REF  `ls MUTATEDHIGH2*` -o quast_results_MUTATEDHIGH2_ALL


# # # # # # # # # # RUN as SCAFOLDS with gage
#MUTATEDNONE0
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/B_FINAL_SCAFFOLDS/3A_MUTATEDNONE

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta

quast.py -R $REF  `ls MUTATEDNONE0*` -o quast_results_MUTATEDNONE_ALL

#MUTATEDLOW1
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/B_FINAL_SCAFFOLDS/3B_MUTATEDLOW1

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
quast.py -R $REF  `ls MUTATEDLOW1*` -o quast_results_MUTATEDLOW1_ALL

#MUTATEDLOW2
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/B_FINAL_SCAFFOLDS/3C_MUTATEDLOW2

REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
quast.py -R $REF  `ls MUTATEDLOW2*` -o quast_results_MUTATEDLOW2_ALL

#MUTATEDHIGH1
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/B_FINAL_SCAFFOLDS/3D_MUTATEDHIGH1
REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
quast.py -R $REF  `ls MUTATEDHIGH1*` -o quast_results_MUTATEDHIGH1_ALL


#MUTATEDHIGH2
cd /Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/B_FINAL_SCAFFOLDS/3E_MUTATEDHIGH2
REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
quast.py -R $REF  `ls MUTATEDHIGH2*` -o quast_results_MUTATEDHIGH2_ALL



## AUtomated for scaffolds
for DIR in 3*; do
  cd $DIR
  if [ $DIR == "3A_MUTATEDNONE" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta
  elif [ $DIR == "3B_MUTATEDLOW1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
  elif [ $DIR == "3C_MUTATEDLOW2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
  elif [ $DIR == "3D_MUTATEDHIGH1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
  elif [ $DIR == "3E_MUTATEDHIGH2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
  fi

  quast.py -R $REF  `ls M*` -o quast_results_${DIR} --scaffolds
  cd ..
done
#
for DIR in 3*; do
  if [ $DIR == "3A_MUTATEDNONE" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta
  elif [ $DIR == "3B_MUTATEDLOW1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
  elif [ $DIR == "3C_MUTATEDLOW2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
  elif [ $DIR == "3D_MUTATEDHIGH1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
  elif [ $DIR == "3E_MUTATEDHIGH2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
  fi

  quast.py -R $REF  `ls ${DIR}/M*` -o quast_results_${DIR} --scaffolds
done

## AUtomated for scaffolds 2 cluster
#source activate QUAST
for DIR in 3*; do
  if [ $DIR == "3A_MUTATEDNONE" ]; then
    REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/2_Analyses/A_Calidad/SmutansUA159_MN0.fasta
  elif [ $DIR == "3B_MUTATEDLOW1" ]; then
    REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/2_Analyses/A_Calidad/SmutansUA159_ML1.fasta
  elif [ $DIR == "3C_MUTATEDLOW2" ]; then
    REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/2_Analyses/A_Calidad/SmutansUA159_ML2.fasta
  elif [ $DIR == "3D_MUTATEDHIGH1" ]; then
    REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/2_Analyses/A_Calidad/SmutansUA159_MH1.fasta
  elif [ $DIR == "3E_MUTATEDHIGH2" ]; then
    REF=/localscratch/larriola/METAGENOMICS/SMUTANS_MAPPING_TEST_2017/2_Analyses/A_Calidad/SmutansUA159_MH2.fasta
  fi
  quast.py -R $REF  `ls ${DIR}/MUTATED*` -o quast_results_${DIR} --scaffolds
done


## Automated for contigs 100
for DIR in 3*; do
  cd $DIR
  if [ $DIR == "3A_MUTATEDNONE" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta
  elif [ $DIR == "3B_MUTATEDLOW1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
  elif [ $DIR == "3C_MUTATEDLOW2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
  elif [ $DIR == "3D_MUTATEDHIGH1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
  elif [ $DIR == "3E_MUTATEDHIGH2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
  fi

  quast.py -R $REF  `ls MUTATED*` -o QUAST_results_GAGE_minC100_${DIR} --gage --min-contig 100
  cd ..
done

## Automated for contigs
for DIR in 3*; do
  cd $DIR
  if [ $DIR == "3A_MUTATEDNONE" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MN0.fasta
  elif [ $DIR == "3B_MUTATEDLOW1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML1.fasta
  elif [ $DIR == "3C_MUTATEDLOW2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_ML2.fasta
  elif [ $DIR == "3D_MUTATEDHIGH1" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH1.fasta
  elif [ $DIR == "3E_MUTATEDHIGH2" ]; then
    REF=/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/0_Raw_Data/SMUT_GENOME/SmutansUA159_MH2.fasta
  fi

  quast.py -R $REF  `ls MUTATED*` -o QUAST_results_GAGE_minC500_${DIR} --gage --min-contig 500
  cd ..
done
