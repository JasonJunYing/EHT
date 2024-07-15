# EHT
## Injured endocardium obtains characteristics of haemogenic endothelium during adult zebrafish heart regeneration  
  1. Single cell sequencing data analysis:  
     To investigate the endocardial-to-haematopoietic transition (EHT) after heart injury, we integrated 6 published zebrafish single-cell RNA sequencing datasets containing steady-state and injured heart samples at different post-injury timepoints: 1) [GSE138181](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE138181) (Koth); 2) [GSE153170](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE153170) (Bakker); 3) [GSE172511](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE172511) (Sun); 4) [GSE159032](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159032) and [GSE158919](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE158919) (Hu); 5) [GSE188511](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE188511) (Kapuria); and 6) [GSE145980](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE145980) (Ma).
     
     These datasets were first preprocessed and analysed separatedly [(pre-analysis)](./preanalysis). Main steps included: 1)Quality control; 2)Normalization (10000 final counts, log-transformed); 3)Cell Cycle Assignment; 4)Select highly variable genes; 5)PCA and UMAP calculation
     
     Then, these datasets were integrated by normalized counts and used to conduct [Combined_analysis](Combined_analysis.ipynb):    
  (1) Highly variable genes selection (min_mean=0.02, max_mean=3, min_disp=0.3)  
  (2) PCA calculation  
  (3) Harmony integration (top 50 PCA)  
  (4) UMAP calculation  
  (5) Cell type definition (Euclidean distance with Hu et al's annotation)

      To investigate the EHT clusters, leiden clustering was performed directly or with the 'restrict_to' parameters [(Subcluster_definition.ipynb)](Subcluster_definition.ipynb).Also, to further investigate the inflammatory response in the endocardium after heart injury, the normalized counts of the endocardial cells from Hu et al’s data were extracted and re-analysed [(Endo_subcluster.ipynb)](Endo_subcluster.ipynb).  
  
      The rank-gene-groups function in Scanpy was used to identify marker genes for each subcluster with the method set to ’t-test'. The plots were generated using the umap/dotplot plotting functions in Scanpy [(EHT_plottings.ipynb)](EHT_plottings.ipynb):  
  (1) Figure 1 (D-G)  
  (2) Figure 2 (A,B,D)   
  (3) Figure 3  
  (5) Figure 6 (C,F)  
  (6) Figure 7 (A,B,C,E)  

2.[Lineage analysis](./lineage):  
Scar lineage tracing information was obtained from the GEO database [GSE159032](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159032). Lineage tree construction was performed using the R script Iterative_tree_building.R in the original manuscript, excluding the DMSO/IWR/morphine treatment samples:  
(1) [Iterative_tree_building](./lineage/Iterative_tree_building.ipynb)  
(2) [Calculate transition probablities](./lineage/lineage_analysis.R)  
(3) [Visulization](./lineage/lineage_directed_graph.R)  

3.[Trajectory analysis](./trajectory):  
(1) [PAGA (Partition-based graph abstraction)](./trajectory/EHT_PAGA.ipynb):  
	1)PAGA calculation  
  2)Filtering and positioning  
(2) [FateID](./trajectory/EHT_FateID_analysis.ipynb):  
  1)Cluster definition  
  2)Fate probability calculation  
  3)Fate bias visualization  

4.Background contamination analysis (SoupX):  
To investigate the influence of the soup contamination on the gene expression evaluation, we conducted contamination analysis using SoupX on the representative datasets:  
(1) [GSE138181_All (WT/runx1KO, 0/3dpi)](./SoupX/SoupX-Koth-All.ipynb)  
(2) [GSE159032_GSM4817944 (WT_3dpi)](./SoupX/SoupX-Hu-WT-3dpi.ipynb)  
Main steps include:  
  1)Contamination probability prediction  
  2)Non-expressing cluster definition  
  3)Soup fraction evalutaion  

The scripts for data type conversion between R and Python could be found in [conversions](./conversions).

