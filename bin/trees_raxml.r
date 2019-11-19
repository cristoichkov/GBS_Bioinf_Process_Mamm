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

ggtree(tree_1) + geom_tiplab() + geom_rootpoint()

tree_1 <- groupOTU(tree_1, cls_lst)

p1 <- ggtree(tree_1) + geom_tiplab(aes(color=group)) + 
  geom_text(aes(label=bootstrap/100), col = "black", size = 3, nudge_x = -0.00015,  nudge_y = 0.7) +
  theme_tree2() +
  geom_vline(xintercept = 0.0169, linetype="dashed", size = 0.6, color = "red")
  
p1

c1 <- ggtree(tree_1) 

c1


tree_2 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_40")

tree_2 <-  rename_taxa(tree_2, names, V1, V2)

tree_2 <- groupOTU(tree_2, cls_lst)

p2 <- ggtree(tree_2) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)

c2 <- ggtree(tree_2) 

c2



tree_3 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_60")

tree_3 <-  rename_taxa(tree_3, names, V1, V2)

tree_3 <- groupOTU(tree_3, cls_lst)

p3 <- ggtree(tree_3) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                            nudge_x = -0.0001,  nudge_y = 0.7)

c3 <- ggtree(tree_3) 

c3


tree_4 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_80")

tree_4 <-  rename_taxa(tree_4, names, V1, V2)

tree_4 <- groupOTU(tree_4, cls_lst)

p4 <- ggtree(tree_4) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                                  nudge_x = -0.0001,  nudge_y = 0.7)

c4 <- ggtree(tree_4) 

c4


tree_5 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_100")

tree_5 <-  rename_taxa(tree_5, names, V1, V2)

tree_5 <- groupOTU(tree_5, cls_lst)

p5 <- ggtree(tree_5) + geom_tiplab(aes(color=group)) +  geom_text(aes(label=bootstrap/100), col = "black", size = 3, 
                                                                  nudge_x = -0.0001,  nudge_y = 0.7)

c5 <- ggtree(tree_5) 

c5

##  plot all the trees in one

ggsave(multiplot(c5, c4, c3, c2, c1, ncol=5, labels=c("A", "B", "C", "D", "E")), 
       file="../out/R_plots/Phylogenetic_resolution.png", device="png", dpi = 300, width = 12, height = 6)




### Compare Trees ##

tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

phylo <- groupClade(tree_1, .node = c(146, 144, 118, 132, 134, 137, 139, 115, 83, 84, 113, 92, 97, 103, 106))

tree_1@phylo <- phylo

p1 <- ggtree(tree_1, aes(color=group))

d1 <- p1$data

comp_tree_list <- list()

for (i in c("40", "60", "80", "100")){
  
  tree_2 <- read.raxml(paste0("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_", i))
  
  tree_2 <-  rename_taxa(tree_2, names, V1, V2)
  
  phylo <- groupClade(tree_2, .node = 75)
  
  tree_2@phylo <- phylo
  
  p2 <- ggtree(tree_2, aes(color=group))
  
  d2 <- p2$data
  
  ## reverse x-axis and 
  ## set offset to make the tree in the right hand side of the first tree
  
  d2$x <- max(d2$x) - d2$x + max(d1$x) + 0.01
  
  dd <- bind_rows(d1, d2) %>% 
    filter(!is.na(label))
  
  pp <- p1 +  geom_tree(data=d2, col = "black") + 
    geom_text(aes(label=bootstrap/100), col = "black", size = 3, nudge_x = -0.0003,  nudge_y = 0.7) +
    geom_text(data = d2, aes(label=bootstrap/100), col = "grey35", size = 3, nudge_x = 0.0004,  nudge_y = 0.7) 
  
  
  tree_com <- pp +  geom_line(aes(x, y, group=label), data=dd) +
    geom_tiplab(data = d1, hjust = -0.1, linetype = "dashed", linesize = 0.001) +
    geom_tiplab(data = d2, hjust = 1.1, linetype = "dashed", linesize = 0.001, color = "grey35") 
  
  comp_tree_list[[i]] <- tree_com
}

comp_tree_list <- comp_tree_list[c("40", "80", "60", "100")]

ggsave(multiplot(plotlist = comp_tree_list,  ncol = 2, labels=c("A", "C", "B", "D"), label_size = 16), 
       file="../out/R_plots/Compare_trees.png", device="png", dpi = 300, width = 30, height = 30)


comp_tree_list
