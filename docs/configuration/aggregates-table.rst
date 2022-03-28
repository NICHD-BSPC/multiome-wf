.. _aggregates-table:

Aggregates Table
================

=================================== ========================= ======================== ========================= ====================
Field                               Used for cellranger count Used for cellranger aggr Used for non-10X Genomics Required
=================================== ========================= ======================== ========================= ====================
:ref:`sample <aggr-sample>`         optional                  yes                      optional                  yes, cellranger aggr
:ref:`replicate <aggr-replicate>`   optional                  yes                      optional                  yes, cellranger aggr
:ref:`bc_suffix <aggr-bc_suffix>`   optional                  yes                      optional                  yes, cellranger aggr
:ref:`library_id <aggr-library>`    optional                  yes                      optional                  yes, cellranger aggr
:ref:`metadata1 <aggr-metadata>`    optional                  optional                 optional                  optional
=================================== ========================= ======================== ========================= ====================

.. note::
    Aggregates table is only used if there is a need to map library barcode labels to a specified library ID. 

    When creating loading matrices, `multiome-wf` will map values in `library_id` to the barcode suffix. If using 10X Genomics platforms, cellranger aggr appends the row number of the aggregates.csv to all barcodes for that rows 'sample_id'.

    For details about 10X Genomic's aggregates tables, see:
    
    - `10X Genomics Multiome Aggregation Page <https://support.10xgenomics.com/single-cell-multiome-atac-gex/software/pipelines/latest/using/aggr#csv_setup>`_

    - `10X Genomics Gene Expression Aggregation Page <https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/aggregate#csv_setup>`_
    
    - `10X Genomics ATAC Aggregation Page <https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/using/aggr#csv_setup>`_


Field descriptions
------------------

.. _aggr-sample:

``sample``
^^^^^^^^^^
    string. Defines labels for each sample.

    Values in ``sample`` column must be unique, unless analyzing technical replicates.
    If specifying technical replicates, sample label must be the same for all rows containing 
    techical replicates.

.. _aggr-replicate:

``replicate``
^^^^^^^^^^^^^
    string, default null. Optional. Defines labels for each technical replicate of a sample.

    Values in ``replicate`` column must be unique per sample.

    **If not specified** technical replicates, leave empty.

    **If specified** technical replicates: sample must be the same for all rows containing 
    techical replicates.

.. _aggr-bc_suffix:

``bc_suffix``
^^^^^^^^^^^^^
    string, default null. Optional. Defines a unique library label to all barcodes for each sample.

    **If sample is output of cellranger aggr** Values in ``bc_suffix`` column must be the **row number (1 based)** corresponding the 'sample_id' value from cellranger aggr's aggregation CSV.

    **If sample is output of non-10X Genomics platform** Values in must be a unique library identifier appended to the barcode. Barcode and library suffix must be separated by a dash "-" in the following pattern: [barcode]"-"[bc_suffix].

.. _aggr-library:

``library_id``
^^^^^^^^^^^^^^
    string, default null. Optional. Defines labels associated with library barcode suffix for each sample.

    Values in ``library_id`` column must be unique per sample.

    **If sample is output of cellranger aggr** Values in ``library_id`` column must be the 'sample_id' value from cellranger aggr's aggregation CSV.

    **If sample is output of non-10X Genomics platform** Values in must correspond to the unique library suffix specified in ``bc_suffix`` column.

.. _aggr-metadata:

``metadata*``
^^^^^^^^^^^^^

    string, default null. Define columns for metadata labels.
    
    Colums beginning with `"metadata"` are placeholders for user specified metadata. They can be re-renamed to any string, deleted, or additional metadata columns can be added.
    
    .. note::
        In ``aggregates.tsv``, the following column names are considered immutable: "sample", "replicate", "bc_suffix", "library_id".

        Any additional columns present in ``aggregates.tsv`` will be considered metadata columns. Metadata columns can have any unique label, not just the `"meta*"` used in the example samples table.

Example
-------

A **basic** example of an aggregates.tsv file is below. This table represents an experiment where 3 libraries of peripheral blood mononuclear cells (PBMC) were sequenced in one batch, and depth normalized using cellranger aggr.

See :ref: `overview-wf` for more detailed examples of config files.

====== ========= ========== ========== =========
sample replicate library_id library_id metadata1
====== ========= ========== ========== =========
pbmc1            PBMC1      1          wt
pbmc1            PBMC2      2          wt
pbmc1            PBMC3      3          wt
====== ========= ========== ========== =========

The corresponding ``cellranger-arc aggr`` aggregates.tsv file would look like:

========== ================================ ================================== ===============================
library_id atac_fragments                   per_barcode_metrics                gex_molecule_info
========== ================================ ================================== ===============================
PBMC1      PBMC1/outs/atac_fragments.tsv.gz PBMC1/outs/per_barcode_metrics.csv PBMC1/outs/gex_molecule_info.h5
PBMC2      PBMC2/outs/atac_fragments.tsv.gz PBMC2/outs/per_barcode_metrics.csv PBMC2/outs/gex_molecule_info.h5
PBMC3      PBMC3/outs/atac_fragments.tsv.gz PBMC3/outs/per_barcode_metrics.csv PBMC3/outs/gex_molecule_info.h5
========== ================================ ================================== ===============================

Notice that there is one sample name for all three libraries (PBMC1, PBMC2, and PBMC3) since cellranger aggr appends a library ID to barcodes within a library. Compare this with :ref: `samples-table` example to see how to incorporate single- and multi-library files for analysis.
