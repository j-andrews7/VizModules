# CLAUDE.md — VizModules Developer Guide

This file provides Claude Code with context for working in the **VizModules** repository. It covers architecture, conventions, module patterns, security requirements, and contribution standards.

---

## Package Overview

**Package:** `VizModules` (v0.1.1)
**Purpose:** Interactivity-first Shiny modules that wrap visualization functions from `dittoViz`, `plotthis`, and custom implementations into reusable, composable Shiny modules with full UI-driven plot customization.

Key dependencies:
- `shiny`, `shinyBS`, `shinyjs`, `shinyjqui`, `shinyWidgets` — UI framework
- `plotly` — All output rendered as interactive plotly figures
- `dittoViz`, `plotthis` — Wrapped plotting libraries
- `ggplot2`, `dplyr`, `scales`, `colourpicker`, `DT`, `readxl` — Support

---

## Repository Layout

```
R/                         # 62 source files (~18,800 lines)
  <moduleName>_module_ui.R     # UI function for each module
  <moduleName>_module_server.R # Server logic for each module
  <moduleName>_module_app.R    # App factory wrapper for each module
  <plotName>.R                 # Custom plotting functions (piePlot, linePlot, etc.)
  createModuleApp.R            # Shared app factory
  ui_utils.R                   # organize_inputs(), default_palettes(), module_tack_ui()
  uniform_ui_inputs.R          # Shared tab helpers: .uniform_*_inputs_ui()
  reset_uniform_ui_inputs.R    # Shared reset helpers: .reset_*_inputs()
  stat_helper.R                # Statistical testing infrastructure
  parse_utils.R                # Text parsing utilities
  plot_mods.R                  # Plotly post-processing utilities
  plotly_annotation_utils.R    # Annotation and subplot helpers
  multiColorPicker.R           # multiColorPicker() widget
  data.R                       # 9 example datasets

man/                       # Auto-generated Rd files (never edit manually)
vignettes/
  quick-start.Rmd
  adding-a-new-module.Rmd    # Canonical contributor checklist — read before adding anything
  custom-modules.Rmd

inst/apps/
  module-gallery/            # Full gallery app (all 14 modules)
  test_*/                    # Individual module test apps

tests/testthat/            # testthat + shinytest2 tests
```

---

## The Three-Function Module Pattern

Every module exports exactly three functions following a consistent naming convention:

```
<ModuleName>InputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
<ModuleName>OutputUI(id)
<ModuleName>Server(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
```

An optional convenience wrapper:
```
<ModuleName>App(data_list = NULL)   # calls createModuleApp() with module-specific defaults
```

### Minimal Shiny app using a module

```r
library(VizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            plotthis_BarPlotInputsUI("plot1", data = mtcars,
                defaults = list(x = "cyl", y = "mpg", group_by = "am"))
        ),
        mainPanel(plotthis_BarPlotOutputUI("plot1"))
    )
)

server <- function(input, output, session) {
    plotthis_BarPlotServer("plot1", data = reactive(mtcars))
}

shinyApp(ui, server)
```

### Key behavior notes

- `data` in `*InputsUI()` is used only to populate column-choice selectors at render time; it does **not** have to be reactive.
- `data` in `*Server()` **must** be a `reactive()` expression — it drives the plot.
- `defaults` is a named list where names match the underlying plot function arguments (e.g., `list(x = "cyl", alpha = 0.7)`).
- `hide.inputs` accepts a character vector of input IDs to hide via `shinyjs::hide()` — values still feed into the plot.
- `hide.tabs` accepts a character vector of tab names (`"Plotly"`, `"Axes"`, `"Lines"`, `"Stats"`, etc.) to remove entirely.
- Each module instance requires a unique `id` string for namespace isolation.

---

## Available Modules

### plotthis wrappers

| Module prefix | Underlying function | Stats tab |
|---|---|---|
| `plotthis_AreaPlot` | `plotthis::AreaPlot()` | No |
| `plotthis_BarPlot` | `plotthis::BarPlot()` | No |
| `plotthis_BoxPlot` | `plotthis::BoxPlot()` | Yes |
| `plotthis_DensityPlot` | `plotthis::DensityPlot()` | No |
| `plotthis_Histogram` | `plotthis::Histogram()` | No |
| `plotthis_SplitBarPlot` | `plotthis::SplitBarPlot()` | No |
| `plotthis_ViolinPlot` | `plotthis::ViolinPlot()` | Yes |

### dittoViz wrappers

| Module prefix | Underlying function | Stats tab |
|---|---|---|
| `dittoViz_scatterPlot` | `dittoViz::scatterPlot()` | No |
| `dittoViz_yPlot` | `dittoViz::yPlot()` | Yes |

### Custom Plotly implementations

| Module prefix | Plot type | Stats tab |
|---|---|---|
| `linePlot` | Line chart | No |
| `piePlot` | Pie / donut chart | No |
| `radarPlot` | Radar / spider chart | No |
| `parallelCoordinatesPlot` | Parallel coordinates | No |
| `ternaryPlot` | Ternary composition | No |
| `dumbbellPlot` | Dumbbell / connected dot | No |

---

## What Every Module Provides (UI Tabs)

| Tab | Controls |
|---|---|
| **Data** | Variable selectors (x, y, color, shape, facet, group), filter expression, data transformations |
| **Aesthetics / Style** | Palette selector, `multiColorPicker`, alpha, size, width |
| **Adjustments** | Axis ranges, label angles, spacing |
| **Plotly** | Download format (PNG/SVG/PDF/HTML), margins, subplot spacing, shape drawing |
| **Axes** | Font family/size/color, axis borders, gridlines, tick styling, facet title styling |
| **Lines** | Horizontal, vertical, diagonal reference lines (intercepts, colors, widths, linetypes) |
| **Stats** *(BoxPlot, ViolinPlot, yPlot only)* | Test type, p-value adjustment, paired testing, bracket styling, per-facet testing |

---

## Shared UI Helpers (use instead of custom inputs)

These internal helpers live in `R/uniform_ui_inputs.R` and `R/reset_uniform_ui_inputs.R`. Access them with `VizModules:::` when writing external code, or directly when inside the package.

```r
# Add to a module's tabsetPanel:
.uniform_plotly_inputs_ui(ns, defaults)        # Download, margins, shape drawing
.uniform_axes_inputs_ui(ns, defaults)          # Font, borders, gridlines, ticks
.uniform_lines_inputs_ui(ns, defaults,         # H/V/diagonal reference lines
    include.fit.lines = FALSE)
.uniform_stats_inputs_ui(ns, defaults)         # Pairwise stats + bracket styling

# Call in reset observer:
.reset_plotly_inputs(session)
.reset_axes_inputs(session)
.reset_lines_inputs(session)
.reset_stats_inputs(session)
```

### `organize_inputs()` — grid layout for input tabs

```r
organize_inputs(
    ns, data,
    tabs = list(
        "Data"        = list(inputs = list(...), n_col = 2),
        "Aesthetics"  = list(inputs = list(...), n_col = 2),
        "Plotly"      = .uniform_plotly_inputs_ui(ns, defaults),
        "Axes"        = .uniform_axes_inputs_ui(ns, defaults),
        "Lines"       = .uniform_lines_inputs_ui(ns, defaults)
    )
)
```

### `module_tack_ui()` — standard control bar

```r
module_tack_ui(ns, has.stats = FALSE)
# Produces: Auto-Update toggle | Update button | Reset button | (Save Stats button if has.stats)
```

---

## Defaults System

`.get_default(defaults, key, fallback, validator = NULL)` is the canonical way to resolve default values inside UI functions:

```r
value = .get_default(defaults, "alpha", 1, is.numeric)
selected = .get_default(defaults, "x", choices[1], function(x) x %in% choices)
```

If the value in `defaults` fails the validator, `fallback` is used. Never read `defaults[[key]]` directly.

---

## Security: Expression Validation (MANDATORY)

**Never use `eval(parse())` or `eval(str2expression())` on raw user input.** All three helpers below must be used whenever modules accept free-text expressions.

```r
# User-typed row filter expression → logical vector
rows.use <- safe_eval_filter(isolate_fn(input$rows.use), data())

# User-typed highlight expression → validated string (passed to plotting fn)
highlight <- validate_expression(isolate_fn(input$highlight), names(data()))

# User-selected function name → actual function from whitelist only
x.adj.fxn <- safe_resolve_adj_fxn(isolate_fn(input$x.adj.fxn))
```

Allowed operations in `safe_eval_filter` / `validate_expression`:
- Comparisons: `<`, `>`, `<=`, `>=`, `==`, `!=`
- Logical: `&`, `&&`, `|`, `||`, `!`
- Utilities: `%in%`, `c()`, `is.na()`, `is.null()`
- Arithmetic: `-`, `+`, `*`, `/`, `:`, `%%`
- Column references and literals (numbers, strings, `TRUE`/`FALSE`/`NA`/`NULL`/`Inf`/`NaN`)

Everything else (including `system()`, `file.remove()`, `library()`) is rejected.

---

## Statistical Testing Integration

Modules that support grouped numeric comparisons (BoxPlot, ViolinPlot, yPlot) add a Stats tab. Key helpers all live in `R/stat_helper.R`:

```r
# Run tests
stats_df <- .compute_pairwise_stats(
    data, x_col, y_col, group_col = NULL,
    test = input$stat.test, p.adj = input$stat.p.adj,
    pairs = .parse_pair_strings(input$stat.pairs),
    facet_col = NULL, per_facet = input$stat.per.facet,
    paired = input$stat.paired
)

# Build plotly bracket shapes/annotations
annotations <- .create_stat_annotations(
    stats_df, p_threshold = input$stat.sig.threshold,
    bracket.style = input$stat.bracket.style, ...
)

# Add to plotly figure
fig <- .apply_stat_annotations(fig, annotations)

# Update pair selector choices when x or grouping changes
updateSelectInput(session, "stat.pairs",
    choices = .generate_pair_strings(levels(data()[[input$x]]))
)

# Export stats to CSV
.write_stats_csv(last_stats_df(), file)
```

UI requirement: pass `has.stats = TRUE` to `module_tack_ui()` and add `.uniform_stats_inputs_ui(ns, defaults)` as a `"Stats"` tab.

---

## Adding a New Module — Checklist

Read `vignettes/adding-a-new-module.Rmd` first. Summary:

1. **Name the module:**
   - `dittoViz_<PlotName>` for dittoViz wrappers
   - `plotthis_<PlotName>` for plotthis wrappers
   - `<plotName>` for custom implementations

2. **Create three files:**
   - `R/<moduleName>_module_ui.R`
   - `R/<moduleName>_module_server.R`
   - `R/<moduleName>_module_app.R`

3. **UI function structure:**
   ```r
   #' @export
   MyPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
       ns <- NS(id)
       tagList(
           module_tack_ui(ns),
           organize_inputs(ns, data, tabs = list(
               "Data"    = list(inputs = list(...), n_col = columns),
               "Plotly"  = .uniform_plotly_inputs_ui(ns, defaults),
               "Axes"    = .uniform_axes_inputs_ui(ns, defaults),
               "Lines"   = .uniform_lines_inputs_ui(ns, defaults)
           ))
       )
   }
   ```

4. **Output function structure:**
   ```r
   #' @export
   MyPlotOutputUI <- function(id) {
       ns <- NS(id)
       jqui_resizable(plotlyOutput(ns("plot")))
   }
   ```

5. **Server function structure:**
   ```r
   #' @export
   MyPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
       moduleServer(id, function(input, output, session) {
           # Hide inputs/tabs
           # Reactive plot render
           output$plot <- renderPlotly({ ... })
           # Reset observer
           observeEvent(input$reset, { ... })
           # Auto-update logic
       })
   }
   ```

6. **UI docstring must include three sections:**
   - `@section Plot parameters not implemented or with altered functionality:`
   - `@section Plot parameters and defaults:`
   - `@section Plot parameters implementing new functionality:`

7. **App wrapper:**
   ```r
   #' @export
   MyPlotApp <- function(data_list = NULL) {
       if (is.null(data_list)) data_list <- list("example" = my_default_data)
       createModuleApp(
           inputs_ui_fn = MyPlotInputsUI,
           output_ui_fn = MyPlotOutputUI,
           server_fn    = MyPlotServer,
           data_list    = data_list,
           title        = "My Plot"
       )
   }
   ```

8. **Add to gallery:** Update `inst/apps/module-gallery/app.R` with a new tab.

9. **Tests:**
   - `tests/testthat/test-<plotName>.R` — `testthat` for plotting function and helpers
   - `tests/testthat/test-<plotName>-app.R` — `shinytest2` for module/app

10. **Run before submitting:**
    ```r
    devtools::document()  # regenerates NAMESPACE and man/ — never edit these manually
    devtools::check()
    ```

---

## Building Custom Wrapper Modules

The key namespace rule: call the base module's **server** function *outside* any `moduleServer()` block.

```r
myWrapperUI <- function(id) {
    ns <- NS(id)
    tagList(
        # Custom inputs use ns()
        checkboxInput(ns("filter_only_a"), "Only Group A", value = FALSE),
        # Base module UI uses bare id
        plotthis_BarPlotInputsUI(id, my_data)
    )
}

myWrapperOutputUI <- function(id) {
    plotthis_BarPlotOutputUI(id)
}

myWrapperServer <- function(id, data) {
    # Step 1: process data inside moduleServer (accesses our custom inputs)
    processed <- moduleServer(id, function(input, output, session) {
        reactive({
            df <- data()
            if (input$filter_only_a) df <- df[df$group == "A", ]
            df
        })
    })
    # Step 2: call base server OUTSIDE the block above (avoids double-namespacing)
    plotthis_BarPlotServer(id, processed)
}
```

---

## Style Guide

- **Indentation:** 4 spaces. **Line limit:** 120 characters.
- **Input labels:** Capitalize first word. Be concise. Move detail into `tipify` tooltips.
- **Tooltips:** Always use `shinyBS::tipify()` with `placement = "top", options = list(container = "body")`.
- **Imports:** Use `@importFrom pkg fun` in roxygen headers; call `fun()` directly in code. Avoid `pkg::fun()` in module bodies.
- **Avoid `sapply()`** — use `vapply()` or `lapply()` with explicit return types.
- **Never edit** `NAMESPACE` or `man/` files directly; always regenerate with `devtools::document()`.

---

## Example Datasets

Available via `data(package = "VizModules")`:

| Dataset | Description | Good for |
|---|---|---|
| `example_bar` | Group/category/numeric | BarPlot, BoxPlot, ViolinPlot |
| `example_sales` | 720-row time series | LinePlot, AreaPlot |
| `example_demographics` | 500-row employee survey | BarPlot, Histogram, DensityPlot |
| `example_iris` | iris + Group column | ScatterPlot, BoxPlot |
| `example_mtcars` | mtcars with factors | BarPlot, ScatterPlot |
| `example_school_earnings` | Dumbbell data | DumbbellPlot |
| `example_skills` | Radar data | RadarPlot |
| `example_roles` | Ternary data | TernaryPlot |
| `example_population` | Line/area data | LinePlot, AreaPlot |

---

## Running the Gallery

```r
shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))
```

Hosted at: https://j-andrews7-VizModules.share.connect.posit.cloud/
