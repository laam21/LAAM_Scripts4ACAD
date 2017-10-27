#!/bin/bash -l
#### RAW 2 MERGED 2 DEMULT 2 OTUPicking
#### Luis Arriola

## Load the Modules
module load bcl2fastq/2.19.1.403 Java/1.8.0_10 BBMap/37.36

#if [ "$#" != "1" ]; then
#  if [ "$#" != "1" ]; then
#    echo -e "Uses bcl2fastq to make FASTQs from Illumina run with no demultiplexing\nWill create a SequenceOutput folder with all your goodies\n\nRequires: Run on ACAD Cluster (Module commands)\n\nUsage: bash RawData1_BCL2fastq2merged.sh RunName"
#    exit 0
#  fi
#
#  RunName=$1
for DIR in DATA_*; do
  mkdir 1_SplitLibraries
  cd DIR
  # Get FCID from RunInfo.xml
  FCID=$(sed -n 's:.*<Flowcell>\(.*\)</Flowcell>.*:\1:p' RunInfo.xml)
  echo -e "FCID,Lane,SampleID,SampleRef,Index,Description,Control,Recipe,Operator,SampleProject\n$FCID,1,not_demultiplexed,,,Test bcl conversion,N,D109LACXX,BCF,testbclconv" > NoDemultiplex.csv
  # Prepare fastq conversion directories
  bcl2fastq --use-bases-mask Y\*,Y\*,Y\* --input-dir /Data/Intensities/BaseCalls  \
        --sample-sheet NoDemultiplex.csv --output-dir ./NotDemultiplexed --mismatches 1

  # Run make command
  cd NotDemultiplexed; make -j 8; cd ..
  # Create Output dir
  mkdir SequenceOutput

  # Move fastq.gz files to current directory
  find . -name "not_demultiplexed_NoIndex_L001*.fastq.gz" -exec mv {} ./SequenceOutput/ \;

  # Cat Read files together
  cat SequenceOutput/not_demultiplexed_NoIndex_L001_R1_00* > SequenceOutput/not_demultiplexed_NoIndex_R1.fastq.gz
  cat SequenceOutput/not_demultiplexed_NoIndex_L001_R2_00* > SequenceOutput/not_demultiplexed_NoIndex_R2.fastq.gz
  cat SequenceOutput/not_demultiplexed_NoIndex_L001_R3_00* > SequenceOutput/not_demultiplexed_NoIndex_R3.fastq.gz
  rm SequenceOutput/not_demultiplexed_NoIndex_L001_R1_00*
  rm SequenceOutput/not_demultiplexed_NoIndex_L001_R2_00*
  rm SequenceOutput/not_demultiplexed_NoIndex_L001_R3_00*

  mv SequenceOutput/not_demultiplexed_NoIndex_R2.fastq.gz SequenceOutput/"$RunName"_index.fastq.gz

  # Merge reads
  bbmerge.sh in1=SequenceOutput/not_demultiplexed_NoIndex_R1.fastq.gz in2=SequenceOutput/not_demultiplexed_NoIndex_R3.fastq.gz out=SequenceOutput/"$RunName"_merged.fastq.gz outu1=SequenceOutput/"$RunName"_unmerged1.fastq.gz outu2=SequenceOutput/"$RunName"_unmerged2.fastq.gz
