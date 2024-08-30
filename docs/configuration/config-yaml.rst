.. _config-yaml:

Config YAML
===========

This page details the various configuration options and describes how to
configure a new workflow. Refer to the :ref:`config` section for general 
information about configuring `multiome-wf`.

While it is possible to use Snakemake mechanisms such as ``--config`` to
override a particular config value and ``--configfile`` to update the config
with a different file, it is easiest to edit the existing
``config.yaml`` in place. This has the additional benefit of reproducibility
because all of the config information is stored in one place.

The config file uses `YAML <https://en.wikipedia.org/wiki/YAML>`_ format, which 
can be conceptualized as a set of nested key:value pairs. When running the workflow, 
the YAML document is parsed into a python dictionary.

By specifying values in various setions of the ``config.yaml``, the workflow 
automatically decides to run analysis variants suitable for scRNA-Seq, scATAC-Seq, 
or multi-modal experiments. With this in mind, there are 2 important points to keep 
in mind when creating a ``config.yaml``.

1. Activating Rules
~~~~~~~~~~~~~~~~~~~

The following rules are optional:

- ``merge_macs_prep``/``macs2``/``add_macs_peaks`` for MACS2 peak calling
- ``integrate`` for `dataset integration using Seurat 
  <https://satijalab.org/seurat/articles/integration_introduction>`_
- ``chooser_paral``/``chooser_aggr`` for computing optimal resolution in clustering
  using `chooseR <https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-021-03957-4>`_
- ``diff_analysis`` for marker gene computation
- ``weigted_nn`` for `Weighted Nearest Neighbor Analysis 
  using Seurat <https://satijalab.org/seurat/articles/weighted_nearest_neighbor_analysis>`_
  (cross-modality integration)


These rules have discrete sections in the ``config.yaml`` where users configure the execution of 
each rule. Refer to the following instruction to activate or inactivate each rule:

.. code-block:: yaml

    # Activate MACS2 peak calling
    macs2:
        run: "Y"

    # Activate dataset integration
    integrate:
        activate: true

    # Activate chooseR
    cluster:
        resolution: null

    # Activate marker gene computation
    diff_analysis:
        activate: true

    # Activate Weighted Nearest Neighber
    weighted_nn:
        activate: true


Note that the ``chooser_paral`` and ``chooser_aggr`` rules only run when no
pre-defined ``resolution`` is provided by the user in the ``cluster`` section.

2. Analysis Groups
~~~~~~~~~~~~~~~~~~

Because of the myriad variants for single cell analysis and preprocessing, it is 
not possible to hard-code all the configuration options in the ``config.yaml`` file. 
Instead, we include analysis "group names" in many sections. These rules will have 
a field named ``group``. Each ``group`` must contain a nested dictionary for each 
analysis variant.

To configure these sections, the user must specify the top-level dictionary key value.
All other keys are hard-coded as options.

Using the ``normalize`` section as an example, we see a single analysis group below. 
The group value, ``unintegrated_0``, is itself a dictionary key for this analysis
variant (a modality for RNA in multiome). This group's dictionary contains additional fields
which together define the groups' analysis options: ``assay_name``, and ``norm_method``.

.. code-block:: yaml

    groups:
        unintegrated_0:
            assay_name: Gene.Expression
            norm_method: sct
        unintegrated_1:
            assay_name: Peaks
            norm_method: lsi
        unintegrated_2:
            assay_name: MACS
            norm_method: lsi
        unintegrated_3:
            assay_name: Gene.Activity
            norm_method: log


.. note::

    It is possible to specify more analysis groups than the number of assays in your data.
    **Do not** specify analysis groups unless your experiment setup supports the condition.

    For example, in the example ``config.yaml`` file, the differential analysis section,
    ``diff_analysis`` contains 2 group key names, ``unintegrated_0`` and ``integrated_0``, if
    you are not performing Seurat integration by setting the ``activate`` key to ``false`` 
    in the ``integrate`` section, delete the ``integrated_*`` group in the rest of the sections.
    If their are superflous groups in the ``config.yaml``, Snakemake will add extra, unwanted 
    rules/jobs when building a DAG.


Field descriptions
~~~~~~~~~~~~~~~~~~

Config Tables
-------------

``samples`` field
^^^^^^^^^^^^^^^^^

    string, default ``samples.tsv``. Defines path to sampletable.
    See :ref:`samples-table` for more.

    Example:

    .. code-block:: yaml

        samples: "config/multiome-config/samples.tsv"

        # OR 
        # samples: "config/atac-config/samples.tsv" for scATAC-seq
        # samples: "config/rna-config/samples.tsv" for scRNA-seq

``aggregates`` field
^^^^^^^^^^^^^^^^^^^^

    string, default ``aggregates.tsv``. Defines path to aggregates table.
    If you are using aggregated input of multiple samples created using 
    ``cellranger-arc aggr`` (multiome), ``cellranger-atac aggr`` (scATAC-seq), 
    or ``cellranger aggr`` (scRNA-seq), specify the path to ``aggregates.tsv``. 
    Otherwise, set to an empty string (``""``). See :ref:`aggregates-table` 
    for more.

    Example:

    .. code-block:: yaml

        assays: "config/multiome-config/aggregates.tsv"

        # OR
        # assays: "config/atac-config/aggregates.tsv" for scATAC-seq
        # assays: "config/rna-config/aggregates.tsv" for scRNA-seq

``assays`` field
^^^^^^^^^^^^^^^^

    string, default ``assays.tsv``. Defines path to assays table.
    If you are using custom counts matrices, specify path to ``assays.tsv``. 
    Otherwise, set to an empty string (``""``). See :ref:`assays-table` 
    for more.

    Example:

    .. code-block:: yaml

        assays: "config/multiome-config/assays.tsv"

        # OR
        # assays: "config/atac-config/assays.tsv" for scATAC-seq
        # assays: "config/rna-config/assays.tsv" for scRNA-seq

Annotation
----------

``ANNOTATION`` field
^^^^^^^^^^^^^^^^^^^^

    ``"EnsDb"`` or ``"GTF"``, default ``"EnsDb"``. Defines the method to build an 
    annotation object (``GenomicRanges``) for scATAC-seq and multiome analyses.

    - ``"EnsDb"`` uses the ``EnsDb.Mmusculus.v79`` (mouse mm10) or ``EnsDb.Hsapiens.v86``
      (human hg38) package in R
    - ``"GTF"`` uses a user-provided annotation file 

``ANNO_FILE`` field
^^^^^^^^^^^^^^^^^^^

    string, default ``"path/to/genes.gtf.gz"``. If ``"GTF"`` is specified in the 
    ``ANNOTATION`` field, provide the path to your annotation file (e.g. ``genes.gtf.gz``). 
    This field is disregarded if the ``ANNOTATION`` field is set to ``"EnsDb"``.

Quality Control (``qc`` section)
--------------------------------

``remove_outliers`` field
^^^^^^^^^^^^^^^^^^^^^^^^^

    boolean, default ``true``. Specify whether or not to run ``qc`` rule.

``rm_outliers_method`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    ``"sd"`` or  ``"iqr"``, default ``"sd"``. Detect outliers using either standard 
    deviation (``"sd"``), or Tukey's interquartile range (``"iqr"``). If set to
    ``"sd"``, the thresholds are determined based on +/- 3 standard deviations.

``meta_labels`` field
^^^^^^^^^^^^^^^^^^^^^

    list. Which metadata columns to use for filtering?

    See :ref:`samples-table` for more details about how metadata columns are detected. 
    If a value is specified in this field, but is not present in the data, it will be 
    disregarded during filtering.

``lower`` field
^^^^^^^^^^^^^^^

    dict. Key:value pairs of metadata column and associated lower limit for cutoff, 
    **below** which exclude cells. If specified, overrides lower limit detected 
    by outlier method for associated metadata columns in ``meta_labels``. If ``null``, 
    outlier method tries to remove cells automatically

``upper`` field
^^^^^^^^^^^^^^^

    dict. Key:value pairs of metadata column and associated upper limit for cutoff, 
    **above** which exclude cells. If specified, overrides lower limit detected 
    by outlier method for associated metadata columns in ``meta_labels``. If ``null``, 
    outlier method tries to remove cells automatically

.. note::

    - In the example below, 3 metadata columns are specified. 3 have hard cut-offs 
      (``nCount_Gene.Expression``, ``nCount_Peaks``, and ``TSS.enrichment``), 
      1 detects lower outliers automatically (``percent.mt``).

    - 10X Genomics ATAC and multiome kits use nuclei, so reads will not map to mitochondria. 
      However, the workflow imputes a value of 0 for ``percent.mt`` in these assays, since 
      missing values are not generally allowed in the underlying packages. This will not 
      effect downstream processes such as normalization, dimensional reduction, clustering, 
      etc.



Example:

.. code-block:: yaml

    qc:
        remove_outliers: true
        rm_outliers_method: sd
        meta_labels:
            - nCount_Gene.Expression
            - nCount_Peaks
            - percent.mt
            - TSS.enrichment
        lower:
            nCount_Gene.Expression: 100
            nCount_Peaks: 1000
            TSS.enrichment: 2
        upper: null

MACS Peak Calling (``macs2`` section)
-------------------------------------

MACS specific parameters.

``run`` field
^^^^^^^^^^^^^

    ``"Y"`` or  ``"N"``, default ``"Y"``. Determine whether or not to run MACS.
    Set to ``"N"`` for RNA-seq. Set to ``"Y"`` for ATAC and multiome requiring MACS 
    peak calling. If you don’t run MACS, delete analysis groups where ``assay_name`` 
    corresponds to ``MACS`` in the remaining sections/fields 
    (e.g. ``unintegrated_2``).

``group_fragments_by`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    string, default ``"genome"``. ``samples.tsv`` metadata column to generate 
    fragments file. All labels in the specified column must have the same value. 
    This forces generation of a single fragments file for MACS peak calling.
    Do not change this setting unless under special circumstances.

Example:

.. code-block:: yaml

    macs2:
        run: "Y"
        group_fragments_by: genome

Normalization (``normalize`` section)
-------------------------------------

Normalization and linear dimensionality reduction.

``split_by`` field
^^^^^^^^^^^^^^^^^^

    string. 

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform normalization. Group name (key) must be unique.

``assay_name`` field
^^^^^^^^^^^^^^^^^^^^

    {"Gene.Expression", "Multiplexing.Capture", "Peaks", "Gene.Activity", "MACS"}. Which Seurat assay to use. Note: Seurat assay names are '.' delimited.

``norm_method`` field
^^^^^^^^^^^^^^^^^^^^^

    {"log", "sct", "clr" or "lsi"}, defaul {Gene.Expression: sct, Peaks: lsi, MACS: lsi, Gene.Activity: log, protein: clr}. Method to normalize the group's assay. Normalize using Log (log), SCTransform (sct), CLR (clr) or latent semantic indexing (lsi). Suggestions include: 5' or 3' Gene expression are typically normalized by Log or SCTransform methods, ATAC Peaks by LSI, and protein by CLR.

Example:

.. code-block:: yaml

    normalize:
        split_by: meta_geno
        groups:
            unintegrated_0:
                assay_name: Gene.Expression
                norm_method: sct
            unintegrated_1:
                assay_name: Peaks
                norm_method: lsi
            unintegrated_2:
                assay_name: MACS
                norm_method: lsi
            unintegrated_3:
                assay_name: Gene.Activity
                norm_method: log

Integration
-----------

``integrate`` config section

    Remove technical/batch effects using Seurat integration methods. This field has 3 sub-fields. Integration rule will create a new Seurat object for each integration performed. 

    ``activate`` field

        boolean, default true. Specify whether or not to run qc rule.

    ``memory_MB`` field

        integer, default null. Specify memory avaiable to R during integration methods. Default R memory is 500 MB. Integration of large data may need this increased to 5-35 GB, as needed.

    ``atac_integrate_embeddings`` field

        boolean, default true. If True, integrate low-dimensional cell embeddings (LSI coordinates) across the datasets. This is the best option for integrating multiple ATAC Peaks data sets. If False, integrate (transform) ATAC Peaks counts matrix across datasets (not LSI coordinates). This may over fit. Kept mainly for legacy support.

    ``groups`` field

        dict. Each group to perform integration. Group name (key) must be unique.

    ``split_by`` field

        string. Metadata column to generate Seurat list prior to integration. 

        See :ref:`samples-table` for more details about how metadata columns are detected.

    ``n_dataset`` field

        integer, the number of datasets to be integrated if more than 2 datasets are integrated.

    ``reference`` field

        dict. Information about the sample(s) to use as a reference during intergation.

        ``label`` field

            string. A single value/label from ``split_by`` column. Used to subset Seurat object to create reference object.

        ``assay_name`` field

            {"Gene.Expression", "Multiplexing.Capture", "Peaks", "Gene.Activity", "MACS"}. Which assay to use as reference assay for integration?

    ``query`` field

        dict. Information about the sample(s) to use as a reference during intergation.

        ``label`` field

            string. A single value/label from ``split_by`` column. Used to subset Seurat object to create query object.

        ``assay_name`` field

            {"Gene.Expression", "Multiplexing.Capture", "Peaks", "Gene.Activity", "MACS"}. Which assay to use as query assay for integration?

    ``norm_method`` field

        {"log", "sct", "clr" or "lsi"}. Nrmalization method to perform on reference and query assays prior to Seurat integration. Suggested methods for integrating only GEX: 'log' or 'sct'. Suggested method for integrating only ATAC: 'lsi'. Suggested method for integrating GEX and ATAC together: 'log'.

    ``integrate_dims`` field

        list of 2 integers, default [1, 30]. Range of dimensions to use for integration stap.

    Example:

    .. code-block:: yaml

        integrate:
          activate: true
          memory_MB: null
          atac_integrate_embeddings: true
          groups:
            integrated_0:
              split_by: meta_batch
              n_dataset: 4
              reference:
                label: batch1
                assay_name: Gene.Expression
              query:
                label: batch2
                assay_name: Gene.Expression
              norm_method: sct
              integrate_dims:
              - 1
              - 30


Utilization of Toy Dataset
--------------------------

``dataset_size`` config section
    
    Assign the utilization of toy dataset. If dataset size is smaller than default k values in kNN computation during integration, Seurat throws an error. 
    

    ``toydataset``
        
        boolean, set true if input is toy dataset and false otherwise.

    ``toy_k``

        size of the number of neighbors when weighting anchors during integration.

    Example:

    .. code-block:: yaml

        dataset_size:
            toydataset: true
            toy_k: 10

Coembedding RNA/ATAC
--------------------

``coembed`` config section

    Integrate single assay 5' or 3' Gene Expression and single assay ATAC data into a common reduced dimensional space. This field has X sub-fields. This is the preferred method to integrate Gene Expression and ATAC data; the standard Seurat integration methods tend to over fit the disparate RNA and ATAC assays. 

    ``activate`` field

        boolean, default false. Specify whether or not to run the coembed rule.

    .. note::

        This rule is unfinished. Config fields and suggested values have intentionally been omitted. Until this documentation is updated, keep the activate field set to false.

Cluster Optimization
--------------------

``chooser`` config section

    Robust selection of parameters for single cell community detection. This field has 3 sub-fields. This rule utilizes methods developed in the ChooseR package. For details about Chooser theory and methods, see `ChooseR Documentaiton Page <https://github.com/rbpatt2019/chooseR>`_

    ``groups`` field

    dict. Each group to perform clustering parameter optimization. Group name (key) must be unique.

        ``npcs`` field

        integer, default {Gene.Expression: 25, ATAC-derived: 20}. The maximum number of linear reduced dimensions dimensional to during clustering. If group contains ATAC Peaks or MACS matrices, this will use LSI components. Otherwise, PCA.

    ``resolutions`` field

        list of integers, default [0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 4, 6, 8, 12, 16]. Resolutions to use when bootstrapping cluster methods. Best to have a range spanning target resolution.

    ``silhouette`` field

        list of strings. default [silhouette, frequency_grouped, silhouette_grouped]. Values are used during path parameter expansion during chooser rules. Advisable to not alter.

    .. note::

        All ``group`` values specified in the config sections: `normalize` and `integrate` (if appicable) **must** have a group entry in the `chooser` config section.

    Example:

    .. code-block:: yaml

        chooser:
          groups:
            unintegrated_0:     # unintegrated Gene Expression
              npcs: 25
            unintegrated_1:     # unintegrated ATAC Peaks
              npcs: 20
            integrated_0:       # integrated Gene Expression to remove batch effects
              npcs: 25
          resolutions:
            - 0.8
            - 1
            - 1.2
            - 1.4
            - 1.6
            - 1.8
            - 2
            - 4
            - 6
            - 8
            - 12
            - 16
          silhouette:
            - silhouette
            - frequency_grouped
            - silhouette_grouped

Clustering Resolution
---------------------

``cluster`` config section
    
    Set the clustering resolution.

    ``resolution``

        float, set the clustering resolution manually. If set to ``null``, the resolution is determined through the optimization using the ``chooser``.

    Example:

    .. code-block:: yaml

        cluster:
            resolution: 0.6

Weighted Nearest Neighbor
-------------------------

``weighted_nn`` config section

    Perform weighted nearest neighbor (WNN) analysis. This field has 2 sub-fields. WNN is similar to shared nearest neighbor commonly used to build graphs while detecting clusters. WNN uses a list of weights from each specified modality, and is useful for incorporating low dimensional embedings from multiple single cell modalities into a global reduced dimensional space. 

    ``activate`` field

        boolean, default false. Specify whether or not to run the coembed rule.

    ``groups`` field

        dict. Each group to perform weighted nearest neighbor analysis. Group name (key) must be unique.
   
    ``neighbor_method`` field

        string, default "weighted". 

    ``input_groups`` field

        list of strings, default ["unintegrated_0", "unintegrated_1"]. ``groups`` dictionary values from `normalize` and `integrate` config sections. Remember, unless performing multimodal integration, each ``group`` value corresponds to an assay. So in our example from the `normalize` config section, specifying ``unintegrated_0`` and ``unintegrated_1`` would combine the reduced dimensional weights of ``Gene.Expression`` and ``Peaks`` during weighted nearest neighbor clustering.

    ``reduction`` field

        list of strings, default ["pca", "lsi"]. Dimension reduction method used for a specified group. In our example from the `normalize` config section, specifying ``unintegrated_0`` and ``unintegrated_1`` would look for ``Gene.Expression`` reduced dimensions in the ``pca`` slot and ``Peaks`` reduced dimensions in the ``lsi`` slot during weighted nearest neighbor clustering.

    ``umap_dims`` field

        list of integers, default [1, 25, 2, 20]. Dimensions to use for UMAP visualization for a specified group.

    ``resolution`` field

        integer, default [0.8]. Resolution to use during community detection.

    .. note::

        All cells for specified assays/groups **must have identical barcodes**, meaning this rule is currently suitable ONLY for multimodal data. For example 3' Gene Expression + CRISPR barcodes (Perturb-Seq), 3' Gene Expression + Protein barcodes (CITE-Seq), 10X Genomics Multiome (Gene Expression + ATAC), etc.

    Example:

    .. code-block:: yaml

        weighted_nn:
          activate: true
          groups:
            wnn_0:
              neighbor_method: weighted
              input_groups:
              - unintegrated_0      # unintegrated Gene Expression
              - unintegrated_1      # unintegrated ATAC Peaks
              reduction:
              - pca
              - lsi
              umap_dims:
              - - 1
                - 25
              - - 2
                - 20
              resolution: 0.8

Differential Testing
--------------------

``diff_analysis`` config section

    Differential testing (i.e. differential gene expression, chromatin accessibility, TF motifs). This field has 2 sub-fields. This rule calls the Seurat function FindAllMarkers().

    ``activate`` field

        boolean, default false. Specify whether or not to run differential testing.

    ``groups`` field

        dict. Each group to perform differential testing. Group name (key) must be unique.

    ``cluster_idents`` field

        string, default "seurat_clusters". Which Seurat metadata column to use as labels for differential testing. Equivilent to ``obj = SetIdents(cluster_idents), FindAllMarkers(obj).``

    ``assay`` field

        string, default null. Which assay use for differential testing. Equivilent to ``FindAllMarkers(obj, assay = assay).``

    ``slot`` field

        string, default "data". Which assay use for differential testing. Equivilent to ``FindAllMarkers(obj, slot = slot).``

    ``min_pct`` field

        string, default null. Minimum percent to use for differential testing. Equivilent to ``FindAllMarkers(obj, min.pct = min_pct).``

    ``test_use`` field

        string, default null. Test to use for differential testing. Equivilent to ``FindAllMarkers(obj, test.use = test_use).``

    ``latent_vars`` field

        string, default null. Variables to test, used only when test_use is one of 'LR', 'negbinom', 'poisson', or 'MAST'.

    .. note::

        Only include ``group`` values specified in the config sections: `normalize`, `integrate` (if appicable) and `weighted_nn` (if appicable).

    Example:

    .. code-block:: yaml

        diff_analysis:
          activate: true
          groups:
            unintegrated_0:                     # unintegrated Gene Expression
              cluster_idents: seurat_clusters
              assay: null
              slot: data
              min_pct: null
              test_use: null
              latent_vars: null
            unintegrated_1:                     # unintegrated ATAC Peaks
              cluster_idents: seurat_clusters
              assay: null
              slot: data
              min_pct: 0.2
              test_use: 'LR'
              latent_vars: 'nCount_Peaks'
            integrated_0:                       # integrated Gene Expression
              cluster_idents: seurat_clusters
              assay: null
              slot: data
              min_pct: null
              test_use: null
              latent_vars: null

Generate Reports
----------------

Generate final report. 

``guide`` field

    {"build", "render", "etc"}, default "etc". Specify `build` to generate initial version report in reStructured Text format (e.g. guide.rst) from template at "config/template_guide.rst". Specify `render` to generate final html report (i.e. guide.html). Specify `etc` to skip this rule.

    .. note::

        **Before** the workflow completes, set guide value to `etc`. This value will prevent this rule from running until all results have been created.

        **After** the workflow completes, set `guide` to `build` or `render`. This creates the final guide.


Example
-------

A **basic** example of a config.yaml file using 2 multiome batches is below, analyzing all samples with and without integration will be performed, then clustering, and differential testing. This example also includes automated optimization of clustering parameters.

See :ref: `overview-wf` for more detailed examples of config files.

.. code-block:: yaml

    samples: config/samples.tsv

    aggregates: config/aggregates.tsv

    assays: config/assays.tsv

    ANNOTATION: EnsDb
    ANNO_FILE: null

    qc:
      remove_outliers: true
      rm_outliers_method: sd
      meta_labels:
      - nCount_Gene.Expression
      - nCount_Peaks
      - percent.mt
      - TSS.enrichment
      lower: 
        nCount_Gene.Expression: 100
        nCount_Peaks: 1000
        TSS.enrichment: 2
      upper: null

    macs2:
      run: "Y"
      group_fragments_by: genome

    normalize:
      groups:
        unintegrated_0:
          assay_name: Gene.Expression
          norm_method: sct
        unintegrated_1:
          assay_name: Peaks
          norm_method: lsi

    integrate:
      activate: true
      memory_MB: null
      atac_integrate_embeddings: true
      groups:
        integrated_0:
          split_by: meta_batch
          reference:
            label: batch1
            assay_name: Gene.Expression
          query:
            label: batch2
            assay_name: Gene.Expression
          norm_method: sct
          integrate_dims:
          - 1
          - 30

    dataset_size:
      toydataset: true  # true or false
      toy_k: 10   

    coembed:
      activate: false
      reference:
        type: null
        slot_name: null
        norm_method: null
        reduction: null
      query:
        type: null
        slot_name: null
        norm_method: null
        reduction: null

    chooser:
      groups:
        unintegrated_0:
          npcs: 25
        unintegrated_1:
          npcs: 20
        integrated_0:
          npcs: 25
      resolutions:
        - 0.8
        - 1
        - 1.2
        - 1.4
        - 1.6
        - 1.8
        - 2
        - 4
        - 6
        - 8
        - 12
        - 16
      silhouette:
        - silhouette
        - frequency_grouped
        - silhouette_grouped

    cluster:
      resolution: 0.6

    weighted_nn:
      activate: true
      groups:
        wnn_0:
          neighbor_method: weighted
          input_groups:
          - unintegrated_0
          - unintegrated_1
          reduction:
          - pca
          - lsi
          umap_dims:
          - - 1
            - 25
          - - 2
            - 20
          resolution: 0.8

    diff_analysis:
      activate: true
      groups:
        unintegrated_0:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
        unintegrated_1:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: 'LR'
          latent_vars: 'nCount_Peaks'
        integrated_0:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
        wnn_0:
          cluster_idents: seurat_clusters
          assay: SCT
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null

    guide: "etc" # set to "build", "render", or "etc"
