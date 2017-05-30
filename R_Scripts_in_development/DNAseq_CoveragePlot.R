##### DNA-Seq Coverage Visualisation
# Duke University Genome Sequencing and Analysis Core Resource 
# (https://sites.duke.edu/sequencingatduke/how-to-vizualise-your-dna-seq-coverage/)
# Install ggplot2
install.packages("ggplot2")
# Load library ggplot2
library("ggplot2")
require(ggplot2)

#Function "slidingwindowplot" takes size of window and sequence as input parameters
slidingwindowplot <- function(windowsize, inputseq)
{
  starts <- seq(1, length(inputseq)-windowsize, by = windowsize)
  n <- length(starts)
  chunkbps <- numeric(n)
  chunkstats <- numeric(n)
  for (i in 1:n){
    chunk <- inputseq[starts[i]:(starts[i]+windowsize-1)] 
    chunkmean <- mean(chunk)
    chunkstdv <- sd(chunk)
    chunkbps[i] <- chunkmean
    chunkstats[i] <- chunkstdv
  }
  return (list(starts,chunkbps,chunkstats))
}

# Windows size and Max Y
binSize <- 1000
maxy <- 25

#types of columns String-field "chromosome", numeric-field "position", numeric-field  "coverage"
column.types <- c("character", "numeric", "numeric")
#Loading the data from comma separated input file (from CoverageBed), with no header, separated by tabs and with the column types previously identified
all.data <- read.csv(file ="/Volumes/ACADretina1_Backup/CHAPTER2_DATA/SMUTANS_MAPPING_TEST/2_Analyses/WHOLE_GENOME/RESULTS_MAP/SmutansUA159_MutatedHigh1_SWRECKED_Deam1.fasta_bowtie2_aDNA.sort.txt" , header=FALSE, sep="\t", colClasses=column.types)

#Get all the coverage data into a vector and run sliding window function
myvector_all <- as.vector(as.matrix(all.data[3]))
windowAll <-slidingwindowplot(binSize,myvector_all)
#Create a data frame with the output of slidingwindow with starts, mean,standard deviation
df<-data.frame(windowAll[[1]],windowAll[[2]],windowAll[[3]])
#add names to Data frame
colname <- c("x","mean","sd")
colnames(df)<-colname

eb<- aes(ymax = mean + sd, ymin = mean - sd)
png("mapping_all.png", height = 600, width = 800)

#ploting with ggplot 2: X vs mean, Points
ggplot(data = df, aes(x = x, y = mean)) +
  geom_point(colour="#0066CC", size=0.5) + 
  geom_ribbon(eb, alpha=.5, colour=NA, fill="#0066CC") + 
  theme_bw()+xlab("Reference Start Position") +
  ylab("coverage") +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(limits = c(0, maxy)) +
  ggtitle("Coverage Across Reference") +geom_smooth(method = loess, colour="Red")

dev.off()

ggplot(data=all.data, aes(x = V2), stat_bin(binwidth = 1000)) + geom_histogram() 
head(all.data)

#ploting with ggplot 2: X vs mean, lines
ggplot(data = df, aes(x = x, y = mean)) +
  geom_line(colour="#0066CC", size=0.5) + 
  geom_ribbon(eb, alpha=.5, colour=NA, fill="#0066CC") + 
  theme_bw()+xlab("Reference Start Position") +
  ylab("coverage") +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(limits = c(0, maxy)) +
  ggtitle("Coverage Across Reference")

dev.off()

