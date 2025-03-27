
.. _overview-output:

Overview of output files
========================

The `multiome-wf` creates a ``results`` folder in the ``workflow`` directory upon completion 
of a run. All output files are saved in this directory.


``results`` directory
~~~~~~~~~~~~~~~~~~~~~

The ``results`` folder contains subfolders and output files. Below is an example of the directory 
structure from a Multiome analysis:

.. code-block:: bash

    $ tree workflow/results/
    workflow/results/
    ├── add_macs_peaks
    │   ├── report.html
    │   └── seurat.rds
    ├── build_annotation
    │   ├── annotation.rds
    │   ├── report.html
    │   └── report.md
    ├── chooser_plot
    │   ├── integrated_0
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   ├── integrated_1
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   ├── integrated_3
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   ├── intermediates_dir
    │   ├── unintegrated_0
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   ├── unintegrated_1
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   ├── unintegrated_2
    │   │   ├── choice.rds
    │   │   ├── clustered_data.rds
    │   │   ├── median_ci.xlsx
    │   │   └── report.html
    │   └── unintegrated_3
    │       ├── choice.rds
    │       ├── clustered_data.rds
    │       ├── median_ci.xlsx
    │       └── report.html
    ├── chooser_run
    │   ├── integrated_0
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   ├── integrated_1
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   ├── integrated_3
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   ├── intermediates_dir
    │   │   ├── integrated_0
    │   │   ├── integrated_1
    │   │   ├── integrated_3
    │   │   ├── unintegrated_0
    │   │   ├── unintegrated_1
    │   │   ├── unintegrated_2
    │   │   └── unintegrated_3
    │   ├── unintegrated_0
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   ├── unintegrated_1
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   ├── unintegrated_2
    │   │   ├── frequency_grouped_0.6.rds
    │   │   ├── frequency_grouped_0.8.rds
    │   │   ├── frequency_grouped_1.2.rds
    │   │   ├── frequency_grouped_1.4.rds
    │   │   ├── frequency_grouped_1.rds
    │   │   ├── res_0.6
    │   │   │   └── report.html
    │   │   ├── res_0.8
    │   │   │   └── report.html
    │   │   ├── res_1
    │   │   │   └── report.html
    │   │   ├── res_1.2
    │   │   │   └── report.html
    │   │   ├── res_1.4
    │   │   │   └── report.html
    │   │   ├── seurat_obj_0.6.rds
    │   │   ├── seurat_obj_0.8.rds
    │   │   ├── seurat_obj_1.2.rds
    │   │   ├── seurat_obj_1.4.rds
    │   │   ├── seurat_obj_1.rds
    │   │   ├── silhouette_0.6.rds
    │   │   ├── silhouette_0.8.rds
    │   │   ├── silhouette_1.2.rds
    │   │   ├── silhouette_1.4.rds
    │   │   ├── silhouette_1.rds
    │   │   ├── silhouette_grouped_0.6.rds
    │   │   ├── silhouette_grouped_0.8.rds
    │   │   ├── silhouette_grouped_1.2.rds
    │   │   ├── silhouette_grouped_1.4.rds
    │   │   └── silhouette_grouped_1.rds
    │   └── unintegrated_3
    │       ├── frequency_grouped_0.6.rds
    │       ├── frequency_grouped_0.8.rds
    │       ├── frequency_grouped_1.2.rds
    │       ├── frequency_grouped_1.4.rds
    │       ├── frequency_grouped_1.rds
    │       ├── res_0.6
    │       │   └── report.html
    │       ├── res_0.8
    │       │   └── report.html
    │       ├── res_1
    │       │   └── report.html
    │       ├── res_1.2
    │       │   └── report.html
    │       ├── res_1.4
    │       │   └── report.html
    │       ├── seurat_obj_0.6.rds
    │       ├── seurat_obj_0.8.rds
    │       ├── seurat_obj_1.2.rds
    │       ├── seurat_obj_1.4.rds
    │       ├── seurat_obj_1.rds
    │       ├── silhouette_0.6.rds
    │       ├── silhouette_0.8.rds
    │       ├── silhouette_1.2.rds
    │       ├── silhouette_1.4.rds
    │       ├── silhouette_1.rds
    │       ├── silhouette_grouped_0.6.rds
    │       ├── silhouette_grouped_0.8.rds
    │       ├── silhouette_grouped_1.2.rds
    │       ├── silhouette_grouped_1.4.rds
    │       └── silhouette_grouped_1.rds
    ├── cluster
    │   ├── integrated_0
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   ├── integrated_1
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   ├── integrated_3
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   ├── intermediates_dir
    │   ├── unintegrated_0
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   ├── unintegrated_1
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   ├── unintegrated_2
    │   │   ├── barcodes.rds
    │   │   ├── clustered_data.rds
    │   │   └── report.html
    │   └── unintegrated_3
    │       ├── barcodes.rds
    │       ├── clustered_data.rds
    │       └── report.html
    ├── combine
    │   ├── report.html
    │   └── seurat_combined.rds
    ├── create_seurat
    │   ├── rep1_homo-nan.report.html
    │   ├── rep1_homo-nan.seurat_raw.rds
    │   ├── rep1_wt-nan.report.html
    │   └── rep1_wt-nan.seurat_raw.rds
    ├── diff_analysis
    │   ├── integrated_0
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── integrated_1
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── integrated_3
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── unintegrated_0
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── unintegrated_1
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── unintegrated_2
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── unintegrated_3
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   ├── wnn_0
    │   │   ├── markers.tsv
    │   │   └── report.html
    │   └── wnn_1
    │       ├── markers.tsv
    │       └── report.html
    ├── integrate
    │   ├── integrated_0.rds
    │   ├── integrated_0.report.html
    │   ├── integrated_1.rds
    │   ├── integrated_1.report.html
    │   ├── integrated_3.rds
    │   └── integrated_3.report.html
    ├── macs2
    │   ├── macspeaks.tsv
    │   ├── macspeaks.tsv.gz
    │   ├── macspeaks.tsv.gz.tbi
    │   ├── NA_control_lambda.bdg
    │   ├── NA_control_lambda.bigwig
    │   ├── NA_peaks.narrowPeak
    │   ├── NA_peaks.xls
    │   ├── NA_summits.bed
    │   ├── NA_treat_pileup.bdg
    │   └── NA_treat_pileup.bigwig
    ├── merge_macs_prep
    │   ├── Multiome.bed
    │   ├── report.html
    │   └── seurat.rds
    ├── normalize_reduce_dims
    │   ├── intermediates_dir
    │   ├── unintegrated_0
    │   │   ├── unintegrated_0.rds
    │   │   └── unintegrated_0.report.html
    │   ├── unintegrated_1
    │   │   ├── unintegrated_1.rds
    │   │   └── unintegrated_1.report.html
    │   ├── unintegrated_2
    │   │   ├── unintegrated_2.rds
    │   │   └── unintegrated_2.report.html
    │   └── unintegrated_3
    │       ├── unintegrated_3.rds
    │       └── unintegrated_3.report.html
    ├── qc
    │   ├── rep1_homo-nan.report.html
    │   ├── rep1_homo-nan.seurat_qc.rds
    │   ├── rep1_wt-nan.report.html
    │   └── rep1_wt-nan.seurat_qc.rds
    └── wnn
        ├── wnn_0
        │   ├── barcodes.rds
        │   ├── clustered_data.rds
        │   └── report.html
        └── wnn_1
            ├── barcodes.rds
            ├── clustered_data.rds
            └── report.html

    96 directories, 290 files



``html`` summary files
~~~~~~~~~~~~~~~~~~~~~~

Each ``html`` file is a summary file for each rule in the ``Snakefile``. Users can review computational 
details, related metrics, and visualized data. For example, the ``html`` summary in the ``qc`` folder
provides information about QC metrics, filtering thresholds, and the distribution of cells
before and after QC filtering.


``rds`` objects
~~~~~~~~~~~~~~~

Each ``rds`` contains an R object passed onto the next step. These objects may be intermediate/final
Seurat objects, R strings, annotations saved as ``GenomicRanges``. Ultimately, users are provided with 
the ``combined_seurat.rds`` file saved in the ``combine`` folder. This file contains a processed 
Seurat object, as shown in the following example:


.. code-block:: r

    ## An object of class Seurat 
    ## 870542 features across 15600 samples within 9 assays 
    ## Active assay: SCT (20354 features, 3000 variable features)
    ##  3 layers present: counts, data, scale.data
    ##  8 other assays present: Gene.Expression, Peaks, MACS, Gene.Activity, integrated_0_SCT, integrated_1_Peaks, integrated_2_MACS, integrated_3_Gene.Activity
    ##  19 dimensional reductions calculated: SCT_pca, SCT_umap, Peaks_lsi, Peaks_umap, MACS_lsi, MACS_umap, Gene.Activity_pca, Gene.Activity_umap, pca, integrated_0_pca, integrated_0_umap, integrated_1_lsi, integrated_1_umap, integrated_2_lsi, integrated_2_umap, integrated_3_pca, integrated_3_umap, wnn_0_umap, wnn_1_umap

This Seurat object contains raw and normalized count matrices for all modalities, metadata, and reduced
dimensions, which are available for further specialized analyses.

``markers.tsv`` table
~~~~~~~~~~~~~~~~~~~~~

Marker genes are saved as excel-readable, tab-separated files named ``markers.tsv``. These files are 
saved in per-modality sub-folders within the ``diff_analysis`` folder.

Below is an example of the first two rows from the ``markers.tsv`` computed in the ``unintegrated_1`` 
assay group:

======================= ===== ================ ===== ===== ========= ======= =============== ===== ====
Gene                    p_val avg_log2FC       pct.1 pct.2 p_val_adj cluster group           assay slot
======================= ===== ================ ===== ===== ========= ======= =============== ===== ====
chr4-95840476-95841400  0     2.60136012051654 0.443 0.084 0         0       seurat_clusters Peaks data
chr18-46109191-46110086 0     2.56059989117035 0.402 0.081 0         0       seurat_clusters Peaks data
======================= ===== ================ ===== ===== ========= ======= =============== ===== ====

The columns indicate the following:

- ``Gene``: Gene symbol (RNA-seq) or locus (ATAC-seq)
- ``p_val``: Raw p-values
- ``avg_log2FC``: Log2-transformed fold changes
- ``pct.1``, ``pct.2``: Percentage of cells expressing each gene in cells annotated the ``cluster``
  (``pct.1``) and not annotated to the ``cluster`` (``pct.2``)
- ``p_val_adj``: Adjusted p-value, False Discovery Rate (FDR) calculated using the 
  `Benjamini-Hochberg procedure <https://en.wikipedia.org/wiki/False_discovery_rate#BH_procedure>`_
- ``cluster``: Cluster where the given marker gene is differentially expressed
- ``group``: Metadata column used in differential testing
- ``assay``: Modality
- ``slot``: Count matrix used for differential testing (``counts`` for raw data, 
  ``data`` for normalized counts)

For computational details, refer to the `FindAllMarkers 
<https://satijalab.org/seurat/reference/findallmarkers>`_ function in Seurat.


MACS2 output
~~~~~~~~~~~~

Optionally, users can call ATAC peaks using `MACS2 
<https://genomebiology.biomedcentral.com/articles/10.1186/gb-2008-9-9-r137>`_. Configure the MACS2 run
as instructed in the :ref:`macs-peakcalling`. The output files are summarized below:

- ``*_peaks.narrowPeak``: Peak locations with peak summit, pvalue, and qvalue in BED6+4 format
- ``*_peaks.xls``: A tabular file which contains information about called peaks, including 
  pileup and fold enrichment
- ``*_summits.bed``: Peak summit locations for every peak. Recommended when identifying motifs at the
  binding sites.
- ``*_control_lambda.bdg``: fragment pileup saved in bedGraph; local lambda values from control
- ``*_treat_pileup.bdg``: fragment pileup saved in bedGraph; values from treatment
- ``*_control_lambda.bigwig``, ``*_treat_pileup.bigwig``: ``bigwig`` coverage files converted from bedGraph

The remaining files (e.g. ``macspeaks.*``) are pre-processed input files for MACS2 and are not considered
as outputs of the peak calling process.

