
.. _faq:

Frequently Asked Questions
==========================


Some package versions configured in ``env.yaml`` are unavailable on conda
-------------------------------------------------------------------------

Specific package versions can become deprecated over time. The most straightforward approach is to delete
the version information for unavailable packages in ``env.yaml``. If alternative versions are incompatible 
with the rest of the packages, delete all version information except for the following packages:

.. code-block:: yaml

      # In env.yaml
      snakemake<8
      r-seurat>5


Users may encounter additional version incompatibilities. Manually configure package versions if necessary.

My input is non-10X Genomics dataset
------------------------------------

The `multiome-wf` has been designed for use with both 10X Genomics and non-10X Genomics datasets. 
Place your input matrices for barcodes, features, and read counts in the same folder, as instructed 
in the :ref:`non-tenx`. Once your input files are ready, provide this the path to this folder 
in the sample table (``samples.tsv``), as instructed in the :ref:`samples-table`.

`multiome-wf` is incompatible with my HPC environment
-----------------------------------------------------

Consult with your HPC staff to update your configuration based on the supported environment. Refer to 
the following pages for the default configuration:

- :ref:`cluster`
- :ref:`configure-hpc`


How do I troubleshoot if I encounter errors?
--------------------------------------------

The `multiome-wf` is designed to create Snakemake log files in the ``workflow/logs`` directory. Refer to
the error messages in the log files for troubleshooting.



