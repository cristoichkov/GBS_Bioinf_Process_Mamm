library(ggtree)
library(ape)
library(treeio)
library(colorspace)
library(MoreTreeTools)
library(doMC)
library(dplyr)
library(ggExtra)
library(tidyr)

tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20")

names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

ggtree(tree_1) + geom_tiplab() + geom_label2(aes(label = node), size = 3) + geom_rootpoint()

ggtree(tree_1) + geom_tiplab() + geom_rootpoint()

nodes_tree <- read.csv("../meta/tips_label.csv")

nodes_tree$TIP <- as.factor(nodes_tree$TIP)
nodes_tree$SP <- as.factor(nodes_tree$SP)

## loop to split the samples according of their nodes and put them in a list
cls_lst <- list()

for (w in 1:length(levels(nodes_tree[,2]))){
  
  Cw <- nodes_tree %>% filter(SP == levels(nodes_tree[,2])[w])
  
  Cw <- as.vector(Cw[,1])
  
  cls_lst[[w]] <- Cw
}

names(cls_lst) <- c("M_albilanata", "M_crucigera", "M_dixanthocentron", "M_duoformis", "M_haageana", "M_huitzilopochtli", "M_lanata", 
                    "M_magnimamma", "M_mystax", "M_supertexta")

tree_1 <- groupOTU(tree_1, cls_lst)

tree_1

p1 <- ggtree(tree_1) + geom_tiplab(aes(color=group)) + 
  geom_text(aes(label=bootstrap/100), col = "black", size = 3, nudge_x = -0.00015,  nudge_y = 0.7) +
  theme_tree2() 


ggsave(p1, file="../out/R_plots/super.png", device="png", dpi = 300, width = 19, height = 15)



### Compare Trees ##

tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20")

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

tree_1 <- groupOTU(tree_1, cls_lst)

p1 <- ggtree(tree_1, aes(color=group)) %>% ape::rotateConstr(tree_1, p1$data$isTip)

d1 <- p1$data


  
  tree_2 <- read.raxml(paste0("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_40"))
  
  tree_2 <-  rename_taxa(tree_2, names, V1, V2)
  
  co <- tree_2@phylo$tip.label[order(match(tree_2@phylo$tip.label, tree_1@phylo$tip.label))]
  
  tree_2 <- ape::rotateConstr(tree_2, co)
  
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
  
  
  tree_com
  
  
  comp_tree_list[[i]] <- tree_com

comp_tree_list <- comp_tree_list[c("40", "80", "60", "100")]

ggsave(multiplot(plotlist = comp_tree_list,  ncol = 2, labels=c("A", "C", "B", "D"), label_size = 16), 
       file="../out/R_plots/Compare_trees.png", device="png", dpi = 300, width = 30, height = 30)


comp_tree_list