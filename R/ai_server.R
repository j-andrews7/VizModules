#' boxAI server module
#'
#' @param id Shiny module id.
#' @param data Reactive expression returning a data.frame.
#' @param hide.inputs Optional character vector of input ids to hide (using shinyjs).
#' @param hide.tabs Optional character vector of tab names to hide.
#' @param defaults Optional named list of defaults for reset behaviour.
#'
#' @return Server-side logic for the boxAI module.
#'
#' @importFrom shiny moduleServer reactive req observeEvent
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#' @importFrom shiny updateTextInput updateNumericInput
#' @importFrom plotthis BoxPlot
#'
#' @export
boxAIServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide inputs/tabs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) hide(input.name))
        }
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "boxAITabsetPanel", target = tab.name)
            })
        }

        # Reset functionality
        observeEvent(input$reset, {
            if (!is.null(defaults)) {
                lapply(names(defaults), function(name) {
                    updateTextInput(session, name, value = defaults[[name]])
                })
            }
            # Reset numeric inputs to defaults derived from data
            updateNumericInput(session, "x.text.angle", value = 90)
            updateNumericInput(
                session, "y.max",
                value = max(data()[, sapply(data(), is.numeric)], na.rm = TRUE)
            )
            updateNumericInput(
                session, "y.min",
                value = min(data()[, sapply(data(), is.numeric)], na.rm = TRUE)
            )
            updateNumericInput(session, "aspect.ratio", value = 1)
            # Reset switches
            updateSwitchInput(session, "flip",        value = FALSE)
            updateSwitchInput(session, "stack",       value = FALSE)
            updateSwitchInput(session, "add.points",  value = FALSE)
            updateSwitchInput(session, "add.trend",   value = FALSE)
            updateSwitchInput(session, "comparisons", value = FALSE)
            updateSwitchInput(session, "hide_ns",     value = TRUE)
        })

        output$boxAIPlot <- renderPlotly({
            req(input$x.data, input$y.data, data())

            p <- plotthis::BoxPlot(
                data = data(),
                x    = input$x.data,
                y    = input$y.data,
                group_by = if (input$group_by == "") NULL else input$group_by,
                facet_by = if (input$facet_by == "") NULL else input$facet_by,
                sort_x   = input$sort_x,
                flip       = input$flip,
                x_text_angle = input$x.text.angle,
                stack      = input$stack,
                y_max      = input$y.max,
                y_min      = input$y.min,
                aspect.ratio = input$aspect.ratio,
                add_point  = input$add.points,
                pt_color   = input$pt.color,
                pt_size    = input$pt.size,
                pt_alpha   = input$pt.alpha,
                jitter_width  = input$jitter.width,
                jitter_height = input$jitter.height,
                alpha      = input$alpha,
                add_trend  = input$add.trend,
                trend_color   = input$trend.color,
                trend_ptsize  = input$trend.ptsize,
                add_stat   = if (input$add_stat == "none") NULL else input$add_stat,
                comparisons    = if (input$comparisons) TRUE else NULL,
                pairwise_method = input$pairwise_method,
                hide_ns    = input$hide_ns,
                sig_labelsize = input$sig_labelsize,
                legend.position = input$legend.position,
                title    = input$title,
                subtitle = input$subtitle,
                xlab     = input$x.lab,
                ylab     = input$y.lab
            )

            ggplotly(p, height = 600, width = "100%")
        })
    })
}
