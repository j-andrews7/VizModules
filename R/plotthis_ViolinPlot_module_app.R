#' Create an example Modular ViolinPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::ViolinPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive violin plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_iris` and `example_mtcars` as example datasets. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("iris" = example_iris, "mtcars" = example_mtcars)` is used as example data.
#' @return A Shiny app object.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- plotthis_ViolinPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- plotthis_ViolinPlotApp(list("sales" = example_sales, "population" = example_population))
#' if (interactive()) runApp(app2)
plotthis_ViolinPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("iris" = example_iris, "mtcars" = example_mtcars)
    }
    createModuleApp(
        inputs_ui_fn = plotthis_ViolinPlotInputsUI,
        output_ui_fn = plotthis_ViolinPlotOutputUI,
        server_fn    = plotthis_ViolinPlotServer,
        data_list    = data_list,
        title        = "Modular ViolinPlots"
    )
}
