## This function parse the .loci file into fasta file, and creates a table with the sequence length ##

## necessary packages
library(tidyverse)
library(seqRFLP)

## Defines the name of the function, which accepts as parameters: 
## file = "../file.loci", n_sambles = # samples
ipyrad_loci_to_fasta <- function(file, n_samples){
  
  ipyrad_Loci <- readLines(file) ## Returns a list containing the lines in "file"

  breakLines <- grep("//", ipyrad_Loci, fixed = TRUE) ## create a vector with the # of the rows that contain "//"
  
  firstLocusLines <- c(1, (breakLines[1:(length(breakLines)-1)] + 1)) ## create a vector with the start of sequences of each locus
  
  ## loop to extract each locus and create a dataframe for each one 
  for (k in 1:length(breakLines)){ ## list the length of breakLines vector
    
    loc <- ipyrad_Loci[firstLocusLines[k]:(breakLines[k]-1)]  ## generate a range that is the number of row for each locus 
    
    loc_split <- strsplit(loc, "\\s+") ## separate each locus and put it in a list 
    
    seq_loc <- data.frame() ## empty dataframe
    
    ## loop to extract all the sequences per locus and create a dataframe for each one
    for (i in 1:length(loc_split)){ ## list the length of loc_split list
      
      name <- data.frame(loc_split[[i]][1]) ## extract the name for each locus 
      
      seq <- data.frame(loc_split[[i]][2]) ## extract the sequence for each sample per locus
      
      df_nam_seq <- cbind(name, seq) ## combine the sample id and its sequence per locus
      
      colnames(df_nam_seq) <- c("Id", paste0("locus_", k)) ## Change the column names 
      
      seq_loc <- rbind(seq_loc, df_nam_seq) ## combine the sequences of all samples per locus
    }
    
    assign(paste0("locus_", k), seq_loc) ## create a dataframe for each locus 
    
  }
  
  lst <- mget(paste0("locus_", 1:length(breakLines))) ## create a list of all locus dataframes 
  
  locus_lenght <- data.frame() ## empty dataframe
  
  ## loop to create a dataframe with the length of each locus
  for (n in 1:length(lst)){
    
    loc_names <- data.frame(paste0("locus_", n)) ## id of each locus 
    
    seq_lenght <- data.frame(nchar(as.vector(lst[[n]][2,2]))) ## length of each locus 
    
    df_length <- cbind(loc_names, seq_lenght) ## combine the locus id and its length
    
    colnames(df_length) <- c("Locus", "Lenght") ## Change the column names 
    
    locus_lenght <- rbind(locus_lenght, df_length) ## combine the lenght of all locus
  }
  
  suppressWarnings(locus_df_all <- reduce(lst, full_join, by = "Id")) ## combine all locus by Id in only one dataframe
  
  locus_df_all <- locus_df_all %>% slice(1:n_samples) ## select only the number of samples 
  
  ## loop to replace <NA> values to "-" character
  for (g in 1:nrow(locus_df_all)){
    for (f in 2:length(locus_df_all)) {
      
        locus_df_all[,f] <- fct_explicit_na(locus_df_all[,f], na_level =  strrep("-", locus_lenght[f-1,2]))
  }
}
  
  pre_fast <- locus_df_all %>% unite("loci", matches("^locus"), sep = "") ## unite all locus y one locus 
  
  dataframe2fas(pre_fast, file = "locus_fasta.fas") ## convert the dataframe to fasta file 
  
  locus_lenght$cumsum <- cumsum(locus_lenght$Lenght) ## convert the dataframe to fasta file 
  
  write.csv(locus_lenght, file = "length_locus.csv", row.names = FALSE) ## save the length dataframe in .csv file
}
  