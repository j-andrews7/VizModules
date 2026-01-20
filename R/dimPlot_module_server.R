#' Server logic for DimPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the DimPlot module.
#'
#' @import shiny
#' @importFrom plotthis DimPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#' @importFrom plotly ggplotly layout config
#'
#' @export
#' @author Jared Andrews
DimPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "DimPlotTabsetPanel", target = tab.name)
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

            if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[group_col]])))
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
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])

            # Data
            updateSelectInput(session, "dim1", selected = num.choices[2])
            updateSelectInput(session, "dim2", selected = num.choices[3])
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "split.by", selected = "")

            # Points
            updateNumericInput(session, "pt.size", value = 1)
            updateNumericInput(session, "pt.alpha", value = 1)
            colourpicker::updateColourInput(session, "bg.color", value = "grey80")

            # Labels
            updateSwitchInput(session, "label", value = FALSE)
            updateSwitchInput(session, "label.insitu", value = FALSE)
            updateNumericInput(session, "label.size", value = 4)
            colourpicker::updateColourInput(session, "label.fg", value = "white")
            colourpicker::updateColourInput(session, "label.bg", value = "black")
            updateNumericInput(session, "label.bg.r", value = 0.1)
            updateSwitchInput(session, "label.repel", value = FALSE)
            updateNumericInput(session, "label.repulsion", value = 20)
            updateNumericInput(session, "label.pt.size", value = 1)
            colourpicker::updateColourInput(session, "label.pt.color", value = "black")
            colourpicker::updateColourInput(session, "label.segment.color", value = "black")

            # Marks & Highlights
            updateSwitchInput(session, "add.mark", value = FALSE)
            updateSelectInput(session, "mark.type", selected = "hull")
            updateNumericInput(session, "mark.alpha", value = 0.1)
            updateNumericInput(session, "mark.linetype", value = 1)
            updateTextInput(session, "highlight", value = "")
            updateNumericInput(session, "highlight.alpha", value = 1)
            updateNumericInput(session, "highlight.size", value = 1)
            colourpicker::updateColourInput(session, "highlight.color", value = "black")
            updateNumericInput(session, "highlight.stroke", value = 0.8)

            # Order & Stats
            updateSelectInput(session, "order", selected = "as-is")
            updateSwitchInput(session, "show.stat", value = FALSE)
            updateSelectInput(session, "stat.by", selected = "")
            updateSelectInput(session, "stat.plot.type", selected = "pie")
            updateNumericInput(session, "stat.plot.size", value = 0.1)

            # Density
            updateSwitchInput(session, "add.density", value = FALSE)
            colourpicker::updateColourInput(session, "density.color", value = "grey80")
            updateSwitchInput(session, "density.filled", value = FALSE)

            # Facet
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scales", selected = "fixed")
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateSwitchInput(session, "facet.byrow", value = TRUE)

            # Aesthetics
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "aspect.ratio", value = 1)
            updateSelectInput(session, "legend.position", selected = "right")
            updateSelectInput(session, "legend.direction", selected = "vertical")

            # Titles
            updateTextInput(session, "title", value = "")
            updateTextInput(session, "subtitle", value = "")
            updateTextInput(session, "xlab", value = "")
            updateTextInput(session, "ylab", value = "")

            # Axes
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
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

            # Download
            updateSelectInput(session, "download.type", selected = "png")
        })

        output$DimPlot <- renderPlotly({
            isolate_fn <- setup_auto_update_logic(input)

            # Handle NULL/empty values
            group.by <- .na_to_null(isolate_fn(input$group.by))
            split.by <- .na_to_null(isolate_fn(input$split.by))
            facet.by <- .na_to_null(isolate_fn(input$facet.by))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            stat.by <- .na_to_null(isolate_fn(input$stat.by))
            title <- .na_to_null(isolate_fn(input$title))
            subtitle <- .na_to_null(isolate_fn(input$subtitle))
            xlab <- .na_to_null(isolate_fn(input$xlab))
            ylab <- .na_to_null(isolate_fn(input$ylab))

            # Parse highlight groups
            highlight_val <- .na_to_null(isolate_fn(input$highlight))
            if (!is.null(highlight_val)) {
                highlight_val <- trimws(strsplit(highlight_val, ",")[[1]])
                if (length(highlight_val) == 0) highlight_val <- NULL
            }

            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours)
            )

            # Prepare dims parameter
            dims_cols <- c(isolate_fn(input$dim1), isolate_fn(input$dim2))

            # Create the DimPlot
            p <- plotthis::DimPlot(
                data(),
                dims = dims_cols,
                group_by = group.by,
                split_by = split.by,
                pt_size = isolate_fn(input$pt.size),
                pt_alpha = isolate_fn(input$pt.alpha),
                bg_color = isolate_fn(input$bg.color),
                label_insitu = isolate_fn(input$label.insitu),
                show_stat = isolate_fn(input$show.stat),
                label = isolate_fn(input$label),
                label_size = isolate_fn(input$label.size),
                label_fg = isolate_fn(input$label.fg),
                label_bg = isolate_fn(input$label.bg),
                label_bg_r = isolate_fn(input$label.bg.r),
                label_repel = isolate_fn(input$label.repel),
                label_repulsion = isolate_fn(input$label.repulsion),
                label_pt_size = isolate_fn(input$label.pt.size),
                label_pt_color = isolate_fn(input$label.pt.color),
                label_segment_color = isolate_fn(input$label.segment.color),
                order = isolate_fn(input$order),
                highlight = highlight_val,
                highlight_alpha = isolate_fn(input$highlight.alpha),
                highlight_size = isolate_fn(input$highlight.size),
                highlight_color = isolate_fn(input$highlight.color),
                highlight_stroke = isolate_fn(input$highlight.stroke),
                add_mark = isolate_fn(input$add.mark),
                mark_type = isolate_fn(input$mark.type),
                mark_alpha = isolate_fn(input$mark.alpha),
                mark_linetype = isolate_fn(input$mark.linetype),
                stat_by = stat.by,
                stat_plot_type = isolate_fn(input$stat.plot.type),
                stat_plot_size = isolate_fn(input$stat.plot.size),
                add_density = isolate_fn(input$add.density),
                density_color = isolate_fn(input$density.color),
                density_filled = isolate_fn(input$density.filled),
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scales),
                facet_nrow = facet.nrow,
                facet_ncol = facet.ncol,
                facet_byrow = isolate_fn(input$facet.byrow),
                title = title,
                subtitle = subtitle,
                xlab = xlab,
                ylab = ylab,
                theme = isolate_fn(input$theme),
                aspect.ratio = isolate_fn(input$aspect.ratio),
                legend.position = isolate_fn(input$legend.position),
                legend.direction = isolate_fn(input$legend.direction),
                palette = default_palette_name,
                palcolor = unname(palette_values)
            )

            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(
                            size = isolate_fn(input$title.font.size),
                            family = isolate_fn(input$font.type),
                            color = isolate_fn(input$text.colour)
                        ),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), 
                                           include.modebar.buttons = TRUE, 
                                           facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
