.. multiome-wf documentation master file, created by
   sphinx-quickstart on Sun Jan 30 19:22:49 2022.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. toctree::
   :caption: Getting Started
   :maxdepth: 1
   :name: getting-started
   :hidden:

   getting-started/setup
   getting-started/tutorial
   getting-started/why-use

.. toctree::
   :caption: Workflows
   :maxdepth: 1
   :name: workflows
   :hidden:

   workflows/overview-wf
   workflows/multiome
   workflows/rna
   workflows/atac
   workflows/overview-input

.. toctree::
   :caption: Configuration
   :maxdepth: 1
   :name: configuration
   :hidden:

   configuration/config
   configuration/config-yaml
   configuration/samples-table
   configuration/aggregates-table
   configuration/assays-table
   configuration/config-multiome
   configuration/config-rna
   configuration/config-atac

.. toctree::
   :caption: Project Info
   :maxdepth: 1
   :name: project-info
   :hidden:

   project-info/citations
   project-info/faq
   project-info/authors

.. _docs-main:

About
=====

`multiome-wf` is a Snakemake workflow for common single cell sequencing analyses.

With the advent of new sequencing methods and associated data sets, combining different
single cell sequencing modalities is cumbersome and error-prone. A core feature of the
`multiome-wf` is standardizing how disparate data types are combined and preprocessed
prior to downstream analyses.

The workflow was build around 10X Genomics products, but should work with any single 
cell data set as long as the input matrices have been properly formatted.

Some of the modalities this workflow supports include:

- Gene Expression: quantified by cellranger count and cellranger aggr

- ATAC: quantified by cellranger-atac count and cellranger aggr

- Multiome (Gene Exression + ATAC from same cell), CITE-Seq: quantified by cellranger-arc count and cellranger-arc aggr

- Cell Multiplexing (Cell Multiplexing Oligos): demultiplexed using cellranger pipelines.

- Multiple Batches, Multiple experimental conditions

.. _note:
    While this workflow does some basic tertiary analyses, such as differential testing, the
    core purpose of this workflow is preparing a unified dataset to be used as input for standalone
    downstream analyses, such as Trajectory Inference, Gene-Peak Interactions, etc which are
    not currently supported by this workflow.


Getting Started
---------------

See :ref:`getting-started` to get started.

See :ref:`workflows` to learn more about the supported workflows.

