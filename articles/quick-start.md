# Quick Start with vizModules

## See the modules

Start with the hosted gallery to explore what each module can do:
<https://j-andrews7-vizmodules.share.connect.posit.cloud/>

You can also run the same gallery locally from this package:

``` r
library(shiny)
shiny::runApp(system.file("apps/module-gallery", package = "vizModules"))
```

## Drop a module into your app

All modules follow the same pattern: `*InputsUI()` for controls,
`*OutputUI()` for the plot, and `*Server()` for the logic. Here is a
minimal `scatterPlot` example:

``` r
library(shiny)
library(vizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            scatterPlotInputsUI("cars",
                mtcars,
                defaults = list(
                    x.by = "wt",
                    y.by = "mpg",
                    color.by = "cyl"
                )
            )
        ),
        mainPanel(scatterPlotOutputUI("cars"))
    )
)

server <- function(input, output, session) {
    scatterPlotServer("cars", data = reactive(mtcars))
}

shinyApp(ui, server)
```

Replace `scatterPlot` with any other module name (e.g., `AreaPlot`,
`BarPlot`, `BoxPlot`, `linePlot`, `piePlot`, `volcanoPlot`) to swap the
visualization.

## Set defaults and hide controls

- **Defaults**: Pass a named list to the `defaults` argument of
  `*InputsUI()` to pre-fill inputs. Names match the underlying plot
  function arguments (e.g.,
  `defaults = list(fill.color = "steelblue")`).
- **Hide inputs**: Use `hide.inputs` in the server call to remove
  controls while still initializing their values. This is useful when
  your app sets certain parameters itself.
- **Hide tabs**: Use `hide.tabs` to remove whole groups of controls
  (e.g., `"Plotly"` or `"Legend/Scale"` in `scatterPlot`).

``` r
scatterPlotServer(
    "cars",
    data = reactive(mtcars),
    hide.inputs = c("split.by", "rows.use"),
    hide.tabs = c("Plotly")
)
```

Hidden inputs and tabs still feed their values into the plot, so the
module stays fully configured while exposing only what your users need.

## Which plot parameters are exposed?

Modules wrap plotting functions from **dittoViz** and **plotthis**. To
see which arguments are available in a module:

1.  Open the module input help page, e.g.,
    [`?scatterPlotInputsUI`](https://j-andrews7.github.io/vizModules/reference/scatterplotInputsUI.md)
    or
    [`?AreaPlotInputsUI`](https://j-andrews7.github.io/vizModules/reference/areaPlotInputsUI.md).
    The **Details** section notes which arguments from the underlying
    plot function are wired through and any that are intentionally
    omitted.
2.  Cross-reference the base plot documentation
    ([`?dittoViz::scatterPlot`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
    [`?plotthis::AreaPlot`](https://pwwang.github.io/plotthis/reference/AreaPlot.html),
    etc.). Input names in `defaults` line up with those function
    arguments when they are supported.

If an argument is listed as missing or non-functional in the module
docs, it has been intentionally hidden because it does not round-trip
well in the interactive Plotly output.
