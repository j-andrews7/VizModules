#' Server logic for yPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the yPlot module.
#'
#' @import shiny
#' @importFrom dittoViz yPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jared Andrews
yPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "yPlotTabsetPanel", target = tab.name)
            })
        }

        ns <- session$ns
        default_palette_name <- "dittoColors"
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

            # Determine which column to use for palette groups
            color_col <- input$color.by
            group_col <- input$group.by

            # Use color.by if specified, otherwise fall back to group.by
            col_to_use <- if (!is.null(color_col) && nzchar(color_col) && color_col %in% names(df)) {
                color_col
            } else if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
                group_col
            } else {
                NULL
            }

            if (!is.null(col_to_use)) {
                unique(stats::na.omit(as.character(df[[col_to_use]])))
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

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])

            # Calculate y.max and y.min from the default selections
            max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11
            min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

            # Data
            updateSelectInput(session, "var", selected = num.choices[2])
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "color.by", selected = "")
            updateSelectInput(session, "shape.by", selected = "")
            updateSelectInput(session, "split.by", selected = "")

            # Plot Type
            updateCheckboxGroupInput(session, "plots", selected = c("vlnplot", "boxplot", "jitter"))

            # Adjustments
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "y.max", value = max.y)
            updateSwitchInput(session, "do.raster", value = FALSE)
            updateNumericInput(session, "raster.dpi", value = 300)

            # Jitter
            updateNumericInput(session, "jitter.size", value = 1)
            updateNumericInput(session, "jitter.width", value = 0.2)
            colourpicker::updateColourInput(session, "jitter.color", value = "#000000")
            updateNumericInput(session, "jitter.shape.legend.size", value = 5)
            updateSwitchInput(session, "jitter.shape.legend.show", value = TRUE)
            updateNumericInput(session, "jitter.position.dodge", value = 1)

            # Box
            updateNumericInput(session, "boxplot.width", value = 0.2)
            colourpicker::updateColourInput(session, "boxplot.color", value = "#000000")
            updateSwitchInput(session, "boxplot.show.outliers", value = FALSE)
            updateNumericInput(session, "boxplot.outlier.size", value = 1.5)
            updateSwitchInput(session, "boxplot.fill", value = TRUE)
            updateNumericInput(session, "boxplot.position.dodge", value = 1)
            updateNumericInput(session, "boxplot.lineweight", value = 1)

            # Violin
            updateNumericInput(session, "vlnplot.lineweight", value = 1)
            updateNumericInput(session, "vlnplot.width", value = 1)
            updateSelectInput(session, "vlnplot.scaling", selected = "area")
            updateTextInput(session, "vlnplot.quantiles", value = "")

            # Ridge
            updateNumericInput(session, "ridgeplot.lineweight", value = 1)
            updateNumericInput(session, "ridgeplot.scale", value = 1.25)
            updateNumericInput(session, "ridgeplot.ymax.expansion", value = NA)
            updateSelectInput(session, "ridgeplot.shape", selected = "smooth")
            updateNumericInput(session, "ridgeplot.bins", value = 30)
            updateNumericInput(session, "ridgeplot.binwidth", value = NULL)

            # Extras
            updateTextInput(session, "add.line", value = "")
            colourpicker::updateColourInput(session, "line.color", value = "#000000")
            updateNumericInput(session, "line.linewidth", value = 0.5)
            updateSelectInput(session, "line.linetype", selected = "dashed")
            updateNumericInput(session, "line.opacity", value = 1)

            # Facet
            updateSelectInput(session, "split.ncol", selected = "")
            updateSelectInput(session, "split.nrow", selected = "")

            # Axes
            updateSwitchInput(session, "x.labels.rotate", value = TRUE)
            updateSelectInput(session, "font.type", selected = "Arial")
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror", value = TRUE)
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
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")

            # Action Button
            updateSelectInput(session, "download.type", selected = "png")
        })

        # Update y-axis range when var (y data) column is changed
        observeEvent(input$var, {
            y_range <- .calculate_y_range(df = data(), y_data_col = input$var, Y_AXIS_SCALE_FACTOR = 1.11)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })


        output$yPlot <- renderPlotly({
            isolate_fn <- setup_auto_update_logic(input)

            # Parse inputs that might need conversion
            split.by <- .na_to_null(isolate_fn(input$split.by))
            color.by <- .na_to_null(isolate_fn(input$color.by))
            shape.by <- .na_to_null(isolate_fn(input$shape.by))
            
            # Parse add.line (comma-separated numeric values)
            add.line <- isolate_fn(input$add.line)
            if (!is.null(add.line) && nzchar(add.line)) {
                add.line <- as.numeric(trimws(strsplit(add.line, ",")[[1]]))
                if (any(is.na(add.line))) {
                    add.line <- NULL
                }
            } else {
                add.line <- NULL
            }

            # Parse vlnplot.quantiles (comma-separated numeric values)
            vlnplot.quantiles <- isolate_fn(input$vlnplot.quantiles)
            if (!is.null(vlnplot.quantiles) && nzchar(vlnplot.quantiles)) {
                vlnplot.quantiles <- as.numeric(trimws(strsplit(vlnplot.quantiles, ",")[[1]]))
                if (any(is.na(vlnplot.quantiles))) {
                    vlnplot.quantiles <- NULL
                }
            } else {
                vlnplot.quantiles <- NULL
            }

            # Parse split dimensions
            split.ncol <- isolate_fn(input$split.ncol)
            if (is.null(split.ncol) || split.ncol == "") {
                split.ncol <- NULL
            } else {
                split.ncol <- as.integer(split.ncol)
            }

            split.nrow <- isolate_fn(input$split.nrow)
            if (is.null(split.nrow) || split.nrow == "") {
                split.nrow <- NULL
            } else {
                split.nrow <- as.integer(split.nrow)
            }

            # Handle ridgeplot.ymax.expansion
            ridgeplot.ymax.expansion <- isolate_fn(input$ridgeplot.ymax.expansion)
            if (is.na(ridgeplot.ymax.expansion)) {
                ridgeplot.ymax.expansion <- NA
            }

            # Handle ridgeplot.binwidth
            ridgeplot.binwidth <- .na_to_null(isolate_fn(input$ridgeplot.binwidth))

            # Resolve color palette
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours)
            )

            # dittoViz yPlot expects color.panel to be a vector of colors
            color.panel.arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                color.panel.arg <- as.vector(palette_values)
            }

            # Set default color.by to group.by if not specified
            if (is.null(color.by) || color.by == "") {
                color.by <- isolate_fn(input$group.by)
            }

            p <- dittoViz::yPlot(
                data_frame = data(),
                var = isolate_fn(input$var),
                group.by = isolate_fn(input$group.by),
                color.by = color.by,
                shape.by = shape.by,
                split.by = split.by,
                plots = isolate_fn(input$plots),
                do.hover = TRUE,
                color.panel = if (!is.null(color.panel.arg)) color.panel.arg else dittoViz::dittoColors(),
                min = isolate_fn(input$y.min),
                max = isolate_fn(input$y.max),
                x.labels.rotate = isolate_fn(input$x.labels.rotate),
                split.nrow = split.nrow,
                split.ncol = split.ncol,
                do.raster = isolate_fn(input$do.raster),
                raster.dpi = isolate_fn(input$raster.dpi),
                jitter.size = isolate_fn(input$jitter.size),
                jitter.width = isolate_fn(input$jitter.width),
                jitter.color = isolate_fn(input$jitter.color),
                jitter.shape.legend.size = isolate_fn(input$jitter.shape.legend.size),
                jitter.shape.legend.show = isolate_fn(input$jitter.shape.legend.show),
                jitter.position.dodge = isolate_fn(input$jitter.position.dodge),
                boxplot.width = isolate_fn(input$boxplot.width),
                boxplot.color = isolate_fn(input$boxplot.color),
                boxplot.show.outliers = isolate_fn(input$boxplot.show.outliers),
                boxplot.outlier.size = isolate_fn(input$boxplot.outlier.size),
                boxplot.fill = isolate_fn(input$boxplot.fill),
                boxplot.position.dodge = isolate_fn(input$boxplot.position.dodge),
                boxplot.lineweight = isolate_fn(input$boxplot.lineweight),
                vlnplot.lineweight = isolate_fn(input$vlnplot.lineweight),
                vlnplot.width = isolate_fn(input$vlnplot.width),
                vlnplot.scaling = isolate_fn(input$vlnplot.scaling),
                vlnplot.quantiles = vlnplot.quantiles,
                ridgeplot.lineweight = isolate_fn(input$ridgeplot.lineweight),
                ridgeplot.scale = isolate_fn(input$ridgeplot.scale),
                ridgeplot.ymax.expansion = ridgeplot.ymax.expansion,
                ridgeplot.shape = isolate_fn(input$ridgeplot.shape),
                ridgeplot.bins = isolate_fn(input$ridgeplot.bins),
                ridgeplot.binwidth = ridgeplot.binwidth,
                add.line = add.line,
                line.linetype = isolate_fn(input$line.linetype),
                line.color = isolate_fn(input$line.color),
                line.linewidth = isolate_fn(input$line.linewidth),
                line.opacity = isolate_fn(input$line.opacity),
                legend.show = TRUE
            )

            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = split.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
