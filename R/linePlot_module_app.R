#' Create an example Modular linePlot Shiny Application
#'
#' This function generates a Shiny application with modular [VizModules::linePlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive line plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches on `example_sales`
#' with the settings the module gallery ([moduleGalleryApp()]) opens this module on,
#' so its main features are on show from the start; any `defaults` you pass are
#' applied over those. Uploaded data files are added to the available datasets and
#' can be selected for plotting. If an uploaded file shares a name with an existing
#' dataset, the existing one is overwritten with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   the module's example dataset is used, along with its showcase defaults.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::linePlot()], [VizModules::linePlotInputsUI()],
#' [VizModules::linePlotOutputUI()], [VizModules::linePlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data (example_sales):
#' app <- linePlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- linePlotApp(list("sales" = example_sales))
#' if (interactive()) runApp(app2)
linePlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        example <- .module_example("line")
        data_list <- example$data_list
        defaults <- utils::modifyList(example$defaults, defaults %||% list())
    }
    createModuleApp(
        inputs_ui_fn = linePlotInputsUI,
        output_ui_fn = linePlotOutputUI,
        server_fn    = linePlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular linePlots"
    )
}


