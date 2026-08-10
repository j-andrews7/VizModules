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
#'   the same list passed to the corresponding UI function. An entry may also be a
#'   [shiny::reactive()] or [shiny::reactiveVal()], in which case the input tracks it as the
#'   parent app's state changes; see [setup_reactive_defaults()].
#' @return The `moduleServer` function for the yPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom ggplot2 theme_bw theme unit element_blank
#' @importFrom stats na.omit
#' @importFrom dittoViz yPlot
#' @importFrom shinyjs hide show delay
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
        params <- setup_reactive_defaults(defaults, input, session)

        # Hide individual inputs/tabs if specified. The inputs UI is injected by the
        # parent app via renderUI (and re-injected when the dataset changes), so the
        # hiding must be (re)applied after the controls exist in the DOM rather than
        # once at module initialization.
        if (!is.null(hide.inputs) || !is.null(hide.tabs)) {
            observeEvent(data(), {
                delay(100, {
                    hide_input(session, hide.inputs)
                    for (tab.name in hide.tabs) hideTab(inputId = "yPlotTabsetPanel", target = tab.name)
                })
            })
        }

        # Keep the Y-data selector in step with the data. Only refresh when the set
        # of numeric columns actually changes (not on every row-filter), to
        # preserve the user's current selection.
        var_choice_cache <- reactiveVal(NULL)
        observeEvent(data(), {
            df <- data()
            req(df)
            num.cols <- names(df)[vapply(df, is.numeric, logical(1))]
            if (identical(num.cols, var_choice_cache())) {
                return()
            }
            var_choice_cache(num.cols)
            current <- isolate(input$var)
            default.var <- get_default(
                defaults, "var",
                if (length(num.cols)) num.cols[1] else "",
                function(x) x %in% num.cols
            )
            selected.var <- if (!is.null(current) && nzchar(current) && current %in% num.cols) {
                current
            } else {
                default.var
            }
            update_viz_select(session, "var", choices = num.cols, selected = selected.var)
        }, ignoreNULL = TRUE)

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
            # Pause readers until the client echoes the cleared selection, otherwise
            # the plot renders once now and again when that echo lands.
            freezeReactiveValue(input, "stat.pairs")
            updateSelectInput(session, "stat.pairs", choices = c("", pair_strings), selected = "")
        })

        ns <- session$ns

        # Persist manual legend/annotation/colorbar repositioning across rebuilds.
        plot_source <- session$ns("yplot")
        edit_store <- setup_manual_edits(input, session, plot_source)

        # Axis side(s) whose title is regenerated (not persisted) because a data
        # adjustment is active; set inside generate_yPlot() and read at render.
        regen_keys_rv <- reactiveVal(character(0))

        # Axis-defining variables at the last build; when they change we drop any
        # persisted manual axis-title text so the title regenerates for the new
        # variable (its dragged position still persists).
        last_axis_vars <- reactiveVal(NULL)

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

            # The rebuilt picker reports its value on a client round-trip. Pause
            # readers until it does, so the plot renders once rather than twice.
            freezeReactiveValue(input, "palette.colours")

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
            choices <- c("", names(data()))

            # Calculate y.max and y.min from the default selections
            if (length(num.choices) >= 2) {
                max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * .y_axis_scale_factor
                min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            } else {
                max.y <- 1
                min.y <- 0
            }

            # Data
            update_viz_select(session, "var",
                choices = num.choices[nzchar(num.choices)],
                selected = get_default(defaults, "var", num.choices[2], function(x) x %in% num.choices))
            update_viz_select(session, "group.by",
                selected = get_default(defaults, "group.by", char.choices[2], function(x) x %in% char.choices))
            update_viz_select(session, "color.by",
                selected = get_default(defaults, "color.by", "", function(x) x == "" || x %in% char.choices))
            update_viz_select(session, "shape.by",
                selected = get_default(defaults, "shape.by", "", function(x) x == "" || x %in% char.choices))


            # Plot Type
            update_viz_select(session, "plots",
                selected = get_default(defaults, "plots", c("boxplot", "jitter")))

            # Adjustments
            update_viz_select(session, "var.adjustment",
                selected = get_default(defaults, "var.adjustment", ""))
            update_viz_select(session, "var.adj.fxn",
                selected = get_default(defaults, "var.adj.fxn", ""))
            updateNumericInput(session, "y.min", value = get_default(defaults, "y.min", min.y, is.numeric))
            updateNumericInput(session, "y.max", value = get_default(defaults, "y.max", max.y, is.numeric))
            updateMaterialSwitch(session, "do.raster", value = get_default(defaults, "do.raster", FALSE, is.logical))
            updateNumericInput(session, "raster.dpi", value = get_default(defaults, "raster.dpi", 600, is.numeric))

            # Jitter
            updateNumericInput(session, "jitter.size", value = get_default(defaults, "jitter.size", 1, is.numeric))
            updateNumericInput(session, "jitter.width", value = get_default(defaults, "jitter.width", 0.2, is.numeric))
            updateColourInput(session, "jitter.color",
                value = get_default(defaults, "jitter.color", "#000000"))
            updateNumericInput(session, "jitter.shape.legend.size",
                value = get_default(defaults, "jitter.shape.legend.size", 5, is.numeric))
            updateMaterialSwitch(session, "jitter.shape.legend.show",
                value = get_default(defaults, "jitter.shape.legend.show", TRUE, is.logical))

            # Box
            updateMaterialSwitch(session, "boxplot.show.outliers",
                value = get_default(defaults, "boxplot.show.outliers", FALSE, is.logical))
            updateColourInput(session, "boxplot.color",
                value = get_default(defaults, "boxplot.color", "#000000"))
            updateMaterialSwitch(session, "boxplot.fill",
                value = get_default(defaults, "boxplot.fill", TRUE, is.logical))
            updateNumericInput(session, "boxplot.lineweight",
                value = get_default(defaults, "boxplot.lineweight", 0.5, is.numeric))
            updateNumericInput(session, "boxgap", value = get_default(defaults, "boxgap", 0.3, is.numeric))
            updateNumericInput(session, "boxgroupgap", value = get_default(defaults, "boxgroupgap", 0.2, is.numeric))

            # Violin
            updateNumericInput(session, "vlnplot.lineweight",
                value = get_default(defaults, "vlnplot.lineweight", 0.5, is.numeric))
            update_viz_select(session, "vlnplot.scaling",
                selected = get_default(defaults, "vlnplot.scaling", "area"))

            # Ridge
            updateNumericInput(session, "ridgeplot.lineweight",
                value = get_default(defaults, "ridgeplot.lineweight", 0.5, is.numeric))
            updateNumericInput(session, "ridgeplot.scale",
                value = get_default(defaults, "ridgeplot.scale", 1.25, is.numeric))
            updateNumericInput(session, "ridgeplot.ymax.expansion",
                value = get_default(defaults, "ridgeplot.ymax.expansion", NA, is.numeric))
            update_viz_select(session, "ridgeplot.shape",
                selected = get_default(defaults, "ridgeplot.shape", "smooth"))
            updateNumericInput(session, "ridgeplot.bins",
                value = get_default(defaults, "ridgeplot.bins", 30, is.numeric))
            updateNumericInput(session, "ridgeplot.binwidth",
                value = get_default(defaults, "ridgeplot.binwidth", NA, is.numeric))

            # Facet
            update_viz_select(session, "split.by",
                selected = get_default(defaults, "split.by", "", function(x) x == "" || x %in% char.choices))
            update_viz_select(session, "split.adjust", selected = get_default(defaults, "split.adjust", "fixed"))
            updateNumericInput(session, "split.ncol", value = get_default(defaults, "split.ncol", NA, is.numeric))
            updateNumericInput(session, "split.nrow", value = get_default(defaults, "split.nrow", NA, is.numeric))

            # Axes
            reset_axes_inputs(session, defaults)

            # Plotly
            reset_plotly_inputs(session, defaults)
            reset_legend_inputs(session, defaults)

            # Hover
            update_viz_select(session, "hover.data",
                selected = get_default(defaults, "hover.data", "", function(x) x == "" || all(x %in% choices)))
            updateNumericInput(session, "hover.round.digits",
                value = get_default(defaults, "hover.round.digits", 5, is.numeric))

            # Lines
            reset_lines_inputs(session, defaults = defaults)

            # Stats
            .reset_stats_inputs(session, defaults)
        })

        # Update y-axis range when var (y data) column is changed
        observeEvent(input$var, {
            y_range <- .calculate_range(df = data(), data_col_y = input$var, axis_scale_factor = .y_axis_scale_factor, grouping = FALSE)
            if (!is.null(y_range)) {
                # Pause readers until the new limits arrive from the client, else the
                # plot renders once with the stale limits and again on their echo.
                freezeReactiveValue(input, "y.max")
                freezeReactiveValue(input, "y.min")
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })

        observeEvent(input$split.by, {
            if (!is.null(input$split.by) && nzchar(input$split.by)) {
                show_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            } else {
                hide_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            }
        })

        # Generate yPlot reactive
        generate_yPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            # Parse inputs that might need conversion
            split.by <- .na_to_null(isolate_fn(input$split.by))
            color.by <- .na_to_null(isolate_fn(input$color.by))
            shape.by <- .na_to_null(isolate_fn(input$shape.by))

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

            # Reflect any applied Y-axis data adjustment in the continuous-axis title so it
            # accurately describes the values displayed (e.g. "log2(z-score(units))").
            var.adjustment <- .na_to_null(isolate_fn(input$var.adjustment))
            var.adj.fxn.name <- isolate_fn(input$var.adj.fxn)
            y_axis_label <- adjusted_axis_label(
                isolate_fn(input$var), var.adjustment, var.adj.fxn.name
            )

            # The Y Axis Min/Max inputs are derived from the raw data range, so let the
            # continuous axis auto-scale whenever an adjustment rescales the values.
            adjustment.active <- !is.null(var.adjustment) ||
                (!is.null(var.adj.fxn.name) && nzchar(var.adj.fxn.name))

            # When an adjustment is active the axis title is regenerated to reflect it, so
            # flag its side for finalize_manual_edits() to skip persisting the text. The
            # continuous var lands on the x-axis for ridgeplots, otherwise the y-axis.
            regen_keys_rv(if (adjustment.active) {
                if ("ridgeplot" %in% isolate_fn(input$plots)) "axis:x" else "axis:y"
            } else {
                character(0)
            })

            # If a variable feeding an axis title (or the ridge orientation that swaps
            # which axis it lands on) changed, drop any persisted manual title text so the
            # title regenerates for the new variable. Runs before finalize_manual_edits()
            # in the same render pass, so the cleared store is what gets re-applied.
            axis_vars <- list(
                var = isolate_fn(input$var),
                group.by = isolate_fn(input$group.by),
                ridge = "ridgeplot" %in% isolate_fn(input$plots)
            )
            if (!identical(axis_vars, last_axis_vars())) {
                reset_axis_title_text(edit_store)
                last_axis_vars(axis_vars)
            }

            # Draw axis borders at the ggplot level
            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )

            # Collect hover data. When the user makes no explicit selection,
            # reconstruct dittoViz::yPlot()'s internal default set so hover
            # content is unchanged from the package default. Columns that do not
            # exist in the plotted data are ignored downstream by dittoViz.
            hover.data <- .na_to_null(isolate_fn(input$hover.data))
            if (is.null(hover.data)) {
                var.name <- isolate_fn(input$var)
                hover.data <- unique(c(
                    var.name,
                    paste0(var.name, ".adj"),
                    "var.multi", "var.which",
                    isolate_fn(input$group.by),
                    color.by,
                    shape.by,
                    split.by
                ))
            }

            p <- yPlot(
                data_frame = data(),
                var = isolate_fn(input$var),
                var.adjustment = var.adjustment,
                var.adj.fxn = safe_resolve_adj_fxn(var.adj.fxn.name),
                # Blank main title by default; dittoViz's "make" would otherwise
                # auto-generate one (the var name) and re-render it every rebuild.
                main = NULL,
                ylab = y_axis_label,
                group.by = isolate_fn(input$group.by),
                color.by = color.by,
                shape.by = shape.by,
                split.by = split.by,
                plots = isolate_fn(input$plots),
                do.hover = TRUE,
                hover.data = hover.data,
                hover.round.digits = isolate_fn(input$hover.round.digits),
                color.panel = if (!is.null(color.panel.arg)) color.panel.arg else dittoViz::dittoColors(),
                min = if (adjustment.active) NA else isolate_fn(input$y.min),
                max = if (adjustment.active) NA else isolate_fn(input$y.max),
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
                # Hide outliers when jitter points are shown (to avoid
                # double-plotting) or when the user disables them. dittoViz::yPlot
                # sets boxpoints = FALSE natively, so no post-hoc removal needed.
                boxplot.show.outliers = isolate_fn(input$boxplot.show.outliers) &&
                    !("jitter" %in% isolate_fn(input$plots)),
                boxplot.fill = isolate_fn(input$boxplot.fill),
                boxplot.lineweight = isolate_fn(input$boxplot.lineweight),
                vlnplot.lineweight = isolate_fn(input$vlnplot.lineweight),
                vlnplot.scaling = isolate_fn(input$vlnplot.scaling),
                vlnplot.width = 1 - isolate_fn(input$boxgap),
                ridgeplot.lineweight = isolate_fn(input$ridgeplot.lineweight),
                ridgeplot.scale = isolate_fn(input$ridgeplot.scale),
                ridgeplot.ymax.expansion = ridgeplot.ymax.expansion,
                ridgeplot.shape = isolate_fn(input$ridgeplot.shape),
                ridgeplot.bins = isolate_fn(input$ridgeplot.bins),
                ridgeplot.binwidth = ridgeplot.binwidth,
                legend.show = TRUE,
                theme = theme_style
            )

            fig <- p |>
                layout(
                    boxmode = ifelse(!color.by == isolate_fn(input$group.by), "group", "overlay"),
                    boxgap = isolate_fn(input$boxgap),
                    boxgroupgap = isolate_fn(input$boxgroupgap)
                )
            if (!is.null(split.by) && nzchar(split.by)) {
                fig <- apply_facet_subplot_spacing(
                    fig,
                    spacing = c(isolate_fn(input$subplot.margin.x), isolate_fn(input$subplot.margin.y)),
                    ncol = split.ncol,
                    nrow = split.nrow
                )

            }
            fig <- apply_title_layout(fig, input, isolate_fn, title_y = 0.98, title_x = isolate_fn(input$axis.title.horizontal.position))
            
            


            # Fix boxplot positioning across faceted subplots
            if (!is.null(split.by) && nzchar(split.by)) {
                fig <- .fix_boxplot_facet_positions(fig)
            }

            # Apply axis styling (borders handled at the ggplot level via theme_style above)
            xaxis_style <- create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)


            # Apply axis title font to shared facet annotation titles
            if (!is.null(split.by) && nzchar(split.by)) {
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


            config_list <- add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = split.by)
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
        output$yPlot <- renderPlotly({
            req(input$var)

            fig <- apply_render_margins(generate_yPlot(), input)
            fig <- finalize_manual_edits(
                fig, plot_source, edit_store, session,
                regen_keys = isolate(regen_keys_rv())
            )

            return(fig)
        })

        # Download handler for source (plot + data + stats)
        # Capture all UI inputs for the source download
        AllInputs <- reactive({
            x <- reactiveValuesToList(input)
            return(x)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_yPlot,
                stats_reactive = last_stats_df,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "yPlot_source"
        )

        return(plot_source_reactive)
    })
}
