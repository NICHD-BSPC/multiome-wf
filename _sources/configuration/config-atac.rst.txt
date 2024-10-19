
.. _config-atac:

scATAC-Seq Examples
===================


Below are different examples of setting up workflows for scATAC-Seq 
experiments. 
For general configuration details, refer to :ref:`config`.


Multiple samples
----------------

.. code-block::
    :caption: samples.tsv

    sample   replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression Peaks                                       TF                                       fragments                          singlecell                 meta_batch  meta_tissue
    CTX                mm10                                                            CTX_rerun/outs/filtered_peak_bc_matrix.h5   CTX_rerun/outs/filtered_tf_bc_matrix.h5  CTX_rerun/outs/fragments.tsv.gz    CTX_rerun/outs/summary.csv batch1      CTX
    MGE                mm10                                                            MGE_rerun/outs/filtered_peak_bc_matrix.h5   MGE_rerun/outs/filtered_tf_bc_matrix.h5  MGE_rerun/outs/fragments.tsv.gz    MGE_rerun/outs/summary.csv batch1      MGE


.. note:: 

    Alternatively, the ``Peaks`` column can point to a directory 
    (e.g. ``path/to/outs/filtered_peak_bc_matrix/``) containing a MEX 
    format sparse matrix along with barcodes and peaks, as shown below:

    .. code-block:: bash

        $ tree filtered_peak_bc_matrix
        filtered_peak_bc_matrix
        ├── barcodes.tsv
        ├── matrix.mtx
        └── peaks.bed


Multiple samples, aggregated
----------------------------

.. code-block::
    :caption: samples.tsv

    sample  replicate  genome  HDF5_Multiple_Assays    RDS_Multiple_Assays   Gene.Expression Peaks                                      TF      fragments                           singlecell                      meta_batch
    aggr               mm10                                                                  aggr_rerun/outs/filtered_peak_bc_matrix.h5         aggr_rerun/outs/fragments.tsv.gz    aggr_rerun/outs/singlecell.csv  batch1

.. code-block::
    :caption: aggregates.tsv

    sample replicate library_id bc_suffix meta_tissue
    CTX              1          1         CTX
    MGE              2          2         MGE


Technical Replicates (Uncommon)
-------------------------------

.. code-block::
    :caption: samples.tsv

    sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression Peaks                                TF  fragments                   singlecell  meta_batch  meta_geno
    pbmc1  A         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc1/outs/fragments.tsv.gz             batch1      wt
    ipsc   A         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      ipsc/outs/fragments.tsv.gz              batch1      wt
    pbmc2  A         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc2/outs/fragments.tsv.gz             batch1      wt
    pbmc1  B         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc1/outs/fragments.tsv.gz             batch1      wt
    ipsc   B         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      ipsc/outs/fragments.tsv.gz              batch1      wt
    pbmc2  B         hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc2/outs/fragments.tsv.gz             batch1      wt


Custom assays (Uncommon)
------------------------

.. code-block::
    :caption: samples.tsv

    sample replicate genome HDF5_Multiple_Assays RDS_Multiple_Assays Gene.Expression Peaks                                TF  fragments                   singlecell  meta_batch  meta_geno
    pbmc1            hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc1/outs/fragments.tsv.gz             batch1      wt
    ipsc             hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      ipsc/outs/fragments.tsv.gz              batch1      wt
    pbmc2            hg38                                                            pbmc1/outs/filtered_peak_bc_matrix/      pbmc2/outs/fragments.tsv.gz             batch1      wt

.. code-block::
    :caption: assays.tsv

    sample replicate assay.name path
    pbmc1
    ipsc             enhancer   pbmc1/assays/enhancer_bc_matrix.h5
    pbmc1
