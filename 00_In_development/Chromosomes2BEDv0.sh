#!/bin/bash
# Created on Fri 6 May 2016
# By L. Arriola
# Script takes a file with chromosome names and sizes and 
# outputs a bed file with the specified step
# Usage: Chromosomes2BEDv0.sh <file> <step>
#		<file> File with chromosome names and lengths
#		<step> Desired step (number)

	while read -r a b; do
		CHROMNAME=$a
		CHROMLEN=$b
		STEP=$2
		COUNTER=0
		while [ $COUNTER -lt $CHROMLEN ]; do
			START=$COUNTER
			if [ $(($COUNTER + $STEP)) -gt $CHROMLEN ]
				then
					END=$CHROMLEN
					echo "$CHROMNAME	$START	$END"
					COUNTER=$(($END))
					break
				else			
					END=$(($COUNTER + $STEP))
					echo "$CHROMNAME	$START	$END"
					COUNTER=$(($END))
			fi
		done
	done < $1	
