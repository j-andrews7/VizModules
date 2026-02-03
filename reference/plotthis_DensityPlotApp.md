# Standalone Multi-Dataset Density Plot Application

Launches a complete Shiny application that displays interactive density
plot modules for every data frame provided in a list. This is ideal for
side-by-side comparison of different genomic datasets or clinical
cohorts.

## Usage

``` r
plotthis_DensityPlotApp(data_list)
```

## Arguments

- data_list:

  `list` A named list of data frames. Each list element will trigger the
  creation of a separate density plot module instance.

## Value

A Shiny app object that can be run locally or deployed to a server.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- plotthis_DensityPlotApp(data_list)
if (interactive()) runApp(app)
```
