
.. why-use:

Why use `multiome-wf`?
======================

`multiome-wf` is a Snakemake workflow for common single cell sequencing analyses. 

There are a multitude of workflows out there for single cell sequencing analyses.
What makes `multiome-wf` different?


Designed for multimodal analyses
--------------------------------

With the advent of new sequencing methods and associated data sets, combining different
single cell sequencing modalities is cumbersome and error-prone. A core feature of the
`multiome-wf` is standardizing how disparate data types are combined and preprocessed
prior to downstream analyses.

The workflow was build around 10X Genomics products, but should work with any single 
cell data set as long as the input matrices have been properly formatted.

Some of the modalities this workflow supports include:

- Gene Expression: quantified by cellranger count and cellranger aggr

- ATAC: quantified by cellranger-atac count and cellranger aggr

- Multiome (Gene Exression + ATAC from same cell), CITE-Seq: quantified by cellranger-arc count and cellranger-arc aggr

- Cell Multiplexing (Cell Multiplexing Oligos): demultiplexed using cellranger pipelines.

- Multiple Batches, Multiple experimental conditions
