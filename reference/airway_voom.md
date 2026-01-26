# Example limma-voom results from airway dataset

A dataset containing differential expression results from comparing
treated vs untreated samples in the airway dataset using limma-voom.

## Usage

``` r
airway_voom
```

## Format

A data frame with columns:

- logFC:

  Log2 fold change between treated and untreated conditions

- AveExpr:

  Average log2 expression

- t:

  Moderated t statistic

- P.Value:

  Moderated t-test p-value

- adj.P.Val:

  Benjamini-Hochberg adjusted p-value

- B:

  Log-odds of differential expression

- ensembl:

  Ensembl gene ID

- symbol:

  Gene symbol

## Source

Generated from the `airway` Bioconductor package using limma. The
contrast compares dexamethasone treatment ("trt") vs untreated
("untrt").

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(airway_voom)
#>                    logFC  AveExpr        t      P.Value    adj.P.Val        B
#> ENSG00000134686 1.381139 6.839533 17.35671 3.800818e-08 0.0001823477 9.401640
#> ENSG00000152583 4.574855 4.167526 18.56584 2.123270e-08 0.0001823477 9.236394
#> ENSG00000125148 2.198075 7.024695 16.55131 5.724844e-08 0.0001823477 9.010762
#> ENSG00000148175 1.440288 8.856653 16.69282 5.320156e-08 0.0001823477 8.916373
#> ENSG00000179094 3.185870 4.421045 16.64713 5.447236e-08 0.0001823477 8.867509
#> ENSG00000120129 2.952724 6.645078 15.89011 8.128610e-08 0.0002157604 8.691210
#>                         ensembl  symbol
#> ENSG00000134686 ENSG00000134686    PHC2
#> ENSG00000152583 ENSG00000152583 SPARCL1
#> ENSG00000125148 ENSG00000125148    MT2A
#> ENSG00000148175 ENSG00000148175    STOM
#> ENSG00000179094 ENSG00000179094    PER1
#> ENSG00000120129 ENSG00000120129   DUSP1
```
