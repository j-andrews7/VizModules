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
                value = ifelse("hline.intercepts" %in% names(defaults), defaults[["hline.intercepts"]], "")
            ),
            intercept_tip, placement = "top", options = list(container = "body")
        ),
        textInput(ns("hline.colors"), "Colors",
            value = ifelse("hline.colors" %in% names(defaults), defaults[["hline.colors"]], "#000000")
        ),
        textInput(ns("hline.widths"), "Widths",
            value = ifelse("hline.widths" %in% names(defaults), defaults[["hline.widths"]], "1")
        ),
        textInput(ns("hline.linetypes"), "Line types",
            placeholder = "solid, dashed, dotted, ...",
            value = ifelse("hline.linetypes" %in% names(defaults), defaults[["hline.linetypes"]], "dashed")
        ),
        textInput(ns("hline.opacities"), "Opacities (0-1)",
            value = ifelse("hline.opacities" %in% names(defaults), defaults[["hline.opacities"]], "1")
        ),
        br(),
        tipify(
            textInput(ns("vline.intercepts"), "X-intercepts",
                placeholder = "e.g. 2, -2",
                value = ifelse("vline.intercepts" %in% names(defaults), defaults[["vline.intercepts"]], "")
            ),
            intercept_tip, placement = "top", options = list(container = "body")
        ),
        textInput(ns("vline.colors"), "Colors",
            value = ifelse("vline.colors" %in% names(defaults), defaults[["vline.colors"]], "#000000")
        ),
        textInput(ns("vline.widths"), "Widths",
            value = ifelse("vline.widths" %in% names(defaults), defaults[["vline.widths"]], "1")
        ),
        textInput(ns("vline.linetypes"), "Line types",
            placeholder = "solid, dashed, dotted, ...",
            value = ifelse("vline.linetypes" %in% names(defaults), defaults[["vline.linetypes"]], "dashed")
        ),
        textInput(ns("vline.opacities"), "Opacities (0-1)",
            value = ifelse("vline.opacities" %in% names(defaults), defaults[["vline.opacities"]], "1")
        ),
        br()
    )

    if (include.fit.lines) {
        fit_inputs <- tagList(
            textInput(ns("abline.slopes"), "Slopes",
                value = ifelse("abline.slopes" %in% names(defaults), defaults[["abline.slopes"]], "")
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
            value = ifelse("rotate" %in% names(defaults),
                ifelse(is.logical(defaults[["rotate"]]), defaults[["rotate"]], FALSE),
                FALSE
            ),
            status = "success"
        )
    } else {
        NULL
    }

    if (include.flip){
        flip_x <- materialSwitch(ns("flip.x"), "Flip X Axis",
            value = ifelse("flip.x" %in% names(defaults),
                ifelse(is.logical(defaults[["flip.x"]]), defaults[["flip.x"]], FALSE),
                FALSE
            ),
            status = "success"
        )
        flip_y <- materialSwitch(ns("flip.y"), "Flip Y Axis",
            value = ifelse("flip.y" %in% names(defaults),
                ifelse(is.logical(defaults[["flip.y"]]), defaults[["flip.y"]], FALSE),
                FALSE
            ),
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
        selectInput(ns("font.type"), "Title Font",
            choices = font_choices,
            selected = ifelse("font.type" %in% names(defaults),
                ifelse(defaults[["font.type"]] %in% font_choices,
                    defaults[["font.type"]], "Arial"
                ),
                "Arial"
            )
        ),
        colourInput(ns("text.colour"), "Title Color",
            value = ifelse("text.colour" %in% names(defaults),
                defaults[["text.colour"]], "#000000"
            )
        ),
        numericInput(ns("axis.title.font.size"), "Axis Title Size",
            value = ifelse("axis.title.font.size" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.title.font.size"]]), defaults[["axis.title.font.size"]], 18),
                18
            ),
            min = 1,
            step = 1
        ),
        colourInput(ns("axis.title.font.color"), "Axis Title Color",
            value = ifelse("axis.title.font.color" %in% names(defaults),
                defaults[["axis.title.font.color"]], "#000000"
            )
        ),
        selectInput(ns("axis.title.font.family"), "Axis Title Font",
            choices = font_choices,
            selected = ifelse("axis.title.font.family" %in% names(defaults),
                ifelse(defaults[["axis.title.font.family"]] %in% font_choices,
                    defaults[["axis.title.font.family"]], "Arial"
                ),
                "Arial"
            )
        ),
        checkboxInput(ns("axis.showline"), "Show Axis Borders",
            value = ifelse("axis.showline" %in% names(defaults),
                ifelse(is.logical(defaults[["axis.showline"]]), defaults[["axis.showline"]], TRUE),
                TRUE
            )
        ),
        checkboxInput(ns("axis.mirror"), "Mirror Axis Borders",
            value = ifelse("axis.mirror" %in% names(defaults),
                ifelse(is.logical(defaults[["axis.mirror"]]), defaults[["axis.mirror"]], TRUE),
                TRUE
            )
        ),
        checkboxInput(ns("show.grid.x"), "Show X Gridlines",
            value = ifelse("show.grid.x" %in% names(defaults),
                ifelse(is.logical(defaults[["show.grid.x"]]), defaults[["show.grid.x"]], TRUE),
                TRUE
            )
        ),
        checkboxInput(ns("show.grid.y"), "Show Y Gridlines",
            value = ifelse("show.grid.y" %in% names(defaults),
                ifelse(is.logical(defaults[["show.grid.y"]]), defaults[["show.grid.y"]], TRUE),
                TRUE
            )
        ),
        colourInput(ns("axis.linecolor"), "Axis Line Color",
            value = ifelse("axis.linecolor" %in% names(defaults),
                defaults[["axis.linecolor"]], "black"
            )
        ),
        numericInput(ns("axis.linewidth"), "Axis Line Width",
            value = ifelse("axis.linewidth" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.linewidth"]]), defaults[["axis.linewidth"]], 0.5),
                0.5
            ),
            min = 0,
            step = 0.1
        ),
        numericInput(ns("axis.tickfont.size"), "Tick Label Size",
            value = ifelse("axis.tickfont.size" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.tickfont.size"]]), defaults[["axis.tickfont.size"]], 12),
                12
            ),
            min = 1,
            step = 1
        ),
        colourInput(ns("axis.tickfont.color"), "Tick Label Color",
            value = ifelse("axis.tickfont.color" %in% names(defaults),
                defaults[["axis.tickfont.color"]], "black"
            )
        ),
        selectInput(ns("axis.tickfont.family"), "Tick Label Font",
            choices = font_choices,
            selected = ifelse("axis.tickfont.family" %in% names(defaults),
                ifelse(defaults[["axis.tickfont.family"]] %in% font_choices,
                    defaults[["axis.tickfont.family"]], "Arial"
                ),
                "Arial"
            )
        ),
        numericInput(ns("axis.tickangle.x"), "X Tick Label Angle",
            value = ifelse("axis.tickangle.x" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.tickangle.x"]]), defaults[["axis.tickangle.x"]], 0),
                0
            ),
            min = -180,
            max = 180,
            step = 15
        ),
        numericInput(ns("axis.tickangle.y"), "Y Tick Label Angle",
            value = ifelse("axis.tickangle.y" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.tickangle.y"]]), defaults[["axis.tickangle.y"]], 0),
                0
            ),
            min = -180,
            max = 180,
            step = 15
        ),
        selectInput(ns("axis.ticks"), "Tick Position",
            choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
            selected = ifelse("axis.ticks" %in% names(defaults),
                ifelse(defaults[["axis.ticks"]] %in% c("outside", "inside", ""),
                    defaults[["axis.ticks"]], "outside"
                ),
                "outside"
            )
        ),
        colourInput(ns("axis.tickcolor"), "Tick Mark Color",
            value = ifelse("axis.tickcolor" %in% names(defaults),
                defaults[["axis.tickcolor"]], "black"
            )
        ),
        numericInput(ns("axis.ticklen"), "Tick Mark Length",
            value = ifelse("axis.ticklen" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.ticklen"]]), defaults[["axis.ticklen"]], 5),
                5
            ),
            min = 0,
            step = 1
        ),
        numericInput(ns("axis.tickwidth"), "Tick Mark Width",
            value = ifelse("axis.tickwidth" %in% names(defaults),
                ifelse(is.numeric(defaults[["axis.tickwidth"]]), defaults[["axis.tickwidth"]], 1),
                1
            ),
            min = 0,
            step = 0.1
        )
    )
}
