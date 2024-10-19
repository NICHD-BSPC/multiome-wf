
.. _setup:

Setting up a project
====================

The general steps to use `multiome-wf` in a new project are:

1. **Installation:** download the repository to your local system, into the place
   where you want to perform the data analysis. Run the following command in your
   terminal:

.. code-block:: bash

    # Option 1: using SSH keys
    $ git clone git@github.com:NICHD-BSPC/multiome-wf.git <project_name>

    # Option 2: using HTTPS
    $ git clone https://github.com/NICHD-BSPC/multiome-wf.git <project_name>

2. **Configure:** set up ``samples.tsv`` table for experiments and edit configuration file.
Optionally, set up ``aggregates.tsv`` for cellranger-aggr barcode/library mapping 
and ``assays.tsv`` if you calculated custom count matrices.

3. **Run:** activate environment and run the Snakemake file either locally or on a cluster

.. note::

    - `multiome-wf` is tested and heavily used on Linux.

    - It is likely to work on macOS as long as all relevant conda packages are
      available for macOS -- though this is not tested.

    - It will **not** work on Windows due to a general lack of support of Windows 
      in bioinformatics tools.

    - The workflow is optimized based on the software versions in the ``env.yaml``.

    - Snakemake versions compatible with the current verion of `multiome-wf` are
      ``>=7.29`` and ``<8.0``

    - In the current version of `multiome-wf`, input datasets mapped to the **mm10 
      (mouse)** or **hg38 (human)** reference genomes are compatible.



1. Installation
---------------

Conda
^^^^^

The main prerequisite for `multiome-wf` is `conda <https://docs.conda.io/en/latest/>`_, 
with the `bioconda <https://bioconda.github.io>`_ channel set up and 
the `mamba <https://github.com/mamba-org/mamba>`_ drop-in replacement for conda.

If you have not done so already, install conda or miniconda and then mamba into your 
base environment. See links above for details.


Clone Repository
^^^^^^^^^^^^^^^^

Clone this repository into a project directory, using the following command:


.. code-block:: bash

    $ git clone https://github.com/NICHD-BSPC/multiome-wf.git

If you have SSH keys set up for GitHub, run the following command:

.. code-block:: bash

   $ git clone git@github.com:NICHD-BSPC/multiome-wf.git

Enter the project directory and create an environment based on an environment 
`YAML <https://en.wikipedia.org/wiki/YAML>`_ file:

.. code-block:: bash

    $ cd multiome-wf
    $ mamba env create --prefix ./env --file env.yaml

Since we specify a YAML environment file, be sure to use ``mamba env create`` 
instead of the more common ``mambe create`` command.



2. Configure
------------

This step takes the most effort. The first time you set up a project it
will take some time to understand the configuration system.

See :ref:`config` for more.

3. Run
------

Activate the main conda environment and go to the workflow you want to run. 
For example if you have configured a scRNA-seq run, then do:

.. code-block:: bash

    $ conda activate ./env

and run the following:

.. code-block:: bash

    # Dry run
    $ snakemake -n


If all goes well, this should print a list of jobs to be run.

You can run locally, but this is NOT recommended. To run locally, choose the
number of CPUs you want to use with the ``-j`` argument as is standard for
Snakemake.

.. warning::

    If you haven't made any changes to the 
    `Snakefile <https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html>`_,
    be aware that the default configuration needs a lot of RAM. Adjust the Snakefiles
    accordingly if you don't have enough RAM available (search for "Xmx" to find 
    the Java args that set memory).

.. code-block:: bash

    # run locally (not recommended)
    snakemake --use-conda -j 8

and then monitor the various jobs that will be submitted on your behalf. See
:ref:`cluster` for more details on this. 

.. note::
   You can execute Snakemake jobs on a cluster using 
   `cluster profiles <https://snakemake.readthedocs.io/en/stable/executing/cli.html#profiles>`_.
   Consult the configuration of your high-performance computing system. The current pipeline
   relies on the `snakemake_profile <https://github.com/NIH-HPC/snakemake_profile>`_
   supported by `NIH Biowulf <https://hpc.nih.gov/>`_.


You can typically run simultaneous workflows when they are in different
directories; see :ref:`overview-wf` for details.
