# AGENTS.md — VizModules AI Agent Reference

This document gives AI coding agents everything needed to:
1. Build Shiny applications using VizModules modules
2. Create new custom modules that follow VizModules conventions

---

## What is VizModules?

**VizModules** is an R package (`library(VizModules)`) that provides reusable, interactive Shiny modules for data visualization. Each module wraps a plotting function and exposes its parameters through a polished UI with tabs for data selection, aesthetics, axes, reference lines, and download options. All outputs are interactive `plotly` figures.

**Install:**
```r
# From GitHub
remotes::install_github("j-andrews7/VizModules")
```

---

## The Module Pattern

Every module has three exported functions:

```
<ModuleName>InputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
<ModuleName>OutputUI(id)
<ModuleName>Server(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
```

- `id` — unique string identifying this module instance (enables multiple plots in one app)
- `data` in `InputsUI` — a plain data frame used to populate column-selector dropdowns at render time
- `data` in `Server` — a `reactive()` expression containing the actual data to plot
- `defaults` — named list pre-filling inputs (names match underlying plot function arguments)
- `hide.inputs` — character vector of input IDs to hide from the user (values still used)
- `hide.tabs` — character vector of tab names to hide (`"Plotly"`, `"Axes"`, `"Lines"`, `"Stats"`)

---

## Available Modules

### plotthis wrappers

| Module name prefix | Underlying plot | Data shape | Stats tab |
|---|---|---|---|
| `plotthis_AreaPlot` | `plotthis::AreaPlot()` | Long-format numeric | No |
| `plotthis_BarPlot` | `plotthis::BarPlot()` | Long-format categorical + numeric | No |
| `plotthis_BoxPlot` | `plotthis::BoxPlot()` | Long-format categorical + numeric | **Yes** |
| `plotthis_DensityPlot` | `plotthis::DensityPlot()` | Long-format numeric | No |
| `plotthis_Histogram` | `plotthis::Histogram()` | Long-format numeric | No |
| `plotthis_SplitBarPlot` | `plotthis::SplitBarPlot()` | Long-format categorical + numeric | No |
| `plotthis_ViolinPlot` | `plotthis::ViolinPlot()` | Long-format categorical + numeric | **Yes** |

### dittoViz wrappers

| Module name prefix | Underlying plot | Data shape | Stats tab |
|---|---|---|---|
| `dittoViz_scatterPlot` | `dittoViz::scatterPlot()` | Data frame with numeric columns | No |
| `dittoViz_yPlot` | `dittoViz::yPlot()` | Long-format multi-variable | **Yes** |

### Custom Plotly implementations

| Module name prefix | Plot type | Data shape | Stats tab |
|---|---|---|---|
| `linePlot` | Line chart | Data frame with x/y/group columns | No |
| `piePlot` | Pie / donut chart | Summary data frame (label + value) | No |
| `radarPlot` | Radar / spider chart | Wide or long format with dimension columns | No |
| `parallelCoordinatesPlot` | Parallel coordinates | Wide-format numeric columns | No |
| `ternaryPlot` | Ternary / composition | Data frame with three component columns | No |
| `dumbbellPlot` | Dumbbell / connected dot | Data frame with category + two value columns | No |

---

## Building a Shiny App

### Minimal example

```r
library(VizModules)

ui <- fluidPage(
    sidebarLayout(
        sidebarPanel(
            plotthis_BoxPlotInputsUI("box1", data = iris,
                defaults = list(x = "Species", y = "Sepal.Length"))
        ),
        mainPanel(plotthis_BoxPlotOutputUI("box1"))
    )
)

server <- function(input, output, session) {
    plotthis_BoxPlotServer("box1", data = reactive(iris))
}

shinyApp(ui, server)
```

### Multiple independent plots in one app

Use a different `id` for each module instance:

```r
ui <- fluidPage(
    fluidRow(
        column(6,
            plotthis_BarPlotInputsUI("bar1", data = mtcars),
            plotthis_BarPlotOutputUI("bar1")
        ),
        column(6,
            dittoViz_scatterPlotInputsUI("scatter1", data = mtcars),
            dittoViz_scatterPlotOutputUI("scatter1")
        )
    )
)

server <- function(input, output, session) {
    plotthis_BarPlotServer("bar1", data = reactive(mtcars))
    dittoViz_scatterPlotServer("scatter1", data = reactive(mtcars))
}
```

### Using createModuleApp() for a full standalone app

`createModuleApp()` produces a complete app with data import, a filterable data table, and dataset switching:

```r
app <- createModuleApp(
    inputs_ui_fn = plotthis_BarPlotInputsUI,
    output_ui_fn = plotthis_BarPlotOutputUI,
    server_fn    = plotthis_BarPlotServer,
    data_list    = list("iris" = iris, "cars" = mtcars),
    title        = "Bar Plot Explorer"
)
if (interactive()) runApp(app)
```

Each built-in `*App()` function (e.g., `plotthis_BarPlotApp()`, `linePlotApp()`) is a thin wrapper around `createModuleApp()` with default data.

### Pre-filling defaults

`defaults` names match the underlying plot function's argument names:

```r
# For plotthis_BarPlot:
defaults = list(
    x        = "Species",
    y        = "Sepal.Length",
    group_by  = "Species",
    alpha    = 0.8,
    facet_by = ""
)

# For dittoViz_scatterPlot:
defaults = list(
    x.by     = "wt",
    y.by     = "mpg",
    color.by = "cyl"
)
```

To find what defaults are accepted, check the `?<ModuleName>InputsUI` help page — the **"Plot parameters and defaults"** section lists every exposed parameter with its UI label and default value.

### Hiding controls

```r
# Hide specific inputs by their input ID (values still used for plotting)
plotthis_BarPlotServer("bar1", data = reactive(iris),
    hide.inputs = c("split.by", "facet.by"))

# Hide entire tabs
dittoViz_scatterPlotServer("sc1", data = reactive(mtcars),
    hide.tabs = c("Plotly", "Lines"))

# Can also hide at UI time
dittoViz_scatterPlotInputsUI("sc1", data = mtcars,
    hide.inputs = c("shape.by", "color.by"))
```

### Reactive data (live filtering)

Pass reactive data to the server for live updates:

```r
server <- function(input, output, session) {
    filtered <- reactive({
        iris[iris$Sepal.Length > input$min_sl, ]
    })
    plotthis_BoxPlotServer("box1", data = filtered)
}
```

---

## Building Custom Wrapper Modules

Custom modules add application-specific logic (filtering, transformations, extra inputs) while reusing a base module's full functionality.

### Critical namespace rule

The base module's server must be called **outside** any `moduleServer()` block to avoid double-namespacing:

```r
myFilteredScatterUI <- function(id, data) {
    ns <- NS(id)
    tagList(
        # Custom inputs use ns() for namespacing
        selectInput(ns("filter_species"), "Show species",
            choices = unique(data$Species), multiple = TRUE,
            selected = unique(data$Species)),
        hr(),
        # Base module UI receives bare id (NOT ns(id))
        dittoViz_scatterPlotInputsUI(id, data,
            defaults = list(x.by = "Sepal.Length", y.by = "Sepal.Width"))
    )
}

myFilteredScatterOutputUI <- function(id) {
    dittoViz_scatterPlotOutputUI(id)  # bare id
}

myFilteredScatterServer <- function(id, data) {
    # Step 1: Access custom inputs inside moduleServer
    filtered_data <- moduleServer(id, function(input, output, session) {
        reactive({
            req(data())
            df <- data()
            if (!is.null(input$filter_species) && length(input$filter_species) > 0) {
                df <- df[df$Species %in% input$filter_species, ]
            }
            df
        })
    })

    # Step 2: Call base server OUTSIDE the block above
    # If called inside, namespacing becomes id-id-inputName and inputs won't work
    dittoViz_scatterPlotServer(id, filtered_data)
}
```

### Full app from a custom module

```r
ui <- fluidPage(
    titlePanel("Filtered Scatter Plot"),
    sidebarLayout(
        sidebarPanel(myFilteredScatterUI("demo", iris)),
        mainPanel(myFilteredScatterOutputUI("demo"))
    )
)

server <- function(input, output, session) {
    myFilteredScatterServer("demo", reactive(iris))
}

shinyApp(ui, server)
```

---

## Example Datasets

Nine datasets ship with the package:

| Dataset | Rows | Key columns | Best modules |
|---|---|---|---|
| `example_bar` | varies | group, category, value | BarPlot, BoxPlot, ViolinPlot |
| `example_sales` | 720 | date, product, sales | LinePlot, AreaPlot |
| `example_demographics` | 500 | dept, salary, years | BarPlot, Histogram, DensityPlot |
| `example_iris` | 150 | Species + numeric + Group | ScatterPlot, BoxPlot |
| `example_mtcars` | 32 | cyl, mpg, am (factors) | BarPlot, ScatterPlot |
| `example_school_earnings` | varies | school, start, end | DumbbellPlot |
| `example_skills` | varies | skill dimensions | RadarPlot |
| `example_roles` | varies | A, B, C composition | TernaryPlot |
| `example_population` | varies | year, group, value | LinePlot, AreaPlot |

Load with: `data("example_bar", package = "VizModules")`

---

## Creating a New Module from Scratch

Follow this checklist when building a module to contribute back to VizModules or for local extension.

### 1. Name the module

- Wrapping `dittoViz`: `dittoViz_<PlotName>` (e.g., `dittoViz_ridgePlot`)
- Wrapping `plotthis`: `plotthis_<PlotName>` (e.g., `plotthis_HeatmapPlot`)
- Custom function: `<plotName>` (e.g., `sunburstPlot`)

Function names: `<ModuleName>InputsUI()`, `<ModuleName>OutputUI()`, `<ModuleName>Server()`, `<ModuleName>App()`

### 2. If adding a new plotting function

Define it in `R/<plotName>.R` before building the module wrapper. Keep argument conventions consistent: `data` first, `...` last, palette/palcolor pattern matching existing functions.

### 3. UI function template

```r
#' Input UI components for the MyPlot module
#'
#' @param id Module ID
#' @param data Data frame used to populate column selectors
#' @param defaults Named list of default values for inputs
#' @param title Optional title above inputs
#' @param columns Number of columns in the input grid (default 2)
#'
#' @section Plot parameters not implemented or with altered functionality:
#' \itemize{
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{palette} - Managed internally via the palette selection UI
#' }
#'
#' @section Plot parameters and defaults:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: first numeric column)
#'   \item \code{group_by} - Grouping variable (UI: "Group by", default: first categorical column)
#'   \item \code{alpha} - Point opacity (UI: "Alpha", default: 1)
#' }
#'
#' @section Plot parameters implementing new functionality:
#' \itemize{
#'   \item \code{axis.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{hline.intercepts} - Y-intercepts for horizontal reference lines (UI: "Y-intercepts", default: "")
#' }
#'
#' @export
MyPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)
    numeric_cols  <- names(Filter(is.numeric, data))
    factor_cols   <- c("", names(Filter(function(x) is.character(x) || is.factor(x), data)))

    tagList(
        if (!is.null(title)) h4(title),
        module_tack_ui(ns),
        organize_inputs(ns, data,
            tabs = list(
                "Data" = list(n_col = columns, inputs = list(
                    selectInput(ns("x"), "X values",
                        choices = numeric_cols,
                        selected = .get_default(defaults, "x", numeric_cols[1],
                            function(v) v %in% numeric_cols)),
                    selectInput(ns("group_by"), "Group by",
                        choices = factor_cols,
                        selected = .get_default(defaults, "group_by", factor_cols[1],
                            function(v) v %in% factor_cols)),
                    sliderInput(ns("alpha"), "Alpha", min = 0, max = 1,
                        value = .get_default(defaults, "alpha", 1, is.numeric), step = 0.05)
                )),
                "Plotly" = .uniform_plotly_inputs_ui(ns, defaults),
                "Axes"   = .uniform_axes_inputs_ui(ns, defaults),
                "Lines"  = .uniform_lines_inputs_ui(ns, defaults)
            )
        )
    )
}
```

### 4. Output function template

```r
#' Output UI for the MyPlot module
#' @param id Module ID
#' @export
MyPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(plotlyOutput(ns("plot")))
}
```

### 5. Server function template

```r
#' Server logic for the MyPlot module
#' @param id Module ID
#' @param data Reactive data frame
#' @param hide.inputs Character vector of input IDs to hide
#' @param hide.tabs Character vector of tab names to hide
#' @param defaults Named list of default values (used for reset)
#' @export
MyPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    moduleServer(id, function(input, output, session) {

        # Hide requested inputs and tabs
        if (!is.null(hide.inputs)) lapply(hide.inputs, function(i) shinyjs::hide(i))
        if (!is.null(hide.tabs))   lapply(hide.tabs,   function(t) shinyjs::hide(t))

        # Helper: run reactively or only on Update click
        isolate_fn <- function(x) if (isTRUE(input$auto.update)) x else isolate(x)

        # Plot rendering
        output$plot <- renderPlotly({
            req(data())
            df <- data()

            x_col    <- isolate_fn(input$x)
            group_by <- isolate_fn(input$group_by)
            alpha    <- isolate_fn(input$alpha)

            # Build the plot (replace with your actual plotting call)
            p <- myPlotFunction(df, x = x_col, group_by = group_by, alpha = alpha)

            # Convert to plotly
            fig <- ggplotly(p)

            # Apply uniform axis styling and reference lines
            fig <- .apply_subplot_axis_styling(fig, session, input)
            fig <- .add_reference_lines(fig, input)

            fig
        }) |> bindEvent(
            data(), input$x, input$group_by, input$alpha,
            input$update, input$auto.update,
            ignoreNULL = FALSE
        )

        # Reset observer
        observeEvent(input$reset, {
            updateSelectInput(session, "x",
                selected = .get_default(defaults, "x", ""))
            updateSelectInput(session, "group_by",
                selected = .get_default(defaults, "group_by", ""))
            updateSliderInput(session, "alpha",
                value = .get_default(defaults, "alpha", 1))
            .reset_plotly_inputs(session)
            .reset_axes_inputs(session)
            .reset_lines_inputs(session)
        })
    })
}
```

### 6. App wrapper template

```r
#' Launch a standalone MyPlot app
#' @param data_list Named list of data frames (NULL uses built-in examples)
#' @export
MyPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example" = example_bar)
    }
    createModuleApp(
        inputs_ui_fn = MyPlotInputsUI,
        output_ui_fn = MyPlotOutputUI,
        server_fn    = MyPlotServer,
        data_list    = data_list,
        title        = "My Plot"
    )
}
```

---

## Security Rules for Expression Inputs

Any text input that gets evaluated must go through one of these three helpers — never `eval(parse())` directly:

```r
# Row filter: user types "Species == 'setosa' & Sepal.Length > 5"
rows.use <- safe_eval_filter(isolate_fn(input$rows.use), data())
# Returns a logical vector for subsetting, or NULL if empty/invalid

# Highlight expression: passed to plotting function as a string
highlight <- validate_expression(isolate_fn(input$highlight), names(data()))
# Returns validated string or NULL

# Axis transform: user selects "log2", "sqrt", etc.
x.adj.fxn <- safe_resolve_adj_fxn(isolate_fn(input$x.adj.fxn))
# Returns the function object or NULL — only whitelisted names accepted
```

Allowed values for `safe_resolve_adj_fxn`: `"log2"`, `"log"`, `"log10"`, `"neg_log10"`, `"log1p"`, `"as.factor"`, `"abs"`, `"sqrt"`.

---

## Statistical Testing (Stats Tab)

BoxPlot, ViolinPlot, and yPlot modules include a Stats tab. To add statistical testing to a new module that has a categorical x-axis and numeric y-axis:

**UI:** add `.uniform_stats_inputs_ui(ns, defaults)` as a `"Stats"` tab and pass `has.stats = TRUE` to `module_tack_ui(ns, has.stats = TRUE)`.

**Server:** integrate the stat helper functions from `R/stat_helper.R`:

```r
last_stats_df <- reactiveVal(NULL)

# Inside renderPlotly, when input$stats.enabled is TRUE:
stats_df <- .compute_pairwise_stats(
    data       = df,
    x_col      = input$x,
    y_col      = input$y,
    group_col  = if (nzchar(input$group_by)) input$group_by else NULL,
    test       = input$stat.test,
    p.adj      = input$stat.p.adj,
    pairs      = .parse_pair_strings(input$stat.pairs),
    per_facet  = input$stat.per.facet,
    paired     = input$stat.paired,
    facet_col  = if (nzchar(input$facet_by)) input$facet_by else NULL
)
last_stats_df(stats_df)

annotations <- .create_stat_annotations(stats_df,
    p_threshold    = input$stat.sig.threshold,
    bracket.style  = input$stat.bracket.style,
    bracket.color  = input$stat.bracket.color,
    bracket.width  = input$stat.bracket.width,
    inset          = input$stat.inset
)
fig <- .apply_stat_annotations(fig, annotations)

# Update pair choices when x or grouping column changes:
observeEvent(list(input$x, input$group_by), {
    pairs <- .generate_pair_strings(unique(df[[input$x]]))
    updateSelectInput(session, "stat.pairs", choices = pairs)
})

# Download handler:
output$download.stats <- downloadHandler(
    filename = function() paste0("stats_", Sys.Date(), ".csv"),
    content  = function(file) .write_stats_csv(last_stats_df(), file)
)
```

---

## Key Shared Utilities Reference

| Function | File | Purpose |
|---|---|---|
| `organize_inputs()` | `ui_utils.R` | Grid layout for tabbed module inputs |
| `module_tack_ui()` | `ui_utils.R` | Auto-Update toggle + Update + Reset buttons |
| `default_palettes()` | `ui_utils.R` | Named list of color palette choices |
| `.get_default()` | `uniform_ui_inputs.R` | Safe default resolution with validation |
| `.uniform_plotly_inputs_ui()` | `uniform_ui_inputs.R` | Download, margins, shape drawing tab |
| `.uniform_axes_inputs_ui()` | `uniform_ui_inputs.R` | Font, borders, gridlines, ticks tab |
| `.uniform_lines_inputs_ui()` | `uniform_ui_inputs.R` | Reference lines tab |
| `.uniform_stats_inputs_ui()` | `uniform_ui_inputs.R` | Stats test controls tab |
| `.reset_plotly_inputs()` | `reset_uniform_ui_inputs.R` | Reset plotly tab inputs |
| `.reset_axes_inputs()` | `reset_uniform_ui_inputs.R` | Reset axes tab inputs |
| `.reset_lines_inputs()` | `reset_uniform_ui_inputs.R` | Reset lines tab inputs |
| `.reset_stats_inputs()` | `reset_uniform_ui_inputs.R` | Reset stats tab inputs |
| `.apply_subplot_axis_styling()` | `plot_mods.R` | Apply axis tab styling to plotly figure |
| `.add_reference_lines()` | `plot_mods.R` | Apply lines tab reference lines to plotly |
| `multiColorPicker()` | `multiColorPicker.R` | Color assignment UI for discrete groups |
| `resolve_palette()` | (exported) | Palette name → colors vector |
| `safe_eval_filter()` | (exported) | Safe evaluation of filter expressions |
| `validate_expression()` | (exported) | Validate expression string for plotting fn |
| `safe_resolve_adj_fxn()` | (exported) | Resolve transform function from whitelist |
| `createModuleApp()` | `createModuleApp.R` | Full standalone app factory |

---

## Style Conventions (apply when generating code)

- 4-space indentation, 120-character line limit
- Input labels: capitalize first word, be concise (`"Group by"` not `"Select the grouping variable"`)
- Non-obvious inputs: wrap with `shinyBS::tipify(..., placement = "top", options = list(container = "body"))`
- `@importFrom pkg fun` in roxygen headers; call `fun()` directly (not `pkg::fun()`) in function bodies
- `vapply()` or `lapply()` instead of `sapply()`
- Never edit `NAMESPACE` or `man/` files — regenerate with `devtools::document()`
- Never use `eval(parse())` on user-typed strings — use the three security helpers

---

## Running the Gallery

```r
library(VizModules)
shiny::runApp(system.file("apps/module-gallery", package = "VizModules"))
```
