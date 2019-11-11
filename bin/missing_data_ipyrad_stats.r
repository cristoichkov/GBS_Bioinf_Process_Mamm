source("missing_data_ipyrad.R")

## List the directories 
folders_clust <- list.files("../out/ipyrad_outfiles/parameters/", pattern = "mindepth")

## Create a dataframe empty
df_miss_data <- data.frame()

## Extract tables for Cluster Treshhold
for (i in folders_clust){
  
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


miss_data_mamm <- df_miss_data %>% 
  separate(Id, c("param", "mindept",  "mindep_rul","min_sam"), "_") %>%
  mutate(mindept = factor(mindept, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(mindep_rul = factor(mindep_rul, levels = c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))



## Create the plot 
miss_data_mamm %>% 
  ggplot(aes(x=mindep_rul, y=perc_miss, fill=factor(min_sam))) +
  geom_boxplot() + 
  labs(y = "Mean bootstrap values (10 RAxML runs)", x = "Clustering Threshold (% similarity)") +
  scale_fill_discrete(name = " Minimum \n number \n of samples", labels = c("40%", "60%", "80%")) +
  geom_vline(xintercept = 3.5, linetype="dashed", size = 0.6, color = "blueviolet") +
  geom_vline(xintercept = 6.5, linetype="dashed", size = 0.6, color = "blueviolet")
  