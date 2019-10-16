#!/bin/bash

## run 10 times with different parsimony and bootstrap seeds for each clustering threshold ##

for i in `ls -d -- ../data/* | grep "_outfiles" | sed "s/..\/data\///" | sed "s/_outfiles//"`; do
    for k in {1..10}; do
      mkdir -p ../out/${i}_raxml
      for h in `shuf -i 10000-99999 -n1`; do
      raxmlHPC-PTHREADS-SSE3 -f a -T 12 -m GTRGAMMA -N 100 -x ${h} -p ${h} -n ${i}_run${k} -w /home/rafael/GBS_phylogeny/out/${i}_raxml -s /home/rafael/GBS_phylogeny/data/${i}_outfiles/${i}.phy -o F12,G12,H12
    done
  done
done
