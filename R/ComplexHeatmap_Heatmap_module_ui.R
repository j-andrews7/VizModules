#' Input UI components for the ComplexHeatmap module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `ComplexHeatmap_HeatmapServer()` and
#' `ComplexHeatmap_HeatmapOutputUI()` functions.
#'
#' @details Unlike the other plotly-based modules, this module wraps
#' [ComplexHeatmap::Heatmap()] and renders its interactive output via the
#' \pkg{InteractiveComplexHeatmap} package. The incoming data frame is converted
#' to a numeric matrix (see the Data / Matrix tab) before being passed to
#' `Heatmap()`.
#'
#' The inputs are organized into a grid via [organize_inputs()], with `columns`
#' controlling the number of columns in the grid. Defaults for each input can be
#' supplied via the `defaults` argument (see [get_default()]).
#'
#' @section Plot parameters and defaults:
#' The following [ComplexHeatmap::Heatmap()] parameters can be accessed via UI
#' inputs and/or the `defaults` argument:
#'
#' - `matrix.cols` - Numeric columns forming the matrix (UI: "Matrix Columns",
#'   default: all numeric columns)
#' - `rowname.col` - Column used as row names (UI: "Row Name Column", default: "")
#' - `name` - Heatmap / legend title (UI: "Heatmap Name", default: "value")
#' - `na_col` - Color for `NA` cells (UI: "NA Color", default: "grey")
#' - `palette` - Continuous color scheme (UI: "Color Scheme", default: "Blue-White-Red")
#' - `reverse.palette` - Reverse the palette (UI: "Reverse Palette", default: FALSE)
#' - `show_heatmap_legend` - Show the heatmap legend (UI: "Show Legend", default: TRUE)
#' - `cluster_rows` - Cluster rows (UI: "Cluster Rows", default: TRUE)
#' - `cluster_columns` - Cluster columns (UI: "Cluster Columns", default: TRUE)
#' - `clustering_distance_rows` - Row distance metric (UI: "Row Distance", default: "euclidean")
#' - `clustering_distance_columns` - Column distance metric (UI: "Column Distance", default: "euclidean")
#' - `clustering_method_rows` - Row linkage method (UI: "Row Method", default: "complete")
#' - `clustering_method_columns` - Column linkage method (UI: "Column Method", default: "complete")
#' - `show_row_dend` - Show row dendrogram (UI: "Show Row Dendrogram", default: TRUE)
#' - `show_column_dend` - Show column dendrogram (UI: "Show Column Dendrogram", default: TRUE)
#' - `row_km` - k-means row split (UI: "Row k-means", default: 1)
#' - `column_km` - k-means column split (UI: "Column k-means", default: 1)
#' - `row_title` - Row title (UI: "Row Title", default: "")
#' - `column_title` - Column title (UI: "Column Title", default: "")
#' - `show_row_names` - Show row names (UI: "Show Row Names", default: TRUE)
#' - `show_column_names` - Show column names (UI: "Show Column Names", default: TRUE)
#' - `row_names_side` - Row names side (UI: "Row Names Side", default: "right")
#' - `column_names_side` - Column names side (UI: "Column Names Side", default: "bottom")
#' - `column_names_rot` - Column name rotation (UI: "Column Name Rotation", default: 90)
#' - `row_names_fontsize` - Row name font size (UI: "Row Name Size", default: 12)
#' - `column_names_fontsize` - Column name font size (UI: "Column Name Size", default: 12)
#' - `title_fontsize` - Row/column title font size (UI: "Title Size", default: 13.2)
#' - `border` - Draw heatmap border (UI: "Border", default: FALSE)
#' - `row_split` - Number of row slices (UI: "Row Split", default: NA)
#' - `column_split` - Number of column slices (UI: "Column Split", default: NA)
#' - `row_gap` - Gap between row slices, mm (UI: "Row Gap (mm)", default: 1)
#' - `column_gap` - Gap between column slices, mm (UI: "Column Gap (mm)", default: 1)
#'
#' @section Plot parameters not implemented:
#' The following [ComplexHeatmap::Heatmap()] parameters are not exposed because
#' they require R code, objects, or annotations that do not map cleanly to UI
#' inputs: `cell_fun`, `layer_fun`, `post_fun`, `rect_gp`, `border_gp`,
#' `top_annotation`, `bottom_annotation`, `left_annotation`, `right_annotation`,
#' custom `col` mapping functions (beyond the palette selector), `row_order` /
#' `column_order`, `row_labels` / `column_labels`, `jitter`, and all
#' rasterization parameters (`use_raster`, `raster_*`). Annotation support may be
#' added in a future release.
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs. An entry may also be a
#'   [shiny::reactive()] or [shiny::reactiveVal()]; it is resolved with [shiny::isolate()] to
#'   seed the control, and the module then keeps it live (see [setup_reactive_defaults()]).
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements.
#'
#' @import shiny
#' @importFrom colourpicker colourInput
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::organize_inputs()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()],
#' [VizModules::ComplexHeatmap_HeatmapServer()], [VizModules::ComplexHeatmap_HeatmapApp()]
#' @examples
#' library(VizModules)
#' ComplexHeatmap_HeatmapInputsUI("heatmap", example_matrix_df)
ComplexHeatmap_HeatmapInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)
    tip_opts <- list(container = "body")

    if (is.null(defaults)) defaults <- list()

    num.cols <- names(data)[vapply(data, is.numeric, logical(1))]
    all.cols <- names(data)
    # Character/factor columns are candidate row-name identifiers.
    id.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    dist.choices <- c(
        "euclidean", "maximum", "manhattan", "canberra", "binary",
        "minkowski", "pearson", "spearman", "kendall"
    )
    method.choices <- c(
        "complete", "average", "single", "ward.D", "ward.D2",
        "mcquitty", "median", "centroid"
    )
    palette.choices <- c(
        "Blue-White-Red", "Green-Black-Red", "Purple-White-Orange",
        "Viridis", "Magma"
    )

    inputs <- list(
        "Matrix" = tagList(
            tipify(selectizeInput(ns("matrix.cols"), "Matrix Columns",
                choices = num.cols,
                selected = get_default(
                    defaults, "matrix.cols", num.cols,
                    function(x) all(x %in% num.cols)
                ),
                multiple = TRUE
            ), "Numeric columns that form the heatmap matrix", placement = "top", options = tip_opts),
            tipify(selectInput(ns("rowname.col"), "Row Name Column",
                choices = id.choices,
                selected = get_default(
                    defaults, "rowname.col", "",
                    function(x) x %in% id.choices
                ), selectize = FALSE
            ), "Optional column whose values are used as row names", placement = "top", options = tip_opts),
            tipify(textInput(ns("name"), "Heatmap Name",
                value = get_default(defaults, "name", "value")
            ), "Name of the heatmap, used as the legend title", placement = "top", options = tip_opts),
            tipify(colourInput(ns("na_col"), "NA Color",
                value = get_default(defaults, "na_col", "grey")
            ), "Color used for NA cells", placement = "top", options = tip_opts)
        ),
        "Colors" = tagList(
            tipify(selectInput(ns("palette"), "Color Scheme",
                choices = palette.choices,
                selected = get_default(
                    defaults, "palette", "Blue-White-Red",
                    function(x) x %in% palette.choices
                ), selectize = FALSE
            ), "Continuous color scheme for the matrix", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("reverse.palette"), "Reverse Palette",
                value = get_default(defaults, "reverse.palette", FALSE, is.logical)
            ), "Reverse the direction of the color scheme", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_heatmap_legend"), "Show Legend",
                value = get_default(defaults, "show_heatmap_legend", TRUE, is.logical)
            ), "Show the heatmap color legend", placement = "top", options = tip_opts)
        ),
        "Clustering" = tagList(
            tipify(checkboxInput(ns("cluster_rows"), "Cluster Rows",
                value = get_default(defaults, "cluster_rows", TRUE, is.logical)
            ), "Perform hierarchical clustering on rows", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("cluster_columns"), "Cluster Columns",
                value = get_default(defaults, "cluster_columns", TRUE, is.logical)
            ), "Perform hierarchical clustering on columns", placement = "top", options = tip_opts),
            tipify(selectInput(ns("clustering_distance_rows"), "Row Distance",
                choices = dist.choices,
                selected = get_default(
                    defaults, "clustering_distance_rows", "euclidean",
                    function(x) x %in% dist.choices
                ), selectize = FALSE
            ), "Distance metric for row clustering", placement = "top", options = tip_opts),
            tipify(selectInput(ns("clustering_distance_columns"), "Column Distance",
                choices = dist.choices,
                selected = get_default(
                    defaults, "clustering_distance_columns", "euclidean",
                    function(x) x %in% dist.choices
                ), selectize = FALSE
            ), "Distance metric for column clustering", placement = "top", options = tip_opts),
            tipify(selectInput(ns("clustering_method_rows"), "Row Method",
                choices = method.choices,
                selected = get_default(
                    defaults, "clustering_method_rows", "complete",
                    function(x) x %in% method.choices
                ), selectize = FALSE
            ), "Linkage method for row clustering", placement = "top", options = tip_opts),
            tipify(selectInput(ns("clustering_method_columns"), "Column Method",
                choices = method.choices,
                selected = get_default(
                    defaults, "clustering_method_columns", "complete",
                    function(x) x %in% method.choices
                ), selectize = FALSE
            ), "Linkage method for column clustering", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_row_dend"), "Show Row Dendrogram",
                value = get_default(defaults, "show_row_dend", TRUE, is.logical)
            ), "Show the row dendrogram", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_column_dend"), "Show Column Dendrogram",
                value = get_default(defaults, "show_column_dend", TRUE, is.logical)
            ), "Show the column dendrogram", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_km"), "Row k-means",
                min = 1, step = 1,
                value = get_default(defaults, "row_km", 1, is.numeric)
            ), "Split rows into this many k-means groups (>= 1)", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_km"), "Column k-means",
                min = 1, step = 1,
                value = get_default(defaults, "column_km", 1, is.numeric)
            ), "Split columns into this many k-means groups (>= 1)", placement = "top", options = tip_opts)
        ),
        "Labels" = tagList(
            tipify(textInput(ns("row_title"), "Row Title",
                value = get_default(defaults, "row_title", "")
            ), "Title placed alongside the rows", placement = "top", options = tip_opts),
            tipify(textInput(ns("column_title"), "Column Title",
                value = get_default(defaults, "column_title", "")
            ), "Title placed alongside the columns", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_row_names"), "Show Row Names",
                value = get_default(defaults, "show_row_names", TRUE, is.logical)
            ), "Show row names", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_column_names"), "Show Column Names",
                value = get_default(defaults, "show_column_names", TRUE, is.logical)
            ), "Show column names", placement = "top", options = tip_opts),
            tipify(selectInput(ns("row_names_side"), "Row Names Side",
                choices = c("right", "left"),
                selected = get_default(
                    defaults, "row_names_side", "right",
                    function(x) x %in% c("right", "left")
                ), selectize = FALSE
            ), "Which side to place row names", placement = "top", options = tip_opts),
            tipify(selectInput(ns("column_names_side"), "Column Names Side",
                choices = c("bottom", "top"),
                selected = get_default(
                    defaults, "column_names_side", "bottom",
                    function(x) x %in% c("bottom", "top")
                ), selectize = FALSE
            ), "Which side to place column names", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_names_rot"), "Column Name Rotation",
                step = 15,
                value = get_default(defaults, "column_names_rot", 90, is.numeric)
            ), "Rotation angle for column names", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_names_fontsize"), "Row Name Size",
                min = 1, step = 0.5,
                value = get_default(defaults, "row_names_fontsize", 12, is.numeric)
            ), "Font size for row names", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_names_fontsize"), "Column Name Size",
                min = 1, step = 0.5,
                value = get_default(defaults, "column_names_fontsize", 12, is.numeric)
            ), "Font size for column names", placement = "top", options = tip_opts),
            tipify(numericInput(ns("title_fontsize"), "Title Size",
                min = 1, step = 0.5,
                value = get_default(defaults, "title_fontsize", 13.2, is.numeric)
            ), "Font size for row and column titles", placement = "top", options = tip_opts)
        ),
        "Body" = tagList(
            tipify(checkboxInput(ns("border"), "Border",
                value = get_default(defaults, "border", FALSE, is.logical)
            ), "Draw a border around the heatmap body", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_split"), "Row Split",
                min = 2, step = 1,
                value = get_default(defaults, "row_split", NA, is.numeric)
            ), "Split rows into this many slices (2 or more; leave blank for none)", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_split"), "Column Split",
                min = 2, step = 1,
                value = get_default(defaults, "column_split", NA, is.numeric)
            ), "Split columns into this many slices (2 or more; leave blank for none)", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_gap"), "Row Gap (mm)",
                min = 0, step = 0.5,
                value = get_default(defaults, "row_gap", 1, is.numeric)
            ), "Gap between row slices in millimeters", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_gap"), "Column Gap (mm)",
                min = 0, step = 0.5,
                value = get_default(defaults, "column_gap", 1, is.numeric)
            ), "Gap between column slices in millimeters", placement = "top", options = tip_opts)
        )
    )

    organize_inputs(
        inputs,
        id = ns("HeatmapTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the ComplexHeatmap module
#'
#' This should be placed in the UI where the heatmap should be shown. Unlike the
#' plotly modules, the interactive output is provided by
#' [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()], which supplies
#' its own resize and export controls.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; accepted for signature parity with the other module
#'   output functions but ignored, since the InteractiveComplexHeatmap widget
#'   manages its own sizing.
#'
#' @return A Shiny UI object for the interactive heatmap.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
#' @seealso [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()]
ComplexHeatmap_HeatmapOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'InteractiveComplexHeatmap' package is required for the ",
            "ComplexHeatmap module. Install it with ",
            "BiocManager::install('InteractiveComplexHeatmap')."
        )
    }
    InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput(ns("Heatmap"))
}
