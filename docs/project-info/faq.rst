
.. _faq:

Frequently Asked Questions
==========================


Some package versions configured in ``env.yaml`` are unavailable on conda
-------------------------------------------------------------------------

Specific package versions can become deprecated over time. The most straightforward approach is to delete
the version information for unavailable packages in ``env.yaml``. If alternative versions are incompatible 
with the rest of the packages, delete all version information except for the following packages:

.. code-block:: yaml

      # In env.yaml
      snakemake<8
      r-seurat>5
      r-signac>1.10


Users may encounter additional version incompatibilities. Manually configure package versions if necessary.

My input is non-10X Genomics dataset
------------------------------------

The `multiome-wf` has been designed for use with both 10X Genomics and non-10X Genomics datasets. 
Place your input matrices for barcodes, features, and read counts in the same folder, as instructed 
in the :ref:`non-tenx`. Once your input files are ready, provide this the path to this folder 
in the sample table (``samples.tsv``), as instructed in the :ref:`samples-table`.

`multiome-wf` is incompatible with my HPC environment
-----------------------------------------------------

Consult with your HPC staff to update your configuration based on the supported environment. Refer to 
the following pages for the default configuration:

- :ref:`cluster`
- :ref:`configure-hpc`


How do I troubleshoot if I encounter errors?
--------------------------------------------

The `multiome-wf` is designed to create Snakemake log files in the ``workflow/logs`` directory. Refer to
the error messages in the log files for troubleshooting.


I have biological and/or technical replicates
---------------------------------------------

We define biological and technical replicates as outlined in the :ref:`replicates` section.

Once confirming that all the technical replicates were properly sequenced, read counts are
summed across technical replicates by setting the input of ``cellranger count`` (RNA-seq), 
``cellranger-arc count`` (ATAC-seq), or ``cellranger-arc count`` (Multiome) to technical replicates. 
Technical replicates prepared using Non-10X Genomics platforms follow equivalent steps. Alternatively, 
the `multiome-wf` performs count aggregation for samples labeled with the same value
in the ``replicate`` column of the sample table (``samples.tsv``) or the aggregates table 
(``aggregates.tsv``). 

Read counts from independent biological replicates are not aggregated to preserve biological 
variability. For users analyzing 10X Genomics datasets, ``cellranger aggr`` (RNA-seq), 
``cellranger-arc aggr`` (ATAC-seq), or ``cellranger-arc aggr`` is optionally available for creating
a concatenated feature-barcode matrix along with a `cloupe 
<https://www.10xgenomics.com/support/software/loupe-browser/latest>`_ file. The sample table 
(``samples.tsv``) accepts input for both per-biological replicate matrices and a concatenated matrix.
If you provide per-biological replicate matrices, each row corresponds to a single biological replicate
in the sample table. If you provide a concatenated matrix, users can provide per-biological replicate 
metadata in the aggregates table where each row corresponds to a single biological replicate. 
Learn more about building the sample and aggregates tables:

- ``replicate`` in sample table: :ref:`samples-replicate`
- ``replicate`` in aggregates table: :ref:`aggr-replicate`

How do I explore my data?
-------------------------

The `multiome-wf` generates a modality-combined Seurat object, saved in 
``workflow/results/combine/seurat_combined.rds``. Users will need the `Seurat 
<https://satijalab.org/seurat/>`_ package to open this object in R. Once imported, count matrices 
and dimensionality reductions for each modality are provided in the Seurat object, as shown below:

.. code-block:: r

   ## An object of class Seurat
   ## 870542 features across 15600 samples within 9 assays
   ## Active assay: SCT (20354 features, 3000 variable features)
   ##  3 layers present: counts, data, scale.data
   ##  8 other assays present: Gene.Expression, Peaks, MACS, Gene.Activity, integrated_0_SCT, integrated_1_Peaks, integrated_2_MACS, integrated_3_Gene.Activity
   ##  19 dimensional reductions calculated: SCT_pca, SCT_umap, Peaks_lsi, Peaks_umap, MACS_lsi, MACS_umap, Gene.Activity_pca, Gene.Activity_umap, pca, integrated_0_pca, integrated_0_umap, integrated_1_lsi, integrated_1_umap, integrated_2_lsi, integrated_2_umap, integrated_3_pca, integrated_3_umap, wnn_0_umap, wnn_1_umap


The most straightforward way to explore this data is by utilizing the functions provided in the Seurat 
package. If you wish to perform downstream analyses outside of Seurat, you can extract count matrices 
and metadata to build the required single cell object, or simply convert to another single cell object.

.. warning::

   The default argument setting may raise errors when calling Seurat functions due to modified 
   names for assays and dimensionality reductions in the Seurat object. Be sure to carefully check 
   the naming conventions in `multiome-wf` when assigning arguments.


Additional data is provided for marker genes, called peaks, and analysis reports at each step, 
depending on the analysis configurations. Refer to the :ref:`overview-output` for more details.

My Multiome/ATAC-seq input organism is neither human nor mouse
--------------------------------------------------------------

The current version of `multiome-wf` provides two options for annotating genomic loci: 
using ``EnsDb`` packages in R or a user's ``GTF`` file. Users can configure this annotation option 
in the :ref:`config-annotation`. One limitation of the ``EnsDb`` option is that only the **mm10 
(mouse) and hg38 (human)** reference genomes are available with this package. 

Input from other organisms, or reads from mouse/human mapped to different reference genomes, are 
supported through the ``GTF`` option.


Chromosome names differ from my input in Multiome/ATAC-seq
----------------------------------------------------------

The `multiome-wf` relies on the ``EnsDb.Mmusculus.v79`` (mm10) or ``EnsDb.Hsapiens.v86`` (hg38)
annotation packages in R. If the chromosome names in your input files don't match the conventions
used in these annotation packages, it is highly recommended that you rerun the mapping process 
using a reference genome with a compatible release version.
