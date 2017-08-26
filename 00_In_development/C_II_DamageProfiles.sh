#!/bin/bash
##########################################################
#
#       Chapter II - aDNA Damage profiles Simulation
#
#       Luis Arriola
#       Last Update: 17 August 2017
#               v.0
#
##########################################################

# simulate
#     -c endogenous coverage  (0.5X low;20X high)
#     -comp composition bact,cont,endo
#     -mapdamage File with Deamination profiles

## Simulation DATASET 1: CONTAMINATION FREE
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_0C100E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_0C100E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_0C100E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_0C100E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_0C100E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_0C100E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_0C100E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_0C100E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_0C100E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_0C100E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_0C100E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_0C100E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_0C100E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_0C100E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0,0,1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_0C100E_DEAM5 DATA1


## Simulation DATASET 2: METAGENOMICS CONTAMINATION
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_90C10E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_90C10E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_90C10E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_90C10E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_90C10E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_90C10E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_90C10E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_90C10E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_90C10E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_90C10E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_90C10E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_90C10E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_90C10E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_90C10E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.9,0,0.1 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_90C10E_DEAM5 DATA1

## Simulation DATASET 3: Streptococci CONTAMINATION
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_80CSmu20E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_80CSmu20E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDNONE0_80CSmu20E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_80CSmu20E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_80CSmu20E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW1_80CSmu20E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_80CSmu20E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_80CSmu20E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDLOW2_80CSmu20E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_80CSmu20E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_80CSmu20E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH1_80CSmu20E_DEAM5 DATA1

/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM1.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_80CSmu20E_DEAM1 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM3.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_80CSmu20E_DEAM3 DATA1
/Users/Annarielh/Bitbucket/Github/gargammel/gargammel.pl -c 5 --comp 0.8,0,0.2 -mapdamage ../MisincorporationData/misincorporationDEAM5.txt double -f ../MisincorporationData/SizeDistribution.txt -o DATA1/MUTATEDHIGH2_80CSmu20E_DEAM5 DATA1
