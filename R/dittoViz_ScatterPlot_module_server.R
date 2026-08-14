#' Server logic for scatterPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot. Values that are not
#'   data frames are coerced with [as.data.frame()]; a `NULL` value is treated as
#'   "not ready yet" and the module waits for data.
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
#' @return The `moduleServer` function for the scatterPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom dittoViz scatterPlot colLevels
#' @importFrom ggplot2 theme_bw waiver theme
#' @importFrom shinyjs hide runjs delay
#' @importFrom stats setNames
#' @importFrom colourpicker colourInput updateColourInput
#'
#' @seealso [dittoViz::scatterPlot()], [VizModules::dittoViz_scatterPlotInputsUI()],
#' [VizModules::dittoViz_scatterPlotOutputUI()], [VizModules::dittoViz_scatterPlotApp()]
#'
#' @export
#' @author Jared Andrews
dittoViz_scatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))
    data <- .require_data_frame(data)

    moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)
        ns <- session$ns
        default_palette_values <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
        # Unique source ID for plotly event_data, scoped to this module instance
        plot_source <- session$ns("scatter")
        # Hide individual inputs/tabs if specified. The inputs UI is injected by the
        # parent app via renderUI (and re-injected when the dataset changes), so the
        # hiding must be (re)applied after the controls exist in the DOM rather than
        # once at module initialization.
        if (!is.null(hide.inputs) || !is.null(hide.tabs)) {
            observeEvent(data(), {
                delay(100, {
                    hide_input(session, hide.inputs)
                    for (tab.name in hide.tabs) hideTab(inputId = "scatterPlotTabsetPanel", target = tab.name)
                })
            })
        }

        # Keep the X/Y data selectors in step with the data. Only refresh when
        # the set of columns actually changes (not on every row-filter), to
        # preserve the user's current selection. Mirrors the analogous `var`
        # refresh in dittoViz_yPlotServer(): the InputsUI is often built from a
        # light placeholder frame (e.g. a handful of columns) while the true
        # `data` reactive carries the full column set (e.g. a wide gene table),
        # so choices/selections must be refreshed once real data flows in.
        xy_choice_cache <- reactiveVal(NULL)
        observeEvent(data(), {
            df <- data()
            req(df)
            cols <- names(df)
            if (identical(cols, xy_choice_cache())) {
                return()
            }
            xy_choice_cache(cols)
            choices <- c("", cols)

            current.x <- isolate(input$x.by)
            default.x <- get_default(
                defaults, "x.by",
                if (length(cols)) cols[1] else "",
                function(x) x %in% choices
            )
            selected.x <- if (!is.null(current.x) && nzchar(current.x) && current.x %in% choices) {
                current.x
            } else {
                default.x
            }
            update_viz_select(session, "x.by", choices = choices, selected = selected.x)

            current.y <- isolate(input$y.by)
            default.y <- get_default(
                defaults, "y.by",
                if (length(cols) > 1) cols[2] else "",
                function(x) x %in% choices
            )
            selected.y <- if (!is.null(current.y) && nzchar(current.y) && current.y %in% choices) {
                current.y
            } else {
                default.y
            }
            update_viz_select(session, "y.by", choices = choices, selected = selected.y)
        }, ignoreNULL = TRUE)

        # Available color groups for the current color.by selection
        # NOTE: We intentionally don't use colLevels() here because it converts
        # to character then back to factor, which sorts levels alphabetically.
        # ggplot2/dittoViz respect the original factor level order, so we must too.
        color_levels <- reactive({
            df <- data()
            color_by <- input$color.by

            if (is.null(df) || is.null(color_by) || color_by == "" || !color_by %in% names(df)) {
                return(character(0))
            }

            col_data <- df[[color_by]]

            if (is.numeric(col_data)) {
                return(character(0))
            }

            # For factors, use the defined levels (preserves order)
            # For character/other, convert to factor (alphabetical order)
            if (is.factor(col_data)) {
                levels(col_data)
            } else {
                levels(as.factor(col_data))
            }
        })

        # Render the multiColorPicker for discrete color mappings or single colourInput
        output$color.panel.ui <- renderUI({
            groups <- color_levels()

            if (length(groups) == 0) {
                # No grouping - show single color picker for point color
                initial_color <- isolate(input$single.point.color)
                if (is.null(initial_color) || !nzchar(initial_color)) {
                    initial_color <- get_default(defaults, "single.point.color", "#000000", is.character)
                }
                return(colourInput(
                    ns("single.point.color"),
                    label = "Point color",
                    value = initial_color
                ))
            }

            initial_colors <- isolate(resolve_palette(
                groups, input$color.panel, default_palette_values,
                .default_group_colors(defaults, "color.panel")
            ))

            # The rebuilt picker reports its value on a client round-trip. Pause
            # readers until it does, so the plot renders once rather than twice.
            freezeReactiveValue(input, "color.panel")

            multiColorPicker(
                ns("color.panel"),
                label = "Color palette",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = "dittoColors",
                colors = initial_colors,
                compact = TRUE
            )
        })

        # Get color panel aligned to the current groups
        color.panel <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            levels <- color_levels()

            # When there are no color levels, use single point color
            if (length(levels) == 0) {
                single_color <- isolate_fn(input$single.point.color)
                if (!is.null(single_color) && nzchar(single_color)) {
                    return(single_color)
                } else {
                    return(get_default(defaults, "single.point.color", default_palette_values[1], is.character))
                }
            }

            resolve_palette(
                levels,
                isolate_fn(input$color.panel),
                default_palette_values,
                .default_group_colors(defaults, "color.panel")
            )
        })

        # Store for manual layout edits (legend/annotation/axis-title/colorbar
        # moves) so they persist across re-renders. See setup_manual_edits().
        edit_store <- setup_manual_edits(input, session, plot_source)

        # Axis side(s) whose title is regenerated (not persisted) because a data
        # adjustment is active; set inside generate_scatterPlot() and read at render.
        regen_keys_rv <- reactiveVal(character(0))

        # x/y variables at the last build; when one changes we drop any persisted
        # manual title text for that axis so it regenerates for the new variable.
        last_axis_by <- reactiveVal(NULL)

        # dataframe of selected data, which is added to with multiple selections
        selected.data <- reactiveVal()

        # Observer to add selected data to selected.data
        observeEvent(
            event_data("plotly_selected", source = plot_source),
            {
                selected <- event_data("plotly_selected", source = plot_source)
                selected.full <- rbind(selected.data(), selected)

                # Since this is running on every selection, remove duplicates
                keep <- selected.full[!duplicated(selected.full), ]

                if (nrow(keep) == 0) {
                    selected.data(NULL)
                } else {
                    selected.data(keep)
                }
            }
        )

        # Observer to clear selected data
        observeEvent(input$annotation.clear, {
            selected.data(NULL)
        })

        # Reset all inputs to defaults
        observeEvent(input$reset, {
            # Get data for defaults
            choices <- c("", names(data()))
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])
            cat.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])

            # Data
            update_viz_select(session, "x.by",
                selected = get_default(defaults, "x.by", choices[2], function(x) x %in% choices)
            )
            update_viz_select(session, "y.by",
                selected = get_default(defaults, "y.by", choices[3], function(x) x %in% choices)
            )
            update_viz_select(session, "color.by",
                selected = get_default(defaults, "color.by", "", function(x) x == "" || x %in% choices)
            )
            update_viz_select(session, "shape.by",
                selected = get_default(defaults, "shape.by", "", function(x) x == "" || x %in% choices)
            )
            update_viz_select(session, "split.by",
                selected = get_default(defaults, "split.by", "", function(x) x == "" || x %in% choices)
            )

            # Adjustments
            update_viz_select(session, "x.adjustment", selected = get_default(defaults, "x.adjustment", ""))
            update_viz_select(session, "y.adjustment", selected = get_default(defaults, "y.adjustment", ""))
            update_viz_select(session, "color.adjustment", selected = get_default(defaults, "color.adjustment", ""))
            update_viz_select(session, "x.adj.fxn", selected = get_default(defaults, "x.adj.fxn", ""))
            update_viz_select(session, "y.adj.fxn", selected = get_default(defaults, "y.adj.fxn", ""))
            update_viz_select(session, "color.adj.fxn", selected = get_default(defaults, "color.adj.fxn", ""))

            # Points
            update_viz_select(session, "size.by", selected = get_default(defaults, "size.by", ""))
            updateNumericInput(session, "size", value = get_default(defaults, "size", 1, is.numeric))
            updateNumericInput(session, "opacity", value = get_default(defaults, "opacity", 1, is.numeric))
            updateCheckboxInput(session, "show.others",
                value = get_default(defaults, "show.others", TRUE, is.logical)
            )
            updateCheckboxInput(session, "split.show.all.others",
                value = get_default(defaults, "split.show.all.others", TRUE, is.logical)
            )
            update_viz_select(session, "plot.order", selected = get_default(defaults, "plot.order", "unordered"))
            updateTextInput(session, "shape.panel",
                value = get_default(defaults, "shape.panel", "16, 15, 17, 23, 25, 8")
            )

            # Colors
            updateColourInput(session, "min.color",
                value = get_default(defaults, "min.color", "#F0E442")
            )
            updateColourInput(session, "max.color",
                value = get_default(defaults, "max.color", "#0072B2")
            )
            updateColourInput(session, "contour.color",
                value = get_default(defaults, "contour.color", "black")
            )
            update_viz_select(session, "contour.linetype",
                selected = get_default(defaults, "contour.linetype", "solid")
            )
            updateColourInput(session, "single.point.color",
                value = get_default(defaults, "single.point.color", "#000000")
            )

            # Reset multiColorPicker to the supplied mapping, or its initial palette
            .reset_group_colors(session, "color.panel", defaults, color_levels(), default_palette_values)

            # Facets
            updateNumericInput(session, "split.nrow", value = get_default(defaults, "split.nrow", NA, is.numeric))
            updateNumericInput(session, "split.ncol", value = get_default(defaults, "split.ncol", NA, is.numeric))
            update_viz_select(session, "multivar.split.dir",
                selected = get_default(defaults, "multivar.split.dir", "col")
            )
            update_viz_select(session, "split.adjust.scales",
                selected = get_default(defaults, "split.adjust.scales", "fixed")
            )

            # Annotations
            update_viz_select(session, "annotate.by",
                selected = get_default(defaults, "annotate.by", "", function(x) x == "" || x %in% choices)
            )
            updateTextAreaInput(session, "highlight.points",
                value = get_default(defaults, "highlight.points", "")
            )
            updateColourInput(session, "highlight.color",
                value = get_default(defaults, "highlight.color", "#00FFF7")
            )
            updateNumericInput(session, "highlight.size",
                value = get_default(defaults, "highlight.size", 7, is.numeric)
            )
            updateColourInput(session, "highlight.border.color",
                value = get_default(defaults, "highlight.border.color", "#000000")
            )
            updateNumericInput(session, "highlight.border.width",
                value = get_default(defaults, "highlight.border.width", 1, is.numeric)
            )
            updateCheckboxInput(session, "highlight.auto.annotate",
                value = get_default(defaults, "highlight.auto.annotate", TRUE, is.logical)
            )
            updateColourInput(session, "annotation.color",
                value = get_default(defaults, "annotation.color", "black")
            )
            updateNumericInput(session, "annotation.ax",
                value = get_default(defaults, "annotation.ax", 20, is.numeric)
            )
            updateNumericInput(session, "annotation.ay",
                value = get_default(defaults, "annotation.ay", -20, is.numeric)
            )
            updateNumericInput(session, "annotation.size",
                value = get_default(defaults, "annotation.size", 10, is.numeric)
            )
            updateCheckboxInput(session, "annotation.showarrow",
                value = get_default(defaults, "annotation.showarrow", TRUE, is.logical)
            )
            updateColourInput(session, "annotation.arrowcolor",
                value = get_default(defaults, "annotation.arrowcolor", "black")
            )
            updateNumericInput(session, "annotation.arrowhead",
                value = get_default(defaults, "annotation.arrowhead", 2, is.numeric)
            )
            updateNumericInput(session, "annotation.arrowwidth",
                value = get_default(defaults, "annotation.arrowwidth", 1.5, is.numeric)
            )

            # Legend
            updateCheckboxInput(session, "legend.show",
                value = get_default(defaults, "legend.show", TRUE, is.logical)
            )
            updateTextInput(session, "legend.color.title",
                value = get_default(defaults, "legend.color.title", "make")
            )
            updateTextInput(session, "legend.color.breaks",
                value = get_default(defaults, "legend.color.breaks", "")
            )
            updateNumericInput(session, "min.value", value = get_default(defaults, "min.value", NA, is.numeric))
            updateNumericInput(session, "max.value", value = get_default(defaults, "max.value", NA, is.numeric))

            # Trajectory
            update_viz_select(session, "trajectory.group.by",
                selected = get_default(defaults, "trajectory.group.by", "", function(x) x == "" || x %in% choices)
            )
            updateTextInput(session, "add.trajectory.by.groups",
                value = get_default(defaults, "add.trajectory.by.groups", "")
            )
            updateNumericInput(session, "trajectory.arrow.size",
                value = get_default(defaults, "trajectory.arrow.size", 0.15, is.numeric)
            )

            # Plotly/Extras
            updateCheckboxInput(session, "webgl", value = get_default(defaults, "webgl", TRUE, is.logical))
            reset_plotly_inputs(session, defaults)
            reset_legend_inputs(session, defaults)
            updateNumericInput(session, "size.legend.x",
                value = get_default(defaults, "size.legend.x", 1.04, is.numeric)
            )
            updateNumericInput(session, "size.legend.y",
                value = get_default(defaults, "size.legend.y", 0.35, is.numeric)
            )
            updateCheckboxInput(session, "do.ellipse",
                value = get_default(defaults, "do.ellipse", FALSE, is.logical)
            )
            updateCheckboxInput(session, "do.contour",
                value = get_default(defaults, "do.contour", FALSE, is.logical)
            )
            update_viz_select(session, "hover.data",
                selected = get_default(defaults, "hover.data", "", function(x) x == "" || x %in% choices)
            )
            updateNumericInput(session, "hover.round.digits",
                value = get_default(defaults, "hover.round.digits", 5, is.numeric)
            )

            # Lines & Axes
            reset_lines_inputs(session, include.fit.lines = TRUE, defaults = defaults)
            reset_axes_inputs(session, defaults)

            # Discard captured manual layout edits so positions revert to defaults
            edit_store$legend <- NULL
            edit_store$annotations <- list()
            edit_store$colorbar <- NULL
        })

        observeEvent(input$split.by, {
            if (!is.null(input$split.by) && any(nzchar(input$split.by))) {
                show_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            } else {
                hide_input(session, c("facet.title.font.size", "facet.title.font.color", "facet.title.font.family"))
            }
        })

        # Reactive expression to generate the plot (used by both output and download)
        generate_scatterPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input, params)

            # Change textInputs and selectInputs to NULL if empty
            null.na.inputs <- list(
                "trajectory.group.by" = .na_to_null(isolate_fn(input$trajectory.group.by)),
                "add.trajectory.by.groups" = .na_to_null(isolate_fn(input$add.trajectory.by.groups)),
                "color.by" = .na_to_null(isolate_fn(input$color.by)),
                "shape.by" = .na_to_null(isolate_fn(input$shape.by)),
                "size.by" = .na_to_null(isolate_fn(input$size.by)),
                "split.by" = .na_to_null(isolate_fn(input$split.by)),
                "annotate.by" = .na_to_null(isolate_fn(input$annotate.by)),
                "x.adjustment" = .na_to_null(isolate_fn(input$x.adjustment)),
                "y.adjustment" = .na_to_null(isolate_fn(input$y.adjustment)),
                "color.adjustment" = .na_to_null(isolate_fn(input$color.adjustment)),
                "x.adj.fxn" = .na_to_null(isolate_fn(input$x.adj.fxn)),
                "y.adj.fxn" = .na_to_null(isolate_fn(input$y.adj.fxn)),
                "color.adj.fxn" = .na_to_null(isolate_fn(input$color.adj.fxn)),
                "split.nrow" = .na_to_null(isolate_fn(input$split.nrow)),
                "split.ncol" = .na_to_null(isolate_fn(input$split.ncol)),
                "hover.data" = .na_to_null(isolate_fn(input$hover.data))
            )

            # Waiver inputs
            waiver.inputs <- list(
                "legend.color.breaks" = isolate_fn(input$legend.color.breaks)
            )

            # If input is empty, set to waiver()
            for (input.name in names(waiver.inputs)) {
                if (waiver.inputs[[input.name]] == "") {
                    waiver.inputs[[input.name]] <- waiver()
                } else {
                    waiver.inputs[[input.name]] <- as.numeric(.string_to_vector(waiver.inputs[[input.name]]))
                }
            }

            # Collect hover data
            if (identical(null.na.inputs$hover.data, NULL)) {
                hover.data <- unique(c(
                    null.na.inputs$annotate.by,
                    null.na.inputs$color.by,
                    paste0(null.na.inputs$color.by, ".color.adj"),
                    "color.multi", "color.which",
                    isolate_fn(input$x.by),
                    paste0(isolate_fn(input$x.by), ".x.adj"),
                    isolate_fn(input$y.by),
                    paste0(isolate_fn(input$y.by), ".y.adj"),
                    null.na.inputs$shape.by,
                    null.na.inputs$split.by,
                    null.na.inputs$size.by
                ))
            } else {
                hover.data <- unique(c(null.na.inputs$hover.data, null.na.inputs$annotate.by))
            }

            palette_values <- isolate_fn(color.panel())
            current_color_levels <- isolate_fn(color_levels())

            additional_theme <- create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_style <- theme_bw() + theme(
                panel.border = additional_theme$panel.border,
                axis.line = additional_theme$axis.line,
                axis.ticks = additional_theme$axis.ticks,
                strip.background = element_blank()
            )
              
            # Reflect any applied data adjustments in the axis titles so they
            # accurately describe the values displayed (e.g. "log2(z-score(units))").
            x_axis_label <- adjusted_axis_label(
                isolate_fn(input$x.by), null.na.inputs$x.adjustment, isolate_fn(input$x.adj.fxn)
            )
            y_axis_label <- adjusted_axis_label(
                isolate_fn(input$y.by), null.na.inputs$y.adjustment, isolate_fn(input$y.adj.fxn)
            )

            # Flag axis sides whose title is adjustment-derived so finalize_manual_edits()
            # regenerates rather than persists their text. adjusted_axis_label() returns the
            # base unchanged when no adjustment, so a difference means an adjustment is active.
            regen_keys_rv(c(
                if (!identical(x_axis_label, isolate_fn(input$x.by))) "axis:x",
                if (!identical(y_axis_label, isolate_fn(input$y.by))) "axis:y"
            ))

            # When the x or y variable changes, drop any persisted manual title text for
            # that side so it regenerates for the new variable (position still persists).
            # Runs before finalize_manual_edits() in the same render pass.
            cur_by <- list(x = isolate_fn(input$x.by), y = isolate_fn(input$y.by))
            prev_by <- last_axis_by()
            if (!identical(cur_by, prev_by)) {
                if (is.null(prev_by) || !identical(cur_by$x, prev_by$x)) {
                    reset_axis_title_text(edit_store, "axis:x")
                }
                if (is.null(prev_by) || !identical(cur_by$y, prev_by$y)) {
                    reset_axis_title_text(edit_store, "axis:y")
                }
                last_axis_by(cur_by)
            }

            # Reflect any applied color data adjustments in the color.by legend title so it
            # accurately describes the values displayed (e.g. "log2(z-score(units))"). Only
            # the auto-generated title ("make") is rewritten so user-supplied titles are kept.
            legend_color_title <- isolate_fn(input$legend.color.title)
            color_adjustment_active <- !is.null(null.na.inputs$color.adjustment) ||
                !is.null(null.na.inputs$color.adj.fxn)
            if (identical(legend_color_title, "make") &&
                !is.null(null.na.inputs$color.by) && color_adjustment_active) {
                legend_color_title <- adjusted_axis_label(
                    null.na.inputs$color.by, null.na.inputs$color.adjustment, null.na.inputs$color.adj.fxn
                )
            }

            p <- scatterPlot(
                data(),
                x.by = isolate_fn(input$x.by),
                y.by = isolate_fn(input$y.by),
                # Blank main title by default; dittoViz's "make" would otherwise
                # auto-generate one and re-render it every rebuild.
                main = NULL,
                xlab = x_axis_label,
                ylab = y_axis_label,
                color.by = null.na.inputs$color.by,
                shape.by = null.na.inputs$shape.by,
                split.by = null.na.inputs$split.by,
                size = if (!is.null(null.na.inputs$size.by)) {
                    null.na.inputs$size.by
                } else {
                    isolate_fn(input$size)
                },
                show.others = isolate_fn(input$show.others),
                x.adjustment = null.na.inputs$x.adjustment,
                y.adjustment = null.na.inputs$y.adjustment,
                color.adjustment = null.na.inputs$color.adjustment,
                x.adj.fxn = safe_resolve_adj_fxn(isolate_fn(input$x.adj.fxn)),
                y.adj.fxn = safe_resolve_adj_fxn(isolate_fn(input$y.adj.fxn)),
                color.adj.fxn = safe_resolve_adj_fxn(isolate_fn(input$color.adj.fxn)),
                split.show.all.others = isolate_fn(input$split.show.all.others),
                opacity = isolate_fn(input$opacity),
                color.panel = unname(palette_values),
                colors = if (length(palette_values) > 0) seq_len(length(palette_values)) else NULL,
                split.nrow = null.na.inputs$split.nrow,
                split.ncol = null.na.inputs$split.ncol,
                split.adjust = list(scales = isolate_fn(input$split.adjust.scales)),
                multivar.split.dir = isolate_fn(input$multivar.split.dir),
                shape.panel = as.numeric(.string_to_vector(isolate_fn(input$shape.panel))),
                rename.color.groups = NULL,
                rename.shape.groups = NULL,
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                min.value = isolate_fn(input$min.value),
                max.value = isolate_fn(input$max.value),
                plot.order = isolate_fn(input$plot.order),
                theme = theme_style,
                do.hover = TRUE,
                hover.data = hover.data,
                hover.round.digits = isolate_fn(input$hover.round.digits),
                do.contour = isolate_fn(input$do.contour),
                contour.color = isolate_fn(input$contour.color),
                contour.linetype = isolate_fn(input$contour.linetype),
                add.trajectory.by.groups = .string_to_list_of_vectors(null.na.inputs$add.trajectory.by.groups),
                trajectory.group.by = null.na.inputs$trajectory.group.by,
                trajectory.arrow.size = isolate_fn(input$trajectory.arrow.size),
                do.ellipse = isolate_fn(input$do.ellipse),
                legend.show = isolate_fn(input$legend.show),
                legend.color.title = legend_color_title,
                legend.color.breaks = waiver.inputs$legend.color.breaks,
                legend.color.breaks.labels = waiver(),
                legend.shape.title = null.na.inputs$shape.by,
                data.out = TRUE
            )
            
            plot_data <- p$Target_data
            # Colour mapping for fit lines â€” palette_values from color.panel() is already
            # fully resolved (match â†’ fallback â†’ rep_len â†’ setNames), so reuse it directly.
            color_mapping <- if (!is.null(null.na.inputs$color.by) && length(current_color_levels) > 0) {
                palette_values
            } else {
                NULL
            }

            if (!is.null(null.na.inputs$split.by)) {
                config_list <- add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = TRUE)
            } else {
                config_list <- add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE)
            }
            fig <- do.call(config, c(list(p = p$plot), config_list))

            if (!is.null(null.na.inputs$split.by) && any(nzchar(null.na.inputs$split.by))) {
                fig <- apply_facet_subplot_spacing(
                    fig,
                    spacing = c(isolate_fn(input$subplot.margin.x), isolate_fn(input$subplot.margin.y)),
                    ncol = null.na.inputs$split.ncol,
                    nrow = null.na.inputs$split.nrow
                )
            }

            # Apply single point color when color.by is not set
            if (is.null(null.na.inputs$color.by) && !is.null(fig$x$data)) {
                single_pt_color <- isolate_fn(input$single.point.color)
                if (!is.null(single_pt_color) && nzchar(single_pt_color)) {
                    for (i in seq_along(fig$x$data)) {
                        trace <- fig$x$data[[i]]
                        # Only modify scatter traces with markers (not lines, shapes, etc.)
                        if (!is.null(trace$mode) && grepl("markers", trace$mode)) {
                            fig$x$data[[i]]$marker$color <- single_pt_color
                            # Also apply to marker border/outline
                            if (is.null(fig$x$data[[i]]$marker$line)) {
                                fig$x$data[[i]]$marker$line <- list()
                            }
                            fig$x$data[[i]]$marker$line$color <- single_pt_color
                        }
                    }
                }
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


            # Apply highlight styling to specified points
            highlight_points_raw <- isolate_fn(input$highlight.points)
            if (!is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                # Remove empty strings that may result from parsing
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    # Get styling parameters
                    hl_color <- isolate_fn(input$highlight.color)
                    hl_size <- isolate_fn(input$highlight.size)
                    hl_border_color <- isolate_fn(input$highlight.border.color)
                    hl_border_width <- isolate_fn(input$highlight.border.width)

                    # Find indices of points to highlight in plot_data
                    annotate_col <- null.na.inputs$annotate.by
                    if (annotate_col %in% names(plot_data)) {
                        highlight_idx <- which(as.character(plot_data[[annotate_col]]) %in% highlight_vals)

                        if (length(highlight_idx) > 0 && !is.null(fig$x$data)) {
                            # Iterate through traces and modify marker properties
                            for (i in seq_along(fig$x$data)) {
                                trace <- fig$x$data[[i]]

                                # Skip traces that should not be included
                                if (!.should_include_trace(trace, isolate_fn(input$show.others))) {
                                    next
                                }

                                trace_n <- length(trace$x)

                                # Initialize marker properties if not present
                                if (is.null(trace$marker)) {
                                    fig$x$data[[i]]$marker <- list()
                                }

                                # Get current marker properties (may be single value or vector)
                                cur_color <- trace$marker$color
                                cur_size <- if (!is.null(trace$marker$size)) {
                                    trace$marker$size
                                } else {
                                    isolate_fn(input$size)
                                }
                                cur_line_color <- if (!is.null(trace$marker$line$color)) {
                                    trace$marker$line$color
                                } else {
                                    "transparent"
                                }
                                cur_line_width <- if (!is.null(trace$marker$line$width)) {
                                    trace$marker$line$width
                                } else {
                                    0
                                }

                                # Expand to vectors if single values
                                if (length(cur_color) == 1) cur_color <- rep(cur_color, trace_n)
                                if (length(cur_size) == 1) cur_size <- rep(cur_size, trace_n)
                                if (length(cur_line_color) == 1) cur_line_color <- rep(cur_line_color, trace_n)
                                if (length(cur_line_width) == 1) cur_line_width <- rep(cur_line_width, trace_n)

                                # Build trace annotation mapping
                                trace_map <- .build_trace_anno_map(trace, isolate_fn(input$annotate.by))
                                if (is.null(trace_map)) {
                                    next
                                }

                                # Find which points in this trace should be highlighted.
                                # Match on the annotation value alone rather than on
                                # coordinates: ggplotly encodes categorical (factor) axes
                                # as numeric positions that will not match the raw data
                                # values in plot_data, which would otherwise drop the
                                # highlight styling for categorical x/y axes.
                                trace_highlight_mask <- trace_map$anno_value %in% highlight_vals

                                if (any(trace_highlight_mask)) {
                                    # Apply highlight styling
                                    if (!is.null(hl_color) && hl_color != "" && hl_color != "transparent") {
                                        cur_color[trace_highlight_mask] <- hl_color
                                    }
                                    if (!is.null(hl_size) && !is.na(hl_size)) {
                                        cur_size[trace_highlight_mask] <- hl_size
                                    }
                                    if (!is.null(hl_border_color) && hl_border_color != "") {
                                        cur_line_color[trace_highlight_mask] <- hl_border_color
                                    }
                                    if (!is.null(hl_border_width) && !is.na(hl_border_width)) {
                                        cur_line_width[trace_highlight_mask] <- hl_border_width
                                    }

                                    # Update trace marker properties
                                    fig$x$data[[i]]$marker$color <- cur_color
                                    fig$x$data[[i]]$marker$size <- cur_size
                                    fig$x$data[[i]]$marker$line <- list(
                                        color = cur_line_color,
                                        width = cur_line_width
                                    )
                                }
                            }
                        }
                    }
                }
            }

            # Create annotation parameters (used for both manual and auto annotations)
            annotation_params <- list(
                ax = isolate_fn(input$annotation.ax),
                ay = isolate_fn(input$annotation.ay),
                showarrow = isolate_fn(input$annotation.showarrow),
                arrowcolor = isolate_fn(input$annotation.arrowcolor),
                arrowhead = isolate_fn(input$annotation.arrowhead),
                arrowwidth = isolate_fn(input$annotation.arrowwidth),
                size = isolate_fn(input$annotation.size),
                color = isolate_fn(input$annotation.color)
            )

            if (!is.null(null.na.inputs$annotate.by) && !is.null(selected.data())) {
                # Create annotations for selected points using helper function
                annos <- .create_selected_annotations(
                    selected_data = selected.data(),
                    fig = fig,
                    annotate.by = isolate_fn(input$annotate.by),
                    annotation_params = annotation_params,
                    show.others = isolate_fn(input$show.others)
                )
            } else {
                annos <- NULL
            }

            # Auto-annotate highlighted points if enabled
            if (isTRUE(isolate_fn(input$highlight.auto.annotate)) &&
                !is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    # Create annotations for highlighted points
                    highlight_annos <- .create_highlight_annotations(
                        plot_data = plot_data,
                        fig = fig,
                        annotate.by = isolate_fn(input$annotate.by),
                        highlight_vals = highlight_vals,
                        x_col = isolate_fn(input$x.by),
                        y_col = isolate_fn(input$y.by),
                        annotation_params = annotation_params,
                        show.others = isolate_fn(input$show.others)
                    )

                    # Combine with existing annotations (avoiding duplicates)
                    if (!is.null(highlight_annos)) {
                        if (is.null(annos)) {
                            annos <- highlight_annos
                        } else {
                            # Helper to create unique key for an annotation
                            get_anno_key <- function(a) {
                                paste0(.create_coord_id(a$x, a$y), "_", a$text)
                            }

                            existing_keys <- vapply(annos, get_anno_key, character(1))

                            # Add only highlight annotations that don't already exist
                            for (ha in highlight_annos) {
                                ha_key <- get_anno_key(ha)
                                if (!ha_key %in% existing_keys) {
                                    annos <- c(annos, list(ha))
                                    existing_keys <- c(existing_keys, ha_key)
                                }
                            }
                        }
                    }
                }
            }

            fig <- apply_plotly_newshape(fig, input, isolate_fn)
            fig <- fig |> layout(annotations = annos)
            fig <- apply_title_layout(fig, input, isolate_fn, title_y = 0.98, title_x = isolate_fn(input$axis.title.horizontal.position))

            # Apply axis styling to all subplot axes (handles faceting/split.by)
            xaxis_style <- create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = TRUE)
            yaxis_style <- create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling =  TRUE)

            fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            # Apply axis title font to shared facet annotation titles
            if (!is.null(null.na.inputs$split.by) && any(nzchar(null.na.inputs$split.by))) {
                fig <- apply_axis_title_to_annotations(fig, input, isolate_fn)
            }

            if (isolate_fn(input$webgl)) {
                # Fix hover data issue with toWebGL() when there are layers without proper text attributes
                # Layers with a single text element (length == 1) are typically background/other layers
                # that don't have meaningful hover data. These interfere with hover functionality when
                # converted to WebGL, so we skip hover info for them.
                if (!is.null(fig$x) && !is.null(fig$x$data)) {
                    for (i in seq_along(fig$x$data)) {
                        if (!is.null(fig$x$data[[i]]$text) && length(fig$x$data[[i]]$text) == 1) {
                            fig$x$data[[i]]$hoverinfo <- "skip"
                        }
                    }
                }
                fig <- fig |> toWebGL()
            }

            # Add fit lines if requested
            # Determine grouping
            group_col <- if (!is.null(input$color.by) && input$color.by != "") {
                input$color.by
            } else {
                NULL
            }

            # Linear model fits
            if (isTRUE(input$linear.model)) {
                fig <- .add_fit_lines_to_subplots(
                    fig = fig,
                    df = data(),
                    x.col = isolate_fn(input$x.by),
                    y.col = isolate_fn(input$y.by),
                    split.by = null.na.inputs$split.by,
                    group.col = group_col,
                    color_mapping = color_mapping,
                    line_color = input$line.best.colour,
                    fit_type = "linear",
                    line_width = 3
                )
            } else if (isTRUE(input$best.fit)) {
                # LOESS smooth fit lines (only if linear model not selected)
                fig <- .add_fit_lines_to_subplots(
                    fig = fig,
                    df = data(),
                    x.col = isolate_fn(input$x.by),
                    y.col = isolate_fn(input$y.by),
                    split.by = null.na.inputs$split.by,
                    group.col = group_col,
                    color_mapping = color_mapping,
                    line_color = input$line.best.colour,
                    fit_type = "loess",
                    span = input$line.best.smoothness,
                    line_width = 3
                )
            }

            # User-defined custom model lines from the multiDynamicInput. Each
            # row supplies a model_type, formula, colour and width, plus any
            # backend-specific extra fields. Formula text is validated by
            # .safe_build_model() (allow-listed fit function + AST whitelist),
            # so no arbitrary code is executed.
            if (isTRUE(input$custom.model.enable)) {
                model_rows <- isolate_fn(input$custom.models)
                if (!is.null(model_rows) && length(model_rows) > 0) {
                    for (row_name in names(model_rows)) {
                        row <- model_rows[[row_name]]
                        formula_text <- row$formula
                        if (is.null(formula_text) || !nzchar(trimws(formula_text))) {
                            next
                        }
                        # Collect extra fields beyond the known UI keys and
                        # forward them to the backend's fit function via ...
                        known_keys <- c("model_type", "formula", "line_colour", "line_width")
                        extra_args <- row[!names(row) %in% known_keys]
                        user_model <- do.call(.safe_build_model, c(
                            list(formula_text = formula_text,
                                 data         = data(),
                                 fit_fn_name  = row$model_type),
                            extra_args
                        ))
                        if (!is.null(user_model)) {
                            line_w <- suppressWarnings(as.numeric(row$line_width))
                            if (is.na(line_w)) line_w <- 2
                            backend <- get_model_backend(row$model_type)
                            fig <- .add_custom_model_lines_to_subplots(
                                fig           = fig,
                                df            = data(),
                                x.col         = isolate_fn(input$x.by),
                                custom.models = setNames(list(user_model), row_name),
                                split.by      = null.na.inputs$split.by,
                                line_color    = row$line_colour %__% "#000000",
                                line_width    = line_w,
                                backend       = backend
                            )
                        } else {
                            showNotification(
                                paste0(
                                    "Model '", row_name, "' was rejected. Use only ",
                                    "data columns and basic math/transform terms ",
                                    "(e.g. '", isolate_fn(input$y.by), " ~ poly(",
                                    isolate_fn(input$x.by), ", 2)')."
                                ),
                                type = "warning"
                            )
                        }
                    }
                }
            }

            # Custom size legend:
            # plotly drops the size legend when point size encodes a numeric
            # column (see plotly.R#705), so draw a manual circle legend that
            # mirrors the plotted marker sizes when `size.by` is set.
            fig <- .custom_legend(
                fig,
                data = data(),
                size_by = null.na.inputs$size.by,
                gap = 0.04,
                title.size = isolate_fn(input$legend.title.size),
                text.size = isolate_fn(input$legend.text.size),
                start_y = isolate_fn(input$size.legend.y),
                start_x = isolate_fn(input$size.legend.x)
            )

            # Apply uniform legend title/label font sizes
            fig <- apply_legend_styling(
                fig,
                title.size = isolate_fn(input$legend.title.size),
                text.size = isolate_fn(input$legend.text.size)
            )

            # Make single-panel x/y axis titles draggable (matches faceted behaviour)
            fig <- axis_titles_as_annotations(fig)

            fig
        })

        # Render the plot output
        output$scatterPlot <- renderPlotly({
            req(input$x.by, input$y.by, data())

            fig <- apply_render_margins(generate_scatterPlot(), input)
            # Restore manually repositioned legend/annotations/axis titles/colorbar
            # so they survive rebuilds, and wire up edit capture for this figure.
            fig <- finalize_manual_edits(
                fig, plot_source, edit_store, session,
                regen_keys = isolate(regen_keys_rv())
            )
            fig
        })

        # Download handler for source (plot + data)
        # Capture all UI inputs for the source download
        AllInputs <- reactive({
            x <- reactiveValuesToList(input)
            return(x)
        })

        plot_source_reactive <- reactive({
            collect_source_data(
                plot_reactive = generate_scatterPlot,
                inputs_reactive = AllInputs()
            )
        })

        output$download.source <- create_source_download_handler(
            data_list = plot_source_reactive,
            filename_base = "scatterPlot_source"
        )

        return(plot_source_reactive)
    })
}
