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


### Compare Trees ##

tree_1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20")

tree_1 <- as.phylo(tree_1)

tree_1 <-  rename_taxa(tree_1, names, V1, V2)

tree_1 <- groupOTU(tree_1, cls_lst)

tree_1$tip.label

tree_3 <- read.raxml(paste0("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_60"))

tree_3 <- as.phylo(tree_3)

tree_3 <- rename_taxa(tree_3, names, V1, V2)

tree_3$tip.label

co <- tree_3$tip.label[order(match(tree_3$tip.label, tree_1$tip.label))]

newtr3 <- rotateConstr(tree_3, co)

newtr3$tip.label



p1 <- ggtree(tree_1, aes(color=group))

p1 <- p1 %>% ggtree::rotate(92) %>% ggtree::rotate(93) %>% ggtree::rotate(96) %>% ggtree::rotate(117) %>% ggtree::rotate(131)

p1 + geom_label2(aes(label = node), size = 3) + geom_tiplab()

d1 <- p1$data

p3 <- ggtree(newtr3) 

d3 <- p3$data

## reverse x-axis and 
## set offset to make the tree in the right hand side of the first tree

d3$x <- max(d3$x) - d3$x + max(d1$x) + 0.01

dd <- bind_rows(d1, d3) %>% 
  filter(!is.na(label))

pp <- p1 +  geom_tree(data=d3, col = "black") 

pp

tree_com_3 <- pp +  geom_line(aes(x, y, group=label), data=dd) +
  geom_tiplab(data = d1, hjust = -0.1, linetype = "dashed", linesize = 0.001) +
  geom_tiplab(data = d3, hjust = 1.1, linetype = "dashed", linesize = 0.001, color = "grey35") 


tree_com_3
