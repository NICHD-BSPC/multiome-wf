#!/bin/bash

# Set bash strict mode
set -eu
IFS=$' '

source multiome_toy_config.sh
# Reference:
# https://support.10xgenomics.com/single-cell-multiome-atac-gex/software/pipelines/latest/output/per_barcode_metrics
# https://timoast.github.io/sinto/basic_usage.html#create-scatac-seq-fragments-file


# Input files:
# 1. per_barcode_metrics.csv
# 2. atac_fragments.tsv
# 3. atac_peaks.bed
# 4. filtered_bc_matrix.h5 -> will be handled in R
#
#
#
# Final output:
# 1. toy_atac.tsv.gz (from atac_fragments.tsv)
# 2. toy_atac.tsv.gz.tbi (from toy_atac.tsv.gz)
# 3. toy_peaks.bed (from atac_peaks.bed calculated by ZINBA)
# 4. toygex_barcodes.txt (for subsetting reads in the filtered_bc_matrix.h5 file)
# 5. toy_barcode.csv (from per_barcode_metrics.csv)

# Create output dir if absent
if [[ ! -e $TOY_OUT ]]
then
    mkdir $TOY_OUT
fi

# Extract header and save as a csv file
awk 'NR == 1' $PER_BARCODE_METRICS > $TOY_BARCODE_CSV

# Explore the number of cells in the dataset
# (indicated by the 4th column. 0 = background, 1=cell)
awk -F "," '$4 == "1"' $PER_BARCODE_METRICS | wc -l # Has to be equal to the number of cells in cellranger summary html

# Extract barcode of every n-th cell
awk -F "," '$4 == "1"' $PER_BARCODE_METRICS | awk -v var=$BARCODE_NTH 'NR % var == 0' >> $TOY_BARCODE_CSV

# comment out (add by chris)
# # Save total valid barcodes to the csv file
# awk -F "," '$4 == "1"' $PER_BARCODE_METRICS >> $TOY_BARCODE_CSV

# Print the first and last few lines
head $TOY_BARCODE_CSV && echo "-------" && tail $TOY_BARCODE_CSV && wc -l $TOY_BARCODE_CSV


# Save reference lines to a new tsv file
grep "#" $ATAC_FRAG > $TOY_ATAC

# Save every n-th atac fragments
grep -v "#" $ATAC_FRAG | awk -v var=$ATAC_NTH 'NR % var == 0' >> $TOY_ATAC
grep -v "#" $ATAC_FRAG | awk -v var=$ATAC_NTH 'NR % var == 0' > $TOY_ATAC_ATAC

# Print the first and last few lines
head $TOY_ATAC && echo "-------" && tail $TOY_ATAC


# Save only the seq names, start, and end data of the toy ATAC fragments as f1.txt
grep -v "#" $TOY_ATAC | cut -f 1-3 > f1.txt

# Save every n-th peak in the original data as f2.txt
grep -v "#" $ATAC_PEAKS | awk -v var=$PEAK_NTH 'NR % var == 0' > f2.txt


# Save reference lines to a new peak bed file
grep "#" $ATAC_PEAKS > $TOY_PEAKS_BED

# Save intersection between f1.txt and f2.txt (and remove)
awk 'NR == FNR' f2.txt f1.txt >> $TOY_PEAKS_BED &&
    awk 'NR == FNR' f2.txt f1.txt > $TOY_PEAKS_PEAKS &&
    rm f1.txt f2.txt

# Explore the output
head $TOY_PEAKS_BED && echo "----------" && tail $TOY_PEAKS_BED && echo "----------"
wc -l $ATAC_FRAG && wc -l $TOY_ATAC && echo "----------"
wc -l $ATAC_PEAKS && wc -l $TOY_PEAKS_BED

# Save toy gex barcodes in a txt file
# (4th column = cell barcode = GEX barcode)
grep -v "#" $TOY_ATAC | cut -f 4 | uniq > $TOYGEX_BARCODES

# Block-compress the toy atac fragment (has to be BED format)
bgzip < $TOY_ATAC > $TOY_ATAC.gz

# Create a tabix file from the block-compressed toy atac fragments
tabix -p bed --zero-based --force --begin 2 --end 3 $TOY_ATAC.gz


Rscript GEX.R
