#' Drag-and-drop control for the order of a categorical axis
#'
#' A [shinyjqui::orderInput()] laid out to fill one [organize_inputs()] grid
#' cell, listing the levels of a categorical column as buttons that can be
#' dragged into the order they should be plotted in. Its value is the levels in
#' their current order, a character vector.
#'
#' The control hides its grid cell whenever it has no items, which is how
#' [setup_level_order()] takes it off screen for a column it cannot order (a
#' numeric one, or one with more levels than are practical to drag). A cell hidden
#' with [hide_input()] stays hidden either way.
#'
#' @param inputId The input ID, namespaced as for any other input (e.g.
#'   `ns("x.order")`).
#' @param label The label shown above the control.
#' @param items Character vector of levels to show, in order, typically from
#'   [level_order_choices()]. `NULL` or empty renders an empty, hidden control.
#' @param tooltip Optional tooltip text shown on hover.
#' @param width The CSS width of the control.
#'
#' @return A `shiny.tag` wrapping the order input.
#'
#' @importFrom shinyjqui orderInput
#' @importFrom shinyBS tipify
#' @importFrom htmltools div
#'
#' @export
#' @author Jared Andrews
#' @seealso [level_order_choices()], [apply_level_order()], [setup_level_order()]
#' @examples
#' level_order_input("x.order", "X Order", items = c("Healthy", "Disease"))
#'
#' # The items for a column of a data frame, in the order they are drawn by default
#' level_order_input("x.order", "X Order",
#'     items = level_order_choices(example_iris, "Species")
#' )
level_order_input <- function(inputId, label = "X Order", items = NULL, tooltip = NULL, width = "100%") {
    items <- if (length(items)) as.character(items) else NULL
    # A placeholder is not passed: shinyjqui builds its CSS selector from the raw
    # id, which a module's dotted, namespaced id breaks.
    el <- div(
        class = "vizmodules-level-order",
        orderInput(inputId, label, items = items, width = width)
    )
    if (!is.null(tooltip) && nzchar(tooltip)) {
        el <- tipify(el, tooltip, placement = "top", options = list(container = "body"))
    }
    el
}


#' The levels a categorical column is plotted in, optionally reordered
#'
#' Gives the levels of `data[[column]]` that are present, in the order a plot
#' draws them by default -- factor level order for a factor, sorted values
#' otherwise -- with any levels named in `order` moved to the front in that order.
#'
#' @param data A data frame.
#' @param column The name of the column.
#' @param order Optional character vector of levels in the order wanted. Entries
#'   that are not present levels are ignored, and levels it leaves out follow in
#'   their default order, so an order kept from an earlier filtering of the data
#'   still applies to what is left.
#' @param max.levels The most levels worth offering for reordering. A column with
#'   more gives `NULL`.
#'
#' @return A character vector of levels, or `NULL` when `column` is missing,
#'   numeric, or has no levels or more than `max.levels` of them.
#'
#' @export
#' @author Jared Andrews
#' @seealso [level_order_input()], [apply_level_order()], [setup_level_order()]
#' @examples
#' level_order_choices(example_iris, "Species")
#' level_order_choices(example_iris, "Species", order = "virginica")
#'
#' # Numeric columns have no levels to order
#' level_order_choices(example_iris, "Sepal.Length")
level_order_choices <- function(data, column, order = NULL, max.levels = 20) {
    if (is.null(data) || !nz_value(column) || !column %in% names(data)) {
        return(NULL)
    }
    values <- data[[column]]
    if (is.numeric(values)) {
        return(NULL)
    }

    lv <- if (is.factor(values)) {
        levels(droplevels(values[!is.na(values)]))
    } else {
        levels(factor(values))
    }
    if (length(lv) == 0 || length(lv) > max.levels) {
        return(NULL)
    }

    order <- as.character(unlist(order))
    order <- unique(order[!is.na(order)])
    c(intersect(order, lv), setdiff(lv, order))
}


#' Reorder the levels of a categorical column
#'
#' Re-levels `data[[column]]` as a factor whose levels follow `order`, which is
#' how the plot modules set the order of a categorical axis: the plot functions,
#' the statistics and their brackets all take the axis order from the column's
#' levels, so they stay in step.
#'
#' @inheritParams level_order_choices
#' @param order Character vector of levels in the order wanted, e.g. the value of
#'   a [level_order_input()]. Merged as in [level_order_choices()], with no cap on
#'   the number of levels.
#'
#' @return `data`, with `column` re-levelled. It is returned unchanged when
#'   `order` is empty or already the default order, or `column` is missing or
#'   numeric.
#'
#' @export
#' @author Jared Andrews
#' @seealso [level_order_input()], [level_order_choices()], [setup_level_order()]
#' @examples
#' df <- apply_level_order(example_iris, "Species", c("virginica", "setosa"))
#' levels(df$Species)
apply_level_order <- function(data, column, order) {
    order <- as.character(unlist(order))
    if (length(order) == 0) {
        return(data)
    }
    lv <- level_order_choices(data, column, order, max.levels = Inf)
    if (is.null(lv) || identical(lv, level_order_choices(data, column, max.levels = Inf))) {
        return(data)
    }
    data[[column]] <- factor(as.character(data[[column]]), levels = lv)
    data
}


#' Keep a level-order control in step with its column
#'
#' The server half of [level_order_input()]. Refills the control with the levels
#' of the selected column whenever the data or the column changes, holds the
#' order the plot should use, and restores `defaults[[inputId]]` when the
#' module's Reset button (`input$reset`) is pressed.
#'
#' @details
#' A new column starts from `defaults[[inputId]]` (levels it does not have are
#' ignored), and new data for the same column keeps the order the user dragged
#' the levels into. A column the control cannot order -- numeric, or with more
#' than `max.levels` levels -- empties the control, which hides it.
#'
#' The returned store, not `input[[inputId]]`, is what the plot should read. It
#' changes only when the order to draw does, so neither the control reporting its
#' initial value nor its echo of an update costs an extra render. A
#' `defaults[[inputId]]` given as a [shiny::reactive()] is followed as the
#' parent's state changes, as with [setup_reactive_defaults()].
#'
#' @param input,session The module's `input` and `session`.
#' @param data A reactive holding the module's data frame.
#' @param column A reactive (or function) giving the name of the column ordered,
#'   e.g. `reactive(input$x.data)`.
#' @param defaults The module's named list of defaults, or `NULL`.
#' @param inputId The un-namespaced ID of the [level_order_input()].
#' @param max.levels The most levels the control offers; see
#'   [level_order_choices()].
#'
#' @return A [shiny::reactiveVal()] holding the levels in the order to draw, or
#'   `NULL` for the default order. Hand it to [apply_level_order()].
#'
#' @importFrom shiny reactiveVal observeEvent isolate is.reactive
#' @importFrom shinyjqui updateOrderInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [level_order_input()], [apply_level_order()]
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'
#'     ui <- fluidPage(
#'         selectInput("x", "X", c("Species", "Petal.Size")),
#'         level_order_input("x.order", "X Order"),
#'         plotOutput("plot")
#'     )
#'
#'     server <- function(input, output, session) {
#'         data <- reactive({
#'             df <- example_iris
#'             df$Petal.Size <- ifelse(df$Petal.Length > 4, "Large", "Small")
#'             df
#'         })
#'         x.order <- setup_level_order(input, session, data, reactive(input$x))
#'
#'         output$plot <- renderPlot({
#'             df <- apply_level_order(data(), input$x, x.order())
#'             boxplot(df$Sepal.Length ~ df[[input$x]], xlab = input$x)
#'         })
#'     }
#'
#'     shinyApp(ui, server)
#' }
setup_level_order <- function(input, session, data, column, defaults = NULL,
                              inputId = "x.order", max.levels = 20) {
    store <- reactiveVal(NULL)

    # The order last chosen, by the user or by the server.
    current.order <- NULL
    # Items sent to the control that it has not reported back yet. Until it does,
    # anything else it reports predates the update and is put right.
    sent <- NULL
    last.column <- NULL

    default_order <- function() get_default(defaults, inputId, NULL, is.character)

    send <- function(items) {
        sent <<- items
        updateOrderInput(session, inputId, items = items, item_class = "default")
    }

    resolve <- function(df, col, order) {
        current.order <<- order
        items <- level_order_choices(df, col, order, max.levels)
        store(if (is.null(items) || identical(items, level_order_choices(df, col, NULL, max.levels))) {
            NULL
        } else {
            items
        })

        items <- items %__% character(0)
        if (!identical(items, .level_order_value(isolate(input[[inputId]])))) {
            send(items)
        }
    }

    observeEvent(list(data(), column()), ignoreNULL = FALSE, {
        col <- column()
        same.column <- identical(col, last.column)
        last.column <<- col
        resolve(data(), col, if (same.column) current.order else default_order())
    })

    observeEvent(input[[inputId]], ignoreInit = TRUE, ignoreNULL = FALSE, {
        value <- .level_order_value(input[[inputId]])
        if (!is.null(sent)) {
            if (!setequal(value, sent)) {
                send(sent)
                return()
            }
            sent <<- NULL
        }
        resolve(isolate(data()), isolate(column()), value)
    })

    observeEvent(input$reset, ignoreInit = TRUE, {
        resolve(isolate(data()), isolate(column()), default_order())
    })

    source <- if (!is.null(defaults)) defaults[[inputId]]
    if (is.reactive(source)) {
        # Ahead of the outputs, so the plot sees the new order in the same flush.
        observeEvent(source(), ignoreInit = TRUE, ignoreNULL = FALSE, priority = 1000, {
            resolve(isolate(data()), isolate(column()), default_order())
        })
    }

    store
}


#' Normalise an orderInput value
#'
#' The control reports a JSON array, which reaches R as `NULL` when it is empty.
#'
#' @param x The input value.
#' @return A character vector, possibly empty.
#' @noRd
.level_order_value <- function(x) {
    x <- as.character(unlist(x))
    x[!is.na(x)]
}
