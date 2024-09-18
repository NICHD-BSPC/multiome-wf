
.. _changelog:

Changelog
=========

v2.0
----

Major update to supprt Seurat v5 and Snakemake v7

- Package version updates 
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

v1.2
----

Minor update

v1.1
----

Minor update to package versions in Conda environment 

- Package version updates in the default Conda environment (``env.yaml``)
- This update is aimed to fix a clustering error raised by the ``Matrix`` package in R 
  (https://github.com/NICHD-BSPC/multiome-wf/issues/18)

v1.0
----

Initial release on GitHub in 2022 March.
