## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

## Start with a fresh brain
rm(list = ls())

## Call the function ipyrad_extract_table
source("ipyrad_extract_table.R")

## Cluster Treshhold ##

## List the directories 
folders <- list.files("../out/ipyrad_outfiles/parameters/", pattern = "clust")

## Create a dataframe empty
df_het_clust <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders){
    
    ## Find the file name pattern
    name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")
    
    tab_hetero <- ipyrad_extract_table(paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, "_stats.txt"), 5, 74)
    
    ## Create a dataframe repeating the identifier according to with the number of row of the table 
    name_row <- data.frame(rep(name, times = nrow(tab_hetero)))
    
    ## Change the name of identifier column
    colnames(name_row) <- "Id"
    
    ## combine the data frames by columns
    final <- cbind(name_row, tab_hetero)
    
    ## combine the data frames by rows    
    df_het_clust <- rbind(df_het_clust, final)
}

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
clust_thresh_het <- df_het_clust %>% 
  separate(Id, c("param", "value", "min_sam"), "_") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

## Create the plot 
clust_thresh_het %>% 
  ggplot(aes(x=value, y=error_est, fill=factor(min_sam))) +
  geom_boxplot() + 
  xlab("Clustering Threshold (% similarity)") + 
  ylab("Mean bootstrap values (10 RAxML runs)") +
  labs(fill = "% minimum \n number \n of samples") 


## mindepth mindepth##

## List the directories 
folders <- list.files("../out/ipyrad_outfiles/parameters/", pattern = "mindepth")

## Create a dataframe empty
df_het_mindepth <- data.frame()

## Extract tables for mindepth 
for (i in folders){
  
  ## Find the file name pattern
  name <- stringr::str_extract(string = i, pattern = "mindepth_[0-9]+_[0-9]+_[0-9]+")
  
  tab_hetero <- ipyrad_extract_table(paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, "_stats.txt"), 5, 74)
  
  ## Create a dataframe repeating the identifier according to with the number of row of the table 
  name_row <- data.frame(rep(name, times = nrow(tab_hetero)))
  
  ## Change the name of identifier column
  colnames(name_row) <- "Id"
  
  ## combine the data frames by columns
  final <- cbind(name_row, tab_hetero)
  
  ## combine the data frames by rows    
  df_het_mindepth <- rbind(df_het_mindepth, final)
}

## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
mindepth_het <- df_het_mindepth %>% 
  separate(Id, c("param", "mindepth_stat", "mindepth_maj", "min_sam"), "_") %>%
  mutate(mindepth_stat = factor(mindepth_stat, levels = c(6))) %>%
  mutate(mindepth_maj = factor(mindepth_maj, levels = c(3, 4, 5))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

## Create the plot 
mindepth_het %>% 
  ggplot(aes(x=mindepth_maj, y=hetero_est, fill=factor(min_sam))) +
  geom_boxplot() + 
  xlab("Clustering Threshold (% similarity)") + 
  ylab("Mean bootstrap values (10 RAxML runs)") +
  labs(fill = "% minimum \n number \n of samples") 
