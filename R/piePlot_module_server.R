#' Server logic for piePlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param update.button Logical; if `TRUE` (default), an "Update Plot" button is shown and plot only re-renders when clicked.
#'   If `FALSE`, plot re-renders immediately when inputs change.
#' @return The `moduleServer` function for the piePlot module.
#'
#' @importFrom shinyjs hide
#' @importFrom stats reformulate
#'
#' @export
#' @author Jacob Martin
piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, update.button = TRUE)) {
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
                hideTab(inputId = "piePlotTabsetPanel", target = tab.name)
            })
        }

        # Hide update button if disabled
        if (!update.button) {
            hide("update")
        }

        # Set up wrapper function for isolate based on update.button parameter
        isolate_fn <- if (update.button) isolate else identity
        ns <- session$ns
        output$palette.selection <- renderUI({
            pal <- input$palette
            colour_selection <- plotthis::palette_list[[pal]]

            selectInput(
                ns("palette.colours"), # namespaced ID
                "Colours to use:",
                multiple = TRUE,
                selected = NULL,
                choices  = c(colour_selection)
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])

            # Reset numeric inputs to defaults derived from data
            # Data
            updateSelectInput(session, "labels", selected = char.choices[2])
            updateSelectInput(session, "values", selected = numeric.data[2])

            # Aesthetics
            updateNumericInput(session, "make.hole", value = 0)
            updateSelectInput(session, "palette", selected = "Paired")
            updateSelectInput(session, "palette.colours", selected = NULL)
            updateTextInput(session, "plot.text", value = "label+percent")
            updateNumericInput(session, "title.font.size", value = 28)
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
        })


        output$piePlot <- renderPlotly({
            if (update.button) {
                input$update
            }

            # Null Values:
            labels_formula <- reformulate(isolate_fn(input$labels))
            plot_values <- reformulate(isolate_fn(input$values))

            # pie Plot

            p <- piePlot(
                reactive.data = data(),
                plot.labels = labels_formula,
                plot.values = plot_values,
                make.hole = isolate_fn(input$make.hole),
                palette = plotthis::palette_list[[isolate_fn(input$palette)]],
                col.palette = isolate_fn(input$palette.colours),
                plot.text = isolate_fn(input$plot.text)
            )


            fig <- ggplotly(p) |>
                layout(
                    title = list(text = "Click To Edit Title", font = list(size = isolate_fn(input$title.font.size), family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)), x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)), margin = list(t = 80), showlegend = TRUE,
                    xaxis = list(
                        showline = isolate_fn(input$axis.showline),
                        mirror = isolate_fn(input$axis.mirror),
                        linecolor = isolate_fn(input$axis.linecolor),
                        linewidth = isolate_fn(input$axis.linewidth),
                        tickfont = list(
                            size = isolate_fn(input$axis.tickfont.size),
                            color = isolate_fn(input$axis.tickfont.color),
                            family = isolate_fn(input$axis.tickfont.family)
                        ),
                        tickangle = isolate_fn(input$axis.tickangle.x),
                        ticks = isolate_fn(input$axis.ticks),
                        tickcolor = isolate_fn(input$axis.tickcolor),
                        ticklen = isolate_fn(input$axis.ticklen),
                        tickwidth = isolate_fn(input$axis.tickwidth)
                    ),
                    yaxis = list(
                        showline = isolate_fn(input$axis.showline),
                        mirror = isolate_fn(input$axis.mirror),
                        linecolor = isolate_fn(input$axis.linecolor),
                        linewidth = isolate_fn(input$axis.linewidth),
                        tickfont = list(
                            size = isolate_fn(input$axis.tickfont.size),
                            color = isolate_fn(input$axis.tickfont.color),
                            family = isolate_fn(input$axis.tickfont.family)
                        ),
                        tickangle = isolate_fn(input$axis.tickangle.y),
                        ticks = isolate_fn(input$axis.ticks),
                        tickcolor = isolate_fn(input$axis.tickcolor),
                        ticklen = isolate_fn(input$axis.ticklen),
                        tickwidth = isolate_fn(input$axis.tickwidth)
                    )
                )
            
            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = FALSE, simple = TRUE)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
