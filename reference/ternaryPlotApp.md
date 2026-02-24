# Create an example Modular ternaryPlot Shiny Application

This function generates a Shiny application with modular ternaryPlot
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
ternaryPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which ternaryPlot modules will be
  created. That is, UI inputs and a ternary plot will be generated for
  each. Each data frame should contain numeric columns for the three
  ternary axes (a, b, c). For multiple traces, include a grouping
  column.

## Value

A Shiny app object.

## See also

[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md),
[`ternaryPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotInputsUI.md),
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md),
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)

# Single trace example
journalist <- c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20)
developer <- c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10)
designer <- c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70)
label <- c("point 1", "point 2", "point 3", "point 4", "point 5", "point 6",
           "point 7", "point 8", "point 9", "point 10", "point 11")

df <- data.frame(journalist, developer, designer, label)

# Multiple trace example
team_data <- data.frame(
    journalist = c(75, 70, 75, 5, 10, 10),
    developer = c(25, 10, 20, 60, 80, 90),
    designer = c(0, 20, 5, 35, 10, 0),
    team = rep(c("Team A", "Team B"), each = 3)
)

data_list <- list("roles" = df, "teams" = team_data)
app <- ternaryPlotApp(data_list)
#> Warning: Navigation containers expect a collection of `bslib::nav_panel()`/`shiny::tabPanel()`s and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. Consider using `header` or `footer` if you wish to place content above (or below) every panel's contents.
if (interactive()) runApp(app)
```
