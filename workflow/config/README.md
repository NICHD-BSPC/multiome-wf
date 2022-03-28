README.MD

All unused entries in samples.tsv or units.tsv are left empty.

samples.tsv:
  - sample: unique accession/ID. Letters/numbers, no spaces, underscores, dashes or other symbols
  - feature_type:
  		'Gene Expression': Gene expression
  		'Peaks': ATAC
  - feature_bc_matrix_h5: absolute path to hdf5 file in outs/ directory from cellranger count, cellranger aggr, cellranger-atac count, cellranger-atac aggr. If present, this file will be prioritized as input over any filtered_feature_bc_matrix paths 
  - feature_bc_matrix_dir: comma separated string of absolute paths to filtered_feature_bc_matrix directories in outs/ directory from cellranger count, cellranger aggr, cellranger-atac count, cellranger-atac aggr. Example: 'outs/filtered_peak_bc_matrix,outs/filtered_tf_bc_matrix'
  - fragments: fragments file in outs/ directory from cellranger-atac count, cellranger-atac aggr
  - singlecell: singlecell.csv file in outs/ directory from cellranger-atac count, cellranger-atac aggr

units.tsv:
  - sample: unique accession/ID. Letters/numbers, no spaces, underscores, dashes or other symbols
  - unit:
  		1: barcode suffix from cellranger count or cellranger-atac counts
  		[0-9]+: barcode suffix corresponding to library_id in libraries.csv file for input to cellranger aggr and cellranger-atac aggr
  - library_id:
  		library ID corresponding to barcode suffix
  - batch_effect: library batch. Cellranger aggr and cellranger-atac aggr can contain barcodes from multiple batches
