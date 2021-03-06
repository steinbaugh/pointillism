#' @name plotCellTypesPerCluster
#' @inherit AcidGenerics::plotCellTypesPerCluster
#' @note Updated 2020-02-21.
#'
#' @details
#' Plot the geometric mean of the significant marker genes for every known cell
#' type (per unbiased cluster). Cell types with too few (`min` cutoff) or too
#' many (`max` cutoff) marker genes will be skipped.
#'
#' @inheritParams AcidRoxygen::params
#' @param ... Passthrough arguments to [plotMarker()].
#'
#' @examples
#' data(Seurat, package = "AcidTest")
#' data(seuratKnownMarkers)
#'
#' ## Seurat ====
#' object <- Seurat
#' markers <- seuratKnownMarkers
#' plotCellTypesPerCluster(
#'     object = object,
#'     markers = markers,
#'     reduction = "UMAP"
#' )
NULL



## Updated 2020-02-21.
`plotCellTypesPerCluster,SingleCellExperiment,KnownMarkers` <-  # nolint
    function(
        object,
        markers,
        min = 1L,
        max = Inf,
        reduction,
        expression,
        headerLevel = 2L,
        ...
    ) {
        ## Passthrough: color, dark.
        validObject(object)
        validObject(markers)
        assert(
            isScalar(reduction),
            isHeaderLevel(headerLevel)
        )
        expression <- match.arg(expression)
        markers <- cellTypesPerCluster(markers, min = min, max = max)
        ## Output Markdown headers per cluster.
        clusters <- unique(as.character(markers[["cluster"]]))
        assert(hasLength(clusters))
        return <- lapply(
            X = clusters,
            FUN = function(cluster) {
                markdownHeader(
                    text = paste("Cluster", cluster),
                    level = headerLevel,
                    tabset = TRUE,
                    asis = TRUE
                )
                keep <- markers[["cluster"]] == cluster
                clusterData <- markers[keep, , drop = FALSE]
                if (!hasRows(clusterData)) {
                    alertWarning(sprintf(
                        "No markers for cluster %s.", cluster
                    ))
                    return(invisible(NULL))
                }
                cellTypes <- clusterData[["cellType"]]
                assert(is.factor(cellTypes))
                lapply(
                    X = cellTypes,
                    FUN = function(cellType) {
                        title <- as.character(cellType)
                        markdownHeader(
                            text = title,
                            level = headerLevel + 1L,
                            asis = TRUE
                        )
                        ## Modify the title by adding the cluster number.
                        title <- paste(paste0("Cluster ", cluster, ":"), title)
                        cellData <- clusterData[
                            clusterData[["cellType"]] == cellType,
                            ,
                            drop = FALSE
                            ]
                        assert(identical(nrow(cellData), 1L))
                        genes <- cellData[["name"]]
                        genes <- as.character(genes)
                        genes <- strsplit(genes, split = ", ")[[1L]]
                        if (!hasLength(genes)) {
                            return(invisible(NULL))
                        }
                        p <- plotMarker(
                            object = object,
                            genes = genes,
                            reduction = reduction,
                            expression = expression,
                            ...
                        )
                        show(p)
                        invisible(p)
                    }
                )
            }
        )
        invisible(return)
    }

args <- c("reduction", "expression", "BPPARAM")
formals(`plotCellTypesPerCluster,SingleCellExperiment,KnownMarkers`)[args] <-
    .formalsList[args]
rm(args)



#' @rdname plotCellTypesPerCluster
#' @export
setMethod(
    f = "plotCellTypesPerCluster",
    signature = signature(
        object = "SingleCellExperiment",
        markers = "KnownMarkers"
    ),
    definition = `plotCellTypesPerCluster,SingleCellExperiment,KnownMarkers`
)



## Updated 2019-08-07.
`plotCellTypesPerCluster,Seurat,KnownMarkers` <-  # nolint
    `plotCellTypesPerCluster,SingleCellExperiment,KnownMarkers`



#' @rdname plotCellTypesPerCluster
#' @export
setMethod(
    f = "plotCellTypesPerCluster",
    signature = signature(
        object = "Seurat",
        markers = "KnownMarkers"
    ),
    definition = `plotCellTypesPerCluster,Seurat,KnownMarkers`
)
