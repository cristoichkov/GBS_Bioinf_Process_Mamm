#!/bin/bash

## run 10 times with different parsimony and bootstrap seeds for each clustering threshold ##

for i in `ls -d -- ../out/ipyrad_outfiles/parameters/* | grep "_outfiles" | sed "s/..\/out\/ipyrad_outfiles\/parameters\///" | sed "s/_outfiles//"`; do
    for k in {1..10}; do
      mkdir -p ../out/raxml/${i}_raxml
      for h in `shuf -i 10000-99999 -n1`; do
      echo raxmlHPC-PTHREADS-SSE3 -f a -T 8 -m GTRGAMMA -N 100 -x ${h} -p ${h} -n ${i}_run${k} -w /LUSTRE/Genetica/ccervantes/GBS_Bioinf_Process_Mamm/out/raxml/${i}_raxml -s /LUSTRE/Genetica/ccervantes/GBS_Bioinf_Process_Mamm/out/ipyrad_outfiles/parameters/${i}_outfiles/${i}.phy -o F12,G12,H12
    done
  done
done
