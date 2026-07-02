#' Reset uniform axes inputs to defaults
#'
#' Resets all inputs created by [uniform_axes_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating 20 `updateXxxInput` calls in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#' @param defaults A named list of default values to reset to, or NULL to use
#'   hardcoded fallbacks. Typically the same list passed to the UI function.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateSelectInput updateNumericInput updateCheckboxInput
#' @importFrom colourpicker updateColourInput
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call inside a module server's observeEvent(input$reset, ...) block:
#' reset_axes_inputs(session, defaults)
#' }
reset_axes_inputs <- function(session, defaults = NULL) {
    # Optional conditional inputs (harmless if absent)
    updateMaterialSwitch(session, "rotate", value = get_default(defaults, "rotate", FALSE, is.logical))
    updateMaterialSwitch(session, "flip.x", value = get_default(defaults, "flip.x", FALSE, is.logical))
    updateMaterialSwitch(session, "flip.y", value = get_default(defaults, "flip.y", FALSE, is.logical))
    updateNumericInput(session, "facet.title.font.size", value = get_default(defaults, "facet.title.font.size", 18, is.numeric))
    updateColourInput(session, "facet.title.font.color", value = get_default(defaults, "facet.title.font.color", "#000000"))
    updateSelectInput(session, "facet.title.font.family", selected = get_default(defaults, "facet.title.font.family", "Arial"))
    updateSelectInput(session, "title.font.family", selected = get_default(defaults, "title.font.family", "Arial"))
    updateColourInput(session, "title.font.color", value = get_default(defaults, "title.font.color", "#000000"))
    updateNumericInput(session, "title.font.size", value = get_default(defaults, "title.font.size", 26, is.numeric))
    updateNumericInput(session, "axis.title.horizontal.position", value = get_default(defaults, "axis.title.horizontal.position", 0.5, is.numeric))
    updateColourInput(session, "axis.title.font.color", value = get_default(defaults, "axis.title.font.color", "#000000"))
    updateSelectInput(session, "axis.title.font.family", selected = get_default(defaults, "axis.title.font.family", "Arial"))
    updateCheckboxInput(session, "axis.showline", value = get_default(defaults, "axis.showline", TRUE, is.logical))
    updateCheckboxInput(session, "axis.mirror", value = get_default(defaults, "axis.mirror", TRUE, is.logical))
    updateCheckboxInput(session, "show.grid.x", value = get_default(defaults, "show.grid.x", TRUE, is.logical))
    updateCheckboxInput(session, "show.grid.y", value = get_default(defaults, "show.grid.y", TRUE, is.logical))
    updateColourInput(session, "grid.color", value = get_default(defaults, "grid.color", "#CCCCCC"))
    updateColourInput(session, "axis.linecolor", value = get_default(defaults, "axis.linecolor", "black"))
    updateNumericInput(session, "axis.linewidth", value = get_default(defaults, "axis.linewidth", 0.5, is.numeric))
    updateNumericInput(session, "axis.tickfont.size", value = get_default(defaults, "axis.tickfont.size", 12, is.numeric))
    updateColourInput(session, "axis.tickfont.color", value = get_default(defaults, "axis.tickfont.color", "black"))
    updateSelectInput(session, "axis.tickfont.family", selected = get_default(defaults, "axis.tickfont.family", "Arial"))
    updateNumericInput(session, "axis.tickangle.x", value = get_default(defaults, "axis.tickangle.x", 0, is.numeric))
    updateNumericInput(session, "axis.tickangle.y", value = get_default(defaults, "axis.tickangle.y", 0, is.numeric))
    updateSelectInput(session, "axis.ticks", selected = get_default(defaults, "axis.ticks", "outside"))
    updateColourInput(session, "axis.tickcolor", value = get_default(defaults, "axis.tickcolor", "black"))
    updateNumericInput(session, "axis.ticklen", value = get_default(defaults, "axis.ticklen", 5, is.numeric))
    updateNumericInput(session, "axis.tickwidth", value = get_default(defaults, "axis.tickwidth", 1, is.numeric))
    invisible(NULL)
}


#' Reset uniform lines inputs to defaults
#'
#' Resets all inputs created by [uniform_lines_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating line-reset boilerplate in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#' @param include.fit.lines Logical; if TRUE, also resets the fit-line
#'   inputs (best.fit, line.best.smoothness, line.best.colour, linear.model).
#'   Default is FALSE.
#' @param defaults A named list of default values to reset to, or NULL to use
#'   hardcoded fallbacks. Typically the same list passed to the UI function.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateTextInput updateNumericInput
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call inside a module server's observeEvent(input$reset, ...) block:
#' reset_lines_inputs(session, defaults = defaults)
#' }
reset_lines_inputs <- function(session, include.fit.lines = FALSE, defaults = NULL) {
    updateTextInput(session, "hline.intercepts", value = get_default(defaults, "hline.intercepts", ""))
    updateTextInput(session, "hline.colors", value = get_default(defaults, "hline.colors", "#000000"))
    updateTextInput(session, "hline.widths", value = get_default(defaults, "hline.widths", "1"))
    updateTextInput(session, "hline.linetypes", value = get_default(defaults, "hline.linetypes", "dashed"))
    updateTextInput(session, "hline.opacities", value = get_default(defaults, "hline.opacities", "1"))
    updateTextInput(session, "vline.intercepts", value = get_default(defaults, "vline.intercepts", ""))
    updateTextInput(session, "vline.colors", value = get_default(defaults, "vline.colors", "#000000"))
    updateTextInput(session, "vline.widths", value = get_default(defaults, "vline.widths", "1"))
    updateTextInput(session, "vline.linetypes", value = get_default(defaults, "vline.linetypes", "dashed"))
    updateTextInput(session, "vline.opacities", value = get_default(defaults, "vline.opacities", "1"))
    updateTextInput(session, "abline.slopes", value = get_default(defaults, "abline.slopes", ""))
    updateTextInput(session, "abline.intercepts", value = get_default(defaults, "abline.intercepts", ""))
    updateTextInput(session, "abline.colors", value = get_default(defaults, "abline.colors", "#000000"))
    updateTextInput(session, "abline.widths", value = get_default(defaults, "abline.widths", "1"))
    updateTextInput(session, "abline.linetypes", value = get_default(defaults, "abline.linetypes", "dashed"))
    updateTextInput(session, "abline.opacities", value = get_default(defaults, "abline.opacities", "1"))

    if (include.fit.lines) {
        updateMaterialSwitch(session, "best.fit", value = get_default(defaults, "best.fit", FALSE, is.logical))
        updateNumericInput(session, "line.best.smoothness", value = get_default(defaults, "line.best.smoothness", 1, is.numeric))
        updateColourInput(session, "line.best.colour", value = get_default(defaults, "line.best.colour", "#000000"))
        updateMaterialSwitch(session, "linear.model", value = get_default(defaults, "linear.model", FALSE, is.logical))
    }
    invisible(NULL)
}


#' Reset uniform stats inputs to defaults
#'
#' Resets all inputs created by [.uniform_stats_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block.
#'
#' @param session The Shiny session object (from `moduleServer`).
#' @param defaults A named list of default values to reset to, or NULL to use
#'   hardcoded fallbacks. Typically the same list passed to the UI function.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateSelectInput updateNumericInput
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @rdname INTERNAL_reset_stats_inputs
#' @keywords internal
.reset_stats_inputs <- function(session, defaults = NULL) {
    updateMaterialSwitch(session, "stats.enabled", value = get_default(defaults, "stats.enabled", FALSE, is.logical))
    updateSelectInput(session, "stat.test", selected = get_default(defaults, "stat.test", "wilcox.test"))
    updateSelectInput(session, "stat.p.adjust", selected = get_default(defaults, "stat.p.adjust", "holm"))
    updateSelectInput(session, "stat.display", selected = get_default(defaults, "stat.display", "p.adj"))
    updateNumericInput(session, "stat.sig.threshold", value = get_default(defaults, "stat.sig.threshold", 0.05, is.numeric))
    updateMaterialSwitch(session, "stat.hide.ns", value = get_default(defaults, "stat.hide.ns", FALSE, is.logical))
    updateMaterialSwitch(session, "stat.paired", value = get_default(defaults, "stat.paired", FALSE, is.logical))
    updateSelectInput(session, "stat.pairs", selected = character(0))
    updateColourInput(session, "stat.line.color", value = get_default(defaults, "stat.line.color", "#000000"))
    updateNumericInput(session, "stat.line.width", value = get_default(defaults, "stat.line.width", 1, is.numeric))
    updateSelectInput(session, "stat.bracket.style", selected = get_default(defaults, "stat.bracket.style", "capped"))
    updateNumericInput(session, "stat.step.increase", value = get_default(defaults, "stat.step.increase", 0.06, is.numeric))
    updateNumericInput(session, "stat.text.bump", value = get_default(defaults, "stat.text.bump", 0.04, is.numeric))
    updateNumericInput(session, "stat.bracket.inset", value = get_default(defaults, "stat.bracket.inset", 0.025, is.numeric))
    updateMaterialSwitch(session, "stat.per.facet", value = get_default(defaults, "stat.per.facet", TRUE, is.logical))
    invisible(NULL)
}


#' Reset uniform Plotly inputs to defaults
#'
#' Resets all inputs created by [uniform_plotly_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating Plotly-reset boilerplate in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#' @param defaults A named list of default values to reset to, or NULL to use
#'   hardcoded fallbacks. Typically the same list passed to the UI function.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateNumericInput updateSelectInput
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call inside a module server's observeEvent(input$reset, ...) block:
#' reset_plotly_inputs(session, defaults)
#' }
reset_plotly_inputs <- function(session, defaults = NULL) {
    updateSelectInput(session, "download.format", selected = get_default(defaults, "download.format", "svg"))
    updateNumericInput(session, "margin.t", value = get_default(defaults, "margin.t", 100, is.numeric))
    updateNumericInput(session, "margin.b", value = get_default(defaults, "margin.b", 70, is.numeric))
    updateNumericInput(session, "margin.l", value = get_default(defaults, "margin.l", 70, is.numeric))
    updateNumericInput(session, "margin.r", value = get_default(defaults, "margin.r", 70, is.numeric))
    subplot_margin_default <- get_default(defaults, "subplot.margin", 0.1, is.numeric)
    updateNumericInput(session, "subplot.margin.x",
        value = get_default(defaults, "subplot.margin.x", subplot_margin_default, is.numeric))
    updateNumericInput(session, "subplot.margin.y",
        value = get_default(defaults, "subplot.margin.y", subplot_margin_default, is.numeric))
    updateColourInput(session, "shape.fill", value = get_default(defaults, "shape.fill", "rgba(0, 0, 0, 0)"))
    updateColourInput(session, "shape.line.color", value = get_default(defaults, "shape.line.color", "black"))
    updateNumericInput(session, "shape.line.width", value = get_default(defaults, "shape.line.width", 4, is.numeric))
    updateSelectInput(session, "shape.linetype", selected = get_default(defaults, "shape.linetype", "solid"))
    updateNumericInput(session, "shape.opacity", value = get_default(defaults, "shape.opacity", 1, is.numeric))
    invisible(NULL)
}


#' Reset uniform Legend inputs to defaults
#'
#' Resets the legend styling inputs (legend title and entry label font sizes)
#' created by [.uniform_legend_inputs_ui()] back to their default values.
#'
#' @param session The Shiny session object.
#' @param defaults A named list of default values. When provided, inputs reset
#'   to these values rather than hardcoded fallbacks. Typically the same list
#'   passed to the UI function.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateNumericInput
#'
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call inside a module server's observeEvent(input$reset, ...) block:
#' reset_legend_inputs(session, defaults)
#' }
reset_legend_inputs <- function(session, defaults = NULL) {
    updateNumericInput(session, "legend.title.size",
        value = get_default(defaults, "legend.title.size", 14, is.numeric))
    updateNumericInput(session, "legend.text.size",
        value = get_default(defaults, "legend.text.size", 12, is.numeric))
    invisible(NULL)
}
