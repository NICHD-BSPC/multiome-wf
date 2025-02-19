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

2023-10-05
----------

@Mira0507

- Documentation updated
    - ``docs/configuration/config.rst`` updated
    - ``docs/configuration/config-yaml.rst`` updated


2024-07-02
----------

@Mira0507

- conda env tested
    
    .. code-block:: yaml

        macs2
        graphviz
        r-tidyverse
        r-base
        r-seurat
        r-seuratobject
        r-signac
        r-matrix
        snakemake<8
        r-hdf5r
        r-ggplot2
        r-ggrepel
        r-plotly
        r-patchwork
        r-devtools
        r-remotes
        bioconductor-bsgenome.hsapiens.ucsc.hg38
        bioconductor-biovizbase
        bioconductor-ensembldb
        bioconductor-ensdb.hsapiens.v86
        bioconductor-limma
        bioconductor-ensdb.mmusculus.v79
        bioconductor-genomicranges
        samtools
        r-data.table
        bioconductor-rhdf5
        python
        pandas
        rst2html5
        alabaster

2024-07-03
----------

@Mira0507

- scripts updated
    - ``workflow/Snakefile``: ``resources`` in ``diff_analysis`` rule
    - ``workflow/create_seurat.Rmd``
        - code cleaned
        - cleaner printing in rendered files
    - ``workflow/qc.Rmd``
        - cleaner printing in rendered files

2025-02-06
----------

@Mira0507

- Three rules added to ``workflow/Snakefile`` in order to create ``bigwig`` files 
  using MACS2-called peaks
    - ``chromsizes``: creates chromsizes
    - ``bigwig_signal``: converts MACS2-created ``bdg`` files for signal to ``bigwig``
    - ``bigwig_noise``: converts MACS2-created ``bdg`` files for noise to ``bigwig``

2025-02-12
----------

@Mira0507

- ``workflow/chooser_paral.Rmd`` updated to fix a bug
    - resolution set to 1.0 ended up deleting the ``results/chooser_run/unintegrated_3/res_1.0``
      directory after the completion of the following run

        .. code-block:: bash

            rule chooser_paral:
                input: chooser_paral.Rmd, results/normalize_reduce_dims/unintegrated_3/unintegrated_3.rds, config/multiome-config/config.yaml
                output: results/chooser_run/unintegrated_3/res_1.0/report.html, results/chooser_run/unintegrated_3/res_1.0, results/chooser_run/unintegrated_3/silhouette_1.0.rds, results/chooser_run/unintegrated_3/frequency_grouped_1.0.rds, results/chooser_run/unintegrated_3/silhouette_grouped_1.0.rds, results/chooser_run/unintegrated_3/seurat_obj_1.0.rds
                jobid: 56
                reason: Missing output files: results/chooser_run/unintegrated_3/frequency_grouped_1.0.rds, results/chooser_run/unintegrated_3/silhouette_grouped_1.0.rds, results/chooser_run/unintegrated_3/silhouette_1.0.rds; Input files updated by another job: results/normalize_reduce_dims/unintegrated_3/unintegrated_3.rds
                wildcards: seurat=unintegrated_3, res=1.0
                threads: 12
                resources: tmpdir=/tmp, mem_mb=102400, mem_mib=97657, disk_mb=51200, disk_mib=48829, runtime=720

    - fix: set the resolution to 1 instead of 1.0 in ``config.yaml``

        .. code-block:: yaml

            chooser:
              groups:
                unintegrated_1:
                  npcs: 20
                unintegrated_2:
                  npcs: 20
                unintegrated_3:
                  npcs: 20
                integrated_1:
                  npcs: 20
                integrated_2:
                  npcs: 20
                integrated_3:
                  npcs: 20
              resolutions:
                - 0.8
                - 1     # UPDATED!
                - 1.2
              silhouette:
                - silhouette
                - frequency_grouped
                - silhouette_grouped

2025-02-18
----------

@Mira0507

- ``workflow/chooser_aggr.Rmd`` updated to fix the following error:

    .. code-block:: r

        Error in bca.ci(boot.out, conf, index[1L], L = L, t = t.o, t0 = t0.o,  :
          estimated adjustment 'w' is infinite

    - bug: this error was raised when the ``boot::boot.ci`` is called with
      the following input vector: ``c(1, 0, 1, 0, 1, 0, 0)``. this error 
      appeared to be raised by few unique input values (0 and 1), which results
      in a trouble with smoothing resampling distributions in bootstrapping.

        .. code-block:: r

            # workflow/chooser/R/pipeline.R
            boot_median <- function(x, interval = 0.95, R = 25000, type = "bca") {
              # Define median to take data and indices for use with boot::
              med <- function(data, indices) {
                resample <- data[indices]
                return(median(resample))
              }

              # Calculate intervals
              boot_data <- boot::boot(data = x, statistic = med, R = R)
              boot_ci <- boot::boot.ci(boot_data, conf = interval, type = type)

              # Extract desired statistics
              ci <- list(
                low_med = boot_ci$bca[4],
                med = boot_ci$t0,
                high_med = boot_ci$bca[5]
              )
              return(ci)
            }


    - fix: introduce small random noise to the input vector

        .. code-block:: r

            x_jittered <- x + rnorm(length(x), mean = 0, sd = 0.0001)
            boot_median(x_jittered, type="bca")

