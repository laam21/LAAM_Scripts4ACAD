#!/bin/bash -l

##########################################################
#
#       QIIME ANALYSIS
#
#       Luis Arriola
#       Last Update: 9th June 2015
#
##########################################################
#	
#
###  Requires:
#       -modules:
#               -Qiime
#               -seqtk
#               -pigz
#       -output from BCL2fastq2merged.sh
#               "$RunName"_merged.fastq.gz
#               "$RunName"_index.fastq.gz
#               "$RunName"_mappingfile.txt
###

if [ $# == 0 ]; then
	echo	"	Usage: qiime_pipeline.sh -r <Run Name> -a <16S|18S>
		-r|--RunName:	Name of the Run or Project
		-a|--analysis:	Type of analysis 16S or 18S"
else
	while [[ $# > 1 ]]
	do
		key="$1"
		shift
	
		case $key in
		-r|--RunName)
		# Run Name to be used.
		RunName="$1"
		shift
		;;
		-a|--Analysis)
		# Whether it is a 16S or 18S analysis
		ANALYSIS="$1"
		shift
		;;

		#--default)
		#DEFAULT=YES
		#shift
		#;;
		*)
		# unknown option
		;;
		esac
	done

module load Qiime/1.8.0 seqtk
module list

### VALIDATE
## Validate mapping file
echo -e "\nValidating Files\n"
validate_mapping_file.py -m "$RunName"_mappingfile.txt

## Validate index and merged files

Merged=$(zcat ${RunName}_merged.fastq.gz | grep -c "^@HWI")
Index=$(zcat ${RunName}_index.fastq.gz | grep -c "^@HWI")

if [ "$Merged" == "$Index" ]; then
	echo -e "\nDemultiplexing...\n"
	split_libraries_fastq.py -i "$RunName"_merged.fastq.gz -b "$RunName"_index.fastq.gz -m "$RunName"_mappingfile_corrected.txt -o SplitLib_"$RunName"_Q20_BC0 --rev_comp_mapping_barcodes -q 19 --max_barcode_errors 0

else
	# Correcting the merged and index files
	zcat "$RunName"_merged.fastq.gz | grep "^@HWI" | sed -e 's/^@HWI-/HWI-/' -e 's/\s1:N:0:.*$/\_2:N:0:/g' > "$RunName"_readIDs.lst
	zcat "$RunName"_index.fastq.gz | sed 's/\s/\_/' > temp_barcodes.fastq
	seqtk subseq temp_barcodes.fastq "$RunName"_readIDs.lst | sed 's/\_/ /' | pigz -c > "$RunName"_index_corrected.fastq.gz
	rm temp_barcodes.fastq  *readIDs.lst
	
	date
	echo -e "\nDemultiplexing...\n"
	split_libraries_fastq.py -i "$RunName"_merged.fastq.gz -b "$RunName"_index_corrected.fastq.gz -m "$RunName"_mappingfile_corrected.txt -o SplitLib_"$RunName"_Q20_BC0 --rev_comp_mapping_barcodes -q 19 --max_barcode_errors 0
fi

echo `date`
echo -e "\nPick OTUs: Open Reference..." 
if [ "$ANALYSIS" == "16S" ]; then
#	echo -e "pick_closed_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 56 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax_SplitLib_"$RunName"_Q20_BC0"
#		pick_closed_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 56 -t /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/taxonomy/97_otu_taxonomy.txt -o closed97_gg13_8_wTax_SplitLib_"$RunName"_Q20_BC0
	echo -e "pick_open_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 56 -o open97_gg13_8_SplitLib_"$RunName"_Q20_BC0"
                pick_open_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /opt/shared/Qiime/1.8.0/gg_otus-13_8-release/rep_set/97_otus.fasta -aO 56 -o open97_gg13_8_SplitLib_"$RunName"_Q20_BC0
elif [ "$ANALYSIS" == "18S" ] ; then
	echo -e "pick_open_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /rdsi/acad/Refs/Silva_108/rep_set/Silva_108_rep_set.fna -aO 24 -o open97_Silva108_SplitLib_"$RunName"_Q20_BC0"
	pick_open_reference_otus.py -i SplitLib_"$RunName"_Q20_BC0/seqs.fna -r /rdsi/acad/Refs/Silva_108/rep_set/Silva_108_rep_set.fna -aO 24 -o open97_Silva108_SplitLib_"$RunName"_Q20_BC0
	echo -e "make_otu_table.py -i  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/final_otu_map.txt -t /rdsi/acad/Refs/Silva_108/taxa_mapping/Silva_108_taxa_mapping.txt -o  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/otu_table_w_tax.biom"
        make_otu_table.py -i  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/final_otu_map.txt -t /rdsi/acad/Refs/Silva_108/taxa_mapping/Silva_108_taxa_mapping.txt -o  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/otu_table_w_tax.biom
        make_otu_table.py -i  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/final_otu_map_mc2.txt -t /rdsi/acad/Refs/Silva_108/taxa_mapping/Silva_108_taxa_mapping.txt -o  open97_Silva108_SplitLib_"$RunName"_Q20_BC0/otu_table_mc2_w_tax.biom
fi

fi

