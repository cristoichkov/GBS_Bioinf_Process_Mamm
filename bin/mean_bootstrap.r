## Packages used 
library(treeio)
library(dplyr)
library(tidyr)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

# start with a fresh brain
rm(list = ls())

## Get raxml trees 
trees_list <- list.files(paste0("../data/raxml/clust_82_40_raxml/"))
trees_bip <- trees_list[grep("RAxML_bipartitionsBranchLabels", trees_list)]

## Create mean bootstrap dataframe of all trees obtained from each parameter
mamm_mean_boots <- data.frame()
for (i in 1:length(trees_bip)){
  ## Read each tree  
  tree_boots <- read.raxml(paste0("../data/raxml/clust_82_40_raxml/", trees_bip[i]))
  ## Obtain bootstrap values and put in a dataframe
  mean_boot <- as.data.frame(mean(tree_boots@data$bootstrap, na.rm = TRUE))
  ## Assign the row name from the name of the file, using only the data that identify the parameters
  rownames(mean_boot) <- stringr::str_extract(string = trees_bip[i], pattern = "clust_[0-9]+_[0-9]+_run[0-9]+")
  ## Change the column name
  colnames(mean_boot) <- "mean_boot"
  ## Combine each mean value by row
  mamm_mean_boots <- rbind(mamm_mean_boots, mean_boot)
}

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
mamm_mean_boots %>% 
  add_rownames("parameters") %>%
  separate(parameters, c("param", "value", "min_sam", "run"), "_") %>%
  mutate(value = factor(value, levels = c(82))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40)))
