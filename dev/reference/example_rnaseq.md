# Example RNA-seq dataset for the RNA-seq showcase app

A simulated pseudo-bulk RNA-seq dataset with 288 rows covering six
immune cell types, eight canonical marker genes, two conditions (Healthy
/ Disease), and three biological replicates per condition. Marker genes
are strongly expressed in their canonical cell type; Disease replicates
include a simulated ~1.2 log2FC upregulation for marker genes, making
biological comparisons visually informative.

## Usage

``` r
example_rnaseq
```

## Format

A data frame with 288 rows and 7 columns:

- cell_type:

  Immune cell type (factor: CD4 T, CD8 T, B Cell, NK Cell, Monocyte,
  pDC)

- gene:

  Gene symbol (factor: CD3D, CD8A, MS4A1, NKG7, LYZ, LILRA4, CD14, GNLY)

- condition:

  Experimental condition (factor: Healthy, Disease)

- replicate:

  Biological replicate (factor: Rep1, Rep2, Rep3)

- log2_cpm:

  Simulated log2 counts-per-million expression value

- avg_expression:

  Mean log2_cpm across replicates for this cell_type \\\times\\ gene
  \\\times\\ condition

- neg_log10_pval:

  Simulated \\-\log\_{10}(p)\\ value for differential expression
  summaries

## Source

Simulated in data-raw/generate_example_data.R.

## Details

The dataset is designed to simultaneously support three VizModules plot
types:

- DotPlot — summarised `avg_expression` and `pct_expressed` columns per
  cell type \\\times\\ gene \\\times\\ condition combination.

- yPlot — per-replicate `log2_cpm` values grouped by `cell_type` and
  coloured by `condition`.

- DensityPlot — per-replicate `log2_cpm` values grouped by `condition`
  and faceted by `cell_type`.

## Author

Jacob Martin
