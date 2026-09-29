# VizModules

This package utilizes various viz packages (currently
[dittoViz](https://github.com/dtm2451/dittoViz),
[plotthis](https://github.com/pwwang/plotthis), and
[ComplexHeatmap](https://bioconductor.org/packages/ComplexHeatmap/)
along with native plotting functions) to create interactivity-first
Shiny modules for common plot types, designed to serve as building
blocks for Shiny apps and as the basis for more complex/specialized
modules.

These modules contain all possible functionality for each plot with some
additional parameters that make use of the interactive features of
plotly, e.g. interactive text annotations, arbitrary shape annotations,
multiple download formats, etc.

The modules provide comprehensive plot control for app users, allowing
for convenient aesthetic customizations and publication-quality images.
They also provide developers a way to dramatically save time and reduce
complexity of their plotting code or a flexible base to build more
specialized Shiny modules upon.

**This package is still in an experimental state undergoing active
development. While each release should be stable and useable, breaking
changes may occur frequently between versions until a major 1.0.0
release is made.**

## Install

``` r

# CRAN
install.packages("VizModules")

# Development version
remotes::install_github("j-andrews7/VizModules")
```

## Quick Start

- Explore the hosted [example
  gallery](https://j-andrews7-vizmodules.share.connect.posit.cloud/).
  Each module opens on an example with its main features switched on
  (statistical comparisons, highlighted points, fit lines, annotations,
  and so on), and the **Figure Builder** tab shows how the modules
  combine into a free-form, multi-panel figure.
- Run the same gallery locally after installation:
  [`VizModules::moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.md)
- Run the Figure Builder on its own:
  [`VizModules::figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)
- See the vignette for a full walkthrough of using the modules in your
  own apps:
  [`vignette("quick-start", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/quick-start.html)

### Using Modules in Your Own App

To use a module in your own app, simply call the `*InputsUI()`,
`*OutputUI()`, and `*Server()` functions for the module you want to use.
For example, to use the ScatterPlot module from dittoViz, you would do
something like this:

``` r

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

Every module uses the same trio of functions: `*InputsUI()` for
controls, `*OutputUI()` for the plot, and `*Server()` for the logic. The
separation of InputsUI and OutputUI allows you to place input controls
and the actual plot wherever you’d like.

Use `defaults` to pre-fill inputs, and `hide.inputs`/`hide.tabs` to hide
controls while keeping their values so you can enforce app-level
defaults without exposing them. A `defaults` entry can also be a
[`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html), so an input
follows your app’s state without an extra re-render.

Modules built on plotting functions from other packages expose most of
the underlying arguments. The module input help pages (e.g.,
[`?dittoViz_scatterPlotInputsUI`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md),
[`?plotthis_AreaPlotInputsUI`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotInputsUI.md))
list what is wired through and any omissions; cross-reference the
underlying plot docs
([`?dittoViz::scatterPlot`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`?plotthis::AreaPlot`](https://pwwang.github.io/plotthis/reference/AreaPlot.html),
etc.) to see the full parameter set.

### Example Apps for Each Module

Every module has a corresponding `*App()` function that creates a
complete Shiny app showcasing the module’s functionality with example
data. For instance,
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md)
creates an app BarPlot module. You can run these apps directly to
explore the module’s features and see how it works in a full Shiny
context.

``` r

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

Every built-in `*App()` convenience function
(e.g. [`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md))
is a thin wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)
with sensible default data. You can also pass your own custom wrapper
module functions to
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)
for rapid prototyping after defining the UI and server functions. All
`*App()` wrappers and
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md)
accept `defaults`, `hide.inputs`, and `hide.tabs` so you can pre-fill or
hide controls when testing a module in isolation; see
[`vignette("defaults-and-hiding", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/defaults-and-hiding.html).

``` r

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

## Figure Builder

The **Figure Builder** is a fully reusable, namespaced Shiny module
([`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md)
/
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md))
that turns the plot modules into a free-form figure builder. It can be
launched as a standalone app, embedded inside a larger app, or even
instantiated more than once on a single page. It is also the **Figure
Builder** tab of the gallery
([`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.md),
or the [hosted
gallery](https://j-andrews7-vizmodules.share.connect.posit.cloud/)).
Launch the standalone app with
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md):

``` r

library(VizModules)

# Launch with the bundled example datasets and all modules
figureBuilderApp()

# Or seed it with your own datasets
figureBuilderApp(data_list = list("iris" = iris, "mtcars" = mtcars))
```

[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)
accepts `data_list` to seed datasets, `module_registry` to add custom
modules, and `return_components = TRUE` to get separate `ui`/`server`
objects instead of a
[`shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html). See
[`?figureBuilderApp`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)
for details.

The Figure Builder is also a self-contained Shiny module, so you can
embed it in a larger app (and even use more than one instance on a page)
with
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md)
/
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md),
just like the plot modules:

``` r

library(VizModules)

ui <- fluidPage(
    figureBuilderUI("figure_builder")
)

server <- function(input, output, session) {
    figureBuilderServer("figure_builder")
}

shinyApp(ui, server)
```

It allows you to interactively compose complicated figures using the
modules in a single page:

- **Add plots on demand.** Click *Add Plot* to drop any VizModule onto
  the canvas, choosing both the plot type and the dataset it should use.
- **Load your own data.** Use the *Load Data* section to upload a `CSV`,
  `TSV` or tab-delimited `TXT` file. Uploaded datasets are added to the
  dataset list so you can build plots from your own data alongside the
  bundled examples. Each plot can use a different dataset if desired.
- **Drag and resize.** Each plot lives on its own card. Hover a card to
  reveal a small toolbar with a drag handle (to reposition it) and a
  remove button, and resize it from its corner (via `shinyjqui`) —
  resizing adjusts the plot in both directions. The toolbar stays out of
  the way otherwise, so cards remain clean and chrome-free in the SVG
  export.
- **A4 canvas.** The canvas is sized to an A4 page (switchable between
  portrait and landscape), making it easy to lay plots out for a
  composite figure.
- **Swappable controls.** A single dropdown swaps the visible plot’s
  input controls in and out, so only one control set is shown at a time
  while every plot keeps its own settings.
- **Swappable filtering table.** A matching dropdown swaps the visible
  plot’s filterable data table, mirroring the controls behaviour.
  Filtering a plot’s table subsets only that plot’s data.
- **Download as SVG.** Click *Download Full Figure (SVG)* to export the
  whole canvas as a single vector SVG, with every plot positioned as it
  appears on the page. This allows downstream editing as necessary,
  though the hope is that you’ll be 95% of the way there with the
  formatting and syling options available in each module.
- **Automatic panel labels.** Use the *Panel labels* dropdown to add
  panel letters (`A`, `B`, `C`, … or lowercase `a`, `b`, `c`, …) to the
  top-left of each panel. Labels now render live on the canvas as soon
  as they are chosen (and renumber as panels are added, removed, or
  dragged), in addition to appearing in the SVG export. Labels are
  ordered the way a reader scans a figure — top-to-bottom by row, then
  left-to-right within a row. Choose *None* to leave the figure
  unlabelled.
- **Download source data.** Click *Download Summary* to download a
  single `.zip` containing all plot data (plot + data + the inputs used
  to build it + statistical testing information (if applied)) for every
  plot on the canvas, with one set of files per panel.

## Building Custom Wrapper Modules

The modules in **VizModules** are designed to be composed and extended.
You can build higher-level modules that add custom logic while reusing
the full functionality of the base modules. Many internal helpers for
axes, faceting, and layouts are now exported to support this, along with
the `defaults`/`hide.inputs`/`hide.tabs` controls covered in
[`vignette("defaults-and-hiding", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/defaults-and-hiding.html).

For more details, see
[`vignette("custom-modules", package = "VizModules")`.](https://j-andrews7.github.io/VizModules/articles/custom-modules.html)

## Custom Shiny Inputs

Beyond the standard `shiny::*Input` widgets, **VizModules** ships two
reusable custom Shiny inputs that are used throughout the package and
are available for your own apps:
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
and
[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md).
See
[`vignette("custom-shiny-inputs", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/custom-shiny-inputs.html)
for full details.

**[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)**
assigns a color to each level of a discrete variable, either by applying
a named palette to every group at once or by fine-tuning individual
groups with a color picker and an editable hex field. It returns a named
character vector of hex colors keyed by group and can be updated from
the server with
[`updateMultiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/updateMultiColorPicker.md).

![](reference/figures/multiColorPicker.png)

**[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)**
is a general-purpose widget that lets users dynamically add and remove
rows of heterogeneous inputs (e.g. a color, a numeric, and a select per
row). It returns a named list of rows and can be updated from the server
with
[`updateMultiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/updateMultiDynamicInput.md).

![](reference/figures/multiDynamicInput.png)

## Modules Provided

Currently, **VizModules** contains a functional Shiny module for the
following visualization functions:

### `dittoViz`

- `dittoViz_scatterPlot` - x/y coordinate plots with additional color
  and shape encodings (wraps
  [`dittoViz::scatterPlot`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)).
  Supports overlaying fit lines, including **multiple custom model
  lines** defined interactively: add a row per model, each with its own
  R model formula (e.g. `revenue ~ poly(units, 2)`), fitting function
  (`lm`, `glm`, `loess`, or a registered backend), line colour, and
  width, see
  [`vignette("custom-model-lines", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/custom-model-lines.html).
- `dittoViz_yPlot` - Multi-variate Y-axis plots (boxplot, jitter,
  violinplots - wraps
  [`dittoViz::yPlot`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)).
- `dittoViz_freqPlot` - Box/jitter plots for discrete observation
  frequencies per sample/group (wraps
  [`dittoViz::freqPlot`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)).

### `plotthis`

- `plotthis_AreaPlot` - Stacked area charts (wraps
  [`plotthis::AreaPlot`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)).
- `plotthis_BoxPlot` - Box plots (wraps
  [`plotthis::BoxPlot`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)).
- `plotthis_BarPlot` - Bar charts (wraps
  [`plotthis::BarPlot`](https://pwwang.github.io/plotthis/reference/barplot.html)).
- `plotthis_SplitBarPlot` - Split bar charts (wraps
  [`plotthis::SplitBarPlot`](https://pwwang.github.io/plotthis/reference/barplot.html)).
- `plotthis_DensityPlot` - Density plots (wraps
  [`plotthis::DensityPlot`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)).
- `plotthis_DotPlot` - Dot plots (wraps
  [`plotthis::DotPlot`](https://pwwang.github.io/plotthis/reference/dotplot.html)).
- `plotthis_Histogram` - Histograms (wraps
  [`plotthis::Histogram`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)).

### `ComplexHeatmap`

- `ComplexHeatmap_Heatmap` - Interactive heatmaps with row/column
  annotation tracks, clustering, and sub-heatmap zoom (wraps
  [`ComplexHeatmap::Heatmap`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)).
  This is the one module whose output is **not** plotly - it renders
  through
  [InteractiveComplexHeatmap](https://bioconductor.org/packages/InteractiveComplexHeatmap/),
  so the plotly-specific controls (the Plotly tab, download formats,
  draggable annotations) do not apply. It is also the one module whose
  `data` may be a list rather than a data frame: pass
  `data = list(matrix = <data.frame>, column_annotations = <data.frame>)`
  when you want column annotation tracks, where the companion table
  carries one row per sample column. `ComplexHeatmap`,
  `InteractiveComplexHeatmap`, and `circlize` are `Suggests` rather than
  hard dependencies, so install them with
  `BiocManager::install(c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize"))`
  before using this module.
  - The interactive output can also be split across
    [`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
    [`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
    and
    [`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)
    if you want the main heatmap, the sub-heatmap, and the click/brush
    info panel in separate places in your layout.

### Plotting Functions Defined in VizModules

Via direct implementation with plotly.

- `linePlot` - Line plots
- `piePlot` - Pie and donut plots
- `radarPlot` - Radar plots
- `parallelCoordinatesPlot` - Parallel coordinate plots
- `dumbbellPlot` - Dumbbell plots

## Statistical Testing

The **BoxPlot**, **yPlot**, and **freqPlot** modules include a **Stats**
tab that adds pairwise statistical testing with bracket annotations
directly on the plotly figure. On **freqPlot** the tests are always run
within each facet (the `stat.per.facet` control is hidden), since each
facet is a different level of the frequency variable and pooling across
them would compare non-comparable quantities. The underlying helpers
([`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md),
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md),
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_stat_annotations.md),
[`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/generate_pair_strings.md),
[`parse_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/parse_pair_strings.md))
are exported so you can add the same bracket annotations to any custom
plotly figure. See
[`vignette("statistical-testing", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/statistical-testing.html).

### Export Summary Data

[`collect_source_data()`](https://j-andrews7.github.io/VizModules/reference/collect_source_data.md)
collects the interactive plot as HTML, its plot data, pairwise testing
statistics (if applied), and UI input values into a single list, and
[`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md)
turns that into a compact zip folder of summary data for the output
plot. The zip also carries an SVG and a PNG of each plot, captured in
the browser so they match what is on screen — every reference line,
statistical bracket, and dragged annotation included.
[`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md)
also accepts a named list of summaries (one per plot), which is how the
Figure Builder bundles every plot on the canvas into one download.

### Supported Tests

- **Pairwise**: Wilcoxon rank-sum test, t-test (paired or unpaired)
- **Omnibus**: Kruskal-Wallis, ANOVA

### Features

- Bracket annotations with capped or flat style, placed via an interval
  packing algorithm to minimize vertical space
- Multiple display modes: adjusted p-values, raw p-values, or
  significance symbols (`*`, `**`, `***`, `****`)
- P-value correction via any `p.adjust` method (Holm, Bonferroni, BH,
  etc.)
- Configurable significance threshold, bracket spacing, inset, and line
  styling
- Per-facet testing: run tests independently within each facet panel, or
  across the full dataset
- Nested grouping: compare `group.by` levels within each x-axis category
- Omnibus test results shown as a draggable text annotation
- Download computed statistics as a CSV with metadata header (correction
  method, threshold, symbol legend)

### Data Format for Paired Tests

When using paired tests (Wilcoxon signed-rank or paired t-test), each
group must have the **same number of observations** in corresponding
order. Data should be sorted so that paired samples align row-by-row
within each group.

## Modules Planned

### `dittoViz`

- **scatterHex** - hexbin plots encoding density/frequency information
  along x/y coordinates.
- **barPlot** - compositional barplots.

[dittoViz](https://github.com/dtm2451/dittoViz) is under active
development, so additional modules may be added as more visualization
functions are added.

## Contributing a New Module

To contribute a new module to the package, see the vignette for clear
guidelines:
[`vignette("adding-a-new-module", package = "VizModules")`](https://j-andrews7.github.io/VizModules/articles/adding-a-new-module.html)

## Available Modules

[linePlot:](https://j-andrews7.github.io/VizModules/reference/linePlotApp.html)

![](reference/figures/LinePlot.png)

[plotthis_AreaPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/AreaPlot.html)

![](reference/figures/AreaPlot.png)

[plotthis_BoxPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)

![](reference/figures/BoxPlot.png)

[plotthis_DensityPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_DensityPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)

![](reference/figures/DensityPlot.png)

[dumbbellPlot:](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.html)

![](reference/figures/DumbbellPlot.png)

[plotthis_Histogram:](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)

![](reference/figures/HistogramPlot.png)

[parallelCoordinatesPlot:](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.html)

![](reference/figures/ParallelPlot.png)

[piePlot:](https://j-andrews7.github.io/VizModules/reference/piePlotApp.html)

![](reference/figures/PiePlot.png)

[radarPlot:](https://j-andrews7.github.io/VizModules/reference/radarPlotApp.html)

![](reference/figures/RadarPlot.png)

[dittoViz_ScatterPlot:](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.html)

[(Source Plotting
Function)](https://cran.r-project.org/package=dittoViz)

![](reference/figures/ScatterPlot.png)

[plotthis_BarPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/barplot.html)

![](reference/figures/BarPlot.png)

[plotthis_SplitBarPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/barplot.html)

![](reference/figures/SplitBarPlot.png)

[dittoViz_yPlot:](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.html)

[(Source Plotting
Function)](https://cran.r-project.org/package=dittoViz)

![](reference/figures/yPlot.png)

[plotthis_DotPlot:](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotApp.html)

[(Source Plotting
Function)](https://pwwang.github.io/plotthis/reference/dotplot.html)

![](reference/figures/DotPlot.png)

[dittoViz_freqPlot:](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotApp.html)

[(Source Plotting
Function)](https://cran.r-project.org/package=dittoViz)

![](reference/figures/FreqPlot.png)

[ComplexHeatmap_Heatmap:](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapApp.html)

[(Source Plotting
Function)](https://jokergoo.github.io/ComplexHeatmap-reference/book/)

![](reference/figures/Heatmap.png)

[figureBuilder:](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.html)

![](reference/figures/Figure_builder.png)

## AI Usage Statement

The developers made use of AI tools (e.g. GitHub Copilot, Claude Code)
for code generation, documentation writing, and test creation. AI
assistance was used to accelerate development after the initial module
scaffolding and structure was in place, but all AI-generated content was
reviewed and edited by human eyeballs/hands to ensure accuracy and
quality. Our own hands are all over this project, and we are invested in
it. Any inaccuracies, bugs, or issues are attributable to us, and we
welcome contributions to help improve the package.

Generative AI tools (GitHub Copilot, ChatGPT, Claude, Gemini, Cursor,
etc.) are **explicitly welcome** for building Shiny apps with these
modules in addition to creating new modules. To do so, we recommend the
use of the skills provided by the package detailed below.

### Agent Skills (GitHub Copilot, OpenAI Codex, Claude Code, and compatible tools)

The package provides three [Agent Skills](https://agentskills.io) that
give an agent the package’s conventions without it having to read the
vignettes first. Install them into a project with:

``` r

VizModules::use_vizmodules_skills(".")
```

That writes `vizmodules-app`, `vizmodules-custom-module`, and
`vizmodules-new-module` into `.agents/skills/` by default, where GitHub
Copilot and OpenAI Codex discover them automatically. Pass
`client = "copilot"` for `.github/skills/` (also read by GitHub Copilot)
or `client = "claude"` for `.claude/skills/` (Claude Code); call the
function more than once with different `client` values to install into
several locations at once. `vizmodules-app` in particular carries a
generated inventory of every module’s column-mapping keys (`x.data` vs
`x.by` vs `x.value` vs `var`), colour key, tab names, and stats keys,
which is what an agent otherwise spends its budget grepping for.

In rough benchmarking, `vizmodules-app` saves ~40-60% of token usage
versus just chucking an agent at the docs/repo/prompt below and
generates a functional app in about half the time. The other skills show
more variable and modest savings (~10-20% fewer tokens), but they tend
to avoid common pitfalls and better utilize some of the more advanced
features. Skills are difficult to benchmark, as the benefits are
context-dependent and vary with the request.
