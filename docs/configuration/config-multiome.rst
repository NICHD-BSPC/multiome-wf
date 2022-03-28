
.. _config-multiome:

Multiome Examples
=================

Below are different examples of setting up workflows for Multiome experiments.

For general configuration details, see :ref:`config`.


Multiple samples
----------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays                     RDS_Multiple_Assays Gene.Expression   Peaks   TF  fragments                        singlecell  meta_modality  meta_batch  meta_geno
    pbmc1            hg38   pbmc1/outs/filtered_feature_bc_matrix.h5                                                   pbmc1/outs/atac_fragments.tsv.gz             Multiome       batch1      wt
    ipsc             hg38   ipsc/outs/filtered_feature_bc_matrix.h5                                                    ipsc/outs/atac_fragments.tsv.gz              Multiome       batch2      wt
    pbmc2            hg38   pbmc2/outs/filtered_feature_bc_matrix.h5                                                   pbmc2/outs/atac_fragments.tsv.gz             Multiome       batch2      wt


Multiple samples, aggregated
----------------------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays                     RDS_Multiple_Assays Gene.Expression   Peaks   TF  fragments                        singlecell  meta_modality  meta_batch  meta_geno
    pbmc1            hg38   pbmc1/outs/filtered_feature_bc_matrix.h5                                                   pbmc1/outs/atac_fragments.tsv.gz             Multiome       batch1      wt
    ipsc             hg38   ipsc/outs/filtered_feature_bc_matrix.h5                                                    ipsc/outs/atac_fragments.tsv.gz              Multiome       batch2      wt
    pbmc2            hg38   pbmc2/outs/filtered_feature_bc_matrix.h5                                                   pbmc2/outs/atac_fragments.tsv.gz             Multiome       batch2      wt

.. code-block::
    :caption: aggregates.tsv

    sample replicate library_id library_id metadata1
    pbmc1            PBMC1      1          wt
    pbmc1            PBMC2      2          wt
    pbmc1            PBMC3      3          wt


Technical Replicates (Uncommon)
-------------------------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays                     RDS_Multiple_Assays Gene.Expression   Peaks   TF  fragments                        singlecell  meta_modality  meta_batch  meta_geno
    pbmc1  A         hg38   pbmc1/outs/filtered_feature_bc_matrix.h5                                                   pbmc1/outs/atac_fragments.tsv.gz             Multiome       batch1      wt
    ipsc   A         hg38   ipsc/outs/filtered_feature_bc_matrix.h5                                                    ipsc/outs/atac_fragments.tsv.gz              Multiome       batch2      wt
    pbmc2  A         hg38   pbmc2/outs/filtered_feature_bc_matrix.h5                                                   pbmc2/outs/atac_fragments.tsv.gz             Multiome       batch2      wt
    pbmc1  B         hg38   pbmc1/outs/filtered_feature_bc_matrix.h5                                                   pbmc1/outs/atac_fragments.tsv.gz             Multiome       batch1      wt
    ipsc   B         hg38   ipsc/outs/filtered_feature_bc_matrix.h5                                                    ipsc/outs/atac_fragments.tsv.gz              Multiome       batch2      wt
    pbmc2  B         hg38   pbmc2/outs/filtered_feature_bc_matrix.h5                                                   pbmc2/outs/atac_fragments.tsv.gz             Multiome       batch2      wt


Custom assays (Uncommon)
------------------------

.. code-block::
    :caption: sample.tsv

    sample replicate genome HDF5_Multiple_Assays                     RDS_Multiple_Assays Gene.Expression   Peaks   TF  fragments                        singlecell  meta_modality  meta_batch  meta_geno
    pbmc1            hg38   pbmc1/outs/filtered_feature_bc_matrix.h5                                                   pbmc1/outs/atac_fragments.tsv.gz             Multiome       batch1      wt
    ipsc             hg38   ipsc/outs/filtered_feature_bc_matrix.h5                                                    ipsc/outs/atac_fragments.tsv.gz              Multiome       batch2      wt
    pbmc2            hg38   pbmc2/outs/filtered_feature_bc_matrix.h5                                                   pbmc2/outs/atac_fragments.tsv.gz             Multiome       batch2      wt

.. code-block::
    :caption: assays.tsv

    sample replicate assay.name path
    pbmc1
    ipsc             enhancer   pbmc1/assays/enhancer_bc_matrix.h5
    pbmc1
