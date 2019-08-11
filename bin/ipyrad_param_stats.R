# Load the datataset
clust_threshold <- read.csv("../data/ipyrad_param_stats.csv")


library(ggplot2)
library(dplyr)


# Convert clust_threshold Values in factor
clust_threshold$Value <- as.factor(clust_threshold$Value)

# Convert min_sam_loc values in factor
clust_threshold$min_sam_loc <- as.factor(clust_threshold$min_sam_loc)

# Filter only the clust_threshold values
clust_threshold_2 <- clust_threshold %>%
  filter(Param == "clust_threshold") %>%
  group_by(min_sam_loc)

# Show the structure of dataset
str(clust_threshold_2)

# Generate the plot of SNPs obteined of clust_threshold's parameters 
ggplot(clust_threshold_2, aes(x=Value, y=SNP)) +
  geom_line(aes(group=min_sam_loc, color=min_sam_loc), size=1) +
  labs(y = "Number of SNPs", x = "Clust threshold") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                      labels=c("40%", "60%", "80%"))
  

# Generate the plot of Loci obteined of clust_threshold's parameters
ggplot(clust_threshold_2, aes(x=Value, y=Loci)) +
  geom_line(aes(group=min_sam_loc, color=min_sam_loc), size=1) +
  labs(y = "Number of loci", x = "Clust threshold") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%"))

# Filter only the mindepth values
min_depth <- clust_threshold %>%
  filter(Param == "mindepth") %>%
  group_by(min_sam_loc)

# Generate the plot of SNP's obteined of mindepth's parameters
ggplot(min_depth, aes(x=Value, y=SNP)) +
  geom_line(aes(group=min_sam_loc, color=min_sam_loc), size=1) +
  labs(y = "Number of SNPs", x = "Mindepth majrule") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%"))

# Generate the plot of Loci obteined of mindepth's parameters
ggplot(min_depth, aes(x=Value, y=Loci)) +
  geom_line(aes(group=min_sam_loc, color=min_sam_loc), size=1) +
  labs(y = "Number of loci", x = "Mindepth majrule") +
  scale_color_discrete(breaks=c("40", "60", "80"),
                       labels=c("40%", "60%", "80%"))


# Create the dataframe with the iteraction of 80% clust_threshold values 

clust_threshold <- c("0.82/0.85", "0.85/0.88", "0.88/0.91", "0.91/0.94")
Value <-c(37, -6, -73, -39)

clust_threshold_3 <- data.frame(clust_threshold, Value)

# Generate the plot of the iteraction of 80% clust_threshold values
ggplot(clust_threshold_3, aes(x=clust_threshold, y=Value, group = 1)) +
  geom_point(size = 2, color = "coral3") + geom_line(size = 1, color = "cyan4", linetype = "dashed") + 
  labs(y = "Number of new Loci", x = "Iteration of clust threshold") 



