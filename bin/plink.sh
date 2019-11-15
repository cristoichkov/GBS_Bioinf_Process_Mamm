#!/bin/bash

## Generate .bed, .bim, .fam, .raw files ##

export PATH=$PATH:~/bin/

for i in `ls ../out/vcftools/ | sed "s/_out//g"`;do
  mkdir ../out/plink/${i}_out
  plink --file ../out/vcftools/${i}_out/${i} --make-bed --out ../out/plink/${i}_out/${i} --recodeAD
done
