# Complete input sets for driving each module's server with testServer(), shared
# by the per-module tests and test-two-tier.R. Override any input through `...`.

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.box_inputs <- function(...) {
    base <- list(
        x.data = "department", y.data = "salary", group.by = "", show.outliers = TRUE,
        boxplot.width = 0.8, sort_x = "", rotate = FALSE, y.min = 0, y.max = NA,
        auto.update = TRUE, update = 0,
        add.points = FALSE, pt.size = 1, pt.alpha = 1, jitter.width = 0.3, pt.color = "#000000",
        highlight = "", highlight.colour = "#000000", highlight.size = 1, highlight.alpha = 1,
        facet.by = "", facet.scale = "fixed", facet.ncol = NA, facet.nrow = NA, facet.by.row = TRUE,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        stats.enabled = FALSE, stat.test = "wilcox.test", stat.p.adjust = "holm",
        stat.display = "p.adj", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "capped", stat.bracket.inset = 0.025,
        stat.step.increase = 0.06, stat.text.bump = 0.04,
        stat.line.color = "#000000", stat.line.width = 1,
        download.format = "svg", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 18,
        facet.title.font.color = "#000000", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 70, margin.r = 90, margin.t = 70, margin.b = 70
    )
    utils::modifyList(base, list(...))
}

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.dot_inputs <- function(...) {
    base <- list(
        x.data = "gene", y.data = "cell_type", rotate = FALSE,
        size.by = "pct_expressed", fill.by = "avg_expression",
        fill.cutoff = NA, fill.cutoff.direction = "<",
        size.min = 1, size.max = 6, size.scale.min = NA, size.scale.max = NA,
        facet.by = "", facet.scale = "fixed", facet.ncol = NA, facet.nrow = NA, facet.by.row = TRUE,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        palette.name = "Spectral", palreverse = FALSE, alpha = 1,
        border.color = "black", border.size = 0.5,
        lower.quantile = 0, upper.quantile = 1, lower.cutoff = NA, upper.cutoff = NA,
        auto.update = TRUE, update = 0,
        size.legend.x = 1.04, size.legend.y = 0.35,
        legend.show = TRUE, legend.font.family = "Arial", legend.font.color = "#000000",
        legend.title.size = 14, legend.text.size = 12,
        download.format = "svg",
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 18,
        facet.title.font.color = "#000000", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 70, margin.r = 140, margin.t = 70, margin.b = 70
    )
    utils::modifyList(base, list(...))
}

# The plot output cannot be driven from testServer (the mock session never
# renders the renderUI()-built colour picker and never registers plotly events),
# but the reactive that builds the figure can, given a complete set of inputs.
.freq_inputs <- function(...) {
    base <- list(
        var = "cell_type", sample.by = "sample", group.by = "condition", color.by = "",
        vars.use = "", scale = "percent", max.normalize = FALSE,
        plots = c("boxplot", "jitter"),
        y.min = 0, y.max = NA, auto.update = TRUE,
        split.adjust = "fixed", split.ncol = NA, split.nrow = NA,
        subplot.margin.x = 30, subplot.margin.y = 30,
        jitter.size = 1, jitter.width = 0.2, jitter.color = "#000000",
        hover.round.digits = 5, do.raster = FALSE, raster.dpi = 600,
        boxplot.show.outliers = FALSE, boxplot.color = "#000000", boxplot.fill = TRUE,
        boxplot.lineweight = 0.5, boxgap = 0.3, boxgroupgap = 0.2,
        vlnplot.lineweight = 0.5, vlnplot.scaling = "area",
        ridgeplot.lineweight = 0.5, ridgeplot.scale = 1.25,
        ridgeplot.ymax.expansion = NA, ridgeplot.shape = "smooth",
        ridgeplot.bins = 30, ridgeplot.binwidth = NA,
        stats.enabled = FALSE, stat.test = "t.test", stat.p.adjust = "none",
        stat.display = "stars", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "bracket", stat.bracket.inset = 0.1,
        stat.step.increase = 0.1, stat.text.bump = 0.02,
        stat.line.color = "black", stat.line.width = 1,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2,
        annotation.arrowwidth = 1.5,
        download.format = "png", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "",
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

# The inputs generate_linePlot() reads; testServer cannot drive the plot output, but the reactive
# that builds the figure can.
.line_inputs <- function(...) {
    utils::modifyList(list(
        x.value = "region", y.value = "revenue", group.by = "", order.by = FALSE,
        error.bar = TRUE, error.bar.colour = "#000000", error.bar.width = 1,
        auto.update = TRUE, update = 0, plot.mode = "lines", line.type = "solid",
        facet.by = "", facet.scales = "fixed", flip.x = FALSE, flip.y = FALSE, legend.show = TRUE
    ), list(...))
}

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.scatter_inputs <- function(...) {
    base <- list(
        x.by = "units", y.by = "revenue", color.by = "", shape.by = "", size.by = "", split.by = "",
        x.adjustment = "", y.adjustment = "", color.adjustment = "",
        x.adj.fxn = "", y.adj.fxn = "", color.adj.fxn = "",
        size = 1, size.min = 1, size.max = 6, size.scale.min = NA, size.scale.max = NA,
        opacity = 1, show.others = FALSE, split.show.all.others = FALSE,
        plot.order = "unordered", shape.panel = "16, 15, 17, 23, 25, 8",
        min.color = "#F0E442", max.color = "#0072B2", min.value = NA, max.value = NA,
        do.contour = FALSE, contour.color = "black", contour.linetype = "solid", do.ellipse = FALSE,
        trajectory.group.by = "", add.trajectory.by.groups = list(), trajectory.arrow.size = 0.1,
        split.nrow = NA, split.ncol = NA, split.adjust.scales = "fixed", multivar.split.dir = "col",
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        legend.show = TRUE, legend.color.title = "make", legend.color.breaks = "",
        legend.title.size = 14, legend.text.size = 12, size.legend.x = 1.03, size.legend.y = 0.35,
        hover.data = "", hover.round.digits = 5, webgl = FALSE, single.point.color = "#000000",
        linear.model = FALSE, best.fit = FALSE, line.best.smoothness = 1, line.best.colour = "#000000",
        custom.model.enable = FALSE, custom.models = NULL,
        marginal.x = character(0), marginal.y = character(0), marginal.x.size = 0.15, marginal.y.size = 0.15,
        marginal.opacity = 0.5, marginal.bins = 30, marginal.binwidth = NA, marginal.density.adjust = 1,
        marginal.rug.height = 0.3, marginal.rug.width = 1,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2, annotation.arrowwidth = 1.5,
        download.format = "png", auto.update = TRUE, update = 0,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.yplot_inputs <- function(...) {
    base <- list(
        var = "salary", group.by = "job_level", color.by = "", shape.by = "", split.by = "",
        plots = c("boxplot", "jitter"), var.adjustment = "", var.adj.fxn = "",
        y.min = NA, y.max = NA, auto.update = TRUE, update = 0,
        multivar.aes = "split", multivar.split.dir = "col",
        split.adjust = "fixed", split.ncol = NA, split.nrow = NA,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        do.raster = FALSE, raster.dpi = 600,
        jitter.size = 1, jitter.width = 0.2, jitter.color = "#000000",
        jitter.shape.legend.size = 5, jitter.shape.legend.show = TRUE,
        boxplot.show.outliers = FALSE, boxplot.color = "#000000", boxplot.fill = TRUE,
        boxplot.lineweight = 0.5, boxgap = 0.3, boxgroupgap = 0.2,
        vlnplot.lineweight = 0.5, vlnplot.scaling = "area",
        ridgeplot.lineweight = 0.5, ridgeplot.scale = 1.25, ridgeplot.ymax.expansion = NA,
        ridgeplot.shape = "smooth", ridgeplot.bins = 30, ridgeplot.binwidth = NA,
        hover.data = "", hover.round.digits = 5,
        stats.enabled = FALSE, stat.test = "t.test", stat.p.adjust = "none",
        stat.display = "p.adj", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "capped", stat.bracket.inset = 0.025,
        stat.step.increase = 0.06, stat.text.bump = 0.04,
        stat.line.color = "#000000", stat.line.width = 1,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2, annotation.arrowwidth = 1.5,
        download.format = "png", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

