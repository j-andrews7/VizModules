# Example DESeq2 results from airway dataset

A dataset containing differential expression results from comparing
treated vs untreated samples in the airway dataset using DESeq2.

## Usage

``` r
airway_deseq2
```

## Format

A data frame with 63677 rows and 7 columns:

- baseMean:

  Mean of normalized counts for all samples

- log2FoldChange:

  Log2 fold change between treated and untreated conditions

- lfcSE:

  Standard error of the log2 fold change estimate

- stat:

  Wald statistic

- pvalue:

  Wald test p-value

- padj:

  Benjamini-Hochberg adjusted p-value

- symbol:

  Gene symbol

- ensembl:

  Ensembl gene ID

## Source

Generated from the `airway` Bioconductor package using DESeq2. The
contrast compares dexamethasone treatment ("trt") vs untreated
("untrt").

## Author

Jared Andrews

## Examples

``` r
data(airway_deseq2)
head(airway_deseq2)
#>                    baseMean log2FoldChange     lfcSE       stat     pvalue
#> ENSG00000000003 708.6021697    -0.37884667 0.1731411 -2.1880804 0.02866375
#> ENSG00000000005   0.0000000             NA        NA         NA         NA
#> ENSG00000000419 520.2979006     0.20376048 0.1005987  2.0254789 0.04281822
#> ENSG00000000457 237.1630368     0.03404294 0.1262790  0.2695852 0.78747941
#> ENSG00000000460  57.9326331    -0.11717811 0.3012365 -0.3889904 0.69728327
#> ENSG00000000938   0.3180984    -1.72456894 3.4936334 -0.4936319 0.62156615
#>                      padj         ensembl   symbol
#> ENSG00000000003 0.1393085 ENSG00000000003   TSPAN6
#> ENSG00000000005        NA ENSG00000000005     TNMD
#> ENSG00000000419 0.1833587 ENSG00000000419     DPM1
#> ENSG00000000457 0.9305689 ENSG00000000457    SCYL3
#> ENSG00000000460 0.8954426 ENSG00000000460 C1orf112
#> ENSG00000000938        NA ENSG00000000938      FGR
```
