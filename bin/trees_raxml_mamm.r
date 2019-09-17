library(ggtree)
library(ape)


tree_run1 <- read.raxml("../out/raxml/clust_88_40_raxml/RAxML_bipartitionsBranchLabels.clust_88_40_run1")


names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")


tree_run1 <- rename_taxa(tree_run1, names, V1, V2)


ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap)) + geom_rootpoint()








