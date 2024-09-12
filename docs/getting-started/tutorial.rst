.. _tutorial:

How to get started
==================

Step 1: Installing `multiome-wf`
--------------------------------

The `multiome-wf` requires the Snakemake pipeline to be cloned to your local 
system, along with necessary packages installed in the conda environment. 
Follow the instructions in the :ref:`setup` page.

If you are new to `multiome-wf`, please review the file system 
described in the :ref:`pipeline-structure` before starting configuration.

Step 2: Configuring sample tables
---------------------------------

To use input files created per sample, complete the ``samples.tsv`` in your 
configuration folder. If you are using input files where all samples
have been aggregated, fill out the ``aggregates.tsv`` in addition to 
``samples.tsv``. Refer to :ref:`config-general` for the hierarchy of 
configuration directories and files.

.. note::

    Note that `multiome-wf` organizes sample information by modality. Any sample
    tables not related to your analysis modality will be disregarded. For example, 
    the sample table for Multiome should be placed in the ``multiome-config``
    directory.

Step 3: Configuring Snakemake pipeline
--------------------------------------

The `multiome-wf` is designed to use the ``config.yaml`` file in your 
configuration folder. Modify this file according to the instructions 
in the :ref:`config-yaml`.

.. note::

    - `multiome-wf` assumes that your ``config.yaml`` and sample tables are 
      located in the same configuration directory. Any ``config.yaml`` files 
      not related to your analysis modality will be disregarded.

    - Once you have finished configuring your sample tables and ``config.yaml``,
      edit your ``Snakefile`` to set the ``configfile`` path to your 
      ``config.yaml``, as shown below:

        .. code-block:: python

            ##### load config and sample sheets #####
            configfile: "config/multiome-config/config.yaml"



Step 4 (Optional): Configuring high performance computing
---------------------------------------------------------
