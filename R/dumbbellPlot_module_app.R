#' Create a Shiny App for Dumbbell Plots
#'
#' This function generates a Shiny application for interactive dumbbell plots.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive dumbbell plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_school_earnings` as an example dataset.
#' Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("school_earnings" = example_school_earnings)`
#'   is used as example data.
#' @return A Shiny app object.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::dumbbellPlot()], [VizModules::dumbbellPlotInputsUI()],
#' [VizModules::dumbbellPlotOutputUI()], [VizModules::dumbbellPlotServer()]
#'
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- dumbbellPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' data <- data.frame(
#'     School = c("MIT", "Stanford", "Harvard"),
#'     Women = c(94, 96, 112),
#'     Men = c(152, 151, 165),
#'     Group = c("A", "B", "A")
#' )
#' app2 <- dumbbellPlotApp(list("School Earnings" = data))
#' if (interactive()) runApp(app2)
dumbbellPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list(
            "school_earnings" = example_school_earnings
        )
    }
    createModuleApp(
        inputs_ui_fn = dumbbellPlotInputsUI,
        output_ui_fn = dumbbellPlotOutputUI,
        server_fn    = dumbbellPlotServer,
        data_list    = data_list,
        title        = "Modular dumbbellPlots"
    )
}
