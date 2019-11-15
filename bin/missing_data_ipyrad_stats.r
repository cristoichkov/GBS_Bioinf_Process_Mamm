## Packages used 
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggtree)

## Clustering Threshold ##

## Mindepth ##

## Call the function ipyrad_extract_table
source("missing_data_ipyrad.R")

## List the directories 
folders_clust <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "clust"),
                             list.files("../out/ipyrad_outfiles/parameters/", pattern = "_outfiles"))


## Create a dataframe empty
df_miss_data_clust <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders_clust){
  
  ## Find the file name pattern
  name <- stringr::str_extract(string = i, pattern = "clust_[0-9]+_[0-9]+")
  
  path_file <- paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, ".loci")
  
  df_miss <- missing_data_ipyrad(path_file, 74)
  
  ## Create a dataframe repeating the identifier according to with the number of row of the table 
  name_row <- data.frame(rep(name, times = nrow(df_miss)))
  
  ## Change the name of identifier column
  colnames(name_row) <- "Id"
  
  ## combine the data frames by columns
  final <- cbind(name_row, df_miss)
  
  df_miss_data_clust <- rbind(df_miss_data_clust, final)
  
}

write.csv(df_miss_data_clust, file = "../out/ipyrad_outfiles/stats/clust_missing_data.csv")

miss_data_clust <- df_miss_data_clust %>% 
  separate(Id, c("param", "value", "min_sam"), "_") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))



## Create the plot 
miss_data_clust %>% 
  ggplot(aes(x=value, y=perc_miss, fill=factor(min_sam))) +
  geom_boxplot() + 
  labs(y = "Missing data fraction ", x = "Clustering Threshold (% similarity)") +
  scale_fill_discrete(name = " Minimum \n number \n of samples", labels = c("40%", "60%", "80%")) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))





## Mindepth ##

## Call the function ipyrad_extract_table
source("missing_data_ipyrad.R")

## List the directories 
folders_mindept <- intersect(list.files("../out/ipyrad_outfiles/parameters/", pattern = "mindepth"),
                     list.files("../out/ipyrad_outfiles/parameters/", pattern = "_outfiles"))


## Create a dataframe empty
df_miss_data <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders_mindept){
  
  ## Find the file name pattern
  name <- stringr::str_extract(string = i, pattern = "mindepth_[0-9]+_[0-9]+_[0-9]+")
  
  path_file <- paste0("../out/ipyrad_outfiles/parameters/", i, "/", name, ".loci")
  
  df_miss <- missing_data_ipyrad(path_file, 74)
  
  ## Create a dataframe repeating the identifier according to with the number of row of the table 
  name_row <- data.frame(rep(name, times = nrow(df_miss)))
  
  ## Change the name of identifier column
  colnames(name_row) <- "Id"
  
  ## combine the data frames by columns
  final <- cbind(name_row, df_miss)
  
  df_miss_data <- rbind(df_miss_data, final)

}

write.csv(df_miss_data, file = "../out/ipyrad_outfiles/stats/mindepth_missing_data.csv")

miss_data_mamm <- df_miss_data %>% 
  separate(Id, c("param", "mindept",  "mindep_rul", "min_sam"), "_") %>%
  mutate(mindept = factor(mindept, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(mindep_rul = factor(mindep_rul, levels = c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))



## Create the plot 
mis_min <- miss_data_mamm %>% 
  ggplot(aes(x=mindep_rul, y=perc_miss, fill=factor(min_sam))) +
  geom_boxplot() + 
  labs(y = "Missing data fraction ", x = "Mindepth") +
  scale_fill_discrete(name = " Minimum \n number \n of samples", labels = c("40%", "60%", "80%")) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))

ggsave(mis_min, file="../out/R_plots/mindepth_missing_data.png", device="png", dpi = 300, width = 10, height = 7)
  