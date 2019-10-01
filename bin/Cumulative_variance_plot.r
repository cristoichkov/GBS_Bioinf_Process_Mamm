## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)
library(filesstrings)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

## Start with a fresh brain
rm(list = ls())

## List the directories 
folders_clust <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "clust"), list.files("../out/ipyrad_outfiles/parameters/", pattern = "_outfiles"))

## Create a dataframe empty
vec_var <- vector()
vec_name <- vector()

## Extract tables for Cluster Treshhold
for (i in folders_clust){
  
  ## Find the file name pattern
  name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")
  
  sum_pca_var <- cum_var_pca(paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, ".vcf"), 5, name, paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, ".gds"))
  
  vec_name <- c(vec_name, name)
  
  vec_var <- c(vec_var, sum_pca_var)
  
}


df_pca_var <- data.frame(vec_name, vec_var)

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
clust_thresh_pca_var <- df_pca_var %>% 
  separate(vec_name, c("param", "value", "min_sam"), "_") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))


## Create the plot 
pl_pca_var <- clust_thresh_pca_var %>% 
  ggplot(aes(x=value, y=vec_var, colour = factor(min_sam))) +
  geom_point() + 
  xlab("Clustering Threshold (% similarity)") + 
  ylab("% heterozygous sites") 

pl_pca_var

