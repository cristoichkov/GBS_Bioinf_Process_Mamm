library(ggtree)
library(ape)
library(treeio)
library(colorspace)
library(MoreTreeTools)
library(doMC)
library(dplyr)
library(ggExtra)
      
## function to extract a list of nodes and its tip labels from a tree
source("extract_nodes_tips.R")

## vector with your nodes 
nodes <- c(126, 115, 112, 141, 138, 108, 83, 99, 97, 81, 77, 146)

## extract a list of nodes and its tip labels from a tree
nodes_tree <- extract_nodes_tips("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_40_run1", all_nodes = FALSE, nodes = nodes)

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



tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_40_run1")

names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

ggtree(tree_1) + geom_tiplab() + geom_label2(aes(label = node), size = 3) + geom_rootpoint()

ggtree(tree_1) + geom_tiplab() + geom_label2(aes(label = bootstrap), size = 3) + geom_rootpoint()

tree_1 <- groupOTU(tree_1, cls_lst)

p1 <- ggtree(tree_1) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.00015,  nudge_y = 0.7)



tree_2 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_60_run1")

tree_2 <-  rename_taxa(tree_2, names, V1, V2)

tree_2 <- groupOTU(tree_2, cls_lst)

p2 <- ggtree(tree_2) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)



tree_3 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_80_run1")

tree_3 <-  rename_taxa(tree_3, names, V1, V2)

tree_3 <- groupOTU(tree_3, cls_lst)

p3 <- ggtree(tree_3) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)

##  plot all the trees in one
multiplot(p1, p2, p3, ncol=3, labels=c("A", "B", "C"))


