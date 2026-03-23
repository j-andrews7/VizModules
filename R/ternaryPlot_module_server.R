#' Server logic for ternaryPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Provide data with
#'   numeric columns for the three ternary axes (a, b, c). For multiple traces, include
#'   a grouping column.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the ternaryPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#'
#' @seealso [VizModules::ternaryPlot()], [VizModules::ternaryPlotInputsUI()],
#' [VizModules::ternaryPlotOutputUI()], [VizModules::ternaryPlotApp()]
#'
#' @export
#' @author Jacob Martin
ternaryPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "ternaryPlotTabsetPanel", target = tab.name)
        }
        ns <- session$ns

        output$color.picker <- renderUI({
            d <- data_reactive()
            grp <- input$group

            # Only show color picker if group is selected
            if (is.null(grp) || grp == "" || !grp %in% names(d)) {
                return(tagList(
                    colourpicker::colourInput(ns("single.color"), "Trace color:",
                        value = "#1F77B4"
                    )
                ))
            }

            groups <- unique(stats::na.omit(as.character(d[[grp]])))
            if (length(groups) == 0) {
                return(NULL)
            }

            multiColorPicker(
                ns("trace.colors"),
                label = "Trace colors",
                groups = groups,
                selected_palette = "dittoColors",
                compact = TRUE
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data_reactive())[vapply(data_reactive(), is.numeric, logical(1))])
            all.choices <- c("", names(data_reactive()))

            # Set default selections for a, b, c axes (first 3 numeric columns)
            default_a <- if (length(numeric.data) > 1) numeric.data[2] else ""
            default_b <- if (length(numeric.data) > 2) numeric.data[3] else ""
            default_c <- if (length(numeric.data) > 3) numeric.data[4] else ""

            # Data
            updateSelectInput(session, "a", selected = default_a)
            updateSelectInput(session, "b", selected = default_b)
            updateSelectInput(session, "c", selected = default_c)
            updateSelectInput(session, "group", selected = "")
            updateNumericInput(session, "sum", value = 100)

            # Trace style
            updateSelectInput(session, "mode", selected = "markers")
            updateNumericInput(session, "marker.size", value = 8)
            updateSelectInput(session, "marker.symbol", selected = "circle")
            updateNumericInput(session, "marker.line.width", value = 0)
            colourpicker::updateColourInput(session, "marker.line.color", value = "#000000")
            updateNumericInput(session, "line.width", value = 2)
            updateSelectInput(session, "line.dash", selected = "solid")
            updateSliderInput(session, "opacity", value = 1)

            # Axes
            updateTextInput(session, "a.title", value = "")
            updateTextInput(session, "b.title", value = "")
            updateTextInput(session, "c.title", value = "")
            updateNumericInput(session, "a.titlefont.size", value = 16)
            updateNumericInput(session, "b.titlefont.size", value = 16)
            updateNumericInput(session, "c.titlefont.size", value = 16)
            colourpicker::updateColourInput(session, "a.gridcolor", value = "#EEEEEE")
            colourpicker::updateColourInput(session, "b.gridcolor", value = "#EEEEEE")
            colourpicker::updateColourInput(session, "c.gridcolor", value = "#EEEEEE")

            # Title
            updateNumericInput(session, "title.font.size", value = 18)
            updateSelectInput(session, "title.font.family", selected = "Arial")
            colourpicker::updateColourInput(session, "title.font.color", value = "#000000")

            # Legend
            updateCheckboxInput(session, "show.legend", value = TRUE)
            updateSelectInput(session, "legend.orientation", selected = "h")
            updateSelectInput(session, "legend.font.family", selected = "Arial")
            updateNumericInput(session, "legend.font.size", value = 12)
            colourpicker::updateColourInput(session, "legend.font.color", value = "#000000")

            # Background
            colourpicker::updateColourInput(session, "bgcolor", value = "#FFFFFF")

            .reset_plotly_inputs(session)
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_ternaryPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()
            req(nrow(d) > 0)

            a_col <- isolate_fn(input$a)
            b_col <- isolate_fn(input$b)
            c_col <- isolate_fn(input$c)
            group_col <- isolate_fn(input$group)

            validate(
                need(
                    !is.null(a_col) && a_col != "" && a_col %in% names(d),
                    "Select a numeric column for the a-axis."
                ),
                need(
                    !is.null(b_col) && b_col != "" && b_col %in% names(d),
                    "Select a numeric column for the b-axis."
                ),
                need(
                    !is.null(c_col) && c_col != "" && c_col %in% names(d),
                    "Select a numeric column for the c-axis."
                ),
                need(is.numeric(d[[a_col]]), "The a-axis column must contain numeric data."),
                need(is.numeric(d[[b_col]]), "The b-axis column must contain numeric data."),
                need(is.numeric(d[[c_col]]), "The c-axis column must contain numeric data.")
            )

            # Handle group column
            if (!is.null(group_col) && group_col == "") {
                group_col <- NULL
            }

            # Get colors
            color_map <- NULL
            if (is.null(group_col) || !group_col %in% names(d)) {
                # Single trace - use single color
                color_map <- isolate_fn(input$single.color)
                if (is.null(color_map)) {
                    color_map <- "#1F77B4"
                }
            } else {
                # Multiple traces - use color map
                color_map <- isolate_fn(input$trace.colors)
                if (is.null(color_map) || length(color_map) == 0) {
                    group_values <- unique(d[[group_col]])
                    default_cols <- default_palettes()$choices$Defaults$dittoColors
                    color_map <- stats::setNames(
                        rep_len(default_cols, length(group_values)),
                        group_values
                    )
                }
            }

            # Get axis titles (use column names if not specified)
            a_title <- isolate_fn(input$a.title)
            if (is.null(a_title) || a_title == "") {
                a_title <- a_col
            }

            b_title <- isolate_fn(input$b.title)
            if (is.null(b_title) || b_title == "") {
                b_title <- b_col
            }

            c_title <- isolate_fn(input$c.title)
            if (is.null(c_title) || c_title == "") {
                c_title <- c_col
            }

            fig <- ternaryPlot(
                df = d,
                a = a_col,
                b = b_col,
                c = c_col,
                group = group_col,
                colors = color_map,
                sum = isolate_fn(input$sum),
                mode = isolate_fn(input$mode),
                marker.size = isolate_fn(input$marker.size),
                marker.symbol = isolate_fn(input$marker.symbol),
                marker.line.width = isolate_fn(input$marker.line.width),
                marker.line.color = isolate_fn(input$marker.line.color),
                line.width = isolate_fn(input$line.width),
                line.dash = isolate_fn(input$line.dash),
                opacity = isolate_fn(input$opacity),
                a.title = a_title,
                b.title = b_title,
                c.title = c_title,
                a.titlefont.size = isolate_fn(input$a.titlefont.size),
                b.titlefont.size = isolate_fn(input$b.titlefont.size),
                c.titlefont.size = isolate_fn(input$c.titlefont.size),
                a.gridcolor = isolate_fn(input$a.gridcolor),
                b.gridcolor = isolate_fn(input$b.gridcolor),
                c.gridcolor = isolate_fn(input$c.gridcolor),
                show.legend = isTRUE(isolate_fn(input$show.legend)),
                legend.orientation = isolate_fn(input$legend.orientation),
                legend.font.family = isolate_fn(input$legend.font.family),
                legend.font.size = isolate_fn(input$legend.font.size),
                legend.font.color = isolate_fn(input$legend.font.color),
                title.font.family = isolate_fn(input$title.font.family),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.color = isolate_fn(input$title.font.color),
                bgcolor = isolate_fn(input$bgcolor)
            )

            config_list <- .add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$ternaryPlot <- renderPlotly({
            
            generate_ternaryPlot() |>  
                layout(
                    margin = list(t = input$margin.t, b = input$margin.b, l = input$margin.l, r = input$margin.r, autoexpand = TRUE)
                )
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_ternaryPlot,
            filename_base = "ternaryPlot"
        )
    })
}
