``workflow`` directory
======================

This directory consists of the following files and directories.

Files for Snakemake run
~~~~~~~~~~~~~~~~~~~~~~~

``Snakefile``
-------------

Snakemake requires a ``Snakefile`` to define rules and input/output files. If you wish to customize your 
``Snakefile``, refer to `Snakefiles and Rules 
<https://snakemake.readthedocs.io/en/stable/snakefiles/rules.html>`_.


``WRAPPER_SLURM`` 
-----------------

This is an optional wrapper script that enables running Snakemake on a cluster. The Snakemake profile
is cluster-specific. The current wrapper is provided for `Slurm cluster of NIH biowulf 
<https://hpc.nih.gov/docs/userguide.html>`_. NIH users can take advantage of this by following the one-time 
setup below:

1. Clone the `Snakemake profile for biowulf <https://github.com/NIH-HPC/snakemake_profile>`_ GitHub repository

.. code-block:: bash

    $ git clone https://github.com/NIH-HPC/snakemake_profile.git <path/to/snakemake_profile>

2. Add the path to your ``snakemake_profile`` to your bash configuration file (``~/.bashrc``)

.. code-block:: bash

    $ echo '$MULTIOMEWF_SNAKEMAKE_PROFILE=<path/to/snakemake_profile>' >> ~/.bashrc

3. Update your bash configuration

.. code-block:: bash

    $ source ~/.bashrc



``config`` directory
~~~~~~~~~~~~~~~~~~~~

This directory contains configuration files used to run Snakemake. It includes ``config.yaml`` and samples 
tables.


Files for Seurat/Signac workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Files for ChooseR run
~~~~~~~~~~~~~~~~~~~~~



