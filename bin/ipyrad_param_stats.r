## Packages used 
library(dplyr)
library(ggplot2)
library(tidyr)

## Working direcory
setwd("~/GBS_Bioinf_Process_Mamm/bin")

## Start with a fresh brain
rm(list = ls())

## Get  parameters file
parameters <- read.table("../out/ipyrad_outfiles/stats/param_clust.txt")
colnames(parameters) <- c("parameter", "loci", "snp")


#### clustering threshold ####

## Reorder the data frame, separate the column parameters by "_" 
## Filter by  clustering threshold
## Change the numeric columns to factors
clust_thresh <- parameters %>% 
  separate(parameter, c("param", "value", "min_sam"), "_") %>%
  filter(param == "clust") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

# Generate the plot of SNPs obteined of clust_threshold's parameters 
clust_tresh_snp <-  ggplot(clust_thresh, aes(x=value, y=snp)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(colour = " Minimum \n number \n of samples", y = "Number of SNPs", x = "Clustering Threshold (% similarity)") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  geom_vline(xintercept = 4, linetype="dashed", size = 0.6, color = "blueviolet") +
  geom_vline(xintercept = 6, linetype="dashed", size = 0.6, color = "blueviolet") +
  annotate("text", x = 1, y = 65000, label = "A)", size = 6, fontface = 2)


clust_tresh_snp

# Generate the plot of Loci obteined of clust_threshold's parameters 
clust_tresh_loci <- ggplot(clust_thresh, aes(x=value, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(colour = " Minimum \n number \n of samples", y = "Number of Loci", x = "Clustering Threshold (% similarity)") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  geom_vline(xintercept = 4, linetype="dashed", size = 0.6, color = "blueviolet") +
  geom_vline(xintercept = 6, linetype="dashed", size = 0.6, color = "blueviolet") +
  annotate("text", x = 1, y = 3850, label = "B)", size = 6, fontface = 2)

clust_tresh_loci

##  plot all the trees in one
multiplot(clust_tresh_snp, clust_tresh_loci,  ncol=2, labels=c("A", "B"))


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

## Reorder the data   frame to can do the graph of new loci
colnames(new_loci) <- "new_loci"
param_int <- as.data.frame(c("0.82/0.85", "0.85/0.86", "0.86/0.87", "0.87/0.88", "0.88/0.89", "0.89/0.91", "0.91/0.94"))
colnames(param_int) <- "int"
new_loci <- cbind(param_int, new_loci)


# Generate the plot of the iteraction of 80% clust_threshold values
new_loci_clust_tresh <- ggplot(new_loci, aes(x=int, y=new_loci, group = 1)) +
  geom_point(size = 2, color = "coral3") + geom_line(size = 1, color = "cyan4", linetype = "dashed") + 
  labs(y = "Number of new Loci", x = "Iteration of clust threshold") 

new_loci_clust_tresh

## Save plot in EPS Extension
ggsave(new_loci_clust_tresh, file="../out/R_plots/Clust_Tresh_new_loci.png", device="png", dpi = 100)


#### mindepth ####

## Reorder the data frame, separate the column parameters by "_" 
## Filter by  mindepth_
## Change the numeric columns to factors
mindepth <- parameters %>% 
  separate(parameter, c("param", "mindepth", "major_r", "min_sam"), "_") %>%
  filter(param == "mindepth") %>%
  mutate(mindepth = factor(mindepth, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(major_r = factor(major_r, levels = c(3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80)))

# Generate the plot of SNPs obteined of mindepth's parameters 
mindepth_snp <- ggplot(mindepth, aes(x=major_r, y=snp)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of SNPs", x = "mindepth") +
  labs(colour = " Minimum \n number \n of samples", y = "Number of SNPs", x = "Mindepth Majrule") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  geom_vline(xintercept = 5, linetype="dashed", size = 0.6, color = "blueviolet") +
  geom_vline(xintercept = 7, linetype="dashed", size = 0.6, color = "blueviolet") +
  annotate("text", x = 10, y = 100000, label = "A)", size = 6, fontface = 2)

mindepth_snp

# Generate the plot of Loci obteined of mindepth's parameters 
mindepth_loci <- ggplot(mindepth, aes(x=major_r, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of Loci", x = "major_r") +
  labs(colour = " Minimum \n number \n of samples", y = "Number of Loci", x = "Mindepth Majrule") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  geom_vline(xintercept = 5, linetype="dashed", size = 0.6, color = "blueviolet") +
  geom_vline(xintercept = 7, linetype="dashed", size = 0.6, color = "blueviolet") +
  annotate("text", x = 10, y = 4800, label = "B)", size = 6, fontface = 2)

mindepth_loci

##  plot all the trees in one
multiplot(mindepth_snp, mindepth_loci,  ncol=2, labels=c("A", "B"))

### Optimal Parameters ###

## Get  parameters file
parameters_opt <- read.table("../out/ipyrad_outfiles/stats/param_clust_opt.txt")
colnames(parameters_opt) <- c("parameter", "loci", "snp")


## Reorder the data frame, separate the column parameters by "_" 
## Filter by  clustering threshold
## Change the numeric columns to factors
par_opt <- parameters_opt %>% 
  separate(parameter, c("param", "clust", "mindepth", "min_sam"), "_") %>%
  mutate(clust = factor(clust, levels = c(87, 88, 89))) %>%
  mutate(mindepth = factor(mindepth, levels = c(7, 8, 9))) %>%
  mutate(min_sam = factor(min_sam, levels = c(30, 44, 60))) %>%
  mutate(min_sam = recode(min_sam, "30" = "40", "44" = "60", "60" = "80")) %>%
  mutate(opt = paste(clust, mindepth, sep = '_')) %>%
  select(param, opt, min_sam, loci, snp)


# Generate the plot of SNPs obteined of clust_threshold's parameters 
param_opt_snp <-  ggplot(par_opt, aes(x=opt, y=snp)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(colour = " Minimum \n number \n of samples", y = "Number of SNPs", x = "Clustering Threshold (% similarity)") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  annotate("text", x = 1, y = 50000, label = "A)", size = 8, fontface = 2)

param_opt_snp

# Generate the plot of Loci obteined of clust_threshold's parameters 
param_opt_loci <- ggplot(par_opt, aes(x=opt, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of Loci", x = "Cluster threshold") +
  labs(colour = " Minimum \n number \n of samples", y = "Number of Loci", x = "Clustering Threshold (% similarity)") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%")) +
  annotate("text", x = 1, y = 3000, label = "B)", size = 8, fontface = 2)

param_opt_loci

