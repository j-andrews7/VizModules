# Create an example Modular BoxPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
plotthis_BoxPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which BoxPlot modules will be created.
  That is, UI inputs and a box plot will be generated for each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data <- data.frame(
    x = rep(LETTERS[1:8], each = 40),
    y = c(rnorm(160), rnorm(160, mean = 1)),
    group1 = sample(c("g1", "g2"), 320, replace = TRUE),
    group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
)
data_list <- list("test_data" = data)
app <- plotthis_BoxPlotApp(data_list)
#> Error in materialSwitch(ns("stack"), "Stack Plot: ", value = FALSE, onLabel = "Stacked",     offLabel = "Not Stacked", status = "success"): unused arguments (onLabel = "Stacked", offLabel = "Not Stacked")
if (interactive()) runApp(app)
```
