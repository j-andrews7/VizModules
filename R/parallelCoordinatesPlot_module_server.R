#' Server logic for parallelCoordinatesPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the parallelCoordinatesPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#'
#' @seealso [VizModules::parallelCoordinatesPlot()], [VizModules::parallelCoordinatesPlotInputsUI()],
#' [VizModules::parallelCoordinatesPlotOutputUI()], [VizModules::parallelCoordinatesPlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
parallelCoordinatesPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "parallelCoordinatesPlotTabsetPanel", target = tab.name)
        }

        # Reset functionality
        observeEvent(input$reset, {
            d <- data_reactive()
            updateSelectInput(session, "dimensions", selected = names(d))
            updateSelectInput(session, "color.by", selected = "")
            updateSelectInput(session, "color.scale", selected = "Viridis")
            updateSliderInput(session, "line.opacity", value = 0.5)
            updateNumericInput(session, "line.width", value = 1)
            updateCheckboxInput(session, "show.colorbar", value = TRUE)
            updateNumericInput(session, "label.font.size", value = 12)
            colourpicker::updateColourInput(session, "label.font.color", value = "black")
            updateSelectInput(session, "label.font.family", selected = "Arial")
            updateNumericInput(session, "tick.font.size", value = 10)
            colourpicker::updateColourInput(session, "tick.font.color", value = "black")
            updateSelectInput(session, "tick.font.family", selected = "Arial")
            updateNumericInput(session, "title.font.size", value = 16)
            updateSelectInput(session, "title.font.family", selected = "Arial")
            colourpicker::updateColourInput(session, "title.text.color", value = "#000000")
            colourpicker::updateColourInput(session, "bgcolor", value = "#FFFFFF")
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_parallelCoordinatesPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()
            req(nrow(d) > 0)

            dims <- isolate_fn(input$dimensions)
            validate(
                need(
                    !is.null(dims) && length(dims) >= 2,
                    "Please select at least two dimension columns."
                )
            )

            # Filter to valid columns
            dims <- dims[dims %in% names(d)]
            validate(
                need(
                    length(dims) >= 2,
                    "Please select at least two valid dimension columns."
                )
            )

            color.by <- isolate_fn(input$color.by)
            if (is.null(color.by) || !nzchar(color.by)) {
                color.by <- NULL
            }

            fig <- parallelCoordinatesPlot(
                data = d,
                dimensions = dims,
                color.by = color.by,
                color.scale = isolate_fn(input$color.scale),
                line.opacity = isolate_fn(input$line.opacity),
                line.width = isolate_fn(input$line.width),
                show.colorbar = isTRUE(isolate_fn(input$show.colorbar)),
                label.font.size = isolate_fn(input$label.font.size),
                label.font.color = isolate_fn(input$label.font.color),
                label.font.family = isolate_fn(input$label.font.family),
                tick.font.size = isolate_fn(input$tick.font.size),
                tick.font.color = isolate_fn(input$tick.font.color),
                tick.font.family = isolate_fn(input$tick.font.family),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.family = isolate_fn(input$title.font.family),
                title.text.color = isolate_fn(input$title.text.color),
                bgcolor = isolate_fn(input$bgcolor)
            )

            config_list <- .add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = FALSE
            )
            fig <- do.call(plotly::config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$parallelCoordinatesPlot <- renderPlotly({
            generate_parallelCoordinatesPlot() |>
                layout(
                    margin = list(t = 100, l = 90, r = 90, b = 100, autoexpand = TRUE)
                )
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_parallelCoordinatesPlot,
            filename_base = "parallelCoordinatesPlot"
        )
    })
}
