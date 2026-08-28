# Example single-cell-style composition data for the freqPlot module

A per-cell record table from a simulated 12-donor immune profiling
experiment, shaped for
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html).
Each donor (`sample`) contributes 150 cells and maps to exactly one
`condition` and one `batch`, which is the nesting
[`freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html) requires
to compare per-sample cell-type frequencies across groups. `batch` is
crossed with `condition` (three donors each), so it works as a
`color.by` without confounding the comparison.

## Usage

``` r
example_composition
```

## Format

A data frame with 1800 rows and 7 columns:

- cell_id:

  Unique cell identifier (character)

- sample:

  Donor identifier, `P01`-`P12` (factor); 150 cells each

- condition:

  Disease state, `Healthy` or `Disease` (factor); six donors each

- batch:

  Processing batch, `B1` or `B2` (factor); crossed with `condition`

- cell_type:

  Annotated cell type (factor), the variable whose per-sample frequency
  [`freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
  tabulates

- n_genes:

  Number of genes detected in the cell (integer)

- percent_mito:

  Percentage of mitochondrial reads (numeric)

## Source

Simulated. Per-donor compositions are Dirichlet draws around
condition-specific means, with cell counts drawn multinomially. See
`data-raw/generate_example_data.R`.

## Details

Composition differs between the two conditions: the Disease donors show
an expanded monocyte compartment and depleted CD4 T cells relative to
Healthy.

## Author

Jared Andrews
