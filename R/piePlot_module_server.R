#' Server logic for piePlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Provide a
#'   summarized table with columns for labels and aggregated values. Values that
#'   are not data frames are coerced with [as.data.frame()]; a `NULL` value is
#'   treated as "not ready yet" and the module waits for data.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function. An entry may also be a
#'   [shiny::reactive()] or [shiny::reactiveVal()], in which case the input tracks it as the
#'   parent app's state changes; see [setup_reactive_defaults()].
#' @return The `moduleServer` function for the piePlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom colourpicker updateColourInput
#' @importFrom stats na.omit
#' @importFrom shinyjs hide delay
#'
#' @seealso [VizModules::piePlot()], [VizModules::piePlotInputsUI()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data <- .require_data_frame(data)
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)

        # Hide individual inputs/tabs if specified. The inputs UI is injected by the
        # parent app via renderUI (and re-injected when the dataset changes), so the
        # hiding must be (re)applied after the controls exist in the DOM rather than
        # once at module initialization.
        if (!is.null(hide.inputs) || !is.null(hide.tabs)) {
            observeEvent(data(), {
                delay(100, {
                    hide_input(session, hide.inputs)
                    for (tab.name in hide.tabs) hideTab(inputId = "piePlotTabsetPanel", target = tab.name)
                })
            })
        }
        ns <- session$ns

        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]

        # Persist manual legend/annotation/colorbar repositioning across rebuilds.
        plot_source <- session$ns("pie")
        edit_store <- setup_manual_edits(input, session, plot_source)

        slice_levels <- reactive({
            d <- data_reactive()
            lbl <- input$labels
            if (is.null(d) || is.null(lbl) || !nzchar(lbl) || !lbl %in% names(d)) {
                return(character(0))
            }
            unique(na.omit(as.character(d[[lbl]])))
        })

        output$color.picker <- renderUI({
            groups <- slice_levels()
            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(resolve_palette(
                groups, input$slice.colors, default_palette_values,
                .default_group_colors(defaults, "slice.colors")
            ))

            multiColorPicker(
                ns("slice.colors"),
                label = "Slice colors",
                groups = groups,
                selected_palette = "dittoColors",
                colors = initial_colors,
                compact = TRUE
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data_reactive())[vapply(data_reactive(), is.numeric, logical(1))])
            char.choices <- c("", names(data_reactive())[!vapply(data_reactive(), is.numeric, logical(1))])

            # Data
            update_viz_select(session, "labels",
                selected = get_default(defaults, "labels", char.choices[2], function(x) x %in% char.choices))
            update_viz_select(session, "values",
                selected = get_default(defaults, "values", numeric.data[2], function(x) x %in% numeric.data))

            # Slice layout
            updateCheckboxInput(session, "sort.slices",
                value = get_default(defaults, "sort.slices", TRUE, is.logical))
            update_viz_select(session, "direction",
                selected = get_default(defaults, "direction", "counterclockwise"))
            updateSliderInput(session, "rotation", value = get_default(defaults, "rotation", 0, is.numeric))
            updateSliderInput(session, "hole", value = get_default(defaults, "hole", 0, is.numeric))

            # Text
            update_viz_select(session, "textinfo",
                selected = get_default(defaults, "textinfo", c("label", "percent")))
            update_viz_select(session, "textposition",
                selected = get_default(defaults, "textposition", "auto"))
            update_viz_select(session, "insidetextorientation",
                selected = get_default(defaults, "insidetextorientation", "auto"))
            updateNumericInput(session, "text.font.size",
                value = get_default(defaults, "text.font.size", 12, is.numeric))
            update_viz_select(session, "text.font.family",
                selected = get_default(defaults, "text.font.family", "Arial"))
            updateColourInput(session, "text.font.color",
                value = get_default(defaults, "text.font.color", "#000000"))

            # Title
            updateSliderInput(session, "title.x", value = get_default(defaults, "title.x", 0.5, is.numeric))
            updateNumericInput(session, "title.font.size",
                value = get_default(defaults, "title.font.size", 28, is.numeric))
            update_viz_select(session, "title.font.family",
                selected = get_default(defaults, "title.font.family", "Arial"))
            updateColourInput(session, "title.font.color",
                value = get_default(defaults, "title.font.color", "#000000"))

            # Legend
            updateCheckboxInput(session, "show.legend",
                value = get_default(defaults, "show.legend", TRUE, is.logical))
            update_viz_select(session, "legend.orientation",
                selected = get_default(defaults, "legend.orientation", "h"))
            update_viz_select(session, "legend.font.family",
                selected = get_default(defaults, "legend.font.family", "Arial"))
            updateNumericInput(session, "legend.font.size",
                value = get_default(defaults, "legend.font.size", 12, is.numeric))
            updateColourInput(session, "legend.font.color",
                value = get_default(defaults, "legend.font.color", "#000000"))

            # Slice borders
            updateColourInput(session, "slice.line.color",
                value = get_default(defaults, "slice.line.color", "#FFFFFF"))
            updateNumericInput(session, "slice.line.width",
                value = get_default(defaults, "slice.line.width", 0, is.numeric))

            # Slice colors
            .reset_group_colors(session, "slice.colors", defaults, slice_levels(), default_palette_values)

            reset_plotly_inputs(session, defaults)
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
            isolate_fn <- setup_auto_update_logic(input, params)

            d <- data_reactive()

            label_col <- isolate_fn(input$labels)
            value_col <- isolate_fn(input$values)

            textinfo <- build_textinfo(isolate_fn(input$textinfo))
            textposition <- isolate_fn(input$textposition)
            if (identical(textinfo, "none")) {
                textposition <- "none"
            }

            label_values <- as.character(d[[label_col]])
            slice_levels <- unique(label_values)
            color_map <- resolve_palette(
                slice_levels,
                isolate_fn(input$slice.colors),
                default_palette_values,
                .default_group_colors(defaults, "slice.colors")
            )
            colour_vector <- unname(color_map[match(label_values, names(color_map))])

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

            config_list <- add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- apply_plotly_newshape(fig, input, isolate_fn)

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
                fig <- empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- apply_render_margins(generate_piePlot(), input)
            }

            fig <- finalize_manual_edits(fig, plot_source, edit_store, session)

            return(fig)
        })

        # Download handler for source (plot + data)
        # Capture all UI inputs for the source download
        AllInputs <- reactive({
            x <- reactiveValuesToList(input)
            return(x)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_piePlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "piePlot_source"
        )

        return(plot_source_reactive)
    })
}
