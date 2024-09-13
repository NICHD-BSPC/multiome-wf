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

    `multiome-wf` assumes that your ``config.yaml`` and sample tables are 
    located in the same configuration directory. Any ``config.yaml`` files 
    not related to your analysis modality will be disregarded.



Step 4: Updating ``Snakefile``
------------------------------

Once you have finished configuring your sample tables and ``config.yaml``, 
edit your ``Snakefile`` accordingly. First, point the ``configfile`` to your 
``config.yaml`` file, as shown below:

.. code-block:: python

    configfile: "config/multiome-config/config.yaml"

Depending on the computation resources required for each rule, update
the ``resources`` directive, as shown below:

.. code-block:: python

    resources:
        mem_mb=1024 * 100,
        disk_mb=1024 * 50,
        runtime=60 * 12

.. note::

    If it is difficult to accurately estimate the required resources, you can 
    update them after encoutering out-of-resource errors during the run.

.. _configure-hpc:

Step 5 (Optional): Configuring high performance computing
---------------------------------------------------------

Optionally, users can run the `multiome-wf` on a High Performance Computing (HPC) cluster 
using Snakemake's cluster execution feature. Refer to the :ref:`cluster` for more details.

Once you have finished configuring your sample tables, ``config.yaml``, and 
updated your ``Snakefile`` accordingly, set the ``--configfile`` parameter to the 
path of your ``config.yaml`` file in the ``WRAPPER_SLURM`` file, as shown below:

.. code-block:: bash

    # Run snakemake
    (
      time snakemake \
      -p \
      --directory $PWD \
      -k \
      --restart-times 3 \
      --rerun-incomplete \
      --rerun-triggers mtime \
      --jobname "s.{rulename}.{jobid}.sh" \
      -j 999 \
      --use-conda \
      --configfile config/multiome-config/config.yaml \    # UPDATE THIS PARAMETER!
      $PROFILE_CMD \
      --latency-wait=300 \
      --max-jobs-per-second 1 \
      --max-status-checks-per-second 0.01 \
      "$@"
      ) > "Snakefile.log" 2>&1


.. note::

    Note that the default configuration of `multiome-wf` is optimized for `NIH's Biowulf 
    <https://hpc.nih.gov/>`_ and may not be suitable for other HPC systems. Users may need  
    additional configuration, including modifications to the ``WRAPPER_SLURM``, depending 
    on their computing environment.

Step 6: Run
-----------

Once everything is ready, users can run the workflow with or without cluster computing. Assuming 
you are in the same directory where your ``Snakefile`` is located, use the following command in your 
terminal to run without submitting a cluster job:

.. code-block:: bash

   # Activate conda environment
   conda activate ../env
   # Run Snakemake
   snakemake --core 8

If you wish to run `multiome-wf` on a cluster and you have configured the pipeline for cluster
computing, activate your conda environment and use the following command in the terminal:

.. code-block:: bash

   # Run Snakemake by submitting jobs
   sbatch WRAPPER_SLURM


.. note::

    The above command is optimized for job submission on NIH's Biowulf. Consult your HPC 
    documentation or administrator for guidance on running Snakemake on a cluster,
    if necessary.


Step 7: Results
---------------

The `multiome-wf` creates a ``results`` folder in the ``workflow`` directory upon completion of a run.
All output files are saved in the ``results`` folder. Refer to the :ref:`overview-output` for more 
information.
