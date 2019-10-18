## This function extracts a list of nodes and its tip labels from a tree ##

## To run the function is necessary to install these packages
library(phylotools)
library(treeio)


## Defines the name of the function, which accepts as parameters: 
## file = "../tree_file"
## all_nodes = if you want extract all nodes TRUE, If is FALSE you have to give a vector whit your nodes example nodes <- c(89, 128, 77)
## nodes = a vector with yor nodes

extract_nodes_tips <- function(file, all_nodes, nodes){
  
  if (all_nodes == "TRUE"){
## if you want all the nodes, you have to use `treeio` and read the tree
tree_raxml <- read.raxml(file)

tree_1 <- read.tree(file)

## create a vector with the nodes 
nodes <- tree_raxml@data$node

} else {
## read the tree
tree_1 <- read.tree(file)

}

## create a dataframe empty
phylo_clades <- data.frame()

for (i in nodes){
  
  ## Extract the tip labels according to whit the node 
  df <- extract.clade(tree_1, i)
  
  ## convert a data frame
  df <- as.data.frame(df$tip.label)
  
  ## change the column name
  colnames(df) <- "tip_label"
  
  ## repeat the node according to the row number
  name <- data.frame(rep(i, times = nrow(df)))
  
  ## change the column name
  colnames(name) <- "node"
  
  ## combine by column 
  df_n <- cbind(df, name)
  
  ## combine by row 
  phylo_clades <- rbind(phylo_clades, df_n)
  
  }

return(phylo_clades)

}
