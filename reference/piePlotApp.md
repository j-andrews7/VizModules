# Create an example Modular piePlot Shiny Application

This function generates a Shiny application with modular piePlot
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
piePlotApp(data_list)
```

## Arguments

- data_list:

  A named list of summary data frames (one row per slice) for which
  piePlot modules will be created. That is, UI inputs and a pie plot
  will be generated for each. Each data frame should already contain a
  label column and an aggregated numeric value column.

## Value

A Shiny app object.

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md),
[`piePlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotInputsUI.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md),
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
sales_summary <- aggregate(revenue ~ region, example_sales, sum)
population_summary <- aggregate(count ~ age_group, example_population, sum)
data_list <- list("sales" = sales_summary, "population" = population_summary)
app <- piePlotApp(data_list)
if (interactive()) runApp(app)
```
