``config`` directory
====================

This directory contains the ``config.yaml`` file and sample tables prepared 
in subdirectories prepared for each modality condition. All unused entries 
in the sample tables are left empty.

``config.yaml``
~~~~~~~~~~~~~~~

This is a `snakemake configuration file 
<https://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html>`_.

Sample tables
~~~~~~~~~~~~~

``samples.tsv``
---------------

This is a default sample table and consists of the following columns:

- ``sample``: Unique accession/ID. Letters/numbers, underscores, dashes 
  or other symbols are accepted without spaces.
- ``replicates``: Optional, technical replicates
- ``genome``: Supported reference genomes are hg38 for human and mm10 for mouse.
- ``HDF5_Multiple_Assays``: Path to a HDF5 file containing multiple feature-by-barcode matrices
- ``RDS_Multiple_Assays``: Path to an RDS file containing multiple feature-by-barcode matrices,
  an alternative option to provide multiple feature-by-barcode matrices to HDF
- ``Gene.Expression``: Path to a single feature-by-barcode matrix containing 5’ or 3’ 
  Gene Expression counts
- ``Peaks``: Path to a single feature-by-barcode matrix containing ATAC peaks counts
- ``TF``: Path to a single feature-by-barcode matrix containing Transcription Factor counts.
- ``fragments``: Path to a ``fragments.tsv.gz`` file containing
- ``singlecell``: Optional, path to a csv file for 10X Genomics ATAC and multiome
- ``meta_*``: Optional, columns for metadata labels such as genotype, tissue, or batch


``aggregates.tsv``
------------------

The aggregates table is optional and  used to map library barcode labels to library IDs 
in aggregated input files. The aggregated input contains multiple biological replicates, 
which can be generated using ``cellranger-arc aggr`` (multiome), ``cellranger-atac aggr`` 
(scATAC-seq), or ``cellranger aggr`` (scRNA-seq). This table consists of the following 
columns:


- ``sample``: Unique accession/ID. Letters/numbers, underscores, dashes 
  or other symbols are accepted without spaces
- ``replicate``: Optional, technical replicates
- ``library_id``: Optional, labels associated with library barcode suffix for each sample
- ``bc_suffix``: Optional, a unique library label to all barcodes for each sample
- ``metadata*``: Optional, columns for additional metadata labels

``assays.tsv``
--------------

The assay table is only used if you have calculated custom feature-by-barcode counts matrices. 
For example, if one has a genome annotation file containing gene coordinates and enhancer 
coordinates, you can count all ATAC reads mapping to a gene and associated enhancers: 

Gene Activity Score = reads mapped within gene + reads mapped to enhancers

This table consists of the following columns:

- ``sample``: Unique accession/ID. Letters/numbers, underscores, dashes 
  or other symbols are accepted without spaces
- ``replicate``: Optional, technical replicates
- ``assay.name``: Optional, the name of custom feature-by-barcode counts matrix
- ``path``: Optional, the path to the custom feature-by-barcode counts matrix
