#!/bin/sh -l
module load velvet/1.2.10 VelvetOptimiser/2.2.5
module list

for FILE in `ls -1 *.fastq`;
  do
    AvSize=`echo "$FILE"| cut -d"_" -f2 | cut -d"." -f1| sed -e "s/SIM//"`
    if (( $AvSize % 2 ==  0 ));
       then
        maxkmer=$(($AvSize - 11))
       else
        maxkmer=$(($AvSize -10))
    fi

    VelvetOptimiser.pl -s 21 -e $maxkmer -f "-short -fastq $(basename $FILE)"

    mv auto_data_* $(basename "${FILE/\.fastq/}")_DeNovo
    cp $(basename "${FILE/\.fastq/}")_DeNovo/contigs.fa ./$(basename "${FILE/\.fastq/}")_DeNovo_contigs.fa

  done
mkdir DENOVO
mv *DeNovo* DENOVO
cd DENOVO

./BWAaln_aDNA.sh &
./BWAaln.sh &
./BWAmem.sh &


date
