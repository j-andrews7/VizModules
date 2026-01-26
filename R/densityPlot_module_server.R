#' Density Plot Server Module
#'
#' @description 
#' Server-side logic for the density plot module. This function manages 
#' reactive data processing, dynamic UI generation for color palettes, 
#' and the rendering of interactive Plotly density plots.
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{reactive} A reactive expression returning a data frame to be plotted.
#' @param hide.inputs \code{character} vector of input IDs to hide in the UI. Default is NULL.
#' @param hide.tabs \code{character} vector of tab names to hide within the module. Default is NULL.
#' 
#' @return A \code{reactive} Plotly object.
#' 
#' @author Jacob Martin
#' 
#' @export
#' @import shiny
#' @import plotly
#' @importFrom stats na.omit setNames
densityPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "densityPlotTabsetPanel", target = tab.name)
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

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data", selected = names(data())[1])
            updateSelectInput(session, "group.by", selected = "")
            updateTextInput(session, "group.by.name", value = "")
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "")
            updateSwitchInput(session, "flip", value = FALSE)
            updateSwitchInput(session, "add.bars", value = FALSE)
            updateNumericInput(session, "bar.height", value = 0.04)
            updateSliderInput(session, "bar.alpha", value = 1)
            updateNumericInput(session, "bar.width", value = 1)
            updateSliderInput(session, "plot.alpha", value = 0.5)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateSelectInput(session, "position", selected = "identity")


            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")

            # Axes:
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            updateCheckboxInput(session, "show.major.grid.x", value = TRUE)
            updateCheckboxInput(session, "show.major.grid.y", value = TRUE)
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
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
        })


        output$densityPlot <- renderPlotly({
            # Check if auto update on
            auto_update <- input$auto.update

            # If update button is required, add dependency on it
            if (!auto_update) {
                input$update
            }

            # Set up wrapper function based on switch state
            isolate_fn <- if (auto_update) identity else isolate

            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            group.by <- NULL
            if (!isolate_fn(input$group.by) == "") {
                group.by <- isolate_fn(input$group.by)
            }

            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours)
            )
            
            palcolor_arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                palcolor_arg <- as.list(palette_values)
            }

            # Facet rows and columns na to null
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            p <- plotthis::DensityPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                group_by = group.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                alpha = isolate_fn(input$plot.alpha),
                flip = isolate_fn(input$flip),
                add_bars = isolate_fn(input$add.bars),
                bar_height = isolate_fn(input$bar.height),
                bar_alpha = isolate_fn(input$bar.alpha),
                bar_width = isolate_fn(input$bar.width),
                theme = isolate_fn(input$theme),
                palette = default_palette_name,
                palcolor = palcolor_arg,
                position = isolate_fn(input$position)
            )

            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            # Axis Styling:

            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
