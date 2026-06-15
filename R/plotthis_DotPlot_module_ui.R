#' Input UI components for the DotPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_DotPlotServer()` and `plotthis_DotPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::DotPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::DotPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{legend.direction} - Legend orientation (plotly allows interactive adjustment)
#'   \item \code{x_sep} - Separator for multiple x columns (not yet implemented)
#'   \item \code{y_sep} - Separator for multiple y columns (not yet implemented)
#'   \item \code{split_by} - Split variable for separate plots (doesn't work with plotly; `facet_by` available instead)
#'   \item \code{split_by_sep} - Separator for multiple `split_by` columns (`split_by` not used in module)
#'   \item \code{size_name} - Size legend name (plotly allows interactive editing)
#'   \item \code{fill_name} - Fill legend name (not yet implemented)
#'   \item \code{fill_cutoff_name} - Fill cutoff legend name (not yet implemented)
#'   \item \code{theme} - ggplot2 theme (managed internally)
#'   \item \code{theme_args} - Theme arguments (not yet implemented)
#'   \item \code{palcolor} - Managed internally via the palette selection UI
#'   \item \code{x_text_angle} - X-axis text angle (handled by axis.tickangle.x)
#'   \item \code{keep_empty} - Keep empty factor levels (not yet implemented)
#'   \item \code{keep_na} - Keep NA values (not yet implemented)
#'   \item \code{combine} - Combine multiple plots (not applicable as `split_by` is not implemented)
#'   \item \code{seed} - Random seed (not applicable)
#'   \item \code{nrow} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{ncol} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{byrow} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{axes} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{axis_titles} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{guides} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#'   \item \code{design} - Only applies if \code{split_by} is used with combine (`split_by` not used in module)
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::DotPlot()] and custom parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X Values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y Values", default: 3rd categorical variable)
#'   \item \code{size_by} - Numeric column mapped to dot size (UI: "Size By", default: "" = count)
#'   \item \code{size_min} - Minimum dot size (UI: "Min Dot Size", default: 1)
#'   \item \code{size_max} - Maximum dot size (UI: "Max Dot Size", default: 10)
#'   \item \code{fill_by} - Numeric column mapped to dot fill (UI: "Fill By", default: "")
#'   \item \code{fill_cutoff} - Cutoff applied to the fill column (UI: "Fill Cutoff", default: NA)
#'   \item \code{flip} - Flip the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#'   \item \code{facet_by} - Faceting variable (UI: "Facet By", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by Row", default: TRUE)
#'   \item \code{palette} - Continuous fill palette (UI: "Color Palette", default: "Spectral")
#'   \item \code{alpha} - Dot fill transparency (UI: "Alpha", default: 1)
#'   \item \code{size.legend.x} - Custom size-legend x position (UI: "Size Legend X Position",
#'     default: 1.02); nudges the manual size legend (drawn when \code{size.by} is set) along the x-axis.
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
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinyBS tipify
#' @import shiny
#' @importFrom plotthis DotPlot
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::DotPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_DotPlotOutputUI()], [VizModules::plotthis_DotPlotServer()], [VizModules::plotthis_DotPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_DotPlotInputsUI("DotPlot", mtcars)
plotthis_DotPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)
    if (is.null(defaults)) defaults <- list()
    if (is.null(defaults[["margin.r"]])) defaults[["margin.r"]] <- 140
    # Get variables of data.
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    char.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    # Continuous palette choices for the fill gradient.
    palette_names <- names(.flatten_palette_options(default_palettes()[["choices"]]))

    selected <- list(
        "x", "y", "size_by", "fill_by", "fill_cutoff", "size_min", "size_max",
        "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow",
        "palette", "alpha"
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::DotPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.data"), "X Values",
                selected = .get_default(
                    defaults, "x.data", char.choices[2],
                    function(x) x %in% char.choices
                ),
                choices = char.choices, selectize = FALSE
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.data"), "Y Values",
                selected = .get_default(
                    defaults, "y.data", char.choices[min(3, length(char.choices))],
                    function(x) x %in% char.choices
                ),
                choices = char.choices, selectize = FALSE
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("size.by"), "Size By",
                selected = .get_default(defaults, "size.by", "", function(x) x == "" || x %in% num.choices),
                choices = num.choices, selectize = FALSE
            ), documentParameters$size_by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("fill.by"), "Fill By",
                selected = .get_default(defaults, "fill.by", "", function(x) x == "" || x %in% num.choices),
                choices = num.choices, selectize = FALSE
            ), documentParameters$fill_by, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("fill.cutoff"), "Fill Cutoff",
                value = .get_default(defaults, "fill.cutoff", NA, is.numeric)
            ), documentParameters$fill_cutoff, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet By",
                selected = .get_default(defaults, "facet.by", "", function(x) x == "" || x %in% char.choices),
                choices = c(char.choices, ""), selectize = FALSE
            ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("facet.scale"), "Facet Scale",
                selected = .get_default(
                    defaults, "facet.scale", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                ),
                choices = c("fixed", "free", "free_x", "free_y"), selectize = FALSE
            ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.ncol"), "Columns",
                value = .get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0, max = 20
            ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.nrow"), "Rows",
                value = .get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0, max = 20
            ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
            tipify(
                materialSwitch(ns("facet.by.row"), "Facet by Row",
                    value = .get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"
                ),
                documentParameters$facet_byrow,
                placement = "top", options = list(container = "body")
            ),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Aesthetics" = tagList(
            tipify(selectInput(ns("palette.name"), "Color Palette",
                choices = palette_names,
                selected = .get_default(
                    defaults, "palette.name", "Spectral",
                    function(x) x %in% palette_names
                ), selectize = FALSE
            ), documentParameters$palette, placement = "top", options = list(container = "body")),
            tipify(
                numericInput(ns("alpha"), "Alpha",
                    value = .get_default(defaults, "alpha", 1, is.numeric), min = 0, max = 1
                ),
                documentParameters$alpha,
                placement = "top", options = list(container = "body")
            )
        ),
        "Legend" = tagList(
            tipify(numericInput(ns("size.min"), "Min Dot Size",
                value = .get_default(defaults, "size.min", 1, is.numeric), min = 0, step = 1
            ), documentParameters$size_min, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.max"), "Max Dot Size",
                value = .get_default(defaults, "size.max", 6, is.numeric), min = 0, step = 1
            ), documentParameters$size_max, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.legend.x"), "Size Legend X Position",
                value = .get_default(defaults, "size.legend.x", 1.02, is.numeric),
                step = 0.02
            ), paste(
                "Horizontal position (paper coordinates) of the custom size",
                "legend drawn when 'Size By' is set. Values just above 1 sit to",
                "the right of the plot; lower it to pull the legend inward on",
                "narrow plots or raise it to push it further out."
            ), placement = "top", options = list(container = "body")),
            .uniform_legend_inputs_ui(ns, defaults)
        ),
        "Plotly" = .uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("DotPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the DotPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output
#'   is wrapped in \code{\link[shinyjqui]{jqui_resizable}} so it can be resized
#'   by dragging. Set to \code{FALSE} when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the DotPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_DotPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("DotPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
