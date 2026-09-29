# Launch the VizModules module gallery

Builds the **VizModules Gallery**: one tab per plot module, each opening
on a bundled example dataset with the module's main features already
switched on (significance brackets, highlighted and labelled points, fit
lines, reference lines, annotation tracks and splits, and so on), plus a
**Figure Builder** tab for composing several modules into one
multi-panel figure and exporting it as an editable SVG.

## Usage

``` r
moduleGalleryApp(title = "VizModules Gallery", return_components = FALSE)
```

## Arguments

- title:

  A character string used as the navbar title and page title.

- return_components:

  Logical. When `FALSE` (the default) a
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
  object is returned. When `TRUE` a named list with `ui` and `server`
  elements is returned instead, which is convenient for deployment
  scripts that need an explicit `shinyApp(ui, server)` call.

## Value

Either a
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object, or (when `return_components = TRUE`) a list with elements `ui`
and `server`.

## Details

Every tab carries the module's full set of controls and a filterable
data table beneath the plot, so the gallery doubles as a tour of what
each module can do. The example settings each tab opens on are the same
ones the module's own `*App()` function (e.g.
[`plotthis_BoxPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.md))
and the Figure Builder start from, so any of them can be reproduced by
passing the same `defaults` to the module in your own app.

The **Heatmap** tab needs the Bioconductor packages ComplexHeatmap,
InteractiveComplexHeatmap and circlize, and is left out when they are
not installed.

The Figure Builder tab embeds
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md)
/
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md)
on the bundled example datasets. To run a standalone Figure Builder, or
one on your own datasets or modules, use
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md).

## See also

[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md),
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
app <- moduleGalleryApp()
if (interactive()) runApp(app)

# The UI and server separately, e.g. for a deployment app.R:
parts <- moduleGalleryApp(return_components = TRUE)
if (interactive()) shinyApp(parts$ui, parts$server)
```
