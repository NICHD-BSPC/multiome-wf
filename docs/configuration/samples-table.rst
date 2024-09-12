.. _samples-table:

Samples Table
=============

========================================== ================= ================ ================= ===================
Field                                      Used for Multiome Used for RNA-seq Used for ATAC-seq Required
========================================== ================= ================ ================= ===================
:ref:`sample <samples-sample>`             yes               yes              yes               yes
:ref:`replicate <samples-replicate>`       optional          optional         optional          optional
:ref:`genome <samples-genome>`             yes               no               yes               yes, ATAC/Multiome
:ref:`HDF5_Multiple_Assay <samples-hdf5>`  yes               yes              yes               See notes below
:ref:`RDS_Multiple_Assays <samples-rds>`   yes               yes              yes               See notes below
:ref:`Gene.Expression <samples-rna>`       yes               yes              no                See notes below
:ref:`Peaks <samples-peaks>`               yes               no               yes               See notes below
:ref:`TF <samples-tf>`                     yes               no               yes               See notes below
:ref:`fragments <samples-frags>`           yes               no               yes               yes, ATAC/Multiome
:ref:`singlecell <samples-singlecell>`     yes               no               yes               no
:ref:`meta_batch <samples-metadata>`       optional          optional         optional          optional
:ref:`meta_geno <samples-metadata>`        optional          optional         optional          optional
========================================== ================= ================ ================= ===================

.. note::

    - Suppored input file formats include HDF5 (10X Genomics compatible), 
      MEX directory, or RDS.

    - For input from non-10X Genomics pipelines, place the ``barcodes.tsv.gz``, 
      ``features.tsv.gz``, and ``matrix.mtx.gz`` in the MEX directory.

    - For details about 10X Genomics' HDF5 format, refer to the `HDF5 Feature-Barcode Matrix Format
      <https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/advanced/h5_matrices>`_.


Field descriptions
~~~~~~~~~~~~~~~~~~

.. _samples-sample:

``sample``
^^^^^^^^^^

    string. Defines labels for each sample. Values in ``sample`` column 
    must be unique, unless analyzing technical replicates. If specifying 
    technical replicates, sample label must be the same for all rows 
    containing techical replicates.

.. _samples-replicate:

``replicate``
^^^^^^^^^^^^^

    string. Optional. Defines labels for each technical replicate of 
    a sample. Values in ``replicate`` column must be unique per sample. 
    **If not specified** technical replicates, leave empty. **If specified** 
    technical replicates: sample must be the same for all rows containing 
    techical replicates.

.. _samples-genome:

``genome``
^^^^^^^^^^

    string, default ``hg38``. Defines labels for genome build per sample.
    If samples include "Peaks" or "Transcription Factor" (TF) matrices, 
    as with ATAC and Multiome products, all samples must have genome. 
    Otherwise, genome labels can differ across samples. In the current 
    version of the `multiome-wf`, ``mm10`` (mouse) and ``hg38`` (human) are
    available.

.. _samples-hdf5:

``HDF5_Multiple_Assays``
^^^^^^^^^^^^^^^^^^^^^^^^

    Path to HDF5 file containing **multiple** feature-by-barcode matrices.
    If a sample's input contains multiple matrices, list the sample path 
    in either ``HDF5_Multiple_Assays`` or ``RDS_Multiple_Assays`` columns 
    of ``samples.tsv``. Paths specified in ``HDF5_Multiple_Assays`` should 
    point to a 10X Genomics compatible HDF5 file.

    .. note::

        - If the specified input file contains feature-by-barcode matrices f
          or 5' or 3' Gene Expression counts matrix, or ATAC/Multiome counts 
          matrices including Peaks or Transcription Factors, **do not** duplicate 
          paths in ``Gene.Expression``, ``Peaks`` or ``TF`` columns, respectively.

        - Specifying paths in this column is useful if you are analyzing 10X Genomics 
          kits containing multiple assays, such as Gene Expression + CRISPR 
          barcodes (Perturb-Seq), 3' Gene Expression + Protein barcodes (CITE-Seq), 
          Multiome (Gene Expression + ATAC), etc.

        - Specifying paths in this column can also be useful if you are analyzing 
          data derived from non-10X Genomics platforms, which may need reformatting 
          prior to running the workflow.

.. _samples-rds:

``RDS_Multiple_Assays``
^^^^^^^^^^^^^^^^^^^^^^^

    Path to RDS file containing **multiple** feature-by-barcode matrices saved 
    in a named list of dgCMatrices. The saved data format is identical to that of 
    :ref:`samples-hdf5` (Refer to the notes under :ref:`samples-hdf5`).


.. _samples-rna:

``Gene.Expression``
^^^^^^^^^^^^^^^^^^^

    Path to a **single** feature-by-barcode matrix containing 5' or 3' Gene 
    Expression counts. Path can point to either 1) a file in HDF or RDS format, 
    or 2) the parent directory containing a 10X compatible MEX sparse matrix and 
    associated barcodes and features files.

    .. note::

        - Specifying paths in this column is useful if you are analyzing 10X 
          Genomics single-assay transcriptomics kits.


        - If analyzing single cell transcriptomics data from a non-10X Genomics 
          platform, reformatting the gene-by-barcode count matrix is likely 
          needed. In such a case, the reformatted counts matrix can be save in HDF5 
          or RDS format and specified in the ``Gene.Expression`` column of 
          ``samples.tsv``.

        - If the specified matrix has any additional features, for example 3' Gene 
          Expression + CRISPR barcodes (Perturb-Seq), 3' Gene Expression + Protein 
          barcodes (CITE-Seq), use either ``HDF5_Multiple_Assays`` or 
          ``RDS_Multiple_Assays`` columns of ``samples.tsv``.

.. _samples-peaks:

``Peaks``
^^^^^^^^^

    Path to a **single** feature-by-barcode matrix containing ATAC peaks counts.
    Path can point to either 1) a file in HDF or RDS format, or 2) the parent 
    directory containing a 10X compatible MEX sparse matrix and associated barcodes 
    and features files.

    .. note::

        - Specifying paths in this column is useful if you are analyzing 10X
          Genomics single-assay chromatin accessibility kits.
    
        - If analyzing single cell ATAC data from a non-10X platform, 
          reformatting the gene-by-barcode count matrix is likely needed. In such 
          a case, the reformatted counts matrix can be save in HDF5 or RDS format 
          and specified in the ``Peaks`` column of ``samples.tsv``.

        - If the specified matrix has any additional features, for example Multiome 
          (Gene Expression + ATAC), use either ``HDF5_Multiple_Assays`` or 
          ``RDS_Multiple_Assays`` columns of ``samples.tsv``.

.. _samples-tf:

``TF``
^^^^^^

    Path to a **single** feature-by-barcode matrix encoding Transcription Factor 
    counts. Path can point to either 1) a file in HDF or RDS format, or 2) the 
    parent directory containing a 10X compatible MEX sparse matrix and associated 
    barcodes and features files. Refer to the notes under :ref:`samples-peaks`.


.. _samples-frags:

``fragments``
^^^^^^^^^^^^^

    Path to the ``fragments.tsv.gz`` file containing a table of tagmentation loci, 
    each with coordinates and de-duplicated counts, created from 10X Genomics ATAC 
    and Multiome kits.

.. _samples-singlecell:

``singlecell``
^^^^^^^^^^^^^^

    Path to the ``singlecell.csv`` file created from 10X Genomics ATAC and Multiome 
    kits.

.. _samples-metadata:

``meta_*``
^^^^^^^^^^

    string. Optional. Define columns for metadata labels. Columns beginning 
    with ``meta_`` are placeholders for user-specified metadata. Users can 
    rename these columns.

    .. note::

        - In ``samples.tsv``, the following column names are considered immutable: 
          ``sample``, ``replicate``, ``genome``, ``HDF5_Multiple_Assays``, 
          ``RDS_Multiple_Assays``, ``Gene.Expression``, ``Peaks``, ``TF``, 
          ``fragments``, ``singlecell``.

        - Any additional columns present in ``samples.tsv`` will be considered 
          metadata columns. Metadata columns can have any unique label, not just 
          the ``meta_*`` used in the example samples table.


Examples
~~~~~~~~


Multiome
^^^^^^^^

A **basic** examples of a ``samples.tsv`` file for 10X Genomics 
Multiome analysis is below:

========= ========= ====== =========================================== =================== ================= ======= === ==================================== =========== =========== =========
sample    replicate genome HDF5_Multiple_Assays                        RDS_Multiple_Assays Gene.Expression   Peaks   TF  fragments                            singlecell  meta_batch  meta_geno
========= ========= ====== =========================================== =================== ================= ======= === ==================================== =========== =========== =========
rep1_wt             mm10   rep1_wt/outs/filtered_feature_bc_matrix.h5                                                    rep1_wt/outs/atac_fragments.tsv.gz               batch1      wt
rep1_homo           mm10   rep_homo/outs/filtered_feature_bc_matrix.h5                                                   rep1_homo/outs/atac_fragments.tsv.gz             batch1      ko
========= ========= ====== =========================================== =================== ================= ======= === ==================================== =========== =========== =========

RNA-seq
^^^^^^^

A **basic** examples of a ``samples.tsv`` file for 10X Genomics
Single Cell 3’ Gene Expression analysis is below:

====== ========= ====== ==================== =================== ===================================== ======= === ========= =========== ========== ===========
sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression                       Peaks   TF  fragments singlecell  meta_batch meta_tissue
====== ========= ====== ==================== =================== ===================================== ======= === ========= =========== ========== ===========
CTX              mm10                                            wt/outs/filtered_feature_bc_matrix.h5                                   batch1     CTX
MGE              mm10                                            ko/outs/filtered_feature_bc_matrix.h5                                   batch1     MGE
====== ========= ====== ==================== =================== ===================================== ======= === ========= =========== ========== ===========

ATAC-seq
^^^^^^^^

A **basic** examples of a ``samples.tsv`` file for 10X Genomics
Single Cell ATAC analysis is below:

====== ========= ====== ==================== =================== =============== ========================================= ======================================= =============================== ========================== ========== =========
sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression Peaks                                     TF                                      fragments                       singlecell                 meta_batch meta_tissue
====== ========= ====== ==================== =================== =============== ========================================= ======================================= =============================== ========================== ========== =========
CTX              mm10                                                            CTX_rerun/outs/filtered_peak_bc_matrix.h5 CTX_rerun/outs/filtered_tf_bc_matrix.h5 CTX_rerun/outs/fragments.tsv.gz CTX_rerun/outs/summary.csv batch1     CTX
MGE              mm10                                                            MGE_rerun/outs/filtered_peak_bc_matrix.h5 MGE_rerun/outs/filtered_tf_bc_matrix.h5 MGE_rerun/outs/fragments.tsv.gz MGE_rerun/outs/summary.csv batch1     MGE
====== ========= ====== ==================== =================== =============== ========================================= ======================================= =============================== ========================== ========== =========


See :ref:`overview-wf` for more detailed examples of config files.
