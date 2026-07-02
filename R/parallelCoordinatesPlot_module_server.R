#' Server logic for parallelCoordinatesPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#' @return The `moduleServer` function for the parallelCoordinatesPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom colourpicker updateColourInput
#' @importFrom shinyjs hide show click delay
#'
#' @seealso [VizModules::parallelCoordinatesPlot()], [VizModules::parallelCoordinatesPlotInputsUI()],
#' [VizModules::parallelCoordinatesPlotOutputUI()], [VizModules::parallelCoordinatesPlotApp()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
parallelCoordinatesPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs/tabs if specified. The inputs UI is injected by the
        # parent app via renderUI (and re-injected when the dataset changes), so the
        # hiding must be (re)applied after the controls exist in the DOM rather than
        # once at module initialization.
        if (!is.null(hide.inputs) || !is.null(hide.tabs)) {
            observeEvent(data(), {
                delay(100, {
                    .hide_input(session, hide.inputs)
                    for (tab.name in hide.tabs) hideTab(inputId = "parallelCoordinatesPlotTabsetPanel", target = tab.name)
                })
            })
        }

        ns <- session$ns

        # Persist manual legend/annotation/colorbar repositioning across rebuilds.
        plot_source <- session$ns("parcoords")
        edit_store <- setup_manual_edits(input, session, plot_source)

        default_palette_name <- "dittoColors"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        # Determine palette groups from a categorical color.by selection
        palette_groups <- reactive({
            df <- data_reactive()
            if (is.null(df)) {
                return(character(0))
            }
            color_by <- input$color.by
            if (is.null(color_by) || !nzchar(color_by) || !(color_by %in% names(df))) {
                return(character(0))
            }
            vals <- df[[color_by]]
            if (is.numeric(vals)) {
                return(character(0))
            }
            sort(unique(na.omit(as.character(vals))))
        })

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(resolve_palette(groups, input$palette.colours, default_palette_values))

            multiColorPicker(
                ns("palette.colours"),
                label = "Plot colors",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = default_palette_name,
                colors = initial_colors,
                compact = TRUE
            )
        })

        # The continuous color scale only applies to numeric color.by. For a
        # categorical color.by the discrete palette picker is used instead, so
        # hide the color scale selector to avoid an irrelevant, no-op control.
        observeEvent(input$color.by, {
            if (!is.null(hide.inputs) && "color.scale" %in% hide.inputs) {
                return()
            }
            if (length(palette_groups()) > 0) {
                .hide_input(session, "color.scale")
            } else {
                .show_input(session, "color.scale")
            }
        }, ignoreNULL = FALSE)

        # Reset functionality
        observeEvent(input$reset, {
            d <- data_reactive()
            all.choices <- c("", names(d))
            updateSelectInput(session, "dimensions",
                selected = get_default(defaults, "dimensions", names(d), function(x) all(x %in% names(d)))
            )
            updateSelectInput(session, "color.by",
                selected = get_default(defaults, "color.by", "", function(x) x == "" || x %in% all.choices)
            )
            updateSelectInput(session, "color.scale",
                selected = get_default(defaults, "color.scale", "Viridis")
            )
            updateSliderInput(session, "line.opacity",
                value = get_default(defaults, "line.opacity", 0.5, is.numeric)
            )
            updateNumericInput(session, "line.width",
                value = get_default(defaults, "line.width", 1, is.numeric)
            )
            updateCheckboxInput(session, "show.colorbar",
                value = get_default(defaults, "show.colorbar", TRUE, is.logical)
            )
            updateNumericInput(session, "label.font.size",
                value = get_default(defaults, "label.font.size", 12, is.numeric)
            )
            updateColourInput(session, "label.font.color",
                value = get_default(defaults, "label.font.color", "black")
            )
            updateSelectInput(session, "label.font.family",
                selected = get_default(defaults, "label.font.family", "Arial")
            )
            updateNumericInput(session, "tick.font.size",
                value = get_default(defaults, "tick.font.size", 10, is.numeric)
            )
            updateColourInput(session, "tick.font.color",
                value = get_default(defaults, "tick.font.color", "black")
            )
            updateSelectInput(session, "tick.font.family",
                selected = get_default(defaults, "tick.font.family", "Arial")
            )
            updateNumericInput(session, "title.font.size",
                value = get_default(defaults, "title.font.size", 16, is.numeric)
            )
            updateSelectInput(session, "title.font.family",
                selected = get_default(defaults, "title.font.family", "Arial")
            )
            updateColourInput(session, "title.font.color",
                value = get_default(defaults, "title.font.color", "#000000")
            )
            updateColourInput(session, "bgcolor",
                value = get_default(defaults, "bgcolor", "#FFFFFF")
            )

            click("reset_palette")

            .reset_plotly_inputs(session, defaults)
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_parallelCoordinatesPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()

            dims <- isolate_fn(input$dimensions)

            # Filter to valid columns
            dims <- dims[dims %in% names(d)]

            color.by <- isolate_fn(input$color.by)
            if (is.null(color.by) || !nzchar(color.by)) {
                color.by <- NULL
            }

            # Resolve discrete palette colors for categorical color.by
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )

            palette_selection <- palette_values
            if (!is.null(palette_selection) && length(palette_selection) == 0) {
                palette_selection <- NULL
            }

            fig <- parallelCoordinatesPlot(
                data = d,
                dimensions = dims,
                color.by = color.by,
                color.scale = isolate_fn(input$color.scale),
                palette.selection = palette_selection,
                line.opacity = isolate_fn(input$line.opacity),
                line.width = isolate_fn(input$line.width),
                show.colorbar = isTRUE(isolate_fn(input$show.colorbar)),
                label.font.size = isolate_fn(input$label.font.size),
                label.font.color = isolate_fn(input$label.font.color),
                label.font.family = isolate_fn(input$label.font.family),
                tick.font.size = isolate_fn(input$tick.font.size),
                tick.font.color = isolate_fn(input$tick.font.color),
                tick.font.family = isolate_fn(input$tick.font.family),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.family = isolate_fn(input$title.font.family),
                title.font.color = isolate_fn(input$title.font.color),
                bgcolor = isolate_fn(input$bgcolor)
            )

            config_list <- add_plot_config(
                download.format = isolate_fn(input$download.format),
                include.modebar.buttons = FALSE
            )
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$parallelCoordinatesPlot <- renderPlotly({
            req(data_reactive(), input$dimensions)

            d <- data_reactive()
            dims <- input$dimensions
            dims <- dims[dims %in% names(d)]

            return_empty <- FALSE
            txt <- c()

            if (length(dims) < 2) {
                return_empty <- TRUE
                txt <- c(txt, "Please select at least two valid dimension columns.")
            }

            if (return_empty) {
                fig <- empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- .apply_render_margins(generate_parallelCoordinatesPlot(), input)
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
                plot_reactive = generate_parallelCoordinatesPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "parallelCoordinatesPlot_source"
        )

        return(plot_source_reactive)
    })
}
