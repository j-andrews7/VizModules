# Tests for organize_inputs() grid-flow behavior.

test_that("organize_inputs gives each visible input exactly one grid cell", {
    n_cells <- function(ui) length(gregexpr("vizmodules-input-cell", as.character(ui))[[1]])

    # NULL inputs create no empty cell.
    expect_equal(n_cells(organize_inputs(tagList(div("a"), NULL, div("b")), columns = 2)), 2)

    # A uniform input block flows into one cell per visible input.
    block <- uniform_axes_inputs_ui(NS("x"))
    expect_equal(n_cells(organize_inputs(block, columns = 2)), sum(!vapply(block, is.null, logical(1))))

    # A tooltip-wrapped input stays a single cell.
    expect_equal(n_cells(organize_inputs(tagList(shinyBS::tipify(numericInput("a", "A", 1), "tip")), columns = 2)), 1)
})


test_that("module_tack_ui marks the download button for the image capture", {
    ui <- module_tack_ui(NS("m"))
    html <- as.character(ui)

    expect_true(grepl("viz-source-download", html, fixed = TRUE))
    # The prefix is how the script works out which plot on the page is this
    # module's; every output of the module is named with it.
    expect_true(grepl('data-viz-source-ns="m-"', html, fixed = TRUE))
    expect_true(grepl('id="m-download.source"', html, fixed = TRUE))

    deps <- vapply(htmltools::findDependencies(ui), function(d) d$name, character(1))
    expect_true("viz-source-export" %in% deps)

    # A module inside the Figure Builder is namespaced twice over, and the
    # script matches on the whole prefix.
    html <- as.character(module_tack_ui(NS(NS("fb")("panel1"))))
    expect_true(grepl('data-viz-source-ns="fb-panel1-"', html, fixed = TRUE))
})


# --- CSS containment ----------------------------------------------------------
# Every stylesheet this package ships is loaded into the *host* document, so a
# selector that is not anchored on a class the package owns restyles the host
# app. That is not hypothetical: multiColorPicker.css styled `.selectize-dropdown`
# generically, which broke every stock selectInput() dropdown on the page, and
# the Figure Builder styled `.well`, which shiny::sidebarPanel() renders.

# Prefixes this package owns. Anything else at the head of a selector reaches
# markup the package did not create.
viz_owned_prefix <- paste0(
    "^(",
    "\\.multi-color-picker|\\.mc-|",
    "\\.multi-dynamic-input|\\.mdi-|",
    "\\.vizmodules-|\\.viz-|",
    "\\.pb-|\\.a4-|",
    "\\.data-filter|\\.df-",
    ")"
)

# Split a stylesheet into individual selectors, dropping at-rules and comments.
viz_selectors <- function(css) {
    css <- paste(css, collapse = "\n")
    css <- gsub("/\\*.*?\\*/", "", css)
    groups <- regmatches(css, gregexpr("[^{}]+(?=\\{)", css, perl = TRUE))[[1]]
    sels <- trimws(unlist(strsplit(groups, ",", fixed = TRUE)))
    sels <- gsub("\\s+", " ", sels)
    sels <- sels[nzchar(sels)]
    # An at-rule's prelude (@media ...) is not a selector.
    sels[!startsWith(sels, "@")]
}


test_that("bundled stylesheets only style markup this package owns", {
    files <- list.files(
        system.file("src", package = "VizModules"),
        pattern = "\\.css$", full.names = TRUE
    )
    skip_if(length(files) == 0, "package not installed with inst/src")

    offenders <- character()
    for (f in files) {
        sels <- viz_selectors(readLines(f, warn = FALSE))
        bad <- sels[!grepl(viz_owned_prefix, sels)]
        if (length(bad)) {
            offenders <- c(offenders, paste0(basename(f), ": ", bad))
        }
    }
    expect_equal(offenders, character())
})


test_that("inline stylesheets only style markup this package owns", {
    for (fn in c(".data_filter_css", ".figure_builder_css")) {
        sels <- viz_selectors(get(fn)())
        bad <- sels[!grepl(viz_owned_prefix, sels)]
        expect_equal(bad, character(), info = fn)
    }
})


test_that("the containment check can actually fail", {
    # A tripwire that cannot fire pins nothing.
    leaky <- ".selectize-dropdown .option { padding: 0 }\n.mc-thing { color: red }"
    sels <- viz_selectors(leaky)
    expect_length(sels, 2)
    expect_length(sels[!grepl(viz_owned_prefix, sels)], 1)
})


test_that("the colour picker tags its own dropdown", {
    js <- readLines(
        system.file("src/multiColorPicker.js", package = "VizModules"),
        warn = FALSE
    )
    js <- paste(js, collapse = "\n")

    # The dropdown is parented to <body>, so this marker is the only thing the
    # stylesheet can scope to. Selectize replaces its default dropdownClass
    # wholesale, so its own class has to be restated alongside ours.
    expect_true(grepl("dropdownClass", js, fixed = TRUE))
    expect_true(grepl("mc-palette-dropdown", js, fixed = TRUE))
    expect_true(grepl("selectize-dropdown mc-palette-dropdown", js, fixed = TRUE))

    # ...and the stylesheet has to actually use it.
    css <- paste(readLines(
        system.file("src/multiColorPicker.css", package = "VizModules"),
        warn = FALSE
    ), collapse = "\n")
    expect_true(grepl(".mc-palette-dropdown", css, fixed = TRUE))
})


# --- The control grid ---------------------------------------------------------

test_that("organize_inputs keeps its layout out of inline styles", {
    ui <- organize_inputs(
        tagList(numericInput("a", "A", 1), numericInput("b", "B", 2)),
        columns = 2
    )
    html <- as.character(ui)

    # The negative-margin row idiom assumed a parent with matching padding; in a
    # sidebar with less than that, the grid overhung and the sidebar scrolled.
    expect_false(grepl("margin-left: -15px", html, fixed = TRUE))
    expect_false(grepl("margin-right: -15px", html, fixed = TRUE))
    # Per-cell padding went with it -- the gap is on the container now.
    expect_false(grepl("padding-left: 15px", html, fixed = TRUE))

    # Only the column count stays inline, because it varies per call. Inline
    # styles cannot be overridden without !important, so everything else lives
    # in the stylesheet.
    expect_true(grepl("--viz-input-columns: 2;", html, fixed = TRUE))

    deps <- vapply(htmltools::findDependencies(ui), function(d) d$name, character(1))
    expect_true("viz-modules" %in% deps)

    # A tabbed set is marked so the tab strip can wrap.
    tabbed <- organize_inputs(
        list(Data = tagList(numericInput("a", "A", 1)), Axes = tagList(numericInput("b", "B", 2))),
        columns = 1
    )
    expect_true(grepl("vizmodules-input-tabs", as.character(tabbed), fixed = TRUE))
})


# Records hide_input()/show_input() calls in place of the JavaScript they send.
.record_toggles <- function(env = parent.frame()) {
    calls <- new.env()
    calls$shown <- character(0)
    calls$hidden <- character(0)
    local_mocked_bindings(
        hide_input = function(session, ids) calls$hidden <- c(calls$hidden, ids),
        show_input = function(session, ids) calls$shown <- c(calls$shown, ids),
        .env = env
    )
    calls
}

test_that(".toggle_facet_title_inputs swaps the main title inputs for the facet ones", {
    main <- c("title.font.family", "title.font.color", "title.font.size", "axis.title.horizontal.position")
    facet <- c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family")

    calls <- .record_toggles()
    .toggle_facet_title_inputs(NULL, TRUE, extra = "facet.nrow")
    expect_setequal(calls$shown, c(facet, "facet.nrow"))
    expect_setequal(calls$hidden, main)

    calls <- .record_toggles()
    .toggle_facet_title_inputs(NULL, FALSE, extra = "facet.nrow")
    expect_setequal(calls$shown, main)
    expect_setequal(calls$hidden, c(facet, "facet.nrow"))
})

test_that(".toggle_facet_title_inputs never re-shows an input the app hid", {
    calls <- .record_toggles()
    .toggle_facet_title_inputs(NULL, FALSE, hidden = c("title.font.size", "legend.x"))
    expect_false("title.font.size" %in% calls$shown)
    expect_true("title.font.color" %in% calls$shown)

    calls <- .record_toggles()
    .toggle_facet_title_inputs(NULL, TRUE, hidden = "facet.title.font.color")
    expect_false("facet.title.font.color" %in% calls$shown)
    expect_true("facet.title.font.size" %in% calls$shown)
})

# ---- Reset returns controls to where they started ----------------------------

# The value a rendered numeric/checkbox control starts at, keyed by input id.
.ui_start_values <- function(ui, ids) {
    html <- as.character(htmltools::renderTags(ui)$html)
    stats::setNames(lapply(ids, function(id) {
        tag <- regmatches(html, regexpr(sprintf('<input id="%s"[^>]*>', gsub(".", "\\.", id, fixed = TRUE)), html))
        if (length(tag) == 0) {
            return(NULL)
        }
        if (grepl('type="checkbox"', tag, fixed = TRUE)) {
            return(grepl("checked", tag, fixed = TRUE))
        }
        as.numeric(sub('.*value="([^"]*)".*', "\\1", tag))
    }), ids)
}

# What a reset helper sends to each control, keyed by input id.
.reset_sent_values <- function(reset_fn, defaults = NULL) {
    sent <- list()
    # The update*Input() helpers insist on a session-classed object.
    session <- new.env()
    session$input <- list()
    # updateNumericInput() sends numbers as formatted strings.
    session$sendInputMessage <- function(inputId, message) {
        v <- message$value
        num <- suppressWarnings(as.numeric(v))
        sent[[inputId]] <<- if (is.character(v) && length(v) == 1 && !is.na(num)) num else v
    }
    class(session) <- "ShinySession"
    reset_fn(session, defaults)
    sent
}

test_that("reset_plotly_inputs() restores the values uniform_plotly_inputs_ui() starts at", {
    ids <- c("margin.t", "margin.b", "margin.l", "margin.r", "shape.line.width", "shape.opacity")
    for (defaults in list(NULL, list(margin.t = 12, margin.r = 34))) {
        start <- .ui_start_values(uniform_plotly_inputs_ui(identity, defaults), ids)
        sent <- .reset_sent_values(reset_plotly_inputs, defaults)
        for (id in ids) {
            expect_equal(sent[[id]], start[[id]], info = id)
        }
    }
})

test_that("subplot spacing starts and resets to the same values, honouring subplot.margin", {
    ids <- c("subplot.margin.x", "subplot.margin.y")
    for (defaults in list(NULL, list(subplot.margin = 0.05), list(subplot.margin = 0.05, subplot.margin.y = 0.2))) {
        start <- .ui_start_values(.uniform_subplot_spacing_inputs_ui(identity, defaults), ids)
        sent <- .reset_sent_values(reset_plotly_inputs, defaults)
        for (id in ids) {
            expect_equal(sent[[id]], start[[id]], info = paste(id, format(defaults)))
        }
    }
    expect_equal(.subplot_spacing_defaults(list(subplot.margin = 0.05)), list(x = 0.05, y = 0.05))
})

test_that(".reset_stats_inputs() restores the values the Stats tab starts at", {
    ids <- c("stats.enabled", "stat.hide.ns", "stat.paired", "stat.per.facet", "stat.sig.threshold",
        "stat.line.width", "stat.step.increase", "stat.text.bump", "stat.bracket.inset")
    start <- .ui_start_values(.uniform_stats_inputs_ui(identity), ids)
    sent <- .reset_sent_values(.reset_stats_inputs)
    for (id in ids) {
        expect_equal(sent[[id]], start[[id]], info = id)
    }
})

test_that("shape-drawing controls can be left out, and are for plots without cartesian axes", {
    shape_ids <- c("shape.fill", "shape.line.color", "shape.line.width", "shape.linetype", "shape.opacity")
    html_of <- function(ui) as.character(htmltools::renderTags(ui)$html)

    with_shapes <- html_of(uniform_plotly_inputs_ui(identity))
    without <- html_of(uniform_plotly_inputs_ui(identity, include.shapes = FALSE))
    for (id in shape_ids) {
        expect_true(grepl(sprintf('id="%s"', id), with_shapes, fixed = TRUE), info = id)
        expect_false(grepl(sprintf('id="%s"', id), without, fixed = TRUE), info = id)
    }
    expect_true(grepl('id="margin.t"', without, fixed = TRUE))

    uis <- list(
        pie = piePlotInputsUI("p", example_skills),
        radar = radarPlotInputsUI("r", example_skills),
        parallel = parallelCoordinatesPlotInputsUI("c", example_sales)
    )
    for (nm in names(uis)) {
        expect_false(grepl("shape.fill", html_of(uis[[nm]]), fixed = TRUE), info = nm)
    }
})


# ---- Reading module inputs that have not reported yet ----------------------

test_that(".nz_value answers FALSE where nzchar() would error", {
    # Every one of these is logical(0) under nzchar()/== "", which makes
    # `if (...)` an "argument is of length zero" error rather than a FALSE.
    expect_false(.nz_value(NULL))
    expect_false(.nz_value(character(0)))

    expect_false(.nz_value(""))
    expect_false(.nz_value(NA_character_))
    expect_false(.nz_value(c("a", "b")))

    expect_true(.nz_value("x"))
    expect_true(.nz_value("some.column"))
})


test_that("no module server tests a bare input with nzchar/is.na/== ''", {
    # viz_select_input() is a custom binding that reports late, and the plot
    # reactives only req() the x/y columns -- so group.by, fill.by, facet.by and
    # friends are readably NULL while the plot is first built. Each of the forms
    # below is logical(0) on a NULL, which makes `if (...)` an error rather than
    # a FALSE; they crashed the render across a dozen modules. Use .nz_value()
    # (for a column name) or .has_value() (for a number) instead.
    #
    # Checked against the deparsed bodies rather than the source files so this
    # holds for an installed package too.
    # covr's instrumentation splits `!is.null(x) && nzchar(x)` across lines, which
    # would flag every properly guarded read.
    skip_if(identical(Sys.getenv("R_COVR"), "true"), "function bodies are instrumented under covr")
    unsafe <- c(
        "nzchar(input$",
        "nzchar(isolate_fn(input$",
        "is.na(input$",
        "is.na(isolate_fn(input$"
    )
    # `!x == ""` parses as `!(x == "")`, so it deparses with the ! outermost.
    unsafe_rx <- "!\\s*\\(?\\s*(isolate_fn\\()?input\\$[A-Za-z._0-9]+\\)?\\s*==\\s*\"\""

    # Line by line, because `!is.null(x) && nzchar(x)` is a perfectly good
    # guard and must not be flagged -- it is only a bare test that is a bug.
    flag_lines <- function(src) {
        lines <- strsplit(src, "\n", fixed = TRUE)[[1]]
        lines <- lines[!grepl("is.null", lines, fixed = TRUE)]
        bad <- vapply(lines, function(ln) {
            any(vapply(unsafe, function(p) grepl(p, ln, fixed = TRUE), logical(1))) ||
                grepl(unsafe_rx, ln)
        }, logical(1))
        unname(trimws(lines[bad]))
    }

    ns <- asNamespace("VizModules")
    offenders <- character()

    for (nm in ls(ns, all.names = TRUE)) {
        obj <- get(nm, envir = ns)
        if (!is.function(obj)) {
            next
        }
        hits <- flag_lines(paste(deparse(body(obj)), collapse = "\n"))
        if (length(hits)) {
            offenders <- c(offenders, paste0(nm, ": ", hits))
        }
    }

    expect_equal(offenders, character())

    # The tripwire has to be able to fire, or it is pinning nothing.
    demo <- function(input) if (nzchar(input$group.by)) 1 else 2
    expect_length(flag_lines(paste(deparse(body(demo)), collapse = "\n")), 1)
    demo2 <- function(input) if (!input$facet.by == "") 1 else 2
    expect_length(flag_lines(paste(deparse(body(demo2)), collapse = "\n")), 1)
    # ...and has to leave a properly guarded read alone.
    ok <- function(input) if (!is.null(input$x) && nzchar(input$x)) 1 else 2
    expect_length(flag_lines(paste(deparse(body(ok)), collapse = "\n")), 0)
})
