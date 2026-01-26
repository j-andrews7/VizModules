# Adding a New Module

This checklist walks through how to add a new plotting module to
**vizModules** so it matches the package’s organization, documentation,
and testing standards.

## Quick Checklist

Pick the plot function you are wrapping and name your module
accordingly:

- For **dittoViz** functions: use `dittoViz_<PlotName>` (e.g.,
  `dittoViz_ScatterPlot` for
  [`dittoViz::scatterPlot`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html))
- For **plotthis** functions: use `plotthis_<PlotName>` (e.g.,
  `plotthis_AreaPlot` for
  [`plotthis::AreaPlot`](https://pwwang.github.io/plotthis/reference/AreaPlot.html))
- For **custom/standalone** functions: use the plot name directly (e.g.,
  `linePlot`, `piePlot`)

If adding a brand-new plotting function (e.g., `piePlot`), define and
document that plot function first, then wrap it with the module.

Create the three core files: `R/<moduleName>_module_ui.R`,
`R/<moduleName>_module_server.R`, and `R/<moduleName>_module_app.R`.

Document UI, server, and app functions with roxygen (`@export`, params,
examples).

In the UI function docstring, add **three required sections**:

- `@section Plot parameters not implemented or with altered functionality:` -
  List inputs not exposed and why
- `@section Plot parameters and defaults:` - Document all exposed
  parameters with UI labels and defaults
- `@section Plot parameters implementing new functionality:` - Document
  any new or plotly-specific controls (axes, ticks, reference lines,
  etc)

Add an example app that uses the module twice to prove multi-instance
behavior.

Cover the base plotting function with `testthat`; cover the module/app
with `shinytest2`.

Note any `ggplotly` conversion quirks that change or drop functionality.

## Naming & Organization

File names follow the module naming pattern:

- **dittoViz wrappers**: `dittoViz_<PlotName>_module_ui.R` (e.g.,
  `dittoViz_scatterPlot_module_ui.R`)
- **plotthis wrappers**: `plotthis_<PlotName>_module_ui.R` (e.g.,
  `plotthis_AreaPlot_module_ui.R`)
- **Custom modules**: `<plotName>_module_ui.R` (e.g.,
  `linePlot_module_ui.R`)

Function names follow the pattern: `<moduleName>InputsUI()`,
`<moduleName>OutputUI()`, `<moduleName>Server()`, `<moduleName>App()`.

- Examples:
  [`plotthis_AreaPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotInputsUI.md),
  [`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md),
  [`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md)

Internal helpers stay in existing helper files when broadly useful;
otherwise keep them inside the module file.

## Documentation Standards

Roxygen headers include title, description, parameters, return value,
authors, and `@export`.

Examples show minimal, runnable usage with a small dataset.

**The UI function must include three documentation sections:**

### 1. `@section Plot parameters not implemented or with altered functionality:`

List all parameters from the base plot function that are **not** exposed
via UI inputs, with explanations:

``` r
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::AreaPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{split_by} - Split variable (returns a patchwork object, not supported in plotly)
#'   \item \code{palette} - Managed internally via the palette selection UI
#' }
```

### 2. `@section Plot parameters and defaults:`

Document all parameters that **are** exposed, listing their UI label and
default value:

``` r
#' @section Plot parameters and defaults:
#' The following [plotthis::AreaPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable (UI: "Group by", default: 3rd categorical variable or "")
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{theme} - ggplot2 theme (UI: "Theme", default: "theme_this")
#'   \item \code{alpha} - Area fill transparency (UI: "Alpha", default: 1)
#' }
```

### 3. `@section Plot parameters implementing new functionality:`

Document all module-specific parameters (plotly controls, reference
lines, etc.):

``` r
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{axis.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{axis.showline} - Show axis border lines (UI: "Show axis lines", default: TRUE)
#'   \item \code{axis.tickfont.size} - Size of tick labels (UI: "Tick label size", default: 12)
#'   \item \code{hline.intercepts} - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#'   \item \code{hline.colors} - Colors for horizontal lines, comma-separated (UI: "Colors", default: "#000000")
#'   \item \code{hline.linetypes} - Line types for horizontal lines, comma-separated (UI: "Line types", default: "dashed")
#'   \item \code{vline.intercepts} - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#'   \item \code{abline.slopes} - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#' }
```

**Note:** Reference line parameters (`hline.*`, `vline.*`, `abline.*`)
accept comma-separated values to control each line individually.

## Functionality & Non-Exposed Inputs

For each plot function argument, decide: expose, set a fixed default, or
drop.

If dropped or fixed, document it inside the UI function (description +
reason).

If `ggplotly` alters or drops a feature (e.g., certain geoms,
annotations), note that limitation in the UI docs so users know what to
expect.

## Example App Requirement

Provide an app in `<plot>_module_app.R` that instantiates the module
**twice** with different datasets/IDs.

Keep the app minimal: load sample data, render both modules’
inputs/outputs, and no extra custom logic beyond demonstrating the
module.

Add the module to the gallery app (`inst/apps/module-gallery/app.R`),
placing it in its own tab alongside the other modules.

## Testing Requirements

`testthat`: cover the base plotting function’s core behavior and
arguments (data handling, grouping, palette handling, etc.).

`shinytest2`: cover the module/app (rendering inputs, updating outputs,
download buttons if present).

Place tests under `tests/testthat/` with clear file names
(`test-<plot>.R`, `test-<plot>-app.R`).

Ensure tests run headless and deterministically (seed randomness where
needed).

For new plotting functions, add dedicated `testthat` coverage of the
plotting helper itself (input validation, defaults, edge cases) in
addition to the module tests.

## Implementing a New Plotting Function (e.g., `piePlot`)

Add the plotting function under `R/` with full roxygen docs,
inputs/returns, and examples.

Keep arguments consistent with existing plot functions (data first,
`...` last, palette/palcolor patterns).

Document any assumptions about input shape (e.g., pre-summarized table
for pies).

Add `testthat` coverage for the plotting function (happy paths + invalid
inputs).

Only after the plotting function is stable, build the module
UI/server/app wrappers around it.

## Gallery App

Add or update the gallery app at `inst/apps/module-gallery/app.R` to
include the new module in its own tab.

Each tab should load a small sample dataset and show the module’s inputs
and outputs together.

Verify namespacing: each module instance should have a unique `id` and
independent state.

Keep dependencies minimal (prefer built-in datasets) so the gallery runs
out-of-the-box.

## Review Before Submitting

Run `devtools::document()` to update NAMESPACE and Rd files.

Run `devtools::check()` and ensure tests pass locally.

Confirm UI text/tooltips mention any missing or altered plot features.

Verify both module instances in the example app work independently
(namespacing correct).
