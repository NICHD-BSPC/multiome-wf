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


    - The aggregates table is optional and used to map library barcode labels 
      to library IDs in aggregated input files. The aggregated input contains 
      multiple biological replicates, which can be generated using 
      ``cellranger-arc aggr`` (Multiome), ``cellranger-atac aggr`` (ATAC), 
      or ``cellranger aggr`` (RNA).

    - When creating loading matrices, `multiome-wf` will map values in 
      ``library_id`` to the barcode suffix. If using 10X Genomics platforms, 
      ``cellranger aggr`` appends the row number of the ``aggregates.csv`` to all 
      barcodes for that rows ``sample_id``.

    - For details about 10X Genomic's aggregates tables, see:

        - `10X Genomics Multiome Aggregation Page <https://support.10xgenomics.com/single-cell-multiome-atac-gex/software/pipelines/latest/using/aggr#csv_setup>`_
        - `10X Genomics Gene Expression Aggregation Page <https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/aggregate#csv_setup>`_
        - `10X Genomics ATAC Aggregation Page <https://support.10xgenomics.com/single-cell-atac/software/pipelines/latest/using/aggr#csv_setup>`_


Field descriptions
------------------

.. _aggr-sample:

``sample``
^^^^^^^^^^

    string. Defines labels for each sample. Values in ``sample`` column must 
    be unique, unless analyzing technical replicates. If specifying technical 
    replicates, sample label must be the same for all rows containing technical 
    replicates.

.. _aggr-replicate:

``replicate``
^^^^^^^^^^^^^

    string. Optional. Defines labels for each technical replicate of a sample.
    Values in ``replicate`` column must be unique per sample. **If not specified** 
    technical replicates, leave empty. **If specified** technical replicates: 
    sample must be the same for all rows containing technical replicates.

.. note::

    Refer to the :ref:`replicates` section for the definition of biological and
    technical replicates.

.. _aggr-bc_suffix:

``bc_suffix``
^^^^^^^^^^^^^

    string. Optional. Defines a unique library label to all barcodes for each sample.
    **If sample is output of cellranger aggr** Values in ``bc_suffix`` column must be 
    the **row number (1 based)** corresponding the ``sample_id`` value 
    ``from cellranger aggr``'s aggregation CSV. 

    **If sample is output of non-10X Genomics platform** Values in must be a unique 
    library identifier appended to the barcode. Barcode and library suffix must be 
    separated by a dash (``-``) in the following pattern: ``[barcode]-[bc_suffix]``.

.. _aggr-library:

``library_id``
^^^^^^^^^^^^^^

    string. Optional. Defines labels associated with library barcode suffix for 
    each sample. Values in ``library_id`` column must be unique per sample. **If 
    sample is output of cellranger aggr** Values in ``library_id`` column must be 
    the 'sample_id' value from cellranger aggr's aggregation CSV. 

    **If sample is output of non-10X Genomics platform** Values in must correspond 
    to the unique library suffix specified in ``bc_suffix`` column.

.. _aggr-metadata:

``metadata*``
^^^^^^^^^^^^^

    string. Optional. Define columns for metadata labels. Colums beginning with ``metadata`` 
    are placeholders for user specified metadata. They can be re-renamed to any 
    string, deleted, or additional metadata columns can be added.
    
    .. note::

        - In ``aggregates.tsv``, the following column names are considered immutable:
          "sample", "replicate", "bc_suffix", "library_id".

        - Any additional columns present in ``aggregates.tsv`` will be considered 
          metadata columns. Metadata columns can have any unique label, not just 
          the `"meta*"` used in the example samples table.

Example
-------


Multiome
^^^^^^^^

a **basic** example of an aggregation CSV passed to the ``--csv`` parameter of
``cellranger-arc aggr`` (upper table) and an ``aggregates.tsv`` file configured
for `multiome-wf` pipeline (lower table):

========= ========= ========== ========== =========
sample    replicate library_id library_id metadata1
========= ========= ========== ========== =========
rep1_wt             1          1          wt
rep1_homo           2          2          ko
========= ========= ========== ========== =========


========== ==================================== ====================================== ==================================
library_id atac_fragments                       per_barcode_metrics                    gex_molecule_info
========== ==================================== ====================================== ==================================
rep1_wt    rep1_wt/outs/atac_fragments.tsv.gz   rep1_wt/outs/per_barcode_metrics.csv   rep1_wt/out/gex_molecule_info.h5
rep1_homo  rep1_homo/outs/atac_fragments.tsv.gz rep1_homo/outs/per_barcode_metrics.csv rep1_homo/out/gex_molecule_info.h5
========== ==================================== ====================================== ==================================


RNA-seq
^^^^^^^

a **basic** example of an aggregation CSV passed to the ``--csv`` parameter of
``cellranger aggr`` (upper table) and an ``aggregates.tsv`` file configured
for `multiome-wf` pipeline (lower table):

========= =========================
sample_id molecule_h5
========= =========================
CTX       CTX/outs/molecule_info.h5
MGE       MGE/outs/molecule_info.h5
========= =========================

====== ========= ========== ========= ===========
sample replicate library_id bc_suffix meta_tissue
====== ========= ========== ========= ===========
CTX              1          1         CTX
MGE              2          2         MGE
====== ========= ========== ========= ===========

ATAC-seq
^^^^^^^^

a **basic** example of an aggregation CSV passed to the ``--csv`` parameter of
``cellranger-atac aggr`` (upper table) and an ``aggregates.tsv`` file configured
for `multiome-wf` pipeline (lower table):

========== =============================== =============================
library_id fragments                       cells
========== =============================== =============================
CTX        CTX_rerun/outs/fragments.tsv.gz CTX_rerun/outs/singlecell.csv
MGE        MGE_rerun/outs/fragments.tsv.gz MGE_rerun/outs/singlecell.csv
========== =============================== =============================

====== ========= ========== ========= ===========
sample replicate library_id bc_suffix meta_tissue
====== ========= ========== ========= ===========
CTX              1          1         CTX
MGE              2          2         MGE
====== ========= ========== ========= ===========

See :ref:`overview-wf` for more detailed examples of config files.
