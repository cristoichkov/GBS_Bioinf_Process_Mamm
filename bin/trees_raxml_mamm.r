library(ggtree)
library(ape)
library(treeio)
library(colorspace)

tree_run1 <- read.raxml("../out/raxml/clust_89_40_raxml/RAxML_bipartitionsBranchLabels.clust_89_40_run1")


names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")


tree_run1 <-  rename_taxa(tree_run1, names, V1, V2)


ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap)) + geom_rootpoint() +
  geom_cladelabel(node=127, label="C1", color="red2", align=TRUE, barsize = 2) +
  geom_cladelabel(node=122, label="C2", color="blue", align=TRUE, barsize = 2) +
  geom_cladelabel(node=116, label="C3", color="green", align=TRUE, barsize = 2)
  




ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = node)) + geom_rootpoint()

