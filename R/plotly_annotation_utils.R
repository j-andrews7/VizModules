#' Check if a plotly trace should be included in annotations
#'
#' Determines whether a trace in a plotly figure should be included when
#' processing annotations. "show.others" background traces are excluded.
#'
#' @param trace A single trace object from a plotly figure's data list.
#' @param show.others Logical. Whether "show.others" was enabled in the plot.
#'
#' @return Logical. TRUE if the trace should be included in annotation processing,
#'   FALSE if it should be skipped.
#'
#' @details Background traces (show.others) are identified by checking for:
#'   - name field containing "show.others"
#'   - legendgroup field containing "show.others"
#'   - Single text element (this check is REMOVED as it's unreliable)
#'
#' @author Jared Andrews
#' @rdname INTERNAL_should_include_trace
#' @keywords internal
.should_include_trace <- function(trace, show.others = TRUE) {
    # Skip non-scatter traces or traces without proper data
    if (is.null(trace$x) || is.null(trace$y)) {
        return(FALSE)
    }
    if (!is.null(trace$type) && !trace$type %in% c("scatter", "scattergl")) {
        return(FALSE)
    }

    # Skip traces that are explicitly marked as background/show.others
    # These are identified by their name or legendgroup
    if (!is.null(trace$name)) {
        if (grepl("show\\.others", trace$name, ignore.case = TRUE)) {
            return(FALSE)
        }
    }
    if (!is.null(trace$legendgroup)) {
        if (grepl("show\\.others", trace$legendgroup, ignore.case = TRUE)) {
            return(FALSE)
        }
    }

    # If coordinates are not numeric, skip
    if (!is.numeric(trace$x) || !is.numeric(trace$y)) {
        return(FALSE)
    }

    return(TRUE)
}


#' Extract annotation text from trace hover text
#'
#' Parses the hover text of a plotly trace to extract the value of a specific
#' annotation field.
#'
#' @param trace_text Character. The hover text from a trace point.
#' @param annotate.by Character. The name of the field to extract from hover text.
#'
#' @return Character. The extracted annotation value, or NULL if not found.
#'
#' @details The hover text is expected to be in the format:
#'   "field1: value1\\nfield2: value2\\n..."
#'   or "field1 value1\\nfield2 value2\\n..."
#'
#' @author Jared Andrews
#' @rdname INTERNAL_extract_annotation_from_text
#' @keywords internal
.extract_annotation_from_text <- function(trace_text, annotate.by) {
    if (is.null(trace_text) || is.na(trace_text) || trace_text == "") {
        return(NULL)
    }

    # Split by newlines to get individual fields
    text_lines <- strsplit(as.character(trace_text), "\\n")[[1]]

    # Find the line containing the annotation field
    anno_line <- grep(annotate.by, text_lines, value = TRUE, fixed = TRUE)

    if (length(anno_line) == 0) {
        return(NULL)
    }

    # Extract the value after the field name
    # Try splitting by ": " first (preferred format)
    anno_parts <- strsplit(anno_line[1], ": ", fixed = TRUE)[[1]]
    if (length(anno_parts) >= 2) {
        return(anno_parts[2])
    }

    # Fallback: try splitting by space
    anno_parts <- strsplit(anno_line[1], " ", fixed = TRUE)[[1]]
    if (length(anno_parts) >= 2) {
        return(anno_parts[2])
    }

    return(NULL)
}


#' Create coordinate identifier for matching points
#'
#' Creates a unique coordinate identifier string for matching points between
#' traces and data frames.
#'
#' @param x Numeric vector. X-coordinates.
#' @param y Numeric vector. Y-coordinates.
#' @param precision Integer. Number of decimal places for rounding (default: 10).
#'
#' @return Character vector. Coordinate identifiers in format "x_y".
#'
#' @author Jared Andrews
#' @rdname INTERNAL_create_coord_id
#' @keywords internal
.create_coord_id <- function(x, y, precision = 10) {
    fmt <- function(v) if (is.numeric(v)) round(v, precision) else as.character(v)
    paste0(fmt(x), "_", fmt(y))
}


#' Build trace-to-annotation mapping
#'
#' Creates a mapping between trace data and annotation values by parsing
#' trace hover text. This is used for robust point matching when creating
#' annotations.
#'
#' @param trace A single trace object from a plotly figure's data list.
#' @param annotate.by Character. The name of the field to extract for annotations.
#'
#' @return A data frame with columns:
#'   - coord_id: Unique coordinate identifier string
#'   - anno_value: Extracted annotation value
#'   Returns NULL if trace has no valid data.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_build_trace_anno_map
#' @keywords internal
.build_trace_anno_map <- function(trace, annotate.by) {
    if (is.null(trace$x) || is.null(trace$y) || is.null(trace$text)) {
        return(NULL)
    }

    # Coordinates may be categorical (e.g. a factor x-axis), in which case
    # trace$x/$y are character/position values. .create_coord_id handles both
    # numeric and non-numeric coordinates, so no numeric requirement is imposed.

    # Create coordinate IDs
    coord_ids <- .create_coord_id(trace$x, trace$y)

    # Extract annotation values from hover text (vectorized)
    # Note: .extract_annotation_from_text can return NULL, so we wrap it
    anno_values <- vapply(
        trace$text,
        function(txt) {
            result <- .extract_annotation_from_text(txt, annotate.by)
            if (is.null(result)) NA_character_ else result
        },
        character(1),
        USE.NAMES = FALSE
    )

    # Return data frame mapping coordinates to annotation values
    data.frame(
        coord_id = coord_ids,
        anno_value = anno_values,
        stringsAsFactors = FALSE
    )
}


#' Create annotations for selected points
#'
#' Creates plotly annotation objects for selected points from event_data("plotly_selected").
#' This function handles the complex logic of matching selected points to their
#' corresponding traces and extracting annotation text.
#'
#' @param selected_data Data frame from event_data("plotly_selected").
#' @param fig Plotly figure object.
#' @param annotate.by Character. Name of the field to use for annotation text.
#' @param annotation_params List of annotation styling parameters (ax, ay, showarrow, etc.).
#' @param show.others Logical. Whether "show.others" was enabled in the plot.
#'
#' @return List of plotly annotation objects, or NULL if no valid annotations.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_create_selected_annotations
#' @keywords internal
.create_selected_annotations <- function(selected_data, fig, annotate.by,
                                         annotation_params, show.others = TRUE) {
    if (is.null(selected_data) || nrow(selected_data) == 0) {
        return(NULL)
    }

    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$data) || length(fig$x$data) == 0) {
        return(NULL)
    }

    # Build mapping of axis references for each trace
    trace_axis_map <- lapply(seq_along(fig$x$data), function(i) {
        trace <- fig$x$data[[i]]
        xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
        yaxis <- if (!is.null(trace$yaxis)) trace$yaxis else "y"
        should_include <- .should_include_trace(trace, show.others)
        list(xaxis = xaxis, yaxis = yaxis, include = should_include)
    })

    # Filter selected points to only those from traces we should include
    include_idx <- vapply(trace_axis_map, function(x) x$include, logical(1))
    valid_curve_nums <- which(include_idx) - 1 # Convert to 0-indexed
    selected_data_filtered <- selected_data[selected_data$curveNumber %in% valid_curve_nums, ]

    if (nrow(selected_data_filtered) == 0) {
        return(NULL)
    }

    # Check for required curveNumber column
    if (!"curveNumber" %in% names(selected_data_filtered) ||
        !is.numeric(selected_data_filtered$curveNumber)) {
        return(NULL)
    }

    # Create annotations for each selected point
    annos <- list()
    for (i in seq_len(nrow(selected_data_filtered))) {
        curve_num <- selected_data_filtered$curveNumber[i] + 1 # Convert to 1-indexed R

        if (curve_num > length(trace_axis_map)) {
            next
        }

        # Get axis references for this trace
        xref <- trace_axis_map[[curve_num]]$xaxis
        yref <- trace_axis_map[[curve_num]]$yaxis

        # Get trace data
        trace <- fig$x$data[[curve_num]]
        if (is.null(trace$x) || is.null(trace$y) || is.null(trace$text)) {
            next
        }

        # Match selected point to trace by coordinates
        selected_coord <- .create_coord_id(
            selected_data_filtered$x[i],
            selected_data_filtered$y[i]
        )
        trace_coords <- .create_coord_id(trace$x, trace$y)
        point_idx <- which(trace_coords == selected_coord)

        if (length(point_idx) == 0) {
            next
        }

        # Extract annotation text from trace hover text
        anno_text <- .extract_annotation_from_text(
            trace$text[point_idx[1]],
            annotate.by
        )

        if (is.null(anno_text)) {
            next
        }

        # Create annotation object
        annos[[length(annos) + 1]] <- list(
            x = selected_data_filtered$x[i],
            y = selected_data_filtered$y[i],
            text = anno_text,
            xref = xref,
            yref = yref,
            ax = annotation_params$ax,
            ay = annotation_params$ay,
            showarrow = annotation_params$showarrow,
            arrowcolor = annotation_params$arrowcolor,
            arrowhead = annotation_params$arrowhead,
            arrowwidth = annotation_params$arrowwidth,
            font = list(
                size = annotation_params$size,
                color = annotation_params$color
            )
        )
    }

    if (length(annos) == 0) {
        return(NULL)
    }

    return(annos)
}


#' Create annotations for highlighted points
#'
#' Creates plotly annotation objects for points highlighted by value matching.
#' This function finds all points in the plot data that match the highlight values
#' and creates annotations for them.
#'
#' @param plot_data Data frame. The plot data from dittoViz scatterPlot (Target_data).
#' @param fig Plotly figure object.
#' @param annotate.by Character. Name of the field to use for annotation text.
#' @param highlight_vals Character vector. Values to highlight from the annotate.by column.
#' @param x_col Character. Name of the x-axis column.
#' @param y_col Character. Name of the y-axis column.
#' @param annotation_params List of annotation styling parameters.
#' @param show.others Logical. Whether "show.others" was enabled in the plot.
#'
#' @return List of plotly annotation objects, or NULL if no valid annotations.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_create_highlight_annotations
#' @keywords internal
.create_highlight_annotations <- function(plot_data, fig, annotate.by, highlight_vals,
                                          x_col, y_col, annotation_params, show.others = TRUE) {
    if (is.null(plot_data) || is.null(highlight_vals) || length(highlight_vals) == 0) {
        return(NULL)
    }

    if (!annotate.by %in% names(plot_data)) {
        return(NULL)
    }

    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$data) || length(fig$x$data) == 0) {
        return(NULL)
    }

    # Find points to highlight in plot data
    highlight_idx <- which(as.character(plot_data[[annotate.by]]) %in% highlight_vals)
    if (length(highlight_idx) == 0) {
        return(NULL)
    }

    # Build mapping of axis references for each trace
    trace_axis_map <- lapply(seq_along(fig$x$data), function(i) {
        trace <- fig$x$data[[i]]
        xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
        yaxis <- if (!is.null(trace$yaxis)) trace$yaxis else "y"
        list(xaxis = xaxis, yaxis = yaxis)
    })

    # Build annotations by matching highlight labels to trace points. Positions
    # are taken from the trace itself (trace$x/$y), which works for numeric and
    # categorical axes alike (ggplotly encodes factor axes as numeric positions
    # that won't match raw data values).
    highlight_vals_chr <- as.character(highlight_vals)
    annos <- list()
    for (i in seq_along(fig$x$data)) {
        trace <- fig$x$data[[i]]

        # Skip traces that should not be included
        if (!.should_include_trace(trace, show.others)) {
            next
        }

        # Build trace annotation mapping
        trace_map <- .build_trace_anno_map(trace, annotate.by)

        if (is.null(trace_map)) {
            next
        }

        matching_rows <- which(trace_map$anno_value %in% highlight_vals_chr)

        for (row in matching_rows) {
            xref <- trace_axis_map[[i]]$xaxis
            yref <- trace_axis_map[[i]]$yaxis

            annos[[length(annos) + 1]] <- list(
                x = trace$x[row],
                y = trace$y[row],
                text = trace_map$anno_value[row],
                xref = xref,
                yref = yref,
                ax = annotation_params$ax,
                ay = annotation_params$ay,
                showarrow = annotation_params$showarrow,
                arrowcolor = annotation_params$arrowcolor,
                arrowhead = annotation_params$arrowhead,
                arrowwidth = annotation_params$arrowwidth,
                font = list(
                    size = annotation_params$size,
                    color = annotation_params$color
                )
            )
        }
    }

    if (length(annos) == 0) {
        return(NULL)
    }

    return(annos)
}
