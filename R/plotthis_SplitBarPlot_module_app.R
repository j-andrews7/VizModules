#' Create an example Modular SplitBarPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::SplitBarPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive split bar plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_bar` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("Bar" = example_bar)` is used as example data.
#' @return A Shiny app object.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- plotthis_SplitBarPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- plotthis_SplitBarPlotApp(list("Bar" = example_bar))
#' if (interactive()) runApp(app2)
plotthis_SplitBarPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("Bar" = example_bar)
    }
    createModuleApp(
        inputs_ui_fn = plotthis_SplitBarPlotInputsUI,
        output_ui_fn = plotthis_SplitBarPlotOutputUI,
        server_fn    = plotthis_SplitBarPlotServer,
        data_list    = data_list,
        title        = "Modular SplitBarPlots"
    )
}
