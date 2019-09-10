#!/bin/bash

#SBATCH -p keri
#SBATCH -n 8
#SBATCH --mem=56000

export LD_LIBRARY_PATH=/opt/miniconda2/lib
export HDF5_USE_FILE_LOCKING=FALSE


ipyrad -p params-default.txt -b mindepth_2_2_80

# Modify the parameters of the created file
sed -i '/\[12] /c\'2'  ## [12] ' params-mindepth_2_2_80.txt

# Modify the parameters of the created file
sed -i '/\[21] /c\'60'  ## [21] ' params-mindepth_2_2_80.txt

# Run the assembly since step 4 until 7
ipyrad -p params-mindepth_2_2_80.txt -s 4567 -f

