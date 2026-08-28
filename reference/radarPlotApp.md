# Create an example Modular radarPlot Shiny Application

This function generates a Shiny application with modular radarPlot
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive radar plot.

## Usage

``` r
radarPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("skills" = example_skills)` is used. Each data frame should
  contain columns for categories (theta) and values (r). For multiple
  traces, include a grouping column.

- defaults:

  A named list of input IDs and their default values to apply on
  startup. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
  to have the input follow the parent app's state; see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md).

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used, but the controls are not shown in the UI.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`example_skills` as an example dataset. Uploaded data files are added to
the available datasets and can be selected for plotting. If an uploaded
file shares a name with an existing dataset, the existing one is
overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`radarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotInputsUI.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- radarPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
skills <- data.frame(
    entity = c(
        rep("Player A", 6),
        rep("Player B", 6),
        rep("Player C", 6),
        rep("Player D", 6)
    ),
    category = rep(c("Pace", "Shooting", "Passing", "Dribbling", "Defending", "Physical"), 4),
    value = c(
        99, 89, 80, 92, 36, 78,
        89, 97, 65, 72, 45, 95,
        76, 86, 94, 86, 64, 78,
        62, 60, 71, 63, 94, 91
    )
)
app2 <- radarPlotApp(list("skills" = skills))
if (interactive()) runApp(app2)
```
