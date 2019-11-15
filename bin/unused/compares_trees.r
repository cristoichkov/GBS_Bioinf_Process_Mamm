library(ape)
library(treeio)
library(ggtree)
library(ggplot2)
library(dplyr)
library(phylobase)

## function to extract a list of nodes and its tip labels from a tree
source("extract_nodes_tips.R")

## vector with your nodes 
nodes <- c(128, 139, 122, 116, 114, 144, 109, 95, 85, 93, 83, 77)

## extract a list of nodes and its tip labels from a tree
nodes_tree <- extract_nodes_tips("../out/raxml/clust_89_40_raxml/RAxML_bipartitionsBranchLabels.clust_89_40_run1", all_nodes = FALSE, nodes = nodes)

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

## 
tree_1 <- read.raxml("../out/raxml/clust_89_40_raxml/RAxML_bipartitionsBranchLabels.clust_89_40_run1")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

phylo <- groupClade(tree_1, .node = c(128, 139, 122, 116, 114, 144, 109, 95, 85, 93, 83, 77))

tree_1@phylo <- phylo

p1 <- ggtree(tree_1, aes(color=group))

tree_2 <- read.raxml("../out/raxml/clust_89_80_raxml/RAxML_bipartitionsBranchLabels.clust_89_80_run1")

tree_2 <-  rename_taxa(tree_2, names, V1, V2)

phylo <- groupClade(tree_2, .node = 75)

tree_2@phylo <- phylo

p2 <- ggtree(tree_2, aes(color=group))

d1 <- p1$data

d2 <- p2$data

## reverse x-axis and 
## set offset to make the tree in the right hand side of the first tree

d2$x <- max(d2$x) - d2$x + max(d1$x) + 0.01

dd <- bind_rows(d1, d2) %>% 
  filter(!is.na(label))

pp <- p1 +  geom_tree(data=d2, col = "black") + 
  geom_text(aes(label=bootstrap/100), col = "black") +
  geom_text(data = d2, aes(label=bootstrap/100), col = "grey35") 

pp +  geom_line(aes(x, y, group=label), data=dd) +
  geom_tiplab(data = d1, hjust = -0.1, linetype = "dashed", linesize = 0.001) +
  geom_tiplab(data = d2, hjust = 1.1, linetype = "dashed", linesize = 0.001, color = "grey35") 









