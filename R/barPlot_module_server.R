#' Server logic for BarPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the BarPlot module.
#'
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jacob Martin
BarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "BarPlotTabsetPanel", target = tab.name)
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
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSwitchInput(session, "flip", value = FALSE)
            updateNumericInput(session, "y.max", value = max.y)
            updateNumericInput(session, "y.min", value = min.y)

            # Grouping
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "NULL")

            # Aesthetics
            updateSelectInput(session, "palette", selected = "Set2")
            updateSwitchInput(session, "background.colour", value = FALSE)
            updateSelectInput(session, "background.palette", selected = "Set2")
            updateNumericInput(session, "background.alpha", value = 0.5)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)
            updateNumericInput(session, "width", value = NA)
            updateTextInput(session, "expand", value = "")

            # Line
            updateNumericInput(session, "add.line", value = NA)
            colourpicker::updateColourInput(session, "line.colour", value = "#000000")
            updateNumericInput(session, "line.type", value = 2)
            updateNumericInput(session, "line.width", value = 0.6)
            updateTextInput(session, "line.name", value = "")

            # Labels
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")

            #Axes: 
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            colourpicker::updateColourInput(session, "axis.linecolor", value = "black")
            updateNumericInput(session, "axis.linewidth", value = 0.5)
            updateNumericInput(session, "axis.tickfont.size", value = 12)
            colourpicker::updateColourInput(session, "axis.tickfont.color", value = "black")
            updateSelectInput(session, "axis.tickfont.family", selected = "Arial")
            updateNumericInput(session, "axis.tickangle.x", value = 0)
            updateNumericInput(session, "axis.tickangle.y", value = 0)
            updateSelectInput(session, "axis.ticks", selected = "outside")
            colourpicker::updateColourInput(session, "axis.tickcolor", value = "black")
            updateNumericInput(session, "axis.ticklen", value = 5)
            updateNumericInput(session, "axis.tickwidth", value = 1)
        })


        output$BarPlot <- renderPlotly({
            input$update

            # Null Values:
            facet.by <- NULL
            if (!isolate(input$facet.by) == "NULL") {
                facet.by <- isolate(input$facet.by)
            }
            line.name <- .na_to_null(isolate(input$line.name))
            expand <- waiver()
            expand.input <- .na_to_null(isolate(input$expand))
            if (!is.null(expand.input)) {
                expand <- as.numeric(strsplit(expand.input, ",\\s*")[[1]])
            }
            if (!is.na(isolate(input$width))) {
                width <- isolate(input$width)
            } else {
                width <- waiver()
            }
            split.by <- NULL
            if (!isolate(input$split.by) == "NULL") {
                split.by <- isolate(input$split.by)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate(input$facet.nrow))

            # bar Plot
            p <- plotthis::BarPlot(
                data(),
                x = isolate(input$x.data),
                y = isolate(input$y.data),
                flip = isolate(input$flip),
                group_by = isolate(input$group.by),
                facet_by = facet.by,
                facet_scales = isolate(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate(input$facet.by.row),
                palette = isolate(input$palette),
                palcolor = isolate(input$palette.colours),
                add_bg = isolate(input$background.colour),
                bg_palette = isolate(input$background.palette),
                bg_alpha = isolate(input$background.alpha),
                y_min = isolate(input$y.min),
                y_max = isolate(input$y.max),
                theme = isolate(input$theme),
                alpha = isolate(input$alpha),
                add_line = isolate(input$add.line),
                line_color = isolate(input$line.colour),
                line_width = isolate(input$line.width),
                line_type = isolate(input$line.type),
                line_name = line.name,
                fill_by_x_if_no_group = TRUE,
                expand = expand,
                width = width,
                split_by = split.by
            )
            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = isolate(input$title.font.size), family = isolate(input$font.type), color = isolate(input$text.colour)),
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

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
            
            config_list <- .add_plot_config(download.format = isolate(input$download.type), include.modebar.buttons = FALSE, simple = TRUE)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
