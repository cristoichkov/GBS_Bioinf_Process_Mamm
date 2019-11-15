## Packages used 
library(dplyr)
library(ggplot2)
library(tidyr)
library(ggtree)

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
  scale_color_discrete(breaks=c("40", "60", "80"), labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  annotate("text", x = 1, y = 65000, label = "A)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) 

clust_tresh_snp

# Generate the plot of Loci obteined of clust_threshold's parameters 
clust_tresh_loci <- ggplot(clust_thresh, aes(x=value, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(colour = " Minimum \n number \n of samples", y = "Number of Loci", x = "Clustering Threshold (% similarity)") +
  scale_color_discrete(breaks=c("40", "60", "80"), labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  annotate("text", x = 1, y = 3850, label = "B)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) 

clust_tresh_loci

ggsave(multiplot(clust_tresh_snp, clust_tresh_loci,  ncol=2, labels=c("A", "B")), 
       file="../out/R_plots/Clustering_num_loci_snps.png", device="png", dpi = 300, width = 12, height = 6)


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
  labs(colour = " Minimum \n number \n of samples", y = "Number of SNPs", x = "Mindepth") +
  scale_color_discrete(breaks=c("40", "60", "80"), labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  annotate("text", x = 10, y = 100000, label = "A)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) 

mindepth_snp

# Generate the plot of Loci obteined of mindepth's parameters 
mindepth_loci <- ggplot(mindepth, aes(x=major_r, y=loci)) +
  geom_line(aes(group=min_sam, color=min_sam), size=1) +
  labs(y = "Number of Loci", x = "major_r") +
  labs(colour = " Minimum \n number \n of samples", y = "Number of Loci", x = "Mindepth") +
  scale_color_discrete(breaks=c("40", "60", "80"), labels=c("40%", "60%", "80%")) +
  theme(legend.position = c(0.9, 0.5)) +
  annotate("text", x = 10, y = 4800, label = "B)", size = 6, fontface = 2) +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) 

mindepth_loci

ggsave(multiplot(mindepth_snp, mindepth_loci,  ncol=2, labels=c("A", "B")), 
       file="../out/R_plots/Mindepth_num_loci_snps.png", device="png", dpi = 300, width = 12, height = 6)
