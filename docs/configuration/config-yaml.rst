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


These rules have discrete sections in the ``config.yaml`` where users configure the 
execution of each rule. Refer to the following instruction to activate or inactivate 
each rule:

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
variant (a modality for RNA in multiome). This group's dictionary contains additional 
fields which together define the groups' analysis options: ``assay_name``, and 
``norm_method``.

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
    ``diff_analysis`` contains 2 group key names, ``unintegrated_0`` and ``integrated_0``, 
    if you are not performing Seurat integration by setting the ``activate`` key to ``false`` 
    in the ``integrate`` section, delete the ``integrated_*`` group in the rest of the 
    sections. If their are superflous groups in the ``config.yaml``, Snakemake will add 
    extra, unwanted rules/jobs when building a DAG.


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

    string of ``"EnsDb"`` or ``"GTF"``, default ``"EnsDb"``. Defines the method 
    to build an annotation object (``GenomicRanges``) for scATAC-seq and multiome 
    analyses.

    - ``"EnsDb"`` uses the ``EnsDb.Mmusculus.v79`` (mouse mm10) or 
      ``EnsDb.Hsapiens.v86`` (human hg38) package in R
    - ``"GTF"`` uses a user-provided annotation file 

``ANNO_FILE`` field
^^^^^^^^^^^^^^^^^^^

    string, default ``"path/to/genes.gtf.gz"``. If ``"GTF"`` is specified in the 
    ``ANNOTATION`` field, provide the path to your annotation file (e.g. 
    ``genes.gtf.gz``). 
    This field is disregarded if the ``ANNOTATION`` field is set to ``"EnsDb"``.

Quality Control (``qc`` section)
--------------------------------

``remove_outliers`` field
^^^^^^^^^^^^^^^^^^^^^^^^^

    boolean, default ``true``. Specify whether or not to run ``qc`` rule.

``rm_outliers_method`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    string of ``"sd"`` or  ``"iqr"``, default ``"sd"``. Detect outliers using either 
    standard deviation (``"sd"``), or Tukey's interquartile range (``"iqr"``). 
    If set to ``"sd"``, the thresholds are determined based on +/- 3 standard 
    deviations.

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

    - 10X Genomics ATAC and multiome kits use nuclei, so reads will not map to 
      mitochondria. However, the workflow imputes a value of 0 for ``percent.mt`` 
      in these assays, since missing values are not generally allowed in the underlying 
      packages. This will not effect downstream processes such as normalization, 
      dimensional reduction, clustering, etc.



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

.. _macs-peakcalling:

MACS Peak Calling (``macs2`` section)
-------------------------------------

MACS specific parameters.

``run`` field
^^^^^^^^^^^^^

    string of ``"Y"`` or  ``"N"``, default ``"Y"``. Determine whether or not to run 
    MACS. Set to ``"N"`` for RNA-seq. Set to ``"Y"`` for ATAC and multiome requiring 
    MACS peak calling. If you don’t run MACS, delete analysis groups where 
    ``assay_name`` corresponds to ``MACS`` in the remaining sections/fields 
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

Normalization and Principal Component Analysis (PCA).

.. _split-by:

``split_by`` field
^^^^^^^^^^^^^^^^^^

    string. A metadata column in ``samples.tsv`` or ``aggregates.tsv``. Datasets 
    will be normalized, and dimensionality reduction using PCA will be performed 
    on each dataset, split by this column. Note that Seurat integration will be 
    performed based on the metadata column specified by ``split_by`` here and
    in the ``integrate`` section.

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform normalization. Group name (key) must be unique.
    Do not modify the prefix (e.g. ``unintegrated`` and ``integrated``) unless
    under special circumstances.

``assay_name`` field
^^^^^^^^^^^^^^^^^^^^

    string of ``Gene.Expression``, ``Multiplexing.Capture``, ``Peaks``, 
    ``Gene.Activity``, or ``MACS``. Which Seurat assay to use. Note that Seurat 
    assay names are "." delimited.

.. _norm-method:

``norm_method`` field
^^^^^^^^^^^^^^^^^^^^^

    string of ``log``, ``sct``, ``clr`` or ``lsi``, default is the following:

    - ``Gene.Expression``: ``sct``
    - ``Peaks``: ``lsi``
    - ``MACS``: ``lsi``
    - ``Gene.Activity``: ``log``
    - ``protein``: ``clr`` 

    Method to normalize the group's assay. Normalize using Log (``log``), SCTransform 
    (``sct``), Centered log ratio (``clr``) or latent semantic indexing (``lsi``). 
    Typically, 5' or 3' Gene expression is normalized using Log or SCTransform methods, 
    ATAC Peaks using LSI, and protein using CLR.

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



Integration (``integrate`` section)
-----------------------------------


Remove technical/batch effects using `Seurat integration 
<https://satijalab.org/seurat/articles/integration_introduction>`_ methods. 
Integration rule will create a new Seurat object for each integration performed. 

``activate`` field
^^^^^^^^^^^^^^^^^^

    boolean, default ``true``. Specify whether or not to run integration.

``atac_integrate_embeddings`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    boolean, default ``true``. If ``true``, integrate low-dimensional cell embeddings 
    (LSI coordinates) across the datasets. This is the best option for integrating 
    multiple ATAC Peaks data sets. If ``false``, integrate (transform) ATAC Peaks counts 
    matrix across datasets (not LSI coordinates). This may over fit. Kept mainly 
    for legacy support.



``split_by`` field
^^^^^^^^^^^^^^^^^^

    string. A metadata column in ``samples.tsv`` or ``aggregates.tsv``. Datasets 
    are integrated based on this column. Ensure the same column is specified as in 
    the :ref:`split-by` of the ``normalize`` section above.

    See :ref:`samples-table` for more details about how metadata columns are detected.

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform integration. Group name (key) must be unique.

``assay_name`` field
^^^^^^^^^^^^^^^^^^^^

    string of ``Gene.Expression``, ``Multiplexing.Capture``, ``Peaks``, 
    ``Gene.Activity``, or ``MACS``. Ensure the same values are specified as in the
    ``normalize`` section above.

``norm_method`` field
^^^^^^^^^^^^^^^^^^^^^

    string of ``log``, ``sct``, ``clr`` or ``lsi``. Ensure the same values are 
    specified as in the :ref:`norm-method` of the ``normalized`` section above.

``integrate_method`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^
    string of ``CCAIntegration``, ``RPCAIntegration``, ``HarmonyIntegration``, 
    ``FastMNNIntegration``, ``scVIIntegration``, or ``rlsi``. Method to integrate 
    unimodal datasets. For any datasets where ``norm_method`` is set to ``log`` or
    ``sct``, this string is passed into the ``method`` argument of the
    ``IntegrateLayers`` function of `Seurat 
    <https://satijalab.org/seurat/reference/integratelayers>`_. If the ``norm_method``
    is set to ``lsi``, set the ``integrate_method`` to ``rlsi`` to call the 
    ``IntegrateEmbeddings`` function, as provided in `Signac
    <https://stuartlab.org/signac/articles/integrate_atac#integration>`_.

``integrate_dims`` field
^^^^^^^^^^^^^^^^^^^^^^^^

    list of 2 integers, default ``[1, 30]``. Range of dimensions to use for 
    integration step.

Example:

.. code-block:: yaml

    integrate:
      activate: true
      atac_integrate_embeddings: true
      split_by: meta_geno # this has to match the column name of your metadata indicating datasets for integrati
      groups:
        integrated_0:
          assay_name: Gene.Expression
          norm_method: sct
          integrate_method: CCAIntegration  # RPCAIntegration, HarmonyIntegration, FastMNNIntegration, scVIIntegration
          integrate_dims:
            - 1
            - 30
        integrated_1:
          assay_name: Peaks
          norm_method: lsi
          integrate_method: rlsi
          integrate_dims:
            - 1
            - 30
        integrated_2:
          assay_name: MACS
          norm_method: lsi
          integrate_dims:
            - 1
            - 30
        integrated_3:
          assay_name: Gene.Activity
          norm_method: log
          integrate_method: CCAIntegration
          integrate_dims:
            - 1
            - 30


Utilization of Toy Dataset (``dataset_size`` config section)
------------------------------------------------------------

Assign the utilization of toy dataset. Users can take advantage
of this functionality for technical purposes such as debugging.
If dataset size is smaller than default k values in kNN computation 
during integration, Seurat throws an error. 


``toydataset`` field
^^^^^^^^^^^^^^^^^^^^
    
    boolean, default ``false``. if ``true``, the computation is adjusted 
    to handle toy datasets. if ``false``, the input datasets are considered
    as normal datasets.

``toy_k`` field
^^^^^^^^^^^^^^^

    integer, number of neighbors used when weighting anchors.
    This value is passed to the ``k.weight`` argument in the
    ``IntegrateLayers`` function during integration.

Example:

.. code-block:: yaml

    dataset_size:
      toydataset: false
        toy_k: 10


Cluster Optimization (``chooser`` config section)
-------------------------------------------------

Users can optimize clustering modularity using `ChooseR 
<https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-021-03957-4>`_
with pipeline-specific modifications. This functionality is enabled only if
the ``resolution`` field in the ``cluster`` section is set to ``null``.

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform clustering parameter optimization. 
    Group name (key) must be unique. All groups in the ``normalize`` and
    ``integrate`` (if applicable) sections can be assigned.

``npcs`` field
^^^^^^^^^^^^^^

    integer, default values:

    - ``Gene.Expression``: 25
    - ``Peaks``, ``MACS``, or ``Gene.Activity``: 20

    The maximum number of linear reduced dimensions, computed from LSI 
    or PCA, that are used during clustering. 

``resolutions`` field
^^^^^^^^^^^^^^^^^^^^^

    list of integers, default ``[0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2]``. 
    Resolutions to use when bootstrapping cluster methods. Best to have 
    a range spanning target resolution.

``silhouette`` field
^^^^^^^^^^^^^^^^^^^^

    list of strings. default ``silhouette``, ``frequency_grouped``, 
    and ``silhouette_grouped``. Values are used during path parameter 
    expansion in rules executing chooseR. It is advisable to not alter
    them.

.. note::

    All ``groups`` values specified in the config sections: 
    ``normalize`` and ``integrate`` (if appicable) **must** have 
    a group entry in the ``chooser`` config section.

Example:

.. code-block:: yaml

    chooser:
      groups:
        unintegrated_0:
          npcs: 25
        unintegrated_1:
          npcs: 20
        unintegrated_2:
          npcs: 20
        unintegrated_3:
          npcs: 20
        integrated_0:
          npcs: 25
        integrated_1:
          npcs: 20
        integrated_2:
          npcs: 20
        integrated_3:
          npcs: 20
      resolutions:
        - 0.6
        - 0.8
        - 1.0
        - 1.2
        - 1.4
        - 1.6
        - 1.8
        - 2.0
      silhouette:
        - silhouette
        - frequency_grouped
        - silhouette_grouped




Clustering (``cluster`` config section)
---------------------------------------

Users can determine a specific resolution for clustering or
or rely on a dataset-optimized resolution computed using ``chooser``.

.. _detection-method:

``detection_method`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^

    integer, default ``3``. Algorithm used for community detection during 
    unimodal clustering. Available options are:

    - ``1``: original Louvain algorithm
    - ``2``: Louvain algorithm with multilevel refinement
    - ``3``: SLM algorithm
    - ``4``: Leiden algorithm (requires the leidenalg python)

    This value is passed to the ``algorithm`` argument of the ``FindClusters`` function. 
    Refer to Seurat `Cluster Determination <https://satijalab.org/seurat/reference/findclusters>`_ 
    for more details.



``resolution`` field
^^^^^^^^^^^^^^^^^^^^

    float or ``null``, default ``null``. If ``null``, clustering is performed
    using an optimized resolution computed by ``chooser``.

Example:

.. code-block:: yaml

    cluster:
      detection_method: 3
      resolution: null

Weighted Nearest Neighbor (``weighted_nn`` config section)
----------------------------------------------------------

This section configures how to perform `Weighted Nearest Neighbor (WNN) analysis
<https://satijalab.org/seurat/articles/weighted_nearest_neighbor_analysis#wnn-analysis-of-10x-multiome-rna-atac>`_. 
WNN is similar to shared nearest neighbor (SNN), which is commonly used to build 
graphs for multiple modalities. WNN uses a list of weights from each specified modality, 
and is useful for incorporating low dimensional embeddings from multiple single cell 
modalities into a global reduced dimensional space. 


.. note::

    - All cells for specified assays/groups **must have identical barcodes**, meaning this 
      rule is currently suitable ONLY for multimodal data. For example 3' Gene Expression + 
      CRISPR barcodes (Perturb-Seq), 3' Gene Expression + 
      Protein barcodes (CITE-Seq), 10X Genomics Multiome (Gene Expression + ATAC), etc.

    - Disable this functionality if the input dataset is not multimodal.

``activate`` field
^^^^^^^^^^^^^^^^^^

    boolean, default ``true`` (multiome) or ``false`` (RNA/ATAC). Specify whether or not 
    to run the coembed rule.

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform weighted nearest neighbor analysis. Group name (key) must be 
    unique.

``input_groups`` field
^^^^^^^^^^^^^^^^^^^^^^

    list of strings, default:

    - ``wnn_0``: ``unintegrated_0`` and ``unintegrated_1``
    - ``wnn_1``: ``integrated_0`` and ``integrated_1``

    ``groups`` dictionary values from ``normalize`` and ``integrate`` config sections. Remember, 
    unless performing multimodal integration, each ``group`` value corresponds to an assay. So in our 
    example from the ``normalize`` config section, specifying ``unintegrated_0`` and ``unintegrated_1`` 
    would combine the reduced dimensional weights of ``Gene.Expression`` and ``Peaks`` during WNN 
    clustering.

``reduction`` field
^^^^^^^^^^^^^^^^^^^

    list of strings, default ``pca`` and ``lsi``. Dimensionality reduction method used for a specified 
    group. In our example from the ``normalize`` config section, specifying ``unintegrated_0`` and 
    ``unintegrated_1`` would look for ``Gene.Expression`` reduced dimensions in the ``pca`` slot and 
    ``Peaks`` reduced dimensions in the ``lsi`` slot during WNN clustering.

``umap_dims`` field
^^^^^^^^^^^^^^^^^^^

    list of integers, default ``[[1, 25], [2, 20]]``. 
    Dimensions to use for UMAP visualization for a specified group.

``resolution`` field
^^^^^^^^^^^^^^^^^^^^

    integer, default ``0.6``. Resolution to use during community detection
    for multimodal clustering.

``detection_method`` field
^^^^^^^^^^^^^^^^^^^^^^^^^^

    integer, default ``3``. Algorithm used for community detection during 
    multimodal clustering. Refer to the :ref:`detection-method` in
    the ``cluster`` section above.

Example:

.. code-block:: yaml

    weighted_nn:
      activate: true
      groups:
        wnn_0:
          input_groups:
            - unintegrated_0 # corresponds to SCT
            - unintegrated_1 # corresponds to Peaks
          reduction:
            - pca
            - lsi
          umap_dims:
            - - 1
              - 25
            - - 1
              - 20
          resolution: 0.6
          detection_method: 3
        wnn_1:
          input_groups:
            - integrated_0 # corresponds to SCT
            - integrated_1 # corresponds to Peaks
          reduction:
            - integrated_pca
            - integrated_lsi
          umap_dims:
            - - 1
              - 25
            - - 1
              - 20
          resolution: 0.6
          detection_method: 3

Differential Testing (``diff_analysis`` config section)
-------------------------------------------------------

This section configures differential testing (i.e. differential gene expression, 
chromatin accessibility, TF motifs) using the ``FindAllMarkers`` function in Seurat.

``activate`` field
^^^^^^^^^^^^^^^^^^

    boolean, default ``true``. Specify whether or not to run differential testing.

``groups`` field
^^^^^^^^^^^^^^^^

    dict. Each group to perform differential testing. Group name (key) must be unique.

``cluster_idents`` field
^^^^^^^^^^^^^^^^^^^^^^^^

    string, default ``seurat_clusters``. Which Seurat metadata column to use as labels 
    for differential testing. Equivalent to ``obj <- SetIdents(cluster_idents)`` before
    running ``FindAllMarkers(obj)``.

``assay`` field
^^^^^^^^^^^^^^^

    string, default ``null``. Which assay use for differential testing. This value is
    passed to the ``assay`` argument of the ``FindAllMarkers`` function.

``slot`` field
^^^^^^^^^^^^^^

    string, default ``data``. Which slot to pull data from. This value is passed to the 
    ``slot`` argument of the ``FindAllMarkers`` function.


``min_pct`` field
^^^^^^^^^^^^^^^^^

    string, default ``null``. Only test genes that are detected in a minimum fraction
    of cells in either of the two populations. If ``null``, a default value of 0.01 is 
    applied. This value is passed to the ``min.pct`` argument of the ``FindAllMarkers`` 
    function.

``test_use`` field
^^^^^^^^^^^^^^^^^^

    string, default ``null``. Test used for differential testing. This value is passed
    to the ``test.use`` argument of the ``FindAllMarkers`` function. If ``null``, the
    `Wilcoxon Rank Sum test <https://en.wikipedia.org/wiki/Mann%E2%80%93Whitney_U_test>`_
    is used by default. Available methods are:

    - ``wilcox``: Wilcoxon Rank Sum test
    - ``wilcox_limma``: Limma implementation of the Wilcoxon Rank Sum test
      (Use this to reproduce results from Seurat v4)
    - ``bimod``: Likelihood-ratio test
    - ``roc``: ROC analysis
    - ``t``: Student's t-test
    - ``negbinom``: Negative binomial generalized linear model
    - ``poisson``: Poisson generalized linear model
    - ``LR``: Logistic regression model
    - ``MAST``: `MAST <https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0844-5>`_
      framework. 
    - ``DESeq2``: `DESeq2 <https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8>`_ 
      framework. (requires to install DESeq2 package in R)


For more details, refer to the `FindAllMarkers <https://satijalab.org/seurat/reference/findallmarkers>`_ 
function in Seurat.

``latent_vars`` field
^^^^^^^^^^^^^^^^^^^^^

    string, default ``null``. Variables to test, used only when ``test_use`` is 
    one of ``LR``, ``negbinom``, ``poisson``, or ``MAST``. This value is passed 
    to the ``latent.vars`` argument of the ``FindAllMarkers`` function.

``alpha`` field
^^^^^^^^^^^^^^^

    float, default 0.05. False discovery rate (FDR) threshold to filter significant marker genes.

.. note::

    Only include ``groups`` values specified in the config sections: ``normalize``, 
    ``integrate`` (if appicable) and ``weighted_nn`` (if appicable).

.. warning::

    For the current version of `multiome-wf`, ``LR`` has a bug where it grabs more
    nodes than allocated on a cluster node. Do not use ``LR`` on a cluster node.

Example:

.. code-block:: yaml

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
          alpha: 0.05
        unintegrated_1:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_Peaks'
          alpha: 0.05
        unintegrated_2:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_MACS'
          alpha: 0.05
        integrated_0:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05
        integrated_1:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_Peaks'
          alpha: 0.05
        wnn_0:
          cluster_idents: seurat_clusters
          assay: SCT
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05
        wnn_1:
          cluster_idents: seurat_clusters
          assay: SCT
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05


Example
~~~~~~~

A **basic** example of a ``config.yaml`` file using 2 multiome batches is provided below. 
The analysis will be performed on all samples with and without integration, followed by 
clustering and differential testing. This example also includes automated optimization 
of clustering parameters.

See :ref:`overview-wf` for more detailed examples of config files.

.. code-block:: yaml

    # Paths to sample tables
    samples: config/multiome-config/samples.tsv
    aggregates: config/multiome-config/aggregates.tsv
    assays: config/multiome-config/assays.tsv

    # Annotation
    ANNOTATION: "EnsDb"
    ANNO_FILE: "path/to/gene.gtf.gz"

    # QC
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


    # MACS2 peak calling
    macs2:
      run: "Y"
      group_fragments_by: genome

    # Normalization
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

    # Integration
    integrate:
      activate: true
      atac_integrate_embeddings: true
      split_by: meta_geno
      groups:
        integrated_0:
          assay_name: Gene.Expression
          norm_method: sct
          integrate_method: CCAIntegration
          integrate_dims:
            - 1
            - 30
        integrated_1:
          assay_name: Peaks
          norm_method: lsi
          integrate_method: rlsi
          integrate_dims:
            - 1
            - 30
        integrated_2:
          assay_name: MACS
          norm_method: lsi
          integrate_method: rlsi
          integrate_dims:
            - 1
            - 30
        integrated_3:
          assay_name: Gene.Activity
          norm_method: log
          integrate_method: CCAIntegration
          integrate_dims:
            - 1
            - 30

    # Toy dataset utilization
    dataset_size:
      toydataset: false
      toy_k: 10

    # Cluster optimization
    chooser:
      groups:
        unintegrated_0:
          npcs: 25
        unintegrated_1:
          npcs: 20
        unintegrated_2:
          npcs: 20
        unintegrated_3:
          npcs: 20
        integrated_0:
          npcs: 25
        integrated_1:
          npcs: 20
        integrated_2:
          npcs: 20
        integrated_3:
          npcs: 20
      resolutions:
        - 0.6
        - 0.8
      silhouette:
        - silhouette
        - frequency_grouped
        - silhouette_grouped

    # Clustering
    cluster:
      detection_method: 3
      resolution: null

    # Multimodal embedding
    weighted_nn:
      activate: true
      groups:
        wnn_0:
          input_groups:
            - unintegrated_0
            - unintegrated_1
          reduction:
            - pca
            - lsi
          umap_dims:
            - - 1
              - 25
            - - 1
              - 20
          resolution: 0.6
          detection_method: 3
        wnn_1:
          input_groups:
            - integrated_0
            - integrated_1
          reduction:
            - integrated_pca
            - integrated_lsi
          umap_dims:
            - - 1
              - 25
            - - 1
              - 20
          resolution: 0.6
          detection_method: 3

    # Differential testing
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
          alpha: 0.05
        unintegrated_1:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_Peaks'
          alpha: 0.05
        unintegrated_2:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_MACS'
          alpha: 0.05
        unintegrated_3:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: 'Gene.Activity'
          alpha: 0.05
        integrated_0:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05
        integrated_1:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_Peaks'
          alpha: 0.05
        integrated_2:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: 0.2
          test_use: null
          latent_vars: 'nCount_MACS'
          alpha: 0.05
        integrated_3:
          cluster_idents: seurat_clusters
          assay: null
          slot: data
          min_pct: null
          test_use: null
          latent_vars: 'Gene.Activity'
          alpha: 0.05
        wnn_0:
          cluster_idents: seurat_clusters
          assay: SCT
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05
        wnn_1:
          cluster_idents: seurat_clusters
          assay: SCT
          slot: data
          min_pct: null
          test_use: null
          latent_vars: null
          alpha: 0.05


