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
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#' @return The `moduleServer` function for the radarPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom colourpicker colourInput updateColourInput
#' @importFrom stats na.omit
#'
#' @seealso [VizModules::radarPlot()], [VizModules::radarPlotInputsUI()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotApp()]
#'
#' @export
#' @author Jacob Martin
radarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
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
                    colourInput(ns("single.color"), "Trace color:",
                        value = "#1F77B4"
                    )
                ))
            }

            groups <- unique(na.omit(as.character(d[[grp]])))
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
            updateSelectInput(session, "theta",
                selected = .get_default(defaults, "theta", cat.choices[2], function(x) x %in% cat.choices))
            updateSelectInput(session, "r",
                selected = .get_default(defaults, "r", numeric.data[2], function(x) x %in% numeric.data))
            updateSelectInput(session, "group",
                selected = .get_default(defaults, "group", "", function(x) x == "" || x %in% all.choices))

            # Trace style
            updateSelectInput(session, "fill", selected = .get_default(defaults, "fill", "toself"))
            updateNumericInput(session, "line.width", value = .get_default(defaults, "line.width", 2, is.numeric))
            updateSelectInput(session, "line.dash", selected = .get_default(defaults, "line.dash", "solid"))
            updateNumericInput(session, "marker.size",
                value = .get_default(defaults, "marker.size", 5, is.numeric))
            updateSelectInput(session, "marker.symbol",
                selected = .get_default(defaults, "marker.symbol", "circle"))
            updateSliderInput(session, "opacity", value = .get_default(defaults, "opacity", 0.6, is.numeric))

            # Radial axis
            updateCheckboxInput(session, "radial.visible",
                value = .get_default(defaults, "radial.visible", TRUE, is.logical))
            updateCheckboxInput(session, "auto.radial.range",
                value = .get_default(defaults, "auto.radial.range", TRUE, is.logical))
            updateNumericInput(session, "radial.min",
                value = .get_default(defaults, "radial.min", 0, is.numeric))
            updateNumericInput(session, "radial.max",
                value = .get_default(defaults, "radial.max", 100, is.numeric))
            updateCheckboxInput(session, "radial.showline",
                value = .get_default(defaults, "radial.showline", TRUE, is.logical))
            updateColourInput(session, "radial.linecolor",
                value = .get_default(defaults, "radial.linecolor", "#444444"))
            updateColourInput(session, "radial.gridcolor",
                value = .get_default(defaults, "radial.gridcolor", "#EEEEEE"))

            # Angular axis
            updateSelectInput(session, "angular.direction",
                selected = .get_default(defaults, "angular.direction", "clockwise"))
            updateSliderInput(session, "angular.rotation",
                value = .get_default(defaults, "angular.rotation", 90, is.numeric))
            updateColourInput(session, "angular.gridcolor",
                value = .get_default(defaults, "angular.gridcolor", "#EEEEEE"))

            # Title
            updateSliderInput(session, "title.x", value = .get_default(defaults, "title.x", 0.5, is.numeric))
            updateNumericInput(session, "title.font.size",
                value = .get_default(defaults, "title.font.size", 18, is.numeric))
            updateSelectInput(session, "title.font.family",
                selected = .get_default(defaults, "title.font.family", "Arial"))
            updateColourInput(session, "title.font.color",
                value = .get_default(defaults, "title.font.color", "#000000"))

            # Legend
            updateCheckboxInput(session, "show.legend",
                value = .get_default(defaults, "show.legend", TRUE, is.logical))
            updateSelectInput(session, "legend.orientation",
                selected = .get_default(defaults, "legend.orientation", "h"))
            updateSelectInput(session, "legend.font.family",
                selected = .get_default(defaults, "legend.font.family", "Arial"))
            updateNumericInput(session, "legend.font.size",
                value = .get_default(defaults, "legend.font.size", 12, is.numeric))
            updateColourInput(session, "legend.font.color",
                value = .get_default(defaults, "legend.font.color", "#000000"))

            # Background
            updateColourInput(session, "bgcolor",
                value = .get_default(defaults, "bgcolor", "#FFFFFF"))
            updateColourInput(session, "polar.bgcolor",
                value = .get_default(defaults, "polar.bgcolor", "#FFFFFF"))

            .reset_plotly_inputs(session, defaults)
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_radarPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()

            theta_col <- isolate_fn(input$theta)
            r_col <- isolate_fn(input$r)
            group_col <- isolate_fn(input$group)

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
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$radarPlot <- renderPlotly({
            req(data_reactive(), input$theta, input$r)

            d <- data_reactive()
            theta_col <- input$theta
            r_col <- input$r

            return_empty <- FALSE
            txt <- c()

            if (!theta_col %in% names(d)) {
                return_empty <- TRUE
                txt <- c(txt, "Select a category column for theta (angular axes).")
            }

            if (!r_col %in% names(d)) {
                return_empty <- TRUE
                txt <- c(txt, "Select a numeric column for r (radial values).")
            } else if (!is.numeric(d[[r_col]])) {
                return_empty <- TRUE
                txt <- c(txt, "The r column must contain numeric data.")
            }

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- .apply_render_margins(generate_radarPlot(), input)
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_radarPlot,
            filename_base = "radarPlot"
        )

        # Download handler for interactive summary (plot + data)
        # Capture all UI inputs for the interactive summary download
        AllInputs <- reactive({
            x <- reactiveValuesToList(input)
            return(x)
        })

        output$download.interactive.summary <- create_interactive_summary_download_handler(
            plot_reactive = generate_radarPlot,
            inputs_reactive = AllInputs(),
            filename_base = "radarPlot_summary"
        )
    })
}
