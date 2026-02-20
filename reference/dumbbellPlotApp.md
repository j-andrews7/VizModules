# Create a Shiny App for Dumbbell Plots

Creates a Shiny application for generating interactive dumbbell plots.
This is a standalone app that demonstrates the dumbbellPlot module
functionality.

## Usage

``` r
dumbbellPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames to plot. Each data frame will get its own
  set of inputs and output in the app.

## Value

A Shiny app object that can be run with
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) or by
calling the function directly.

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md),
[`dumbbellPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotInputsUI.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md)

## Author

Jacob Martin

## Examples

``` r
if (FALSE) { # \dontrun{
data <- data.frame(
  School = c("MIT", "Stanford", "Harvard"),
  Women = c(94, 96, 112),
  Men = c(152, 151, 165),
  Group = c("A", "B", "A")
)
dumbbellPlotApp(list("School Earnings" = data))
} # }
```
