      library(ggtree)
      library(ape)
      library(treeio)
library(colorspace)
library(MoreTreeTools)
library(doMC)


tree_run1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.clust_89_40_run1")

ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = node), size = 3) + geom_rootpoint()

tree_run1 <- groupClade(tree_run1, .node = c(127, 122, 113, 144, 109, 95, 82))


tree_mamm <- ggtree(tree_run1, aes(color=group)) + geom_tiplab() 

ggsave(tree_mamm, file="../out/R_plots/tree_mamm.png", device="png", dpi = 100)


  names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")


tree_run1 <-  rename_taxa(tree_run1, names, V1, V2)

tree_run1@phylo$tip.label
  
ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap)) + geom_rootpoint() +
  geom_cladelabel(node=127, label="C1", color="red2", align=TRUE, barsize = 2) +
  geom_cladelabel(node=122, label="C2", color="blue", align=TRUE, barsize = 2) +
  geom_cladelabel(node=116, label="C3", color="green", align=TRUE, barsize = 2)
  

ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap), size = 3) + geom_rootpoint()


ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap))
n <- detectCores()
# set-up
registerDoMC(cores=n)
# example tree
tree <- rtree(1000)

nodes

ggtree(tree) + geom_tiplab() + geom_label2(aes(label = node)) + geom_rootpoint()

# find all internal nodes in tree
nds <- (getSize(tree) + 1):(tree$Nnode + getSize(tree))
# generate inital 'loop dataframe' for plyr
l_data <- data.frame(node=nds, stringsAsFactors=FALSE)
res <- plyr::mlply(.data=l_data, .fun=getChildren, tree=tree, .parallel=TRUE)
res <- res[1:length(res)]  # remove the 'attr's
# add children for each tip, which is just the tip, for consistency
res[tree$tip.label] <- tree$tip.label






tree_run1 <- read.raxml("../out/tree_raxml/RAxML_bipartitionsBranchLabels.clust_89_40_run1")

names <- read.csv("../meta/Mamm_names.csv", header = FALSE, sep = "\t")

tree_run1 <-  rename_taxa(tree_run1, names, V1, V2)

names_clades <- read.csv("../meta/Mamm_clades_chlor.csv")

p <- ggtree(tree_run1) + geom_tiplab() + geom_label2(aes(label = bootstrap), size = 3) + geom_rootpoint()


p$labels$label

p %<+% names_clades + 
  geom_tiplab(aes(fill = factor(clade_chorl)),
              color = "black", # color for label font
              geom = "label",  # labels not text
              label.padding = unit(0.15, "lines"), # amount of padding around the labels
              label.size = 0) 

p

ggsave(pl_boost, file="../out/R_plots/Clust_Tresh_bootstrap.png", device="png", dpi = 100)
