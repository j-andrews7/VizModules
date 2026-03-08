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
#' @import plotly
#' @importFrom dittoViz yPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @seealso [dittoViz::yPlot()], [VizModules::dittoViz_yPlotInputsUI()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotApp()]
#'
#' @export
#' @author Jared Andrews, Jacob Martin
dittoViz_yPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                col_data <- stats::na.omit(df[[col_to_use]])
                # Use factor level order to match ggplot2/dittoViz color assignment.
                # For factors, use the defined levels (preserves order);
                # for character/other, convert to factor (alphabetical order).
                if (is.factor(col_data)) {
                    levels(col_data)
                } else {
                    levels(as.factor(col_data))
                }
            } else {
                character(0)
            }
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

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])

            # Calculate y.max and y.min from the default selections
            if (length(num.choices) >= 2) {
                max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11
                min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            } else {
                max.y <- 1
                min.y <- 0
            }

            # Data
            updateSelectInput(session, "var", selected = num.choices[2])
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "color.by", selected = "")
            updateSelectInput(session, "shape.by", selected = "")
            

            # Plot Type
            updateCheckboxGroupInput(session, "plots", selected = c("boxplot", "jitter"))

            # Adjustments
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "y.max", value = max.y)
            updateMaterialSwitch(session, "do.raster", value = FALSE)
            updateNumericInput(session, "raster.dpi", value = 600)

            # Jitter
            updateNumericInput(session, "jitter.size", value = 1)
            updateNumericInput(session, "jitter.width", value = 0.2)
            colourpicker::updateColourInput(session, "jitter.color", value = "#000000")
            updateNumericInput(session, "jitter.shape.legend.size", value = 5)
            updateMaterialSwitch(session, "jitter.shape.legend.show", value = TRUE)
            updateNumericInput(session, "jitter.position.dodge", value = NA)

            # Box
            updateMaterialSwitch(session, "show.outliers", value = FALSE)
            colourpicker::updateColourInput(session, "boxplot.color", value = "#000000")
            updateMaterialSwitch(session, "boxplot.fill", value = TRUE)
            updateNumericInput(session, "boxplot.lineweight", value = 0.5)
            updateNumericInput(session, "boxgap", value = 0.3)
            updateNumericInput(session, "boxgroupgap", value = 0.2)

            # Violin
            updateNumericInput(session, "vlnplot.lineweight", value = 0.5)
            updateNumericInput(session, "vlnplot.width", value = 1)
            updateSelectInput(session, "vlnplot.scaling", selected = "area")
            updateTextInput(session, "vlnplot.quantiles", value = "")

            # Ridge
            updateNumericInput(session, "ridgeplot.lineweight", value = 0.5)
            updateNumericInput(session, "ridgeplot.scale", value = 1.25)
            updateNumericInput(session, "ridgeplot.ymax.expansion", value = NA)
            updateSelectInput(session, "ridgeplot.shape", selected = "smooth")
            updateNumericInput(session, "ridgeplot.bins", value = 30)
            updateNumericInput(session, "ridgeplot.binwidth", value = NULL)

            # Facet
            updateSelectInput(session, "split.by", selected = "")
            updateSelectInput(session, "split.adjust", selected = "free")
            updateSelectInput(session, "split.ncol", selected = "")
            updateSelectInput(session, "split.nrow", selected = "")

            # Axes
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.title.font.size", value = 18)
            colourpicker::updateColourInput(session, "axis.title.font.color", value = "#000000")
            updateSelectInput(session, "axis.title.font.family", selected = "Arial")
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror", value = TRUE)
            updateCheckboxInput(session, "show.grid.x", value = TRUE)
            updateCheckboxInput(session, "show.grid.y", value = TRUE)
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

            # Lines
            updateTextInput(session, "hline.intercepts", value = "")
            updateTextInput(session, "hline.colors", value = "#000000")
            updateTextInput(session, "hline.widths", value = "1")
            updateTextInput(session, "hline.linetypes", value = "dashed")
            updateTextInput(session, "hline.opacities", value = "1")
            updateTextInput(session, "vline.intercepts", value = "")
            updateTextInput(session, "vline.colors", value = "#000000")
            updateTextInput(session, "vline.widths", value = "1")
            updateTextInput(session, "vline.linetypes", value = "dashed")
            updateTextInput(session, "vline.opacities", value = "1")
            updateTextInput(session, "abline.slopes", value = "")
        })

        # Update y-axis range when var (y data) column is changed
        observeEvent(input$var, {
            y_range <- .calculate_range(df = data(), data_col_y = input$var, axis_scale_factor = 1.11, grouping = FALSE)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })

        # Generate yPlot reactive
        generate_yPlot <- reactive({
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
                isolate_fn(input$palette.colours),
                default_palette_values
            )

            # Keep names so scale_fill_manual matches colors to groups by name,
            # making the mapping independent of positional order.
            color.panel.arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                color.panel.arg <- palette_values
            }

            # Set default color.by to group.by if not specified
            if (is.null(color.by) || color.by == "") {
                color.by <- isolate_fn(input$group.by)
            }
            
            #Formating split adjustment into correct structure for dittoViz paramater input 
            split.adjust <- list(scales = "free")
            if (!isolate_fn(input$split.adjust) == "free"){
                split.adjust$scales <- isolate_fn(input$split.adjust)
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
                split.nrow = split.nrow,
                split.ncol = split.ncol,
                split.adjust = split.adjust,
                do.raster = isolate_fn(input$do.raster),
                raster.dpi = isolate_fn(input$raster.dpi),
                jitter.size = isolate_fn(input$jitter.size),
                jitter.width = isolate_fn(input$jitter.width),
                jitter.color = isolate_fn(input$jitter.color),
                jitter.shape.legend.size = isolate_fn(input$jitter.shape.legend.size),
                jitter.shape.legend.show = isolate_fn(input$jitter.shape.legend.show),
                jitter.position.dodge = 1 - isolate_fn(input$boxgap),
                boxplot.color = isolate_fn(input$boxplot.color),
                boxplot.show.outliers = TRUE,
                boxplot.fill = isolate_fn(input$boxplot.fill),
                boxplot.lineweight = isolate_fn(input$boxplot.lineweight),
                vlnplot.lineweight = isolate_fn(input$vlnplot.lineweight),
                vlnplot.scaling = isolate_fn(input$vlnplot.scaling),
                vlnplot.quantiles = vlnplot.quantiles,
                vlnplot.width = 1 - isolate_fn(input$boxgap),
                ridgeplot.lineweight = isolate_fn(input$ridgeplot.lineweight),
                ridgeplot.scale = isolate_fn(input$ridgeplot.scale),
                ridgeplot.ymax.expansion = ridgeplot.ymax.expansion,
                ridgeplot.shape = isolate_fn(input$ridgeplot.shape),
                ridgeplot.bins = isolate_fn(input$ridgeplot.bins),
                ridgeplot.binwidth = ridgeplot.binwidth,
                legend.show = TRUE, 
                theme = theme_bw()
            )

            fig <- p |>
                plotly::layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    ),
                    boxmode = ifelse(!color.by == isolate_fn(input$group.by), "group", "overlay"),
                    boxgap = isolate_fn(input$boxgap),
                    boxgroupgap = isolate_fn(input$boxgroupgap)
                )

            # Apply axis styling
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE)

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

            # Remove outliers if jitter is shown or if user explicitly disabled outliers
            if ("jitter" %in% isolate_fn(input$plots) || !isolate_fn(input$show.outliers)) {
                fig <- .remove_boxplot_outliers(fig)
            }


            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = split.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$yPlot <- renderPlotly({

            var_input <- input$var

            return_empty <- FALSE
            txt <- c()

            if (length(var_input) == 0 || !nzchar(var_input)) {
                return_empty <- TRUE
                txt <- c(txt, "Y variable input must not be empty. Please select a numeric variable.")
            }

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_yPlot() |>
                    layout(
                        margin = list(t = 100, l = 90, r = 90, b = 100, autoexpand = TRUE)
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_yPlot,
            filename_base = "yPlot"
        )
    })
}
