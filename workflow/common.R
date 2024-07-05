# Addapted from Seurat::Read10X()
# Now reads in all cellranger/cellranger-atac sparse matrices
# If only one 'feature type' is included, returns sparse matrix, else returns named list of sparse matrices
read_10X_mm <- function(
	data.dir,
	gene.column = 2,
	cell.column = 1,
	unique.features = TRUE,
	strip.suffix = FALSE,
	feature_list = NULL
) {
	full.data <- list()
	for (i in seq_along(along.with = data.dir)) {
		run <- data.dir[i]
		if (!dir.exists(paths = run)) {
			stop("Directory provided does not exist")
		}
		barcodes_base = list.files(run)[grep('barcodes.tsv', list.files(run))]
		barcode.loc <- file.path(run, barcodes_base)
		gene.loc <- file.path(run, 'genes.tsv')

		matrix_base = list.files(run)[grep('matrix.mtx', list.files(run))]
		matrix.loc <- file.path(run, matrix_base)

		features_base = setdiff(list.files(run), c(barcodes_base, matrix_base))
		features.loc <- file.path(run, features_base)

		# Flag to indicate if this data is from CellRanger >= 3.0
		pre_ver_3 <- file.exists(gene.loc)
		# if (!pre_ver_3) {
		#   addgz <- function(s) {
		#     return(paste0(s, ".gz"))
		#   }
		#   barcode.loc <- addgz(s = barcode.loc)
		#   matrix.loc <- addgz(s = matrix.loc)
		# }
		if (!file.exists(barcode.loc)) {
			stop("Barcode file missing. Expecting ", basename(path = barcode.loc))
		}
		if (!pre_ver_3 && !file.exists(features.loc) ) {
			stop("Gene name or features file missing. Expecting ", basename(path = features.loc))
		}
		if (!file.exists(matrix.loc)) {
			stop("Expression matrix file missing. Expecting ", basename(path = matrix.loc))
		}
		data <- Matrix::readMM(file = matrix.loc)
		cell.barcodes <- read.table(file = barcode.loc, header = FALSE, sep = '\t', row.names = NULL)
		if (ncol(x = cell.barcodes) > 1) {
			cell.names <- cell.barcodes[, cell.column]
		} else {
			cell.names <- readLines(con = barcode.loc)
		}
		if (all(grepl(pattern = "\\-1$", x = cell.names)) & strip.suffix) {
			cell.names <- as.vector(x = as.character(x = sapply(
				X = cell.names,
				FUN = ExtractField,
				field = 1,
				delim = "-"
			)))
		}
		if (is.null(x = names(x = data.dir))) {
			if (length(x = data.dir) < 2) {
				colnames(x = data) <- cell.names
			} else {
				colnames(x = data) <- paste0(i, "_", cell.names)
			}
		} else {
			colnames(x = data) <- paste0(names(x = data.dir)[i], "_", cell.names)
		}
		feature.names <- read.delim(
			file = ifelse(test = pre_ver_3, yes = gene.loc, no = features.loc),
			header = FALSE,
			stringsAsFactors = FALSE
		)
		if (any(is.na(x = feature.names[, gene.column]))) {
			warning(
				'Some features names are NA. Replacing NA names with ID from the opposite column requested',
				call. = FALSE,
				immediate. = TRUE
			)
			na.features <- which(x = is.na(x = feature.names[, gene.column]))
			replacement.column <- ifelse(test = gene.column == 2, yes = 1, no = 2)
			feature.names[na.features, gene.column] <- feature.names[na.features, replacement.column]
		}
		if (grepl('features.tsv', features_base)) {
			if (unique.features) {
				fcols = ncol(x = feature.names)
				if (fcols < gene.column) {
					stop(paste0("gene.column was set to ", gene.column,
											" but feature.tsv.gz (or genes.tsv) only has ", fcols, " columns.",
											" Try setting the gene.column argument to a value <= to ", fcols, "."))
				}
				rownames(x = data) <- make.unique(names = feature.names[, gene.column])
			}
		} else if (grepl('peaks.bed', features_base)) {
			rownames(x = data) = paste0(feature.names[,1], ':', feature.names[,2], '-', feature.names[,3])
		} else if (grepl('motifs.tsv', features_base)) {
			rownames(x = data) = feature.names[,1]
		} else {
			print('Features file format incorrect!')
			print('Please reformat features file name and fields with one of the following:')
			print('peaks.bed: column contents: chr, start, end')
			print('motifs.tsv: column contents: feature, common_name')
			print('features.tsv or features.tsv.gz: column contents: accession_id, feature_symbol, feature_type')
		}
		# In cell ranger 3.0, a third column specifying the type of data was added
		# and we will return each type of data as a separate matrix
		if (ncol(x = feature.names) > 2 && grepl('features.tsv', features_base)) {
			data_types <- factor(x = feature.names$V3)
			lvls <- levels(x = data_types)
			if (length(x = lvls) > 1 && length(x = full.data) == 0) {
				message("10X data contains more than one type and is being returned as a list containing matrices of each type.")
			}
			expr_name <- "Gene Expression"
			if (expr_name %in% lvls) { # Return Gene Expression first
				lvls <- c(expr_name, lvls[-which(x = lvls == expr_name)])
			}
			data <- lapply(
				X = lvls,
				FUN = function(l) {
					return(data[data_types == l, , drop = FALSE])
				}
			)
			names(x = data) <- lvls
		} else {
			data <- list(data)
			names(data) = feature_list[i]
		}
		full.data[[length(x = full.data) + 1]] <- data
	}

	n_features = sapply(unlist(full.data), nrow)
	if (length(n_features) > 1) {
		equal_nrows = isTRUE(all.equal(n_features[1], n_features[2:length(n_features)]))
	} else {
		equal_nrows = TRUE
	}
	if (equal_nrows) {
		# Combine all the data from different directories into one big matrix, note this
		# assumes that all data directories essentially have the same features files
		list_of_data <- list()
		for (j in 1:length(x = full.data[[1]])) {
			list_of_data[[j]] <- do.call(cbind, lapply(X = full.data, FUN = `[[`, j))
			# Fix for Issue #913
			list_of_data[[j]] <- as(object = list_of_data[[j]], Class = "dgCMatrix")
		}
		names(x = list_of_data) <- names(x = full.data[[1]])
	} else {
		list_of_data = unlist(full.data)
	}
	# If multiple features, will return a list, otherwise
	# a matrix.
	if (length(x = list_of_data) == 1) {
		return(list_of_data[[1]])
	} else {
		return(list_of_data)
	}
}

# wrapper to read in matrices from hdf5 or 10x sparse matrix format
# input path to hdf5 file or comma separated list of sparse matrix directories
# outputs a sparse matrix (if only one matrix supplied) or list of matrices (if multiple dirs supplied),
# similar in behavior to Seurat::Read10X() and/or Seurat::Read10X_h5
load_10X_features = function(input_path, feature_list = NULL) {
	if (length(input_path) == 1 && all(grepl('.h5', input_path))) {
		tenx_data <- read_10X_h5_features(filename = input_path)
	} else {
		tenx <- read_10X_mm(
			data.dir = input_path, 
			feature_list = feature_list
			)
		tenx_data = lapply(seq_along(tenx), function(x){
			tenx_rnames = rownames(tenx[[x]])
			return(tenx_rnames)
		})
		names(tenx_data) = names(tenx)
	}
	return(tenx_data)
}

# Find outliers for QC filtering
# method:
#    'iqr': Filter using Tukey's Fences
#    'sd': Filter using standard deviation
# k: multiplier if method = 'iqr', default set to 2.2 based on:
#	“Fine-Tuning Some Resistant Rules for Outlier Labeling” by Hoaglin and Iglewicz (1987)
#   historical k value set to 1.5, Tukey's "far out" ouliers k value set to 3
# sigma: number of standard deviations away from mean to use as cutoff
# lower: user defined hard cutoff for lower limit. If set, 'iqr' and 'sd' methods ignored
# upper: user defined hard cutoff for upper limit. If set, 'iqr' and 'sd' methods ignored
# na_rm: if NAs present, exclude prior to calculations?
find_outliers <- function(
	counts,
	method = 'sd',
	k = 2.2,
	sigma = 3,
	lower = NULL,
	upper = NULL,
	na_rm = TRUE
) {

	if (method == 'iqr') {
		# Lower Q
		q1 <- quantile(counts, 0.25, na.rm = na_rm)
		# q1.s1
		
		# Upper Q:
		q3 <- quantile(counts, 0.75, na.rm = na_rm)
		# q3.s1
		
		# k * IQR:
		whisker <- k * IQR(counts, na.rm = na_rm)

		lower_limit <- q1 - whisker
		upper_limit <- q3 + whisker
	} else if (method == 'sd') {
		u <- mean(counts, na.rm = na_rm)
		s <- sigma * sd(counts, na.rm = na_rm)

		lower_limit <- u-s
		upper_limit <- u+s
	}
	
	if (is.null(lower)) {
		if ( lower_limit <= 0 ) {
			# want > 0, since some functions break with counts == 0
			feature_min <- 0
		} else {
			feature_min <- lower_limit
		}
	} else {
		feature_min <- lower
	}

	if (is.null(upper)) {
		if ( upper_limit >= max(counts, na.rm = na_rm) ) {
			feature_max <- max(counts, na.rm = na_rm)
		} else {
			feature_max <- upper_limit
		}
	} else {
		feature_max <- upper
	}

	min_max <- c(feature_min, feature_max)
	names(min_max) <- c("min", "max")
	return(min_max)
}

preprocess_seurat <- function(seurat_obj, assay, norm_method) {
	DefaultAssay(seurat_obj) <- assay
	
	if (norm_method == 'log') {
		print("Performing log normalization.")
		
		seurat_obj <- NormalizeData(
			object = seurat_obj,
			normalization.method = 'LogNormalize'
		)
		
		seurat_obj <- FindVariableFeatures(
			object = seurat_obj,
			selection.method = "vst",
			nfeatures = 2000
		)
		
		# Log norm method needs fruther scaling
		seurat_obj <- ScaleData(seurat_obj)
		
		seurat_obj <- RunPCA(seurat_obj)

		# reduction_name = paste0(tolower(assay), '_pca')
		# seurat_obj <- RunPCA(
		# 	object = seurat_obj,
		# 	reduction.name = reduction_name
		# )
		
		# max_pcs = ncol(seurat_obj[[reduction_name]]@cell.embeddings)
		
		# umap_red_name =paste0(tolower(assay), '_umap')
		# seurat_obj = RunUMAP(
		# 	seurat_obj,
		# 	dims = 1:max_pcs, 
		# 	reduction = reduction_name,
		# 	reduction.name = umap_red_name
		# )
		
	} else if (norm_method == 'clr') {
		print("Performing log normalization.")
		
		VariableFeatures(seurat_obj) <- rownames(seurat_obj)
		print(head(VariableFeatures(seurat_obj)))
		
		seurat_obj <- NormalizeData(
			object = seurat_obj,
			normalization.method = 'CLR',
			margin = 2
		)
		
		# Log norm method needs fruther scaling
		seurat_obj <- ScaleData(seurat_obj)
		
		seurat_obj <- RunPCA(object = seurat_obj)

		# reduction_name = paste0(tolower(assay), '_pca')
		# seurat_obj <- RunPCA(
		# 	object = seurat_obj,
		# 	reduction.name = reduction_name
		# )
		
		# max_pcs = ncol(seurat_obj[[reduction_name]]@cell.embeddings)
		
		# umap_red_name =paste0(tolower(assay), '_umap')
		# seurat_obj = RunUMAP(
		# 	seurat_obj,
		# 	dims = 1:max_pcs, 
		# 	reduction = reduction_name,
		# 	reduction.name = umap_red_name
		# )
		
	} else if (norm_method == 'sct') {
		print("Performing SCTransform normalization.")
		
		# # Default assay name returned by SCTransform is 'SCT'
		# # Need to rename in case using SCT on multiple assays (GEX + feature barcoding, etc)
		# new_assay_name = paste(assay, 'SCT', sep = '.')
		# print('Adding SCTransform to the following slot')
		# print(new_assay_name)
		# seurat_obj = SCTransform(
		# 	object = seurat_obj,
		# 	assay = assay,
		# 	new.assay.name = new_assay_name
		# 	# verbose = FALSE
		# )
		
		seurat_obj <- SCTransform(
			object = seurat_obj,
			assay = assay
		)
		
		# !!!!!!!!!! When using SCT method DO NOT scale data with ScaleData() !!!!!!!!!!
		
		seurat_obj <- RunPCA(seurat_obj)

		# reduction_name = paste0(tolower(assay), '_pca')
		# seurat_obj <- RunPCA(
		# 	object = seurat_obj,
		# 	reduction.name = reduction_name
		# )
		
		# max_pcs = ncol(seurat_obj[[reduction_name]]@cell.embeddings)
		
		# umap_red_name =paste0(tolower(assay), '_umap')
		# seurat_obj = RunUMAP(
		# 	seurat_obj,
		# 	dims = 1:max_pcs, 
		# 	reduction = reduction_name,
		# 	reduction.name = umap_red_name
		# )
		
	} else if (norm_method == "lsi") {
		print("Performing LSA normalization.")
		
		seurat_obj <- RunTFIDF(seurat_obj)
		
		seurat_obj <- FindTopFeatures(
			object = seurat_obj,
			min.cutoff = 10
		)
		
		seurat_obj <- RunSVD(seurat_obj)

		# # use 'lsi' reduction.name for now
		# reduction_name = paste0(tolower(assay), '_lsi')
		# seurat_obj <- RunSVD(
		# 	object = seurat_obj,
		# 	reduction.name = reduction_name
		# )
		
		# max_pcs = ncol(seurat_obj[[reduction_name]]@cell.embeddings)
		
		# umap_red_name =paste0(tolower(assay), '_umap')
		# seurat_obj = RunUMAP(
		# 	seurat_obj,
		# 	dims = 1:max_pcs, 
		# 	reduction = reduction_name,
		# 	reduction.name = umap_red_name
		# )
		
	} else {
		print('Invalid choice for normalization.')
		print('please select log, sct or tfidf methods and re-run this step')
	}
	return(seurat_obj)
}

# input is vector of min/max pairs, output is ranged sequence for each pair
dim_vals_to_list = function(dim_vals) {
	split_list = split(dim_vals, 1:length(dim_vals) %% 2 == 0)

	dims_list = lapply(seq_along(split_list), function(x) {
		mins = split_list[['FALSE']]
		maxs = split_list[['TRUE']]
		min_max = c(mins[x], maxs[x])
		return(min_max)
	})

	dims_list = lapply(seq_along(dims_list), function(x) {
		dims = dims_list[[x]]
		dims = seq(from = dims[1], to = dims[2])
		return(dims)
	})

	return(dims_list)
}


# Detect core on slurm cluster
#############################
detectBatchCPUs <- function() {
  ncores <- as.integer(Sys.getenv("SLURM_CPUS_PER_TASK")) 
  if (is.na(ncores)) { 
    ncores <- as.integer(Sys.getenv("SLURM_JOB_CPUS_PER_NODE")) 
  } 
  if (is.na(ncores)) { 
    return(4) # for helix
  } 
  return(ncores)
}

# # capitalize first letter of period delimited string ("hello.world" --> "Hello.World")
# simple_cap <- function(x) {
#   s <- strsplit(x, "\\.")[[1]]
#   paste(toupper(substring(s, 1, 1)), substring(s, 2),
#         sep = "", collapse = ".")
# }
