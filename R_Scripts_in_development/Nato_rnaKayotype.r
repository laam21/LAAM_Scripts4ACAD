### NATOS DATA
setwd("Downloads/")
getwd()

list.files()
df <- read.csv("", sep = '\t')


### GGBIO:
## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
biocLite("ggbio")

browseVignettes("ggbio")
library(ggbio)
p.ideo <-Ideogram(genome = "hg19")
p.ideo
library(GenomicRanges)
p.ideo + xlim(GRanges("chr2", IRanges(1e8,1e8+10000000)))
p.ideo + xlim(GRanges("chr2", IRanges(1e8, 1e8+10000000)))

data(ideoCyto, package = "biovizBase")
autoplot(seqinfo(ideoCyto$hg19), layout = "karyogram")
biovizBase::isIdeogram(ideoCyto$hg19)
autoplot(ideoCyto$hg19, layout = "karyogram", cytoband = TRUE)

##GENOMATION: Transform BED files into  GRanges (https://rdrr.io/bioc/genomation/man/readBed.html)
source("https://bioconductor.org/biocLite.R")
biocLite("genomation")
library(genomation)
nato_bed= readBed("/Users/Annarielh/Downloads/Gscan_example_chr9_117799090_117799203_31_r_-_NA_cmCD.bed12", track.line = "auto")
head(nato_bed)
summary(nato_bed)
nato_bed2= readBed("/Users/Annarielh/Downloads/Gscan_example_chr1_149400063_149400167_23_s_-_NA_cmCD.bed12", track.line ="au")
head(nato_bed2)
summary(nato_bed2)
nato_bed3= readBed("/Users/Annarielh/Downloads/Gscan_example_chr17_66147519_66147717_26_r_-_NA_cmCD.bed12", track.line ="au")
head(nato_bed3)
summary(nato_bed3)


autoplot(nato_bed, layout = "karyogram")
autoplot(nato_bed2, layout = "karyogram")
autoplot(nato_bed3, layout = "karyogram")


autoplot(nato_bed, layout = "karyogram", color = "blue")
autoplot(nato_bed2, layout = "karyogram", color = "blue")


autoplot(nato_bed, layout = "karyogram", color = "red", geom = "rect")

autoplot(nato_bed, layout = "karyogram", color = "red", geom = "rect", ylim = c(-11,0)) 
autoplot(nato_bed2, layout = "karyogram", color = "blue", geom = "rect", ylim = c(11,21)) 
autoplot(nato_bed3, layout = "karyogram", color = "green", geom = "rect", ylim = c(-11,0)) 


autoplot(nato_bed, layout = "karyogram", color = "red", geom = "rect", ylim = c(11,21)) + autoplot(hg19, cytoband=TRUE)


###Test
library(ggbio)
data(hg19IdeogramCyto, package ="biovizBase")
head(hg19IdeogramCyto)
getOption("biovizBase")$cytobandColor
autoplot(hg19IdeogramCyto, layout = "karyogram", cytoband = TRUE)

library(GenomicRanges)
hg19 <- keepSeqlevels(hg19IdeogramCyto, paste0("chr", c(1:22, "X", "Y")))
head(hg19)
autoplot(hg19, layout = "karyogram", cytoband = TRUE)


nato_bed= readBed("/Users/Annarielh/Downloads/Gscan_example_chr9_117799090_117799203_31_r_-_NA_cmCD.bed12", track.line = "auto")
head(nato_bed)
summary(nato_bed)
autoplot(nato_bed, layout = "karyogram" )

p <- ggplot(hg19) + layout_karyogram(cytoband=TRUE)
p <-ggplot(hg19) + layout_karyogram(cytoband=TRUE) + theme(legend.position="none", axis.text=element_text(size=10), axis.title=element_text(size=10,face="bold"))

p <- ggplot(hg19) + layout_karyogram(cytoband=TRUE) + theme(legend.position="none")

p + layout_karyogram(nato_bed, color = "red", geom = "rect", ylim = c(11,21)) + layout_karyogram(nato_bed2, color = "blue", geom = "rect", ylim = c(-11,0))
p + layout_karyogram(nato_bed, color = "red", geom = "rect", ylim = c(11,22))+ layout_karyogram(nato_bed2, color = "white", geom = "rect", ylim = c(-11,-3)) + layout_karyogram(nato_bed3, color = "white", geom = "rect", ylim = c(-11,-3))
ggsave('NR5150_NR1100_R11506.pdf')

p + layout_karyogram(nato_bed, color = "red", geom = "rect") + layout_karyogram(nato_bed2, color = "blue", geom = "rect")
p + layout_karyogram(nato_bed, color = "red", geom = "rect") + layout_karyogram(nato_bed2, color = "blue", geom = "rect") + layout_karyogram(nato_bed3, color = "green", geom = "rect")

setwd("/Users/Annarielh/Desktop")

P <- p + autoplot(nato_bed, layout = "karyogram", color = "red", geom = "rect", ylim = c(11,21))
p
  
p1 <- p + layout_karyogram(nato_bed, color = "red", geom = "rect")
p1
getwd()
