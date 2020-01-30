## Cell-cycle and cell-type markers.
## Updated 2020-01-30.

## Here we're matching the stored Ensembl identifiers (`geneID`) using
## ensembldb to obtain the latest symbol names from Ensembl.

## Cell-cycle markers devied from:
## - Tirosh et al, 2015
## - http://satijalab.org/seurat/cell_cycle_vignette.html

library(usethis)
library(stringr)

# Import as `DataFrame` instead of `tbl_df`.
options("acid.data.frame" = "DataFrame")

markers_dir <- system.file(
    file.path("inst", "extdata", "markers"),
    package = "pointillism"
)
stopifnot(dir.exists(markers_dir))

## Ensembl release version.
release <- as.integer(readLines(file.path(markers_dir, "ensembl-release.txt")))

## Cell-cycle markers ==========================================================
cell_cycle_dir <- file.path(markers_dir, "cell-cycle")
stopifnot(dir.exists(cell_cycle_dir))
files <- list.files(path = cell_cycle_dir, pattern = "*.csv", full.names = TRUE)
cell_cycle_markers_list <- lapply(
    X = files,
    FUN = function(file) {
        data <- import(file = file)
        data <- as(data, "DataFrame")
        organism <- basenameSansExt(file)
        gene2symbol <- makeGene2SymbolFromEnsembl(
            organism = organism,
            release = release
        )
        CellCycleMarkers(
            object = data,
            gene2symbol = gene2symbol
        )
    }
)
names <- camel(basenameSansExt(files))
names(cell_cycle_markers_list) <- names

## Cell-type markers ===========================================================
cell_type_dir <- file.path(markers_dir, "cell-type")
stopifnot(dir.exists(cell_type_dir))
files <- list.files(path = cell_type_dir, pattern = "*.csv", full.names = TRUE)
cell_type_markers_list <- lapply(
    X = files,
    FUN = function(file) {
        data <- import(file = file)
        data <- as(data, "DataFrame")
        organism <- basenameSansExt(file)
        gene2symbol <- makeGene2SymbolFromEnsembl(
            organism = organism,
            release = release
        )
        CellTypeMarkers(
            object = data,
            gene2symbol = gene2symbol
        )
    }
)
names <- camel(basenameSansExt(files))
names(cell_type_markers_list) <- names

## Save R data ==================================================================
use_data(
    cell_cycle_markers_list,
    cell_type_markers_list,
    compress = "xz",
    overwrite = TRUE
)