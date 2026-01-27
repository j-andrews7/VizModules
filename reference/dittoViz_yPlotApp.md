# Create an example Modular yPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
dittoViz_yPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which yPlot modules will be created.
  That is, UI inputs and a y plot will be generated for each.

## Value

A Shiny app object.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
data <- data.frame(
    group = rep(LETTERS[1:4], each = 50),
    value = c(rnorm(50, mean = 5), rnorm(50, mean = 10), 
              rnorm(50, mean = 7), rnorm(50, mean = 12)),
    category = sample(c("Type1", "Type2"), 200, replace = TRUE)
)
data_list <- list("test_data" = data)
app <- dittoViz_yPlotApp(data_list)
#> Error in materialSwitch(ns("auto.update"), "Auto Update", value = FALSE,     size = "mini", status = "success"): unused argument (size = "mini")
if (interactive()) runApp(app)
```
