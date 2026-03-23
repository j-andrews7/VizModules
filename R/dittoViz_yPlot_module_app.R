#' Create an example Modular yPlot Shiny Application
#'
#' This function generates a Shiny application with modular [dittoViz::yPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive y plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `gallery_demographics` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("demographics" = gallery_demographics)` is used as example data.
#' @return A Shiny app object.
#'
#' @seealso [dittoViz::yPlot()], [VizModules::dittoViz_yPlotInputsUI()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- dittoViz_yPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- dittoViz_yPlotApp(list("demographics" = example_demographics))
#' if (interactive()) runApp(app2)
dittoViz_yPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("demographics" = example_demographics)
    }
    createModuleApp(
        inputs_ui_fn = dittoViz_yPlotInputsUI,
        output_ui_fn = dittoViz_yPlotOutputUI,
        server_fn    = dittoViz_yPlotServer,
        data_list    = data_list,
        title        = "Modular yPlots"
    )
}
