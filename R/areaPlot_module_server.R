#' Server logic for AreaPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the AreaPlot module.
#'
#' @importFrom plotly renderPlotly ggplotly layout config
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jacob Martin, Jared Andrews
AreaPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "AreaPlotTabsetPanel", target = tab.name)
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
            numeric.data <- data()[, unlist(lapply(data(), is.numeric), use.names = FALSE), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data
            # Data
            updateSelectInput(session, "x.data", selected = char.choices[2])

            # Grouping
            updateSelectInput(session, "group.by", selected = char.choices[3])
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "NULL")

            # Aesthetics
            updateSelectInput(session, "palette", selected = "Set2")
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)

            # Labels
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")
        })


        output$areaPlot <- renderPlotly({
            input$update

            # Null Values:
            facet.by <- NULL
            if (!isolate(input$facet.by) == "NULL") {
                facet.by <- isolate(input$facet.by)
            }

            split.by <- NULL
            if (!isolate(input$split.by) == "NULL") {
                split.by <- isolate(input$split.by)
            }

            design <- if (isolate(input$split.by) == "NULL" || isolate(input$design) == "NULL") NULL else isolate(input$design)

            p <- plotthis::AreaPlot(
                data(),
                x = isolate(input$x.data),
                y = isolate(input$y.data),
                split_by = split.by,
                group_by = isolate(input$group.by),
                theme = isolate(input$theme),
                palette = isolate(input$palette),
                palcolor = isolate(input$palette.colours),
                alpha = isolate(input$alpha),
                facet_by = facet.by,
                facet_scales = isolate(input$facet.scale),
                facet_ncol = isolate(input$facet.ncol),
                facet_nrow = isolate(input$facet.nrow),
                facet_byrow = isolate(input$facet.by.row),
                combine = isolate(input$combine),
                design = design
            )


            plotlyOut <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(
                            size = isolate(input$title.font.size),
                            family = isolate(input$font.type),
                            color = isolate(input$text.colour)
                        ),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- list(
                title = list(
                    font = list(size = isolate(input$axis.font.size), family = isolate(input$font.type), color = isolate(input$text.colour))
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
                    font = list(size = isolate(input$axis.font.size), family = isolate(input$font.type), color = isolate(input$text.colour))
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

            plotlyOut <- .apply_subplot_axis_styling(plotlyOut, xaxis_style, yaxis_style) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(format = isolate(input$download.type), filename = "area_plot", height = 500, width = 700, scale = 1),
                    displaylogo = FALSE
                )

            return(plotlyOut)
        })
    })
}
