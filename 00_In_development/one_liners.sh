# Quick Bash one-linners

#Change multiple names on MoL samples
  for filename in ./*; do mv "$filename" $(basename "$filename" | awk -F "_l" '{print $1".rma3"}'); done



#Stats
for FILE in ./*.stats; do echo "$FILE">>SUMMARY_STATS.txt; cat $FILE | awk 'NR==3' >>SUMMARY_STATS.txt;done
