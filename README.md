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
- See the vignette for a full walkthrough: [`vignette("quick-start", package = "VizModules")`][18]

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

## App Factory

Need a quick standalone app for any module? `createModuleApp()` is a factory that wires up data import, a filterable data table, dataset switching, and the module's UI/server:

```r
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

Every built-in `*App()` convenience function (e.g. `plotthis_BarPlotApp()`, `linePlotApp()`) is a thin wrapper around `createModuleApp()` with sensible default data. You can also pass your own custom wrapper module functions to `createModuleApp()` for rapid prototyping.


## Building Custom Wrapper Modules

The modules in **VizModules** are designed to be composed and extended. You can build higher-level modules that add custom logic while reusing the full functionality of the base modules.


**Key points when building wrapper modules:**

1. **Namespace handling**: Use `NS(id)` for your wrapper's custom inputs, and pass the bare `id` (not namespaced) to the base module's UI and server functions.

2. **Data processing pattern**: Process your data inside a `moduleServer()` block to access your wrapper's namespaced inputs, then call the base module's server function *outside* that block to avoid double-namespacing.

3. **Reactive data**: Always pass reactive expressions to both your wrapper and the underlying module servers.

For more details, see [`vignette("custom-modules", package = "VizModules")`.][17]

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
* `radarPlot` - Radar Plot 
* `parallelCoordinatePlot` 
* `ternaryPlot`
* `dumbbellPlot`
* `volcanoPlot` - Volcano plots for differential expression analysis (extends `dittoViz_scatterPlot`).

## Modules Planned

### `dittoViz`

* **scatterHex** - hexbin plots encoding density/frequency information along x/y coordinates.
* **barPlot** - compositional barplots.
* **freqPlot** - box/jitter plots for discrete observation frequencies per sample/group.

dittoViz is under active development, so additional modules will be created as more visualization functions are added.

## Contributing a New Module

To contribute a new module to the package, see the vignette for guidelines: [`vignette("adding-a-new-module", package = "VizModules")`][16]


## Examples of Plots:

[linePlot:][1]

![](man/PlotImages/LinePlot.png)

[plotthis_AreaPlot:][2]

[(Source Plotting Function)][19]

![](man/PlotImages/AreaPlot.png)

[plotthis_BoxPlot:][3]

[(Source Plotting Function)][20]

![](man/PlotImages/BoxPlot.png)

[plotthis_DensityPlot:][4]

[(Source Plotting Function)][21]

![](man/PlotImages/DensityPlot.png)

[dumbellPlot:][5]

![](man/PlotImages/DumbellPlot.png)

[plotthis_HistogramPlot:][6]

[(Source Plotting Function)][21]

![](man/PlotImages/HistogramPlot.png)

[parallelCoordinatePlot:][7]

![](man/PlotImages/ParallelPlot.png)

[piePlot:][8]

![](man/PlotImages/PiePlot.png)

[radarPlot:][9]

![](man/PlotImages/RadarPlot.png)

[dittoViz_ScatterPlot:][10]

[(Source Plotting Function)][22]

![](man/PlotImages/ScatterPlot.png)

[plotthis_SplitBarPlot:][11]

[(Source Plotting Function)][23]

![](man/PlotImages/SplitBarPlot.png)

[ternaryPlot:][12]

![](man/PlotImages/ternaryPlot.png)

[plotthis_ViolinPlot:][13]

[(Source Plotting Function)][20]

![](man/PlotImages/ViolinPlot.png)

[dittoViz_yPlot:][14]

[(Source Plotting Function)][22]

![](man/PlotImages/yPlot.png)

### UI Overview:

![](man/PlotImages/UI_Overview.png)

Developed by [Jared Andrews](https://github.com/j-andrews7) and [Jacob Martin](https://github.com/Jacob1106)




[1]: https://j-andrews7.github.io/VizModules/reference/linePlotApp.html
[2]: https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotApp.html
[3]: https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.html
[4]: https://j-andrews7.github.io/VizModules/reference/plotthis_DensityPlotApp.html
[5]:https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.html
[6]:https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramApp.html
[7]:https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.html
[8]:https://j-andrews7.github.io/VizModules/reference/piePlotApp.html
[9]:https://j-andrews7.github.io/VizModules/reference/radarPlotApp.html
[10]:https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.html
[11]:https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.html
[12]:https://j-andrews7.github.io/VizModules/reference/ternaryPlotApp.html
[13]:https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotApp.html
[14]:https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.html
[15]: https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.html
[16]: https://j-andrews7.github.io/VizModules/articles/adding-a-new-module.html
[17]: https://j-andrews7.github.io/VizModules/articles/custom-modules.html
[18]: https://j-andrews7.github.io/VizModules/articles/quick-start.html
[19]: https://pwwang.github.io/plotthis/reference/AreaPlot.html
[20]: https://pwwang.github.io/plotthis/reference/boxviolinplot.html
[21]: https://pwwang.github.io/plotthis/reference/densityhistoplot.html
[22]: https://cran.r-project.org/web/packages/dittoViz/refman/dittoViz.html
[23]: https://pwwang.github.io/plotthis/reference/barplot.html