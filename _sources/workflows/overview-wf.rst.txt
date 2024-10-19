
.. _overview-wf:

Overview of workflows
=====================

Overview
--------

The main goal of `multiome-wf` is transforming and combining raw data into usable results 
for downstream analyses. For scRNA-seq, that's differentially-expressed genes (along with 
comprehensive QC and analysis). For scATAC-seq, that's called peaks or differentially accessible 
chromatin regions.

`multiome-wf` is a framework that supports a number of analysis variants based on how it is configured. 
Each class of analysis variants, such as scRNA-Seq or scATAC-Seq is a "core" workflow since a different 
directed acyclic graph (DAG) is constructed for each analysis variant. Using a single framework promotes 
flexibility in single cell analyses. Data derived from many different experimental strategies can 
effectively be combined, and by setting up the configuration files properly, `multiome-wf` will decide 
the best workflow to use.

.. _pipeline-structure:

Core pipeline structure
-----------------------

`multiome-wf` is a parallelized pipeline built using Snakemake. The pipeline consists of 
rules that implement modular workflows, as defined in the ``Snakefile`` within the 
``workflow`` directory. Each rule runs analysis scripts written in R or Bash. R scripts 
are executed from individual ``Rmd`` files in the same directory, which also creates 
analysis reports in ``html`` format in the ``workflow/results`` folder upon completion of
the analysis.

`multiome-wf` is configured by plain text `YAML <https://en.wikipedia.org/wiki/YAML>`_ 
and `TSV <https://en.wikipedia.org/wiki/Tab-separated_values>`_ format files located in the
``config`` directory (see :ref:`config` for more information).

Optionally, the pipeline can run on a High Performance Computing (HPC) cluster. The 
``WRAPPER_SLURM`` file in the ``workflow`` directory is specially prepared to configure
high performance computing on `NIH's Biowulf <https://hpc.nih.gov/>`_. Refer to 
:ref:`cluster` for more details.

.. code-block:: bash

    $ tree workflow/
    workflow/
    ├── add_macs_peaks.Rmd
    ├── annotation_ensdb.Rmd
    ├── annotation_gtf.Rmd
    ├── chooser
    │   ├── env.yaml
    │   ├── R
    │   │   └── pipeline.R
    │   └── requirements.txt
    ├── chooser_aggr.Rmd
    ├── chooser_paral.Rmd
    ├── cluster.Rmd
    ├── combine.Rmd
    ├── common.R
    ├── config
    │   ├── atac-config
    │   │   ├── aggregates.tsv
    │   │   ├── assays.tsv
    │   │   ├── config.yaml
    │   │   └── samples.tsv
    │   ├── multiome-config
    │   │   ├── aggregates.tsv
    │   │   ├── assays.tsv
    │   │   ├── config.yaml
    │   │   └── samples.tsv
    │   ├── README.rst
    │   └── rna-config
    │       ├── aggregates.tsv
    │       ├── assays.tsv
    │       ├── config.yaml
    │       └── samples.tsv
    ├── create_seurat.Rmd
    ├── diff_analysis.Rmd
    ├── integrate.Rmd
    ├── merge_macs_prep.Rmd
    ├── merge_zinba.Rmd
    ├── normalize_reduce_dims.Rmd
    ├── qc.Rmd
    ├── README.rst
    ├── Snakefile
    ├── weighted_nn.Rmd
    └── WRAPPER_SLURM

    6 directories, 35 files


The core workflows are:

 - :ref:`multiome`
   
 - :ref:`rna`

 - :ref:`atac`


A number of additional analyses can be added to core workflows, such as quantifyng CRISPR sgRNA 
barcodes or surface protein associated oligos, by updating relevant config files.

In all cases, search for the string **NOTE:** in the ``Snakefile`` to read notes on
how to configure each rule, and make adjustments as necessary. 

.. note:: 

    If you have two different scATAC-seq experiments, from different species, they
    have to be run separately. However, if downstream analyses will use them both
    then you would like to keep them in the same project. In this case, you can copy
    the ``workflow`` directory to two other directories:

    .. code-block:: bash

        $ rsync -rvt workflow/ workflow-genome1-atac/
        $ rsync -rvt workflow/ workflow-genome2-atac/

    Now, downstream analyses can link to and utilize results from these individual
    folders, while the whole project remains self-contained.


Features common to workflows
----------------------------

In this section, we will take a higher-level look at the features common to
all workflows.

- The config file is hard-coded to use one of the following:
  ``workflow/config/multiome-config/config.yaml``, ``workflow/config/atac-config/config.yaml``,
  or ``workflow/config/rna-config/config.yaml``. This allows the config file to be
  in the ``config`` dir with other config files without having to be specified on
  the command line, while also affording the user flexibility. For instance, a custom
  config can be specified at the command-line, using  ``snakemake
  --configfile <path to other config file>``.

- The config file is loaded using ``common.load_config``. This function resolves
  various paths (especially the references config section) and checks to see
  if the config is well-formatted.

- Various files can be used to specify cluster-specific parameters if the workflows
  are being run in a high-performance cluster environment. For more
  details, carefully read the section :ref:`cluster`.
