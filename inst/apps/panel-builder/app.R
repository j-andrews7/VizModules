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

# The bundled datasets that seed the dataset registry. Users can add their own
# datasets at runtime via the "Load Data" section (see the server below), which
# are appended to this catalogue.
initial_datasets <- list(
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
#pb_canvas_scroll {
    overflow: auto;
    border: 1px solid #e0e0e0;
    background: #ececec;
    padding: 16px;
    border-radius: 6px;
}
#pb_canvas {
    position: relative;
    margin: 0 auto;
    background:
        #fff
        linear-gradient(90deg, #f3f3f3 1px, transparent 1px) 0 0 / 24px 24px,
        linear-gradient(0deg, #f3f3f3 1px, transparent 1px) 0 0 / 24px 24px;
    box-shadow: 0 1px 8px rgba(0,0,0,0.2);
    overflow: hidden;
}
/* A4 page sizes at 96dpi (210 x 297 mm). */
#pb_canvas.a4-portrait  { width: 794px;  height: 1123px; }
#pb_canvas.a4-landscape { width: 1123px; height: 794px; }
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
/* A small floating toolbar that only appears while hovering a card. It holds
   the drag handle and remove button so the static card (and the SVG export)
   stays free of any chrome. */
.viz-panel-toolbar {
    position: absolute;
    top: 4px;
    left: 4px;
    z-index: 10;
    display: flex;
    align-items: center;
    gap: 2px;
    padding: 2px 4px;
    background: rgba(44, 62, 80, 0.85);
    border-radius: 4px;
    opacity: 0;
    transition: opacity 0.15s ease-in-out;
    pointer-events: none;
}
.viz-panel-card:hover .viz-panel-toolbar { opacity: 1; pointer-events: auto; }
.viz-panel-drag {
    cursor: move;
    color: #fff;
    padding: 0 4px;
    font-size: 13px;
    line-height: 1;
    user-select: none;
}
.viz-panel-remove {
    background: transparent; border: none; color: #fff;
    padding: 0 4px; line-height: 1; cursor: pointer; font-size: 13px;
}
.viz-panel-remove:hover { color: #ff7675; }
.viz-panel-body { flex: 1 1 auto; padding: 6px; overflow: hidden; }
/* Let the plot fill the card so vertical resizing changes the plot height,
   not just the width. */
.viz-panel-body > .html-widget,
.viz-panel-body > .shiny-plot-output,
.viz-panel-body .js-plotly-plot,
.viz-panel-body .plotly,
.viz-panel-body .plot-container {
    width: 100% !important;
    height: 100% !important;
}
.pb-empty-hint { color: #999; text-align: center; padding-top: 30vh; }
")

# Client-side export of the whole canvas to a single SVG file. Each plot is a
# Plotly chart, so we ask Plotly for an SVG of every plot and stitch them into
# one SVG document positioned to match the cards on the A4 canvas. This keeps
# the output vector-based, suitable for a poster or composite figure.
app_js <- HTML("
function pbDownloadSVG() {
    var canvas = document.getElementById('pb_canvas');
    if (!canvas) { return; }
    var cards = canvas.querySelectorAll('.viz-panel-card');
    if (!cards.length) {
        alert('Add at least one plot before downloading.');
        return;
    }
    var W = canvas.clientWidth, H = canvas.clientHeight;
    var canvasRect = canvas.getBoundingClientRect();
    var tasks = [];
    cards.forEach(function(card) {
        var cardRect = card.getBoundingClientRect();
        var x = cardRect.left - canvasRect.left + canvas.scrollLeft;
        var y = cardRect.top - canvasRect.top + canvas.scrollTop;
        var w = cardRect.width, h = cardRect.height;
        var body = card.querySelector('.viz-panel-body');
        var gd = card.querySelector('.js-plotly-plot');
        var pw = body ? body.clientWidth : w;
        var ph = body ? body.clientHeight : h;
        var meta = { x: x, y: y, w: w, h: h, pw: pw, ph: ph, url: null };
        if (gd && window.Plotly) {
            tasks.push(
                Plotly.toImage(gd, { format: 'svg', width: pw, height: ph })
                    .then(function(url) { meta.url = url; return meta; })
                    .catch(function() { return meta; })
            );
        } else {
            tasks.push(Promise.resolve(meta));
        }
    });
    Promise.all(tasks).then(function(items) {
        var parts = [];
        parts.push('<?xml version=\"1.0\" encoding=\"UTF-8\"?>');
        parts.push('<svg xmlns=\"http://www.w3.org/2000/svg\" ' +
            'xmlns:xlink=\"http://www.w3.org/1999/xlink\" ' +
            'width=\"' + W + '\" height=\"' + H + '\" ' +
            'viewBox=\"0 0 ' + W + ' ' + H + '\">');
        parts.push('<rect x=\"0\" y=\"0\" width=\"' + W + '\" height=\"' + H +
            '\" fill=\"#ffffff\"/>');
        items.forEach(function(it) {
            parts.push('<g>');
            if (it.url) {
                parts.push('<image x=\"' + (it.x + 6) + '\" y=\"' +
                    (it.y + 6) + '\" width=\"' + it.pw +
                    '\" height=\"' + it.ph + '\" xlink:href=\"' + it.url + '\"/>');
            }
            parts.push('</g>');
        });
        parts.push('</svg>');
        var blob = new Blob([parts.join('\\n')], { type: 'image/svg+xml' });
        var a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'vizmodules-panel.svg';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(a.href);
    });
}

// Keep each plot sized to its card so dragging the resize handle changes the
// plot's height as well as its width. jQuery UI resizable only resizes the
// card div, so we watch each card body and ask Plotly to relayout to fit.
var pbCardObservers = new WeakMap();
function pbResizePlot(card) {
    var gd = card.querySelector('.js-plotly-plot');
    if (gd && window.Plotly) { Plotly.Plots.resize(gd); }
}
function pbObserveCard(card) {
    if (pbCardObservers.has(card) || !window.ResizeObserver) { return; }
    var body = card.querySelector('.viz-panel-body');
    if (!body) { return; }
    var ro = new ResizeObserver(function() { pbResizePlot(card); });
    ro.observe(body);
    pbCardObservers.set(card, ro);
}
function pbUnobserveCard(card) {
    var ro = pbCardObservers.get(card);
    if (ro) { ro.disconnect(); pbCardObservers.delete(card); }
}
function pbFindCard(node) {
    if (node.nodeType !== 1) { return null; }
    if (node.classList && node.classList.contains('viz-panel-card')) { return node; }
    if (node.querySelector) { return node.querySelector('.viz-panel-card'); }
    return null;
}
function pbContainsPlot(node) {
    if (node.nodeType !== 1) { return false; }
    if (node.classList && node.classList.contains('js-plotly-plot')) { return true; }
    return node.querySelector ? !!node.querySelector('.js-plotly-plot') : false;
}
// Ask every plot on the canvas to relayout to its container. A card body is a
// fixed-size flex box, so its ResizeObserver never fires after Plotly finishes
// its (asynchronous) initial render. Without this nudge a freshly added plot can
// stay blank, which is why plots stopped appearing after the first few. We also
// dispatch a window resize so any plot that measured a zero-size container
// re-measures and draws.
function pbResizeAllPlots() {
    if (!window.Plotly) { return; }
    document.querySelectorAll('#pb_canvas .js-plotly-plot').forEach(function(gd) {
        try { Plotly.Plots.resize(gd); } catch (e) {}
    });
}
function pbScheduleResize() {
    [50, 200, 500].forEach(function(t) {
        setTimeout(function() {
            pbResizeAllPlots();
            if (window.dispatchEvent) { window.dispatchEvent(new Event('resize')); }
        }, t);
    });
}
$(function() {
    var canvas = document.getElementById('pb_canvas');
    if (!canvas) { return; }
    // Attach observers to cards added at runtime and tear them down on removal
    // so detached cards do not leak their ResizeObserver. Nudge plots to resize
    // whenever a card or a plot is inserted so none are left blank.
    var mo = new MutationObserver(function(mutations) {
        mutations.forEach(function(m) {
            m.addedNodes.forEach(function(node) {
                var card = pbFindCard(node);
                if (card) { pbObserveCard(card); pbScheduleResize(); }
                if (pbContainsPlot(node)) { pbScheduleResize(); }
            });
            m.removedNodes.forEach(function(node) {
                var card = pbFindCard(node);
                if (card) { pbUnobserveCard(card); }
            });
        });
    });
    mo.observe(canvas, { childList: true, subtree: true });
});
")

# --- UI --------------------------------------------------------------------
ui <- fluidPage(
    title = "VizModules Panel Builder",
    shinyjs::useShinyjs(),
    tags$head(tags$style(app_css), tags$script(app_js)),
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
            downloadButton("download.summary", "Download Summary",
                class = "btn-primary"),
            hr(),
            h4("Load Data"),
            helpText(
                "Upload a CSV, TSV or RDS file to make it available as a",
                "dataset when adding plots."
            ),
            textInput("pb_data_name", "Dataset name (optional):",
                placeholder = "Defaults to the file name"
            ),
            fileInput("pb_data_file", "Data file:",
                accept = c(".csv", ".tsv", ".txt", ".rds", ".RDS")
            ),
            actionButton("pb_data_add", "Add dataset", icon = icon("upload")),
            hr(),
            h4("Canvas"),
            selectInput("pb_orientation", "Page size:",
                choices = c("A4 portrait" = "portrait",
                            "A4 landscape" = "landscape")
            ),
            tags$button("Download Panel (SVG)",
                id = "pb_download", type = "button",
                class = "btn btn-success", onclick = "pbDownloadSVG()"
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
                id = "pb_canvas_scroll",
                div(
                    id = "pb_canvas", class = "a4-portrait",
                    div(class = "pb-empty-hint", id = "pb_canvas_empty",
                        "No plots yet. Click \"Add Plot\" to begin.")
                )
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
    # Registry of datasets available to the "Add Plot" dialog. Seeded with the
    # bundled examples and extended at runtime via the "Load Data" section.
    dataset_store <- reactiveVal(initial_datasets)

    # Reactive bookkeeping for the panels currently on the canvas.
    rv <- reactiveValues(
        panel_ids = character(0), # ordered vector of active panel ids
        labels    = list(),       # pid -> display label
        counter   = 0L            # monotonic id source
    )

    # Per-panel data snapshots (fixed at creation time) and the observers that
    # power each card's remove button. Storing the data in reactiveValues lets
    # us null it out on removal so any lingering reactive reads short-circuit
    # via req() instead of erroring.
    panel_data <- reactiveValues()
    # Per-panel summary reactives returned by each module server. Used to bundle
    # every plot's interactive summary (plot + data + inputs) into one download.
    panel_summaries <- reactiveValues()
    panel_observers <- new.env(parent = emptyenv())

    # Always render new cards at the top-left of the canvas; they can then be
    # dragged into position.
    next_offset <- function(n) {
        list(top = 20L, left = 20L)
    }

    # --- Load custom data --------------------------------------------------
    observeEvent(input$pb_data_add, {
        file <- input$pb_data_file
        if (is.null(file)) {
            showNotification("Choose a file to load first.", type = "warning")
            return(invisible(NULL))
        }
        ext <- tolower(tools::file_ext(file$name))
        df <- tryCatch({
            switch(ext,
                csv = utils::read.csv(file$datapath,
                    stringsAsFactors = FALSE, check.names = FALSE),
                tsv = utils::read.delim(file$datapath,
                    stringsAsFactors = FALSE, check.names = FALSE),
                txt = utils::read.delim(file$datapath,
                    stringsAsFactors = FALSE, check.names = FALSE),
                rds = readRDS(file$datapath),
                stop("Unsupported file type '.", ext, "'.")
            )
        }, error = function(e) e)

        if (inherits(df, "error")) {
            showNotification(paste("Could not read file:", conditionMessage(df)),
                type = "error", duration = 8)
            return(invisible(NULL))
        }
        if (!is.data.frame(df)) {
            df <- tryCatch(as.data.frame(df, check.names = FALSE),
                error = function(e) NULL)
        }
        if (!is.data.frame(df) || nrow(df) == 0L || ncol(df) == 0L) {
            showNotification("File must contain a non-empty data frame.",
                type = "error", duration = 8)
            return(invisible(NULL))
        }

        nm <- trimws(input$pb_data_name)
        if (!nzchar(nm)) {
            nm <- tools::file_path_sans_ext(basename(file$name))
        }
        store <- dataset_store()
        # Ensure a unique name so existing datasets are never overwritten.
        base <- nm
        i <- 1L
        while (nm %in% names(store)) {
            i <- i + 1L
            nm <- paste0(base, " (", i, ")")
        }
        store[[nm]] <- df
        dataset_store(store)
        updateTextInput(session, "pb_data_name", value = "")
        showNotification(
            sprintf("Added dataset '%s' (%d rows x %d cols).",
                nm, nrow(df), ncol(df)),
            type = "message"
        )
    })

    # --- Canvas page size --------------------------------------------------
    observeEvent(input$pb_orientation, {
        if (identical(input$pb_orientation, "landscape")) {
            shinyjs::removeClass("pb_canvas", "a4-portrait")
            shinyjs::addClass("pb_canvas", "a4-landscape")
        } else {
            shinyjs::removeClass("pb_canvas", "a4-landscape")
            shinyjs::addClass("pb_canvas", "a4-portrait")
        }
    })

    # --- Add Plot dialog ---------------------------------------------------
    observeEvent(input$pb_add, {
        showModal(modalDialog(
            title = "Add a Plot",
            selectInput("pb_new_module", "Plot type:",
                choices = module_choices
            ),
            selectInput("pb_new_dataset", "Dataset:",
                choices = names(dataset_store())
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
        if (!is.null(mod) && mod$dataset %in% names(dataset_store())) {
            updateSelectInput(session, "pb_new_dataset",
                selected = mod$dataset
            )
        }
    })

    # --- Create a panel ----------------------------------------------------
    observeEvent(input$pb_add_confirm, {
        datasets <- dataset_store()
        mod_key <- input$pb_new_module
        ds_name <- input$pb_new_dataset
        mod <- module_registry[[mod_key]]
        req(mod, ds_name %in% names(datasets))
        removeModal()

        rv$counter <- rv$counter + 1L
        pid <- paste0("panel", rv$counter)
        data_snapshot <- datasets[[ds_name]]
        panel_data[[pid]] <- data_snapshot

        label <- sprintf("%s #%d (%s)", mod$label, rv$counter, ds_name)
        # Only apply built-in defaults when the dataset they target is chosen.
        defaults <- if (identical(ds_name, mod$dataset)) mod$defaults else list()

        # Hide empty-state hints once the first panel is added.
        shinyjs::hide("pb_canvas_empty")
        shinyjs::hide("pb_controls_empty")
        shinyjs::hide("pb_table_empty")

        # 1) Plot card on the canvas (draggable via the hover toolbar's grip,
        #    resizable from the corner). The toolbar only appears on hover and
        #    is excluded from the SVG export, so the card stays free of chrome.
        pos <- next_offset(rv$counter - 1L)
        card <- div(
            id = paste0(pid, "_card"),
            class = "viz-panel-card",
            style = sprintf("top:%dpx; left:%dpx;", pos$top, pos$left),
            div(
                class = "viz-panel-toolbar",
                span(
                    class = "viz-panel-drag", title = label,
                    icon("grip-vertical")
                ),
                tags$button(
                    id = paste0(pid, "_remove"),
                    class = "viz-panel-remove action-button",
                    type = "button", title = "Remove plot",
                    icon("times")
                )
            ),
            div(class = "viz-panel-body", mod$output_ui(pid, resizable = FALSE))
        )
        insertUI(
            selector = "#pb_canvas", where = "beforeEnd",
            ui = shinyjqui::jqui_draggable(
                shinyjqui::jqui_resizable(card),
                options = list(handle = ".viz-panel-drag", containment = "parent")
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

        # 4) Wire up the servers. The dataset is fixed; the filter feeds the
        #    plot. Reads short-circuit once the panel's data is removed.
        panel_reactive <- reactive({
            d <- panel_data[[pid]]
            req(d)
            d
        })
        filtered <- dataFilterServer(paste0(pid, "_filter"), panel_reactive)
        # The module server returns a reactive yielding its interactive summary
        # (plot + data + inputs); keep it so we can bundle every panel together.
        panel_summaries[[pid]] <- mod$server_fn(pid, data = filtered)

        # 5) Per-panel remove handler (tracked so it can be destroyed on remove).
        panel_observers[[pid]] <- observeEvent(
            input[[paste0(pid, "_remove")]],
            {
                remove_panel(pid)
            },
            ignoreInit = TRUE
        )

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
        # Destroy the jQuery UI interactions before pulling the DOM nodes so the
        # remaining cards are never disturbed by orphaned handlers.
        shinyjqui::jqui_draggable(paste0("#", pid, "_card"),
            operation = "destroy")
        shinyjqui::jqui_resizable(paste0("#", pid, "_card"),
            operation = "destroy")
        removeUI(selector = paste0("#", pid, "_card"), immediate = TRUE)
        removeUI(selector = paste0("#", pid, "_controls"), immediate = TRUE)
        removeUI(selector = paste0("#", pid, "_table"), immediate = TRUE)

        # Tear down the panel's bookkeeping so its controls/table cannot linger.
        if (!is.null(panel_observers[[pid]])) {
            panel_observers[[pid]]$destroy()
            rm(list = pid, envir = panel_observers)
        }
        panel_data[[pid]] <- NULL
        panel_summaries[[pid]] <- NULL
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
  
    # --- Summary download --------------------------------------------------
    # Bundle every panel's interactive summary (plot + data + inputs) into a
    # single .zip. We collect each panel's summary reactive (returned by its
    # module server) and hand a named list of summaries to .create_download_file,
    # which writes one set of files per panel. Handled entirely in R.
    output$download.summary <- .create_download_file(
        data_list = reactive({
            ids <- rv$panel_ids
            validate(need(length(ids) > 0,
                "Add at least one plot before downloading."))
            summaries <- lapply(ids, function(p) {
                sr <- panel_summaries[[p]]
                if (is.null(sr)) {
                    return(NULL)
                }
                # Skip (rather than abort the whole download) if a single
                # panel's summary cannot be built.
                tryCatch(sr(), error = function(e) {
                    warning("Could not build summary for panel '", p, "': ",
                        conditionMessage(e))
                    NULL
                })
            })
            names(summaries) <- vapply(ids,
                function(p) rv$labels[[p]], character(1))
            summaries[!vapply(summaries, is.null, logical(1))]
        }),
        filename_base = "panel_summary"
    )
}

shinyApp(ui, server)


