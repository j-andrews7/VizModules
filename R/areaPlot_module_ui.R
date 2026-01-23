#' Input UI components for the AreaPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `AreaPlotServer()` and `AreaPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::AreaPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#' 
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::AreaPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{split_by} - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#'   \item \code{design} - Only applies if `split_by` is used
#'   \item \code{split_by_sep} - Only applies if `split_by` is used
#'   \item \code{axes} - Only applies if `split_by` is used
#'   \item \code{axis_titles} - Only applies if `split_by` is used
#'   \item \code{guides} - Only applies if `split_by` is used
#'   \item \code{byrow} - Only applies if `split_by` is used
#'   \item \code{nrow} - Only applies if `split_by` is used
#'   \item \code{ncol} - Only applies if `split_by` is used
#'   \item \code{palette} - Managed internally via the palette selection UI
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::AreaPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable for area fill (UI: "Group by", default: 3rd categorical variable or "")
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Facet number of columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Facet number of rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by row", default: TRUE)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#'   \item \code{theme} - ggplot2 theme (UI: "Theme", default: "theme_this")
#'   \item \code{alpha} - Area fill transparency (UI: "Alpha", default: 1)
#'   \item \code{scale_y} - Scale y-axis by total (UI: "Scale y-axis by total", default: FALSE)
#'   \item \code{legend_direction} - Legend orientation (UI: "Legend direction", default: "vertical")
#' }
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @importFrom colourpicker colourInput
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::AreaPlot()], [vizModules::organize_inputs()],
#' [vizModules::AreaPlotOutputUI()], [vizModules::AreaPlotServer()], [vizModules::AreaPlotApp()]
#' @examples
#' library(vizModules)
#' # Needs at least 2 categorical variables for grouping and x-axis
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' mtcars$gear <- as.factor(mtcars$gear)
#' AreaPlotInputsUI("areaPlot", mtcars)
AreaPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)
    group_facet_choices <- setdiff(cat.choices, cat.choices[2])

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X values:",
                selected = ifelse("x.data" %in% names(defaults) && defaults[["x.data"]] %in% cat.choices,
                    defaults[["x.data"]], cat.choices[2]
                ),
                choices = cat.choices
            ),
            selectInput(ns("y.data"), "Y values:",
                selected = ifelse("y.data" %in% names(defaults) && defaults[["y.data"]] %in% num.choices,
                    defaults[["y.data"]], num.choices[2]
                ),
                choices = num.choices
            ),
            selectInput(ns("group.by"), "Group by:",
                selected = ifelse("group.by" %in% names(defaults) && defaults[["group.by"]] %in% c("", group_facet_choices),
                    defaults[["group.by"]], cat.choices[3]
                ),
                choices = c("", group_facet_choices)
            )
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:",
                selected = ifelse("facet.by" %in% names(defaults) && defaults[["facet.by"]] %in% c(group_facet_choices, ""),
                    defaults[["facet.by"]], ""
                ),
                choices = c(group_facet_choices, "")
            ),
            selectInput(ns("facet.scale"), "Facet scale:",
                selected = ifelse("facet.scale" %in% names(defaults) && defaults[["facet.scale"]] %in% c("fixed", "free", "free_x", "free_y"),
                    defaults[["facet.scale"]], "fixed"
                ),
                choices = c("fixed", "free", "free_x", "free_y")
            ),
            numericInput(ns("facet.ncol"), "Facet number of columns:",
                value = ifelse("facet.ncol" %in% names(defaults) && is.numeric(defaults[["facet.ncol"]]),
                    defaults[["facet.ncol"]], NULL
                ),
                min = 0, max = 20
            ),
            numericInput(ns("facet.nrow"), "Facet number of rows:",
                value = ifelse("facet.nrow" %in% names(defaults) && is.numeric(defaults[["facet.nrow"]]),
                    defaults[["facet.nrow"]], NULL
                ),
                min = 0, max = 20
            ),
            materialSwitch(ns("facet.by.row"), "Facet by row",
                value = ifelse("facet.by.row" %in% names(defaults),
                    ifelse(is.logical(defaults[["facet.by.row"]]), defaults[["facet.by.row"]], TRUE),
                    TRUE
                ),
                status = "success"
            )
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            selectInput(ns("theme"), "Theme:",
                selected = ifelse("theme" %in% names(defaults) && defaults[["theme"]] %in% c(
                    "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                    "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                    "theme_this", "theme_blank"
                ), defaults[["theme"]], "theme_this"),
                choices = c(
                    "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                    "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                    "theme_this", "theme_blank"
                )
            ),
            numericInput(ns("alpha"), "Alpha:",
                value = ifelse("alpha" %in% names(defaults),
                    ifelse(is.numeric(defaults[["alpha"]]), defaults[["alpha"]], 1),
                    1
                ),
                min = 0, max = 1
            ),
            selectInput(ns("legend.direction"), "Legend direction:",
                selected = ifelse("legend.direction" %in% names(defaults) && defaults[["legend.direction"]] %in% c("vertical", "horizontal"),
                    defaults[["legend.direction"]], "vertical"
                ),
                choices = c("vertical", "horizontal")
            )
        ),
        "Axes" = tagList(
            numericInput(ns("axis.font.size"), "Axis font size",
                value = ifelse("axis.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.font.size"]]), defaults[["axis.font.size"]], 18),
                    18
                ),
                min = 1
            ),
            numericInput(ns("title.font.size"), "Title font size",
                value = ifelse("title.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["title.font.size"]]), defaults[["title.font.size"]], 28),
                    28
                ),
                min = 1
            ),
            selectInput(ns("font.type"), "Font:",
                selected = ifelse("font.type" %in% names(defaults) && defaults[["font.type"]] %in% c(
                    "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono",
                    "Gravitas One", "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow",
                    "Raleway", "Times New Roman", "Verdana", "sans-serif", "serif", "monospace"
                ), defaults[["font.type"]], "Arial"),
                choices = c(
                    "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono",
                    "Gravitas One", "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow",
                    "Raleway", "Times New Roman", "Verdana", "sans-serif", "serif", "monospace"
                )
            ),
            colourpicker::colourInput(ns("text.colour"), "Label colour:",
                value = ifelse("text.colour" %in% names(defaults),
                    defaults[["text.colour"]], "#000000"
                )
            ),
            checkboxInput(ns("axis.showline"), "Show axis lines",
                value = ifelse("axis.showline" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.showline"]]), defaults[["axis.showline"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("axis.mirror"), "Mirror axis lines",
                value = ifelse("axis.mirror" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.mirror"]]), defaults[["axis.mirror"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("axis.linecolor"), "Axis line color",
                value = ifelse("axis.linecolor" %in% names(defaults),
                    defaults[["axis.linecolor"]], "black"
                )
            ),
            numericInput(ns("axis.linewidth"), "Axis line width",
                value = ifelse("axis.linewidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.linewidth"]]), defaults[["axis.linewidth"]], 0.5),
                    0.5
                ),
                min = 0,
                step = 0.1
            ),
            materialSwitch(ns("scale.y"), "Scale y-axis by total",
                value = ifelse("scale.y" %in% names(defaults),
                    ifelse(is.logical(defaults[["scale.y"]]), defaults[["scale.y"]], FALSE),
                    FALSE
                ),
                status = "success"
            )
        ),
        "Ticks" = tagList(
            numericInput(ns("axis.tickfont.size"), "Tick label size",
                value = ifelse("axis.tickfont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickfont.size"]]), defaults[["axis.tickfont.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourInput(ns("axis.tickfont.color"), "Tick label color",
                value = ifelse("axis.tickfont.color" %in% names(defaults),
                    defaults[["axis.tickfont.color"]], "black"
                )
            ),
            selectInput(ns("axis.tickfont.family"), "Tick label font",
                choices = c(
                    "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                    "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                    "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                    "Verdana", "sans-serif", "serif", "monospace"
                ),
                selected = ifelse("axis.tickfont.family" %in% names(defaults),
                    ifelse(defaults[["axis.tickfont.family"]] %in% c(
                        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                        "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                        "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                        "Verdana", "sans-serif", "serif", "monospace"
                    ), defaults[["axis.tickfont.family"]], "Arial"),
                    "Arial"
                )
            ),
            numericInput(ns("axis.tickangle.x"), "X-axis tick label angle",
                value = ifelse("axis.tickangle.x" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.x"]]), defaults[["axis.tickangle.x"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            numericInput(ns("axis.tickangle.y"), "Y-axis tick label angle",
                value = ifelse("axis.tickangle.y" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.y"]]), defaults[["axis.tickangle.y"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            selectInput(ns("axis.ticks"), "Tick position",
                choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
                selected = ifelse("axis.ticks" %in% names(defaults),
                    ifelse(defaults[["axis.ticks"]] %in% c("outside", "inside", ""),
                        defaults[["axis.ticks"]], "outside"
                    ),
                    "outside"
                )
            ),
            colourInput(ns("axis.tickcolor"), "Tick mark color",
                value = ifelse("axis.tickcolor" %in% names(defaults),
                    defaults[["axis.tickcolor"]], "black"
                )
            ),
            numericInput(ns("axis.ticklen"), "Tick mark length",
                value = ifelse("axis.ticklen" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.ticklen"]]), defaults[["axis.ticklen"]], 5),
                    5
                ),
                min = 0,
                step = 1
            ),
            numericInput(ns("axis.tickwidth"), "Tick mark width",
                value = ifelse("axis.tickwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickwidth"]]), defaults[["axis.tickwidth"]], 1),
                    1
                ),
                min = 0,
                step = 0.1
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("AreaPlotTabsetPanel"),
        title = title,
        tack = tagList(
            fluidRow(
                column(3, materialSwitch(ns("auto.update"), "Auto Update", value = FALSE, status = "success"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("update"), "Update", width = "100%"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("reset"), "Reset", class = "btn-secondary", width = "100%"), style = "margin-top: 25px;"),
                column(3, selectInput(ns("download.type"), "Download Format", selected = "png", choices = c("png", "svg"), width = "100%"))
            ),
            br()
        ),
        columns = columns
    )
}

#' Output UI components for the AreaPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the AreaPlot
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
AreaPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("AreaPlot"))
    )
}
