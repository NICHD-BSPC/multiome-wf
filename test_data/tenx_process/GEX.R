
# Reference:
# 1. https://www.r-bloggers.com/2020/03/what-is-a-dgcmatrix-object-made-of-sparse-matrix-format-in-r
# 2. https://www.bioconductor.org/packages/release/bioc/vignettes/rhdf5/inst/doc/rhdf5.html
# This script is designed to generate toy dataset (see input/output file names in GEX_config.R)



library(rhdf5)
library(tidyverse)
library(data.table)
library(Seurat)
library(Matrix)


# Source variables and paths
source("GEX_config.R")

########## Import HDF5 matrix

# Import hdf5 file using Seurat package
counts <- Read10X_h5(path.hdf5)

# Explore the data
str(counts)

# Expected output
#
# > str(counts)
# List of 2
# $ Gene Expression:Formal class 'dgCMatrix' [package "Matrix"] with 6 slots
#  .. ..@ i       : int [1:5218473] 16 30 43 44 73 83 86 97 104 170 ...
#  .. ..@ p       : int [1:2712] 0 2272 5526 7324 8469 9964 11306 13895 16280 19289 ...
#  .. ..@ Dim     : int [1:2] 36601 2711
#  .. ..@ Dimnames:List of 2
#  .. .. ..$ : chr [1:36601] "MIR1302-2HG" "FAM138A" "OR4F5" "AL627309.1" ...
#  .. .. ..$ : chr [1:2711] "AAACAGCCAAATATCC-1" "AAACAGCCAGGAACTG-1" "AAACAGCCAGGCTTCG-1" "AAACCAACACCTGCTC-1" ...
#  .. ..@ x       : num [1:5218473] 1 2 1 1 1 1 1 1 1 3 ...
#  .. ..@ factors : list()
# $ Peaks          :Formal class 'dgCMatrix' [package "Matrix"] with 6 slots
#  .. ..@ i       : int [1:19292713] 13 36 43 47 48 66 72 75 79 80 ...
#  .. ..@ p       : int [1:2712] 0 5415 14987 24446 31080 38187 45565 51219 56431 70199 ...
#  .. ..@ Dim     : int [1:2] 98319 2711
#  .. ..@ Dimnames:List of 2
#  .. .. ..$ : chr [1:98319] "chr1:9768-10660" "chr1:180582-181297" "chr1:181404-181887" "chr1:191175-192089" ...
#  .. .. ..$ : chr [1:2711] "AAACAGCCAAATATCC-1" "AAACAGCCAGGAACTG-1" "AAACAGCCAGGCTTCG-1" "AAACCAACACCTGCTC-1" ...
#  .. ..@ x       : num [1:19292713] 2 2 2 4 2 2 6 2 3 2 ...
#  .. ..@ factors : list()

# Dimnames[[1]] = rows (genes or peaks)
# Dimnames[[2]] = columns (barcodes)
# Have to match output of as.data.frame(counts[[1]])


######### Import Peaks

# Save the toy peak data as a data frame
peak.df <- fread(path.to.peak) %>%
    mutate(Peaks=paste0(V1, ":", V2, "-", V3))

# Explore the output
head(peak.df)
length(peak.df$Peaks)
nrow(peak.df)


# Create a vector storing the narrowed peaks
peaks.narrowed <- peak.df$Peaks



######### Narrow genes


# Import read count matrix
reads <- h5dump(path.hdf5)


# Explore the imported data
class(reads)
str(reads)
str(reads$matrix)
length(reads$matrix$barcodes)



# Extract total genes read
genes.read <- unique(reads$matrix$features$name)
length(genes.read)
head(genes.read)


# Sample 2000 indices
set.seed(1122)
sample.index <- sort(sample(1:length(genes.read),
                           how.many.genes,
                           replace=F))

# Explore the indices
head(sample.index)
length(sample.index)


# Narrow genes matching the indices
genes.narrowed <- genes.read[sample.index]
head(genes.narrowed)
length(genes.narrowed)


######## Import barcodes

# Create a vector storing toy GEX barcodes
gex.barcode <- scan(path.to.gexbarcode, character(), quote="")

# Explore the barcodes
class(gex.barcode)
head(gex.barcode)
length(gex.barcode)


######## Separate two matrices

# Create a new matrix storing GEX matrix
gex.mat <- counts[[1]]

# Create a new matrix storing Peak matrix
peak.mat <- counts[[2]]


# Set a function subsetting matrix
# mat = matrix
# var.narrowed = genes.narrowed or peaks.narrowed
subset.matrix <- function(mat, var.narrowed) {

    # Create a logical vector determining intersection rows
    rows.narrowed <- rownames(mat) %in% var.narrowed

    # Explore the number of intersection rows
    print(paste("# of rows:", sum(rows.narrowed)))

    # Create a logical vector determining intersection columns
    cols.narrowed <- colnames(mat) %in% gex.barcode

    # Explore the number of intersection columns
    print(paste("# of columns:", sum(cols.narrowed)))

    # Subset the matrix
    matrix.subset <- mat[rows.narrowed, cols.narrowed]

    # Explore the output matrix
    print(str(matrix.subset))

    return(matrix.subset)
}

# Update each matrix
counts[[1]] <- subset.matrix(gex.mat, genes.narrowed)
counts[[2]] <- subset.matrix(peak.mat, peaks.narrowed)

# Explore the output
str(counts)

# add by chris
# get valid barcodes from "toy_barcode.csv" (filetered for N-th valid barcodes)
library(readr)
toy_barcodes <- read_csv(path.to.bc)
head(toy_barcodes)

length(intersect(colnames(counts[[1]]), toy_barcodes$barcode))
length(intersect(colnames(counts[[2]]), toy_barcodes$barcode))
length(intersect(colnames(counts[[2]]), toy_barcodes$atac_barcode))

cell_barcodes = toy_barcodes$barcode
gex_barcode = toy_barcodes$gex_barcode
atac_barcode = toy_barcodes$atac_barcode

new_counts = lapply(seq_along(counts), function(x) {
    this_count = counts[[x]]
    index = which(colnames(this_count) %in% cell_barcodes)
    valid_barcodes = colnames(this_count)[index]
    subset_count = this_count[, valid_barcodes]
    return(subset_count)
})
names(new_counts) = names(counts)

lapply(new_counts, dim)

new_counts[[2]] <- new_counts[[2]][Matrix::rowSums(new_counts[[2]]) != 0,] 
lapply(new_counts, dim)

hist(Matrix::rowSums(new_counts[[2]]))
summary(Matrix::rowSums(new_counts[[2]]))

# what will peak matrix look like after subsetting low read cells in Seurat?
#filter out cells with less that 500 nCounts_Peaks
test = new_counts[[2]][which(Matrix::rowSums(new_counts[[2]]) > 500),]
summary(Matrix::rowSums(test))
dim(test)

test = new_counts[[2]][which(Matrix::rowSums(new_counts[[2]]) > 1000),]
summary(Matrix::rowSums(test))
dim(test)

# Save the matrices as a rds file
write_rds(new_counts, path.to.toymatrix)




