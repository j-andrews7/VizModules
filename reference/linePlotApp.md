# Create an example Modular linePlot Shiny Application

This function generates a Shiny application with modular
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
components. The app features three tabs: a **Data Input** tab for
uploading Excel spreadsheets, a **Table** tab for viewing and editing
the active dataset, and a **Plots** tab for configuring and displaying
an interactive line plot.

## Usage

``` r
linePlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("iris" = iris, "mtcars" = mtcars)` is used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`iris` and `mtcars` as example datasets. Uploaded Excel files are added
to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

## See also

[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md),
[`linePlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotInputsUI.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md),
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data (iris & mtcars):
app <- linePlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- linePlotApp(list("cars" = mtcars))
if (interactive()) runApp(app2)
```
