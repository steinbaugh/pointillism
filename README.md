# pointillism

[![Travis CI](https://travis-ci.com/acidgenomics/pointillism.svg?branch=master)](https://travis-ci.org/acidgenomics/pointillism)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)

[R][] package for for single-cell RNA-seq clustering analysis.

## Installation

This is an [R][] package.

### [Bioconductor][]

We recommend installing the package with [BiocManager][].

```r
if (!require("BiocManager")) {
    install.packages("BiocManager")
}
BiocManager::install("remotes")
BiocManager::install("acidgenomics/pointillism")
```

## Supported data classes

[pointillism][] currently supports these S4 single-cell container classes:

- [SingleCellExperiment][]
- [Seurat][] (v3)

**monocle v3**: Support for the [monocle][] `CellDataSet` class will be added when [monocle][] v3 becomes available on [Bioconductor][].

## Markers

Cell-cycle and cell-type markers are stored internally inside the package. Refer to `inst/extdata/` for the CSV files.

## Troubleshooting

### Maximal number of DLLs reached

```
Error: package or namespace load failed for 'pointillism' in dyn.load(file, DLLpath = DLLpath, ...):
  maximal number of DLLs reached...
```

Depending on your operating system, you may encounter this error about hitting the DLL limit in [R][]. This issue is becoming more common as RNA-seq analysis packages grow increasingly complex. Luckily, we can configure [R][] to increase the DLL limit. Append this line to your `~/.Renviron` file:

```
R_MAX_NUM_DLLS=150
```

For more information on this issue, consult `help("dyn.load")` in the [R][] documentation. The number of loaded DLLs in an [R][] session can be obtained with `getLoadedDLLs()`.

## References

The papers and software cited in our workflows are available as a [shared library](https://paperpile.com/shared/5PLRi1) on [Paperpile][].

[BiocManager]: https://cran.r-project.org/package=BiocManager
[Bioconductor]: https://bioconductor.org/
[CRAN]: https://cran.r-project.org/  "The Comprehensive R Archive Network"
[Michael Steinbaugh]: https://mike.steinbaugh.com/
[Paperpile]: https://paperpile.com/
[R]: https://www.r-project.org/
[Seurat]: https://satijalab.org/seurat/
[SingleCellExperiment]: https://bioconductor.org/packages/SingleCellExperiment/
[conda]: https://conda.io/
[monocle]: http://cole-trapnell-lab.github.io/monocle-release/
[pointillism]: https://pointillism.acidgenomics.com/
