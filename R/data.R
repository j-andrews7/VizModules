#' Example DESeq2 results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using DESeq2.
#'
#' @format A data frame with 63677 rows and 7 columns:
#' \describe{
#'   \item{baseMean}{Mean of normalized counts for all samples}
#'   \item{log2FoldChange}{Log2 fold change between treated and untreated conditions}
#'   \item{lfcSE}{Standard error of the log2 fold change estimate}
#'   \item{stat}{Wald statistic}
#'   \item{pvalue}{Wald test p-value}
#'   \item{padj}{Benjamini-Hochberg adjusted p-value}
#'   \item{symbol}{Gene symbol}
#'   \item{ensembl}{Ensembl gene ID}
#' }
#'
#' @source Generated from the \code{airway} Bioconductor package using DESeq2.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_deseq2)
#'
#' @author Jared Andrews
#' @keywords datasets
"airway_deseq2"

#' Example edgeR results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using edgeR (quasi-likelihood).
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{logFC}{Log2 fold change between treated and untreated conditions}
#'   \item{logCPM}{Log2 counts per million}
#'   \item{F}{Quasi-likelihood F statistic}
#'   \item{PValue}{Quasi-likelihood F-test p-value}
#'   \item{FDR}{Benjamini-Hochberg adjusted p-value}
#'   \item{ensembl}{Ensembl gene ID}
#'   \item{symbol}{Gene symbol}
#' }
#'
#' @source Generated from the \code{airway} Bioconductor package using edgeR.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_edger)
#'
#' @author Jared Andrews
#' @keywords datasets
"airway_edger"

#' Example limma-voom results from airway dataset
#'
#' A dataset containing differential expression results from comparing treated vs untreated
#' samples in the airway dataset using limma-voom.
#'
#' @format A data frame with columns:
#' \describe{
#'   \item{logFC}{Log2 fold change between treated and untreated conditions}
#'   \item{AveExpr}{Average log2 expression}
#'   \item{t}{Moderated t statistic}
#'   \item{P.Value}{Moderated t-test p-value}
#'   \item{adj.P.Val}{Benjamini-Hochberg adjusted p-value}
#'   \item{B}{Log-odds of differential expression}
#'   \item{ensembl}{Ensembl gene ID}
#'   \item{symbol}{Gene symbol}
#' }
#'
#' @source Generated from the \code{airway} Bioconductor package using limma.
#' The contrast compares dexamethasone treatment ("trt") vs untreated ("untrt").
#'
#' @examples
#' library(VizModules)
#' head(airway_voom)
#'
#' @author Jared Andrews
#' @keywords datasets
"airway_voom"

#' Example sales dataset for module apps
#'
#' A dataset containing simulated sales records across years, months, and regions.
#'
#' @format A data frame with 720 rows and 6 columns:
#' \describe{
#'   \item{sale_id}{Unique sale record identifier}
#'   \item{year}{Year of the sale}
#'   \item{month}{Month of the sale}
#'   \item{region}{Sales region}
#'   \item{revenue}{Revenue amount}
#'   \item{units}{Units sold}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(example_sales)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_sales"

#' Example population dataset for module apps
#'
#' A dataset containing simulated population counts across years and age groups.
#'
#' @format A data frame with 400 rows and 4 columns:
#' \describe{
#'   \item{record_id}{Unique population record identifier}
#'   \item{year}{Year of the record}
#'   \item{age_group}{Age group}
#'   \item{count}{Population count}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(example_population)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_population"
