#' Server logic for scatterPlot module
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the scatterPlot module.
#'
#' @importFrom shiny moduleServer isolate hideTab reactive req
#' @importFrom dittoViz scatterPlot dittoColors
#' @importFrom ggplot2 theme_bw waiver
#' @importFrom plotly renderPlotly %>% config layout toWebGL
#' @importFrom shinyjs hide
#'
#' @export
#' @author Jared Andrews
scatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = session$ns("scatterPlotTabsetPanel"), target = tab.name)
            })
        }

        # Get color panel
        color.panel <- reactive({
            if (is.null(input$color.panel) || input$color.panel == "dittoColors") {
                palette <- dittoColors()
            } else if (!is.null(input$color.by)) {
                if (input$color.panel %in% c("viridis", "magma", "inferno", "plasma", "cividis")) {
                    palette <- viridis_pal(option = input$color.panel)(length(colLevels(input$color.by, data())))
                } else if (input$color.panel == "ggplot2") {
                    palette <- hue_pal()(length(colLevels(input$color.by, data())))
                } else {
                    palette <- brewer_pal(palette = input$color.panel)(length(colLevels(input$color.by, data())))
                }
            }

            palette
        })

        # dataframe of selected data, which is added to with multiple selections
        selected.data <- reactiveVal()

        # Observer to add selected data to selected.data
        observeEvent(
            event_data("plotly_selected"),
            # suspended = TRUE,
            {
                selected <- event_data("plotly_selected")
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

        output$scatterPlot <- renderPlotly({
            req(input$x.by, input$y.by, data())
            input$update

            # Change textInputs and selectInputs to NULL if empty
            null.na.inputs <- list(
                "trajectory.group.by" = isolate(input$trajectory.group.by),
                "add.trajectory.by.groups" = isolate(input$add.trajectory.by.groups),
                "add.xline" = isolate(input$add.xline),
                "add.yline" = isolate(input$add.yline),
                "color.by" = isolate(input$color.by),
                "shape.by" = isolate(input$shape.by),
                "split.by" = isolate(input$split.by),
                "x.adjustment" = isolate(input$x.adjustment),
                "y.adjustment" = isolate(input$y.adjustment),
                "color.adjustment" = isolate(input$color.adjustment),
                "x.adj.fxn" = isolate(input$x.adj.fxn),
                "y.adj.fxn" = isolate(input$y.adj.fxn),
                "color.adj.fxn" = isolate(input$color.adj.fxn),
                "split.nrow" = isolate(input$split.nrow),
                "split.ncol" = isolate(input$split.ncol),
                "hover.data" = isolate(input$hover.data),
                "annotate.by" = isolate(input$annotate.by)
            )

            for (input.name in names(null.na.inputs)) {
                if (!is.null(null.na.inputs[[input.name]])) {
                    if (identical(null.na.inputs[[input.name]], NA)) {
                        null.na.inputs[[input.name]] <- NULL
                    } else if (identical(null.na.inputs[[input.name]], "")) {
                        null.na.inputs[[input.name]] <- NULL
                    }
                }
            }

            # Waiver inputs
            waiver.inputs <- list(
                "legend.color.breaks" = isolate(input$legend.color.breaks)
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
                    null.na.inputs$color.by,
                    paste0(null.na.inputs$color.by, ".color.adj"),
                    "color.multi", "color.which",
                    isolate(input$x.by),
                    paste0(isolate(input$x.by), ".x.adj"),
                    isolate(input$y.by),
                    paste0(isolate(input$y.by), ".y.adj"),
                    null.na.inputs$shape.by,
                    null.na.inputs$split.by
                ))
            } else {
                hover.data <- null.na.inputs$hover.data
            }

            p <- scatterPlot(
                data(),
                x.by = isolate(input$x.by),
                y.by = isolate(input$y.by),
                color.by = null.na.inputs$color.by,
                shape.by = null.na.inputs$shape.by,
                split.by = null.na.inputs$split.by,
                size = isolate(input$size),
                rows.use = with(data(), eval(str2expression(isolate(input$rows.use)))),
                show.others = isolate(input$show.others),
                x.adjustment = null.na.inputs$x.adjustment,
                y.adjustment = null.na.inputs$y.adjustment,
                color.adjustment = null.na.inputs$color.adjustment,
                x.adj.fxn = eval(str2expression(isolate(input$x.adj.fxn))),
                y.adj.fxn = eval(str2expression(isolate(input$y.adj.fxn))),
                color.adj.fxn = eval(str2expression(isolate(input$color.adj.fxn))),
                split.show.all.others = isolate(input$split.show.all.others),
                opacity = isolate(input$opacity),
                color.panel = isolate(color.panel()),
                colors = seq_along(isolate(color.panel())),
                split.nrow = null.na.inputs$split.nrow,
                split.ncol = null.na.inputs$split.ncol,
                split.adjust = list(),
                multivar.split.dir = isolate(input$multivar.split.dir),
                shape.panel = as.numeric(.string_to_vector(isolate(input$shape.panel))),
                rename.color.groups = NULL,
                rename.shape.groups = NULL,
                min.color = isolate(input$min.color),
                max.color = isolate(input$max.color),
                min.value = isolate(input$min.value),
                max.value = isolate(input$max.value),
                plot.order = isolate(input$plot.order),
                theme = theme_bw(),
                do.hover = TRUE,
                hover.data = hover.data,
                hover.round.digits = isolate(input$hover.round.digits),
                do.contour = isolate(input$do.contour),
                contour.color = isolate(input$contour.color),
                contour.linetype = isolate(input$contour.linetype),
                add.trajectory.by.groups = .string_to_list_of_vectors(null.na.inputs$add.trajectory.by.groups),
                trajectory.group.by = null.na.inputs$trajectory.group.by,
                trajectory.arrow.size = isolate(input$trajectory.arrow.size),
                add.xline = as.numeric(.string_to_vector(null.na.inputs$add.xline)),
                xline.linetype = isolate(input$xline.linetype),
                xline.color = isolate(input$xline.color),
                add.yline = as.numeric(.string_to_vector(null.na.inputs$add.yline)),
                yline.linetype = isolate(input$yline.linetype),
                yline.color = isolate(input$yline.color),
                do.ellipse = isolate(input$do.ellipse),
                legend.show = isolate(input$legend.show),
                legend.color.title = isolate(input$legend.color.title),
                legend.color.size = isolate(input$legend.color.size),
                legend.color.breaks = waiver.inputs$legend.color.breaks,
                legend.color.breaks.labels = waiver(),
                legend.shape.title = null.na.inputs$shape.by,
                legend.shape.size = isolate(input$legend.shape.size),
                show.grid.lines = isolate(input$show.grid.lines),
                data.out = TRUE
            )

            plot.data <- p$Target_data

            # COLOUR MAPPING FOR LINE
            if (!is.null(input$color.by) && input$color.by != "") {
                color_levels <- colLevels(input$color.by, data())
                color_mapping <- setNames(color.panel()[seq_along(color_levels)], color_levels)
            } else {
                color_mapping <- NULL
            }


            fig <- p$plot %>% config(
                edits = list(
                    axisTitleText = TRUE,
                    titleText = TRUE,
                    legendText = TRUE,
                    legendPosition = TRUE,
                    colorbarPosition = TRUE,
                    colorbarTitleText = TRUE,
                    annotationTail = TRUE
                ),
                toImageButtonOptions = list(
                    format = isolate(input$download.format)
                ),
                modeBarButtonsToAdd = list(
                    "drawline",
                    "drawopenpath",
                    "drawclosedpath",
                    "drawcircle",
                    "drawrect",
                    "eraseshape"
                ),
                displaylogo = FALSE
            )

            if (!is.null(null.na.inputs$annotate.by) & !is.null(selected.data())) {
                anno.data <- plot.data[, c(isolate(input$x.by), isolate(input$y.by), null.na.inputs$annotate.by)]
                colnames(anno.data) <- c("x", "y", "text")

                # Filter to rows of anno.data where the x.by and y.by columns BOTH match selected.data()$x and selected.data()$y in the same row
                anno.data$xy <- paste0(anno.data$x, "_", anno.data$y)
                anno.data <- anno.data[anno.data$xy %in% paste0(selected.data()$x, "_", selected.data()$y), ]

                annos <- list(
                    x = anno.data$x,
                    y = anno.data$y,
                    text = anno.data$text,
                    xref = "x",
                    yref = "y",
                    ax = isolate(input$annotation.ax),
                    ay = isolate(input$annotation.ay),
                    showarrow = isolate(input$annotation.showarrow),
                    arrowcolor = isolate(input$annotation.arrowcolor),
                    arrowhead = isolate(input$annotation.arrowhead),
                    arrowwidth = isolate(input$annotation.arrowwidth),
                    font = list(
                        size = isolate(input$annotation.size),
                        color = isolate(input$annotation.color)
                    )
                )
            } else {
                annos <- NULL
            }

            fig <- fig %>% layout(
                newshape = list(
                    fillcolor = isolate(input$shape.fill),
                    line = list(
                        color = isolate(input$shape.line.color),
                        width = isolate(input$shape.line.width),
                        dash = isolate(input$shape.linetype)
                    ),
                    opacity = isolate(input$shape.opacity)
                ),
                annotations = annos
            )

            if (isolate(input$webgl)) {
                fig <- fig %>% toWebGL()
            }


            without.line <- fig
            linear_model <- reactive({
                req(input$x.by, input$y.by, input$linear.model)

                df <- data()
                if (identical(input$best.fit, FALSE)) {
                    x_col <- input$x.by
                    y_col <- input$y.by

                    model <- lm(df[[y_col]] ~ df[[x_col]], data = df)

                    x_min <- min(df[[x_col]], na.rm = TRUE)
                    x_max <- max(df[[x_col]], na.rm = TRUE)
                    x_grid <- seq(x_min, x_max, length.out = 100)


                    intercept <- coef(model)[1]
                    slope <- coef(model)[2]

                    # Calculate y directly from equation y = mx + b
                    y_grid <- intercept + slope * x_grid

                    predict_df <- data.frame(x = x_grid, y = y_grid)
                    predict_df
                } else {
                    NULL
                }
            })
            colour.by.model <- reactive({
                req(input$color.by, input$x.by, input$y.by, input$linear.model)

                df <- data()

                if (!input$color.by == "") {
                    x_col <- input$x.by
                    y_col <- input$y.by
                    color_col <- input$color.by

                    models <- list()
                    for (species in unique(df[[color_col]])) {
                        species_data <- df[df[[color_col]] == species, ]

                        model <- lm(species_data[[y_col]] ~ species_data[[x_col]])

                        x_min <- min(species_data[[x_col]], na.rm = TRUE)
                        x_max <- max(species_data[[x_col]], na.rm = TRUE)
                        x_grid <- seq(x_min, x_max, length.out = 100)

                        intercept <- coef(model)[1]
                        slope <- coef(model)[2]

                        y_grid <- intercept + slope * x_grid

                        models[[as.character(species)]] <- data.frame(x = x_grid, y = y_grid)
                    }
                    models
                } else {
                    NULL
                }
            })
            # Smooth best fit line reactive:

            best_fit_by_group <- reactive({
                req(input$color.by, input$x.by, input$y.by, input$best.fit)

                df <- data()
                if (identical(input$best.fit, TRUE) && !identical(input$color.by, "")) {
                    x_col <- input$x.by
                    y_col <- input$y.by
                    color_col <- input$color.by

                    models <- list()
                    for (species in unique(df[[color_col]])) {
                        species_data <- df[df[[color_col]] == species, ]

                        fit <- loess(
                            formula = species_data[[y_col]] ~ -log10(species_data[[x_col]]),
                            span    = input$line.best.smoothness
                        )

                        x_min <- min(species_data[[x_col]], na.rm = TRUE)
                        x_max <- max(species_data[[x_col]], na.rm = TRUE)
                        x_grid <- seq(x_min, x_max, length.out = 100)

                        newdata <- data.frame(x_grid)
                        names(newdata) <- x_col

                        y_grid <- predict(fit, newdata = newdata)

                        models[[as.character(species)]] <- data.frame(x = x_grid, y = y_grid)
                    }
                    models
                } else {
                    NULL
                }
            })


            if (identical(input$best.fit, TRUE) && identical(input$linear.model, FALSE)) {
                if (!identical(input$color.by, "")) {
                    # grouped best-fit lines
                    for (species in names(best_fit_by_group())) {
                        line_color <- color_mapping[[species]]
                        fig <- fig %>%
                            add_lines(
                                data = best_fit_by_group()[[species]],
                                x = ~x,
                                y = ~y,
                                line = list(color = line_color, width = 3),
                                name = paste("Best fit", species)
                            )
                    }
                } else {
                    # single global best-fit (your existing behaviour)
                    fig <- fig %>%
                        add_lines(
                            y = ~ fitted(loess(.data[[input$y.by]] ~ -log10(.data[[input$x.by]]),
                                span = input$line.best.smoothness
                            )),
                            line = list(color = input$line.best.colour, width = 3),
                            name = "LBF"
                        )
                }
            }


            if (identical(input$linear.model, TRUE) & !input$color.by == "") {
                for (species in names(colour.by.model())) {
                    line_color <- color_mapping[[species]]
                    fig <- fig %>%
                        add_lines(
                            data = colour.by.model()[[species]],
                            x = ~x, y = ~y,
                            line = list(color = line_color, width = 3),
                            name = paste("Linear", species)
                        )
                }
            } else if (identical(input$linear.model, TRUE) & identical(input$best.fit, FALSE)) {
                fig <- fig %>%
                    add_lines(
                        data = linear_model(),
                        x = ~x,
                        y = ~y,
                        line = list(color = input$line.best.colour, width = 3),
                        name = "Linear Fit"
                    )
                fig
            }


            fig
        })
    })
}
