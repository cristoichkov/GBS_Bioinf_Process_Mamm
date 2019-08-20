#!bin/bash

### get sample data simulated for ipyrad ###
curl -LkO https://github.com/dereneaton/ipyrad/raw/master/tests/ipsimdata.tar.gz
tar -xvzf ipsimdata.tar.gz
rm ipsimdata.tar.gz # remove data
mv ipsimdata data_raw # change folder name

#Create an ipyrad params defaults file
ipyrad -n default

### We use the data of pairgbs ###
# Modify the parameters of the created file
sed -i '/\[2] /c\./data_raw/pairgbs*  ## [2] ' params-default.txt
sed -i '/\[3] /c\./data_raw/pairgbs_example_barcodes.txt  ## [3] ' params-default.txt
sed -i '/\[7] /c\pairgbs  ## [7] ' params-default.txt
sed -i '/\[16] /c\2  ## [16] ' params-default.txt  ## Remove adapters with a strict value

# Execute ipyrad with the fault parameters
ipyrad -p params-default.txt -s 1234567

#### create the set of parameters ####

# create the set of parameters for clust_threshold
for i in 82 85 88 91 94 ; do
  for k in 5 7 10; do
    ipyrad -p params-default.txt -b clust_${i}_${k}
    # Modify the parameters of the created file
    sed -i '/\[14] /c\0.'$i'  ## [14] ' params-clust_${i}_${k}.txt
    sed -i '/\[21] /c\'$k'  ## [21] ' params-clust_${i}_${k}.txt
  done
done

# create the set of parameters for mindepth_majrule
for i in 1 2 3 4 5 6; do
  for k in 5 7 10; do
    ipyrad -p params-default.txt -b mindepth_${i}_${k}
    # Modify the parameters of the created file
    sed -i '/\[12] /c\'$i'  ## [12] ' params-mindepth_${i}_${k}.txt
    sed -i '/\[21] /c\'$k'  ## [21] ' params-mindepth_${i}_${k}.txt
  done
done

for i in `ls -d -- ./* | grep "params-" | sed "s/.\///" | grep -v "default"`; do
  ipyrad -p ${i} -s 34567 -f;
done

## Create a txt file of all results obtained of the standardization of parameters ##

## Create a txt file of all results obtained of the standardization of parameters ##

for i in `ls -d -- ./* | grep "_outfiles" | sed "s/.\///" | sed "s/_outfiles//"`; do  # Create a list of the names of all output folder
  cd ${i}_outfiles  # Enter to each output folder
  for k in `awk '{if(NR==14) print $0}' ${i}_stats.txt | grep -Eo "[0-9]{1,10}" | awk '{if(NR==3) print $0}'`; do # Search the loci number obtained
    for p in `head -n 1 ${i}.snps.phy | cut -sd " " -f 2`; do  # Search the snps number obtained
    echo ${i} ${k} ${p} >> ../meta/param_clust.txt # Show the parameter, the number of loci and SNPs, and put the result in a txt file
  done
  done
  cd ..
done
