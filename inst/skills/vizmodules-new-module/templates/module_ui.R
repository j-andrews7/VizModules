# TEMPLATE: R/<MODULE>_module_ui.R
#
# Replace throughout:
#   <MODULE>    module name, e.g. plotthis_RidgePlot / dittoViz_freqPlot / myPlot
#   <PLOTFN>    underlying plot function, e.g. plotthis::RidgePlot
#   <OUTPUTID>  the plot output id, conventionally the bare plot name, e.g. RidgePlot
#   <TABSETID>  <OUTPUTID>TabsetPanel
#
# Delete every comment marked [T] before committing.

#' Input UI components for the <MODULE> module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `<MODULE>Server()` and `<MODULE>OutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()`
#' function, with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults`
#' argument. Nearly all parameters for [<PLOTFN>()] can be set via these inputs, so see the
#' help for that function for an exhaustive list.
#'
#' [T] The three @section blocks below are MANDATORY. See references/roxygen-sections.md.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [<PLOTFN>()] parameters are not available via UI inputs:
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `split_by` - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#' - `palette` - Managed internally via the palette selection UI
#'
#' @section Plot parameters and defaults:
#' The following [<PLOTFN>()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X Values", default: 2nd categorical variable)
#' - `y` - Y-axis variable (UI: "Y Values", default: 2nd numeric variable)
#' - `group_by` - Grouping variable (UI: "Group By", default: 3rd categorical variable or "")
#' - `facet_by` - Faceting variable (UI: "Facet By", default: "")
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific
#' features are also available:
#'
#' - `title.font.size` - Plot title font size (UI: "Title Size", default: 26)
#' - `axis.title.font.size` - Axis title font size (UI: "Axis Title Size", default: 18)
#' - `hline.intercepts` - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#' - `palette.colours` - Named character vector mapping group levels to colors, e.g.
#'   `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds the picker; unnamed groups fall
#'   back to the default palette and user edits take precedence.
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs. An entry may also be a
#'   [shiny::reactive()] or [shiny::reactiveVal()]; it is resolved with [shiny::isolate()] to
#'   seed the control, and the module then keeps it live (see [setup_reactive_defaults()]).
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @importFrom colourpicker colourInput
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Your Name
#' @seealso [<PLOTFN>()], [VizModules::organize_inputs()],
#' [VizModules::<MODULE>OutputUI()], [VizModules::<MODULE>Server()], [VizModules::<MODULE>App()]
#' @examples
#' library(VizModules)
#' <MODULE>InputsUI("plot", example_demographics)
<MODULE>InputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    group_facet_choices <- setdiff(cat.choices, cat.choices[2])

    # [T] Pulls upstream parameter documentation for the tooltips. List the argument
    # names of <PLOTFN> that you expose; documentParameters$<arg> is then the tip text.
    selected <- list(
        "x", "y", "group_by",
        "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow"
    )
    documentParameters <- get_documentation(
        package_name = "<PLOTFN>", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(viz_select_input(ns("x.data"), "X Values",
                selected = get_default(
                    defaults, "x.data", cat.choices[2],
                    function(x) x %in% cat.choices
                ),
                choices = cat.choices[nzchar(cat.choices)]
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("y.data"), "Y Values",
                selected = get_default(
                    defaults, "y.data", num.choices[2],
                    function(x) x %in% num.choices
                ),
                choices = num.choices[nzchar(num.choices)]
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("group.by"), "Group By",
                selected = get_default(
                    defaults, "group.by", cat.choices[3],
                    function(x) x %in% c("", group_facet_choices)
                ),
                choices = c("", group_facet_choices)
            ), documentParameters$group_by, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(viz_select_input(ns("facet.by"), "Facet By",
                selected = get_default(
                    defaults, "facet.by", "",
                    function(x) x %in% c(group_facet_choices, "")
                ),
                choices = c(intersect(group_facet_choices, .facet_check(data)), "")
            ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("facet.scale"), "Facet Scale",
                selected = get_default(
                    defaults, "facet.scale", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                ),
                choices = c("fixed", "free", "free_x", "free_y")
            ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.ncol"), "Columns",
                value = get_default(defaults, "facet.ncol", NA, is.numeric),
                min = 0, max = 20
            ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("facet.nrow"), "Rows",
                value = get_default(defaults, "facet.nrow", NA, is.numeric),
                min = 0, max = 20
            ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("facet.by.row"), "Facet By Row",
                value = get_default(defaults, "facet.by.row", TRUE, is.logical),
                status = "success"
            ), documentParameters$facet_byrow, placement = "top", options = list(container = "body")),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Aesthetics" = tagList(
            # [T] The colour picker is rendered server-side; this is only its slot.
            uiOutput(ns("palette.selection")),
            tipify(numericInput(ns("alpha"), "Alpha",
                value = get_default(defaults, "alpha", 1, is.numeric),
                min = 0, max = 1
            ), "Fill transparency", placement = "top", options = list(container = "body"))
        ),
        # [T] Shared tabs. Add `"Stats" = .uniform_stats_inputs_ui(ns, defaults)` only for
        # categorical-x / numeric-y plots. See references/stats-integration.md.
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("<TABSETID>"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}

#' Output UI components for the <MODULE> module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the <MODULE>
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Your Name
<MODULE>OutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("<OUTPUTID>"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
