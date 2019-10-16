#!/bin/bash

#SBATCH -p keri
#SBATCH -n 8
#SBATCH --mem=56000

export LD_LIBRARY_PATH=/opt/miniconda2/lib
export HDF5_USE_FILE_LOCKING=FALSE


ipyrad -p mindepth_2_2_80 -b mindepth_2_2_40


# Modify the parameters of the created file
sed -i '/\[21] /c\'30'  ## [21] ' params-mindepth_2_2_40.txt

# Run the assembly since step 4 until 7
ipyrad -p params-mindepth_2_2_40.txt -s 7 -f


ipyrad -p mindepth_2_2_80 -b mindepth_2_2_60


# Modify the parameters of the created file
sed -i '/\[21] /c\'44'  ## [21] ' params-mindepth_2_2_60.txt

# Run the assembly since step 4 until 7
ipyrad -p params-mindepth_2_2_60.txt -s 7 -f
