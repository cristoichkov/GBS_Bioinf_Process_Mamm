## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggtree)

## Cluster Treshhold ##

## List the directories 
folders_clust <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "clust"), 
                           list.files("../out/ipyrad_outfiles/parameters/", pattern = "80_consens"))

## Create a dataframe empty
df_het_clust <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders_clust){
    
    ## Find the file name pattern
    name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")
    
    tab_hetero <- read.table(paste0("../out/ipyrad_outfiles/parameters/", i, "/s5_consens_stats.txt", row.names = NULL))
    
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
  mutate(min_sam = factor(min_sam, levels = c(80)))

## Create the plot 
pl_heter <- clust_thresh_het %>% 
  ggplot(aes(x=value, y=heterozygosity)) +
  geom_boxplot() + 
  xlab("Clustering Threshold (% similarity)") + 
  ylab("% heterozygous sites") +
  annotate("text", x = 1, y = 0.015, label = "A)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) 

pl_heter



## Mindepth ##

## Call the function ipyrad_extract_table
source("ipyrad_extract_table.R")

## List the directories 
folders <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "mindepth"),
                     list.files("../out/ipyrad_outfiles/parameters/", pattern = "80_outfiles"))

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
  mutate(mindepth_stat = factor(mindepth_stat, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(mindepth_maj = factor(mindepth_maj, levels = c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80))) 

## Create the plot 
pl_heter_min <- mindepth_het %>% 
  ggplot(aes(x=mindepth_maj, y=hetero_est)) +
  geom_boxplot() + 
  xlab("Mindepth") + 
  ylab("% heterozygous sites") +
  annotate("text", x = 1.2, y = 0.036, label = "B)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))

pl_heter_min


ggsave(multiplot(pl_heter, pl_heter_min,  ncol=2, labels=c("A", "B")), 
       file="../out/R_plots/Heterozygous.png", device="png", dpi = 300, width = 12, height = 6)
