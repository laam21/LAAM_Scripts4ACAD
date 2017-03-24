cat *.fna.gz > seqs.fna

/localscratch/lweyrich/Files_for_PickOTUs/Tim_SoilMicrobiome/Data/Data/fasta_files_alldata_ITS

scp -r its_12_11_otus.tar.gz acad:/localscratch/lweyrich/Files_for_PickOTUs/Tim_SoilMicrobiome_ITS/REF_ITS/

module load Qiime

pick_open_reference_otus.py -i /localscratch/lweyrich/Files_for_PickOTUs/Tim_SoilMicrobiome_ITS/Data/seqs.fna -o pickOpenRefOTUs_Unite_20151119 -r /localscratch/lweyrich/Files_for_PickOTUs/Tim_SoilMicrobiome_ITS/REF_ITS/its_12_11_otus/rep_set/97_otus.fasta -a -O 24

make_otu_table.py -i pickOpenRefOTUs_Unite_20151119/final_otu_map.txt -t /localscratch/lweyrich/Files_for_PickOTUs/Tim_SoilMicrobiome_ITS/REF_ITS/its_12_11_otus/taxonomy/97_otu_taxonomy.txt -o pickOpenRefOTUs_Unite_20151119/otu_table_w_tax.biom
