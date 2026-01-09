#' Server logic for BoxPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the BoxPlot module.
#'
#' @importFrom plotly renderPlotly ggplotly layout config
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jacob Martin
BoxPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "BoxPlotTabsetPanel", target = tab.name)
            })
        }

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "group.by", selected = "NULL")
            # Adjustments
            updateSelectInput(session, "sort_x", selected = "none")
            updateSwitchInput(session, "flip", value = FALSE)
            updateSwitchInput(session, "stack", value = FALSE)
            updateNumericInput(session, "aspect.ratio", value = 1)
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "y.max", value = max.y)

            # Points
            updateSwitchInput(session, "add.points", value = FALSE)
            updateNumericInput(session, "pt.size", value = 1)
            updateNumericInput(session, "pt.alpha", value = 1)
            updateNumericInput(session, "jitter.width", value = 0.5)
            updateNumericInput(session, "jitter.height", value = 0)

            # Colors
            colourpicker::updateColourInput(session, "pt.color", value = "#4472C4")
            updateNumericInput(session, "alpha", value = 0.7)

            # Annotations
            updateTextInput(session, "title", value = "title")
            updateTextInput(session, "y.lab", value = "y title")
            updateTextInput(session, "x.lab", value = "x title")
            updateNumericInput(session, "add.line", value = NULL)
            updateTextInput(session, "highlight", value = "")
            colourpicker::updateColourInput(session, "highlight.colour", value = "#000000")
            updateNumericInput(session, "highlight.size", value = 1)
            updateNumericInput(session, "highlight.alpha", value = 1)
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")

            # Trajectory
            updateSwitchInput(session, "add.trend", value = FALSE)
            updateNumericInput(session, "trend.pt.size", value = 2)
            colourpicker::updateColourInput(session, "trend.colour", value = "#000000")
            updateNumericInput(session, "trend.line.width", value = 1)

            # Stats
            updateSelectInput(session, "add.stat", selected = "mean")
            colourpicker::updateColourInput(session, "stat.color", value = "#000000")
            updateNumericInput(session, "stat.size", value = 1)
            updateNumericInput(session, "stat.sroke", value = 1)
            updateNumericInput(session, "stat.shape", value = 25)

            # Palette
            updateSelectInput(session, "palette", selected = "Paired")
            # Facet
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)

            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")
        })


        output$BoxPlot <- renderPlotly({
            input$update

            # Facet By Null option Upstream:
            facet.by <- NULL
            if (!isolate(input$facet.by) == "NULL") {
                facet.by <- isolate(input$facet.by)
            }
            group.by <- NULL
            if (!isolate(input$group.by) == "NULL") {
                group.by <- isolate(input$group.by)
            }
            highlight <- .na_to_null(isolate(input$highlight))

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate(input$facet.nrow))

            # Box Plot
            p <- plotthis::BoxPlot(
                data = data(),
                x = isolate(input$x.data),
                y = isolate(input$y.data),
                flip = isolate(input$flip),
                sort_x = isolate(input$sort_x),
                stack = isolate(input$stack),
                y_max = isolate(input$y.max),
                y_min = isolate(input$y.min),
                aspect.ratio = isolate(input$aspect.ratio),
                add_point = isolate(input$add.points),
                pt_size = isolate(input$pt.size),
                pt_alpha = isolate(input$pt.alpha),
                jitter_width = isolate(input$jitter.width),
                jitter_height = isolate(input$jitter.height),
                pt_color = isolate(input$pt.color),
                alpha = isolate(input$alpha),
                add_trend = isolate(input$add.trend),
                trend_ptsize = isolate(input$trend.pt.size),
                trend_color = isolate(input$trend.colour),
                trend_linewidth = isolate(input$trend.line.width),
                add_stat = match.fun(isolate(input$add.stat)),
                stat_color = isolate(input$stat.color),
                stat_size = isolate(input$stat.size),
                stat_stroke = isolate(input$stat.stroke),
                stat_shape = isolate(input$stat.shape),
                stat_name = isolate(input$add.stat),
                palette = isolate(input$palette),
                add_bg = isolate(input$background.colour),
                bg_palette = isolate(input$background.palette),
                add_line = isolate(input$add.line),
                facet_by = facet.by,
                facet_scales = isolate(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate(input$facet.by.row),
                group_by = group.by,
                highlight = highlight,
                highlight_color = isolate(input$highlight.colour),
                highlight_size = isolate(input$highlight.size),
                highlight_alpha = isolate(input$highlight.alpha),
                combine = isolate(input$combine)
            )

            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = 28, family = isolate(input$font.type), color = isolate(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- list(
                title = list(
                    font = list(size = 18, family = isolate(input$font.type), color = isolate(input$text.colour))
                ),
                showline = isolate(input$axis.showline),
                mirror = isolate(input$axis.mirror),
                linecolor = isolate(input$axis.linecolor),
                linewidth = isolate(input$axis.linewidth),
                tickfont = list(
                    size = isolate(input$axis.tickfont.size),
                    color = isolate(input$axis.tickfont.color),
                    family = isolate(input$axis.tickfont.family)
                ),
                tickangle = isolate(input$axis.tickangle.x),
                ticks = isolate(input$axis.ticks),
                tickcolor = isolate(input$axis.tickcolor),
                ticklen = isolate(input$axis.ticklen),
                tickwidth = isolate(input$axis.tickwidth)
            )

            yaxis_style <- list(
                title = list(
                    font = list(size = 18, family = isolate(input$font.type), color = isolate(input$text.colour))
                ),
                showline = isolate(input$axis.showline),
                mirror = isolate(input$axis.mirror),
                linecolor = isolate(input$axis.linecolor),
                linewidth = isolate(input$axis.linewidth),
                tickfont = list(
                    size = isolate(input$axis.tickfont.size),
                    color = isolate(input$axis.tickfont.color),
                    family = isolate(input$axis.tickfont.family)
                ),
                tickangle = isolate(input$axis.tickangle.y),
                ticks = isolate(input$axis.ticks),
                tickcolor = isolate(input$axis.tickcolor),
                ticklen = isolate(input$axis.ticklen),
                tickwidth = isolate(input$axis.tickwidth)
            )

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(format = isolate(input$download.type), filename = "box_plot", height = 500, width = 700, scale = 1),
                    displaylogo = FALSE
                )

            return(fig)
        })
    })
}
