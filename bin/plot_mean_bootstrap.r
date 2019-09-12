## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)

## Call the function ipyrad_extract_table
source("mean_bootstrap.R")

## List the directories 
folders <- list.files("../out/raxml/")

## Create a dataframe empty
mean_boot <- data.frame()

## 
for (i in folders){
  for (n in c(1:10)){
  
  ## Since the directories end in _outfiles we have to stay alone with the folder identifier in this case clust_ [0-9]+_ [0-9]+
  name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")

  ## Extract the desired tree, for this we use paste0 to enter the folders where are the trees and the mean as dataframe
  tab <-  as.data.frame(mean_bootstrap(paste0("../out/raxml/", i, "/", "RAxML_bipartitionsBranchLabels.", name, "_run", n)))
  
  ## Change the colname of mean bootstrap
  colnames(tab) <- "mean_boot"
  
  ## Create a second column with the name of the parameter
  tab$param <- (name)
  
  ## combine the data frames by rows
  mean_boot <- rbind(mean_boot, tab)
  
  }
}
  

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
mean_boot <- mean_boot %>% 
  separate(param, c("param", "value", "min_sam"), "_") %>%
  mutate(value = factor(value, levels = c(82, 85))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

## Create the plot 
mean_boot %>% 
  ggplot(aes(x=value, y=mean_boot, fill=factor(min_sam))) +
  geom_boxplot() 


