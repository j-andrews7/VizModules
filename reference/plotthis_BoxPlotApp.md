# Create an example Modular BoxPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive box plot.

## Usage

``` r
plotthis_BoxPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("demographics" = gallery_demographics)` is used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`gallery_demographics` as an example dataset. Uploaded data files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- plotthis_BoxPlotApp()
#> Error in plotthis_BoxPlotApp(): object 'gallery_demographics' not found
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_BoxPlotApp(list("demographics" = gallery_demographics))
#> Error: object 'gallery_demographics' not found
if (interactive()) runApp(app2)
```
