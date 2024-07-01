.. _config-yaml:

Config YAML
===========

This page details the various configuration options and describes how to
configure a new workflow.

Config files are expected to be in a ``config`` directory next to the the Snakefile. 
For example, ``config/config.yaml``. Be sure to update the path to the ``config.yaml`` in the Snakefile and/or WRAPPER_SLURM files.

While it is possible to use Snakemake mechanisms such as ``--config`` to
override a particular config value and ``--configfile`` to update the config
with a different file, it is easiest to edit the existing
``config/config.yaml`` in place. This has the additional benefit of reproducibity
because all of the config information is stored in one place.

The config file uses YAML format, which can be conceptualized as a set of nested key:value pairs. When running the workflow, the YAML document is parsed into a python dictionary.

By specifying values in various setions of the config.yaml, the workflow automatically
decides to run analysis variants suitable for scRNA-Seq, scATAC-Seq, or multi-modal
experiments. With this in mind, there are 2 important points to keep in mind when
creating a config.yaml.

1. Activating Rules
-------------------

Many workflow rules are optional. These rules have a discrete sections in
the config.yaml. For example, to integrate samples to remove batch effects, there is
a section in the config.yaml ``integrate``.

If a rule is optional, it will have a key named ``activate`` or ``run``.

To specify which optional rules will be included in the analysis, 
set ``activate`` to ``true`` or ``false``, or set ``run`` to ``Y`` or ``N``.

2. Analysis Groups
------------------

Because of the myriad variants for single cell analysis and preprocessing, it is not
possible to hard-code all the configuration options in the config.yaml file. Instead,
we include analysis "group names" in many sections. These rules will have a field named ``group``.
Each ``group`` must contain a nested dictionary for each analysis variant.

To configure these sections, the user must specify the top-level dictionary key value.
All other keys are hard-coded as options.

Using the config.yaml's ``integrate`` section as an example, we see a single analysis 
group below. The group value, ``integrated_0``, is itself a dictionary key for this analysis
variant (integrating RNA batches). This group's dictionary contains additional fields
which together define the groups' analysis options: ``split_by``, ``reference``, ``query``, 
``norm_method``, and ``integrate_dims``.

.. code-block:: yaml

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

Keep in mind that the ``group`` key values are arbitrary. In the example above, it would be
acceptable to replace the ``group`` key label with something more intuitive like the assay
name being integrated: ``group: Gene.Expression`` or ``group: RNA``. This works well for 
groups that have a single assay. However, in multi-modal analyses, using an assay or sample
name as a ``group`` key quickly becomes cumbersome and uninformative. As a result, in the 
following examples we will use ``unintegrated_*`` or ``integrated_*`` keys but feel free to change these.

.. note::

    It is possible to specify more analysis groups than the number of assays in your data.
    **Do not** specify analysis groups unless your experiment setup supports the condition.

    For example, in the example config.yaml file, the differential analysis section,
    ``diff_analysis`` contains 2 group key names, ``unintegrated_0`` and ``integrated_0``, if
    you are not performing Seurat integration (e.g. if config.yaml['integrate']['activate']: false),
    delete the ``integrated`` group. If their are superflous groups in the config.yaml,
    Snakemake will add extra, unwanted rules/jobs when building a DAG.


Field descriptions
------------------

Config Tables
^^^^^^^^^^^^^

``samples`` field

    string, default "config/aggregates.tsv". Defines path to samples table.

    See :ref:`samples-table` for more.

    Example:

    .. code-block:: yaml

        samples: "config/samples.tsv"

``aggregates`` field

    string, default "config/aggregates.tsv". Defines path to aggregates table.

    If an input file is the result of ``cellranger aggr`` (e.g. barcode suffixes map to a library ID), specify path to aggregates.tsv. Otherwise, set to empty string, "".

    See :ref:`aggregates-table` for more.

    Example:

    .. code-block:: yaml

        assays: "config/aggregates.tsv"

``assays`` field

    string, default "config/assays.tsv". Defines path to assays table.

    If using custom counts matrices, specify path to assays.tsv. Otherwise, set to empty string, "".

    See :ref:`assays-table` for more.

    Example:

    .. code-block:: yaml

        assays: "config/assays.tsv"

Annotation
^^^^^^^^^^

``ANNOTATION`` field

    {"EnsDb", "GTF"}, default "EnsDb". Defines method to annotate genomic ranges objects used in ATAC and Multiome (Gene Expression + ATAC) analyses.

``ANNO_FILE`` field

    string, default null. If ``GTF`` is specified in ``ANNOTATION``, provide path to annotation file, otherwise null.

Quality Control
^^^^^^^^^^^^^^^

``qc`` config section

    Feature based QC filtering of cells. This field has 5 sub-fields. 

    ``remove_outliers`` field

        boolean, default true. Specify whether or not to run qc rule.

    ``rm_outliers_method`` field

        {"sd", "iqr"}, default "sd". Detect outliers using standard deviation (sd), or Tukey's interquartile range (iqr).

    ``meta_labels`` field

        list. Which metadata columns to use for filtering?

        See :ref:`samples-table` for more details about how metadata columns are detected. If a value is specified in this field, but is not present in the data, it will be skipped during filtering.
   
    ``lower`` field

        dict. Key:value pairs of metadata column and associated lower limit for cutoff, below which exclude cells.
        If specified, overrides lower limit detected by outlier method for associated metadata columns in "meta_labels".
        If null, outlier method tries to remove cells automatically

    ``upper`` field

        dict. Key:value pairs of metadata column and associated upper limit for cutoff, above which exclude cells.
        If specified, overrides lower limit detected by outlier method for associated metadata columns in "meta_labels".
        If null, outlier method tries to remove cells automatically

    .. note::

        In the example below, 3 metadata columns are specified. 2 have hard cut-offs ("nCount_Gene.Expression" and "TSS.enrichment"), 1 detects lower outliers automatically ("percent.mt").

    .. note::

        10X Genomics ATAC and multiome kits use nuclei, so reads will not map to mitochondria. However, the workflow imputes a value of 0 for "percent.mt" in these assays, since missing values are not generally allowed in the underlying packages. This will not effect downstream processes such as normalization, dimensional reduction, clustering, etc.

    Example:

    .. code-block:: yaml

        qc:
          activate: true
          rm_outliers_method: sd
          meta_labels:
          - nCount_Gene.Expression
          - percent.mt
          - TSS.enrichment
          lower: 
            nCount_Gene.Expression: 100
            TSS.enrichment: 2
          upper: null

MACS
^^^^

``macs2`` config section

    MACS specific parameters. This field has 2 sub-fields.

    ``run`` field

        {"Y", "N"}, default "Y". Determine whether or not to run macs2.

        Set to "N" for RNA-seq. Set to "Y" for ATAC and Multiome requiring MACS peak calling.

    ``group_fragments_by`` field

        string, default "genome". Samples.tsv metadata column to generate fragments file. All labels in the specified column must have the same value. This forces generation of a single fragments file for MACS peak calling.

    Example:

    .. code-block:: yaml

        macs2:
          run: "Y"
          group_fragments_by: genome

Normalization
^^^^^^^^^^^^^

``normalize`` config section

    Normalization and linear reduction. This field has 3 sub-fields.

    ``groups`` field

    dict. Each group to perform normalization. Group name (key) must be unique.

    ``assay_name`` field

    {"Gene.Expression", "Multiplexing.Capture", "Peaks", "Gene.Activity", "MACS"}. Which Seurat assay to use. Note: Seurat assay names are '.' delimited.

    ``norm_method`` field

    {"log", "sct", "clr" or "lsi"}, defaul {Gene.Expression: sct, Peaks: lsi, MACS: lsi, Gene.Activity: log, protein: clr}. Method to normalize the group's assay. Normalize using Log (log), SCTransform (sct), CLR (clr) or latent semantic indexing (lsi). Suggestions include: 5' or 3' Gene expression are typically normalized by Log or SCTransform methods, ATAC Peaks by LSI, and protein by CLR.

    Example:

    .. code-block:: yaml

        normalize:
          groups:
            unintegrated_0:
              assay_name: Gene.Expression
              norm_method: sct
            unintegrated_1:
              assay_name: Peaks
              norm_method: lsi

Integration
^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^

``coembed`` config section

    Integrate single assay 5' or 3' Gene Expression and single assay ATAC data into a common reduced dimensional space. This field has X sub-fields. This is the preferred method to integrate Gene Expression and ATAC data; the standard Seurat integration methods tend to over fit the disparate RNA and ATAC assays. 

    ``activate`` field

        boolean, default false. Specify whether or not to run the coembed rule.

    .. note::

        This rule is unfinished. Config fields and suggested values have intentionally been omitted. Until this documentation is updated, keep the activate field set to false.

Cluster Optimization
^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^

``cluster`` config section
    
    Set the clustering resolution.

    ``resolution``

        float, set the clustering resolution manually. If set to ``null``, the resolution is determined through the optimization using the ``chooser``.

    Example:

    .. code-block:: yaml

        cluster:
            resolution: 0.6

Weighted Nearest Neighbor
^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^

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
