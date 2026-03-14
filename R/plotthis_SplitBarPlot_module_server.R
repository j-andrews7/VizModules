#' Server logic for SplitBarPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#'
#' @return The `moduleServer` function for the SplitBarPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide show
#' 
#' @export
#'
#' @seealso [plotthis::SplitBarPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_SplitBarPlotInputsUI()], [VizModules::plotthis_SplitBarPlotOutputUI()],
#' [VizModules::plotthis_SplitBarPlotApp()]
#'
#' @author Jacob Martin, Jared Andrews
plotthis_SplitBarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Constant for y-axis scaling to ensure highest bar reaches ~85% of chart height

        axis_scale <- reactive({
            axis_scale_factor <- input$axis.scale.factor
        })
        #Initial call of .calculate_range() made into a reactive to be used later on in server 
        axis_range <- reactive({
            return(.calculate_range(
                        df                = data(),
                        data_col_x        = input$y.data,
                        data_col_y        = input$x.data,
                        axis_scale_factor = axis_scale(),
                        grouping          = TRUE
                    ))
        })

        
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
    
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "SplitBarPlotTabsetPanel", target = tab.name)
        }

        # Toggle text.position slider visibility based on label.on.y.axis switch
        observeEvent(input$label.on.y.axis, {
            if (isTRUE(input$label.on.y.axis)) {
                shinyjs::hide("text.position")
            } else {
                shinyjs::show("text.position")
            }
        })

        ns <- session$ns
        default_palette_name <- "dittoColors"
        default_gradient_palette <- "Spectral"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        fill_by_is_numeric <- reactive({
            df <- data()
            fill_col <- input$fill.by
            if (!is.null(df) && !is.null(fill_col) && nzchar(fill_col) && fill_col %in% names(df)) {
                is.numeric(df[[fill_col]])
            } else {
                FALSE
            }
        })

        palette_groups <- reactive({
            df <- data()
            if (is.null(df)) {
                return(character(0))
            }

            fill_col <- input$fill.by
            y_col <- input$y.data

            if (!is.null(fill_col) && nzchar(fill_col) && fill_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[fill_col]])))
            } else if (!is.null(y_col) && nzchar(y_col) && y_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[y_col]])))
            } else {
                character(0)
            }
        })

        # Track initialization
        initialized <- reactiveVal(FALSE)

        output$palette.selection <- renderUI({
            if (fill_by_is_numeric()) {
                # Numeric fill_by: show palette selector for gradient
                # Build choices with palette names as values (selectInput needs atomic values)
                raw_choices <- default_palettes()[["choices"]]
                palette_choices <- lapply(raw_choices, function(group) {
                    stats::setNames(names(group), names(group))
                })
                selectInput(
                    ns("gradient.palette"),
                    "Color palette",
                    choices = palette_choices,
                    selected = default_gradient_palette
                )
            } else {
                # Categorical fill_by: show multi-color picker
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
            }
        })

        # Initialize x-axis range on startup
        observe({
            # Only run once when inputs are first available
            if (!initialized()) {
                # Only require y.data, other inputs can be empty
                req(input$y.data)
                
                # Wait a moment for other inputs to be available
                if (!is.null(input$x.data) && input$x.data != "") {
                    x_range <- axis_range()
                    if (!is.null(x_range)) {
                        updateNumericInput(session, "x.max", value = x_range$max)
                        updateNumericInput(session, "x.min", value = -x_range$max)
                        initialized(TRUE)
                    }
                }
            }
        })

        # Auto-update x-axis range when relevant inputs change
        observe({
            # Trigger on changes to y.data, x.data, or fill.by
            y_col <- input$y.data
            x_col <- input$x.data
            fill_col <- input$fill.by

            # Skip if we haven't initialized yet or y.data is not set
            if (!initialized() || is.null(y_col) || y_col == "") {
                return()
            }
            x_range <- axis_range()
            # Only auto-update if auto.update is enabled
            if (!is.null(input$auto.update) && input$auto.update) {
                if (!is.null(x_range)) {
                    updateNumericInput(session, "x.max", value = x_range$max)
                    updateNumericInput(session, "x.min", value = -x_range$max)
                }
            }
            if (!is.null(x_range)) {
                updateSliderInput(session, "text.position", min = -x_range$max, max = x_range$max)
            }
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])
            
            # Calculate x.max and x.min from the default selections
            default_y_col <- if (length(num.choices) >= 2) num.choices[2] else NULL
            default_x_col <- if (length(char.choices) >= 2) char.choices[2] else NULL
            default_group_col <- if (length(char.choices) >= 2) char.choices[2] else NULL

            x_range <- axis_range()
            if (!is.null(x_range)) {
                min.x <- -x_range$max
                max.x <- x_range$max
            } else {
                # Fallback to all numeric data if no default column
                max.x <- max(numeric.data, na.rm = TRUE) * axis_scale()
                min.x <- -max.x
            }
            # Reset numeric inputs to defaults derived from data

            # Data
            # Data Section
            updateSelectInput(session, "x.data", selected = num.choices[2])
            updateSelectInput(session, "y.data", selected = char.choices[2])
            updateSelectInput(session, "fill.by", selected = char.choices[2])

            # Facet Section
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "free_y")
            updateNumericInput(session, "facet.ncol", value = NA) # Using NA for NULL in numericInput
            updateNumericInput(session, "facet.nrow", value = NA)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "")
          #Aesthetics
            updateSelectInput(session, "theme", selected = "theme_this")
            updateSelectInput(session, "alpha.by", selected = "")
            updateMaterialSwitch(session, "alpha.reverse", value = FALSE)
            updateTextInput(session, "alpha.name", value = "")
            updateNumericInput(session, "bar.height", value = 0.9)
            updateNumericInput(session, "line.height", value = 0.5)
            updateMaterialSwitch(session, "label.on.y.axis", value = FALSE)
            updateSliderInput(session, "axis.scale.factor", value = 1.2)
            updateSliderInput(session, "text.position", value = 0)
            # Axes
            updateMaterialSwitch(session, "rotate", value = FALSE)
            updateNumericInput(session, "x.max", value = max.x)
            updateNumericInput(session, "x.min", value = min.x)
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            .reset_axes_inputs(session)

            # Action Button (unchanged)
            updateSelectInput(session, "download.format", selected = "png")

            # Lines
            .reset_lines_inputs(session)

        })

        # Update x-axis range when data columns or fill.by change (when auto-update is off)
        observeEvent(list(input$x.data, input$y.data, input$fill.by), {
            req(input$x.data, input$y.data)
            req(input$x.data %in% names(data()))
            req(input$y.data %in% names(data()))

            x_range <- axis_range()
            if (!is.null(x_range)) {
                updateNumericInput(session, "x.max", value = x_range$max)
                updateNumericInput(session, "x.min", value = -x_range$max)
                updateSliderInput(session, "text.position", min = 0, max = x_range$max)
            }
        })


        generate_SplitBarPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            # Null Values:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            split.by <- NULL
            if (!isolate_fn(input$split.by) == "") {
                split.by <- isolate_fn(input$split.by)
            }
            fill.by <- NULL
            if (!isolate_fn(input$fill.by) == ""){
                fill.by <- isolate_fn(input$fill.by)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            # Determine palette/palcolor based on fill_by type
            palcolor_arg <- NULL
            palette_arg <- default_gradient_palette
            if (isolate_fn(fill_by_is_numeric())) {
                # Numeric fill_by: look up hex colors and pass via palcolor
                sel_palette <- isolate_fn(input$gradient.palette)
                if (!is.null(sel_palette) && nzchar(sel_palette)) {
                    pal_colors <- palette_lookup[[sel_palette]]
                    if (!is.null(pal_colors) && length(pal_colors) > 0) {
                        palcolor_arg <- pal_colors
                    }
                }
            } else {
                # Categorical fill_by: use individual color pickers
                palette_values <- resolve_palette(
                    isolate_fn(palette_groups()),
                    isolate_fn(input$palette.colours),
                    default_palette_values
                )
                if (!is.null(palette_values) && length(palette_values) > 0) {
                    palcolor_arg <- as.list(palette_values)
                }
            }

            alpha.by <- NULL
            if (!isolate_fn(input$alpha.by) == ""){
              alpha.by <- isolate_fn(input$alpha.by)
            }
          
          
            theme_args <- .create_ggplot_axis_style(input, isolate_fn = isolate_fn)

            # bar Plot
            p <- plotthis::SplitBarPlot(
                data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                flip = isolate_fn(input$rotate),
                fill_by = fill.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                palcolor = palcolor_arg,
                palette = palette_arg,
                x_min = isolate_fn(input$x.min),
                x_max = isolate_fn(input$x.max),
                theme = "theme_this",
                theme_args = theme_args,
                alpha_by  = alpha.by,
                alpha_reverse = isolate_fn(input$alpha.reverse),
                alpha_name = isolate_fn(input$alpha.name),
                split_by = split.by,
                bar_height = isolate_fn(input$bar.height)
            )

            y <- isolate_fn(input$y.data)
            x <- isolate_fn(input$x.data)

            # Remove the original geom_text layer added by plotthis::SplitBarPlot
            # to replace it with user-controlled positioning. This is necessary because
            # plotthis::SplitBarPlot() adds a non-customizable geom_text layer for
            # category labels at x=0 that cannot be controlled through its parameters.
            

            if (!isolate_fn(input$rotate)) {
                p$layers <- p$layers[!vapply(p$layers, function(l) inherits(l$geom, "GeomText"), logical(1))]

                if (isTRUE(isolate_fn(input$label.on.y.axis))) {
                    # Show category labels on the Y axis by re-enabling axis text
                    # that plotthis::SplitBarPlot() hides internally
                    p <- p + ggplot2::theme(
                        axis.text.y = ggplot2::element_text(),
                        axis.ticks.y = ggplot2::element_line()
                    )
                } else {
                    # #Determining wether each y value is positive or negative 
                    # Show category labels at the slider-controlled position on the x axis
                    position <- isolate_fn(input$text.position)
                    lineheight <- 0.5


                    p <- p + geom_text(
                        data = ~ dplyr::filter(.x, .data[[x]] >= 0), # Adding labels for categories with only positive x axis numbers 
                        aes(
                            x = position, y = !!sym(y),
                            label = ifelse(
                                is.na(!!sym(y)), " NA ",
                                ifelse(
                                    .data[[x]] >= 0,
                                    gsub("(\\n|$)", " \\1", !!sym(y)),
                                    gsub("(^|\\n)", "\\1 ", !!sym(y))
                                )
                            ),
                            hjust = ifelse(.data[[x]] >= 0, 1, 0)
                        ),
                        color = "black",
                        lineheight = lineheight,
                        inherit.aes = FALSE
                    ) +
                    ggplot2::theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
                    
                    p <- p + geom_text(
                        data = ~ dplyr::filter(.x, .data[[x]] < 0), # Adding labels for categories with only negative x axis numbers 
                        aes(
                            x = -position, y = !!sym(y), # Position is set to negative as labels are being moved in the opposite direction 
                            label = ifelse(
                                is.na(!!sym(y)), " NA ",
                                ifelse(
                                    .data[[x]] >= 0,
                                    gsub("(\\n|$)", " \\1", !!sym(y)),
                                    gsub("(^|\\n)", "\\1 ", !!sym(y))
                                )
                            ),
                            hjust = ifelse(.data[[x]] >= 0, 1, 0)
                        ),
                        color = "black",
                        lineheight = lineheight,
                        inherit.aes = FALSE
                    ) +
                    ggplot2::theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
                }
            }
            fig <- ggplotly(p) |>
                plotly::layout(
                    title = list(
                        font = list(size = isolate_fn(input$title.font.size), family = isolate_fn(input$title.font.family), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            # Add reference lines
            fig <- .add_reference_lines(fig,
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

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$SplitBarPlot <- renderPlotly({

            x_input <- input$x.data
            y_input <- input$y.data

            return_empty <- FALSE
            txt <- c()

            if (length(x_input) == 0 || !nzchar(x_input)) {
                return_empty <- TRUE
                txt <- c(txt, "X variable input must not be empty. Please select a numeric variable.")
            }

            if (length(y_input) == 0 || !nzchar(y_input)) {
                return_empty <- TRUE
                txt <- c(txt, "Y variable input must not be empty. Please select a categorical variable.")
            }

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_SplitBarPlot() |>
                    layout(
                        margin = list(t = 100, l = 90, r = 90, b = 100, autoexpand = TRUE)
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_SplitBarPlot,
            filename_base = "SplitBarPlot"
        )
    })

}

