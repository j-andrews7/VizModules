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
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#' @return The `moduleServer` function for the ternaryPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom stats na.omit setNames
#' @importFrom colourpicker updateColourInput colourInput
#'
#' @seealso [VizModules::ternaryPlot()], [VizModules::ternaryPlotInputsUI()],
#' [VizModules::ternaryPlotOutputUI()], [VizModules::ternaryPlotApp()]
#'
#' @export
#' @author Jacob Martin
ternaryPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
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
            all.choices <- c("", names(data_reactive()))

            # Set default selections for a, b, c axes (first 3 numeric columns)
            default_a <- if (length(numeric.data) > 1) numeric.data[2] else ""
            default_b <- if (length(numeric.data) > 2) numeric.data[3] else ""
            default_c <- if (length(numeric.data) > 3) numeric.data[4] else ""

            # Data
            updateSelectInput(session, "a",
                selected = .get_default(defaults, "a", default_a, function(x) x == "" || x %in% numeric.data))
            updateSelectInput(session, "b",
                selected = .get_default(defaults, "b", default_b, function(x) x == "" || x %in% numeric.data))
            updateSelectInput(session, "c",
                selected = .get_default(defaults, "c", default_c, function(x) x == "" || x %in% numeric.data))
            updateSelectInput(session, "group",
                selected = .get_default(defaults, "group", "", function(x) x == "" || x %in% all.choices))
            updateNumericInput(session, "sum", value = .get_default(defaults, "sum", 100, is.numeric))

            # Trace style
            updateSelectInput(session, "mode", selected = .get_default(defaults, "mode", "markers"))
            updateNumericInput(session, "marker.size",
                value = .get_default(defaults, "marker.size", 8, is.numeric))
            updateSelectInput(session, "marker.symbol",
                selected = .get_default(defaults, "marker.symbol", "circle"))
            updateNumericInput(session, "marker.line.width",
                value = .get_default(defaults, "marker.line.width", 0, is.numeric))
            updateColourInput(session, "marker.line.color",
                value = .get_default(defaults, "marker.line.color", "#000000"))
            updateNumericInput(session, "line.width", value = .get_default(defaults, "line.width", 2, is.numeric))
            updateSelectInput(session, "line.dash", selected = .get_default(defaults, "line.dash", "solid"))
            updateSliderInput(session, "opacity", value = .get_default(defaults, "opacity", 1, is.numeric))

            # Axes
            updateTextInput(session, "a.title", value = .get_default(defaults, "a.title", ""))
            updateTextInput(session, "b.title", value = .get_default(defaults, "b.title", ""))
            updateTextInput(session, "c.title", value = .get_default(defaults, "c.title", ""))
            updateNumericInput(session, "a.titlefont.size",
                value = .get_default(defaults, "a.titlefont.size", 16, is.numeric))
            updateNumericInput(session, "b.titlefont.size",
                value = .get_default(defaults, "b.titlefont.size", 16, is.numeric))
            updateNumericInput(session, "c.titlefont.size",
                value = .get_default(defaults, "c.titlefont.size", 16, is.numeric))
            updateColourInput(session, "a.gridcolor",
                value = .get_default(defaults, "a.gridcolor", "#EEEEEE"))
            updateColourInput(session, "b.gridcolor",
                value = .get_default(defaults, "b.gridcolor", "#EEEEEE"))
            updateColourInput(session, "c.gridcolor",
                value = .get_default(defaults, "c.gridcolor", "#EEEEEE"))

            # Title
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

            .reset_plotly_inputs(session, defaults)
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
                    color_map <- setNames(
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
                    margin = list(
                        t = input$margin.t,
                        b = input$margin.b,
                        l = input$margin.l,
                        r = input$margin.r,
                        autoexpand = TRUE
                    )
                )
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_ternaryPlot,
            filename_base = "ternaryPlot"
        )
    })
}
