# Quick Start with VizModules

## See the modules

Start with the hosted gallery to explore what each module can do:
<https://j-andrews7-VizModules.share.connect.posit.cloud/>

You can also run the same gallery locally from this package:

``` r

library(shiny)
shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))
```

## Drop a module into your app

All modules follow the same pattern: `*InputsUI()` for controls,
`*OutputUI()` for the plot, and `*Server()` for the logic. Here is a
minimal scatter plot example using the `dittoViz_scatterPlot` module:

``` r

library(VizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            dittoViz_scatterPlotInputsUI("cars",
                mtcars,
                defaults = list(
                    x.by = "wt",
                    y.by = "mpg",
                    color.by = "cyl"
                )
            )
        ),
        mainPanel(dittoViz_scatterPlotOutputUI("cars"))
    )
)

server <- function(input, output, session) {
    dittoViz_scatterPlotServer("cars", data = reactive(mtcars))
}

shinyApp(ui, server)
```

## Set defaults and hide controls

- **Defaults**: Pass a named list to the `defaults` argument of
  `*InputsUI()` to pre-fill inputs. Names match the underlying plot
  function arguments (e.g.,
  `defaults = list(fill.color = "steelblue")`).
- **Hide inputs**: Use `hide.inputs` in the server call to remove
  controls while still initializing their values. This is useful when
  your app sets certain parameters itself or wants to hide control of
  various elements while still passing their initial values.
- **Hide tabs**: Use `hide.tabs` to remove whole groups of controls
  (e.g., `"Plotly"` or `"Legend"` in `scatterPlot`).

``` r

dittoViz_scatterPlotServer(
    "cars",
    data = reactive(mtcars),
    hide.inputs = c("split.by", "rows.use"),
    hide.tabs = c("Plotly")
)
```

Hidden inputs and tabs still feed their values into the plot, so the
module stays fully configured while exposing only what your users need.

## App factory with `createModuleApp()`

To enable simple, consistent testing of any module, we provide an app
factory function that returns a full standalone app with data import, a
filterable data table, and dataset switching for any module -
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md):

``` r

library(VizModules)

app <- createModuleApp(
    inputs_ui_fn = plotthis_BarPlotInputsUI,
    output_ui_fn = plotthis_BarPlotOutputUI,
    server_fn    = plotthis_BarPlotServer,
    data_list    = list("cars" = mtcars),
    title        = "My Bar Plot"
)
if (interactive()) runApp(app)
```

All built-in `*App()` convenience functions
(e.g. [`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md))
are thin wrappers around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)
with sensible default data. You can also pass custom wrapper module
functions to
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)
for rapid prototyping.

## Export Summary Data

We provide
[`collect_source_data()`](https://j-andrews7.github.io/VizModules/reference/collect_source_data.md)
to assemble a compact record of the plotted data, stats, UI inputs, and
the rendered plot, and
[`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md)
to turn that record into a downloadable `.zip`.
[`collect_source_data()`](https://j-andrews7.github.io/VizModules/reference/collect_source_data.md)
requires a reactive plotly plot; the output summary can be optionally
enriched by both a stats reactive and a UI inputs reactive.
[`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md)
also accepts a named list of summaries (one per plot), which is how the
Panel Builder bundles every plot on its canvas into a single download.

``` r


if (interactive()) {
    library(shiny)
    library(plotly)

    ui <- fluidPage(
        plotlyOutput("plot"),
        downloadButton("download_summary", "Download Summary")
    )

    server <- function(input, output, session) {
        # A reactive plotly plot
        plot_reactive <- reactive({
            plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
        })

        # Optional: a reactive returning a stats data.frame
        stats_reactive <- reactive({
            data.frame(
                metric = c("mean_mpg", "sd_mpg"),
                value  = c(mean(mtcars$mpg), sd(mtcars$mpg))
            )
        })

        # Optional: capture all UI inputs as a named list
        AllInputs <- reactive({
            reactiveValuesToList(input)
        })

        output$plot <- renderPlotly(plot_reactive())

        # Assemble the summary, then wire up the download handler.
        plot_summary_reactive <- reactive({
            collect_source_data(
                plot_reactive   = plot_reactive,
                stats_reactive  = stats_reactive,
                inputs_reactive = AllInputs()
            )
        })

        output$download_summary <- create_source_download_handler(
            data_list     = plot_summary_reactive,
            filename_base = "my_plot_summary"
        )
    }

    shinyApp(ui, server)
}
```

## Which plot parameters are exposed?

Modules wrap plotting functions from **dittoViz**, **plotthis**, and
native plotting functions. To see which arguments are available in a
module:

1.  Open the module input help page, e.g.,
    [`?dittoViz_scatterPlotInputsUI`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md)
    or
    [`?plotthis_AreaPlotInputsUI`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotInputsUI.md).
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
