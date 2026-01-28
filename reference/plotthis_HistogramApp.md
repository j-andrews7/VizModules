# Standalone Multi-Dataset Histogram Application

Launches a complete Shiny application that displays interactive
histogram modules for every data frame provided in a list. This is ideal
for side-by-side comparison of different genomic datasets or clinical
cohorts.

## Usage

``` r
plotthis_HistogramApp(data_list)
```

## Arguments

- data_list:

  `list` A named list of data frames. Each list element will trigger the
  creation of a separate histogram module instance.

## Value

A Shiny app object that can be run locally or deployed to a server.

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- plotthis_HistogramApp(data_list)
if (interactive()) runApp(app)
```
