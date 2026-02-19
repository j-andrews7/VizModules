# VizModules

<!-- badges: start -->
[![R-CMD-check](https://github.com/j-andrews7/VizModules/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/R-CMD-check.yaml)
[![Tests](https://github.com/j-andrews7/VizModules/actions/workflows/check-app.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/check-app.yaml)
[![pkgdown](https://github.com/j-andrews7/VizModules/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

This package utilizes various viz packages (currently [dittoViz](https://github.com/dtm2451/dittoViz) and [plotthis](https://github.com/pwwang/plotthis)) to create interactivity-first Shiny modules for common plot types, designed to serve as building blocks for Shiny apps and as the basis for more complex/specialized modules.

These modules will contain all possible functionality for each plot with some additional parameters that make use of the interactive features of plotly, e.g. interactive text annotations, arbitrary shape annotations, multiple download formats, etc.

The modules provide comprehensive plot control for app users, allowing for convenient aesthetic customizations and publication-quality images.
They also provide developers a way to dramatically save time and reduce complexity of their plotting code or a flexible base to build more specialized Shiny modules upon.

## Install

Note that this package is in development and may break at any time.

Currently, the package can be installed from Github:

```r
devtools::install_github("j-andrews7/VizModules")
```

## Quick Start

- Explore the hosted gallery: <https://j-andrews7-vizmodules.share.connect.posit.cloud/>
- Run the same gallery locally: `shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))`
- See the vignette for a full walkthrough: `vignette("quick-start", package = "VizModules")`
- Learn about colour picker inputs: `vignette("colour-pickers", package = "VizModules")`

```r
library(VizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            dittoViz_ScatterPlotInputsUI(
                "cars",
                mtcars,
                defaults = list(
                    x.by = "wt",
                    y.by = "mpg",
                    color.by = "cyl"
                )
            )
        ),
        mainPanel(dittoViz_ScatterPlotOutputUI("cars"))
    )
)

server <- function(input, output, session) {
    dittoViz_ScatterPlotServer(
        "cars",
        data = reactive(mtcars),
        hide.inputs = c("rows.use"),
        hide.tabs = c("Plotly")
    )
}

shinyApp(ui, server)
```

Every module uses the same trio of functions: `*InputsUI()` for controls, `*OutputUI()` for the plot, and `*Server()` for the logic. Use `defaults` to pre-fill inputs, and `hide.inputs`/`hide.tabs` to hide controls while keeping their values so you can enforce app-level defaults without exposing them.

Modules built on plotting functions from other packages expose most of the underlying arguments. The module input help pages (e.g., `?dittoViz_ScatterPlotInputsUI`, `?plotthis_AreaPlotInputsUI`) list what is wired through and any omissions; cross-reference the underlying plot docs (`?dittoViz::scatterPlot`, `?plotthis::AreaPlot`, etc.) to see the full parameter set.

## Using **VizModules** 

Including a VizModules module in your Shiny application is simple. 
The package provides a function returning an example Shiny application for each module that showcases their functionality and how they can be used.

As an example, we can look at the `dittoViz_ScatterPlotApp()` function:

```r
library(VizModules)

dittoViz_ScatterPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    # UI definition
    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular scatterPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        scatterPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(dittoViz_ScatterPlotOutputUI(name), br())
                })
            )
        )
    )

    # Server function
    server <- function(input, output, session) {

        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            dittoViz_ScatterPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    # Return the Shiny app
    shinyApp(ui, server)
}

data_list <- list("mtcars" = mtcars, "iris" = iris)
dittoViz_ScatterPlotApp(data_list)
```

## Building Custom Wrapper Modules

The modules in **VizModules** are designed to be composed and extended. You can build higher-level modules that add custom logic while reusing the full functionality of the base modules.

Here's a minimal example of wrapping the `dittoViz_ScatterPlot` module to add custom filtering logic:

```r
library(VizModules)

# Define the wrapper UI
minimalWrapperUI <- function(id) {
    ns <- NS(id)
    tagList(
        h4("Minimal Wrapper Controls"),
        checkboxInput(ns("filter_setosa"), "Start with Setosa Only", value = FALSE),
        hr(),
        dittoViz_ScatterPlotInputsUI(id, iris)
    )
}

minimalWrapperOutput <- function(id) {
    dittoViz_ScatterPlotOutputUI(id)
}

# Define the wrapper server
minimalWrapperServer <- function(id, data_reactive) {
    # 1. Process data in a moduleServer block to access inputs namespaced to 'id'
    # We return the reactive expression produced by this block.
    # Note: moduleServer returns the return value of the function it runs.
    filtered_data <- moduleServer(id, function(input, output, session) {
        reactive({
            req(data_reactive())
            df <- data_reactive()

            # Custom wrapper logic: filter based on a checkbox
            if (isTRUE(input$filter_setosa)) {
                if ("Species" %in% names(df)) {
                    df <- df[df$Species == "setosa", ]
                }
            }
            df
        })
    })

    # 2. Call the base module server with the processed data.
    # We call this OUTSIDE the first moduleServer closure so that
    # dittoViz_ScatterPlotServer attaches to 'id' relative to the parent,
    # avoiding nested namespace issues (e.g. id-id-input).
    dittoViz_ScatterPlotServer(id, filtered_data)
}

# Create the app using the wrapper
ui <- fluidPage(
    titlePanel("Minimal Wrapper Example"),
    sidebarLayout(
        sidebarPanel(
            minimalWrapperUI("demo")
        ),
        mainPanel(
            minimalWrapperOutput("demo")
        )
    )
)

server <- function(input, output, session) {
    minimalWrapperServer("demo", reactive({ iris }))
}

shinyApp(ui, server)
```

**Key points when building wrapper modules:**

1. **Namespace handling**: Use `NS(id)` for your wrapper's custom inputs, and pass the bare `id` (not namespaced) to the base module's UI and server functions.

2. **Data processing pattern**: Process your data inside a `moduleServer()` block to access your wrapper's namespaced inputs, then call the base module's server function *outside* that block to avoid double-namespacing.

3. **Reactive data**: Always pass reactive expressions to both your wrapper and the underlying module servers.

For more details, see `vignette("custom-modules", package = "VizModules")`. To understand how colour picker inputs work in modules, see `vignette("colour-pickers", package = "VizModules")`.

## Modules Provided

Currently, **VizModules** contains a functional Shiny module for the following visualization functions:

### `dittoViz`

* `dittoViz_scatterPlot` - x/y coordinate plots with additional color and shape encodings (wraps `dittoViz::scatterPlot`).
* `dittoViz_yPlot` - Multi-variate Y-axis plots (wraps `dittoViz::yPlot`).

### `plotthis`

* `plotthis_AreaPlot` - Stacked area charts (wraps `plotthis::AreaPlot`).
* `plotthis_ViolinPlot` - Violin plots (wraps `plotthis::ViolinPlot`).
* `plotthis_BoxPlot` - Box plots (wraps `plotthis::BoxPlot`).
* `plotthis_BarPlot` - Bar charts (wraps `plotthis::BarPlot`).
* `plotthis_SplitBarPlot` - Split bar charts (wraps `plotthis::SplitBarPlot`).
* `plotthis_DensityPlot` - Density plots (wraps `plotthis::DensityPlot`).
* `plotthis_Histogram` - Histograms (wraps `plotthis::Histogram`).

### Defined in VizModules

* `linePlot` - Line plots with customizable trajectories.
* `piePlot` - Pie and donut charts.
* `volcanoPlot` - Volcano plots for differential expression analysis (extends `dittoViz_scatterPlot`).

## Modules Planned

### `dittoViz`

* **yPlot** - box/violin/jitter plots.
* **scatterHex** - hexbin plots encoding density/frequency information along x/y coordinates.
* **barPlot** - compositional barplots.
* **freqPlot** - box/jitter plots for discrete observation frequencies per sample/group.

dittoViz is under active development, so additional modules will be created as more visualization functions are added.

## Contributing a New Module

To contribute a new module to the package, see the vignette for guidelines: `vignette("adding-a-new-module", package = "VizModules")`.
