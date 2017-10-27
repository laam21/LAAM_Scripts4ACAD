##### Reference ASSISTED assembly Analysis Summaries.txt File
setwd("/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/1_REF_ASSIST_ASSEMBLY/")
getwd()
list.files()
df <- read.csv("Summaries.txt", sep = '\t')
names(df)
head(df)
summary(df)

#Give correct order to Factors
df$Method <- factor(df$Method, levels = c("MAPPING","REFGUIDED","ITERMAP"))
df$Divergence <- factor(df$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df$Tool <- factor(df$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA","mira"))
df$Contamination <- factor(df$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)

### Contgs Mapped (reference assited assembly)

#     We investigate the number of contigs Mapped from the total reads available in the pool.
# 1)  This number is the total contigs AVAILABLE (reported using samtools stats)
ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of contigs available for mapping') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_01_Total_number_of_Contigs_available_for_mapping.png')

ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total number of contigs available for mapping') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_01b_Total_number_of_Contigs_available_for_mapping.png')

# 2)  This number is the total number of contigs MAPPED (reported using samtools stats)
ggplot(aes(x=Divergence,y=MappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of contigs Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_02_Total_number_of_contigs_mapped.png')

ggplot(aes(x=Divergence,y=MappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total number of contigs Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_02b_Total_number_of_contigs_mapped.png')

# 3)  This is the percentage of contigs MAPPED from total available (reported using samtools stats)
ggplot(aes(x=Divergence,y=PercMappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  ggtitle('Percentage Contigs Mapped From Total available') +
  facet_grid(Tool~Contamination)+
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_03_Percentage_Mapped_contigs_from_Total_available.png')

ggplot(aes(x=Divergence,y=PercMappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  ggtitle('Percentage Contigs Mapped From Total available') +
  facet_grid(Contamination~Tool)+
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_03b_Percentage_Mapped_contigs_from_Total_available.png')

# 4)  This is the percentage of contigs MAPPED from total Endogenous reads available (reported using samtools stats), and grep
#ggplot(aes(x=Divergence,y=((MappedReads/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage reads Mapped from Total endogenous') +
#  scale_y_continuous(limits = c(0,115)) +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_04_Percentage_MappedReads_from_TotalEndogenous.png')

#ggplot(aes(x=Divergence,y=((MappedReads/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Percentage reads Mapped from Total endogenous') +
#  scale_y_continuous(limits = c(0,115)) +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_04b_Percentage_MappedReads_from_TotalEndogenous.png')

# 5)  This is the percentage of reads MAPPED with minimum MQ30 from total Endogenous reads available (reported using samtools stats), and grep
#ggplot(aes(x=Divergence,y=((MQ30MappedReads/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage reads Mapped with minimum MQ30 from Total endogenous') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_05_Percentage_MQ30MappedRead_from_TotalEndogenous.png')

#ggplot(aes(x=Divergence,y=((MQ30MappedReads/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Percentage reads Mapped with minimum MQ30 from Total endogenous') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_05b_Percentage_MQ30MappedRead_from_TotalEndogenous.png')

# 6)  This is the percentage of endogenous reads MAPPED with minimum MQ30 from total Endogenous reads available (reported using samtools stats), and grep
#ggplot(aes(x=Divergence,y=((MQ30Endogenous/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage endogenous reads Mapped with minimum MQ30 from Total endogenous') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_06_Percentage_EndogenousMQ30_from_TotalEndogenous.png')

#ggplot(aes(x=Divergence,y=((MQ30Endogenous/TotalEndogenous)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Percentage endogenous reads Mapped with minimum MQ30 from Total endogenous') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_06b_Percentage_EndogenousMQ30_from_TotalEndogenous.png')

# 7) This is the Percentage of Endogenous reads Mapped at MQ30 from the Total reads Mapped at MQ30(Proportion of endogenous from total mapped)
#ggplot(aes(x=Divergence,y=((MQ30Endogenous/MQ30MappedReads)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_07_Percentage_Endogenous_MQ30_TotalMQ30Mapped.png')

#ggplot(aes(x=Divergence,y=((MQ30Endogenous/MQ30MappedReads)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_07b_Percentage_Endogenous_MQ30_TotalMQ30Mapped.png')

# 8) This is the percentage of non-endogenous mapped reads with MQ>30
#ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)/MQ30MappedReads)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage non-endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30 (contamination)') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_08_Percentage_NonEndogenous_MQ30_TotalMQ30Mapped.png')

#ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)/MQ30MappedReads)*100)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Percentage non-endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_08b_Percentage_NonEndogenous_MQ30_TotalMQ30Mapped.png')

# 9) Total number of endogenous mapped reads with MQ>30
ggplot(aes(x=Divergence,y=MQ30Endogenous),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total Endogenous reads Mapped with MQ>=30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_09_Total_Endogenous_MQ30.png')

#ggplot(aes(x=Divergence,y=MQ30Endogenous),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Total Endogenous reads Mapped with MQ>=30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_09b_Total_Endogenous_MQ30.png')


# 10) Total number of non-endogenous mapped reads with MQ>30
#ggplot(aes(x=Divergence,y=(MQ30MappedReads-MQ30Endogenous)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Total non-endogenous reads Mapped with MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_10_Total_NonEndogenous_MQ30.png')

#ggplot(aes(x=Divergence,y=(MQ30MappedReads-MQ30Endogenous)),data=df)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Contamination~Tool)+
#  ggtitle('Total non-endogenous reads Mapped with MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAPPING_10b_Total_NonEndogenous_MQ30.png')

# 11) Total number of mapped contigs with MQ>30
ggplot(aes(x=Divergence,y=MQ30MappedReads),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Number of Contigs Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_11_Total_contigs_MQ30_Mapped.png')

ggplot(aes(x=Divergence,y=MQ30MappedReads),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Number of Contigs Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_REFASSEMBLY_11b_Total_Reads_MQ30_Mapped.png')

summary(df)

###################CORRECT MAPPING
setwd("../")
getwd()
list.files()
df3 <- read.csv("SummariesRefMap_RefAssem_IterMap.txt", sep = '\t')
names(df3)
head(df3, 10)
summary(df3$Tool)

#Give correct order to Factors
df3$Method <- factor(df3$Method, levels = c("MAPPING","REFGUIDED","ITERMAP"))
df3$Divergence <- factor(df3$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df3$Tool <- factor(df3$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA","mira","mbim"))
df3$Contamination <- factor(df3$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)
summary(df3)

# 00) Number of base pairs covered with MQ30 data
ggplot(aes(x=Divergence,y=MQ30Coverage),data=df3)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination ~Method + Tool)+
  ggtitle('Number of base pairs covered with MQ30 (Coverage)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_REFASSEMBLY_ITERMAP_00_MQ30_Coverage.png')

ggplot(aes(x=Divergence,y=MQ30Coverage),data=df3)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Method +Tool~Contamination)+
  ggtitle('Number of base pairs MQ30 with MQ30 (Coverage)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_REFASSEMBLY_00b_MQ30_Coverage.png')


# 01) Depth of coverage
ggplot(aes(x=Divergence,y=MQ30DepthCov),data=df3)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination ~Method + Tool)+
  ggtitle('Depth of Coverage with MQ30 data') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_REFASSEMBLY_01_MQ30_DepthOfCoverage.png')

ggplot(aes(x=Divergence,y=MQ30DepthCov),data=df3)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Method  ~ Tool+ Contamination)+
  ggtitle('Depth of Coverage with MQ30 data') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_REFASSEMBLY_01c_MQ30_DepthOfCoverage.png')



#MixOmics
install.packages("mixOmics")
library(mixOmics)
sessionInfo()
install.packages("rgl")
library(rgl)require("rgl")

install.packages()



setwd("/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/3A_MUTATEDNONE/quast_results_MUTATEDNONE0_ALL/results_2017_09_27_04_47_51/")
getwd()
list.files()
list.files()
df_mnone <- read.csv("MUTATEDNONE0_QUAST_transposed_report.txt", sep = '\t')
names(df_mnone)
head(df_mnone, 10)
summary(df_mnone)

#Give correct order to Factors
df_mnone$Method <- factor(df_mnone$Method, levels = c("MAPPING","REFGUIDED","ITERMAP"))
df_mnone$Divergence <- factor(df_mnone$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df_mnone$Tool <- factor(df_mnone$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA","mira","mbim"))
df_mnone$Contamination <- factor(df_mnone$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)

ggplot(aes(x=Divergence,y=(Genome.fraction....)),data=df_mnone)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Genome Fraction recovered with final consensus sequence (Contigs)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggplot(aes(x=Divergence,y=X..mismatches.per.100.kbp),data=df_mnone)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Percentage lenght recovered with final consensus sequence (Contigs)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")



##QUAST
setwd("/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/A_FINAL_CONTIGS/")
getwd()
list.files()
df_quast <- read.csv("ALL_QUAST_transposed_report.txt", sep = '\t')
names(df_quast)
head(df_quast, 10)
summary(df_quast)

#Give correct order to Factors
df_quast$Method <- factor(df_quast$Method, levels = c("MAPPING","REFGUIDED","ITERMAP"))
df_quast$Divergence <- factor(df_quast$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df_quast$Tool <- factor(df_quast$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA","mira","mbim"))
df_quast$Contamination <- factor(df_quast$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
df_quast$Genome.fraction....=as.numeric(levels(df_quast$Genome.fraction....))[df_quast$Genome.fraction....]
df_quast$X..mismatches.per.100.kbp=as.numeric(levels(df_quast$X..mismatches.per.100.kbp))[df_quast$X..mismatches.per.100.kbp]
df_quast$Largest.alignment=as.numeric(levels(df_quast$Largest.alignment))[df_quast$Largest.alignment]


install.packages("GGally")
library(GGally)

library(ggplot2)
ggpairs(df_quast)

ggplot(aes(x=Divergence,y=(Genome.fraction....)),data=subset(df_quast,Method!="REFGUIDED" ))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Genome Fraction recovered with final consensus sequence (Contigs)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom") 

ggsave('C_II_GENOME_FRACTION_recovered.png')

ggplot(aes(x=Divergence,y=(Genome.fraction....)),data=df_quast)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Genome Fraction recovered with final consensus sequence (Contigs)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom") 

ggsave('C_II_GENOME_FRACTION_recovered_ALL.png')


ggplot(aes(x=Divergence,y=(Genome.fraction....)),data=subset(df_quast,Divergence="MUTATEDNONE0" ))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Genome Fraction recovered with final consensus sequence (Contigs)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")


ggplot(aes(x=Divergence,y=X..mismatches.per.100.kbp),data=subset(df_quast,Method!="REFGUIDED" ))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Mismatches per 100kbp') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")


ggplot(aes(x=Divergence,y=X..N.s.per.100.kbp),data=subset(df_quast,Method!="REFGUIDED" ))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Percentage Ns per 100kbp') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggplot(aes(x=Divergence,y=Largest.alignment),data=subset(df_quast,Method!="REFGUIDED" ))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~  Method + Tool )+
  ggtitle('Largest alignment') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")
