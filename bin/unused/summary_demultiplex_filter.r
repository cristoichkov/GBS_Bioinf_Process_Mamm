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
  
df_flex <- flextable(stats_summary_demultiplex_filter)
save_as_image(df_flex, path = "../out/R_plots/Table_stats.png")  
  
webshot::install_phantomjs()
