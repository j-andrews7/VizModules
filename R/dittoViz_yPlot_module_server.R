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
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#' @return The `moduleServer` function for the yPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom ggplot2 theme_bw theme unit
#' @importFrom stats na.omit
#' @importFrom dittoViz yPlot
#' @importFrom shinyjs hide show
#' @importFrom shinyWidgets updateMaterialSwitch
#' @importFrom colourpicker updateColourInput
#'
#' @seealso [dittoViz::yPlot()], [VizModules::dittoViz_yPlotInputsUI()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotApp()]
#'
#' @export
#' @author Jared Andrews, Jacob Martin
dittoViz_yPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "yPlotTabsetPanel", target = tab.name)
        }

        # Conditionally show/hide Stats tab based on plot type selection
        observeEvent(input$plots, {
            if (length(input$plots) == 1 && input$plots == "ridgeplot") {
                hideTab(inputId = "yPlotTabsetPanel", target = "Stats")
            } else {
                showTab(inputId = "yPlotTabsetPanel", target = "Stats")
            }
        })

        # Update stat comparison pairs when group.by or color.by changes
        observeEvent(c(input$group.by, input$color.by), {
            req(input$group.by)
            color_by <- if (!is.null(input$color.by) && nzchar(input$color.by)) input$color.by else NULL
            pair_strings <- generate_pair_strings(data(), input$group.by, color_by)
            updateSelectInput(session, "stat.pairs", choices = c("", pair_strings), selected = "")
        })

        # Show/hide Save Stats button based on stats.enabled
        observeEvent(input$stats.enabled, {
            if (isTRUE(input$stats.enabled)) {
                show("download.stats.col")
            } else {
                hide("download.stats.col")
            }
        })

        ns <- session$ns

        # Store last computed stats table for download
        last_stats_df <- reactiveVal(NULL)
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
                col_data <- na.omit(df[[col_to_use]])
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
                max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * .y_axis_scale_factor
                min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            } else {
                max.y <- 1
                min.y <- 0
            }

            # Data
            updateSelectInput(session, "var",
                selected = .get_default(defaults, "var", num.choices[2], function(x) x %in% num.choices))
            updateSelectInput(session, "group.by",
                selected = .get_default(defaults, "group.by", char.choices[2], function(x) x %in% char.choices))
            updateSelectInput(session, "color.by",
                selected = .get_default(defaults, "color.by", "", function(x) x == "" || x %in% char.choices))
            updateSelectInput(session, "shape.by",
                selected = .get_default(defaults, "shape.by", "", function(x) x == "" || x %in% char.choices))


            # Plot Type
            updateCheckboxGroupInput(session, "plots",
                selected = .get_default(defaults, "plots", c("boxplot", "jitter")))

            # Adjustments
            updateNumericInput(session, "y.min", value = .get_default(defaults, "y.min", min.y, is.numeric))
            updateNumericInput(session, "y.max", value = .get_default(defaults, "y.max", max.y, is.numeric))
            updateMaterialSwitch(session, "do.raster", value = .get_default(defaults, "do.raster", FALSE, is.logical))
            updateNumericInput(session, "raster.dpi", value = .get_default(defaults, "raster.dpi", 600, is.numeric))

            # Jitter
            updateNumericInput(session, "jitter.size", value = .get_default(defaults, "jitter.size", 1, is.numeric))
            updateNumericInput(session, "jitter.width", value = .get_default(defaults, "jitter.width", 0.2, is.numeric))
            updateColourInput(session, "jitter.color",
                value = .get_default(defaults, "jitter.color", "#000000"))
            updateNumericInput(session, "jitter.shape.legend.size",
                value = .get_default(defaults, "jitter.shape.legend.size", 5, is.numeric))
            updateMaterialSwitch(session, "jitter.shape.legend.show",
                value = .get_default(defaults, "jitter.shape.legend.show", TRUE, is.logical))

            # Box
            updateMaterialSwitch(session, "boxplot.show.outliers",
                value = .get_default(defaults, "boxplot.show.outliers", FALSE, is.logical))
            updateColourInput(session, "boxplot.color",
                value = .get_default(defaults, "boxplot.color", "#000000"))
            updateMaterialSwitch(session, "boxplot.fill",
                value = .get_default(defaults, "boxplot.fill", TRUE, is.logical))
            updateNumericInput(session, "boxplot.lineweight",
                value = .get_default(defaults, "boxplot.lineweight", 0.5, is.numeric))
            updateNumericInput(session, "boxgap", value = .get_default(defaults, "boxgap", 0.3, is.numeric))
            updateNumericInput(session, "boxgroupgap", value = .get_default(defaults, "boxgroupgap", 0.2, is.numeric))

            # Violin
            updateNumericInput(session, "vlnplot.lineweight",
                value = .get_default(defaults, "vlnplot.lineweight", 0.5, is.numeric))
            updateSelectInput(session, "vlnplot.scaling",
                selected = .get_default(defaults, "vlnplot.scaling", "area"))
            updateTextInput(session, "vlnplot.quantiles",
                value = .get_default(defaults, "vlnplot.quantiles", ""))

            # Ridge
            updateNumericInput(session, "ridgeplot.lineweight",
                value = .get_default(defaults, "ridgeplot.lineweight", 0.5, is.numeric))
            updateNumericInput(session, "ridgeplot.scale",
                value = .get_default(defaults, "ridgeplot.scale", 1.25, is.numeric))
            updateNumericInput(session, "ridgeplot.ymax.expansion",
                value = .get_default(defaults, "ridgeplot.ymax.expansion", NA, is.numeric))
            updateSelectInput(session, "ridgeplot.shape",
                selected = .get_default(defaults, "ridgeplot.shape", "smooth"))
            updateNumericInput(session, "ridgeplot.bins",
                value = .get_default(defaults, "ridgeplot.bins", 30, is.numeric))
            updateNumericInput(session, "ridgeplot.binwidth",
                value = .get_default(defaults, "ridgeplot.binwidth", NA, is.numeric))

            # Facet
            updateSelectInput(session, "split.by",
                selected = .get_default(defaults, "split.by", "", function(x) x == "" || x %in% char.choices))
            updateSelectInput(session, "split.adjust", selected = .get_default(defaults, "split.adjust", "free"))
            updateNumericInput(session, "split.ncol", value = .get_default(defaults, "split.ncol", NA, is.numeric))
            updateNumericInput(session, "split.nrow", value = .get_default(defaults, "split.nrow", NA, is.numeric))

            # Axes
            .reset_axes_inputs(session, defaults)

            # Plotly
            .reset_plotly_inputs(session, defaults)

            # Lines
            .reset_lines_inputs(session, defaults = defaults)

            # Stats
            .reset_stats_inputs(session, defaults)
        })

        # Update y-axis range when var (y data) column is changed
        observeEvent(input$var, {
            y_range <- .calculate_range(df = data(), data_col_y = input$var, axis_scale_factor = .y_axis_scale_factor, grouping = FALSE)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })

        observeEvent(input$split.by, {
            if (!is.null(input$split.by) && nzchar(input$split.by)) {
                show("facet.title.font.size")
                show("facet.title.font.color")
                show("facet.title.font.family")
            } else {
                hide("facet.title.font.size")
                hide("facet.title.font.color")
                hide("facet.title.font.family")
            }
        })

        # Generate yPlot reactive
        generate_yPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            # Parse inputs that might need conversion
            split.by <- .na_to_null(isolate_fn(input$split.by))
            color.by <- .na_to_null(isolate_fn(input$color.by))
            shape.by <- .na_to_null(isolate_fn(input$shape.by))

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
            split.ncol <- .na_to_null(isolate_fn(input$split.ncol))
            split.nrow <- .na_to_null(isolate_fn(input$split.nrow))

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

            # Formatting split adjustment into correct structure for dittoViz parameter input
            split.adjust <- list(scales = "free")
            if (isolate_fn(input$split.adjust) != "free") {
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
                boxplot.show.outliers = isolate_fn(input$boxplot.show.outliers),
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
                theme = theme_bw() + theme(
                    panel.border = element_blank(),
                    axis.line = element_line(colour = "black"),  # draws only bottom + left
                    axis.ticks.top = element_blank(),
                    axis.ticks.right = element_blank(),
                    strip.background = element_blank()
                )
            )

            fig <- p |>
                layout(
                    boxmode = ifelse(!color.by == isolate_fn(input$group.by), "group", "overlay"),
                    boxgap = isolate_fn(input$boxgap),
                    boxgroupgap = isolate_fn(input$boxgroupgap)
                )
            if (!is.null(split.by) && nzchar(split.by)) {
                fig <- .apply_facet_subplot_spacing(
                    fig,
                    spacing = isolate_fn(input$subplot.margin),
                    ncol = split.ncol,
                    nrow = split.nrow
                )

            }
            fig <- .apply_title_layout(fig, input, isolate_fn, title_y = 0.98, title_x = isolate_fn(input$axis.title.horizontal.position))
            
            


            # Fix boxplot positioning across faceted subplots
            if (!is.null(split.by) && nzchar(split.by)) {
                fig <- .fix_boxplot_facet_positions(fig)
            }

            # Apply axis styling
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = FALSE)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)


            # Apply axis title font to shared facet annotation titles
            if (!is.null(split.by) && nzchar(split.by)) {
                fig <- .apply_axis_title_to_annotations(fig, input, isolate_fn)
            }

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

            # Statistical annotations
            if (isolate_fn(input$stats.enabled)) {
                # yPlot uses group.by as the x-axis, color.by for nested grouping
                xvar <- isolate_fn(input$group.by)
                grp_var <- if (!is.null(color.by) && color.by != xvar) color.by else NULL
                stat_pairs <- parse_pair_strings(isolate_fn(input$stat.pairs))
                stats_df <- compute_pairwise_stats(
                    df = data(), x = xvar,
                    y = isolate_fn(input$var), pairs = stat_pairs,
                    test = isolate_fn(input$stat.test),
                    p.adjust.method = isolate_fn(input$stat.p.adjust),
                    paired = isolate_fn(input$stat.paired),
                    group.by = grp_var, facet.by = split.by,
                    per.facet = isolate_fn(input$stat.per.facet),
                    sig.threshold = isolate_fn(input$stat.sig.threshold)
                )
                last_stats_df(stats_df)
                stat_result <- create_stat_annotations(
                    stats_df = stats_df, fig = fig, df = data(),
                    x = xvar, y = isolate_fn(input$var),
                    display = isolate_fn(input$stat.display),
                    hide.ns = isolate_fn(input$stat.hide.ns),
                    sig.threshold = isolate_fn(input$stat.sig.threshold),
                    line.color = isolate_fn(input$stat.line.color),
                    line.width = isolate_fn(input$stat.line.width),
                    bracket.style = isolate_fn(input$stat.bracket.style),
                    group.by = grp_var, facet.by = split.by,
                    step.increase = isolate_fn(input$stat.step.increase),
                    text.bump = isolate_fn(input$stat.text.bump),
                    bracket.inset = isolate_fn(input$stat.bracket.inset)
                )
                fig <- apply_stat_annotations(fig, stat_result,
                    y.min = isolate_fn(input$y.min)
                )
            }


            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = split.by)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$yPlot <- renderPlotly({
            req(input$var)

            fig <- .apply_render_margins(generate_yPlot(), input)


            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_yPlot,
            filename_base = "yPlot"
        )

        # Download handler for stats table
        output$download.stats <- downloadHandler(
            filename = function() {
                paste0("stats_table_", Sys.Date(), ".csv")
            },
            content = function(file) {
                write_stats_csv(
                    stats_df = last_stats_df(), file = file,
                    p.adjust.method = input$stat.p.adjust,
                    sig.threshold = input$stat.sig.threshold
                )
            }
        )
    })
}
