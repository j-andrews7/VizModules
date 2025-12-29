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
#' @export
#' @author Jared Andrews
volcanoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facets")) {
    volcano_data <- moduleServer(id, function(input, output, session) {
        # Reactive data with group column based on thresholds
        reactive({
            req(data())
            # Use !is.null() checks for threshold inputs since req(0) returns FALSE
            req(!is.null(input$sig.thresh), !is.null(input$fc.thresh))
            dat <- data()

            # Ensure the columns exist
            req("padj" %in% names(dat), "log2FoldChange" %in% names(dat))

            # Handle potential NA values in padj
            dat$padj[is.na(dat$padj)] <- 1

            dat$group <- "Insignificant"
            # Fold change threshold logic - compare directly to fc.thresh since log2FoldChange is already log2 scale
            # Using abs() comparison handles both up/down in one check, then assign direction
            dat$group[dat$padj < input$sig.thresh & dat$log2FoldChange > input$fc.thresh] <- "Upregulated"
            dat$group[dat$padj < input$sig.thresh & dat$log2FoldChange < -input$fc.thresh] <- "Downregulated"

            # Ensure group is a factor for consistent coloring
            dat$group <- factor(dat$group, levels = c("Upregulated", "Downregulated", "Insignificant"))
            dat
        })
    })

    scatterPlotServer(id = id, data = volcano_data, hide.inputs = hide.inputs, hide.tabs = hide.tabs)
}
