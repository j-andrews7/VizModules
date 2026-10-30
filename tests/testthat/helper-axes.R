# The x categories each panel of a built figure draws, in order.
.panel_x_orders <- function(fig) {
    lay <- suppressWarnings(plotly::plotly_build(fig))$x$layout
    axes <- grep("^xaxis[0-9]*$", names(lay), value = TRUE)
    axes <- axes[order(as.integer(sub("^xaxis", "0", axes)))]
    Filter(length, lapply(axes, function(a) unlist(lay[[a]]$ticktext)))
}

# The x positions each horizontal significance bracket spans, as integer pairs.
.bracket_spans <- function(fig) {
    shapes <- plotly::plotly_build(fig)$x$layout$shapes
    lines <- Filter(function(s) {
        identical(s$type, "line") && .data_ref(s$yref) && isTRUE(all.equal(s$y0, s$y1)) && s$x0 != s$x1
    }, shapes)
    lapply(lines, function(s) round(sort(c(s$x0, s$x1))))
}
