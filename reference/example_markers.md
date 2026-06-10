# Example single-cell marker gene dataset for dot plots

A simulated single-cell marker-gene expression dataset with 104 rows
covering eight immune cell types and thirteen canonical marker genes.
Each cell type strongly expresses its own marker genes (high average
expression and percent expressed) and weakly expresses the rest, making
it a realistic example for
[`plotthis_DotPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotApp.md)
where dot size encodes the percent of cells expressing a gene and dot
fill encodes average expression.

## Usage

``` r
example_markers
```

## Format

A data frame with 104 rows and 4 columns:

- cell_type:

  Immune cell type (factor: CD4 T, CD8 T, B, NK, Monocyte, Dendritic,
  Plasma, Platelet)

- gene:

  Marker gene symbol (factor with 13 levels, e.g. CD3D, MS4A1, NKG7,
  LYZ, MZB1, PPBP)

- avg_expression:

  Average expression of the gene in the cell type

- pct_expressed:

  Percent of cells in the cell type expressing the gene

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jacob Martin
