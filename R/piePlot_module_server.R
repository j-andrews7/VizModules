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
#' @return The `moduleServer` function for the piePlot module.
#'
#' @importFrom shinyjs hide
#' @importFrom stats reformulate
#'
#' @export
#' @author Jacob Martin
piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
            input$update

            # Null Values:
            labels_formula <- reformulate(isolate(input$labels))
            plot_values <- reformulate(isolate(input$values))

            # pie Plot

            fig <- piePlot(
                reactive.data = data(),
                plot.labels = labels_formula,
                plot.values = plot_values,
                make.hole = isolate(input$make.hole),
                palette = plotthis::palette_list[[isolate(input$palette)]],
                col.palette = isolate(input$palette.colours),
                plot.text = isolate(input$plot.text)
            ) |>
                layout(
                    title = list(
                        text = "Click To Edit Title",
                        font = list(
                            size = isolate(input$title.font.size),
                            family = isolate(input$font.type),
                            color = isolate(input$text.colour)
                        ),
                        x = 0.47,
                        xanchor = "center",
                        y = 0.95,
                        yanchor = "top",
                        pad = list(t = 20)
                    ),
                    margin = list(t = 80),
                    showlegend = TRUE
                ) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(
                        format = isolate(input$download.type),
                        filename = "pie_plot", height = 600, width = 700, scale = 1
                    ),
                    displaylogo = FALSE
                ) # Hiding Plotly Logo

            return(fig)
        })
    })
}
