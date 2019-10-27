library(ggtree)
library(ape)
library(treeio)
library(colorspace)
library(MoreTreeTools)
library(doMC)
library(dplyr)
library(ggExtra)
library(tidyr)
      
## function to extract a list of nodes and its tip labels from a tree
source("extract_nodes_tips.R")

## vector with your nodes 
nodes <- c(146, 144, 118, 132, 134, 137, 139, 115, 83, 84, 113, 92, 97, 103, 106)

## extract a list of nodes and its tip labels from a tree
nodes_tree <- extract_nodes_tips("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20", all_nodes = FALSE, nodes = nodes)

## convert nodes to dataframe
nodes_tree$node <- factor(nodes_tree$node)

## Read the file with the mammillarias name 
names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")

## loop to change the names of tips in the file nodes tree
for (i in 1:nrow(names)){
  
  x <- names[i,1]
  
  y <- names[i,2]
  
  for (n in 1:nrow(nodes_tree)){
    
    if (nodes_tree[n,1] == x){
      
      nodes_tree[n,1] <- y
    }
  }
}

## loop to split the samples according of their nodes and put them in a list
cls_lst <- list()

for (w in 1:length(levels(nodes_tree[,2]))){
  
  Cw <- nodes_tree %>% filter(node == levels(nodes_tree[,2])[w])
  
  Cw <- as.vector(Cw[,1])
  
  cls_lst[[w]] <- Cw
}



tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20")

names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

ggtree(tree_1) + geom_tiplab() + geom_label2(aes(label = node), size = 3) + geom_rootpoint()

ggtree(tree_1) + geom_tiplab() + geom_label2(aes(label = bootstrap), size = 3) + geom_rootpoint()

tree_1 <- groupOTU(tree_1, cls_lst)

p1 <- ggtree(tree_1) + geom_tiplab(aes(color=group)) + 
  geom_text(aes(label=bootstrap/100), col = "black", size = 3, nudge_x = -0.00015,  nudge_y = 0.7) +
  theme_tree2() +
  geom_vline(xintercept = 0.0169, linetype="dashed", size = 0.6, color = "red")
  
p1

c1 <- ggtree(tree_1) 

nl1 <- ggtree(tree_1, branch.length='none')



tree_2 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_40")

tree_2 <-  rename_taxa(tree_2, names, V1, V2)

tree_2 <- groupOTU(tree_2, cls_lst)

p2 <- ggtree(tree_2) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)

c2 <- ggtree(tree_2) 

nl2 <- ggtree(tree_2, branch.length='none')



tree_3 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_60")

tree_3 <-  rename_taxa(tree_3, names, V1, V2)

tree_3 <- groupOTU(tree_3, cls_lst)

p3 <- ggtree(tree_3) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)

c3 <- ggtree(tree_3) 

nl3 <- ggtree(tree_3, branch.length='none')


tree_4 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_80")

tree_4 <-  rename_taxa(tree_4, names, V1, V2)

tree_4 <- groupOTU(tree_4, cls_lst)

p4 <- ggtree(tree_4) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                                  nudge_x = -0.0001,  nudge_y = 0.7)

c4 <- ggtree(tree_4) 

nl4 <- ggtree(tree_4, branch.length='none')


tree_5 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_100")

tree_5 <-  rename_taxa(tree_5, names, V1, V2)

tree_5 <- groupOTU(tree_5, cls_lst)

p5 <- ggtree(tree_5) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                                  nudge_x = -0.0001,  nudge_y = 0.7)

c5 <- ggtree(tree_5) 

nl5 <- ggtree(tree_5, branch.length='none')

##  plot all the trees in one
multiplot(c5, c4, c3, c2, c1, ncol=5, labels=c("A", "B", "C", "D", "E"))

##  plot all the trees in one
multiplot(nl5, nl4, nl3, nl2, nl1, ncol=5, labels=c("A", "B", "C", "D", "E"))


## Call the function ipyrad_extract_table
source("mean_bootstrap_raxml.R")


## List the directories 
files <- list.files("../out/tree_raxml")


## Create a dataframe empty
mean_boot <- data.frame()


for (i in files){
    
    ## Since the directories end in _outfiles we have to stay alone with the folder identifier in this case clust_ [0-9]+_ [0-9]+
    name <- stringr::str_extract(string = i, pattern = "opt_89_9_[0-9]+")
    
    ## Extract the desired tree, for this we use paste0 to enter the folders where are the trees and the mean as dataframe
    tab <-  as.data.frame(mean_bootstrap(paste0("../out/tree_raxml/", i)))
    
    ## Change the colname of mean bootstrap
    colnames(tab) <- "mean_boot"
    
    ## Create a second column with the name of the parameter
    tab$param <- (name)
    
    ## combine the data frames by rows
    mean_boot <- rbind(mean_boot, tab)
    
}


## Reorder the data frame, separate the column parameters by "_" 
## Change the numeric columns to factors
mean_boot <- mean_boot %>% 
  separate(param, c("param", "clust", "mindepth", "min_sam"), "_") %>%
  mutate(min_sam = factor(min_sam, levels = c(100, 80, 60, 40, 20))) %>%
  mutate(min_sam = factor(min_sam, labels = c("0", "20", "40", "60", "80")))

ggplot(mean_boot, aes(x=min_sam, y=mean_boot, group = clust)) + geom_point(size = 3) + geom_line() +
  scale_y_continuous(breaks = seq(0, 100, by=15)) +
  labs(y = "Mean bootstrap values", x = "Percentage of missing data ")
