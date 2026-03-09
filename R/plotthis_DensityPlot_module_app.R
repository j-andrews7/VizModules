#' Create an example Modular DensityPlot Shiny Application
#'
#' This function generates a Shiny application with modular density plot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive density plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_sales` and `example_population` as example datasets. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("sales" = example_sales, "population" = example_population)` is used as example data.
#' @return A Shiny app object.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- plotthis_DensityPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- plotthis_DensityPlotApp(list("cars" = mtcars))
#' if (interactive()) runApp(app2)
plotthis_DensityPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("sales" = example_sales, "population" = example_population)
    }
    createModuleApp(
        inputs_ui_fn = plotthis_DensityPlotInputsUI,
        output_ui_fn = plotthis_DensityPlotOutputUI,
        server_fn    = plotthis_DensityPlotServer,
        data_list    = data_list,
        title        = "Modular DensityPlots"
    )
}
