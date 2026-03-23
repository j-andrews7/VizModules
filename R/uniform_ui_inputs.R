#' Resolve a default value from a named list
#'
#' Looks up `key` in `defaults`. If present and passes `validator` (when
#' supplied), returns the stored value; otherwise returns `fallback`.
#' Uses standard `if`/`else` instead of vectorized `ifelse()` to avoid
#' silent truncation of multi-valued defaults.
#'
#' @param defaults A named list of default values, or NULL.
#' @param key Character string — the name to look up.
#' @param fallback The value to return when `key` is absent or fails validation.
#' @param validator An optional single-argument predicate function (e.g.,
#'   `is.numeric`, `is.logical`). When supplied, the stored value is returned
#'   only if `validator(value)` is `TRUE`.
#'
#' @return The resolved default value or `fallback`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_get_default
#' @keywords internal
.get_default <- function(defaults, key, fallback, validator = NULL) {
    if (!is.null(defaults) && key %in% names(defaults)) {
        value <- defaults[[key]]
        if (is.null(validator) || isTRUE(validator(value))) {
            return(value)
        }
    }
    fallback
}


#' Reset uniform axes inputs to defaults
#'
#' Resets all inputs created by [.uniform_axes_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating 20 `updateXxxInput` calls in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateSelectInput updateNumericInput updateCheckboxInput
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @rdname INTERNAL_reset_axes_inputs
#' @keywords internal
.reset_axes_inputs <- function(session) {
    # Optional conditional inputs (harmless if absent)
    shinyWidgets::updateMaterialSwitch(session, "rotate", value = FALSE)
    shinyWidgets::updateMaterialSwitch(session, "flip.x", value = FALSE)
    shinyWidgets::updateMaterialSwitch(session, "flip.y", value = FALSE)
    # Title font
    updateSelectInput(session, "title.font.family", selected = "Arial")
    colourpicker::updateColourInput(session, "text.colour", value = "#000000")
    # Axis title
    updateNumericInput(session, "axis.title.font.size", value = 18)
    colourpicker::updateColourInput(session, "axis.title.font.color", value = "#000000")
    updateSelectInput(session, "axis.title.font.family", selected = "Arial")
    # Borders & gridlines
    updateCheckboxInput(session, "axis.showline", value = TRUE)
    updateCheckboxInput(session, "axis.mirror", value = TRUE)
    updateCheckboxInput(session, "show.grid.x", value = TRUE)
    updateCheckboxInput(session, "show.grid.y", value = TRUE)
    colourpicker::updateColourInput(session, "axis.linecolor", value = "black")
    updateNumericInput(session, "axis.linewidth", value = 0.5)
    # Tick marks
    updateNumericInput(session, "axis.tickfont.size", value = 12)
    colourpicker::updateColourInput(session, "axis.tickfont.color", value = "black")
    updateSelectInput(session, "axis.tickfont.family", selected = "Arial")
    updateNumericInput(session, "axis.tickangle.x", value = 0)
    updateNumericInput(session, "axis.tickangle.y", value = 0)
    updateSelectInput(session, "axis.ticks", selected = "outside")
    colourpicker::updateColourInput(session, "axis.tickcolor", value = "black")
    updateNumericInput(session, "axis.ticklen", value = 5)
    updateNumericInput(session, "axis.tickwidth", value = 1)
    invisible(NULL)
}


#' Reset uniform lines inputs to defaults
#'
#' Resets all inputs created by [.uniform_lines_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating line-reset boilerplate in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#' @param include.fit.lines Logical; if TRUE, also resets the fit-line
#'   inputs (best.fit, line.best.smoothness, line.best.colour, linear.model).
#'   Default is FALSE.
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateTextInput updateNumericInput
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @rdname INTERNAL_reset_lines_inputs
#' @keywords internal
.reset_lines_inputs <- function(session, include.fit.lines = FALSE) {
    # Horizontal lines
    updateTextInput(session, "hline.intercepts", value = "")
    updateTextInput(session, "hline.colors", value = "#000000")
    updateTextInput(session, "hline.widths", value = "1")
    updateTextInput(session, "hline.linetypes", value = "dashed")
    updateTextInput(session, "hline.opacities", value = "1")
    # Vertical lines
    updateTextInput(session, "vline.intercepts", value = "")
    updateTextInput(session, "vline.colors", value = "#000000")
    updateTextInput(session, "vline.widths", value = "1")
    updateTextInput(session, "vline.linetypes", value = "dashed")
    updateTextInput(session, "vline.opacities", value = "1")
    # Diagonal lines
    updateTextInput(session, "abline.slopes", value = "")
    updateTextInput(session, "abline.intercepts", value = "")
    updateTextInput(session, "abline.colors", value = "#000000")
    updateTextInput(session, "abline.widths", value = "1")
    updateTextInput(session, "abline.linetypes", value = "dashed")
    updateTextInput(session, "abline.opacities", value = "1")

    if (include.fit.lines) {
        shinyWidgets::updateMaterialSwitch(session, "best.fit", value = FALSE)
        updateNumericInput(session, "line.best.smoothness", value = 1)
        colourpicker::updateColourInput(session, "line.best.colour", value = "#000000")
        shinyWidgets::updateMaterialSwitch(session, "linear.model", value = FALSE)
    }
    invisible(NULL)
}


#' Generate uniform Lines input UI
#'
#' Creates a standardized tagList of line-related inputs (horizontal, vertical,
#' and diagonal lines) for use across plot modules.
#'
#' @param ns A namespace function, typically created by `NS(id)`.
#' @param defaults A named list of default values for the inputs.
#' @param include.fit.lines Logical; whether to include "line of best fit" and
#'   "linear model line" inputs. Only applicable for scatter plots. Default is FALSE.
#'
#' @return A `tagList` containing the line input UI elements.
#'
#' @importFrom shiny textInput br tagList numericInput
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @importFrom shinyBS tipify
#'
#' @author Jared Andrews
#' @rdname INTERNAL_uniform_lines_inputs_ui
#' @keywords internal
.uniform_lines_inputs_ui <- function(ns, defaults = NULL, include.fit.lines = FALSE) {
    intercept_tip <- paste(
        "For categorical or factor axes, enter the index (position) of the",
        "category rather than its name. For example, if the axis categories",
        "are 'Audi', 'Mercedes', 'Bugatti', enter 2 to place a line at 'Mercedes'."
    )
    base_inputs <- tagList(
        tipify(
            textInput(ns("hline.intercepts"), "Y-intercepts",
                placeholder = "e.g. 2, -2",
                value = .get_default(defaults, "hline.intercepts", "")
            ),
            intercept_tip,
            placement = "top", options = list(container = "body")
        ),
        textInput(ns("hline.colors"), "Colors",
            value = .get_default(defaults, "hline.colors", "#000000")
        ),
        textInput(ns("hline.widths"), "Widths",
            value = .get_default(defaults, "hline.widths", "1")
        ),
        textInput(ns("hline.linetypes"), "Line types",
            placeholder = "solid, dashed, dotted, ...",
            value = .get_default(defaults, "hline.linetypes", "dashed")
        ),
        textInput(ns("hline.opacities"), "Opacities (0-1)",
            value = .get_default(defaults, "hline.opacities", "1")
        ),
        tipify(
            textInput(ns("vline.intercepts"), "X-intercepts",
                placeholder = "e.g. 2, -2",
                value = .get_default(defaults, "vline.intercepts", "")
            ),
            intercept_tip,
            placement = "top", options = list(container = "body")
        ),
        textInput(ns("vline.colors"), "Colors",
            value = .get_default(defaults, "vline.colors", "#000000")
        ),
        textInput(ns("vline.widths"), "Widths",
            value = .get_default(defaults, "vline.widths", "1")
        ),
        textInput(ns("vline.linetypes"), "Line types",
            placeholder = "solid, dashed, dotted, ...",
            value = .get_default(defaults, "vline.linetypes", "dashed")
        ),
        textInput(ns("vline.opacities"), "Opacities (0-1)",
            value = .get_default(defaults, "vline.opacities", "1")
        )
    )

    if (include.fit.lines) {
        fit_inputs <- tagList(
            textInput(ns("abline.slopes"), "Slopes",
                value = .get_default(defaults, "abline.slopes", "")
            ),
            materialSwitch(ns("best.fit"), "Line of best fit:",
                value = FALSE,
                status = "success"
            ),
            numericInput(ns("line.best.smoothness"), "Smoothness of line of best fit:",
                value = 1,
                min = 0,
                max = 10000
            ),
            colourpicker::colourInput(ns("line.best.colour"), "Line of best fit colour:",
                value = "#000000"
            ),
            materialSwitch(ns("linear.model"), "Linear model line",
                value = FALSE,
                status = "success"
            )
        )

        base_inputs <- tagList(base_inputs, fit_inputs)
    }

    base_inputs
}


#' Generate uniform Axes input UI
#'
#' Creates a standardized tagList of axis-related inputs for use across plot modules.
#'
#' @param ns A namespace function, typically created by `NS(id)`.
#' @param defaults A named list of default values for the inputs.
#' @param include.rotate Logical; whether to include the "Rotate" input for swapping
#'   x and y axes (e.g., horizontal bar plots). Default is FALSE.
#' @param include.flip Logical; whether to include the "Flip" input for flipping
#'   the axis. Default is FALSE.
#'
#' @return A `tagList` containing the axis input UI elements.
#'
#' @importFrom shiny numericInput checkboxInput selectInput tagList
#' @importFrom colourpicker colourInput
#'
#' @importFrom shinyWidgets materialSwitch
#'
#' @author Jared Andrews
#' @rdname INTERNAL_uniform_axes_inputs_ui
#' @keywords internal
.uniform_axes_inputs_ui <- function(ns, defaults = NULL, include.rotate = FALSE, include.flip = FALSE) {
    font_choices <- c(
        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
        "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
        "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
        "Verdana", "sans-serif", "serif", "monospace"
    )

    rotate_input <- if (include.rotate) {
        materialSwitch(ns("rotate"), "Rotate (swap X/Y)",
            value = .get_default(defaults, "rotate", FALSE, is.logical),
            status = "success"
        )
    } else {
        NULL
    }

    if (include.flip) {
        flip_x <- materialSwitch(ns("flip.x"), "Flip X Axis",
            value = .get_default(defaults, "flip.x", FALSE, is.logical),
            status = "success"
        )
        flip_y <- materialSwitch(ns("flip.y"), "Flip Y Axis",
            value = .get_default(defaults, "flip.y", FALSE, is.logical),
            status = "success"
        )
    } else {
        flip_x <- NULL
        flip_y <- NULL
    }

    tagList(
        rotate_input,
        flip_x,
        flip_y,
        selectInput(ns("title.font.family"), "Title Font",
            choices = font_choices,
            selected = .get_default(
                defaults, "title.font.family", "Arial",
                function(x) x %in% font_choices
            )
        ),
        colourInput(ns("text.colour"), "Title Color",
            value = .get_default(defaults, "text.colour", "#000000")
        ),
        numericInput(ns("axis.title.font.size"), "Axis Title Size",
            value = .get_default(defaults, "axis.title.font.size", 18, is.numeric),
            min = 1,
            step = 1
        ),
        colourInput(ns("axis.title.font.color"), "Axis Title Color",
            value = .get_default(defaults, "axis.title.font.color", "#000000")
        ),
        selectInput(ns("axis.title.font.family"), "Axis Title Font",
            choices = font_choices,
            selected = .get_default(
                defaults, "axis.title.font.family", "Arial",
                function(x) x %in% font_choices
            )
        ),
        checkboxInput(ns("axis.showline"), "Show Axis Borders",
            value = .get_default(defaults, "axis.showline", TRUE, is.logical)
        ),
        checkboxInput(ns("axis.mirror"), "Mirror Axis Borders",
            value = .get_default(defaults, "axis.mirror", TRUE, is.logical)
        ),
        checkboxInput(ns("show.grid.x"), "Show X Gridlines",
            value = .get_default(defaults, "show.grid.x", TRUE, is.logical)
        ),
        checkboxInput(ns("show.grid.y"), "Show Y Gridlines",
            value = .get_default(defaults, "show.grid.y", TRUE, is.logical)
        ),
        colourInput(ns("axis.linecolor"), "Axis Line Color",
            value = .get_default(defaults, "axis.linecolor", "black")
        ),
        numericInput(ns("axis.linewidth"), "Axis Line Width",
            value = .get_default(defaults, "axis.linewidth", 0.5, is.numeric),
            min = 0,
            step = 0.1
        ),
        numericInput(ns("axis.tickfont.size"), "Tick Label Size",
            value = .get_default(defaults, "axis.tickfont.size", 12, is.numeric),
            min = 1,
            step = 1
        ),
        colourInput(ns("axis.tickfont.color"), "Tick Label Color",
            value = .get_default(defaults, "axis.tickfont.color", "black")
        ),
        selectInput(ns("axis.tickfont.family"), "Tick Label Font",
            choices = font_choices,
            selected = .get_default(
                defaults, "axis.tickfont.family", "Arial",
                function(x) x %in% font_choices
            )
        ),
        numericInput(ns("axis.tickangle.x"), "X Tick Label Angle",
            value = .get_default(defaults, "axis.tickangle.x", 0, is.numeric),
            min = -180,
            max = 180,
            step = 15
        ),
        numericInput(ns("axis.tickangle.y"), "Y Tick Label Angle",
            value = .get_default(defaults, "axis.tickangle.y", 0, is.numeric),
            min = -180,
            max = 180,
            step = 15
        ),
        selectInput(ns("axis.ticks"), "Tick Position",
            choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
            selected = .get_default(
                defaults, "axis.ticks", "outside",
                function(x) x %in% c("outside", "inside", "")
            )
        ),
        colourInput(ns("axis.tickcolor"), "Tick Mark Color",
            value = .get_default(defaults, "axis.tickcolor", "black")
        ),
        numericInput(ns("axis.ticklen"), "Tick Mark Length",
            value = .get_default(defaults, "axis.ticklen", 5, is.numeric),
            min = 0,
            step = 1
        ),
        numericInput(ns("axis.tickwidth"), "Tick Mark Width",
            value = .get_default(defaults, "axis.tickwidth", 1, is.numeric),
            min = 0,
            step = 0.1
        )
    )
}


#' Generate uniform Stats input UI
#'
#' Creates a standardized tagList of statistical testing inputs for use across
#' plot modules that support pairwise comparisons (BoxPlot, ViolinPlot, yPlot).
#'
#' @param ns A namespace function, typically created by `NS(id)`.
#' @param defaults A named list of default values for the inputs.
#'
#' @return A `tagList` containing the stats input UI elements.
#'
#' @importFrom shiny selectInput numericInput tagList
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @importFrom shinyBS tipify
#'
#' @author Jared Andrews
#' @rdname INTERNAL_uniform_stats_inputs_ui
#' @keywords internal
.uniform_stats_inputs_ui <- function(ns, defaults = NULL) {
    tip_opts <- list(container = "body")
    tagList(
        tipify(
            materialSwitch(ns("stats.enabled"), "Enable Stats",
                value = .get_default(defaults, "stats.enabled", FALSE, is.logical),
                status = "success"
            ),
            "Toggle pairwise statistical testing with bracket annotations on the plot",
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("stat.test"), "Test",
                choices = c(
                    "Wilcoxon" = "wilcox.test",
                    "t-test" = "t.test",
                    "Kruskal-Wallis" = "kruskal.test",
                    "ANOVA" = "anova"
                ),
                selected = .get_default(defaults, "stat.test", "wilcox.test")
            ),
            paste(
                "Statistical test for comparisons.",
                "Wilcoxon and t-test perform pairwise comparisons.",
                "Kruskal-Wallis and ANOVA perform omnibus tests."
            ),
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("stat.p.adjust"), "P-value Adjustment",
                choices = c(
                    "holm", "hochberg", "hommel", "bonferroni",
                    "BH", "BY", "fdr", "none"
                ),
                selected = .get_default(defaults, "stat.p.adjust", "holm")
            ),
            "Method for multiple testing correction applied to all p-values",
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("stat.display"), "Display",
                choices = c(
                    "Adjusted P-value" = "p.adj",
                    "P-value" = "p.value",
                    "Symbols" = "symbol"
                ),
                selected = .get_default(defaults, "stat.display", "p.adj")
            ),
            "What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("stat.sig.threshold"), "Significance Threshold",
                value = .get_default(defaults, "stat.sig.threshold", 0.05, is.numeric),
                min = 0, max = 1, step = 0.01
            ),
            "(Adjusted, if applied) P-values above this threshold are labeled 'ns'. Also used as the boundary for the '*' significance symbol.",
            placement = "top", options = tip_opts
        ),
        tipify(
            materialSwitch(ns("stat.hide.ns"), "Hide Non-Significant",
                value = .get_default(defaults, "stat.hide.ns", FALSE, is.logical),
                status = "success"
            ),
            "Hide comparison brackets where the adjusted p-value exceeds the significance threshold",
            placement = "top", options = tip_opts
        ),
        tipify(
            materialSwitch(ns("stat.paired"), "Paired Test",
                value = .get_default(defaults, "stat.paired", FALSE, is.logical),
                status = "success"
            ),
            paste(
                "Perform paired tests (Wilcoxon signed-rank or paired t-test).",
                "Each group must have the same number of observations in corresponding order.",
                "Data should be sorted so that paired samples align row-by-row within each group."
            ),
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("stat.pairs"), "Comparisons",
                choices = c(), multiple = TRUE
            ),
            "Select specific pairwise comparisons to display. If empty, all possible pairs are tested.",
            placement = "top", options = tip_opts
        ),
        tipify(
            colourpicker::colourInput(ns("stat.line.color"), "Line Color",
                value = .get_default(defaults, "stat.line.color", "#000000")
            ),
            "Color for bracket lines and annotation text",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("stat.line.width"), "Line Width",
                value = .get_default(defaults, "stat.line.width", 1, is.numeric),
                min = 1, max = 50, step = 1
            ),
            "Width of bracket lines in pixels",
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("stat.bracket.style"), "Bracket Style",
                choices = c("Capped" = "capped", "Flat" = "flat"),
                selected = .get_default(defaults, "stat.bracket.style", "capped")
            ),
            "Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("stat.step.increase"), "Bracket Spacing",
                value = .get_default(defaults, "stat.step.increase", 0.06, is.numeric),
                min = 0.01, max = 0.3, step = 0.01
            ),
            "Fraction of the y-axis range used as vertical spacing between successive bracket levels",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("stat.text.bump"), "Text Offset",
                value = .get_default(defaults, "stat.text.bump", 0.04, is.numeric),
                min = 0.005, max = 0.2, step = 0.005
            ),
            "Fraction of the y-axis range for vertical distance between the bracket line and annotation text",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("stat.bracket.inset"), "Bracket Inset",
                value = .get_default(defaults, "stat.bracket.inset", 0.025, is.numeric),
                min = 0, max = 0.2, step = 0.005
            ),
            "Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets",
            placement = "top", options = tip_opts
        ),
        tipify(
            materialSwitch(ns("stat.per.facet"), "Per Facet Panel",
                value = .get_default(defaults, "stat.per.facet", TRUE, is.logical),
                status = "success"
            ),
            "When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.",
            placement = "top", options = tip_opts
        )
    )
}


#' Reset uniform stats inputs to defaults
#'
#' Resets all inputs created by [.uniform_stats_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block.
#'
#' @param session The Shiny session object (from `moduleServer`).
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
.reset_stats_inputs <- function(session) {
    shinyWidgets::updateMaterialSwitch(session, "stats.enabled", value = FALSE)
    updateSelectInput(session, "stat.test", selected = "wilcox.test")
    updateSelectInput(session, "stat.p.adjust", selected = "holm")
    updateSelectInput(session, "stat.display", selected = "p.adj")
    updateNumericInput(session, "stat.sig.threshold", value = 0.05)
    shinyWidgets::updateMaterialSwitch(session, "stat.hide.ns", value = FALSE)
    shinyWidgets::updateMaterialSwitch(session, "stat.paired", value = FALSE)
    updateSelectInput(session, "stat.pairs", selected = character(0))
    colourpicker::updateColourInput(session, "stat.line.color", value = "#000000")
    updateNumericInput(session, "stat.line.width", value = 1)
    updateSelectInput(session, "stat.bracket.style", selected = "capped")
    updateNumericInput(session, "stat.step.increase", value = 0.06)
    updateNumericInput(session, "stat.text.bump", value = 0.04)
    updateNumericInput(session, "stat.bracket.inset", value = 0.025)
    shinyWidgets::updateMaterialSwitch(session, "stat.per.facet", value = TRUE)
    invisible(NULL)
}


#' Generate uniform Plotly input UI
#'
#' Creates a standardized tagList of Plotly-specific inputs used across all plot
#' modules. Includes interactive download controls, plot margin adjustments,
#' subplot spacing, and user-drawn shape styling for Plotly's drawing tools.
#'
#' @param ns A namespace function, typically created by `NS(id)`.
#' @param defaults A named list of default values for the inputs.
#'
#' @return A `tagList` containing the Plotly input UI elements.
#'
#' @importFrom shiny downloadButton selectInput numericInput tagList br icon
#' @importFrom colourpicker colourInput
#' @importFrom shinyBS tipify
#'
#' @author Jared Andrews
#' @rdname INTERNAL_uniform_plotly_inputs_ui
#' @keywords internal
.uniform_plotly_inputs_ui <- function(ns, defaults = NULL) {
    tip_opts <- list(container = "body")
    tagList(
        downloadButton(
            ns("download.interactive"),
            "Save Interactive",
            class = "btn-secondary",
            icon = icon("download"),
            width = "100%"
        ),
        selectInput(
            ns("download.format"),
            "Download Format",
            selected = .get_default(defaults, "download.format", "svg",
                function(x) x %in% c("svg", "png", "jpeg", "webp")),
            choices = c("svg", "png", "jpeg", "webp"),
            width = "100%"
        ),
        tipify(
            numericInput(ns("margin.t"), "Margin Top",
                value = .get_default(defaults, "margin.t", 100, is.numeric),
                min = 0, step = 5
            ),
            "Top margin of the plot in pixels",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("margin.b"), "Margin Bottom",
                value = .get_default(defaults, "margin.b", 100, is.numeric),
                min = 0, step = 5
            ),
            "Bottom margin of the plot in pixels",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("margin.l"), "Margin Left",
                value = .get_default(defaults, "margin.l", 90, is.numeric),
                min = 0, step = 5
            ),
            "Left margin of the plot in pixels",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("margin.r"), "Margin Right",
                value = .get_default(defaults, "margin.r", 90, is.numeric),
                min = 0, step = 5
            ),
            "Right margin of the plot in pixels",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("subplot.margin"), "Subplot Spacing",
                value = .get_default(defaults, "subplot.margin", 0.05, is.numeric),
                min = 0, max = 0.5, step = 0.01
            ),
            paste(
                "Spacing between facet panels as a fraction of the plot area.",
                "Only applies when faceting is active."
            ),
            placement = "top", options = tip_opts
        ),
        tipify(
            colourInput(ns("shape.fill"), "Shape Fill",
                allowTransparent = TRUE,
                value = .get_default(defaults, "shape.fill", "rgba(0, 0, 0, 0)")
            ),
            "Interior fill color for shapes drawn on the plot using Plotly's drawing tools",
            placement = "top", options = tip_opts
        ),
        tipify(
            colourInput(ns("shape.line.color"), "Shape Line Color",
                allowTransparent = TRUE,
                value = .get_default(defaults, "shape.line.color", "black")
            ),
            "Outline color for shapes drawn on the plot using Plotly's drawing tools",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("shape.line.width"), "Shape Line Width",
                value = .get_default(defaults, "shape.line.width", 4, is.numeric),
                min = 0, step = 0.25
            ),
            "Outline width for shapes drawn on the plot using Plotly's drawing tools",
            placement = "top", options = tip_opts
        ),
        tipify(
            selectInput(ns("shape.linetype"), "Shape Linetype",
                choices = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot"),
                selected = .get_default(defaults, "shape.linetype", "solid",
                    function(x) x %in% c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot"))
            ),
            "Line dash style for shapes drawn on the plot using Plotly's drawing tools",
            placement = "top", options = tip_opts
        ),
        tipify(
            numericInput(ns("shape.opacity"), "Shape Opacity",
                value = .get_default(defaults, "shape.opacity", 1, is.numeric),
                min = 0, max = 1, step = 0.01
            ),
            "Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque",
            placement = "top", options = tip_opts
        )
    )
}


#' Reset uniform Plotly inputs to defaults
#'
#' Resets all inputs created by [.uniform_plotly_inputs_ui()] to their default
#' values. Call inside an `observeEvent(input$reset, ...)` block to avoid
#' duplicating Plotly-reset boilerplate in every module server.
#'
#' @param session The Shiny session object (from `moduleServer`).
#'
#' @return Called for side effects; returns `invisible(NULL)`.
#'
#' @importFrom shiny updateNumericInput updateSelectInput
#' @importFrom colourpicker updateColourInput
#'
#' @author Jared Andrews
#' @rdname INTERNAL_reset_plotly_inputs
#' @keywords internal
.reset_plotly_inputs <- function(session) {
    updateSelectInput(session, "download.format", selected = "svg")
    updateNumericInput(session, "margin.t", value = 100)
    updateNumericInput(session, "margin.b", value = 100)
    updateNumericInput(session, "margin.l", value = 90)
    updateNumericInput(session, "margin.r", value = 90)
    updateNumericInput(session, "subplot.margin", value = 0.05)
    colourpicker::updateColourInput(session, "shape.fill", value = "rgba(0, 0, 0, 0)")
    colourpicker::updateColourInput(session, "shape.line.color", value = "black")
    updateNumericInput(session, "shape.line.width", value = 4)
    updateSelectInput(session, "shape.linetype", selected = "solid")
    updateNumericInput(session, "shape.opacity", value = 1)
    invisible(NULL)
}
