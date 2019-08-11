# Taxonomic delimitation of *Mammillaria haageana* (Cactaceae)

This repository contains a proposal of a workflow to process GBS data mainly with ipyrad (Fig. 1). I tested the performance of three different programs to demultiplex gbs data ([GBSX](https://github.com/GenomicsCoreLeuven/GBSX), [Stacks](http://catchenlab.life.illinois.edu/stacks/) and [ipyrad](https://ipyrad.readthedocs.io/index.html)). The filtering process was done in ipyrad. I made different assembled under different parameter settings, to find the optimal parameters for my dataset following the 80% rules ([Paris et al., 2017](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/2041-210X.12775)).

<p align="center">
<img src="workflow.jpg" width="550">
</p>
<p align="center">
Figure 1.- Workflow to process GBS dataset
</p>

#### Prerequisites

##### Software:
- [GBSX v1.3](https://github.com/GenomicsCoreLeuven/GBSX)
- [ipyrad 0.7.30](https://ipyrad.readthedocs.io/index.html)
- [Stacks 2.41](http://catchenlab.life.illinois.edu/stacks/)
- [R 3.6.1](https://www.r-project.org/)

##### R packages:
- ggplot2_3.2.0
- dplyr_0.8.0.3
- RColorBrewer_1.1-2
- reshape2_1.4.3

##### PC info
- Running under: Ubuntu 18.04.2 LTS
- Motherboard: Asus TUF B450M-plus gaming
- CPU: Ryzen 7 2700x
- RAM: G.Skill Trident Z DDR4 4 x 8GB


#### Directories:
###### bin
Contains scripts `ipyrad_param_stats.R` and `Reads_demultiplex_stats.R` used for the analysis.


###### data
Contains the results of demultiplex the raw data files:
 - `GBSX_reads_stats.csv`
 - `ipyrad_demultiplex_stats.csv`
 - `stacks_demultiplex_stats.txt`

Parameters optimization in ipyrad:
 - `ipyrad_param_stats.csv`

###### meta
-

#### Notes


#### Credits
##### Cristian Cervantes
