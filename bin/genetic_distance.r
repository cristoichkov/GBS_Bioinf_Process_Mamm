library(plyr)
library(dplyr)
library(adegenet)
library(poppr)
library(ape)
library(ggplot2)


## function to extract a list of nodes and its tip labels from a tree
source("extract_nodes_tips.R")

## vector with your nodes 
nodes <- c(146, 144, 118, 132, 134, 137, 139, 115, 83, 84, 113, 92, 97, 103, 106)

## extract a list of nodes and its tip labels from a tree
nodes_tree <- extract_nodes_tips("../out/tree_raxml/RAxML_bipartitionsBranchLabels.opt_89_9_20", all_nodes = FALSE, nodes = nodes)

## convert nodes to dataframe
nodes_tree$node <- factor(nodes_tree$node)

## loop to split the samples according of their nodes and put them in a list
cls_lst <- list()

for (w in 1:length(levels(nodes_tree[,2]))){
  
  Cw <- nodes_tree %>% dplyr::filter(node == levels(nodes_tree[,2])[w])
  
  Cw <- as.vector(Cw[,1])
  
  cls_lst[[w]] <- Cw
}


## Clustering Treshold ##

## List the directories 
plink_folders_clust <- intersect(list.files("../out/plink/", pattern = "clust"), list.files("../out/plink/", pattern = "80"))


## parse raw

for (i in plink_folders_clust){
  
  plink_files <- list.files(paste0("../out/plink/", i))
  
  for (j in plink_files){
    
    ## Encuentra el patrón del nombre del archivo
    name <- stringr::str_extract(string = j, pattern = "clust_[0-9]+_[0-9]+")
    
    pl_raw <- read.delim(paste0("../out/plink/", i, "/", name, ".raw"), sep = " ")
    
    
    pl_raw$FID <-  mapvalues(pl_raw$FID, from = c("A11", "H10"), to = c("s1", "s1"))
    
    for (w in 1:length(cls_lst)){
      
      newvalues <- rep(paste0("s", w), time = length(cls_lst[[w]]))
      
      pl_raw$FID <-  mapvalues(pl_raw$FID, from = cls_lst[[w]], to = newvalues)
      
    }
    
    
    for (k in 1:nrow(pl_raw)){
      
      pl_raw[k,2] <- paste0(pl_raw[k,1], pl_raw[k,2])
      
    }
    
    
    write.table(pl_raw, file = paste0("../out/plink/", i, "/", name, "_mod_min.raw"), sep = " ", quote = FALSE, row.names = FALSE)
    
    
  }
}


pl_raw <- read.delim("../out/plink/mindepth_10_10_80_out/clust_82_80_mod.raw", sep = " ")

matinfo <- pl_raw %>% 
  select(FID, IID) %>%
  rename(Pop = FID, sample = IID)



## Create a dataframe empty
dists_clust <-data.frame()

for (i in plink_folders){
  
  plink_files <- list.files(paste0("../out/plink/", i))
  
  for (j in plink_files){
    
    ## Encuentra el patrón del nombre del archivo
    name <- stringr::str_extract(string = j, pattern = "clust_[0-9]+_[0-9]+")
    
    liSNPs <- read.PLINK(paste0("../out/plink/", i, "/", name, "_mod_min.raw"))
    
    ## separate the whole genlight object in smaller ones by creating blocks of loci. This facilitates computing
    blocks<- seploc(liSNPs, n.block=5) 
    class(blocks) #check if it is a list
    ## estimate distance matrix between individuals of each block
    D<- lapply(blocks, function(e) dist(as.matrix(e))) 
    names(D) #check names correspond to blocks
    # generate final general distance matrix by summing the distance matrixes
    Df<- Reduce("+", D) 
    
    ###  Compute distance matrix (euclidean)
    dat.d = dist(Df)
    
    ## add matinfo to dat.d matrix
    x <- match(labels(dat.d), matinfo$sample) #match labels with samples names
    x <- matinfo[x,] #create a new matrix with the samples from dat.d
    pop <- x$Pop #extract Pop info
    
    ### 3) Normalize distance matrix
    dat.d<- dat.d/max(dat.d)
    
    ### 4) Extract distances between indvs of each population
    dist.p<-data.frame()
    for (k in levels(pop(liSNPs))){
      # get the samples belonging to the i pop from the dad.d dist matrix
      s<-grep(k, labels(dat.d), value= TRUE, invert= FALSE) 
      # Transform dist matrix to matrix
      m<-as.matrix(dat.d)
      # select the samples to keep
      m<-m[s,s]
      # keep only lower triangle of the mat
      dist<-m[lower.tri(m)]
      # store data in the data.frame dists created externally 
      Pop <- rep(k,length(dist))  
      x<-cbind.data.frame(Pop, dist)
      
      dist.p<-rbind.data.frame(x,dist.p)
    }
    
    # add param info
    param <- rep(name,nrow(dist.p))
    x <- cbind.data.frame(param,dist.p)
    dists_clust <- rbind.data.frame(x,dists)
  }
}

write.csv(dists, file = "../out/ipyrad_outfiles/stats/clust_dist.csv")

dists_clust <- read.csv("../out/ipyrad_outfiles/stats/clust_dist.csv")


dists_sep_clust <- dists_clust %>% 
  separate(param, c("param", "value", "min_sam"), "_") %>%
  filter(param == "clust") %>%
  mutate(value = factor(value, levels = c(82, 85, 86, 87, 88, 89, 91, 94))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80))) %>%
  filter(Pop != "s15" & Pop != "s1" & Pop != "s10" & Pop != "s14", Pop != "s6") 

  dists_sep_clust$Pop <-  mapvalues(dists_sep_clust$Pop, from = c("s2", "s3", "s4", "s5", "s7", "s8", "s9", "s11", "s12", "s13"), 
                           to = c("Teh", "Cui", "Meis", "Cons", "Ton", "Hua", "Noch", "Acul", "Esp", "Per"))


dis_gen_clust <- dists_sep_clust %>% 
  ggplot(aes(x=Pop, y=dist, fill=factor(value))) +
  geom_boxplot() +
  labs(colour = " Minimum \n number \n of samples", y = "Genetic distance", x = "Populations") +
  scale_fill_discrete(name = "Clustering\nThreshold") +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))

dis_gen_clust 
  

ggsave(dis_gen_clust, file="../out/R_plots/Genetic_dist_clust.png", device="png", dpi = 300, width = 12, height = 7)


## List the directories 
plink_folders <- intersect(list.files("../out/plink/", pattern = "mindepth"), list.files("../out/plink/", pattern = "80"))


## parse raw

for (i in plink_folders){
  
  plink_files <- list.files(paste0("../out/plink/", i))
  
  for (j in plink_files){
    
    ## Encuentra el patrón del nombre del archivo
    name <- stringr::str_extract(string = j, pattern = "mindepth_[0-9]+_[0-9]+_[0-9]+")
    
    pl_raw <- read.delim(paste0("../out/plink/", i, "/", name, ".raw"), sep = " ")
    
    
    pl_raw$FID <-  mapvalues(pl_raw$FID, from = c("A11", "H10"), to = c("s1", "s1"))
    
    for (w in 1:length(cls_lst)){
      
      newvalues <- rep(paste0("s", w), time = length(cls_lst[[w]]))
      
      pl_raw$FID <-  mapvalues(pl_raw$FID, from = cls_lst[[w]], to = newvalues)
      
    }
    

    for (k in 1:nrow(pl_raw)){
      
      pl_raw[k,2] <- paste0(pl_raw[k,1], pl_raw[k,2])
      
    }
    
    
    write.table(pl_raw, file = paste0("../out/plink/", i, "/", name, "_mod_min.raw"), sep = " ", quote = FALSE, row.names = FALSE)
    
    
  }
}


## Create a dataframe empty
dists<-data.frame()

for (i in plink_folders){
  
  plink_files <- list.files(paste0("../out/plink/", i))
  
  for (j in plink_files){
    
    ## Encuentra el patrón del nombre del archivo
    name <- stringr::str_extract(string = j, pattern = "mindepth_[0-9]+_[0-9]+_[0-9]+")
    
    liSNPs <- read.PLINK(paste0("../out/plink/", i, "/", name, "_mod_min.raw"))
    
    ## separate the whole genlight object in smaller ones by creating blocks of loci. This facilitates computing
    blocks<- seploc(liSNPs, n.block=5) 
    class(blocks) #check if it is a list
    ## estimate distance matrix between individuals of each block
    D<- lapply(blocks, function(e) dist(as.matrix(e))) 
    names(D) #check names correspond to blocks
    # generate final general distance matrix by summing the distance matrixes
    Df<- Reduce("+", D) 
    
    ###  Compute distance matrix (euclidean)
    dat.d = dist(Df)
    
    ## add matinfo to dat.d matrix
    x <- match(labels(dat.d), matinfo$sample) #match labels with samples names
    x <- matinfo[x,] #create a new matrix with the samples from dat.d
    pop <- x$Pop #extract Pop info
    
    ### 3) Normalize distance matrix
    dat.d<- dat.d/max(dat.d)
    
    ### 4) Extract distances between indvs of each population
    dist.p<-data.frame()
    for (k in levels(pop(liSNPs))){
      # get the samples belonging to the i pop from the dad.d dist matrix
      s<-grep(k, labels(dat.d), value= TRUE, invert= FALSE) 
      # Transform dist matrix to matrix
      m<-as.matrix(dat.d)
      # select the samples to keep
      m<-m[s,s]
      # keep only lower triangle of the mat
      dist<-m[lower.tri(m)]
      # store data in the data.frame dists created externally 
      Pop <- rep(k,length(dist))  
      x<-cbind.data.frame(Pop, dist)
      
      dist.p<-rbind.data.frame(x,dist.p)
    }
    
    # add param info
    param <- rep(name,nrow(dist.p))
    x <- cbind.data.frame(param,dist.p)
    dists <- rbind.data.frame(x,dists)
}
}

dists_mindepth <- read.csv("../out/ipyrad_outfiles/stats/mindepth_dist.csv")


dists_sep_mindepth <- dists_mindepth %>% 
  separate(param, c("param", "mindept",  "mindep_rul","min_sam"), "_") %>%
  mutate(mindept = factor(mindept, levels = c(6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(mindep_rul = factor(mindep_rul, levels = c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12))) %>%
  mutate(min_sam = factor(min_sam, levels = c(40, 60, 80))) %>%
  filter(Pop != "s15" & Pop != "s1" & Pop != "s10" & Pop != "s14" & Pop != "s6" & mindep_rul != "2")  

dists_sep_mindepth$Pop <-  mapvalues(dists_sep_mindepth$Pop, from = c("s2", "s3", "s4", "s5", "s7", "s8", "s9", "s11", "s12", "s13"), 
                                  to = c("Teh", "Cui", "Meis", "Cons", "Ton", "Hua", "Noch", "Acul", "Esp", "Per"))


dis_gen_mindepth <- dists_sep_mindepth %>% 
  ggplot(aes(x=Pop, y=dist, fill=factor(mindep_rul))) +
  geom_boxplot() +
  labs(colour = " Minimum \n number \n of samples", y = "Genetic distance", x = "Populations") +
  scale_fill_discrete(name = "Mindepth") +
  theme(axis.text.x = element_text(face="bold", size=12, colour = "gray16"), 
        axis.text.y = element_text(face="bold", size=12, colour = "gray16")) +
  theme(axis.title.y = element_text(face="bold", size = rel(1.2), angle = 90, colour = "grey32")) +
  theme(axis.title.x = element_text(face="bold", size = rel(1.2), angle = 00, colour = "grey32"))


ggsave(dis_gen_mindepth, file="../out/R_plots/Genetic_dist_mindepth.png", device="png", dpi = 300, width = 12, height = 7)


