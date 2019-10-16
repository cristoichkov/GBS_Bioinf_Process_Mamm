library(SNPRelate)

cum_var_pca <- function(file, n_comp){
  
vcf.fn <- file

snpgdsVCF2GDS(vcf.fn, "ccm.gds",  method="biallelic.only")

genofile <- openfn.gds("ccm.gds")

ccm_pca <- snpgdsPCA(genofile, autosome.only = FALSE)

sum(ccm_pca$varprop[1:comp])

}