library(ape)
library(treeio)

## Working direcory
setwd("~/GBS_ipyrad_mamm/bin")

trees_list <- list.files(paste0("../data/raxml/clust_82_40_raxml/"))
trees_bip <- trees_list[grep("RAxML_bipartitionsBranchLabels", trees_list)]


mamm_mean_boots <- data.frame()
for (i in 1:length(trees_bip)){
  tree_boots <- read.raxml(paste0("../data/raxml/clust_82_40_raxml/", trees_bip[i]))
  
  mean_boot <- as.data.frame(mean(tree_boots@data$bootstrap, na.rm = TRUE))
  
  rownames(mean_boot) <- stringr::str_extract(string = trees_bip[i], pattern = "clust_[0-9]+_[0-9]+_run[0-9]+")

  colnames(mean_boot) <- "mean_boot"
  
  mamm_mean_boots <- rbind(mamm_mean_boots, mean_boot)
  
  }

