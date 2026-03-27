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
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#' @return The `moduleServer` function for the piePlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom colourpicker updateColourInput
#' @importFrom stats na.omit
#' @importFrom shinyjs hide
#'
#' @seealso [VizModules::piePlot()], [VizModules::piePlotInputsUI()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "piePlotTabsetPanel", target = tab.name)
        }
        ns <- session$ns

        output$color.picker <- renderUI({
            d <- data_reactive()
            lbl <- input$labels
            req(!is.null(lbl), lbl %in% names(d))

            groups <- unique(na.omit(as.character(d[[lbl]])))
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
            updateSelectInput(session, "labels",
                selected = .get_default(defaults, "labels", char.choices[2], function(x) x %in% char.choices))
            updateSelectInput(session, "values",
                selected = .get_default(defaults, "values", numeric.data[2], function(x) x %in% numeric.data))

            # Slice layout
            updateCheckboxInput(session, "sort.slices",
                value = .get_default(defaults, "sort.slices", TRUE, is.logical))
            updateSelectInput(session, "direction",
                selected = .get_default(defaults, "direction", "counterclockwise"))
            updateSliderInput(session, "rotation", value = .get_default(defaults, "rotation", 0, is.numeric))
            updateSliderInput(session, "hole", value = .get_default(defaults, "hole", 0, is.numeric))

            # Text
            updateSelectInput(session, "textinfo",
                selected = .get_default(defaults, "textinfo", c("label", "percent")))
            updateSelectInput(session, "textposition",
                selected = .get_default(defaults, "textposition", "auto"))
            updateSelectInput(session, "insidetextorientation",
                selected = .get_default(defaults, "insidetextorientation", "auto"))
            updateNumericInput(session, "text.font.size",
                value = .get_default(defaults, "text.font.size", 12, is.numeric))
            updateSelectInput(session, "text.font.family",
                selected = .get_default(defaults, "text.font.family", "Arial"))
            updateColourInput(session, "text.font.color",
                value = .get_default(defaults, "text.font.color", "#000000"))

            # Title
            updateSliderInput(session, "title.x", value = .get_default(defaults, "title.x", 0.5, is.numeric))
            updateNumericInput(session, "title.font.size",
                value = .get_default(defaults, "title.font.size", 28, is.numeric))
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

            # Slice borders
            updateColourInput(session, "slice.line.color",
                value = .get_default(defaults, "slice.line.color", "#FFFFFF"))
            updateNumericInput(session, "slice.line.width",
                value = .get_default(defaults, "slice.line.width", 0, is.numeric))

            # Slice colors
            updateMultiColorPicker(session, "slice.colors", palette = "dittoColors")

            .reset_plotly_inputs(session, defaults)
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
        generate_piePlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()

            label_col <- isolate_fn(input$labels)
            value_col <- isolate_fn(input$values)

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

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$piePlot <- renderPlotly({
            req(data_reactive(), input$labels, input$values)

            d <- data_reactive()
            label_col <- input$labels
            value_col <- input$values

            return_empty <- FALSE
            txt <- c()

            if (!label_col %in% names(d)) {
                return_empty <- TRUE
                txt <- c(txt, "Select a label column for the slices.")
            }

            if (!value_col %in% names(d)) {
                return_empty <- TRUE
                txt <- c(txt, "Select a numeric column for slice values.")
            } else if (!is.numeric(d[[value_col]])) {
                return_empty <- TRUE
                txt <- c(txt, "The value column must contain numeric, aggregated data.")
            }

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_piePlot() |>
                    layout(
                        margin = list(
                            t = input$margin.t,
                            b = input$margin.b,
                            l = input$margin.l,
                            r = input$margin.r,
                            autoexpand = TRUE
                        )
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_piePlot,
            filename_base = "piePlot"
        )
    })
}
