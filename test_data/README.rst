``test_data`` directory
=======================

Overview
~~~~~~~~

Test datasets (aka toy datasets) are downloaded (scATAC-seq, scRNA-seq) or generated
from downloaded datasets (multiome). The source of all toy datasets is
`10X Genomics <https://www.10xgenomics.com/>`_.


The *multiome-wf* provides a toy dataset for multiome and download scripts for scATAC/RNA-seq.
All files for creating or downloading toy datasets are listed below:

.. code-block:: bash

   $ tree
   .
   ├── README.rst
   ├── tenx_atac
   │   └── download_raw.sh
   ├── tenx_multiome_toy
   │   ├── toy_atac.tsv.gz
   │   ├── toy_atac.tsv.gz.tbi
   │   ├── toy_barcode.csv
   │   ├── toy_matrix.rds
   │   ├── toy_peaks.bed
   │   └── toy_peaks_peaks.tsv
   ├── tenx_process
   │   ├── download_raw.sh
   │   ├── GEX_config.R
   │   ├── GEX.R
   │   ├── multiome_toy_config.sh
   │   └── multiome_toy.sh
   └── tenx_rna
       └── download_raw.sh

Directories:


- ``tenx_multiome_toy``
    - Contains pipeline-provided toy dataset for multiome
- ``tenx_atac``
    - Contains a pipeline-provided bash script (``download_raw.sh``) for downloading 
      from 10X Genomics
    - The scATAC-seq test dataset will be downloaded here
- ``tenx_rna``
    - Contains a pipeline-provided bash script (``download_raw.sh``) for downloading 
      from 10X Genomics
    - The scRNA-seq test dataset will be downloaded here
- ``tenx_process``
    - Contains a pipeline-provided bash script (``download_raw.sh``) for downloading 
      from 10X Genomics
    - The main bash script (``multiome_toy.sh``) is run to generate the toy dataset 
      in ``tenx_multiome_toy``
    - Contains auxiliary scripts (``multiome_toy_config.sh``, ``GEX.R``, ``GEX_config.R``) implemented 
      in the main bash script


Conda environment
~~~~~~~~~~~~~~~~~

This demo requires a conda environment set up for the main workflow. Ensure that your 
main conda environment is activated.

Generating 10X multiome toy dataset
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following demo will walk you through how to generate the multiome toy dataset. 
However, you do not need to re-run it if you have cloned the repository.

Dataset preparation is performed in the ``tenx_process`` folder. 

.. code-block:: bash

    $ cd tenx_process

The toy dataset is prepared from a full dataset provided by 10X Genomics. Run
the following command to download it:

.. code-block:: bash

   # Ensure you are in tenx_process directory
   $ bash download_raw.sh

This will download the following files in a new directory named ``tenx_input`` 
as shown below:

.. code-block:: bash

    $ tree tenx_input
    tenx_input
    ├── atac_fragments.tsv
    ├── atac_fragments.tsv.gz.tbi
    ├── atac_peaks.bed
    ├── filtered_bc_matrix.h5
    └── per_barcode_metrics.csv

    0 directories, 5 files

Once the full dataset is prepared, run the following command to create a toy dataset 
containing a subset of the full dataset:

.. code-block:: bash

    $ bash multiome_toy.sh

The output of this run is found in ``../tenx_multiome_toy`` as show below:

.. code-block:: bash

    $ tree ../tenx_multiome_toy/
    ../tenx_multiome_toy/
    ├── toy_atac_atac.tsv
    ├── toy_atac.tsv
    ├── toy_atac.tsv.gz
    ├── toy_atac.tsv.gz.tbi
    ├── toy_barcode.csv
    ├── toygex_barcodes.txt
    ├── toy_matrix.rds
    ├── toy_peaks.bed
    └── toy_peaks_peaks.tsv

    0 directories, 9 files



Downloading 10X Genomics scATAC-seq toy dataset
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This dataset will be downloaded in the ``tenx_atac`` directory by running the following command:

.. code-block:: bash

    # Assume you are in the test_data directory
    cd tenx_atac
    bash download_raw.sh

    $ tree
    .
    ├── download_raw.sh
    ├── filtered_peak_bc_matrix.h5
    ├── filtered_tf_bc_matrix.h5
    ├── fragments.tsv.gz
    ├── fragments.tsv.gz.tbi
    ├── peaks.bed
    └── summary.csv

    0 directories, 7 files

Now you have the following files prepared for your test run:

- ``filtered_peak_bc_matrix.h5``
- ``filtered_tf_bc_matrix.h5``
- ``fragments.tsv.gz``
- ``fragments.tsv.gz.tbi``
- ``peaks.bed``
- ``summary.csv``


If you wish to download manually, visit 
`1k Peripheral Blood Mononuclear Cells (PBMCs) from a Healthy Donor (Next GEM v1.1) 
<https://www.10xgenomics.com/resources/datasets/1-k-peripheral-blood-mononuclear-cells-pbm-cs-from-a-healthy-donor-next-gem-v-1-1-1-1-standard-2-0-0>`_.

Downloading 10X Genomics scRNA-seq toy dataset
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This dataset will be downloaded in the ``tenx_rna`` directory by running the following command:

.. code-block:: bash

    # Assume you are in the test_data directory
    cd tenx_rna
    bash download_raw.sh

    $ tree
    .
    ├── download_raw.sh
    └── filtered_feature_bc_matrix.h5

Now you have the ``filtered_feature_bc_matrix.h5`` ready for your test run.

If you wish to download manually, visit `500 Human PBMCs, 3' LT v3.1, Chromium Controller
<https://www.10xgenomics.com/resources/datasets/500-human-pbm-cs-3-lt-v-3-1-chromium-controller-3-1-low-6-1-0>`_.

