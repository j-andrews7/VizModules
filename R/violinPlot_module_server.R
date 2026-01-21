#' Server logic for ViolinPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the ViolinPlot module.
#'
#' @import shiny
#' @importFrom plotthis ViolinPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jacob Martin
ViolinPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Constant for y-axis scaling to ensure highest violin reaches ~90% of chart height
        

        
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "ViolinPlotTabsetPanel", target = tab.name)
            })
        }

        ns <- session$ns
        default_palette_name <- "Paired"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        palette_groups <- reactive({
            df <- data()
            if (is.null(df)) {
                return(character(0))
            }

            group_col <- input$group.by
            x_col <- input$x.data

            if (!is.null(group_col) && nzchar(group_col) && group_col != "NULL" && group_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[group_col]])))
            } else if (!is.null(x_col) && nzchar(x_col) && x_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[x_col]])))
            } else {
                character(0)
            }
        })

        resolve_palette <- function(groups, selected_colors = NULL) {
            if (length(groups) == 0) {
                return(NULL)
            }

            colors <- selected_colors
            if (is.null(colors) || length(colors) == 0) {
                colors <- default_palette_values
            }

            if (!is.null(names(colors)) && any(nzchar(names(colors)))) {
                colors <- colors[match(groups, names(colors))]
            }

            if (any(is.na(colors))) {
                na_idx <- which(is.na(colors))
                fallback <- if (length(default_palette_values) > 0) default_palette_values else "#000000"
                colors[na_idx] <- rep_len(fallback, length(na_idx))
            }

            colors <- rep_len(colors, length(groups))
            stats::setNames(colors[seq_along(groups)], groups)
        }

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(resolve_palette(groups, input$palette.colours))

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

        # Track initialization
        # initialized <- reactiveVal(FALSE)


        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            
            # Calculate y.max and y.min from the default selections
            max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 
            min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "group.by", selected = "NULL")
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSelectInput(session, "y.data", selected = num.choices[2])
            # Adjustments
            updateSelectInput(session, "sort_x", selected = "none")
            updateSwitchInput(session, "flip", value = FALSE)
            updateSwitchInput(session, "stack", value = FALSE)
            updateNumericInput(session, "aspect.ratio", value = 1)
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "y.max", value = max.y)

            # Points
            updateSwitchInput(session, "add.points", value = FALSE)
            updateNumericInput(session, "pt.size", value = 1)
            updateNumericInput(session, "pt.alpha", value = 1)
            updateNumericInput(session, "jitter.width", value = 0.5)
            updateNumericInput(session, "jitter.height", value = 0)

            # Box
            updateSwitchInput(session, "add.box", value = FALSE)
            colourpicker::updateColourInput(session, "box.color", value = "#000000")
            updateNumericInput(session, "box.width", value = 0.1)
            updateNumericInput(session, "box.ptsize", value = 2.5)

            # Colors
            colourpicker::updateColourInput(session, "pt.color", value = "#4472C4")

            # Annotations
            updateNumericInput(session, "add.line", value = NA)
            updateNumericInput(session, "line.width", value = 0.6)
            colourpicker::updateColourInput(session, "line.colour", value = "#000000")
            updateNumericInput(session, "line.type", value = 1)
            updateTextInput(session, "highlight", value = "")
            colourpicker::updateColourInput(session, "highlight.colour", value = "#000000")
            updateNumericInput(session, "highlight.size", value = 1)
            updateNumericInput(session, "highlight.alpha", value = 1)
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")

            # Stats
            updateSelectInput(session, "add.stat", selected = "")
            colourpicker::updateColourInput(session, "stat.color", value = "#000000")
            updateNumericInput(session, "stat.size", value = 1)
            updateNumericInput(session, "stat.stroke", value = 1)
            updateNumericInput(session, "stat.shape", value = 25)

            # Facet
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)

            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")

            # Axes:
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            colourpicker::updateColourInput(session, "axis.linecolor", value = "black")
            updateNumericInput(session, "axis.linewidth", value = 0.5)
            updateNumericInput(session, "axis.tickfont.size", value = 12)
            colourpicker::updateColourInput(session, "axis.tickfont.color", value = "black")
            updateSelectInput(session, "axis.tickfont.family", selected = "Arial")
            updateNumericInput(session, "axis.tickangle.x", value = 0)
            updateNumericInput(session, "axis.tickangle.y", value = 0)
            updateSelectInput(session, "axis.ticks", selected = "outside")
            colourpicker::updateColourInput(session, "axis.tickcolor", value = "black")
            updateNumericInput(session, "axis.ticklen", value = 5)
            updateNumericInput(session, "axis.tickwidth", value = 1)
        })

        # Update y-axis range when y data column is changed
        observeEvent(input$y.data, {
            y_range <- .calculate_y_range(df = data(), y_data_col = input$y.data, Y_AXIS_SCALE_FACTOR = 1.11)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })


        output$ViolinPlot <- renderPlotly({
            isolate_fn <- setup_auto_update_logic(input)

            # Facet By Null option Upstream:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }
            group.by <- NULL
            if (!isolate_fn(input$group.by) == "") {
                group.by <- isolate_fn(input$group.by)
            }
            highlight <- .na_to_null(isolate_fn(input$highlight))

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            #Stats Default: 
            add.stat <- NULL
            if (!isolate_fn(input$add.stat) == ""){
                add.stat <- isolate_fn(input$add.stat)
            }
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours)
            )
            palcolor_arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                # plotthis::ViolinPlot expects a named list for palcolor when manually setting colors
                palcolor_arg <- as.list(palette_values)
            }

            p <- plotthis::ViolinPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                flip = isolate_fn(input$flip),
                sort_x = isolate_fn(input$sort_x),
                stack = isolate_fn(input$stack),
                y_max = isolate_fn(input$y.max),
                y_min = isolate_fn(input$y.min),
                aspect.ratio = isolate_fn(input$aspect.ratio),
                add_point = isolate_fn(input$add.points),
                pt_size = isolate_fn(input$pt.size),
                pt_alpha = isolate_fn(input$pt.alpha),
                jitter_width = isolate_fn(input$jitter.width),
                jitter_height = isolate_fn(input$jitter.height),
                pt_color = isolate_fn(input$pt.color),
                add_box = isolate_fn(input$add.box),
                box_color = isolate_fn(input$box.color),
                box_width = isolate_fn(input$box.width),
                box_ptsize = isolate_fn(input$box.ptsize),
                add_stat = add.stat,
                stat_color = isolate_fn(input$stat.color),
                stat_size = isolate_fn(input$stat.size),
                stat_stroke = isolate_fn(input$stat.stroke),
                stat_shape = isolate_fn(input$stat.shape),
                stat_name = isolate_fn(input$add.stat),
                palette = default_palette_name,
                palcolor = palcolor_arg,
                add_line = isolate_fn(input$add.line),
                line_color = isolate_fn(input$line.colour),
                line_width = isolate_fn(input$line.width),
                line_type = isolate_fn(input$line.type),
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                group_by = group.by,
                highlight = highlight,
                highlight_color = isolate_fn(input$highlight.colour),
                highlight_size = isolate_fn(input$highlight.size),
                highlight_alpha = isolate_fn(input$highlight.alpha)
            )

            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            #Axis Styling: 

            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style) 
            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
