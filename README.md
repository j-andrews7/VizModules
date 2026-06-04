# VizModules

<!-- badges: start -->
[![R-CMD-check](https://github.com/j-andrews7/VizModules/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/R-CMD-check.yaml)
[![Tests](https://github.com/j-andrews7/VizModules/actions/workflows/check-app.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/check-app.yaml)
[![pkgdown](https://github.com/j-andrews7/VizModules/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/j-andrews7/VizModules/actions/workflows/pkgdown.yaml)
<!-- badges: end -->

This package utilizes various viz packages (currently [dittoViz](https://github.com/dtm2451/dittoViz) and [plotthis](https://github.com/pwwang/plotthis) along with native plotting functions) to create interactivity-first Shiny modules for common plot types, designed to serve as building blocks for Shiny apps and as the basis for more complex/specialized modules.

These modules contain all possible functionality for each plot with some additional parameters that make use of the interactive features of plotly, e.g. interactive text annotations, arbitrary shape annotations, multiple download formats, etc.

The modules provide comprehensive plot control for app users, allowing for convenient aesthetic customizations and publication-quality images.
They also provide developers a way to dramatically save time and reduce complexity of their plotting code or a flexible base to build more specialized Shiny modules upon.

## Install

```r
# CRAN
install.packages("VizModules")

# Development version
remotes::install_github("j-andrews7/VizModules")
```

## Quick Start

- Explore the hosted example gallery: <https://j-andrews7-vizmodules.share.connect.posit.cloud/>
- Run the same gallery locally after installation: `shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))`
- See the vignette for a full walkthrough: [`vignette("quick-start", package = "VizModules")`][18]

### Using Modules in Your Own App

To use a module in your own app, simply call the `*InputsUI()`, `*OutputUI()`, and `*Server()` functions for the module you want to use. For example, to use the ScatterPlot module from dittoViz, you would do something like this:

```r
library(VizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            dittoViz_scatterPlotInputsUI(
                "cars",
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
    dittoViz_scatterPlotServer(
        "cars",
        data = reactive(mtcars)
    )
}

shinyApp(ui, server)
```

Every module uses the same trio of functions: `*InputsUI()` for controls, `*OutputUI()` for the plot, and `*Server()` for the logic. The separation of InputsUI and OutputUI allows you to place input controls and the actual plot wherever you'd like.

Use `defaults` to pre-fill inputs, and `hide.inputs`/`hide.tabs` to hide controls while keeping their values so you can enforce app-level defaults without exposing them.

Modules built on plotting functions from other packages expose most of the underlying arguments. The module input help pages (e.g., `?dittoViz_scatterPlotInputsUI`, `?plotthis_AreaPlotInputsUI`) list what is wired through and any omissions; cross-reference the underlying plot docs (`?dittoViz::scatterPlot`, `?plotthis::AreaPlot`, etc.) to see the full parameter set.

### Example Apps for Each Module

Every module has a corresponding `*App()` function that creates a complete Shiny app showcasing the module's functionality with example data. For instance, `plotthis_BarPlotApp()` creates an app BarPlot module. You can run these apps directly to explore the module's features and see how it works in a full Shiny context.

```r
library(VizModules)
# Using built-in example data (or upload your own file in the app)
plotthis_BarPlotApp()

# Providing your own data
df <- data.frame(
    category = c("A", "B", "C"),
    value = c(10, 20, 15),
    group = c("X", "Y", "X")
)

plotthis_BarPlotApp(data = df)
```

## App Factory

Every built-in `*App()` convenience function (e.g. `plotthis_BarPlotApp()`, `linePlotApp()`) is a thin wrapper around `createModuleApp()` with sensible default data. You can also pass your own custom wrapper module functions to `createModuleApp()` for rapid prototyping after defining the UI and server functions.

```r
library(VizModules)

app <- createModuleApp(
    inputs_ui_fn = plotthis_BarPlotInputsUI,
    output_ui_fn = plotthis_BarPlotOutputUI,
    server_fn    = plotthis_BarPlotServer,
    data_list    = list("cars" = mtcars),
    title        = "My Bar Plot"
)

runApp(app)
```


## Building Custom Wrapper Modules

The modules in **VizModules** are designed to be composed and extended. You can build higher-level modules that add custom logic while reusing the full functionality of the base modules.

For more details, see [`vignette("custom-modules", package = "VizModules")`.][17]

## Modules Provided

Currently, **VizModules** contains a functional Shiny module for the following visualization functions:

### `dittoViz`

* `dittoViz_scatterPlot` - x/y coordinate plots with additional color and shape encodings (wraps `dittoViz::scatterPlot`).
* `dittoViz_yPlot` - Multi-variate Y-axis plots (boxplot, jitter, violinplots - wraps `dittoViz::yPlot`).

### `plotthis`

* `plotthis_AreaPlot` - Stacked area charts (wraps `plotthis::AreaPlot`).
* `plotthis_ViolinPlot` - Violin plots (wraps `plotthis::ViolinPlot`).
* `plotthis_BoxPlot` - Box plots (wraps `plotthis::BoxPlot`).
* `plotthis_BarPlot` - Bar charts (wraps `plotthis::BarPlot`).
* `plotthis_SplitBarPlot` - Split bar charts (wraps `plotthis::SplitBarPlot`).
* `plotthis_DensityPlot` - Density plots (wraps `plotthis::DensityPlot`).
* `plotthis_DotPlot` - Dot plots (wraps `plotthis::DotPlot`).
* `plotthis_Histogram` - Histograms (wraps `plotthis::Histogram`).

### Plotting Functions Defined in VizModules

Via direct implementation with plotly.

* `linePlot` - Line plots
* `piePlot` - Pie and donut plots
* `radarPlot` - Radar plots
* `parallelCoordinatesPlot` - Parallel coordinate plots
* `ternaryPlot` - Ternary plots
* `dumbbellPlot` - Dumbbell plots

## Statistical Testing

The **BoxPlot**, **ViolinPlot**, and **yPlot** modules include a **Stats** tab that adds pairwise statistical testing with bracket annotations directly on the plotly figure.

## Export Summary Data:

`create_interactive_summary_download_handler()' function to generate a compact zip folder of summary data for the outputed plot. Including summary statistics, plot data, UI input values, and the rendered plot. 

### Supported Tests

- **Pairwise**: Wilcoxon rank-sum test, t-test (paired or unpaired)
- **Omnibus**: Kruskal-Wallis, ANOVA

### Features

- Bracket annotations with capped or flat style, placed via an interval packing algorithm to minimize vertical space
- Multiple display modes: adjusted p-values, raw p-values, or significance symbols (`*`, `**`, `***`, `****`)
- P-value correction via any `p.adjust` method (Holm, Bonferroni, BH, etc.)
- Configurable significance threshold, bracket spacing, inset, and line styling
- Per-facet testing: run tests independently within each facet panel, or across the full dataset
- Nested grouping: compare `group.by` levels within each x-axis category
- Omnibus test results shown as a draggable text annotation
- Download computed statistics as a CSV with metadata header (correction method, threshold, symbol legend)

### Data Format for Paired Tests

When using paired tests (Wilcoxon signed-rank or paired t-test), each group must have the **same number of observations** in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.

## Modules Planned

### `dittoViz`

* **scatterHex** - hexbin plots encoding density/frequency information along x/y coordinates.
* **barPlot** - compositional barplots.
* **freqPlot** - box/jitter plots for discrete observation frequencies per sample/group.

[dittoViz](https://github.com/dtm2451/dittoViz) is under active development, so additional modules may be added as more visualization functions are added.

## Contributing a New Module

To contribute a new module to the package, see the vignette for clear guidelines: [`vignette("adding-a-new-module", package = "VizModules")`][16]


## Available Modules

[linePlot:][1]

![](man/figures/LinePlot.png)

[plotthis_AreaPlot:][2]

[(Source Plotting Function)][19]

![](man/figures/AreaPlot.png)

[plotthis_BoxPlot:][3]

[(Source Plotting Function)][20]

![](man/figures/BoxPlot.png)

[plotthis_DensityPlot:][4]

[(Source Plotting Function)][21]

![](man/figures/DensityPlot.png)

[dumbbellPlot:][5]

![](man/figures/DumbellPlot.png)

[plotthis_Histogram:][6]

[(Source Plotting Function)][21]

![](man/figures/HistogramPlot.png)

[parallelCoordinatesPlot:][7]

![](man/figures/ParallelPlot.png)

[piePlot:][8]

![](man/figures/PiePlot.png)

[radarPlot:][9]

![](man/figures/RadarPlot.png)

[dittoViz_ScatterPlot:][10]

[(Source Plotting Function)][22]

![](man/figures/ScatterPlot.png)

[plotthis_SplitBarPlot:][11]

[(Source Plotting Function)][23]

![](man/figures/SplitBarPlot.png)

[ternaryPlot:][12]

![](man/figures/ternaryPlot.png)

[plotthis_ViolinPlot:][13]

[(Source Plotting Function)][20]

![](man/figures/ViolinPlot.png)

[dittoViz_yPlot:][14]

[(Source Plotting Function)][22]

![](man/figures/yPlot.png)

plotthis::DotPlot:

![](man/figures/DotPlot.png)

### UI Example

![](man/figures/UI_Overview.png)

## AI Usage Statement
The developers made use of AI tools (e.g. GitHub Copilot, Claude Code) for code generation, documentation writing, and test creation.
AI assistance was used to accelerate development after the initial module scaffolding and structure was in place, but all AI-generated content was reviewed and edited by human eyeballs to ensure accuracy and quality.
Our own hands are all over this project, and we are invested in it. 
Any inaccuracies, bugs, or issues are attributable to us, and we welcome contributions to help improve the package.

Generative AI tools (GitHub Copilot, ChatGPT, Claude, Gemini, Cursor, etc.) are **explicitly welcome** for building Shiny apps with these modules in addition to creating new modules. To do so, we recommend prefixing prompts with the below to aid LLM usage (or adding it to a file and attaching it directly).

### LLM Instructions

Copy the prompt below into your LLM or save it in a file (Copilot, ChatGPT, Claude, Gemini, Cursor, etc.) before asking it to build a Shiny app with **VizModules**. It points the model to the authoritative, locally-installed sources of truth so it can use the package correctly.

> You are helping me build a Shiny application using the installed R package **VizModules**, which provides interactivity-first, plotly-based Shiny modules for common plot types. Before writing code, ground yourself in the package's own documentation rather than guessing at the API.
>
> **Core concept.** Every module is a trio of functions that share an `id`: `*InputsUI(id, ...)` renders the controls, `*OutputUI(id)` renders the plotly output, and `*Server(id, data, ...)` holds the logic. `InputsUI` and `OutputUI` are separate so controls and plot can be placed anywhere in the layout. `data` is passed to the server as a `reactive()`. Use the `defaults` argument to pre-fill inputs and `hide.inputs`/`hide.tabs` to lock values while hiding their controls.
>
> **Where to look (all available after `install.packages`/`remotes::install_github`):**
> - `vignette("quick-start", package = "VizModules")` — start here: end-to-end walkthrough of wiring `*InputsUI()`, `*OutputUI()`, and `*Server()` into an app, using `defaults`, and the example `*App()` functions.
> - `vignette("custom-modules", package = "VizModules")` — how to **extend existing modules** by building wrapper modules (adding custom logic/inputs while reusing a base module). Follow the namespace pattern: process namespaced inputs *inside* `moduleServer()`, then call the base `*Server()` *outside* it with the bare `id` to avoid double-namespacing.
> - `vignette("adding-a-new-module", package = "VizModules")` — how to **author a brand-new module** from scratch (the InputsUI/OutputUI/Server contract, conventions, and helpers).
> - The README — overview, install, the full list of available modules, the App Factory (`createModuleApp()`), statistical-testing features, and summary-data export.
> - Per-function help pages via `?` — e.g. `?dittoViz_scatterPlotInputsUI`, `?plotthis_BarPlotServer`, `?createModuleApp`. Module help pages document exactly which underlying arguments are wired through and any omissions. Cross-reference the underlying plotting docs (`?dittoViz::scatterPlot`, `?plotthis::AreaPlot`, etc.) for the complete parameter set. Browse all docs with `help(package = "VizModules")` or the pkgdown site: <https://j-andrews7.github.io/VizModules/reference/>.
> - `NEWS.md` (`news(package = "VizModules")`) — newest features and changes.
>
> **Available modules:** `dittoViz_scatterPlot`, `dittoViz_yPlot`, `plotthis_AreaPlot`, `plotthis_ViolinPlot`, `plotthis_BoxPlot`, `plotthis_BarPlot`, `plotthis_SplitBarPlot`, `plotthis_DensityPlot`, `plotthis_DotPlot`, `plotthis_Histogram`, plus the natively-implemented `linePlot`, `piePlot`, `radarPlot`, `parallelCoordinatesPlot`, `ternaryPlot`, and `dumbbellPlot`. Each has a matching `*App()` function (e.g. `plotthis_BarPlotApp()`) you can run to see it in action.
>
> **Optional building blocks** (inspect their source/help in the installed package's `R/` directory or via `?`):
> - Data table / filtering module — `?dataFilterUI`, `?dataFilterServer`.
> - Statistical testing helpers (pairwise + omnibus brackets on plotly figures) — see `?compute_pairwise_stats`, `?apply_stat_annotations`, and the README "Statistical Testing" section; supported by the BoxPlot, ViolinPlot, and yPlot modules.
> - Summary-data export — `?create_interactive_summary_download_handler`.
> - App factory — `?createModuleApp` (every `*App()` is a thin wrapper around it).
>
> **Rules:** All plots are plotly-based; prefer the documented module arguments over hand-rolled plotting. Verify function signatures against the installed help pages before using them, and tell me explicitly if a feature you need is not exposed by a module.


[1]: https://j-andrews7.github.io/VizModules/reference/linePlotApp.html
[2]: https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotApp.html
[3]: https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.html
[4]: https://j-andrews7.github.io/VizModules/reference/plotthis_DensityPlotApp.html
[5]: https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.html
[6]: https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramApp.html
[7]: https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.html
[8]: https://j-andrews7.github.io/VizModules/reference/piePlotApp.html
[9]: https://j-andrews7.github.io/VizModules/reference/radarPlotApp.html
[10]: https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.html
[11]: https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.html
[12]: https://j-andrews7.github.io/VizModules/reference/ternaryPlotApp.html
[13]: https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotApp.html
[14]: https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.html
[15]: https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.html
[16]: https://j-andrews7.github.io/VizModules/articles/adding-a-new-module.html
[17]: https://j-andrews7.github.io/VizModules/articles/custom-modules.html
[18]: https://j-andrews7.github.io/VizModules/articles/quick-start.html
[19]: https://pwwang.github.io/plotthis/reference/AreaPlot.html
[20]: https://pwwang.github.io/plotthis/reference/boxviolinplot.html
[21]: https://pwwang.github.io/plotthis/reference/densityhistoplot.html
[22]: https://cran.r-project.org/package=dittoViz
[23]: https://pwwang.github.io/plotthis/reference/barplot.html