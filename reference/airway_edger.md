# Example edgeR results from airway dataset

A dataset containing differential expression results from comparing
treated vs untreated samples in the airway dataset using edgeR
(quasi-likelihood).

## Usage

``` r
airway_edger
```

## Format

A data frame with columns:

- logFC:

  Log2 fold change between treated and untreated conditions

- logCPM:

  Log2 counts per million

- F:

  Quasi-likelihood F statistic

- PValue:

  Quasi-likelihood F-test p-value

- FDR:

  Benjamini-Hochberg adjusted p-value

- ensembl:

  Ensembl gene ID

- symbol:

  Gene symbol

## Source

Generated from the `airway` Bioconductor package using edgeR. The
contrast compares dexamethasone treatment ("trt") vs untreated
("untrt").

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
head(airway_edger)
#>                    logFC   logCPM        F       PValue          FDR
#> ENSG00000152583 4.592225 5.542697 485.5167 4.650242e-09 7.405976e-05
#> ENSG00000250978 6.170713 1.408178 167.1807 5.173554e-08 2.045145e-04
#> ENSG00000134686 1.378839 7.000894 278.3245 5.209517e-08 2.045145e-04
#> ENSG00000179094 3.174553 5.182775 269.1113 6.025823e-08 2.045145e-04
#> ENSG00000125148 2.193761 7.416911 258.5757 7.154966e-08 2.045145e-04
#> ENSG00000148175 1.442768 9.031950 254.1664 7.704930e-08 2.045145e-04
#>                         ensembl        symbol
#> ENSG00000152583 ENSG00000152583       SPARCL1
#> ENSG00000250978 ENSG00000250978 RP11-357D18.1
#> ENSG00000134686 ENSG00000134686          PHC2
#> ENSG00000179094 ENSG00000179094          PER1
#> ENSG00000125148 ENSG00000125148          MT2A
#> ENSG00000148175 ENSG00000148175          STOM
```
