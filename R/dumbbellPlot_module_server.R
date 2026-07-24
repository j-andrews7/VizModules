#' Server logic for dumbbellPlot module
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
#' @return The `moduleServer` function for the dumbbellPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom stats na.omit
#' @importFrom colourpicker updateColourInput
#' @importFrom shinyjs hide click delay
#'
#' @seealso [VizModules::dumbbellPlot()], [VizModules::dumbbellPlotInputsUI()],
#' [VizModules::dumbbellPlotOutputUI()], [VizModules::dumbbellPlotApp()]
#'
#' @export
#' @author Jacob Martin
dumbbellPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
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
                    for (tab.name in hide.tabs) hideTab(inputId = "dumbbellPlotTabsetPanel", target = tab.name)
                })
            })
        }

        ns <- session$ns

        # Persist manual legend/annotation/colorbar repositioning across rebuilds.
        plot_source <- session$ns("dumbbell")
        edit_store <- setup_manual_edits(input, session, plot_source)

        default_palette_name <- "dittoColors"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        palette_groups <- reactive({
            df <- data_reactive()
            if (is.null(df)) {
                return(character(0))
            }

            x_vals <- input$x.value
            y_val <- input$y.value
            colour_by <- input$colour.by

            # Ensure max 2 x values
            if (!is.null(x_vals) && length(x_vals) > 2) {
                x_vals <- x_vals[1:2]
            }

            if (!is.null(colour_by) && colour_by == "X variables") {
                # Color by X variables
                if (!is.null(x_vals) && length(x_vals) > 0) {
                    return(x_vals)
                }
            } else {
                # Color by Y variables
                if (!is.null(y_val) && nzchar(y_val) && y_val %in% names(df)) {
                    return(unique(na.omit(as.character(df[[y_val]]))))
                }
            }

            character(0)
        })

        # Enforce max 2 x values
        observeEvent(input$x.value,
            {
                if (!is.null(input$x.value) && length(input$x.value) > 2) {
                    updateSelectInput(session, "x.value", selected = input$x.value[1:2])
                }
            },
            ignoreNULL = FALSE
        )

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

        # Reset functionality
        observeEvent(input$reset, {
            choices <- c("", names(data()))

            # Get numeric variables of data.
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])
            cat.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])

            # Reset Data columns to default. First and second index of data named list

            # Data tab
            updateSelectInput(session, "x.value",
                selected = get_default(defaults, "x.value", num.choices[2], function(x) all(x %in% num.choices))
            )
            updateSelectInput(session, "y.value",
                selected = get_default(defaults, "y.value", cat.choices[2], function(x) all(x %in% cat.choices))
            )

            updateSelectInput(session, "x.adjustment", selected = get_default(defaults, "x.adjustment", ""))
            updateSelectInput(session, "colour.by",
                selected = get_default(defaults, "colour.by", "X variables")
            )

            # Facet tab
            updateSelectInput(session, "facet.by",
                selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% cat.choices)
            )
            updateSelectInput(session, "facet.scales", selected = get_default(defaults, "facet.scales", "fixed"))

            # Aesthetics tab
            updateColourInput(session, "line.colour",
                value = get_default(defaults, "line.colour", "gray30")
            )

            click("reset_palette")


            # Axes
            reset_axes_inputs(session, defaults)

            # Plotly
            reset_plotly_inputs(session, defaults)
            reset_legend_inputs(session, defaults)

            # Lines
            reset_lines_inputs(session, defaults = defaults)
        })

        observeEvent(input$facet.by, {
            if (!input$facet.by == "") {
                .show_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            } else {
                .hide_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            }
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_dumbbellPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()

            x_input <- isolate_fn(input$x.value)
            y_input <- isolate_fn(input$y.value)

            # Ensure max 2 x values
            if (!is.null(x_input) && length(x_input) > 2) {
                x_input <- x_input[1:2]
            }

            # Sets the colouring based on colour.by selection
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )

            palette_selection <- unname(palette_values)
            if (is.null(palette_selection) || length(palette_selection) == 0) {
                palette_selection <- default_palette_values
            }

            colour_by <- isolate_fn(input$colour.by)

            # Axis title:
            x_title <- if (length(x_input) == 1) x_input[1] else "Value"
            y_title <- y_input

            x.adjustment <- NULL
            if (!isolate_fn(input$x.adjustment) == "") {
                x.adjustment <- isolate_fn(input$x.adjustment)
            }

            # Checking that all columns are numeric for x adjustment to be available
            if (!is.null(x_input) && length(x_input) > 0 && !all(vapply(d[x_input], is.numeric, logical(1)))) {
                updateSelectInput(session, "x.adjustment", selected = "")
                x.adjustment <- NULL
            }

            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            fig <- dumbbellPlot(
                data = d,
                x = x_input,
                y = y_input,
                line.colour = isolate_fn(input$line.colour),
                colour.by = colour_by,
                palette.selection = palette_selection,
                show.legend = TRUE,
                facet.by = facet.by,
                facet.scales = isolate_fn(input$facet.scales),
                subplot.margin = c(isolate_fn(input$subplot.margin.x), isolate_fn(input$subplot.margin.y)),
                axis.showline = isolate_fn(input$axis.showline),
                axis.mirror = isolate_fn(input$axis.mirror),
                axis.linecolor = isolate_fn(input$axis.linecolor),
                axis.linewidth = isolate_fn(input$axis.linewidth),
                axis.tickfont.size = isolate_fn(input$axis.tickfont.size),
                axis.tickfont.color = isolate_fn(input$axis.tickfont.color),
                axis.tickfont.family = isolate_fn(input$axis.tickfont.family),
                axis.tickangle.x = isolate_fn(input$axis.tickangle.x),
                axis.tickangle.y = isolate_fn(input$axis.tickangle.y),
                axis.ticks = isolate_fn(input$axis.ticks),
                axis.tickcolor = isolate_fn(input$axis.tickcolor),
                axis.ticklen = isolate_fn(input$axis.ticklen),
                axis.tickwidth = isolate_fn(input$axis.tickwidth),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.family = isolate_fn(input$title.font.family),
                title.font.color = isolate_fn(input$title.font.color),
                title.x.position = isolate_fn(input$axis.title.horizontal.position),
                x.title = x_title,
                y.title = y_title,
                flip.x = isolate_fn(input$flip.x),
                flip.y = isolate_fn(input$flip.y),
                x.adjustment = x.adjustment
            )

            # Apply axis title font to shared facet annotation titles
            if (!is.null(facet.by) && nzchar(facet.by)) {
                fig <- apply_axis_title_to_annotations(fig, input, isolate_fn)
            }

            # Add reference lines
            fig <- add_reference_lines(fig,
                hline.intercepts = isolate_fn(input$hline.intercepts),
                hline.colors = isolate_fn(input$hline.colors),
                hline.widths = isolate_fn(input$hline.widths),
                hline.linetypes = isolate_fn(input$hline.linetypes),
                hline.opacities = isolate_fn(input$hline.opacities),
                vline.intercepts = isolate_fn(input$vline.intercepts),
                vline.colors = isolate_fn(input$vline.colors),
                vline.widths = isolate_fn(input$vline.widths),
                vline.linetypes = isolate_fn(input$vline.linetypes),
                vline.opacities = isolate_fn(input$vline.opacities),
                abline.slopes = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors = isolate_fn(input$abline.colors),
                abline.widths = isolate_fn(input$abline.widths),
                abline.linetypes = isolate_fn(input$abline.linetypes),
                abline.opacities = isolate_fn(input$abline.opacities)
            )

            config_list <- add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = FALSE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- apply_plotly_newshape(fig, input, isolate_fn)

            # Apply uniform legend title/label font sizes
            fig <- apply_legend_styling(
                fig,
                title.size = isolate_fn(input$legend.title.size),
                text.size = isolate_fn(input$legend.text.size)
            )

            # Make single-panel x/y axis titles draggable (matches faceted behaviour)
            fig <- axis_titles_as_annotations(fig)

            return(fig)
        })

        # Render the plot output
        output$dumbbellPlot <- renderPlotly({
            req(input$x.value, input$y.value)

            fig <- apply_render_margins(generate_dumbbellPlot(), input)

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
                plot_reactive = generate_dumbbellPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "dumbbellPlot_source"
        )

        return(plot_source_reactive)
    })
}
