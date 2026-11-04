# Render-performance benchmark for the VizModules showcase modules.
#
# Drives each module's example app in headless Chrome (shinytest2) and reports,
# per module:
#   * builds   - calls to the module's plot function (plotthis/dittoViz/native)
#                at startup and per input change, i.e. full structure rebuilds;
#   * renders  - plotly payloads sent to the browser;
#   * server   - ms from the input reaching the client's queue to the plot
#                payload (or layout-only update) arriving back;
#   * total    - ms from the input to the browser finishing the redraw;
#   * payload  - KB of the plot payload;
#   * ui       - ms to build the module's settings UI in R.
# It also saves a screenshot of every plot, for before/after visual diffs.
#
# Usage (from the package root, with NOT_CRAN=true set for shinytest2):
#   Rscript dev/bench/bench.R <label> [rows] [module ids...]
# e.g.
#   Rscript dev/bench/bench.R baseline
#   Rscript dev/bench/bench.R baseline 20000 box yplot scatter
# Results go to dev/bench/results/<label>/ (results.csv and <module>.png).

args <- commandArgs(trailingOnly = TRUE)
label <- if (length(args) >= 1) args[[1]] else "run"
rows <- if (length(args) >= 2) as.integer(args[[2]]) else 0L
only <- if (length(args) >= 3) args[-(1:2)] else NULL

Sys.setenv(NOT_CRAN = "true")
suppressPackageStartupMessages({
    library(shinytest2)
    pkgload::load_all(".", quiet = TRUE)
})
pkg <- normalizePath(".", winslash = "/")
out_dir <- file.path("dev", "bench", "results", label)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Per module: the app constructor, and a structural ("mapping") change that
# gives the plot different data to draw. A cosmetic change (title font size)
# and a margin change are measured for every module.
modules <- list(
    area      = list(app = "plotthis_AreaPlotApp", map = list("scale.y", FALSE)),
    bar       = list(app = "plotthis_BarPlotApp", map = list("y.data", "Score")),
    box       = list(app = "plotthis_BoxPlotApp", map = list("y.data", "age")),
    density   = list(app = "plotthis_DensityPlotApp", map = list("x.data", "age")),
    dotplot   = list(app = "plotthis_DotPlotApp", map = list("fill.by", "pct_expressed")),
    dumbbell  = list(app = "dumbbellPlotApp", map = list("facet.by", "")),
    freq      = list(app = "dittoViz_freqPlotApp", map = list("var", "batch")),
    histogram = list(app = "plotthis_HistogramApp", map = list("x.data", "salary")),
    line      = list(app = "linePlotApp", map = list("y.value", "profit")),
    parallel  = list(app = "parallelCoordinatesPlotApp", map = list("color.by", "revenue")),
    pie       = list(app = "piePlotApp", map = NULL),
    radar     = list(app = "radarPlotApp", map = NULL),
    scatter   = list(app = "dittoViz_scatterPlotApp", map = list("y.by", "profit")),
    splitbar  = list(app = "plotthis_SplitBarPlotApp", map = list("x.data", "Values")),
    yplot     = list(app = "dittoViz_yPlotApp", map = list("var", "age"))
)
if (!is.null(only)) modules <- modules[intersect(names(modules), only)]

builders <- c(
    "BarPlot", "BoxPlot", "AreaPlot", "DensityPlot", "DotPlot", "Histogram", "SplitBarPlot",
    "scatterPlot", "yPlot", "freqPlot", "dumbbellPlot", "linePlot", "radarPlot", "piePlot",
    "parallelCoordinatesPlot"
)

# Traces written into each app: a STAGE line per builder call and per plotly
# payload serialised, read back from the app's log.
tracer <- sprintf('
.vm_trace <- function(fname) {
    ns <- asNamespace("VizModules")
    env <- if (exists(fname, envir = ns, inherits = FALSE)) ns else parent.env(ns)
    if (!exists(fname, envir = env, inherits = FALSE)) return(invisible())
    suppressMessages(trace(fname, where = env, print = FALSE,
        exit = bquote(message("STAGE build ", .(fname)))))
}
for (f in c(%s)) .vm_trace(f)
suppressMessages(trace("toJSON", where = asNamespace("htmlwidgets"), print = FALSE,
    exit = quote(if (is.list(x) && !is.null(x$x$layout)) message("STAGE render"))))
', paste(sprintf('"%s"', builders), collapse = ", "))

app_source <- function(app_fn, id, rows) {
    c(
        sprintf("suppressPackageStartupMessages(pkgload::load_all('%s', quiet = TRUE))", pkg),
        tracer,
        sprintf("fn <- %s", app_fn),
        sprintf("rows <- %dL", rows),
        "if (rows > 0) {",
        sprintf("  ent <- .module_showcase()[['%s']]", id),
        "  d <- .example_datasets()[[ent$dataset]]; set.seed(1)",
        "  d <- d[rep(seq_len(nrow(d)), length.out = rows), , drop = FALSE]",
        "  num <- vapply(d, is.numeric, logical(1))",
        "  d[num] <- lapply(d[num], function(v) v * stats::runif(length(v), 0.9, 1.1))",
        "  fn(data_list = list(big = d), defaults = ent$defaults)",
        "} else fn()"
    )
}

# Records, per change, when the input was queued, when the plot payload (or a
# layout-only update) arrived and when plotly finished drawing it.
hook <- "
window.__vm = {events: []};
var push = function(e) { window.__vm.events.push(e); };
$(document).on('shiny:value', function(e) {
  if (e.name && /^active_plot-[A-Za-z]*[Pp]lot$/.test(e.name))
    push({type: 'value', t: performance.now(), kb: JSON.stringify(e.value).length / 1024});
});
$(document).on('shiny:message', function(e) {
  var m = e.message && e.message.custom;
  if (m && m['vizmodules-plotly-layout'])
    push({type: 'value', t: performance.now(), kb: JSON.stringify(m).length / 1024});
});
['newPlot', 'react'].forEach(function(m) {
  var orig = Plotly[m];
  Plotly[m] = function() {
    var r = orig.apply(this, arguments);
    if (r && r.then) r.then(function() {
      requestAnimationFrame(function() { push({type: 'drawn', t: performance.now()}); });
    });
    return r;
  };
});
"

stage_counts <- function(lines) {
    s <- sub("^STAGE ", "", grep("^STAGE ", lines, value = TRUE))
    c(builds = sum(startsWith(s, "build ")), renders = sum(s == "render"))
}

# Shiny can go idle while the widget is still resizing and reporting back, so
# also wait until the build and render counts have stopped changing.
settle <- function(app) {
    app$wait_for_idle(duration = 1500, timeout = 300 * 1000)
    last <- NULL
    stable <- 0
    for (i in 1:30) {
        Sys.sleep(1)
        now <- stage_counts(as.data.frame(app$get_logs())$message)
        stable <- if (identical(now, last)) stable + 1 else 0
        last <- now
        if (stable >= 2) break
    }
}

measure_change <- function(app, input, value, before) {
    app$run_js("window.__vm.events = [];")
    t0 <- app$get_js("performance.now()")
    app$run_js(sprintf(
        "Shiny.setInputValue('active_plot-%s', %s, {priority: 'event'});",
        input, jsonlite::toJSON(value, auto_unbox = TRUE)
    ))
    settle(app)
    ev <- jsonlite::fromJSON(app$get_js("JSON.stringify(window.__vm.events)"), simplifyVector = TRUE)
    logs <- as.data.frame(app$get_logs())$message
    # The log interleaves browser and R lines by time, so count totals.
    after <- stage_counts(logs)
    counts <- after - before
    val <- if (length(ev)) ev[ev$type == "value", , drop = FALSE] else NULL
    drawn <- if (length(ev)) ev[ev$type == "drawn", , drop = FALSE] else NULL
    list(
        totals = after,
        row = data.frame(
            builds = counts[["builds"]], renders = counts[["renders"]],
            server_ms = if (NROW(val)) max(val$t) - t0 else NA,
            total_ms = if (NROW(drawn)) max(drawn$t) - t0 else NA,
            payload_kb = if (NROW(val)) sum(val$kb) else 0
        )
    )
}

ui_time <- function(id) {
    ent <- .module_showcase()[[id]]
    d <- .example_datasets()[[ent$dataset]]
    stats::median(vapply(1:3, function(i) {
        system.time(ent$inputs_ui(id, d, defaults = ent$defaults))[["elapsed"]]
    }, numeric(1))) * 1000
}

results <- list()
for (id in names(modules)) {
    m <- modules[[id]]
    app_dir <- file.path(tempdir(), paste0("vmbench_", id))
    dir.create(app_dir, showWarnings = FALSE)
    writeLines(app_source(m$app, id, rows), file.path(app_dir, "app.R"))

    message("Benchmarking ", id, if (rows > 0) paste0(" at ", rows, " rows"))
    app <- AppDriver$new(app_dir, load_timeout = 300 * 1000, timeout = 300 * 1000,
        height = 1000, width = 1400)
    settle(app)
    logs <- as.data.frame(app$get_logs())$message
    start <- stage_counts(logs)
    totals <- start

    shot <- file.path(out_dir, paste0(id, if (rows > 0) paste0("_", rows), ".png"))
    try(app$get_screenshot(shot, selector = ".plotly.html-widget"), silent = TRUE)

    app$run_js(hook)
    # The first change after startup can overlap the browser finishing its own
    # startup work, so the cosmetic change is timed twice; cosmetic2 is the
    # steady-state figure.
    changes <- list(
        cosmetic = list("title.font.size", 22), cosmetic2 = list("title.font.size", 24),
        margin = list("margin.r", 120)
    )
    if (!is.null(m$map)) changes$mapping <- m$map
    for (nm in names(changes)) {
        res <- measure_change(app, changes[[nm]][[1]], changes[[nm]][[2]], totals)
        totals <- res$totals
        results[[length(results) + 1]] <- cbind(
            data.frame(module = id, rows = rows, change = nm,
                startup_builds = start[["builds"]], startup_renders = start[["renders"]]),
            res$row
        )
    }
    app$stop()
}

out <- do.call(rbind, results)
ui <- vapply(unique(out$module), ui_time, numeric(1))
out$ui_ms <- unname(ui[out$module])
csv <- file.path(out_dir, if (rows > 0) sprintf("results_%d.csv", rows) else "results.csv")
utils::write.csv(out, csv, row.names = FALSE)
num <- vapply(out, is.numeric, logical(1))
out[num] <- lapply(out[num], round)
print(out, row.names = FALSE)
message("Wrote ", csv)
