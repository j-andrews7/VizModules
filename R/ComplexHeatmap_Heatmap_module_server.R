#' Server logic for the ComplexHeatmap module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide. These will still
#'   be initialized and their values used, but the user will not be able to
#'   see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   will still be initialized and used, but not shown in the UI.
#' @param defaults A named list of default values for the inputs. When the reset
#'   button is clicked, inputs are reset to these values rather than hardcoded
#'   fallbacks. Typically the same list passed to the UI function.
#'
#' @return The `moduleServer` function for the ComplexHeatmap module. The
#'   returned reactive yields the source-download bundle (matrix data + inputs).
#'
#' @details The incoming data frame is converted to a numeric matrix using the
#'   selected matrix columns (and optional row-name column). The heatmap is built
#'   with [ComplexHeatmap::Heatmap()] and registered for interactivity with
#'   [InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()], which draws it
#'   onto its own device to capture the interactive widget.
#'
#'   Both \pkg{ComplexHeatmap} and \pkg{InteractiveComplexHeatmap} are
#'   Bioconductor packages and are only required at runtime for this module; they
#'   are guarded with [requireNamespace()].
#'
#' @import shiny
#' @importFrom shinyjs delay
#'
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()], [VizModules::ComplexHeatmap_HeatmapApp()]
#'
#' @export
#' @author Jacob Martin
ComplexHeatmap_HeatmapServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    for (pkg in c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize")) {
        if (!requireNamespace(pkg, quietly = TRUE)) {
            stop(
                "The '", pkg, "' package is required for the ComplexHeatmap module. ",
                "Install it with BiocManager::install('", pkg, "')."
            )
        }
    }

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # Hide individual inputs/tabs if specified. UI is (re)injected by the
        # parent app, so hiding is (re)applied after the controls exist.
        if (!is.null(hide.inputs) || !is.null(hide.tabs)) {
            observeEvent(data(), {
                delay(100, {
                    .hide_input(session, hide.inputs)
                    for (tab.name in hide.tabs) hideTab(inputId = "HeatmapTabsetPanel", target = tab.name)
                })
            })
        }

        # Map palette name -> vector of colors interpolated by circlize::colorRamp2.
        palette_colors <- function(name) {
            switch(name,
                "Blue-White-Red" = c("#2166AC", "#F7F7F7", "#B2182B"),
                "Green-Black-Red" = c("green", "black", "red"),
                "Purple-White-Orange" = c("#762A83", "#F7F7F7", "#E08214"),
                "Viridis" = c("#440154", "#21908C", "#FDE725"),
                "Magma" = c("#000004", "#B63679", "#FCFDBF"),
                c("#2166AC", "#F7F7F7", "#B2182B")
            )
        }

        # Convert the incoming data frame to a numeric matrix per the selected
        # columns, applying the optional row-name column. Surfaces friendly
        # validation messages on bad input.
        heatmap_matrix <- reactive({
            df <- data()
            req(df)

            cols <- input$matrix.cols
            validate(need(
                !is.null(cols) && length(cols) >= 1,
                "Select at least one numeric column for the matrix."
            ))
            validate(need(
                all(cols %in% names(df)),
                "One or more selected matrix columns are not in the data."
            ))

            mat <- as.matrix(df[, cols, drop = FALSE])
            validate(need(
                is.numeric(mat),
                "The selected matrix columns must all be numeric."
            ))

            rn.col <- input$rowname.col
            if (!is.null(rn.col) && nzchar(rn.col) && rn.col %in% names(df)) {
                rownames(mat) <- make.unique(as.character(df[[rn.col]]))
            }

            # Guard against clustering failures on all-NA or zero-variance rows.
            validate(need(
                any(!is.na(mat)),
                "The matrix is entirely NA; nothing to plot."
            ))

            mat
        })

        # Build (and draw) the Heatmap object from the current inputs.
        build_heatmap <- reactive({
            isolate_fn <- setup_auto_update_logic(input)
            mat <- heatmap_matrix()

            col_fun <- circlize::colorRamp2(
                seq(min(mat, na.rm = TRUE), max(mat, na.rm = TRUE), length.out = 3),
                {
                    cols <- palette_colors(isolate_fn(input$palette))
                    if (isTRUE(isolate_fn(input$reverse.palette))) rev(cols) else cols
                }
            )

            row_km <- isolate_fn(input$row_km)
            column_km <- isolate_fn(input$column_km)
            row_split <- isolate_fn(input$row_split)
            column_split <- isolate_fn(input$column_split)

            ht <- ComplexHeatmap::Heatmap(
                matrix = mat,
                name = isolate_fn(input$name),
                col = col_fun,
                na_col = isolate_fn(input$na_col),
                show_heatmap_legend = isolate_fn(input$show_heatmap_legend),
                border = isolate_fn(input$border),
                cluster_rows = isolate_fn(input$cluster_rows),
                cluster_columns = isolate_fn(input$cluster_columns),
                clustering_distance_rows = isolate_fn(input$clustering_distance_rows),
                clustering_distance_columns = isolate_fn(input$clustering_distance_columns),
                clustering_method_rows = isolate_fn(input$clustering_method_rows),
                clustering_method_columns = isolate_fn(input$clustering_method_columns),
                show_row_dend = isolate_fn(input$show_row_dend),
                show_column_dend = isolate_fn(input$show_column_dend),
                row_km = if (is.na(row_km)) 1 else max(1, as.integer(row_km)),
                column_km = if (is.na(column_km)) 1 else max(1, as.integer(column_km)),
                row_split = if (is.na(row_split)) NULL else as.integer(row_split),
                column_split = if (is.na(column_split)) NULL else as.integer(column_split),
                row_gap = grid::unit(isolate_fn(input$row_gap), "mm"),
                column_gap = grid::unit(isolate_fn(input$column_gap), "mm"),
                row_title = isolate_fn(input$row_title),
                column_title = isolate_fn(input$column_title),
                show_row_names = isolate_fn(input$show_row_names),
                show_column_names = isolate_fn(input$show_column_names),
                row_names_side = isolate_fn(input$row_names_side),
                column_names_side = isolate_fn(input$column_names_side),
                column_names_rot = isolate_fn(input$column_names_rot),
                row_names_gp = grid::gpar(fontsize = isolate_fn(input$row_names_fontsize)),
                column_names_gp = grid::gpar(fontsize = isolate_fn(input$column_names_fontsize)),
                row_title_gp = grid::gpar(fontsize = isolate_fn(input$title_fontsize)),
                column_title_gp = grid::gpar(fontsize = isolate_fn(input$title_fontsize))
            )

            # The interactive widget needs a *drawn* heatmap (HeatmapList) to
            # measure cell positions. Draw it onto a throwaway device so the
            # heatmap does not also appear in the R session's plot pane, then
            # return the drawn object. (Passing an un-drawn Heatmap can leave the
            # widget's render stalled on "Making heatmap, please wait...".)
            grDevices::pdf(NULL)
            on.exit(grDevices::dev.off(), add = TRUE)
            ComplexHeatmap::draw(ht)
        })

        # makeInteractiveComplexHeatmap() uses `heatmap_id` verbatim as the
        # output slot name and in session/input message keys (see the package
        # source: output[[qq("@{heatmap_id}_heatmap")]], input[[qq(...)]],
        # session$sendCustomMessage(qq("@{heatmap_id}_..."))). It was written for
        # a top-level server, not moduleServer: a module's `output` auto-prefixes
        # the namespace to keys (double-namespacing), while `input` and
        # `sendCustomMessage` do not. To keep both sides consistent with the UI's
        # InteractiveComplexHeatmapOutput(ns("Heatmap")), we register against the
        # session's *root* scope and pass the fully-qualified id ns("Heatmap").
        root_session <- session$rootScope()

        observeEvent(build_heatmap(), {
            InteractiveComplexHeatmap::makeInteractiveComplexHeatmap(
                root_session$input, root_session$output, root_session,
                build_heatmap(),
                heatmap_id = ns("Heatmap")
            )
        }, ignoreNULL = TRUE)

        # Reset handler mirroring the UI defaults.
        observeEvent(input$reset, {
            df <- data()
            num.cols <- names(df)[vapply(df, is.numeric, logical(1))]
            id.choices <- c("", names(df)[vapply(df, function(x) !is.numeric(x), logical(1))])

            updateSelectizeInput(session, "matrix.cols",
                selected = get_default(defaults, "matrix.cols", num.cols, function(x) all(x %in% num.cols)))
            updateSelectInput(session, "rowname.col",
                selected = get_default(defaults, "rowname.col", "", function(x) x %in% id.choices))
            updateTextInput(session, "name", value = get_default(defaults, "name", "value"))
            colourpicker::updateColourInput(session, "na_col", value = get_default(defaults, "na_col", "grey"))

            updateSelectInput(session, "palette", selected = get_default(defaults, "palette", "Blue-White-Red"))
            updateCheckboxInput(session, "reverse.palette", value = get_default(defaults, "reverse.palette", FALSE, is.logical))
            updateCheckboxInput(session, "show_heatmap_legend", value = get_default(defaults, "show_heatmap_legend", TRUE, is.logical))

            updateCheckboxInput(session, "cluster_rows", value = get_default(defaults, "cluster_rows", TRUE, is.logical))
            updateCheckboxInput(session, "cluster_columns", value = get_default(defaults, "cluster_columns", TRUE, is.logical))
            updateSelectInput(session, "clustering_distance_rows", selected = get_default(defaults, "clustering_distance_rows", "euclidean"))
            updateSelectInput(session, "clustering_distance_columns", selected = get_default(defaults, "clustering_distance_columns", "euclidean"))
            updateSelectInput(session, "clustering_method_rows", selected = get_default(defaults, "clustering_method_rows", "complete"))
            updateSelectInput(session, "clustering_method_columns", selected = get_default(defaults, "clustering_method_columns", "complete"))
            updateCheckboxInput(session, "show_row_dend", value = get_default(defaults, "show_row_dend", TRUE, is.logical))
            updateCheckboxInput(session, "show_column_dend", value = get_default(defaults, "show_column_dend", TRUE, is.logical))
            updateNumericInput(session, "row_km", value = get_default(defaults, "row_km", 1, is.numeric))
            updateNumericInput(session, "column_km", value = get_default(defaults, "column_km", 1, is.numeric))

            updateTextInput(session, "row_title", value = get_default(defaults, "row_title", ""))
            updateTextInput(session, "column_title", value = get_default(defaults, "column_title", ""))
            updateCheckboxInput(session, "show_row_names", value = get_default(defaults, "show_row_names", TRUE, is.logical))
            updateCheckboxInput(session, "show_column_names", value = get_default(defaults, "show_column_names", TRUE, is.logical))
            updateSelectInput(session, "row_names_side", selected = get_default(defaults, "row_names_side", "right"))
            updateSelectInput(session, "column_names_side", selected = get_default(defaults, "column_names_side", "bottom"))
            updateNumericInput(session, "column_names_rot", value = get_default(defaults, "column_names_rot", 90, is.numeric))
            updateNumericInput(session, "row_names_fontsize", value = get_default(defaults, "row_names_fontsize", 12, is.numeric))
            updateNumericInput(session, "column_names_fontsize", value = get_default(defaults, "column_names_fontsize", 12, is.numeric))
            updateNumericInput(session, "title_fontsize", value = get_default(defaults, "title_fontsize", 13.2, is.numeric))

            updateCheckboxInput(session, "border", value = get_default(defaults, "border", FALSE, is.logical))
            updateNumericInput(session, "row_split", value = get_default(defaults, "row_split", NA, is.numeric))
            updateNumericInput(session, "column_split", value = get_default(defaults, "column_split", NA, is.numeric))
            updateNumericInput(session, "row_gap", value = get_default(defaults, "row_gap", 1, is.numeric))
            updateNumericInput(session, "column_gap", value = get_default(defaults, "column_gap", 1, is.numeric))
        })

        # Capture all UI inputs for the source download.
        AllInputs <- reactive(reactiveValuesToList(input))

        # Heatmap-specific source collector. The shared create_source_download_handler()
        # writes object$plot via htmlwidgets::saveWidget(), which only accepts an
        # htmlwidget; a drawn Heatmap is not one, so `plot` is left NULL and we
        # export the underlying matrix and the UI input values instead.
        plot_source_reactive <- reactive({
            mat <- heatmap_matrix()
            inputs <- isolate(AllInputs())
            input_df <- data.frame(
                names = names(inputs),
                values = vapply(inputs, function(v) {
                    if (is.null(v)) "NULL" else paste(as.character(v), collapse = ", ")
                }, character(1)),
                stringsAsFactors = FALSE
            )
            list(
                plot = NULL,
                plot_data = as.data.frame(mat),
                stats = NULL,
                inputs = input_df
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "ComplexHeatmap_source"
        )

        return(plot_source_reactive)
    })
}
