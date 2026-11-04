# Browser checks for the plot widget's in-place updates.
#
# For a module app it checks, after several re-renders, that:
#   * styling changes reach the browser as layout-only updates (no full
#     render), and are drawn;
#   * re-renders go through Plotly.react() rather than purge + newPlot;
#   * the graph's event listeners do not stack up (one per event, as at start);
#   * a user's zoom survives a styling change and resets on a mapping change;
#   * a selection reaches the server once;
#   * after an error hides the plot, putting the input back shows it again,
#     although the figure then matches the one sent before the error.
#
# Usage (from the package root, NOT_CRAN=true):
#   Rscript dev/bench/check_client.R [module ids...]
args <- commandArgs(trailingOnly = TRUE)
Sys.setenv(NOT_CRAN = "true")
suppressPackageStartupMessages(library(shinytest2))
pkg <- normalizePath(".", winslash = "/")

# map: an input change that redraws the plot; err: one that fails the render's req().
modules <- list(
    scatter = list(app = "dittoViz_scatterPlotApp", map = list("y.by", "profit"), err = "y.by"),
    box = list(app = "plotthis_BoxPlotApp", map = list("y.data", "age"), err = "y.data"),
    line = list(app = "linePlotApp", map = list("y.value", "profit"), err = NULL)
)
if (length(args)) modules <- modules[args]

hook <- "
window.__vm = {react: 0, newPlot: 0, purge: 0, values: 0, layouts: 0};
['react', 'newPlot', 'purge'].forEach(function(m) {
  var orig = Plotly[m];
  Plotly[m] = function() { window.__vm[m]++; return orig.apply(this, arguments); };
});
$(document).on('shiny:value', function(e) {
  if (e.name && /^active_plot-[A-Za-z]*[Pp]lot$/.test(e.name)) window.__vm.values++;
});
$(document).on('shiny:message', function(e) {
  if (e.message && e.message.custom && e.message.custom['vizmodules-plotly-layout']) window.__vm.layouts++;
});
"
gd <- "document.querySelector('.js-plotly-plot')"
listeners <- sprintf("(function(){ var gd = %s; var ev = gd._ev && gd._ev._events || {};
  var out = {}; Object.keys(ev).forEach(function(k){ out[k] = Array.isArray(ev[k]) ? ev[k].length : 1; });
  return JSON.stringify(out); })()", gd)
xrange <- sprintf("JSON.stringify(%s._fullLayout.xaxis.range)", gd)
counts <- function(app) jsonlite::fromJSON(app$get_js("JSON.stringify(window.__vm)"))

settle <- function(app) {
    app$wait_for_idle(duration = 1000, timeout = 120 * 1000)
    Sys.sleep(1)
}
set_input <- function(app, id, value) {
    app$run_js(sprintf("Shiny.setInputValue('active_plot-%s', %s, {priority: 'event'});",
        id, jsonlite::toJSON(value, auto_unbox = TRUE)))
    settle(app)
}

for (id in names(modules)) {
    m <- modules[[id]]
    app_dir <- file.path(tempdir(), paste0("vmcheck_", id))
    dir.create(app_dir, showWarnings = FALSE)
    writeLines(c(
        sprintf("suppressPackageStartupMessages(pkgload::load_all('%s', quiet = TRUE))", pkg),
        sprintf("%s()", m$app)
    ), file.path(app_dir, "app.R"))
    app <- AppDriver$new(app_dir, load_timeout = 3e5, timeout = 3e5, height = 1000, width = 1400)
    settle(app)
    app$run_js(hook)
    before <- jsonlite::fromJSON(app$get_js(listeners))

    for (i in 1:4) set_input(app, "title.font.size", 20 + i)
    after <- jsonlite::fromJSON(app$get_js(listeners))
    calls <- counts(app)
    title_size <- app$get_js(sprintf("%s._fullLayout.title.font.size", gd))

    # Zoom in, then restyle: the zoom should stay. Then change what is drawn: it should go.
    # Zoom with a real drag across the plot: uirevision preserves what the user
    # does through the UI (a plain Plotly.relayout() call counts as the app's).
    box <- jsonlite::fromJSON(app$get_js(sprintf("(function(){ var r = %s.querySelector('.nsewdrag').getBoundingClientRect();
        return JSON.stringify({x: r.left, y: r.top, w: r.width, h: r.height}); })()", gd)))
    cdp <- app$get_chromote_session()
    from <- c(box$x + box$w * 0.2, box$y + box$h * 0.3)
    to <- c(box$x + box$w * 0.5, box$y + box$h * 0.7)
    cdp$Input$dispatchMouseEvent(type = "mouseMoved", x = from[1], y = from[2])
    cdp$Input$dispatchMouseEvent(type = "mousePressed", x = from[1], y = from[2], button = "left", clickCount = 1)
    for (k in 1:5) {
        p <- from + (to - from) * k / 5
        cdp$Input$dispatchMouseEvent(type = "mouseMoved", x = p[1], y = p[2], button = "left")
    }
    cdp$Input$dispatchMouseEvent(type = "mouseReleased", x = to[1], y = to[2], button = "left", clickCount = 1)
    settle(app)
    zoomed <- jsonlite::fromJSON(app$get_js(xrange))
    set_input(app, "title.font.size", 30)
    restyled <- jsonlite::fromJSON(app$get_js(xrange))
    set_input(app, m$map[[1]], m$map[[2]])
    remapped <- jsonlite::fromJSON(app$get_js(xrange))

    # One selection should arrive once, however many renders came before.
    app$run_js(sprintf("window.__sel = 0; $(document).on('shiny:inputchanged', function(e) {
        if (/plotly_selected/.test(e.name)) window.__sel++; });
        %s.emit('plotly_selected', {points: []});", gd))
    Sys.sleep(1)
    selected <- app$get_js("window.__sel")

    # Fail the render, then put the input back: the figure is the one sent
    # before the error, but the plot must be shown again.
    recovered <- NA
    if (!is.null(m$err)) {
        good <- app$get_value(input = paste0("active_plot-", m$err))
        set_input(app, m$err, "")
        hidden <- app$get_js(sprintf("getComputedStyle(%s).visibility", gd))
        n0 <- counts(app)$values
        set_input(app, m$err, good)
        shown <- app$get_js(sprintf("getComputedStyle(%s).visibility", gd))
        recovered <- sprintf("%s (hidden=%s, full renders=%d)", identical(shown, "visible"),
            identical(hidden, "hidden"), counts(app)$values - n0)
    }

    same_listeners <- identical(before[sort(names(before))], after[sort(names(after))])
    cat(sprintf(paste0(
        "CHECK %-8s 4 restyles: full renders=%d layout updates=%d title size=%s | react=%d newPlot=%d purge=%d |",
        " listeners stable=%s (%s) | zoom kept on restyle=%s, reset on mapping=%s | selection sent %s time(s) |",
        " shown again after an error=%s\n"),
        id, calls$values, calls$layouts, title_size, calls$react, calls$newPlot, calls$purge, same_listeners,
        paste(sprintf("%s:%s", names(after), unlist(after)), collapse = ","),
        isTRUE(all.equal(zoomed, restyled)), !isTRUE(all.equal(zoomed, remapped)), selected, recovered
    ))
    app$stop()
}
