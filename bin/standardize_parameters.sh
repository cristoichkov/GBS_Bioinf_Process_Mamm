#!/bin/bash

#Create an ipyrad params defaults file
ipyrad -n default

### We use the data of pairgbs ###
# Modify the parameters of the created file
sed -i '/\[1] /c\./../data/ipyrad_out  ## [1] ' params-default.txt
sed -i '/\[4] /c\./../data/demultiplex/*.fastq.gz  ## [4] ' params-default.txt
sed -i '/\[7] /c\pairgbs  ## [7] ' params-default.txt
sed -i '/\[8] /c\TGCAT, CCG  ## [8] ' params-default.txt
sed -i '/\[16] /c\2  ## [16] ' params-default.txt  ## Remove adapters with a strict value
sed -i '/\[17] /c\130  ## [17] ' params-default.txt
sed -i '/\[25] /c\10, 130, 10, 130   ## [25] ' params-default.txt

## Execute ipyrad with defaults parameters

# Load the fastq data
ipyrad -p params-default.txt -s 1

# Run the remaining assembly steps
ipyrad -p params-default.txt -s 234567

# create the set of parameters for clust_threshold
for i in 82 85 86 87 88 89 91 94; do
    ipyrad -p params-default.txt -b clust_${i}
    # Modify the parameters of the created file
    sed -i '/\[14] /c\0.'$i'  ## [14] ' params-clust_${i}.txt
    # Run the assembly since step 3 until 7
    ipyrad -p params-clust_${i}.txt -s 34567 -f
  done

# create the set of parameters for clust_threshold and min_samples_locus
for i in 82 85 86 87 88 89 91 94; do
  for k in 30 44 60; do
    ipyrad -p params-clust_${i}.txt -b clust_${i}_${k}
    # Modify the parameters of the created file
    sed -i '/\[21] /c\'$k'  ## [21] ' params-clust_${i}_${k}.txt
    # Run the assembly only in step 7
    ipyrad -p params-clust_${i}_${k}.txt -s 7 -f
  done
done

# create the set of parameters for mindepth_majrule
for i in 3 4 5 6; do
    ipyrad -p params-default.txt -b mindepth_${i}
    # Modify the parameters of the created file
    sed -i '/\[12] /c\'$i'  ## [12] ' params-mindepth_${i}.txt
    # Run the assembly since step 4 until 7
    ipyrad -p params-mindepth_${i}.txt -s 4567 -f
  done

# create the set of parameters for mindepth_majrule and min_samples_locus
for i in 3 4 5 6; do
  for k in 30 44 60; do
    ipyrad -p params-mindepth_${i}.txt -b mindepth_${i}_${k}
    # Modify the parameters of the created file
    sed -i '/\[21] /c\'$k'  ## [21] ' params-mindepth_${i}_${k}.txt
    # Run the assembly only in step 7
    ipyrad -p params-mindepth_${i}_${k}.txt -s 7 -f
  done
done


# create the set of parameters for mindepth_statistical + mindepth_majrule
for i in 7 8 9 10 11 12; do
  ipyrad -p params-default.txt -b mindepth_${i}
  # Modify the parameters of the created file
  sed -i '/\[11] /c\'$i'  ## [11] ' params-mindepth_${i}.txt
  sed -i '/\[12] /c\'$i'  ## [12] ' params-mindepth_${i}.txt
  # Run the assembly since step 4 until 7
  ipyrad -p params-mindepth_${i}.txt -s 4567 -f
done


# create the set of parameters for mindepth_statistical and min_samples_locus
for i in 7 8 9 10 11 12; do
  for k in 30 44 60; do
    ipyrad -p params-mindepth_${i}.txt -b mindepth_${i}_${k}
    # Modify the parameters of the created file
    sed -i '/\[21] /c\'$k'  ## [21] ' params-mindepth_${i}_${k}.txt
    # Run the assembly only in step 7
    ipyrad -p params-mindepth_${i}_${k}.txt -s 7 -f
  done
done

## Obtein the total of snp and loci for each parameter, and create a table
for i in `ls -d -- ../data/ipyrad_out/* | grep "_outfiles" | sed "s/..\/data\/ipyrad_out\///" | sed "s/_outfiles//"`; do  # Create a list of the names of all output folder
  cd ../data/ipyrad_out/${i}_outfiles  # Enter to each output folder
  for k in `awk '{if(NR==14) print $0}' ${i}_stats.txt | grep -Eo "[0-9]{1,10}" | awk '{if(NR==3) print $0}'`; do # Search the loci number obtained
    for p in `head -n 1 ${i}.snps.phy | cut -sd " " -f 2`; do  # Search the snps number obtained
    echo ${i} ${k} ${p} >> ../../parameter_result/param_clust.txt # Show the parameter, the number of loci and SNPs, and put the result in a txt file
  done
  done
  cd ../../../bin
done
