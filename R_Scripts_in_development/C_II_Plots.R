##### Reference mapping assembly Analysis Summaries.txt File
setwd("/Volumes/ACADretina1_Backup/PHD/CHAPTER2_DATA/1708014_SMUTANS_MAPPING_TEST/2_Analyses/0_MAPPING_ASSEMBLY/")
getwd()
list.files()
df <- read.csv("Summaries.txt", sep = '\t')
names(df)
head(df)
summary(df)

#Give correct order to Factors
df$Method <- factor(df$Method, levels = c("MAPPING","REFASSEMB","ITERMAP"))
df$Divergence <- factor(df$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df$Tool <- factor(df$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA"))
df$Contamination <- factor(df$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)

### % Total Reads Mapped

#ggplot(aes(x=Method,y=PercMappedReads),data=df)+ 
#  geom_point(aes(color=Tool, shape=Deamination), position = position_dodge(width = .9)) +
#  facet_wrap(~Divergence) +
#  ggtitle('Percentage Covered')+
#  theme(axis.text.x = element_text(angle=90, hjust = 1))

ggplot(aes(x=Divergence,y=TotalReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Total Reads Mapped (Collapsed and Not Collapsed)') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Total_Mapped.png')


ggplot(aes(x=Divergence,y=PercMappedReads),data=df)+ 
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Reads Mapped From Total') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_Mapped_Total.png')


ggplot(aes(x=Divergence,y=((MQ30Endogenous/TotalEndogenous)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total endogenous') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_Endogenous_MQ30_TotalEndogenous.png')


ggplot(aes(x=Divergence,y=((MQ30Endogenous/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped at MQ30 from Total reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_Endogenous_MQ30_TotalMapped.png')


ggplot(aes(x=Divergence,y=MQ30Endogenous),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Total Endogenous reads Mapped with MQ>=30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Total_Endogenous_MQ30.png')



ggplot(aes(x=Divergence,y=(((MQ30MappedReads-MQ30Endogenous)/MQ30MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous reads Mapped at MQ30 from Total reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_NonEndogenous_MQ30_Mapped_TotalMapped.png')

ggplot(aes(x=Divergence,y=((MQ30MappedReads/MappedReads)*100)),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Pecentage Reads Mapped at MQ30 from total reads Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_Reads_MQ30_Mapped_TotalMapped.png')

ggplot(aes(x=Divergence,y=MQ30MappedReads),data=df)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Number of Reads Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Total_Reads_MQ30_Mapped.png')

###################CORRECT MAPPING
df2 <- read.csv("Summaries_CorrectMapping.txt", sep = '\t')
names(df2)
head(df2)
summary(df2)

#Give correct order to Factors
df2$Method <- factor(df2$Method, levels = c("MAPPING","REFASSEMB","ITERMAP"))
df2$Divergence <- factor(df2$Divergence, levels = c("MUTATEDNONE0","MUTATEDLOW1","MUTATEDLOW2","MUTATEDHIGH1","MUTATEDHIGH2"))
df2$Tool <- factor(df2$Tool, levels = c("bwaaln","bwaaDNA","bwamem","bowtie2","bowtie2Vsens","bowtie2aDNA"))
df2$Contamination <- factor(df2$Contamination, levels = c("0C100E","90C10E","80CSmu20E"))
library(ggplot2)

ggplot(aes(x=Divergence,y=((MQ30EndoWithinStrict/MQ30EndoSumStrict)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped within the original coordinates (strict) at MQ30 from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_MappedWithinCoords_MQ30_TotalEndogenous_Strict.png')


ggplot(aes(x=Divergence,y=MQ30EndoWithinStrict),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Total Endogenous reads Mapped within the original coordinates (strict) at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Total_MappedWithinCoords_MQ30_Strict.png')



ggplot(aes(x=Divergence,y=((MQ30EndoOutsideStrict/MQ30Endogenous)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped Outside of the original coordinates at MQ30 from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_MappedOutsideCoords_MQ30_TotalEndogenous_Strict.png')

ggplot(aes(x=Divergence,y=MQ30EndoOutsideStrict),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Total Endogenous reads Mapped Outside of the original coordinates at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Total_MappedOutsideCoords_MQ30_Strict.png')


ggplot(aes(x=Divergence,y=((MQ30EndoWithin50/MQ30Endogenous)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped within the original coordinates (-+50) at MQ30 from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_MappedWithinCoords_MQ30_TotalEndogenous50.png')

ggplot(aes(x=Divergence,y=((MQ30EndoOutside50/MQ30Endogenous)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped Outside of the original coordinates(+-50) at MQ30 from Total endogenous Mapped') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_MappedOutsideCoords_MQ30_TotalEndogenous50.png')

ggplot(aes(x=Divergence,y=((EndoRNA/TotalRNA)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Endogenous reads Mapped in RNA Regions at MQ30 from Total Reads Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_Endo_Mapped_MQ30_Totalmapped_inRNACoords.png')

ggplot(aes(x=Divergence,y=(((MQ30MappedReads-TotalRNA)/MQ30MappedReads)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Mapped at MQ30 excluding Reads Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggplot(aes(x=Divergence,y=(((TotalRNA-EndoRNA)/MQ30MappedReads)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous Mapped at MQ30 excluding Reads Mapped in RNA regions') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggplot(aes(x=Divergence,y=(((TotalRNA-EndoRNA)/MQ30MappedReads)*100)),data=df2)+
  geom_point(aes(color=Tool, shape=Contamination, alpha=Deamination), position = position_dodge(width = .5), size=2.5) +
  facet_grid(Tool~TypeReads)+
  ggtitle('Percentage Non Endogenous Mapped within RNA regions from Total Mapped at MQ30') +
  theme(axis.text.x = element_text(angle=90, hjust = 0), legend.position = "bottom")

ggsave('C_II_MAP_Percentage_NonEndo_Mapped_inRNACoords_Totalmapped_MQ30.png')


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
