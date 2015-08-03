#!/bin/bash -l

##########################################################
#
#       QIIME ANALYSIS -Pick OTUs 16S
#
#       Luis Arriola
#       Last Update: 27th July 2015
#
##########################################################
#       Notes:  Version modified to run on several seqs.fna files
#
###  Requires:
#       -modules:
#               -Qiime
#       -*.fna file
###

if [ $# == 0 ]; then
	echo "       Usage: qiime_pOTUS16S.sh <Directory>
				Directory:   Name of the Directory containing seqs.fna"
else
	module load Qiime
	module list

	for SEQS in $1/*.fna; do
		SEQSname=`basename "$SEQS" | cut -s -d'.' -f1`
		
		echo -e "OTU picking: Closed References… \n"
		echo -e "pick_closed_reference_otus.py -i $SEQS -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 24 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax_"$SEQSname" "
	#	pick_closed_reference_otus.py -i $SEQS -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 24 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax_"$SEQSname" 

		echo -e "OTU picking: Open References… \n"
		echo -e "pick_open_reference_otus.py -i $SEQS -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 24 -o open97_gg13_8_"$SEQSname" "
	#	pick_open_reference_otus.py -i $SEQS -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 24 -o open97_gg13_8_"$SEQSname" 
	done
fi
