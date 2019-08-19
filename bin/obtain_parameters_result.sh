#!/bin/bash

## Create a txt file of all results obtained of the standardization of parameters ##

for i in `ls -d -- ../* | grep "_outfiles" | sed "s/..\///" | sed "s/_outfiles//"`; do  # Create a list of the names of all output folder
  cd ../${i}_outfiles  # Enter to each output folder
  for k in `awk '{if(NR==14) print $0}' ${i}_stats.txt | grep -Eo "[0-9]{1,10}" | awk '{if(NR==3) print $0}'`; do # Search the loci number obtained
    for p in `head -n 1 ${i}.snps.phy | cut -sd " " -f 2`; do  # Search the snps number obtained
    echo ${i} ${k} ${p} >> ../meta/param_clust.txt # Show the parameter, the number of loci and SNPs, and put the result in a txt file
  done
  done
  cd ../bin/ ## Return to bin folder
done
