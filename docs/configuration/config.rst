
.. _config:

Configuration details
=====================


.. _config-general:

General configuration
~~~~~~~~~~~~~~~~~~~~~

The majority of the work in setting up a new project is in the configuration --
which samples to run, where the data files are located, which references are
needed, etc.

**The entry point for configuration** is found in ``workflow/config`` directory
as shown below:

.. code-block:: bash

    $ tree workflow/config
    workflow/config
    ├── atac-config
    │   ├── aggregates.tsv
    │   ├── assays.tsv
    │   ├── config.yaml
    │   └── samples.tsv
    ├── multiome-config
    │   ├── aggregates.tsv
    │   ├── assays.tsv
    │   ├── config.yaml
    │   └── samples.tsv
    ├── README.rst
    └── rna-config
        ├── aggregates.tsv
        ├── assays.tsv
        ├── config.yaml
        └── samples.tsv

    3 directories, 13 files


``config.yaml``
---------------

This is a `snakemake configuration file 
<https://snakemake.readthedocs.io/en/stable/snakefiles/configuration.html>`_.

See :ref:`config-yaml` for pipeline-specific configuration.

``samples.tsv``
---------------

This is a default sample table containing input file paths and metadata.

See :ref:`samples-table` for more.


``aggregates.tsv`` (Optional)
-----------------------------


This table is used to map library barcode labels to library IDs 
in aggregated input files. The aggregated input contains multiple biological 
replicates, which can be generated using ``cellranger-arc aggr`` (multiome), 
``cellranger-atac aggr`` (scATAC-seq), or ``cellranger aggr`` (scRNA-seq). 

See :ref:`aggregates-table` for more.

``assays.tsv`` (Optional)
-------------------------

The assay table is only used if you have calculated custom feature-by-barcode 
counts matrices. For example, if one has a genome annotation file containing 
gene coordinates and enhancer coordinates, you can count all ATAC reads mapping 
to a gene and associated enhancers:

Gene Activity Score = reads mapped within gene + reads mapped to enhancers

See :ref:`assays-table` for more.


.. _cluster:

Running on a cluster
~~~~~~~~~~~~~~~~~~~~

The example commands in :ref:`getting-started` describe running Snakemake
locally. For larger data sets, you'll want to run them on an HPC cluster.
Snakemake `supports arbitrary cluster commands
<http://snakemake.readthedocs.io/en/latest/snakefiles/configuration.html>`_,
making it easy to run these workflows on many different cluster environments.

Snakemake and these workflows are designed to decouple the code from the
configuration. If you are running the workflows on NIH's Biowulf cluster, you
don't need to change anything.

If you are running on a different cluster, you should inspect the following files:

- ``WRAPPER_SLURM``
- Profile config files from the `NIH HPC <https://github.com/NIH-HPC/snakemake_profile.git>`_

The default configuration we provide is specific to the NIH Biowulf cluster.
To run a workflow on Biowulf, from the top-level project directory, 
run the following command

.. code-block:: bash

    sbatch WRAPPER_SLURM

The ``WRAPPER_SLURM`` script submits the main Snakemake process on a separate
node to avoid any restrictions from running on the head node. That main
Snakemake process then submits each rule separately to the cluster scheduler.


.. _cluster_specific:

``TMPDIR`` handling
~~~~~~~~~~~~~~~~~~~
The top of each snakefile sets up a shell prefix that exports the TMPDIR
variable. The reason for this is that the NIH Biowulf cluster supports nodes
with temporary local storage in a directory named after the SLURM job ID. This
ID is not known ahead of time, but is stored in the ``SLURM_JOBID`` env var.

Since each rule executed on a cluster node calls the snakefile (see the job
scripts created by snakemake for more on this), we can look for the job ID and
set the tempdir appropriately. Upon setting ``$TMPDIR``, the Python
``tempfile`` module will use that directory to store temp files. Any wrappers
can additionally use ``$TMPDIR`` in shell commands and it will use this
directory.

Note that the default behavior -- if the ``SLURM_JOBID`` env var is not set --
is to set ``$TMPDIR`` to the default temp directory as documented in Python's
`tempfile module
<https://docs.python.org/3/library/tempfile.html#tempfile.gettempdir>`_.
However if you use these workflows on a different cluster, you may need to
provide a different function to return the job-specific temp directory.


.. _new_cluster_config:

Cluster configuration
~~~~~~~~~~~~~~~~~~~~~

For Snakemake versions after 7.29, we use profile established by 
`NIH HPC <https://github.com/NIH-HPC/snakemake_profile.git>`_. If you're a first-time user,
you can setup your profile on NIH's Biowulf as demonstrated below:

.. code-block:: bash

    # Clone the profile repo
    git clone https://github.com/NIH-HPC/snakemake_profile.git /data/$USER/snakemake_profile

Once the repository is cloned, add ``export MULTIOMEWF_SNAKEMAKE_PROFILE="/data/$USER/snakemake_profile"``
to your bash configuration file (``~/.bashrc``). 

Update your bash config by running the following command:

.. code-block:: bash

    source ~/.bashrc


After completing your initial configuration for HPC utilization,
return to the ``WRAPPER_SLURM`` file to set the ``--configfile`` parameter 
to point to the ``config.yaml`` you're using.

.. code-block:: bash

    # In WRAPPER_SLURM:
    (
        time snakemake \
        <snakemake_parameters>
        --configfile config/multiome-config/config.yaml \    # IMPORTANT!
        ) > "Snakefile.log" 2>&1


