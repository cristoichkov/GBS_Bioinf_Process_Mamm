## This function parse the .loci file into fasta file, and creates a table with the sequence length ##

## necessary packages
library(tidyverse)
library(plyr)

missing_data_ipyrad <- function(file, n_samples){
  
  ipyrad_Loci <- readLines(file)

breakLines <- grep("//", ipyrad_Loci, fixed = TRUE)

firstLocusLines <- c(1, (breakLines[1:(length(breakLines)-1)] + 1))


loc_df <- data.frame()

## loop to extract each locus and create a dataframe for each one 
for (k in 1:length(breakLines)){ ## list the length of breakLines vector
  
  loc <- ipyrad_Loci[firstLocusLines[k]:(breakLines[k]-1)]
  
  loc <- gsub(" +", ",", loc)
  
  ne <- data.frame(loc)
  
  nex <- ne %>%
    separate(loc, c("Id", "seq"), ",", convert = TRUE, remove = FALSE, fill = "right") %>%
    select(Id)
  
  name_nex <- data.frame(rep(paste0("locus", k), times = nrow(nex)))
  
  colnames(name_nex) <- "locus"
  
  loc_pre_nex <- data.frame(rep(1, times = nrow(nex)))
  
  colnames(loc_pre_nex) <- "pre"
  
  lsl <- cbind(nex, name_nex, loc_pre_nex)
  
  loc_df <- rbind(loc_df, lsl)
  
}

loc_df <- subset(loc_df, Id != "")

geta_df_loc <- spread(loc_df, locus, pre)

miss_dat_df <- data.frame()

for (i in 2:length(geta_df_loc)){
  
  prub <- data.frame(table(is.na(geta_df_loc[,i])))
  
  spr_df <- spread(prub, Var1, Freq)
  
  name_spr <- data.frame(paste0("locus", i))
  
  colnames(name_spr) <- "locus"
  
  fin_df <- cbind(name_spr, spr_df)
  
  miss_dat_df <- rbind.fill(miss_dat_df, fin_df)
  
}

colnames(miss_dat_df) <- c("locus", "no_miss", "miss")

miss_dat_df$perc_no_miss <- miss_dat_df$no_miss/n_samples

miss_dat_df$perc_miss <- miss_dat_df$miss/n_samples

return(miss_dat_df)

}
