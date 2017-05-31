#!/bin/bash -l
#### Separate FastQ sequences by length
#### Luis Arriola [31 May 2007]

### USAGE DESCRIPTION
# User should provide the FILE minimum(MIN) size and the maximum(MAX) size of reads
# to be copied into the Output file.
#     SeparateByLength.sh <FILE> <MIN length> <MAX length>

FILE=$1
MIN=$2
MAX=$3

cat $FILE \
| awk -v aMIN="$MIN" -v aMAX="$MAX" \
      'BEGIN {OFS = "\n"}{ \
          Header = $0 ; \
          getline Sequence; \
          getline QualHeader ; \
          getline QualScores ; \
          if (length(Sequence) >= aMIN && length(Sequence) <= aMAX){ \
            print Header, Sequence, QualHeader, QualScores \
          } \
        }' \
        >${FILE/.fastq/_length"$MIN"_"$MAX".fastq}
