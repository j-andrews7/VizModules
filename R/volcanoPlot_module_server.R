#' Server logic for volcanoPlot module
#'
#' This module builds upon the [vizModules::scatterPlotServer()] to provide a volcano plot
#' with interactive significance and fold-change thresholding.
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#'   Must contain `padj` and `log2FoldChange` columns.
#' @param hide.inputs A character vector of input IDs to hide.
#' @param hide.tabs A character vector of tab names to hide.
#' @return The `moduleServer` function for the volcanoPlot module.
#'
#' @importFrom shiny moduleServer reactive isolate req
#' @export
#' @author Jared Andrews
volcanoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facets")) {
    res <- moduleServer(id, function(input, output, session) {
        # Reactive data with group column based on thresholds
        data_reac <- reactive({
            req(data())
            # Explicit dependency on the update button
            input$update

            # Use isolate for threshold inputs so they don't trigger updates
            sig_thresh <- isolate(input$sig.thresh)
            fc_thresh <- isolate(input$fc.thresh)

            # Determine which columns to use for effect size (x) and significance (y)
            # We use the selected x and y inputs mostly likely, as those should be valid columns
            x_col <- isolate(input$x.by)
            y_col <- isolate(input$y.by)

            # Use !is.null() checks for threshold inputs since req(0) returns FALSE
            req(!is.null(sig_thresh), !is.null(fc_thresh), !is.null(x_col), !is.null(y_col))
            dat <- data()

            # Ensure the columns exist
            req(y_col %in% names(dat), x_col %in% names(dat))

            # Handle potential NA values in p-value column
            dat[[y_col]][is.na(dat[[y_col]])] <- 1

            dat$group <- "n.s."
            # Fold change threshold logic - compare directly to fc.thresh since log2FoldChange is already log2 scale
            # Using abs() comparison handles both up/down in one check, then assign direction
            dat$group[dat[[y_col]] < sig_thresh & dat[[x_col]] > fc_thresh] <- "Up"
            dat$group[dat[[y_col]] < sig_thresh & dat[[x_col]] < -fc_thresh] <- "Down"

            # Ensure group is a factor for consistent coloring
            dat$group <- factor(dat$group, levels = c("Up", "Down", "n.s."))
            dat
        })

        # Use color inputs for manual colors - reactive so it updates on button click
        color_reac <- reactive({
            input$update
            c(
                "Up" = if (!is.null(isolate(input$color.up))) isolate(input$color.up) else "red",
                "Down" = if (!is.null(isolate(input$color.down))) isolate(input$color.down) else "blue",
                "n.s." = if (!is.null(isolate(input$color.ns))) isolate(input$color.ns) else "lightgray"
            )
        })

        list(data = data_reac, colors = color_reac)
    })

    # Hide the standard color panel since we're using custom controls
    if (is.null(hide.inputs)) {
        hide.inputs <- c("color.panel")
    } else {
        hide.inputs <- c(hide.inputs, "color.panel")
    }

    scatterPlotServer(id = id, data = res$data, hide.inputs = hide.inputs, hide.tabs = hide.tabs, manual.colors = res$colors)
}
