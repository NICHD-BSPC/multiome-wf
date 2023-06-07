multiome-wf
===========

2023-06-05
----------

@Mira0507

- ``workflow/WRAPPER_SLURM`` updated
    - to use ``snakemake_profile`` established by NIH HPC (``https://github.com/NIH-HPC/snakemake_profile.git``)
    - to remove lines using ``SNAKE_PID``

- ``workflow/Snakefile`` updated
    - directives ``resources`` added
    - ``res_use`` added to ``params`` of the ``rule cluster``
        - enables users to set their clustering resolution in ``config.yaml`` file (see ``cluster`` in the yaml file)
    - ``workflow/cluster.Rmd`` updated accordingly
        - if statement added to choose clustering resolution between chooser-computed and user-provided values

- ``workflow/config/multiome-config/config.yaml`` updated
    - ``dataset_size`` added to reveal whether input is a toy dataset
        - ``workflow/weighted_nn.Rmd`` updated accordingly
            - If input is toydataset, ``k.nn`` and ``k.range`` is adjusted in an if statement
            - This update is required to run ``FindMultiModalNeighbors()`` error-free with tiny input data
    - Indentation corrected

- chooser updated
    - conda env updated
        - ``workflow/chooser/requirements.txt``
        - ``workflow/chooser/env.yaml``
    - multiple bugs fixed when handling toydataset in ``workflow/chooser_paral.Rmd`` and ``workflow/chooser_aggr.Rmd``

2023-06-06
----------

@Mira0507


