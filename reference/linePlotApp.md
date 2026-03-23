# Create an example Modular linePlot Shiny Application

This function generates a Shiny application with modular
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive line plot.

## Usage

``` r
linePlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("sales" = gallery_sales)` is used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`gallery_sales` as an example dataset. Uploaded data files are added to
the available datasets and can be selected for plotting. If an uploaded
file shares a name with an existing dataset, the existing one is
overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

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
# Launch with default example data (gallery_sales):
app <- linePlotApp()
#> Error in linePlotApp(): object 'gallery_sales' not found
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- linePlotApp(list("sales" = gallery_sales))
#> Error: object 'gallery_sales' not found
if (interactive()) runApp(app2)
```
