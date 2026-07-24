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
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `legend.direction` - Legend orientation (plotly allows interactive adjustment)
#' - `x_sep` - Separator for multiple x columns (not yet implemented)
#' - `y_sep` - Separator for multiple y columns (not yet implemented)
#' - `split_by` - Split variable for separate plots (doesn't work with plotly; `facet_by` available instead)
#' - `split_by_sep` - Separator for multiple `split_by` columns (`split_by` not used in module)
#' - `size_name` - Size legend name (plotly allows interactive editing)
#' - `fill_name` - Fill legend name (not yet implemented)
#' - `fill_cutoff_name` - Fill cutoff legend name (not yet implemented)
#' - `theme` - ggplot2 theme (managed internally)
#' - `theme_args` - Theme arguments (not yet implemented)
#' - `palcolor` - Managed internally via the palette selection UI
#' - `border_alpha` - Dot border transparency (not exposed; uses the plotthis default of 1)
#' - `add_bg` - Add background stripes/shading (not yet implemented)
#' - `bg_palette` - Background palette (not yet implemented)
#' - `bg_palcolor` - Background palette colors (not yet implemented)
#' - `bg_alpha` - Background alpha (not yet implemented)
#' - `bg_direction` - Background stripe direction (not yet implemented)
#' - `x_text_angle` - X-axis text angle (handled by axis.tickangle.x)
#' - `keep_empty` - Keep empty factor levels (not yet implemented)
#' - `keep_na` - Keep NA values (not yet implemented)
#' - `combine` - Combine multiple plots (not applicable as `split_by` is not implemented)
#' - `seed` - Random seed (not applicable)
#' - `nrow` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `ncol` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `byrow` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `axes` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `axis_titles` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `guides` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#' - `design` - Only applies if `split_by` is used with combine (`split_by` not used in module)
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::DotPlot()] and custom parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X Values", default: 2nd categorical variable)
#' - `y` - Y-axis variable (UI: "Y Values", default: 3rd categorical variable)
#' - `size_by` - Numeric column mapped to dot size (UI: "Size By", default: "" = count)
#' - `size_min` - Minimum dot size (UI: "Min Dot Size", default: 1)
#' - `size_max` - Maximum dot size (UI: "Max Dot Size", default: 6)
#' - `fill_by` - Numeric column mapped to dot fill (UI: "Fill By", default: "")
#' - `fill_cutoff` - Cutoff applied to the fill column (UI: "Fill Cutoff", default: NA)
#' - `fill_cutoff_direction` - Direction of the fill cutoff (UI: "Fill Cutoff Direction",
#'   default: "<"); combined with `fill_cutoff` into a `plotthis` expression such as `"< 18"`.
#' - `flip` - Flip the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#' - `facet_by` - Faceting variable (UI: "Facet By", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#' - `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)
#' - `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)
#' - `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default: TRUE)
#' - `palette` - Continuous fill palette (UI: "Color Palette", default: "Spectral")
#' - `palreverse` - Reverse the color palette (UI: "Reverse palette", default: FALSE)
#' - `alpha` - Dot fill transparency (UI: "Alpha", default: 1)
#' - `border_color` - Dot border color; only constant colors are supported
#'   (UI: "Border Color", default: "black")
#' - `border_size` - Dot border stroke width (UI: "Border Size", default: 0.5)
#' - `lower_quantile` - Lower quantile for the continuous fill color scale
#'   (UI: "Lower Quantile", default: 0)
#' - `upper_quantile` - Upper quantile for the continuous fill color scale
#'   (UI: "Upper Quantile", default: 1)
#' - `lower_cutoff` - Explicit lower cutoff for the continuous fill color scale
#'   (UI: "Lower Cutoff", default: NA); overrides `lower_quantile` when set
#' - `upper_cutoff` - Explicit upper cutoff for the continuous fill color scale
#'   (UI: "Upper Cutoff", default: NA); overrides `upper_quantile` when set
#' - `size.legend.x` - Custom size-legend x position (UI: "Size Legend X Position",
#'   default: 1.04); nudges the manual size legend (drawn when `size.by` is set) along the x-axis.
#' - `size.legend.y` - Custom size-legend y position (UI: "Size Legend Y Position",
#'   default: 0.35); nudges the manual size legend (drawn when `size.by` is set) along the y-axis.
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
        "palette", "palreverse", "alpha", "border_color", "border_size",
        c("lower_quantile", "upper_quantile"), c("lower_cutoff", "upper_cutoff")
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::DotPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.data"), "X Values",
                selected = get_default(
                    defaults, "x.data", char.choices[2],
                    function(x) x %in% char.choices
                ),
                choices = char.choices, selectize = FALSE
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.data"), "Y Values",
                selected = get_default(
                    defaults, "y.data", char.choices[min(3, length(char.choices))],
                    function(x) x %in% char.choices
                ),
                choices = char.choices, selectize = FALSE
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("size.by"), "Size By",
                selected = get_default(defaults, "size.by", "", function(x) x == "" || x %in% num.choices),
                choices = num.choices, selectize = FALSE
            ), documentParameters$size_by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("fill.by"), "Fill By",
                selected = get_default(defaults, "fill.by", "", function(x) x == "" || x %in% num.choices),
                choices = num.choices, selectize = FALSE
            ), documentParameters$fill_by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("fill.cutoff.direction"), "Fill Cutoff Direction",
                selected = get_default(
                    defaults, "fill.cutoff.direction", "<",
                    function(x) x %in% c("<", "<=", ">", ">=")
                ),
                choices = c("<", "<=", ">", ">="), selectize = FALSE
            ), paste(
                "Direction of the fill cutoff. Values on the selected side of the",
                "cutoff (e.g. '<' greys out values below it) are set to NA and drawn",
                "in grey. Only applies when 'Fill By' and 'Fill Cutoff' are set."
            ), placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("fill.cutoff"), "Fill Cutoff",
                value = get_default(defaults, "fill.cutoff", NA, is.numeric)
            ), documentParameters$fill_cutoff, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet By",
                selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% char.choices),
                choices = c("", .facet_check(data)), selectize = FALSE
            ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("facet.scale"), "Facet Scale",
                selected = get_default(
                    defaults, "facet.scale", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                ),
                choices = c("fixed", "free", "free_x", "free_y"), selectize = FALSE
            ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.ncol"), "Columns",
                value = get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0, max = 20
            ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.nrow"), "Rows",
                value = get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0, max = 20
            ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
            tipify(
                materialSwitch(ns("facet.by.row"), "Facet by Row",
                    value = get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"
                ),
                documentParameters$facet_byrow,
                placement = "top", options = list(container = "body")
            ),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Aesthetics" = tagList(
            tipify(selectInput(ns("palette.name"), "Color Palette",
                choices = palette_names,
                selected = get_default(
                    defaults, "palette.name", "Spectral",
                    function(x) x %in% palette_names
                ), selectize = FALSE
            ), documentParameters$palette, placement = "top", options = list(container = "body")),
            tipify(
                materialSwitch(ns("palreverse"), "Reverse Palette",
                    value = get_default(defaults, "palreverse", FALSE, is.logical), status = "success"
                ),
                documentParameters$palreverse,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("alpha"), "Alpha",
                    value = get_default(defaults, "alpha", 1, is.numeric), min = 0, max = 1
                ),
                documentParameters$alpha,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("border.color"), "Border Color",
                    value = get_default(defaults, "border.color", "black", is.character)
                ),
                documentParameters$border_color,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("border.size"), "Border Size",
                    value = get_default(defaults, "border.size", 0.5, is.numeric), min = 0, step = 0.1
                ),
                documentParameters$border_size,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("lower.quantile"), "Lower Quantile",
                    value = get_default(defaults, "lower.quantile", 0, is.numeric),
                    min = 0, max = 1, step = 0.01
                ),
                documentParameters$lower_quantile,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("upper.quantile"), "Upper Quantile",
                    value = get_default(defaults, "upper.quantile", 1, is.numeric),
                    min = 0, max = 1, step = 0.01
                ),
                documentParameters$upper_quantile,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("lower.cutoff"), "Lower Cutoff",
                    value = get_default(defaults, "lower.cutoff", NA, is.numeric)
                ),
                documentParameters$lower_cutoff,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("upper.cutoff"), "Upper Cutoff",
                    value = get_default(defaults, "upper.cutoff", NA, is.numeric)
                ),
                documentParameters$upper_cutoff,
                placement = "top", options = list(container = "body")
            )
        ),
        "Legend" = tagList(
            tipify(numericInput(ns("size.min"), "Min Dot Size",
                value = get_default(defaults, "size.min", 1, is.numeric), min = 0, step = 1
            ), documentParameters$size_min, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.max"), "Max Dot Size",
                value = get_default(defaults, "size.max", 6, is.numeric), min = 0, step = 1
            ), documentParameters$size_max, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.legend.x"), "Size Legend X Position",
                value = get_default(defaults, "size.legend.x", 1.04, is.numeric),
                step = 0.02
            ), paste(
                "Horizontal position (paper coordinates) of the custom size",
                "legend drawn when 'Size By' is set. Values just above 1 sit to",
                "the right of the plot; lower it to pull the legend inward on",
                "narrow plots or raise it to push it further out."
            ), placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.legend.y"), "Size Legend Y Position",
                value = get_default(defaults, "size.legend.y", 0.35, is.numeric),
                step = 0.05
            ), paste(
                "Vertical position (paper coordinates) of the custom size",
                "legend drawn when 'Size By' is set. Lower it to offset the",
                "size legend from an overlapping color or shape legend."
            ), placement = "top", options = list(container = "body")),
            uniform_legend_inputs_ui(ns, defaults)
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
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
