

library(tidyverse)
library(seqRFLP)

ipyrad_loci_to_fasta <- function(file){

ipyrad_Loci <- readLines(file)

breakLines <- grep("//", ipyrad_Loci, fixed = TRUE)

firstLocusLines <- c(1, (breakLines[1:(length(breakLines)-1)] + 1))

for (k in 1:length(breakLines)){
  
loc <- ipyrad_Loci[firstLocusLines[k]:(breakLines[k]-1)]   

loc_split <- strsplit(loc, "\\s+") 

seq_loc <- data.frame()

for (i in 1:length(loc_split)){
  
  name <- data.frame(loc_split[[i]][1])
  
  seq <- data.frame(loc_split[[i]][2])
  
  df_nam_seq <- cbind(name, seq)
  
  colnames(df_nam_seq) <- c("Id", paste0("locus_", k))
  
  seq_loc <- rbind(seq_loc, df_nam_seq)
  }

assign(paste0("locus_", k), seq_loc)

}

lst <- mget(paste0("locus_", 1:497))

locus_df_all <- reduce(lst, full_join, by = "Id")

locus_lenght <- data.frame()

for (n in 2:length(locus_df_all)){
  
  loc_names <- data.frame(colnames(locus_df_all[n]))
  
  seq_lenght <- data.frame(nchar(as.vector(locus_df_all[1,n])))
  
  df_length <- cbind(loc_names, seq_lenght)
  
  colnames(df_length) <- c("Locus", "Lenght")
  
  locus_lenght <- rbind(locus_lenght, df_length)
}

pre_fast <- locus_df_all %>% unite("loci", locus_1:locus_497, sep = "")

dataframe2fas(pre_fast, file = "locus_fasta.fas" )

locus_lenght$cumsum <- cumsum(locus_lenght$Lenght)

write.csv(locus_lenght, file = "length_locus.csv", row.names = FALSE)

}
