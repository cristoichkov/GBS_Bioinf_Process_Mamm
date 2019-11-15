#!/bin/bash

for i in `ls ../out/ipyrad_outfiles/parameters/ | sed "s/_outfiles//g"`;do
  makdir ../out/vcftools/${i}
  vcftools --vcf ../out/ipyrad_outfiles/parameters/${i}_outfiles/${i}.vcf --plink --out ../out/vcftools/${i}
done
