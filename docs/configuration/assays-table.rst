.. _assays-table:

Assays Table
=============

=================================== ===================== ========================= ======================== ========
Field                               Used for 10X Genomics Used for non-10X Genomics Used for Custom Matrices Required
=================================== ===================== ========================= ======================== ========
:ref:`sample <assays-sample>`       no                    no                        yes                      yes
:ref:`replicate <assays-replicate>` no                    no                        yes                      optional
:ref:`assay.name <assays-name>`     no                    no                        yes                      optional
:ref:`path <assays-path>`           no                    no                        yes                      optional
=================================== ===================== ========================= ======================== ========

.. note::

   - Assay table is only used if you have calculated custom feature-by-barcode 
     counts matrices. For example, if one has a genome annotation file containing
     gene coordinates and enhancer coordinates, you can count all ATAC reads mapping 
     to a gene and associated enhancers: 
     
        Gene Activity Score = reads mapped within gene + reads mapped to enhancers.

   - **Do not** use this table for calculating standard Gene Activity 
     Scores (GAS) common to ATAC analyses. This is included in the standard 
     ATAC Peaks workflow. For details about the standard GAS included in this
     workflow, see `Signac Documentation 
     <https://stuartlab.org/signac/reference/geneactivity>`_.


Field descriptions
------------------

.. _assays-sample:

``sample``
^^^^^^^^^^

    string. Defines labels for each sample. Values in ``sample`` column must be unique, 
    unless analyzing technical replicates. If specifying technical replicates, sample 
    label must be the same for all rows containing techical replicates.

.. _assays-replicate:

``replicate``
^^^^^^^^^^^^^

    string. Optional. Defines labels for each technical replicate of a sample.
    Values in ``replicate`` column must be unique per sample. **If not specified** 
    technical replicates, leave empty. **If specified** technical replicates: 
    sample must be the same for all rows containing techical replicates.

.. _assays-name:

``assay.name``
^^^^^^^^^^^^^^

    string. Optional. Name of custom feature-by-barcode counts matrix.
    **If not specified** Leave empty. **If specified** Name of custom 
    feature-by-barcode counts matrix (string). Cannot be ``Gene.Expression``, 
    ``Peaks``, or ``TF``.

.. _assays-path:

``path``
^^^^^^^^

    string. Optional. Path to custom feature-by-barcode counts matrix. 
    **If not specified** Leave empty. **If specified** Path to custom 
    feature-by-barcode counts matrix in HDF5 or RDS format, or path to 
    parent directory of MEX formatted matrix, barcode and features files.


Example
-------

A **basic** example of an assays.tsv file is below. This table represents 
an experiment where a custom enhancer counts matrix was calculated 
**in addition to** 'core' cellranger analyses.


====== ========= ========== ==================================
sample replicate assay.name path
====== ========= ========== ==================================
pbmc1
ipsc             enhancer   pbmc1/assays/enhancer_bc_matrix.h5
====== ========= ========== ==================================

See :ref:`overview-wf` for more detailed examples of config files.
