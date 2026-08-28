# Example gene-expression-style matrix for the ComplexHeatmap module

A tidy data frame shaped as observations (genes, rows) by samples
(columns) — the layout
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
expects. 30 genes drawn from three functional pathways (10 genes each),
profiled across 12 samples (6 "Healthy", 6 "Disease"). Values are
simulated, *unscaled* log2-CPM-like expression: Immune and Cell Cycle
pathway genes are elevated in Disease samples, Metabolic pathway genes
are flat, so the module's row/column scaling, clustering, splitting, and
row-annotation controls all have real signal to demonstrate on. Pairs
with
[example_heatmap_column_data](https://j-andrews7.github.io/VizModules/reference/example_heatmap_column_data.md)
to additionally demonstrate column annotations (see
[`ComplexHeatmap_HeatmapApp()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapApp.md)'s
`column_data` argument).

## Usage

``` r
example_heatmap_matrix
```

## Format

A data frame with 30 rows and 15 columns:

- gene:

  Gene symbol (character), used as row identifier

- pathway:

  Functional pathway the gene belongs to (factor: Immune, Metabolic,
  Cell Cycle) — a categorical row-annotation column

- mean_expression:

  Mean log2-CPM-like expression across the 12 samples — a numeric
  row-annotation column

- Healthy_1, Healthy_2, Healthy_3, Healthy_4, Healthy_5, Healthy_6,
  Disease_1, Disease_2, Disease_3, Disease_4, Disease_5, Disease_6:

  Simulated log2-CPM-like expression values forming the heatmap matrix

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jacob Martin
