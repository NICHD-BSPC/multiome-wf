
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

In general, **technical replicates** refer to samples originating from the same biological source, 
such as reads from multiple sequencing runs of an identical cell population. In contrast, 
**biological replicates** refer to samples originating from different biological sources, such as
reads from multiple sequencing runs where each run contains a unique cell population.

Technical replicates are often prepared to improve sequencing coverage. Therefore, read counts are
summed across technical replicates by setting the input of ``cellranger count`` (RNA-seq), 
``cellranger-arc count`` (ATAC-seq), or ``cellranger-arc count`` (Multiome) to technical replicates. 
Technical replicates prepared using Non-10X Genomics platforms follow equivalent steps.

Alternatively, the `multiome-wf` performs count aggregation for samples labeled with the same value
in the ``replicate`` column of the sample table (``samples.tsv``) or the aggregates table 
(``aggregates.tsv``). Learn more about utilizing the ``replicate`` column from the following
pages:

- ``replicate`` in sample table: :ref:`samples-replicate`
- ``replicate`` in aggregates table: :ref:`aggr-replicate`

Read counts from independent biological replicates are not aggregated to preserve biological 
variability. For users analyzing 10X Genomics datasets, ``cellranger aggr`` (RNA-seq), 
``cellranger-arc aggr`` (ATAC-seq), or ``cellranger-arc aggr`` is optionally available for creating
a concatenated feature-barcode matrix along with a `cloupe 
<https://www.10xgenomics.com/support/software/loupe-browser/latest>`_ file. The sample table 
(``samples.tsv``) accepts input for both per-biological replicate matrices and a concatenated matrix.
