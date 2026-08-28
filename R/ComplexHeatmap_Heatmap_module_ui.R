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
#' - `scale` - Z-score the matrix by row, column, or not at all (UI: "Scale", default:
#'   "None"). Applied before plotting only — row/column annotation values and the
#'   source-data download always use the unscaled matrix.
#' - `reverse.palette` - Reverse the palette (UI: "Reverse Palette", default: FALSE)
#' - `low_color`, `mid_color`, `high_color` - Colors for the low/mid/high end of the value
#'   scale, i.e. what `col` in [ComplexHeatmap::Heatmap()] is built from via
#'   [circlize::colorRamp2()] (UI: "Low/Mid/High Color", default: blue/white/red)
#' - `min_value`, `mid_value`, `max_value` - Values mapped to `low_color`/`mid_color`/`high_color`
#'   (UI: "Min/Mid/Max Value", default: NA = derived from the matrix: min, `mean(range(mat))`,
#'   and max respectively)
#' - `show_heatmap_legend` - Show the heatmap legend (UI: "Show Legend", default: TRUE)
#' - `border` - Draw heatmap border (UI: "Border", default: FALSE)
#' - `cluster_rows` - Cluster rows (UI: "Cluster Rows", default: TRUE)
#' - `cluster_columns` - Cluster columns (UI: "Cluster Columns", default: TRUE)
#' - `clustering_distance_rows` - Row distance metric (UI: "Row Distance", default: "euclidean")
#' - `clustering_distance_columns` - Column distance metric (UI: "Column Distance", default: "euclidean")
#' - `clustering_method_rows` - Row linkage method (UI: "Row Method", default: "complete")
#' - `clustering_method_columns` - Column linkage method (UI: "Column Method", default: "complete")
#' - `show_row_dend` - Show row dendrogram (UI: "Show Row Dendrogram", default: TRUE)
#' - `show_column_dend` - Show column dendrogram (UI: "Show Column Dendrogram", default: TRUE)
#' - `row_split_by` - Row split method: "None", "K-means", or "Hierarchical" (UI: "Row Split
#'   Method", default: "None"). Only one split mechanism is ever active per axis, which avoids the
#'   error `ComplexHeatmap::Heatmap()` raises when both a k-means and a hierarchical split are
#'   requested at once.
#' - `row_split_n` - Number of row groups, used when `row_split_by` is not "None" (UI: "Row
#'   Groups", default: NA; clamped to the number of matrix rows)
#' - `column_split_by` - Column split method: "None", "K-means", or "Hierarchical" (UI: "Column
#'   Split Method", default: "None")
#' - `column_split_n` - Number of column groups, used when `column_split_by` is not "None" (UI:
#'   "Column Groups", default: NA; clamped to the number of matrix columns)
#' - `row_gap` - Gap between row slices, mm (UI: "Row Gap (mm)", default: 1)
#' - `column_gap` - Gap between column slices, mm (UI: "Column Gap (mm)", default: 1)
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
#' - `row_annotations` - Row annotation tracks, built as [ComplexHeatmap::rowAnnotation()] and
#'   passed as `left_annotation`/`right_annotation` per row (UI: "Annotations" tab, "Row
#'   Annotations" [multiDynamicInput()] — each row picks a `matrix` column and a side, Left or
#'   Right; default: none). Each row's color control appears just below the list once a column is
#'   picked: numeric columns get Low/Mid/High color pickers, everything else gets a
#'   [multiColorPicker()] with one color per level.
#' - `column_key` - Column in `column_annotations` matched against the matrix's selected
#'   column names (UI: "Annotations" tab, "Column Key"; only shown when `data` supplies a
#'   `column_annotations` table)
#' - `column_annotations` - Column annotation tracks, built as
#'   [ComplexHeatmap::columnAnnotation()] and passed as `top_annotation`/`bottom_annotation` per
#'   row (UI: "Annotations" tab, "Column Annotations" [multiDynamicInput()] — each row picks a
#'   column and a side, Top or Bottom, with the same per-row color controls as row annotations;
#'   only shown when `data` supplies a `column_annotations` table; default: none)
#'
#' @section Plot parameters not implemented:
#' The following [ComplexHeatmap::Heatmap()] parameters are not exposed because
#' they require R code, objects, or annotations that do not map cleanly to UI
#' inputs: `cell_fun`, `layer_fun`, `post_fun`, `rect_gp`, `border_gp`,
#' custom `col` mapping functions for the annotation tracks (beyond the Low/Mid/High colors and
#' `multiColorPicker`), `row_order` / `column_order`, `row_labels` / `column_labels`,
#' `jitter`, and all rasterization parameters (`use_raster`, `raster_*`).
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation, *or* a list with a
#'   `matrix` data frame (required) and a `column_annotations` data frame
#'   (optional) — see [ComplexHeatmap_HeatmapServer()]'s `data` parameter for
#'   details. Row-annotation choices come from `matrix`'s columns;
#'   column-annotation choices (and the "Column Annotations" tab controls) only
#'   appear when `column_annotations` is supplied.
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
#' @author Jacob Martin, Jared Andrews
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::organize_inputs()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()],
#' [VizModules::ComplexHeatmap_HeatmapServer()], [VizModules::ComplexHeatmap_HeatmapApp()]
#' @examples
#' library(VizModules)
#' ComplexHeatmap_HeatmapInputsUI("heatmap", example_heatmap_matrix)
ComplexHeatmap_HeatmapInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)
    tip_opts <- list(container = "body")

    if (is.null(defaults)) defaults <- list()

    resolved <- .heatmap_resolve_data(data)
    data <- resolved$matrix
    column.data <- resolved$column_annotations

    num.cols <- names(data)[vapply(data, is.numeric, logical(1))]
    all.cols <- names(data)
    # Character/factor columns are candidate row-name identifiers.
    id.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    # Row-annotation candidates: whatever's left of `matrix` once the initial
    # matrix.cols/rowname.col defaults are set aside. Like matrix.cols/rowname.col
    # themselves, this choice list is fixed at UI-build time and does not
    # live-update if the parent app later swaps in a differently-shaped dataset.
    matrix.cols.default <- get_default(
        defaults, "matrix.cols", num.cols, function(x) all(x %in% num.cols)
    )
    rowname.col.default <- get_default(
        defaults, "rowname.col", "", function(x) x %in% id.choices
    )
    row.annotation.choices <- setdiff(all.cols, c(matrix.cols.default, rowname.col.default))

    # Column-annotation candidates only exist when a column_annotations table
    # was supplied (see .heatmap_resolve_data()).
    column.key.choices <- if (!is.null(column.data)) names(column.data) else character(0)
    column.key.default <- get_default(
        defaults, "column_key",
        if (length(column.key.choices) > 0) column.key.choices[1] else "",
        function(x) x %in% column.key.choices
    )
    column.annotation.choices <- setdiff(column.key.choices, column.key.default)

    dist.choices <- c(
        "euclidean", "maximum", "manhattan", "canberra", "binary",
        "minkowski", "pearson", "spearman", "kendall"
    )
    method.choices <- c(
        "complete", "average", "single", "ward.D", "ward.D2",
        "mcquitty", "median", "centroid"
    )
    split.method.choices <- c("None", "K-means", "Hierarchical")
    scale.choices <- c("None", "Rows", "Columns")

    inputs <- list(
        "Matrix" = tagList(
            tipify(viz_select_input(ns("matrix.cols"), "Matrix Columns",
                choices = num.cols,
                selected = get_default(
                    defaults, "matrix.cols", num.cols,
                    function(x) all(x %in% num.cols)
                ),
                multiple = TRUE,
                # Show a collapsed "N columns shown" summary instead of a tag per
                # selection -- the tag list gets unwieldy once dozens of sample
                # columns are involved. Native virtual-select properties, passed
                # straight through by viz_select_input()'s `...`.
                showValueAsTags = FALSE,
                alwaysShowSelectedOptionsCount = TRUE,
                optionsSelectedText = "columns shown",
                optionSelectedText = "column shown"
            ), "Numeric columns that form the heatmap matrix", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("rowname.col"), "Row Name Column",
                choices = id.choices,
                selected = get_default(
                    defaults, "rowname.col", "",
                    function(x) x %in% id.choices
                )
            ), "Optional column whose values are used as row names", placement = "top", options = tip_opts),
            tipify(textInput(ns("name"), "Heatmap Name",
                value = get_default(defaults, "name", "value")
            ), "Name of the heatmap, used as the legend title", placement = "top", options = tip_opts),
            tipify(colourInput(ns("na_col"), "NA Color",
                value = get_default(defaults, "na_col", "grey")
            ), "Color used for NA cells", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("scale"), "Scale",
                choices = scale.choices,
                selected = get_default(
                    defaults, "scale", "None",
                    function(x) x %in% scale.choices
                )
            ), "Z-score the matrix by row or column before plotting (a constant row/column becomes 0)", placement = "top", options = tip_opts)
        ),
        "Colors" = tagList(
            tipify(colourInput(ns("low_color"), "Low Color",
                value = get_default(defaults, "low_color", .heatmap_default_colors()[1])
            ), "Color for the lowest (or Min Value) end of the scale", placement = "top", options = tip_opts),
            tipify(numericInput(ns("min_value"), "Min Value",
                value = get_default(defaults, "min_value", NA, is.numeric)
            ), "Value mapped to the Low Color (blank = the matrix minimum)", placement = "top", options = tip_opts),
            tipify(colourInput(ns("mid_color"), "Mid Color",
                value = get_default(defaults, "mid_color", .heatmap_default_colors()[2])
            ), "Color for the midpoint of the scale", placement = "top", options = tip_opts),
            tipify(numericInput(ns("mid_value"), "Mid Value",
                value = get_default(defaults, "mid_value", NA, is.numeric)
            ), "Value mapped to the Mid Color (blank = the midpoint between Min and Max Value; set to 0 to center a z-scored matrix)", placement = "top", options = tip_opts),
            tipify(colourInput(ns("high_color"), "High Color",
                value = get_default(defaults, "high_color", .heatmap_default_colors()[3])
            ), "Color for the highest (or Max Value) end of the scale", placement = "top", options = tip_opts),
            tipify(numericInput(ns("max_value"), "Max Value",
                value = get_default(defaults, "max_value", NA, is.numeric)
            ), "Value mapped to the High Color (blank = the matrix maximum)", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("reverse.palette"), "Reverse Palette",
                value = get_default(defaults, "reverse.palette", FALSE, is.logical)
            ), "Reverse the direction of the color scheme", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_heatmap_legend"), "Show Legend",
                value = get_default(defaults, "show_heatmap_legend", TRUE, is.logical)
            ), "Show the heatmap color legend", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("border"), "Border",
                value = get_default(defaults, "border", FALSE, is.logical)
            ), "Draw a border around the heatmap body", placement = "top", options = tip_opts)
        ),
        "Clustering" = tagList(
            tipify(checkboxInput(ns("cluster_rows"), "Cluster Rows",
                value = get_default(defaults, "cluster_rows", TRUE, is.logical)
            ), "Perform hierarchical clustering on rows", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("cluster_columns"), "Cluster Columns",
                value = get_default(defaults, "cluster_columns", TRUE, is.logical)
            ), "Perform hierarchical clustering on columns", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("clustering_distance_rows"), "Row Distance",
                choices = dist.choices,
                selected = get_default(
                    defaults, "clustering_distance_rows", "euclidean",
                    function(x) x %in% dist.choices
                )
            ), "Distance metric for row clustering", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("clustering_distance_columns"), "Column Distance",
                choices = dist.choices,
                selected = get_default(
                    defaults, "clustering_distance_columns", "euclidean",
                    function(x) x %in% dist.choices
                )
            ), "Distance metric for column clustering", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("clustering_method_rows"), "Row Method",
                choices = method.choices,
                selected = get_default(
                    defaults, "clustering_method_rows", "complete",
                    function(x) x %in% method.choices
                )
            ), "Linkage method for row clustering", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("clustering_method_columns"), "Column Method",
                choices = method.choices,
                selected = get_default(
                    defaults, "clustering_method_columns", "complete",
                    function(x) x %in% method.choices
                )
            ), "Linkage method for column clustering", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_row_dend"), "Show Row Dendrogram",
                value = get_default(defaults, "show_row_dend", TRUE, is.logical)
            ), "Show the row dendrogram", placement = "top", options = tip_opts),
            tipify(checkboxInput(ns("show_column_dend"), "Show Column Dendrogram",
                value = get_default(defaults, "show_column_dend", TRUE, is.logical)
            ), "Show the column dendrogram", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("row_split_by"), "Row Split Method",
                choices = split.method.choices,
                selected = get_default(
                    defaults, "row_split_by", "None",
                    function(x) x %in% split.method.choices
                )
            ), "How to split rows into groups: k-means, or hierarchical (cutting the row dendrogram)", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_split_n"), "Row Groups",
                min = 2, step = 1,
                value = get_default(defaults, "row_split_n", NA, is.numeric)
            ), "Number of row groups (used when Row Split Method is not 'None')", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("column_split_by"), "Column Split Method",
                choices = split.method.choices,
                selected = get_default(
                    defaults, "column_split_by", "None",
                    function(x) x %in% split.method.choices
                )
            ), "How to split columns into groups: k-means, or hierarchical (cutting the column dendrogram)", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_split_n"), "Column Groups",
                min = 2, step = 1,
                value = get_default(defaults, "column_split_n", NA, is.numeric)
            ), "Number of column groups (used when Column Split Method is not 'None')", placement = "top", options = tip_opts),
            tipify(numericInput(ns("row_gap"), "Row Gap (mm)",
                min = 0, step = 0.5,
                value = get_default(defaults, "row_gap", 1, is.numeric)
            ), "Gap between row slices in millimeters (used when Row Split Method is not 'None')", placement = "top", options = tip_opts),
            tipify(numericInput(ns("column_gap"), "Column Gap (mm)",
                min = 0, step = 0.5,
                value = get_default(defaults, "column_gap", 1, is.numeric)
            ), "Gap between column slices in millimeters (used when Column Split Method is not 'None')", placement = "top", options = tip_opts)
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
            tipify(viz_select_input(ns("row_names_side"), "Row Names Side",
                choices = c("right", "left"),
                selected = get_default(
                    defaults, "row_names_side", "right",
                    function(x) x %in% c("right", "left")
                )
            ), "Which side to place row names", placement = "top", options = tip_opts),
            tipify(viz_select_input(ns("column_names_side"), "Column Names Side",
                choices = c("bottom", "top"),
                selected = get_default(
                    defaults, "column_names_side", "bottom",
                    function(x) x %in% c("bottom", "top")
                )
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
        "Annotations" = tagList(
            # organize_inputs() gives each *top-level* tagList element here its
            # own grid cell at a fixed max-width of 100%/columns (2, for this
            # module) -- regardless of how many elements a tab ends up with. A
            # multiDynamicInput()/uiOutput() pair must therefore be nested
            # inside one shared tagList() (stacked vertically) rather than
            # listed as two separate top-level elements, or the two can land
            # in different cells (adjacent by luck for a 2-element tab, but
            # visibly split once another element -- "Column Key" -- shifts the
            # count). A fluidRow()/column() split was tried and rejected: it
            # halves an already-halved 50%-wide cell into unusably narrow 25%
            # columns, since organize_inputs()'s width is fixed by `columns`,
            # not by how much content is inside a cell.
            tagList(
                multiDynamicInput(
                    ns("row_annotations"), "Row Annotations",
                    row_spec = list(
                        column = list(type = "select", args = list(choices = row.annotation.choices)),
                        side = list(type = "select", args = list(choices = c("Left", "Right")))
                    ),
                    elements = get_default(defaults, "row_annotations", NULL),
                    max_per_row = 2
                ),
                uiOutput(ns("row_annotation_colors_ui"))
            ),
            if (!is.null(column.data)) {
                tagList(
                    tipify(viz_select_input(ns("column_key"), "Column Key",
                        choices = column.key.choices,
                        selected = column.key.default
                    ), "Column in the column-annotation table that matches the heatmap's sample column names", placement = "top", options = tip_opts),
                    multiDynamicInput(
                        ns("column_annotations"), "Column Annotations",
                        row_spec = list(
                            column = list(type = "select", args = list(choices = column.annotation.choices)),
                            side = list(type = "select", args = list(choices = c("Top", "Bottom")))
                        ),
                        elements = get_default(defaults, "column_annotations", NULL),
                        max_per_row = 2
                    ),
                    uiOutput(ns("column_annotation_colors_ui"))
                )
            } else {
                helpText(
                    "Supply data as list(matrix = ..., column_annotations = ...) to ",
                    "enable column annotations."
                )
            }
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
#' This renders the original heatmap, the selected sub-heatmap, and the
#' click/brush info panel together as one widget, arranged per `layout` (see
#' [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()] for the
#' available layout strings, e.g. `"(1-2)|3"`, `"1|(2-3)"`, `"1-2-3"`).
#'
#' Pass `compact = TRUE` for a smaller footprint (see the
#' \href{https://jokergoo.github.io/InteractiveComplexHeatmap/articles/shiny_dev.html#compact-mode}{"Compact
#' mode" article section}): the sub-heatmap panel is dropped entirely and the
#' click/brush info floats near the cursor instead of occupying its own static
#' area — equivalent to `response = c(action, "brush-output"), output_ui_float
#' = TRUE`, per [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()]'s
#' own docs. `layout` has nothing left to arrange in compact mode, since only
#' one static panel remains. No server-side change is needed to turn compact
#' mode on or off.
#'
#' To place the three components independently anywhere in a custom UI
#' (separate tabs, cards, columns, etc.), use [ComplexHeatmap_HeatmapMainOutputUI()],
#' [ComplexHeatmap_HeatmapSubOutputUI()], and [ComplexHeatmap_HeatmapInfoOutputUI()]
#' instead of this function. Use one approach or the other, not both, for the
#' same module `id`. Compact mode is specific to this combined widget: the
#' separated pieces (`originalHeatmapOutput()`, `subHeatmapOutput()`,
#' `HeatmapInfoOutput()`, which back the three functions above) don't accept a
#' `compact` argument at all.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; accepted for signature parity with the other module
#'   output functions but ignored, since the InteractiveComplexHeatmap widget
#'   manages its own sizing.
#' @param ... Additional arguments passed to
#'   [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()], e.g.
#'   `layout`, `compact`, `width1`/`height1`, `title1`/`title2`/`title3`.
#'
#' @return A Shiny UI object for the interactive heatmap.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()],
#' [ComplexHeatmap_HeatmapMainOutputUI()], [ComplexHeatmap_HeatmapSubOutputUI()],
#' [ComplexHeatmap_HeatmapInfoOutputUI()]
#' @examples
#' library(VizModules)
#' # Default combined widget:
#' ComplexHeatmap_HeatmapOutputUI("heatmap")
#' # Same widget, main heatmap on its own row above sub-heatmap + info:
#' ComplexHeatmap_HeatmapOutputUI("heatmap", layout = "1|(2-3)")
#' # Compact: no sub-heatmap panel, click/brush info floats near the cursor
#' ComplexHeatmap_HeatmapOutputUI("heatmap", compact = TRUE)
ComplexHeatmap_HeatmapOutputUI <- function(id, resizable = TRUE, ...) {
    ns <- NS(id)
    if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'InteractiveComplexHeatmap' package is required for the ",
            "ComplexHeatmap module. Install it with ",
            "BiocManager::install('InteractiveComplexHeatmap')."
        )
    }
    InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput(ns("Heatmap"), ...)
}


#' Main heatmap output UI component for the ComplexHeatmap module
#'
#' Renders *only* the original (main) interactive heatmap panel, via
#' [InteractiveComplexHeatmap::originalHeatmapOutput()]. Use this together with
#' [ComplexHeatmap_HeatmapSubOutputUI()] and/or [ComplexHeatmap_HeatmapInfoOutputUI()]
#' to place the three interactive components independently in a custom layout,
#' instead of [ComplexHeatmap_HeatmapOutputUI()]'s single combined widget. All
#' pieces used for one heatmap must share the same module `id` as the
#' [ComplexHeatmap_HeatmapServer()] call — no server-side changes are needed to
#' switch between the combined and separated forms.
#'
#' @param id The ID for the Shiny module. Must match the `id` used for
#'   [ComplexHeatmap_HeatmapServer()] and any other output pieces for the same
#'   heatmap.
#' @param title Optional panel title. `NULL` (the default) omits the title.
#' @param width,height Panel dimensions in pixels.
#' @param ... Additional arguments passed to
#'   [InteractiveComplexHeatmap::originalHeatmapOutput()], e.g. `action`,
#'   `response`, `brush_opt`.
#'
#' @return A Shiny UI object for the main interactive heatmap panel.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
#' @seealso [InteractiveComplexHeatmap::originalHeatmapOutput()],
#' [ComplexHeatmap_HeatmapOutputUI()], [ComplexHeatmap_HeatmapSubOutputUI()],
#' [ComplexHeatmap_HeatmapInfoOutputUI()]
#' @examples
#' library(VizModules)
#' ComplexHeatmap_HeatmapMainOutputUI("heatmap", title = "Heatmap")
ComplexHeatmap_HeatmapMainOutputUI <- function(id, title = NULL, width = 450, height = 350, ...) {
    ns <- NS(id)
    if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'InteractiveComplexHeatmap' package is required for the ",
            "ComplexHeatmap module. Install it with ",
            "BiocManager::install('InteractiveComplexHeatmap')."
        )
    }
    InteractiveComplexHeatmap::originalHeatmapOutput(
        ns("Heatmap"),
        title = title, width = width, height = height, ...
    )
}


#' Sub-heatmap output UI component for the ComplexHeatmap module
#'
#' Renders *only* the selected sub-heatmap panel (the zoomed-in view of a
#' brushed/selected region), via [InteractiveComplexHeatmap::subHeatmapOutput()].
#' See [ComplexHeatmap_HeatmapMainOutputUI()] for how the separated output
#' pieces fit together.
#'
#' @param id The ID for the Shiny module. Must match the `id` used for
#'   [ComplexHeatmap_HeatmapServer()] and any other output pieces for the same
#'   heatmap.
#' @param title Optional panel title. `NULL` (the default) omits the title.
#' @param width,height Panel dimensions in pixels.
#' @param ... Additional arguments passed to
#'   [InteractiveComplexHeatmap::subHeatmapOutput()].
#'
#' @return A Shiny UI object for the sub-heatmap panel.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
#' @seealso [InteractiveComplexHeatmap::subHeatmapOutput()],
#' [ComplexHeatmap_HeatmapOutputUI()], [ComplexHeatmap_HeatmapMainOutputUI()],
#' [ComplexHeatmap_HeatmapInfoOutputUI()]
#' @examples
#' library(VizModules)
#' ComplexHeatmap_HeatmapSubOutputUI("heatmap", title = "Selected region")
ComplexHeatmap_HeatmapSubOutputUI <- function(id, title = NULL, width = 400, height = 350, ...) {
    ns <- NS(id)
    if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'InteractiveComplexHeatmap' package is required for the ",
            "ComplexHeatmap module. Install it with ",
            "BiocManager::install('InteractiveComplexHeatmap')."
        )
    }
    InteractiveComplexHeatmap::subHeatmapOutput(
        ns("Heatmap"),
        title = title, width = width, height = height, ...
    )
}


#' Click/brush info output UI component for the ComplexHeatmap module
#'
#' Renders *only* the output panel showing information about the clicked or
#' brushed cell(s) (e.g. row/column names and value), via
#' [InteractiveComplexHeatmap::HeatmapInfoOutput()]. See
#' [ComplexHeatmap_HeatmapMainOutputUI()] for how the separated output pieces
#' fit together.
#'
#' @param id The ID for the Shiny module. Must match the `id` used for
#'   [ComplexHeatmap_HeatmapServer()] and any other output pieces for the same
#'   heatmap.
#' @param title Optional panel title. `NULL` (the default) omits the title.
#' @param width Panel width in pixels.
#' @param ... Additional arguments passed to
#'   [InteractiveComplexHeatmap::HeatmapInfoOutput()].
#'
#' @return A Shiny UI object for the click/brush info panel.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
#' @seealso [InteractiveComplexHeatmap::HeatmapInfoOutput()],
#' [ComplexHeatmap_HeatmapOutputUI()], [ComplexHeatmap_HeatmapMainOutputUI()],
#' [ComplexHeatmap_HeatmapSubOutputUI()]
#' @examples
#' library(VizModules)
#' ComplexHeatmap_HeatmapInfoOutputUI("heatmap", title = "Details")
ComplexHeatmap_HeatmapInfoOutputUI <- function(id, title = NULL, width = 400, ...) {
    ns <- NS(id)
    if (!requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
        stop(
            "The 'InteractiveComplexHeatmap' package is required for the ",
            "ComplexHeatmap module. Install it with ",
            "BiocManager::install('InteractiveComplexHeatmap')."
        )
    }
    InteractiveComplexHeatmap::HeatmapInfoOutput(
        ns("Heatmap"),
        title = title, width = width, ...
    )
}
