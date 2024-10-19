#!/bin/bash

SAVE_IN="tenx_input"

if [[ ! -e $SAVE_IN ]]
then
    mkdir $SAVE_IN
fi


wget https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/pbmc_granulocyte_sorted_3k_per_barcode_metrics.csv -O $SAVE_IN/per_barcode_metrics.csv
wget https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/pbmc_granulocyte_sorted_3k_filtered_feature_bc_matrix.h5 -O $SAVE_IN/filtered_bc_matrix.h5
wget https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/pbmc_granulocyte_sorted_3k_atac_fragments.tsv.gz -O $SAVE_IN/atac_fragments.tsv.gz && gzip -d $SAVE_IN/atac_fragments.tsv.gz
wget https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/pbmc_granulocyte_sorted_3k_atac_fragments.tsv.gz.tbi -O $SAVE_IN/atac_fragments.tsv.gz.tbi
wget https://cf.10xgenomics.com/samples/cell-arc/2.0.0/pbmc_granulocyte_sorted_3k/pbmc_granulocyte_sorted_3k_atac_peaks.bed -O $SAVE_IN/atac_peaks.bed


