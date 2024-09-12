
.. _config-rna:

scRNA-Seq Examples
==================

Below are different examples of setting up workflows for 
scRNA-Seq experiments. For general configuration details, see 
:ref:`config`.


Multiple samples
----------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression                        Peaks   TF  fragments singlecell  meta_batch meta_tissue
    CTX              mm10                                            CTX/outs/filtered_feature_bc_matrix.h5                                   batch1     CTX
    MGE              mm10                                            MGE/outs/filtered_feature_bc_matrix.h5                                   batch1     MGE

.. note:: 

    Alternatively, the ``Gene.Expression`` column can point to a directory 
    (e.g. ``path/to/outs/filtered_feature_bc_matrix/``) containing a MEX 
    format sparse matrix along with barcodes and features, as shown below:

    .. code-block:: bash

        $ tree filtered_feature_bc_matrix
        filtered_feature_bc_matrix
        ├── barcodes.tsv.gz
        ├── features.tsv.gz
        └── matrix.mtx.gz


Multiple samples, aggregated
----------------------------

.. code-block::
    :caption: sample.tsv

    sample  replicate  genome  HDF5_Multiple_Assays    RDS_Multiple_Assays     Gene.Expression Peaks                          TF      fragments       singlecell    meta_batch
    aggr               mm10                                                    aggr/outs/count/filtered_feature_bc_matrix.h5                                        batch1

.. code-block::
    :caption: aggregates.tsv

    sample replicate library_id bc_suffix meta_tissue
    CTX              1          1         CTX
    MGE              2          2         MGE


Technical Replicates (Uncommon)
-------------------------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression                          Peaks TF fragments singlecell  meta_batch  meta_geno
    pbmc1  A         hg38                                            pbmc1/outs/filtered_feature_bc_matrix.h5                                batch1      wt
    ipsc   A         hg38                                            ipsc/outs/filtered_feature_bc_matrix.h5                                 batch1      wt
    pbmc2  A         hg38                                            pbmc2/outs/filtered_feature_bc_matrix.h5                                batch1      wt
    pbmc1  B         hg38                                            pbmc1/outs/filtered_feature_bc_matrix.h5                                batch1      wt
    ipsc   B         hg38                                            ipsc/outs/filtered_feature_bc_matrix.h5                                 batch1      wt
    pbmc2  B         hg38                                            pbmc2/outs/filtered_feature_bc_matrix.h5                                batch1      wt


Custom assays (Uncommon)
------------------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression                          Peaks TF fragments singlecell  meta_batch  meta_geno
    pbmc1            hg38                                            pbmc1/outs/filtered_feature_bc_matrix.h5                                batch1      wt
    ipsc             hg38                                            ipsc/outs/filtered_feature_bc_matrix.h5                                 batch1      wt
    pbmc2            hg38                                            pbmc2/outs/filtered_feature_bc_matrix.h5                                batch1      wt

.. code-block::
    :caption: assays.tsv

    sample replicate assay.name path
    pbmc1
    ipsc             enhancer   pbmc1/assays/enhancer_bc_matrix.h5
    pbmc1
