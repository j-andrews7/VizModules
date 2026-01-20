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
#' library(vizModules)
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
#' library(vizModules)
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
#' library(vizModules)
#' head(airway_voom)
#'
#' @author Jared Andrews
#' @keywords datasets
"airway_voom"
