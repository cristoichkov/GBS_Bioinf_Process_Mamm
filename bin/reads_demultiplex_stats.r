# Packages to be used
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(reshape2)

## Load the results of demultiplex to ipyrad, stacks and gbsx and Sum of correctly match reads
gbsx <- read.table("../out/demultiplex_stats/GBSX_reads_stats.csv", sep = ",", header=TRUE)
sum(as.numeric(gbsx$total_sequences), na.rm = TRUE)

PyRad <- read.csv("../out/demultiplex_stats/ipyrad_demultiplex_stats.csv", sep = "\t", header=TRUE)
sum(as.numeric(PyRad$total_reads), na.rm = TRUE)

stacks <- read.table("../out/demultiplex_stats/stacks_demultiplex_stats.txt", sep = "\t", header=FALSE)
sum(as.numeric(stacks$V4), na.rm = TRUE)

## Create a dataframe with the percentages of match reads and no match reads
Software <- c("ipyrad", "Stacks", "GBSX")
Match_reads <- c(94.74, 95.41, 97.20)
No_match_reads <- c(5.25, 4.58, 2.79)
perf_soft <- data.frame(Software, Match_reads, No_match_reads)
perf_soft <- melt(data = perf_soft, id.vars = "Software", measure.vars = c("Match_reads", "No_match_reads"))

## Plot of software performance 
p_demul <- ggplot(perf_soft, aes(x = Software, y = value, fill = forcats::fct_rev(variable))) + 
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label = paste0(value,"%")), position = position_stack(vjust = .5), size = 4) +
  scale_fill_discrete(name = "", labels = c("Non-matching", "Matching")) +
  xlab("Demultiplex software") + ylab("Percentage of demultiplexed reads (%)") +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32")) +
  theme(legend.position="bottom")
  
ggsave(p_demul, file="../out/R_plots/Correctly_demultiplexed.png", device="png", dpi = 300, width = 7, height = 7)


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
  filter(!Muestra %in% mhsa_filt)

## Order levels of the column that ggplot2 uses in x so that they are in the desired order
msuper$ID<-factor(msuper$ID, levels = msuper$ID[order(msuper$Especie)])

## Create a color palette - https://medialab.github.io/iwanthue/
demultipex_colors <- c("#db6295", "#75b550", "#6a70d7", "#bbb136", "#563688", "#57ba75", "#bc51a8",
                       "#43c8ac", "#c04b3a", "#628ed6", "#c7782a", "#c584d5", "#587325", "#8b2d62", 
                       "#b7a951", "#ba4758", "#ae683b")

## Plot the number of reads obtained after demultiplex
n_reads <- ggplot(msuper, aes(x=ID, y=total_sequences, fill = Especie)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(breaks = c(6000000, 4000000, 2000000, 1000000, 800000)) +
  geom_hline(yintercept = 1000000, linetype="dashed", size = 0.6) +
  geom_hline(yintercept = 800000, linetype="dashed", size = 0.6) +
  labs(x = "Samples", y = "Number of reads", fill = "Species") +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  scale_fill_manual(name = "Taxa", values = demultipex_colors) +
  theme(axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))
  
ggsave(n_reads, file="../out/R_plots/Reads_per_sample.png", device="png", width = 12, height = 6, dpi = 300)


