##### Genomic Variant Annotation on ancient Hominins

# LIBRARIES
## Installing packages
source("http://bioconductor.org/biocLite.R")
biocLite("VariantAnnotation")
biocLite("cgdv17")               ##Complete Genomics Fiversity panel data for Chr 17 on 46 individuals
browseVignettes("cgdv17")        ## Vignette of the dataset
biocLite("org.Hs.eg.db")
biocLite("BSgenome.Hsapiens.UCSC.hg19")
biocLite("PolyPhen.Hsapiens.dbSNP131")

## Loading the packages
library(VariantAnnotation)
library(cgdv17)
library(org.Hs.eg.db)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(BSgenome.Hsapiens.UCSC.hg19)
library(PolyPhen.Hsapiens.dbSNP131)

## DATA
### VCF
### Loading Data (example data from package)
file <- system.file("vcf", "NA06985_17.vcf.gz", package = "cgdv17")

# Checking the header. scanVcfHeader() parses the file header into a VCFHeader object and info() and geno() accessors field-specific data
hdr <- scanVcfHeader(file)      # Creates data structure with the info of the header of the VCF file
info(hdr)
geno(hdr)
meta(hdr)$META  #Useful to check metadata info: fileformat fileData source reference and phasing

## GENES OF INTEREST DATA
# The package org.Hs.eg.db allow us to convert gene symbols to gene ids
# Get entrez ids from gene symbols
genesym <- c("TRPV1", "TRPV2", "TRPV3", "FZD6") # List of genes of interest
geneid <- select(org.Hs.eg.db, keys=genesym, keytype="SYMBOL", columns = "ENTREZID")    # Mapping between keys and columns
geneid  # Print list

# The annotation package TxDB.Hsapiens.UCSC.hg19.knownGene contains GenomicFeatures info of genes in the genome browse of UCSC
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
txdb
head(seqlevels(txdb))  #to determine which chromosomes are currently active we use the seqlevels method
#* seqlevels(txdb) <- "chr1"  #Use this to make all the analysis on an specific chromosome
#* seqlevels(txdb) <- seqlevels0(txdb)  # reset back to the original levels


#Sometimes the VCF files are aligned to a diferent genetracks with different nomenclatures of Chromosome names. To use them together we need to modify them to match
txdb <- renameSeqlevels(txdb, gsub("chr", "",seqlevels(txdb)))
txdb <- keepSeqlevels(txdb, "17") # Seqlevels allow us to modify data stored in a data structure

#*  columns(txdb) # allows to check the different columns
#* keytypes(txdb) # allows to see the different keytypes

# Create list of transcripts by gene
GR <- transcripts(txdb)
GR[1:3]
vals <- list(tx_chrom = "chr17", tx_strand = "+")
GR <- transcripts(txdb, vals)
length(GR)
unique(strand(GR))
EX <- exons(txdb)
EX[1:4]
length(GR)
length(EX)

txbygene <- transcriptsBy(txdb, by = "gene")  # genomic features of a given type extracted by another type
length(txbygene)
names(txbygene)[10:13]
txbygene[11:12]
tx_ids <- names(txbygene)
tx_ids
columns(txdb)


keys<- c(geneid$ENTREZID)
keys
columns(txdb)
keytypes(txdb)
select(txdb, keys= keys, columns="TXNAME",keytype="TXID")

cols<- c("TXNAME", "TXSTRAND", "TXCHROM")
select(txdb, keys=keys, columns=cols, keytype="GENEID")

names(txbygene)


geneid$ENTREZID[1]

txbygene[c(geneid$ENTREZID)]


# Create the gene ranges for the TRPV genes
gnrng <- unlist(range(txbygene[geneid$ENTREZID[1]]), use.names = FALSE)
names(gnrng) <- geneid$SYMBOL[1]

param <- ScanVcfParam(which = gnrng, info = "DP", geno = c("GT", "cPd"))
param

## Extract the TRPV ranges from the VCF file 
vcf <- readVcf(file, "hg19", param)
info(vcf)
fixed(vcf)
geno(vcf)
vcf
head(fixed(vcf))


## VARIANT LOCATIONIN THE GENE MODEL
## 'locateVariants' function identifies where a variant falls with respect to gene structure (e.g. exon, utr, splice site, etc)
cds <- locateVariants(vcf, txdb, CodingVariants())
five <- locateVariants(vcf, txdb, FiveUTRVariants())
splice <- locateVariants(vcf, txdb, SpliceSiteVariants())
intron <- locateVariants(vcf, txdb, IntronVariants())

all <- locateVariants(vcf, txdb, AllVariants())

## Did any variants match more than one gene?
table(sapply(split(mcols(all)$GENEID, mcols(all)$QUERYID), 
             function(x) length(unique(x)) > 1))

## Summarize the number of variants by gene:
idx <- sapply(split(mcols(all)$QUERYID, mcols(all)$GENEID), unique)
sapply(idx, length)

sapply(names(idx), 
       function(nm) {
         d <- all[mcols(all)$GENEID %in% nm, c("QUERYID", "LOCATION")]
         table(mcols(d)$LOCATION[duplicated(d) == FALSE])
       })


## AMINOACID CODING CHANGES IN NON-SYNONYMOUS VARIANTS
# Aminoacid coding fpr non-synonymous variants can be computed with the function predict Coding. The BSgenome package is used as the source of the
# reference alleles. Variant alleles are provided by the user
library(BSgenome.Hsapiens.UCSC.hg19)
seqlevelsStyle(vcf) <-"UCSC"
seqlevelsStyle(txdb) <- "UCSC"
aa <- predictCoding(vcf, txdb, Hsapiens)


## Did any variants match more than one gene?
table(sapply(split(mcols(aa)$GENEID, mcols(aa)$QUERYID), 
             function(x) length(unique(x)) > 1))

## Summarize the number of variants by gene:
idx <- sapply(split(mcols(aa)$QUERYID, mcols(aa)$GENEID, drop=TRUE), unique)
sapply(idx, length)

## Summarize variant consequence by gene:
sapply(names(idx), 
       function(nm) {
         d <- aa[mcols(aa)$GENEID %in% nm, c("QUERYID","CONSEQUENCE")]
         table(mcols(d)$CONSEQUENCE[duplicated(d) == FALSE])
       })

### ANNOTATING WITH THE ensembleVEP package
biocLite("ensemblVEP")
library(ensemblVEP)
dest <- tempfile()
writeVcf(vcf, dest)

gr <- ensemblVEP(file = dest)

