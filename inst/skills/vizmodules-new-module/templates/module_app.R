# TEMPLATE: R/<MODULE>_module_app.R
#
# Every *App() is a thin wrapper around createModuleApp(). Do not re-implement data
# import, the filterable table, or dataset switching -- createModuleApp() already does
# all of that. Replace <MODULE>, <PLOTFN>, <DATASET> (a bundled example dataset that
# suits this plot) and <LABEL>.

#' Create an example Modular <MODULE> Shiny Application
#'
#' This function generates a Shiny application with modular [<PLOTFN>()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `<DATASET>` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("<LABEL>" = <DATASET>)` is used as example data.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @export
#' @author Your Name
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- <MODULE>App()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- <MODULE>App(list("<LABEL>" = <DATASET>))
#' if (interactive()) runApp(app2)
<MODULE>App <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        data_list <- list("<LABEL>" = <DATASET>)
    }
    createModuleApp(
        inputs_ui_fn = <MODULE>InputsUI,
        output_ui_fn = <MODULE>OutputUI,
        server_fn    = <MODULE>Server,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular <MODULE>s"
    )
}
