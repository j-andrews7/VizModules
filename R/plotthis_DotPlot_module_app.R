#' Create an example Modular DotPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::DotPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive dot plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_markers` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("markers" = example_markers)` is used as example data.
#' @return A Shiny app object.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- plotthis_DotPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- plotthis_DotPlotApp(list("markers" = example_markers))
#' if (interactive()) runApp(app2)
plotthis_DotPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("markers" = example_markers)
    }
    createModuleApp(
        inputs_ui_fn = plotthis_DotPlotInputsUI,
        output_ui_fn = plotthis_DotPlotOutputUI,
        server_fn    = plotthis_DotPlotServer,
        data_list    = data_list,
        title        = "Modular DotPlots"
    )
}
