
.. _changelog:

Changelog
=========

v2.0 (September 2024)
---------------------

Major update to support Seurat v5

- Package version updates 
    - Upgraded Seurat from v4 to v5
    - Updated packages in Conda environments
    - Conda environments for the default Snakemake and ChooseR: ``env.yaml`` and 
      ``workflow/chooser/env.yaml``
- Enhanced presentation of results in the report ``html`` files
- ``config.yaml`` updates:
    - ``integrate`` field:
       - Removed ``n_dataset``, ``reference``, ``query``. Instead, datasets will be split using
         the metadata column specified by the ``split_by`` key and then integrated.
       - Added ``integrate_method`` key to allow users to select the desired integration algorithm
    - ``coembed`` field: deprecated
    - ``cluster`` field: added ``detection_method`` to allow users to specify community detection 
      algorithm.
    - ``weighted_nn`` field: added ``detection_method`` to allow users to specify community detection 
      algorithm.
    - ``diff_analysis`` field: disabled logistic regression (``LR``) due to a bug causing unallocated 
      CPU issues on HPC systems
    - ``guide`` field: deprecated
- Bugfix: Resolved an issue with incorrect prefixes in clustering columns in the metadata
  (https://github.com/NICHD-BSPC/multiome-wf/issues/17)


v1.1, v1.2 (July 2024)
----------------------

Minor update to upgrade package versions in the Conda environment and enhance functionality

- Package version updates in the default Conda environment (``env.yaml``)
- This update also fixes a clustering error caused by the ``Matrix`` package in R 
  (https://github.com/NICHD-BSPC/multiome-wf/issues/18)
- ``n_dataset`` key added to the ``integrate`` field in ``config.yaml``. This key speficies
  the number of datasets to be integrated for cases where there are more than two datasets.

v1.0 (October 2023)
-------------------

Major update to support Snakemake v7

- Snakemake updates
    - Upgraded Snakemake from v6 to v7
    - Updated ``Snakefile`` to use the ``resources`` directive in each rule
    - Removed the ``--clusterconfig`` mechanism
    - Requires the use of a `profile 
      <https://snakemake.readthedocs.io/en/stable/executing/cli.html#profiles>`_
      when running on a cluster (e.g. `snakemake_profile <https://github.com/NIH-HPC/snakemake_profile>`_
      prepared for `NIH's Biowulf <https://hpc.nih.gov/>`_)
    - Updated ``WRAPPER_SLURM`` accordingly
- ``config.yaml`` updates
    - ``toydataset`` field
        - Added to optimize integration for small datasets
        - The ``toy_k`` key specifies the number of neighbors when weighting anchors 
          during integration. This value is passed to the ``k.weight`` argument 
          in Seurat's ``IntegrateData`` function.
    - ``cluster`` field
        - Users are allowed to specify clustering resolution using the ``resolution`` key
        - Alternatively, dataset-optimized resolution can be used by setting the ``resolution`` 
          key to ``null`` with `chooseR 
          <https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-021-03957-4>`_.


v0.0 (March 2022)
-----------------

Initial release on GitHub in March 2022
