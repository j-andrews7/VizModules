#' Server logic for radarPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Provide data with
#'   columns for categories (theta) and values (r). For multiple traces, include
#'   a grouping column.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the radarPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#'
#' @seealso [VizModules::radarPlot()], [VizModules::radarPlotInputsUI()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotApp()]
#'
#' @export
#' @author Jacob Martin
radarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "radarPlotTabsetPanel", target = tab.name)
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
            cat.choices <- c("", names(data_reactive())[!vapply(data_reactive(), is.numeric, logical(1))])
            all.choices <- c("", names(data_reactive()))

            # Data
            updateSelectInput(session, "theta", selected = cat.choices[2])
            updateSelectInput(session, "r", selected = numeric.data[2])
            updateSelectInput(session, "group", selected = "")

            # Trace style
            updateSelectInput(session, "fill", selected = "toself")
            updateNumericInput(session, "line.width", value = 2)
            updateSelectInput(session, "line.dash", selected = "solid")
            updateNumericInput(session, "marker.size", value = 5)
            updateSelectInput(session, "marker.symbol", selected = "circle")
            updateSliderInput(session, "opacity", value = 0.6)

            # Radial axis
            updateCheckboxInput(session, "radial.visible", value = TRUE)
            updateCheckboxInput(session, "auto.radial.range", value = TRUE)
            updateNumericInput(session, "radial.min", value = 0)
            updateNumericInput(session, "radial.max", value = 100)
            updateCheckboxInput(session, "radial.showline", value = TRUE)
            colourpicker::updateColourInput(session, "radial.linecolor", value = "#444444")
            colourpicker::updateColourInput(session, "radial.gridcolor", value = "#EEEEEE")

            # Angular axis
            updateSelectInput(session, "angular.direction", selected = "clockwise")
            updateSliderInput(session, "angular.rotation", value = 90)
            colourpicker::updateColourInput(session, "angular.gridcolor", value = "#EEEEEE")

            # Title
            updateSliderInput(session, "title.x", value = 0.5)
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
            colourpicker::updateColourInput(session, "polar.bgcolor", value = "#FFFFFF")
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_radarPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()
            req(nrow(d) > 0)

            theta_col <- isolate_fn(input$theta)
            r_col <- isolate_fn(input$r)
            group_col <- isolate_fn(input$group)

            validate(
                need(
                    !is.null(theta_col) && theta_col %in% names(d),
                    "Select a category column for theta (angular axes)."
                ),
                need(
                    !is.null(r_col) && r_col %in% names(d),
                    "Select a numeric column for r (radial values)."
                ),
                need(is.numeric(d[[r_col]]), "The r column must contain numeric data.")
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

            # Handle radial range
            radial_range <- NULL
            if (!isTRUE(isolate_fn(input$auto.radial.range))) {
                radial_range <- c(
                    isolate_fn(input$radial.min),
                    isolate_fn(input$radial.max)
                )
            }

            # Convert fill value
            fill_val <- isolate_fn(input$fill)
            if (fill_val == "none") {
                fill_val <- FALSE
            }

            fig <- radarPlot(
                df = d,
                theta = theta_col,
                r = r_col,
                group = group_col,
                colors = color_map,
                fill = fill_val,
                line.width = isolate_fn(input$line.width),
                line.dash = isolate_fn(input$line.dash),
                marker.size = isolate_fn(input$marker.size),
                marker.symbol = isolate_fn(input$marker.symbol),
                opacity = isolate_fn(input$opacity),
                radial.visible = isTRUE(isolate_fn(input$radial.visible)),
                radial.range = radial_range,
                radial.showline = isTRUE(isolate_fn(input$radial.showline)),
                radial.linecolor = isolate_fn(input$radial.linecolor),
                radial.gridcolor = isolate_fn(input$radial.gridcolor),
                angular.direction = isolate_fn(input$angular.direction),
                angular.rotation = isolate_fn(input$angular.rotation),
                angular.gridcolor = isolate_fn(input$angular.gridcolor),
                show.legend = isTRUE(isolate_fn(input$show.legend)),
                legend.orientation = isolate_fn(input$legend.orientation),
                legend.font.family = isolate_fn(input$legend.font.family),
                legend.font.size = isolate_fn(input$legend.font.size),
                legend.font.color = isolate_fn(input$legend.font.color),
                title.font.family = isolate_fn(input$title.font.family),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.color = isolate_fn(input$title.font.color),
                title.x = isolate_fn(input$title.x),
                bgcolor = isolate_fn(input$bgcolor),
                polar.bgcolor = isolate_fn(input$polar.bgcolor)
            )

            config_list <- .add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = TRUE
            )
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$radarPlot <- renderPlotly({
            
            generate_radarPlot() |>
                layout(
                    margin = list(t = 100, l = 90, r = 90, b = 100, autoexpand = TRUE)
                )
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_radarPlot,
            filename_base = "radarPlot"
        )
    })
}
