library(VizModules)

# ---------------------------------------------------------------------------
# Panel Builder
#
# A free-form dashboard builder for VizModules. Users can:
#   * Add any VizModules plot at runtime, choosing both the plot type and the
#     dataset it should use.
#   * Drag and resize each plot to arrange a panel of plots on the page.
#   * Swap the visible plot's *controls* in and out with a single dropdown that
#     switches between the control sets of every plot that has been added.
#   * Swap the visible plot's *data-filter table* in and out with a second
#     dropdown, mirroring the controls behaviour.
#
# Every plot lives on its own draggable + resizable card on the canvas, while a
# single shared controls pane and a single shared table pane keep the interface
# uncluttered no matter how many plots are added.
# ---------------------------------------------------------------------------

# --- Available datasets ----------------------------------------------------
# A derived summary dataset that suits the pie plot.
sales_by_product <- aggregate(revenue ~ product_line, example_sales, sum)

datasets <- list(
    "example_sales"           = example_sales,
    "example_bar"             = example_bar,
    "example_demographics"    = example_demographics,
    "example_markers"         = example_markers,
    "example_school_earnings" = example_school_earnings,
    "example_skills"          = example_skills,
    "example_roles"           = example_roles,
    "example_rnaseq"          = example_rnaseq,
    "example_iris"            = example_iris,
    "example_mtcars"          = example_mtcars,
    "example_population"      = example_population,
    "sales_by_product"        = sales_by_product
)

# --- Module registry -------------------------------------------------------
# Each entry wires up one VizModules module. `dataset` is the dataset that the
# supplied `defaults` were written for; it is used as the initial selection and
# the defaults are only applied when that dataset is chosen.
module_registry <- list(
    area = list(
        label = "Area Plot", dataset = "example_sales",
        inputs_ui = plotthis_AreaPlotInputsUI,
        output_ui = plotthis_AreaPlotOutputUI,
        server_fn = plotthis_AreaPlotServer,
        defaults = list("x.data" = "year", "y.data" = "revenue",
                        "group.by" = "product_line")
    ),
    bar = list(
        label = "Bar Plot", dataset = "example_bar",
        inputs_ui = plotthis_BarPlotInputsUI,
        output_ui = plotthis_BarPlotOutputUI,
        server_fn = plotthis_BarPlotServer,
        defaults = list("x.data" = "Group", "y.data" = "Values",
                        "group.by" = "Type")
    ),
    box = list(
        label = "Box Plot", dataset = "example_demographics",
        inputs_ui = plotthis_BoxPlotInputsUI,
        output_ui = plotthis_BoxPlotOutputUI,
        server_fn = plotthis_BoxPlotServer,
        defaults = list("x.data" = "department", "y.data" = "salary")
    ),
    density = list(
        label = "Density Plot", dataset = "example_demographics",
        inputs_ui = plotthis_DensityPlotInputsUI,
        output_ui = plotthis_DensityPlotOutputUI,
        server_fn = plotthis_DensityPlotServer,
        defaults = list("x.data" = "salary", "group.by" = "department")
    ),
    dotplot = list(
        label = "Dot Plot", dataset = "example_markers",
        inputs_ui = plotthis_DotPlotInputsUI,
        output_ui = plotthis_DotPlotOutputUI,
        server_fn = plotthis_DotPlotServer,
        defaults = list("x.data" = "gene", "y.data" = "cell_type",
                        "size.by" = "pct_expressed", "fill.by" = "avg_expression")
    ),
    dumbbell = list(
        label = "Dumbbell Plot", dataset = "example_school_earnings",
        inputs_ui = dumbbellPlotInputsUI,
        output_ui = dumbbellPlotOutputUI,
        server_fn = dumbbellPlotServer,
        defaults = list()
    ),
    histogram = list(
        label = "Histogram", dataset = "example_demographics",
        inputs_ui = plotthis_HistogramInputsUI,
        output_ui = plotthis_HistogramOutputUI,
        server_fn = plotthis_HistogramServer,
        defaults = list("x.data" = "salary")
    ),
    line = list(
        label = "Line Plot", dataset = "example_sales",
        inputs_ui = linePlotInputsUI,
        output_ui = linePlotOutputUI,
        server_fn = linePlotServer,
        defaults = list("x.value" = "product_line", "y.value" = "units")
    ),
    parallel = list(
        label = "Parallel Coordinates", dataset = "example_sales",
        inputs_ui = parallelCoordinatesPlotInputsUI,
        output_ui = parallelCoordinatesPlotOutputUI,
        server_fn = parallelCoordinatesPlotServer,
        defaults = list("color.by" = "product_line")
    ),
    pie = list(
        label = "Pie Plot", dataset = "sales_by_product",
        inputs_ui = piePlotInputsUI,
        output_ui = piePlotOutputUI,
        server_fn = piePlotServer,
        defaults = list("labels" = "product_line", "values" = "revenue")
    ),
    radar = list(
        label = "Radar Plot", dataset = "example_skills",
        inputs_ui = radarPlotInputsUI,
        output_ui = radarPlotOutputUI,
        server_fn = radarPlotServer,
        defaults = list("theta" = "category", "r" = "value", "group" = "player")
    ),
    scatter = list(
        label = "Scatter Plot", dataset = "example_sales",
        inputs_ui = dittoViz_scatterPlotInputsUI,
        output_ui = dittoViz_scatterPlotOutputUI,
        server_fn = dittoViz_scatterPlotServer,
        defaults = list("x.by" = "revenue", "y.by" = "units",
                        "color.by" = "product_line")
    ),
    splitbar = list(
        label = "Split Bar Plot", dataset = "example_bar",
        inputs_ui = plotthis_SplitBarPlotInputsUI,
        output_ui = plotthis_SplitBarPlotOutputUI,
        server_fn = plotthis_SplitBarPlotServer,
        defaults = list("x.data" = "Score", "y.data" = "Group")
    ),
    ternary = list(
        label = "Ternary Plot", dataset = "example_roles",
        inputs_ui = ternaryPlotInputsUI,
        output_ui = ternaryPlotOutputUI,
        server_fn = ternaryPlotServer,
        defaults = list("a" = "journalist", "b" = "developer",
                        "c" = "designer", "group" = "team")
    ),
    violin = list(
        label = "Violin Plot", dataset = "example_demographics",
        inputs_ui = plotthis_ViolinPlotInputsUI,
        output_ui = plotthis_ViolinPlotOutputUI,
        server_fn = plotthis_ViolinPlotServer,
        defaults = list("x.data" = "department", "y.data" = "salary")
    ),
    yplot = list(
        label = "yPlot", dataset = "example_demographics",
        inputs_ui = dittoViz_yPlotInputsUI,
        output_ui = dittoViz_yPlotOutputUI,
        server_fn = dittoViz_yPlotServer,
        defaults = list("var" = "salary", "group.by" = "department")
    )
)

# Choices for the "add plot" module picker (label shown, key returned).
module_choices <- stats::setNames(
    names(module_registry),
    vapply(module_registry, function(m) m$label, character(1))
)

# --- Styling ---------------------------------------------------------------
app_css <- HTML("
#pb_canvas {
    position: relative;
    min-height: 80vh;
    border: 1px dashed #bbb;
    border-radius: 6px;
    background:
        linear-gradient(90deg, #f7f7f7 1px, transparent 1px) 0 0 / 24px 24px,
        linear-gradient(0deg, #f7f7f7 1px, transparent 1px) 0 0 / 24px 24px;
    overflow: auto;
}
.viz-panel-card {
    position: absolute;
    width: 480px;
    height: 380px;
    background: #fff;
    border: 1px solid #ccc;
    border-radius: 6px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}
.viz-panel-header {
    cursor: move;
    background: #2c3e50;
    color: #fff;
    padding: 4px 8px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 13px;
    user-select: none;
}
.viz-panel-title { font-weight: 600; white-space: nowrap;
    overflow: hidden; text-overflow: ellipsis; }
.viz-panel-remove {
    background: transparent; border: none; color: #fff;
    padding: 0 4px; line-height: 1; cursor: pointer;
}
.viz-panel-remove:hover { color: #ff7675; }
.viz-panel-body { flex: 1 1 auto; padding: 6px; overflow: auto; }
.pb-empty-hint { color: #999; text-align: center; padding-top: 30vh; }
")

# --- UI --------------------------------------------------------------------
ui <- fluidPage(
    title = "VizModules Panel Builder",
    shinyjs::useShinyjs(),
    tags$head(tags$style(app_css)),
    titlePanel("VizModules Panel Builder"),
    sidebarLayout(
        sidebarPanel(
            width = 4,
            actionButton("pb_add", "Add Plot",
                icon = icon("plus"), class = "btn-primary"
            ),
            helpText(
                "Add VizModules plots to the canvas, then drag them by their",
                "title bar and resize from the bottom-right corner."
            ),
            hr(),
            h4("Plot Controls"),
            selectInput("pb_controls_select", "Show controls for:",
                choices = character(0)
            ),
            div(
                id = "pb_controls_container",
                div(
                    class = "pb-empty-hint", id = "pb_controls_empty",
                    "Add a plot to configure its controls here."
                )
            )
        ),
        mainPanel(
            width = 8,
            div(
                id = "pb_canvas",
                div(class = "pb-empty-hint", id = "pb_canvas_empty",
                    "No plots yet. Click \"Add Plot\" to begin.")
            ),
            hr(),
            h4("Data Table"),
            p("Filtering a plot's table subsets only that plot's data.",
                style = "color: grey; font-size: 12px;"
            ),
            selectInput("pb_table_select", "Show table for:",
                choices = character(0)
            ),
            div(
                id = "pb_table_container",
                div(
                    class = "pb-empty-hint", id = "pb_table_empty",
                    "Add a plot to view and filter its data here."
                )
            )
        )
    )
)

# --- Server ----------------------------------------------------------------
server <- function(input, output, session) {
    # Reactive bookkeeping for the panels currently on the canvas.
    rv <- reactiveValues(
        panel_ids = character(0), # ordered vector of active panel ids
        labels    = list(),       # pid -> display label
        counter   = 0L            # monotonic id source
    )

    # Snapshot of the data each panel was created with (kept out of reactivity
    # since a panel's dataset is fixed at creation time).
    panel_data <- new.env(parent = emptyenv())

    # Stagger new cards so they do not stack exactly on top of each other.
    next_offset <- function(n) {
        step <- (n %% 6L) * 30L
        list(top = 20L + step, left = 20L + step)
    }

    # --- Add Plot dialog ---------------------------------------------------
    observeEvent(input$pb_add, {
        showModal(modalDialog(
            title = "Add a Plot",
            selectInput("pb_new_module", "Plot type:",
                choices = module_choices
            ),
            selectInput("pb_new_dataset", "Dataset:",
                choices = names(datasets)
            ),
            footer = tagList(
                modalButton("Cancel"),
                actionButton("pb_add_confirm", "Add",
                    class = "btn-primary"
                )
            ),
            easyClose = TRUE
        ))
    })

    # Suggest the module's preferred dataset when the plot type changes.
    observeEvent(input$pb_new_module, {
        mod <- module_registry[[input$pb_new_module]]
        if (!is.null(mod) && mod$dataset %in% names(datasets)) {
            updateSelectInput(session, "pb_new_dataset",
                selected = mod$dataset
            )
        }
    })

    # --- Create a panel ----------------------------------------------------
    observeEvent(input$pb_add_confirm, {
        mod_key <- input$pb_new_module
        ds_name <- input$pb_new_dataset
        mod <- module_registry[[mod_key]]
        req(mod, ds_name %in% names(datasets))
        removeModal()

        rv$counter <- rv$counter + 1L
        pid <- paste0("panel", rv$counter)
        data_snapshot <- datasets[[ds_name]]
        assign(pid, data_snapshot, envir = panel_data)

        label <- sprintf("%s #%d (%s)", mod$label, rv$counter, ds_name)
        # Only apply built-in defaults when the dataset they target is chosen.
        defaults <- if (identical(ds_name, mod$dataset)) mod$defaults else list()

        # Hide empty-state hints once the first panel is added.
        shinyjs::hide("pb_canvas_empty")
        shinyjs::hide("pb_controls_empty")
        shinyjs::hide("pb_table_empty")

        # 1) Plot card on the canvas (draggable via header, resizable).
        pos <- next_offset(rv$counter - 1L)
        card <- div(
            id = paste0(pid, "_card"),
            class = "viz-panel-card",
            style = sprintf("top:%dpx; left:%dpx;", pos$top, pos$left),
            div(
                class = "viz-panel-header",
                span(class = "viz-panel-title", label),
                tags$button(
                    id = paste0(pid, "_remove"),
                    class = "viz-panel-remove action-button",
                    type = "button",
                    icon("times")
                )
            ),
            div(class = "viz-panel-body", mod$output_ui(pid))
        )
        insertUI(
            selector = "#pb_canvas", where = "beforeEnd",
            ui = shinyjqui::jqui_draggable(
                shinyjqui::jqui_resizable(card),
                options = list(handle = ".viz-panel-header", containment = "parent")
            ),
            immediate = TRUE
        )

        # 2) Controls for this panel (hidden until selected in the dropdown).
        insertUI(
            selector = "#pb_controls_container", where = "beforeEnd",
            ui = div(
                id = paste0(pid, "_controls"),
                class = "pb-controls-pane",
                style = "display:none;",
                mod$inputs_ui(pid, data_snapshot, defaults = defaults)
            ),
            immediate = TRUE
        )

        # 3) Data-filter table for this panel (hidden until selected).
        insertUI(
            selector = "#pb_table_container", where = "beforeEnd",
            ui = div(
                id = paste0(pid, "_table"),
                class = "pb-table-pane",
                style = "display:none;",
                dataFilterUI(paste0(pid, "_filter"))
            ),
            immediate = TRUE
        )

        # 4) Wire up the servers. The dataset is fixed; the filter feeds the plot.
        filtered <- dataFilterServer(
            paste0(pid, "_filter"),
            reactive(get(pid, envir = panel_data))
        )
        mod$server_fn(pid, data = filtered)

        # 5) Per-panel remove handler.
        observeEvent(input[[paste0(pid, "_remove")]], {
            remove_panel(pid)
        }, ignoreInit = TRUE)

        # 6) Register the panel and focus it in both dropdowns.
        rv$labels[[pid]] <- label
        rv$panel_ids <- c(rv$panel_ids, pid)
        refresh_selectors(selected = pid)
    })

    # --- Remove a panel ----------------------------------------------------
    remove_panel <- function(pid) {
        if (!pid %in% rv$panel_ids) {
            return(invisible(NULL))
        }
        removeUI(selector = paste0("#", pid, "_card"), immediate = TRUE)
        removeUI(selector = paste0("#", pid, "_controls"), immediate = TRUE)
        removeUI(selector = paste0("#", pid, "_table"), immediate = TRUE)
        if (exists(pid, envir = panel_data, inherits = FALSE)) {
            rm(list = pid, envir = panel_data)
        }
        rv$labels[[pid]] <- NULL
        rv$panel_ids <- setdiff(rv$panel_ids, pid)

        if (length(rv$panel_ids) == 0L) {
            shinyjs::show("pb_canvas_empty")
            shinyjs::show("pb_controls_empty")
            shinyjs::show("pb_table_empty")
        }
        refresh_selectors()
    }

    # --- Keep both selectors in sync with the active panels ----------------
    refresh_selectors <- function(selected = NULL) {
        choices <- stats::setNames(
            rv$panel_ids,
            vapply(rv$panel_ids, function(p) rv$labels[[p]], character(1))
        )
        pick <- function(current) {
            if (!is.null(selected)) {
                return(selected)
            }
            if (!is.null(current) && current %in% rv$panel_ids) {
                return(current)
            }
            if (length(rv$panel_ids)) rv$panel_ids[[1]] else NULL
        }
        updateSelectInput(session, "pb_controls_select",
            choices = choices, selected = pick(isolate(input$pb_controls_select))
        )
        updateSelectInput(session, "pb_table_select",
            choices = choices, selected = pick(isolate(input$pb_table_select))
        )
    }

    # --- Swap visible controls in/out --------------------------------------
    observeEvent(input$pb_controls_select, {
        sel <- input$pb_controls_select
        for (p in rv$panel_ids) {
            if (identical(p, sel)) {
                shinyjs::show(paste0(p, "_controls"))
            } else {
                shinyjs::hide(paste0(p, "_controls"))
            }
        }
    }, ignoreNULL = FALSE)

    # --- Swap visible table in/out -----------------------------------------
    observeEvent(input$pb_table_select, {
        sel <- input$pb_table_select
        for (p in rv$panel_ids) {
            if (identical(p, sel)) {
                shinyjs::show(paste0(p, "_table"))
            } else {
                shinyjs::hide(paste0(p, "_table"))
            }
        }
    }, ignoreNULL = FALSE)
}

shinyApp(ui, server)
