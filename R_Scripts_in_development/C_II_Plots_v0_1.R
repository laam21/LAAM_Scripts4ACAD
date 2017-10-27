##### Reference mapping assembly Analysis Summaries.txt File
setwd("/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/0_MAPPING_ASSEMBLY/")
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

### Reads Mapped

#multiple scatterplots to explore the data
install.packages("GGally")
library(GGally)

#Summary all variables
theme_get()
theme_set(theme_gray()) #Big fonts
ggpairs(df, axisLabels = 'internal')

#     We investigate the number of reads Mapped from the total reads available in the pool.
#00
ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of Collapsed reads available for mapping') +
  geom_area(data = df, aes(x=Divergence,y=TotalEndogenous), color= "gray",position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of Collapsed reads available for mapping') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

# 1)  This number is the total reads AVAILABLE (reported using samtools stats)
ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of Collapsed reads available for mapping') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_01_Total_number_of_Collapsed_reads_available_for_mapping.png')

ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total number of Collapsed reads available for mapping') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_01b_Total_number_of_Collapsed_reads_available_for_mapping.png')

# 2)  This number is the total reads MAPPED (reported using samtools stats)
ggplot(aes(x=Divergence,y=MappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total number of Collapsed reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_02_Total_number_of_Collapsed_reads_mapped.png')

ggplot(aes(x=Divergence,y=MappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total number of Collapsed reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_02b_Total_number_of_Collapsed_reads_mapped.png')

# 3)  This is the percentage of reads MAPPED from total reads available (reported using samtools stats)
ggplot(aes(x=Divergence,y=PercMappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  ggtitle('Percentage Reads Mapped From Total reads available') +
  facet_grid(Tool~Contamination)+
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_03_Percentage_Mapped_from_Total_available.png')

ggplot(aes(x=Divergence,y=PercMappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  ggtitle('Percentage Reads Mapped From Total reads available') +
  facet_grid(Contamination~Tool)+
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_03b_Percentage_Mapped_from_Total_available.png')

# 4)  This is the percentage of reads MAPPED from total Endogenous reads available (reported using samtools stats), and grep
ggplot(aes(x=Divergence,y=((MappedReads/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage reads Mapped from Total endogenous') +
  scale_y_continuous(limits = c(0,115)) +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_04_Percentage_MappedReads_from_TotalEndogenous.png')

ggplot(aes(x=Divergence,y=((MappedReads/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage reads Mapped from Total endogenous') +
  scale_y_continuous(limits = c(0,115)) +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_04b_Percentage_MappedReads_from_TotalEndogenous.png')

# 5)  This is the percentage of reads MAPPED with minimum MQ30 from total Endogenous reads available (reported using samtools stats), and grep
ggplot(aes(x=Divergence,y=((MQ30MappedReads/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage reads Mapped with minimum MQ30 from Total endogenous') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_05_Percentage_MQ30MappedRead_from_TotalEndogenous.png')

ggplot(aes(x=Divergence,y=((MQ30MappedReads/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage reads Mapped with minimum MQ30 from Total endogenous') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_05b_Percentage_MQ30MappedRead_from_TotalEndogenous.png')

# 6)  This is the percentage of endogenous reads MAPPED with minimum MQ30 from total Endogenous reads available (reported using samtools stats), and grep
ggplot(aes(x=Divergence,y=((MQ30Endogenous/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage endogenous reads Mapped with minimum MQ30 from Total endogenous') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_06_Percentage_EndogenousMQ30_from_TotalEndogenous.png')

ggplot(aes(x=Divergence,y=((MQ30Endogenous/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage endogenous reads Mapped with minimum MQ30 from Total endogenous') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_06b_Percentage_EndogenousMQ30_from_TotalEndogenous.png')

# 7) This is the Percentage of Endogenous reads Mapped at MQ30 from the Total reads Mapped at MQ30(Proportion of endogenous from total mapped)
ggplot(aes(x=Divergence,y=((MQ30Endogenous/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_07_Percentage_Endogenous_MQ30_TotalMQ30Mapped.png')

ggplot(aes(x=Divergence,y=((MQ30Endogenous/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_07b_Percentage_Endogenous_MQ30_TotalMQ30Mapped.png')

# 8) This is the percentage of non-endogenous mapped reads with MQ>30
ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage non-endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30 (contamination)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_08_Percentage_NonEndogenous_MQ30_TotalMQ30Mapped.png')

ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage non-endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_08b_Percentage_NonEndogenous_MQ30_TotalMQ30Mapped.png')

# 9) Total number of endogenous mapped reads with MQ>30
ggplot(aes(x=Divergence,y=MQ30Endogenous),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total Endogenous reads Mapped with MQ>=30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_09_Total_Endogenous_MQ30.png')

ggplot(aes(x=Divergence,y=MQ30Endogenous),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total Endogenous reads Mapped with MQ>=30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_09b_Total_Endogenous_MQ30.png')


# 10) Total number of non-endogenous mapped reads with MQ>30
ggplot(aes(x=Divergence,y=(MQ30MappedReads-MQ30Endogenous)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Total non-endogenous reads Mapped with MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_10_Total_NonEndogenous_MQ30.png')

ggplot(aes(x=Divergence,y=(MQ30MappedReads-MQ30Endogenous)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Total non-endogenous reads Mapped with MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_10b_Total_NonEndogenous_MQ30.png')

# 11) Total number of mapped reads with MQ>30
ggplot(aes(x=Divergence,y=MQ30MappedReads),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Number of Reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_11_Total_Reads_MQ30_Mapped.png')

ggplot(aes(x=Divergence,y=MQ30MappedReads),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Number of Reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_11b_Total_Reads_MQ30_Mapped.png')

summary(df)

###################CORRECT MAPPING
df2 <- read.csv("Summaries_CorrectMapping.txt", sep = '\t')
names(df2)
head(df2, 10)
summary(df2)

#Give correct order to Factors
df2$Method <- factor(df2$Method, levels = c("MAPPING","REFGUIDED","ITERMAP"))
df2$Divergence <- factor(df2$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df2$Tool <- factor(df2$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA","mira"))
df2$Contamination <- factor(df2$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)
summary(df2)

# 12) Percentage Endogenous reads with MQ30 that mapped within correct coordinates from Total Endogenous with MQ30
ggplot(aes(x=Divergence,y=((MQ30EndoWithinStrict/MQ30EndoSumStrict)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('% Endogenous reads Mapped with MQ30 mapped within correct coordinates from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_12_Percentage_MappedWithinCoords_MQ30_TotalEndogenous_Strict.png')

ggplot(aes(x=Divergence,y=((MQ30EndoWithinStrict/MQ30EndoSumStrict)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('% Endogenous reads Mapped with MQ30 mapped within correct coordinates from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_12b_Percentage_MappedWithinCoords_MQ30_TotalEndogenous_Strict.png')


# 13) Percentage Endogenous reads with MQ30 that mapped within (50bp+-) correct coordinates from Total Endogenous with MQ30
ggplot(aes(x=Divergence,y=((MQ30EndoWithin50/MQ30EndoSum50)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('% Endogenous reads Mapped with MQ30 mapped within correct coordinates from Total endogenous Mapped (50bp)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_13_Percentage_MappedWithinCoords_MQ30_TotalEndogenous_50bp.png')

ggplot(aes(x=Divergence,y=((MQ30EndoWithin50/MQ30EndoSum50)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('% Endogenous reads Mapped with MQ30 mapped within correct coordinates from Total endogenous Mapped(50bp)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_13b_Percentage_MappedWithinCoords_MQ30_TotalEndogenous_50bp.png')

##
#ggplot(aes(x=Divergence,y=MQ30EndoWithinStrict),data=df2)+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~TypeReads)+
#  ggtitle('Total Endogenous reads Mapped within the original coordinates (strict) at MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")
#ggsave('C_II_MAP_Total_MappedWithinCoords_MQ30_Strict.png')

#ggplot(aes(x=Divergence,y=((MQ30EndoOutsideStrict/MQ30Endogenous)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Percentage Endogenous reads Mapped Outside of the original coordinates at MQ30 from Total endogenous Mapped') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAP_Percentage_MappedOutsideCoords_MQ30_TotalEndogenous_Strict.png')

#ggplot(aes(x=Divergence,y=MQ30EndoOutsideStrict),data=subset(df2,Divergence=='MUTATEDNONE0'))+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~Contamination)+
#  ggtitle('Total Endogenous reads Mapped Outside of the original coordinates at MQ30') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAP_Total_MappedOutsideCoords_MQ30_Strict.png')

#ggplot(aes(x=Divergence,y=((MQ30EndoWithin50/MQ30Endogenous)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~TypeReads)+
#  ggtitle('Percentage Endogenous reads Mapped within the original coordinates (-+50) at MQ30 from Total endogenous Mapped') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAP_Percentage_MappedWithinCoords_MQ30_TotalEndogenous50.png')

#ggplot(aes(x=Divergence,y=((MQ30EndoOutside50/MQ30Endogenous)*100)),data=subset(df2,Divergence=='MUTATEDNONE0'))+
#  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
#  facet_grid(Tool~TypeReads)+
#  ggtitle('Percentage Endogenous reads Mapped Outside of the original coordinates(+-50) at MQ30 from Total endogenous Mapped') +
#  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

#ggsave('C_II_MAP_Percentage_MappedOutsideCoords_MQ30_TotalEndogenous50.png')

# 14) Percentage Endogenous reads Mapped in RNA regions at MQ30 from Total endogenous Reads Mapped in RNA regions
# this is, the proportion of reads that we will loose by masking this coordinates
ggplot(aes(x=Divergence,y=((EndoRNA/MQ30Endogenous)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Percentage Endogenous reads Mapped in RNA Regions at MQ30 from Total endogenous Reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_14_Percentage_Endo_Mapped_MQ30_inRNAcoords_from_Total_endogenous_mapped.png')

ggplot(aes(x=Divergence,y=((EndoRNA/MQ30Endogenous)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Percentage Endogenous reads Mapped in RNA Regions at MQ30 from Total endogenous Reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_14b_Percentage_Endo_Mapped_MQ30_inRNAcoords_from_Total_endogenous_mapped.png')

# 15) Percentage Non-Endogenous reads Mapped in RNA regions at MQ30 from Total Non-endogenous reads Mapped
# this is, how many Non-endogenou reads can we get rid off by masking this coordinates
ggplot(aes(x=Divergence,y=((MQ30MappedReads-MQ30Endogenous)-(TotalRNA-EndoRNA))  ),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~Contamination)+
  ggtitle('Number of Non Endogenous Mapped at MQ30 excluding non-endo Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_15_Total_NonEndo_Mapped_inRNACoords.png')

ggplot(aes(x=Divergence,y=((MQ30MappedReads-MQ30Endogenous)-(TotalRNA-EndoRNA))  ),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Contamination~Tool)+
  ggtitle('Number of Non Endogenous Mapped at MQ30 excluding non-endo Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAPPING_15b_Total_NonEndo_Mapped_inRNACoords.png')



ggplot(aes(x=Divergence,y=(((TotalRNA-EndoRNA)/MQ30MappedReads)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous Mapped within RNA regions from Total Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_NonEndo_Mapped_inRNACoords_Totalmapped_MQ30.png')

ggplot(aes(x=Divergence,y=(((MQ30MappedReads-TotalRNA)/MQ30MappedReads)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Mapped at MQ30 excluding Reads Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")


ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)-(TotalRNA-EndoRNA))/MQ30MappedReads)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous Mapped outside RNA regions from Total Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_NonEndo_Mapped_outRNACoords_Totalmapped_MQ30.png')


ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)-(TotalRNA-EndoRNA))/MQ30MappedReads)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous Mapped outside RNA regions from Total Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_NonEndo_Mapped_outRNACoords_Totalmapped_MQ30.png')
