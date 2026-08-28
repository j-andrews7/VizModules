# Filtering Data with the dataFilter Module

## Introduction

The `dataFilter` module renders an interactive table with a filter box
on every column and returns **only the rows the user has left visible**.
Because it hands that filtered data back as a reactive, you can plug it
in front of any plotting module so the plot always reflects the current
table filters.

Like every module in **VizModules**, it comes in two halves that share
an `id`:

- `dataFilterUI(id)` – places the table in your UI.
- `dataFilterServer(id, data, ...)` – runs the table and returns the
  filtered data.

## What the module does

The server is small, and its job is easy to describe:

1.  **Prepare the data.** By default (`factor.char.cols = TRUE`) every
    character column is converted to a factor. This is purely cosmetic:
    it makes DT show a drop-down select filter for those columns instead
    of a free-text search box.
2.  **Render the table.** A [DT](https://rstudio.github.io/DT/) table is
    drawn with a filter row at the top of each column
    (`filter = "top"`).
3.  **Return the visible rows.** DT continuously reports which rows
    survive the current filters via `input$table_rows_all`. The module
    subsets the data to those rows, calls
    [`droplevels()`](https://rdrr.io/r/base/droplevels.html) so
    filtered-out categories don’t linger in plot legends or axes, and
    returns the result as a reactive.

Conceptually:

    data (reactive) --> character cols to factors --> DT table (user filters)
                                                            |
                                         input$table_rows_all (visible rows)
                                                            v
                                                  filtered data (reactive)

### Arguments

| Argument | Default | Purpose |
|----|----|----|
| `id` | – | Module id; must match the `id` given to [`dataFilterUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterUI.md). |
| `data` | – | A **reactive** containing the data frame to display and filter. |
| `factor.char.cols` | `TRUE` | Convert character columns to factors so they get drop-down filters. |
| `page.length` | `10` | Rows shown per page. |
| `col.visibility` | `FALSE` | Add a “Columns” button so users can show/hide individual columns. |
| `hide.columns` | `NULL` | Column names (or positions) to hide when the table is first drawn. |

### Return value

A **reactive** that evaluates to the filtered subset of `data`. This is
the key to the module’s flexibility: a reactive can be read by as many
consumers as you like, so the same filtered data can drive one plot or
several.

## Showing fewer columns

Wide data frames make for a busy table and a wall of filter boxes. Pass
the columns you don’t want on screen to `hide.columns` and the table is
drawn without them – no column, no filter box:

``` r

filtered <- dataFilterServer("filter", reactive(example_bar),
    hide.columns = c("internal_id", "batch")
)
```

Two things to keep in mind:

- **Hiding is display-only.** The returned reactive still contains every
  column, so a plotting module can map a hidden column to an aesthetic
  even though users never see it in the table.
- **Hidden stays hidden unless you say otherwise.** Add
  `col.visibility = TRUE` to get DT’s “Columns” button, which lets users
  switch any column – including the ones you hid – back on.

``` r

filtered <- dataFilterServer("filter", reactive(example_bar),
    hide.columns = c("internal_id", "batch"),
    col.visibility = TRUE
)
```

The name-to-position lookup behind `hide.columns` is exported as
[`resolve_column_targets()`](https://j-andrews7.github.io/VizModules/dev/reference/resolve_column_targets.md),
so you can reach for it in your own tables too. DataTables addresses
columns in `columnDefs` by zero-based position; this turns column names
into those positions (pass `rownames = TRUE` if your table shows a
row-names column, which shifts everything over by one). Hiding is just
one use - the same targets drive `width`, `orderable`, `className`, and
friends:

``` r

DT::datatable(
    example_bar,
    rownames = FALSE,
    options = list(
        columnDefs = list(list(
            visible = FALSE,
            targets = resolve_column_targets(example_bar, c("internal_id", "batch"))
        ))
    )
)
```

## A minimal example

Pass the returned reactive straight into a plotting module’s `data`
argument. When the user filters the table, the plot redraws
automatically.

``` r

library(shiny)
library(VizModules)

ui <- fluidPage(
    plotthis_BarPlotOutputUI("bar"),
    dataFilterUI("filter"),
    plotthis_BarPlotInputsUI("bar", example_bar)
)

server <- function(input, output, session) {
    # Returns a reactive of only the currently-visible rows.
    filtered <- dataFilterServer("filter", reactive(example_bar))

    # The plot tracks the filter automatically.
    plotthis_BarPlotServer("bar", data = filtered)
}

if (interactive()) shinyApp(ui, server)
```

Note the shared `id`: `"bar"` is used for the module’s `OutputUI`,
`InputsUI`, and `Server`, while `"filter"` ties
[`dataFilterUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterUI.md)
to
[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterServer.md).

## Linking several modules to one table

Because the filtered data is just a reactive, you don’t need any special
machinery to connect it to more than one plot – **feed the same
`filtered` reactive into each module’s server**. Every module reading it
re-renders whenever the filter changes, so a single table keeps all of
the plots in sync.

``` r

library(shiny)
library(shinyjs)
library(VizModules)

ui <- fluidPage(
    useShinyjs(),
    fluidRow(
        column(6, plotthis_BarPlotOutputUI("bar")),
        column(6, plotthis_BoxPlotOutputUI("box"))
    ),
    dataFilterUI("filter"),
    fluidRow(
        column(6, plotthis_BarPlotInputsUI("bar", example_bar)),
        column(6, plotthis_BoxPlotInputsUI("box", example_bar))
    )
)

server <- function(input, output, session) {
    # One filtered reactive, shared by both modules.
    filtered <- dataFilterServer("filter", reactive(example_bar))

    plotthis_BarPlotServer("bar", data = filtered)
    plotthis_BoxPlotServer("box", data = filtered)
}

if (interactive()) shinyApp(ui, server)
```

The only rule to remember is namespacing: **each plotting module’s
`InputsUI`, `OutputUI`, and `Server` must share the same top-level
`id`** (`"bar"` and `"box"` above). Nothing wraps the module servers, so
their ids resolve to the top-level namespace where their UI lives, and
everything connects.

A ready-to-run version of this app ships with the package:

``` r

shiny::runApp(
    system.file("examples", "linked-filter", package = "VizModules")
)
```

## How it compares to `createModuleApp()`

The `*App()` helpers and
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md)
already wire a `dataFilter` table to a single plot for you (see the
*Quick Start* vignette). Reach for
[`dataFilterUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterUI.md)
/
[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterServer.md)
directly when you want to control the layout yourself – for example, to
share one table across multiple plots as shown above, or to embed the
table inside a larger custom module.

## Summary

- [`dataFilterServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterServer.md)
  returns a **reactive of the currently-visible rows**.
- Plug that reactive into any plotting module’s `data` argument.
- Feed the *same* reactive into several servers to link multiple plots
  to one table – no extra wiring required.
- Keep each module’s `InputsUI`, `OutputUI`, and `Server` on a shared,
  top-level `id` so namespaces line up.
