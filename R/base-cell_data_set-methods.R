#' Extend base S4 methods for `cell_data_set` class
#'
#' @name base-cell_data_set
#' @keywords internal
#' @note Updated 2019-08-05.
#'
#' @inheritParams acidroxygen::params
#'
#' @return Varies, depending on the generic.
NULL



## Updated 2019-08-02.
`Gene2Symbol,cell_data_set` <-  # nolint
    function(object, ...) {
        assert(isSubset("gene_short_name", colnames(rowData(object))))
        df <- DataFrame(
            geneID = rownames(object),
            geneName = rowData(object)[["gene_short_name"]],
            row.names = rownames(object)
        )
        Gene2Symbol(object = df, ...)
    }



#' @rdname base-cell_data_set
#' @export
setMethod(
    f = "Gene2Symbol",
    signature = signature("cell_data_set"),
    definition = `Gene2Symbol,cell_data_set`
)



## Updated 2019-08-05.
`logcounts,cell_data_set` <-  # nolint
    function(object, verbose = FALSE) {
        assert(isFlag(verbose))
        if (isTRUE(verbose)) {
            message(
                "Returning log normalized counts with ",
                "'monocle3::normalized_counts()'."
            )
        }
        monocle3::normalized_counts(
            cds = object,
            norm_method = "log",
            pseudocount = 1L
        )
    }



#' @rdname base-cell_data_set
#' @export
setMethod(
    f = "logcounts",
    signature = signature("cell_data_set"),
    definition = `logcounts,cell_data_set`
)



## This method will automatically add "ident" column and strip "cell" column.
## Updated 2019-08-06.
`metrics,cell_data_set` <-  # nolint
    function(object, return) {
        validObject(object)
        ## Strip invalid columns from column data.
        colData(object)[c("cell", "ident", "Size_Factor")] <- NULL
        data <- metrics(
            object = as(object, "SingleCellExperiment"),
            return = return
        )
        ident <- tryCatch(
            expr = clusters(object),
            error = function(e) NULL
        )
        if (is.factor(ident)) {
            data[["ident"]] <- ident
        }
        data
    }

f <- methodFormals(
    f = "metrics",
    signature = "SingleCellExperiment",
    package = "basejump"
)
formals(`metrics,cell_data_set`)[["return"]] <- f[["return"]]



#' @rdname base-cell_data_set
#' @export
setMethod(
    f = "metrics",
    signature = signature("cell_data_set"),
    definition = `metrics,cell_data_set`
)



## Updated 2019-08-05.
`normcounts,cell_data_set` <-  # nolint
    function(object, verbose = FALSE) {
        assert(isFlag(verbose))
        if (isTRUE(verbose)) {
            message(
                "Getting normalized counts with ",
                "'monocle3::normalized_counts()'."
            )
        }
        monocle3::normalized_counts(
            cds = object,
            norm_method = "size_only",
            pseudocount = NULL
        )
    }



#' @rdname base-cell_data_set
#' @export
setMethod(
    f = "normcounts",
    signature = signature("cell_data_set"),
    definition = `normcounts,cell_data_set`
)



## Updated 2019-08-06.
`sizeFactors,cell_data_set` <-  # nolint
    function(object) {
        colData(object)[["Size_Factor"]]
    }



#' @rdname base-cell_data_set
#' @export
setMethod(
    f = "sizeFactors",
    signature = signature("cell_data_set"),
    definition = `sizeFactors,cell_data_set`
)



## nolint start
##
## > getMethod(
## >     f = "sizeFactors<-",
## >     signature = signature(
## >         object = "SummarizedExperiment",
## >         value = "numeric"
## >     ),
## >     where = asNamespace("basejump")
## > )
##
## nolint end



## Updated 2019-08-06.
`sizeFactors<-,cell_data_set,ANY` <-  # nolint
    function(object, value) {
        if (!is.null(value)) {
            assert(
                all(!is.na(value)),
                all(is.finite(value)),
                all(value > 0L)
            )
            value <- unname(value)
        }
        colData(object)[["Size_Factor"]] <- value
        object
    }



#' @rdname base-cell_data_set
#' @export
setReplaceMethod(
    f = "sizeFactors",
    signature = signature(
        object = "cell_data_set",
        value = "ANY"
    ),
    definition = `sizeFactors<-,cell_data_set,ANY`
)