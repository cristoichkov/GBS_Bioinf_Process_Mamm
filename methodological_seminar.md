### Optimization of parameters in ipyrad.

Reduced genome representation techniques can be a useful tool in phylogenetic inference (Hou et al., 2015). Genotyping by sequencing (GBS) (Elshire et al., 2011), is a method that has proven useful for solving phylogenetic relationships in species complexes (Anderson, Thiele, Krauss, & Barrett, 2017), as well as to evaluate the structure genetics into populations (Otto et al., 2017). The main programs used to analyze the data obtained from GBS are stacks (Catchen et al., 2011) and ipyrad (Eaton, 2014). The difference between these two programs is that ipyrad uses a global alignment  algoritm through the USEARCH program (Edgar, 2010), which allows the presence of insertions and deletions (indels) making it possible to compare phylogenetically distant species (Pante et al. , 2015).

Among the most important parameters in ipyrad is the minimum coverage, which refers to the number of readings needed to consider an allele or locus. This parameter allows us to distinguish between a PCR/sequencing error and real variation. If this value is very low we can accept variation from an error and consider it real, while if we choose a high value we can generate allele and locus drop (Fig. 1). If we generate locus drop our results will have a lot of lost data, but if we allow allele drop we are inflicting homozygosis when the real state of the locus is heterozygous (Mastretta-Yanes et al., 2015).

<p align="center">
<img src="Mastretta.png" width="800">
</p>
<p align="center">
Figure 1.- Scheme showing the effects of using a low minimum coverage (= 2) and a high coverage (= 6), taken from Mastretta-Yanes et al. (2015)
</p>

The level of dissimilarity of the sequences is another parameter that is also important to take into account, since it allows us to distinguish paralogous loci. If we choose a very high value it will imply the risk of dividing the divergent alleles into separate loci when the orthologous differ by an amount greater than the similarity threshold, while lower similarity thresholds may allow the paralogous sequences to merge correctly into an orthologous site ( Nadukkalam Ravindran et al., 2018). Improving the de novo assembly of data is important to obtain good results and reduce error rates (Mastretta-Yanes et al., 2015). In phylogenetic studies, it performs explorations of parameters that have been useful to find trees with highly resolved, and strongly supported topologies (Tripp et al., 2017).
