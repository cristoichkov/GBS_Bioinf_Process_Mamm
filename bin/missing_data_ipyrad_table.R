## This function parse the .loci file into fasta file, and creates a table with the sequence length ##

## necessary packages
library(tidyverse)
library(plyr)

missing_data_ipyrad_table <- function(file){
  
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
  
  geta_df_loc[is.na(geta_df_loc)] = 0
  
  row.names(geta_df_loc) <- geta_df_loc[,1]
  
  geta_df_loc <- geta_df_loc[,-1]
  
  return(geta_df_loc)
  
}
