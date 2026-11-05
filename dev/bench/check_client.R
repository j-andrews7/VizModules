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
#     although the figure then matches the one sent before the error;
#   * after a palette change, every legend swatch shows its trace's new colour;
#   * with colour and shape both mapped, the legend has a section for each, a
#     click on an entry hides its level's points, a double-click shows only its
#     level, and both survive a styling change;
#   * a selection leaves nothing dimmed once its annotations are drawn: that redraw
#     is a new plot, so the figure goes out whole, whose traces hold no selection.
#
# Usage (from the package root, NOT_CRAN=true):
#   Rscript dev/bench/check_client.R [module ids...]
args <- commandArgs(trailingOnly = TRUE)
Sys.setenv(NOT_CRAN = "true")
suppressPackageStartupMessages(library(shinytest2))
pkg <- normalizePath(".", winslash = "/")

# map: an input change that redraws the plot; err: one that fails the render's req();
# palette: whether the module has a palette.colours picker to recolour the groups with;
# shape: an input change that maps shape alongside colour; annotate: the Annotate By
# column for a selection.
modules <- list(
    scatter = list(app = "dittoViz_scatterPlotApp", map = list("y.by", "profit"), err = "y.by",
        shape = list("shape.by", "region"), annotate = "sale_id"),
    yplot = list(app = "dittoViz_yPlotApp", map = NULL, err = NULL, shape = list("shape.by", "gender"),
        annotate = "employee_id"),
    box = list(app = "plotthis_BoxPlotApp", map = list("y.data", "age"), err = "y.data"),
    line = list(app = "linePlotApp", map = list("y.value", "profit"), err = NULL),
    area = list(app = "plotthis_AreaPlotApp", map = NULL, err = NULL, palette = TRUE),
    dumbbell = list(app = "dumbbellPlotApp", map = NULL, err = NULL, palette = TRUE)
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
# Each legend entry's swatch colour beside its trace's as now drawn (not the legend's
# own copy of the trace, which is as stale as the legend), as rgb() with the alpha
# dropped: the legend draws a fill's opacity separately.
swatches <- sprintf("(function(){ var gd = %s;
  function rgb(c){ var d = document.createElement('div'); d.style.color = c; document.body.appendChild(d);
    var v = getComputedStyle(d).color; d.remove(); return (v.match(/[0-9.]+/g) || []).slice(0, 3).join(','); }
  var out = [];
  gd.querySelectorAll('.legend .traces').forEach(function(item){
    var cd = item.__data__ && item.__data__[0], drawn_tr = cd && cd.trace; if (!drawn_tr) return;
    var tr = gd._fullData[drawn_tr.index] || drawn_tr;
    var sw = item.querySelector('.legendfill path, .legendpoints path, .legendlines path'); if (!sw) return;
    var shown = sw.style.fill && sw.style.fill !== 'none' ? sw.style.fill : sw.style.stroke;
    var drawn = tr.fill && tr.fill !== 'none' ? tr.fillcolor :
      (tr.marker && typeof tr.marker.color === 'string' ? tr.marker.color : tr.line && tr.line.color);
    out.push({name: String(tr.name), legend: rgb(shown), trace: rgb(drawn)});
  });
  return JSON.stringify(out); })()", gd)
# The legend sections' state: the levels hidden in each, and how many point traces
# disagree with them (one is hidden exactly when its colour or its shape is).
sections <- sprintf("(function(){ var gd = %s;
  var out = {color: [], shape: [], entries: {color: [], shape: []}, points: 0, wrong: 0};
  var tag = function(t){ return t.meta && t.meta.vizmodules_legend; };
  gd.data.forEach(function(t){ var m = tag(t); if (m && m.entry) { out.entries[m.entry].push(m[m.entry]);
    if (t.visible === 'legendonly') out[m.entry].push(m[m.entry]); } });
  gd.data.forEach(function(t){ var m = tag(t); if (!m || m.entry || m.shape === undefined) return; out.points++;
    var off = out.color.indexOf(m.color) >= 0 || out.shape.indexOf(m.shape) >= 0;
    if (off !== (t.visible === 'legendonly')) out.wrong++; });
  var ev = gd._ev && gd._ev._events || {}; var n = ev.plotly_legendclick;
  out.handlers = Array.isArray(n) ? n.length : (n ? 1 : 0);
  return JSON.stringify(out); })()", gd)
click_legend <- function(app, label, double = FALSE) {
    # A real click, as plotly counts a double-click from the mouse-downs it sees.
    p <- jsonlite::fromJSON(app$get_js(sprintf("(function(){ var gd = %s;
      var it = Array.from(gd.querySelectorAll('.legend .traces')).find(function(e){
        return e.__data__ && String(e.__data__[0].trace.name) === %s; });
      var r = it.querySelector('.legendtoggle').getBoundingClientRect();
      return JSON.stringify({x: r.x + r.width / 2, y: r.y + r.height / 2}); })()",
        gd, jsonlite::toJSON(label, auto_unbox = TRUE))))
    cdp <- app$get_chromote_session()
    cdp$Input$dispatchMouseEvent(type = "mouseMoved", x = p$x, y = p$y)
    for (k in seq_len(if (double) 2L else 1L)) {
        cdp$Input$dispatchMouseEvent(type = "mousePressed", x = p$x, y = p$y, button = "left", clickCount = k)
        cdp$Input$dispatchMouseEvent(type = "mouseReleased", x = p$x, y = p$y, button = "left", clickCount = k)
    }
    Sys.sleep(1)
}

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
    zoomed <- restyled <- remapped <- NA
    if (!is.null(m$map)) {
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
    }

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

    # Recolour the legend's groups: the legend must follow, not keep the colours it
    # was first drawn with. (The picker sits in a hidden tab, so it never reports.)
    legend_ok <- NA
    if (isTRUE(m$palette)) {
        before_sw <- jsonlite::fromJSON(app$get_js(swatches))
        # Unnamed colours are taken in group order (see resolve_palette()).
        palette <- c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#A65628", "#F781BF", "#999999")
        app$run_js(sprintf(
            "Shiny.setInputValue('active_plot-palette.colours', %s, {priority: 'event'});",
            jsonlite::toJSON(rep_len(palette, max(nrow(before_sw), 2L)))
        ))
        settle(app)
        after_sw <- jsonlite::fromJSON(app$get_js(swatches))
        legend_ok <- sprintf("%s (legend entries=%d, legend colours changed=%s)",
            nrow(after_sw) > 0 && identical(after_sw$legend, after_sw$trace), nrow(after_sw),
            !identical(before_sw$legend, after_sw$legend))
    }

    # Drag out a selection: its annotations are added, and nothing stays dimmed.
    select_ok <- NA
    if (!is.null(m$annotate)) {
        set_input(app, "annotate.by", m$annotate)
        annotations <- sprintf("(%s.layout.annotations || []).length", gd)
        before_select <- app$get_js(annotations)
        renders <- counts(app)$values
        app$run_js(sprintf("Plotly.relayout(%s, {dragmode: 'select'});", gd))
        Sys.sleep(1)
        box <- jsonlite::fromJSON(app$get_js(sprintf("(function(){ var r = %s.querySelector('.nsewdrag').getBoundingClientRect();
            return JSON.stringify({x: r.left, y: r.top, w: r.width, h: r.height}); })()", gd)))
        cdp <- app$get_chromote_session()
        from <- c(box$x + box$w * 0.1, box$y + box$h * 0.1)
        to <- c(box$x + box$w * 0.9, box$y + box$h * 0.9)
        cdp$Input$dispatchMouseEvent(type = "mouseMoved", x = from[1], y = from[2])
        cdp$Input$dispatchMouseEvent(type = "mousePressed", x = from[1], y = from[2], button = "left", clickCount = 1)
        for (k in 1:8) {
            p <- from + (to - from) * k / 8
            cdp$Input$dispatchMouseEvent(type = "mouseMoved", x = p[1], y = p[2], button = "left")
            Sys.sleep(0.05)
        }
        cdp$Input$dispatchMouseEvent(type = "mouseReleased", x = to[1], y = to[2], button = "left", clickCount = 1)
        settle(app)
        Sys.sleep(1)
        dimmed <- app$get_js(sprintf("%s.data.filter(function(t){
            return t.selectedpoints !== undefined && t.selectedpoints !== null; }).length", gd))
        added <- app$get_js(annotations) - before_select
        select_ok <- sprintf("%s (annotations added=%d, traces still dimmed=%d, full renders=%d)",
            added > 0 && dimmed == 0, added, dimmed, counts(app)$values - renders)
    }

    # Map shape alongside colour, then click the legend's sections.
    sections_ok <- NA
    if (!is.null(m$shape)) {
        set_input(app, m$shape[[1]], m$shape[[2]])
        s0 <- jsonlite::fromJSON(app$get_js(sections))
        color1 <- s0$entries$color[1]
        shape1 <- s0$entries$shape[1]
        click_legend(app, color1)
        s1 <- jsonlite::fromJSON(app$get_js(sections))
        click_legend(app, shape1, double = TRUE)
        s2 <- jsonlite::fromJSON(app$get_js(sections))
        set_input(app, "title.font.size", 31)
        s3 <- jsonlite::fromJSON(app$get_js(sections))
        click_legend(app, shape1, double = TRUE)
        s4 <- jsonlite::fromJSON(app$get_js(sections))
        sections_ok <- sprintf(paste0(
            "%s (entries: %d colour, %d shape; click hid %s; double-click left %d of %d shapes; ",
            "kept after restyle %s; double-click again showed all %s; points out of step %d; handlers %d)"),
            identical(s1$color, color1) && length(s2$shape) == length(s0$entries$shape) - 1L &&
                identical(s3[c("color", "shape")], s2[c("color", "shape")]) && length(s4$shape) == 0L &&
                all(c(s1$wrong, s2$wrong, s3$wrong, s4$wrong) == 0L),
            length(s0$entries$color), length(s0$entries$shape), paste(s1$color, collapse = ","),
            length(s2$entries$shape) - length(s2$shape), length(s2$entries$shape),
            identical(s3[c("color", "shape")], s2[c("color", "shape")]), length(s4$shape) == 0L,
            sum(s1$wrong, s2$wrong, s3$wrong, s4$wrong), s4$handlers
        )
    }

    same_listeners <- identical(before[sort(names(before))], after[sort(names(after))])
    cat(sprintf(paste0(
        "CHECK %-8s 4 restyles: full renders=%d layout updates=%d title size=%s | react=%d newPlot=%d purge=%d |",
        " listeners stable=%s (%s) | zoom kept on restyle=%s, reset on mapping=%s | selection sent %s time(s) |",
        " shown again after an error=%s | legend follows a palette change=%s | legend sections=%s | selection=%s\n"),
        id, calls$values, calls$layouts, title_size, calls$react, calls$newPlot, calls$purge, same_listeners,
        paste(sprintf("%s:%s", names(after), unlist(after)), collapse = ","),
        isTRUE(all.equal(zoomed, restyled)), !isTRUE(all.equal(zoomed, remapped)), selected, recovered, legend_ok,
        sections_ok, select_ok
    ))
    app$stop()
}
