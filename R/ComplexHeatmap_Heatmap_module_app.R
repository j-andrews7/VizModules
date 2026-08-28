#' Create an example Modular ComplexHeatmap Shiny Application
#'
#' This function generates a Shiny application with modular
#' [ComplexHeatmap::Heatmap()] components rendered interactively via
#' \pkg{InteractiveComplexHeatmap}. The app features a **Data Import** section for
#' uploading data, a **Data Table** for filtering the active dataset, and a
#' **Plot** area for configuring and displaying the interactive heatmap.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_heatmap_matrix` (a simulated gene x sample expression matrix) as an
#' example dataset. Uploaded
#' data files are added to the available datasets and can be selected for
#' plotting. If an uploaded file shares a name with an existing dataset, the
#' existing one is overwritten with a warning.
#'
#' Unlike the other modules, this one depends on the Bioconductor packages
#' \pkg{ComplexHeatmap}, \pkg{InteractiveComplexHeatmap}, and \pkg{circlize},
#' which must be installed (e.g. via `BiocManager::install()`).
#'
#' This is a convenience wrapper around [createModuleApp()] — *except* when
#' `column_data` is supplied (see below), which needs a small bespoke app
#' instead, since [createModuleApp()] always hands the module server a single
#' data frame and can't carry the two-table `list(matrix = ,
#' column_annotations = )` shape the module's column-annotation feature needs
#' (see [ComplexHeatmap_HeatmapServer()]'s `data` parameter).
#'
#' @param data_list An optional named list of data frames. If `NULL` (the
#'   default), `list("matrix" = example_heatmap_matrix)` is used as example data.
#'   Ignored (only its first element is used, as the matrix) when `column_data`
#'   is supplied — that path has no dataset picker/upload/filter UI.
#' @param column_data An optional data frame of per-sample metadata, enabling
#'   column annotations (see [ComplexHeatmap_HeatmapServer()]'s `data`
#'   parameter for the expected shape — a key column matching the matrix's
#'   column names, plus arbitrary annotation columns). When supplied, the app
#'   is a minimal single-dataset `shinyApp()` (no Data Import/Data Table
#'   sections) wiring `data = list(matrix = <first element of data_list, or
#'   example_heatmap_matrix>, column_annotations = column_data)` directly into
#'   the module.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are
#'   still initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   are still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()], [VizModules::ComplexHeatmap_HeatmapServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data (row annotations only):
#' app <- ComplexHeatmap_HeatmapApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Launch with column annotations too:
#' app2 <- ComplexHeatmap_HeatmapApp(column_data = example_heatmap_column_data)
#' if (interactive()) shiny::runApp(app2)
ComplexHeatmap_HeatmapApp <- function(data_list = NULL, column_data = NULL, defaults = NULL,
                                      hide.inputs = NULL, hide.tabs = NULL) {
    missing_pkgs <- Filter(
        function(pkg) !requireNamespace(pkg, quietly = TRUE),
        c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize")
    )
    if (length(missing_pkgs) > 0) {
        stop(
            "The ComplexHeatmap module requires the following Bioconductor ",
            "package(s), which are not installed: ",
            paste(missing_pkgs, collapse = ", "), ". Install them with ",
            "BiocManager::install(c(",
            paste(sprintf("'%s'", missing_pkgs), collapse = ", "), ")).",
            call. = FALSE
        )
    }

    # matrix.cols defaults to *every* numeric column, which would sweep
    # example_heatmap_matrix's mean_expression row-annotation column into the
    # heatmap body itself. Point the bundled example at just the sample
    # columns so mean_expression stays available as a row annotation; a
    # caller-supplied data_list/defaults is left alone.
    example_defaults <- function(matrix_df) {
        if (!identical(matrix_df, example_heatmap_matrix)) {
            return(list())
        }
        list(
            matrix.cols = setdiff(names(example_heatmap_matrix), c("gene", "pathway", "mean_expression")),
            rowname.col = "gene"
        )
    }

    if (!is.null(column_data)) {
        matrix_df <- if (is.null(data_list)) example_heatmap_matrix else data_list[[1]]
        heatmap_data <- list(matrix = matrix_df, column_annotations = column_data)
        defaults <- utils::modifyList(example_defaults(matrix_df), defaults %||% list())

        ui <- fluidPage(
            title = "Modular ComplexHeatmap",
            useShinyjs(),
            sidebarLayout(
                sidebarPanel(
                    ComplexHeatmap_HeatmapInputsUI(
                        "active_plot", heatmap_data,
                        title = h3("Heatmap Settings"), defaults = defaults
                    )
                ),
                mainPanel(
                    ComplexHeatmap_HeatmapOutputUI("active_plot", compact = TRUE)
                )
            )
        )

        server <- function(input, output, session) {
            ComplexHeatmap_HeatmapServer(
                "active_plot",
                data = reactive(heatmap_data),
                hide.inputs = hide.inputs, hide.tabs = hide.tabs, defaults = defaults
            )
        }

        return(shinyApp(ui, server))
    }

    if (is.null(data_list)) {
        data_list <- list("matrix" = example_heatmap_matrix)
    }
    defaults <- utils::modifyList(example_defaults(data_list[[1]]), defaults %||% list())
    createModuleApp(
        inputs_ui_fn  = ComplexHeatmap_HeatmapInputsUI,
        output_ui_fn  = ComplexHeatmap_HeatmapOutputUI,
        server_fn     = ComplexHeatmap_HeatmapServer,
        data_list     = data_list,
        defaults      = defaults,
        hide.inputs   = hide.inputs,
        hide.tabs     = hide.tabs,
        title         = "Modular ComplexHeatmap"
    )
}
