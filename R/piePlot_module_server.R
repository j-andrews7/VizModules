#' Server logic for piePlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Provide a
#'   summarized table with columns for labels and aggregated values.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the piePlot module.
#'
#' @import shiny
#' @importFrom shinyjs hide
#' @importFrom stats na.omit setNames
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

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

        output$color.picker <- renderUI({
            d <- data_reactive()
            lbl <- input$labels
            req(!is.null(lbl), lbl %in% names(d))

            groups <- unique(stats::na.omit(as.character(d[[lbl]])))
            if (length(groups) == 0) {
                return(NULL)
            }

            multiColorPicker(
                ns("slice.colors"),
                label = "Slice colors",
                groups = groups,
                selected_palette = "dittoColors",
                compact = TRUE
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data_reactive())[vapply(data_reactive(), is.numeric, logical(1))])
            char.choices <- c("", names(data_reactive())[!vapply(data_reactive(), is.numeric, logical(1))])

            # Data
            updateSelectInput(session, "labels", selected = char.choices[2])
            updateSelectInput(session, "values", selected = numeric.data[2])

            # Slice layout
            updateCheckboxInput(session, "sort.slices", value = TRUE)
            updateSelectInput(session, "direction", selected = "counterclockwise")
            updateSliderInput(session, "rotation", value = 0)
            updateSliderInput(session, "hole", value = 0)

            # Text
            updateSelectInput(session, "textinfo", selected = c("label", "percent"))
            updateSelectInput(session, "textposition", selected = "auto")
            updateSelectInput(session, "insidetextorientation", selected = "auto")
            updateNumericInput(session, "text.font.size", value = 12)
            updateSelectInput(session, "text.font.family", selected = "Arial")
            colourpicker::updateColourInput(session, "text.font.color", value = "#000000")

            # Title
            updateSliderInput(session, "title.x", value = 0.5)
            updateNumericInput(session, "title.font.size", value = 28)
            updateSelectInput(session, "title.font.family", selected = "Arial")
            colourpicker::updateColourInput(session, "title.font.color", value = "#000000")

            # Legend
            updateCheckboxInput(session, "show.legend", value = TRUE)
            updateSelectInput(session, "legend.orientation", selected = "h")
            updateSelectInput(session, "legend.font.family", selected = "Arial")
            updateNumericInput(session, "legend.font.size", value = 12)
            colourpicker::updateColourInput(session, "legend.font.color", value = "#000000")

            # Slice borders
            colourpicker::updateColourInput(session, "slice.line.color", value = "#FFFFFF")
            updateNumericInput(session, "slice.line.width", value = 0)
        })

        build_textinfo <- function(selected) {
            if (is.null(selected) || length(selected) == 0) {
                return("none")
            }
            if ("none" %in% selected) {
                return("none")
            }
            paste(unique(selected), collapse = "+")
        }

        # Reactive expression to generate the plot (used by both output and download)
        generate_pieplot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()
            req(nrow(d) > 0)

            label_col <- isolate_fn(input$labels)
            value_col <- isolate_fn(input$values)

            validate(
                need(!is.null(label_col) && label_col %in% names(d), "Select a label column for the slices."),
                need(!is.null(value_col) && value_col %in% names(d), "Select a numeric column for slice values."),
                need(is.numeric(d[[value_col]]), "The value column must contain numeric, aggregated data.")
            )

            textinfo <- build_textinfo(isolate_fn(input$textinfo))
            textposition <- isolate_fn(input$textposition)
            if (identical(textinfo, "none")) {
                textposition <- "none"
            }

            label_values <- as.character(d[[label_col]])
            color_map <- isolate_fn(input$slice.colors)

            if (is.null(color_map) || length(color_map) == 0) {
                default_cols <- default_palettes()$choices$Defaults$dittoColors
                color_map <- stats::setNames(rep_len(default_cols, length(unique(label_values))), unique(label_values))
            }

            colour_vector <- color_map
            if (!is.null(names(color_map)) && any(nzchar(names(color_map)))) {
                colour_vector <- color_map[match(label_values, names(color_map))]
            } else {
                colour_vector <- rep_len(color_map, length(label_values))
            }

            if (any(is.na(colour_vector))) {
                fallback_cols <- default_palettes()$choices$Defaults$dittoColors
                colour_vector[is.na(colour_vector)] <- rep_len(fallback_cols, sum(is.na(colour_vector)))
            }

            fig <- piePlot(
                df = d,
                labels = label_col,
                values = value_col,
                colors = colour_vector,
                hole = isolate_fn(input$hole),
                textinfo = textinfo,
                textposition = textposition,
                insidetextorientation = isolate_fn(input$insidetextorientation),
                sort = isTRUE(isolate_fn(input$sort.slices)),
                direction = isolate_fn(input$direction),
                rotation = isolate_fn(input$rotation),
                show.legend = isTRUE(isolate_fn(input$show.legend)),
                legend.orientation = isolate_fn(input$legend.orientation),
                legend.font.family = isolate_fn(input$legend.font.family),
                legend.font.size = isolate_fn(input$legend.font.size),
                legend.font.color = isolate_fn(input$legend.font.color),
                title.font.family = isolate_fn(input$title.font.family),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.color = isolate_fn(input$title.font.color),
                title.x = isolate_fn(input$title.x),
                text.font.family = isolate_fn(input$text.font.family),
                text.font.size = isolate_fn(input$text.font.size),
                text.font.color = isolate_fn(input$text.font.color),
                slice.line.color = isolate_fn(input$slice.line.color),
                slice.line.width = isolate_fn(input$slice.line.width)
            )

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$piePlot <- renderPlotly({
            generate_pieplot()
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot = generate_pieplot(),
            filename_base = "pieplot"
        )
    })
}
