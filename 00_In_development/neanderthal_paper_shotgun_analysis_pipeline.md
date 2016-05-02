#NEANDERTHAL PAPER SHOTGUN ANALYSIS PIPELINE:

## DEMULTIPLEXING AND ADAPTER TRIMMING
###	Samples were demultiplexed by barcodes using ACAD's Next Generation Sequencing (NGS) pipeline
#### Script:
	- ngs1_barcodes_sabre.sh
#### Programs(version):
	- sabre/20131121-gnu_4.8.0
#### Input DATA:
	- RIGHT_BARCODES:	barcodes_R2.txt
	- LEFT_BARCODES:	barcodes_R1_r<RIGHT_BC>.txt
	- FASTQ_FILES:		<FASTQ_FILE>_R1.fastqc
						<FASTQ_FILE>_R2.fastqc

### Adapters were trimmed and reads were collapsed using ACAD's NGS pipeline.
#### Script:
	- ngs2_adapters_AdapterRemovalPE_sabre.sh
#### Programs(version):
	AdapterRemoval/1.5.2-gnu_4.8.0
##### Parameters:
	- collapse
	- minlenght:	25
	- quality:		4
	- mismatcherate:0.1
	- minoverlap:	11bp
#### Input DATA:
	- DEMULTIPLEXED_FASTQ_FILES
	- ADAPTERS:			adapters_AdapterRemoval.txt

## METAGENOMIC ALIGNMENT
### Database indexing was performed using a modified wrapper script
#### Script:
	- build-index_MALT2
#### Programs(version):
	- malt-build  (version 0.0.12, built 20 Nov 2014)
#### Parameters:
	- tre	ncbi.tre.gz
	- map	ncbi.map.gz
	- cmf	cog.map.gz
	- g2k	gi2kegg-new.map.gz
	- g2t	gi_taxid_prot-2014Jan04.bin
	- r2k	ref2kegg.map.gz
	- r2c	ref2cog.map.gz
	- r2s	ref2seed.map.gz
#### Input DATA:
	- NCBI nr database 2014 (semester 2)
### Reads were aligned using a wrapper script
#### Script:
	- malt_multi.sh
#### Programs:
	- malt-run	(version 0.0.12, built 20 Nov 2014)
#### Parameters:
	- BlastX
	- RMA
	
