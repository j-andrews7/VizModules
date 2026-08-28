# Example sample-metadata table for the ComplexHeatmap module

Per-sample metadata for the 12 samples in
[example_heatmap_matrix](https://j-andrews7.github.io/VizModules/reference/example_heatmap_matrix.md),
keyed by `sample`. Supplying this alongside the matrix (as
`list(matrix = example_heatmap_matrix, column_annotations = example_heatmap_column_data)`)
enables column annotations in the ComplexHeatmap module.

## Usage

``` r
example_heatmap_column_data
```

## Format

A data frame with 12 rows and 4 columns:

- sample:

  Sample identifier (factor), matching the sample column names in
  [example_heatmap_matrix](https://j-andrews7.github.io/VizModules/reference/example_heatmap_matrix.md)

- condition:

  Experimental condition (factor: Healthy, Disease)

- batch:

  Processing batch (factor: B1, B2), crossed with `condition`

- library_size:

  Simulated sequencing library size (numeric)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jacob Martin
