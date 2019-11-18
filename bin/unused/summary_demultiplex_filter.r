library(dplyr)
library(tidyr)
library(purrr)
library(flextable)

## Load the results of demultiplex with gbsx
df_reads_dem <- read.csv("../out/demultiplex_stats/GBSX_reads_stats.csv")

## Filter M_haageana_san_angelensis but not incluid Mhsa_6_2 Mhsa_6_1 
mhsa <- df_reads_dem %>%
  select(Muestra, Especie) %>%
  filter(Especie == "M_haageana_san_angelensis" & Muestra != "Mhsa_6_2" & Muestra != "Mhsa_6_1") 

## Create a vector with the previous dataframe 
mhsa_filt <- as.vector(mhsa$Muestra) 

## Filter the data frame but not included the Muestras filtering previously 
msuper <- df_reads_dem %>%
  filter(!Muestra %in% mhsa_filt) %>%
  separate(ID, c("Id", "R"))


fil_reads <- read.table("../out/ipyrad_outfiles/stats/s2_rawedit_stats.txt", row.names = NULL)

fil_reads <- rename(fil_reads, Id = row.names)

head(gbsx)

gbsx <- gbsx %>%
  separate(ID, c("Id", "R"))


fil_reads$reads_deleted <- fil_reads$reads_raw - fil_reads$reads_passed_filter

fil_reads$perc_reads_passed <- (fil_reads$reads_passed_filter*100)/fil_reads$reads_raw

fil_reads$perc_reads_deleted <- (fil_reads$reads_deleted*100)/fil_reads$reads_raw

head(fil_reads)

summary(fil_reads$perc_reads_passed)

summary(fil_reads$perc_reads_deleted)

sd(fil_reads$perc_reads_passed)

sd(fil_reads$perc_reads_deleted)

rownames(fil_reads) <- NULL

head(fil_reads)

df_summary_filter_demultiplex <- merge(msuper, fil_reads, by = "Id", all.x = TRUE)

head(df_summary_filter_demultiplex)

stats_summary_demultiplex_filter <- df_summary_filter_demultiplex %>%
  select(Id, Especie, Muestra, total_sequences, trim_adapter_bp_read1, trim_adapter_bp_read2, trim_quality_bp_read1,
         trim_quality_bp_read2, reads_filtered_by_Ns, reads_filtered_by_minlen, reads_passed_filter,
         reads_deleted, perc_reads_passed, perc_reads_deleted)
  
write.csv(stats_summary_demultiplex_filter, file = "../out/ipyrad_outfiles/stats/stats_summary_demultiplex_filter.csv", row.names = FALSE)

df_flex <- flextable(stats_summary_demultiplex_filter)
save_as_image(df_flex, path = "../out/R_plots/Table_stats.png")  
  
sd(stats_summary_demultiplex_filter$perc_reads_deleted, na.rm = TRUE)

summary(stats_summary_demultiplex_filter$perc_reads_passed)
sd


### Tables stats number loci and snps ##

pread(clust_thresh, min_sam, loci)

head(clust_thresh)

stat_clust_loci_snp <- clust_thresh %>%
  select(-(param)) %>%
  gather(key, val, -value, -min_sam) %>%
  mutate(key = paste0(key, "_minsam_", min_sam)) %>%
  select(-min_sam) %>%
  spread(key, val) %>%
  rename(param = value)

param <- rep("clust threshold", nrow(stat_clust_loci_snp))

clust_stats <- cbind(param, stat_clust_loci_snp)


## Change the numeric columns to factors
mindepth <- parameters %>% 
  separate(parameter, c("param", "mindepth", "major_r", "min_sam"), "_") %>%
  filter(param == "mindepth") %>%
  mutate(mindepth = factor(mindepth, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(major_r = factor(major_r, levels = c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

head(mindepth)

stat_mindepth_loci_snp <- mindepth %>%
  select(-param, -mindepth) %>%
  gather(key, val, -major_r, -min_sam) %>%
  mutate(key = paste0(key, "_minsam_", min_sam)) %>%
  select(-min_sam) %>%
  spread(key, val) %>%
  rename(param = major_r)


param_min <- rep("mindepth", nrow(stat_mindepth_loci_snp))

param_all <-  data.frame(c(param, param_min)) 

colnames(param_all) <- "param"

stats_params_all <- bind_rows(stat_clust_loci_snp, stat_mindepth_loci_snp)

stats_params_all <- cbind(param_all, stats_params_all)

write.csv(stats_params_all, file = "../out/ipyrad_outfiles/stats/stats_params_all.csv", row.names = FALSE)
