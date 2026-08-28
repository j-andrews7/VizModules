#' Create an example Modular freqPlot Shiny Application
#'
#' This function generates a Shiny application with modular [dittoViz::freqPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive frequency plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_composition` as an example dataset, which has twelve donors nested
#' inside two conditions - the shape [dittoViz::freqPlot()] needs to compare
#' per-sample frequencies across groups.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("composition" = example_composition)` is used as example data.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [dittoViz::freqPlot()], [VizModules::dittoViz_freqPlotInputsUI()],
#' [VizModules::dittoViz_freqPlotOutputUI()], [VizModules::dittoViz_freqPlotServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- dittoViz_freqPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch on the cell-type composition of each donor, split by disease state:
#' app2 <- dittoViz_freqPlotApp(
#'     defaults = list(
#'         var = "cell_type", sample.by = "sample", group.by = "condition"
#'     )
#' )
#' if (interactive()) runApp(app2)
dittoViz_freqPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        data_list <- list("composition" = example_composition)
        # Only seeded alongside the bundled dataset, so supplying your own data
        # still opens on columns chosen from it rather than on these names.
        if (is.null(defaults)) {
            defaults <- list(var = "cell_type", sample.by = "sample", group.by = "condition")
        }
    }
    createModuleApp(
        inputs_ui_fn = dittoViz_freqPlotInputsUI,
        output_ui_fn = dittoViz_freqPlotOutputUI,
        server_fn    = dittoViz_freqPlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular freqPlots"
    )
}
