##  This function calculates the bootstrap mean of RAxML_bipartitionsBranchLabels tree ##

## To run the function is necessary to install the package treeio 
library(treeio)

mean_bootstrap <- function(file){
  
  ## Read file RAxML_bipartitionsBranchLabels, file = "../RAxML_bipartitionsBranchLabels.namefile"
  tree_raxml <- read.raxml(file)
  
  ## Extract the values of  bootstrap and calculate the mean
  mean_boot <- mean(tree_raxml@data$bootstrap, na.rm = TRUE)
  
  return(mean_boot)
  
}
  
