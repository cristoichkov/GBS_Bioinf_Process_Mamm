## Packages used 
library(dplyr)
library(ggplot2)
library(tidyr)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

## Start with a fresh brain
rm(list = ls())

## Get  parameters file
parameters <- read.table("../data/ipyrad_outfiles/param_clust.txt")
colnames(parameters) <- c("parameter", "loci", "snp")

## Reorder the data frame, separate the column parameters by "_" 
## Filter by  clustering threshold
## Change the numeric columns to factors
clust_thresh <- parameters %>% 
  separate(parameter, c("param", "value", "min_sam"), "_") %>%
  filter(param == "clust") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

# Generate the plot of SNPs obteined of clust_threshold's parameters 
ggplot(clust_thresh, aes(x=value, y=snp)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of SNPs", x = "Cluster threshold") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%"))

# Generate the plot of Loci obteined of clust_threshold's parameters 
ggplot(clust_thresh, aes(x=value, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of Loci", x = "Cluster threshold") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%"))

## Filter the loci in 80%
loci <- clust_thresh %>% 
  filter(min_sam == "80") %>%
  select(loci) 

## Subtract the parameters at 80% to obtain the new loci discovered
new_loci <- data.frame()
for (row in 1:nrow(loci)){
  
  loci_rest <- loci[[(row+1),1]] - loci[[row,1]]
  
  new_loci <- rbind(new_loci, loci_rest)
}

## Reorder the data frame to can do the graph of new loci
colnames(new_loci) <- "new_loci"
param_int <- as.data.frame(c("0.82/0.85", "0.85/0.86", "0.86/0.87", "0.87/0.88", "0.88/0.89", "0.89/0.91", "0.91/0.94"))
colnames(param_int) <- "int"
new_loci <- cbind(param_int, new_loci)


# Generate the plot of the iteraction of 80% clust_threshold values
ggplot(new_loci, aes(x=int, y=new_loci, group = 1)) +
  geom_point(size = 2, color = "coral3") + geom_line(size = 1, color = "cyan4", linetype = "dashed") + 
  labs(y = "Number of new Loci", x = "Iteration of clust threshold") 
