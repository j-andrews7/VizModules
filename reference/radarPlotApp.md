# Create an example Modular radarPlot Shiny Application

This function generates a Shiny application with modular radarPlot
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
radarPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which radarPlot modules will be
  created. That is, UI inputs and a radar plot will be generated for
  each. Each data frame should contain columns for categories (theta)
  and values (r). For multiple traces, include a grouping column.

## Value

A Shiny app object.

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`radarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotInputsUI.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)

# Single trace example
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
    value = c(8, 6, 7, 9, 8)
)

# Multiple trace example
team_stats <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Speed"), 2),
    value = c(8, 6, 7, 9, 8, 5, 9, 8, 6, 5),
    player = rep(c("Player A", "Player B"), each = 5)
)

data_list <- list("skills" = skills, "team" = team_stats)
app <- radarPlotApp(data_list)
if (interactive()) runApp(app)
```
