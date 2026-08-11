#' Resolve reactive `defaults` entries into a server-side parameter store
#'
#' Plot module parameters normally travel through client-side inputs: the value
#' is seeded into a control by `*InputsUI()` and read back at render time as
#' `input$<key>`. That makes it impossible for a parent app to drive a parameter
#' from app state without a visible double render. `update*Input()` is an
#' asynchronous client round-trip, so the plot renders once with the stale value
#' and again when the new value arrives from the browser.
#'
#' `setup_reactive_defaults()` fixes that by giving the module a *server-side*
#' channel. Any `defaults` entry that is a [shiny::reactive()] or
#' [shiny::reactiveVal()] is mirrored into an internal store that updates in the
#' same reactive flush as the parent's data, so the plot renders once. The store
#' is the render's source of truth (see [setup_auto_update_logic()]); the
#' on-screen control is kept in sync separately and remains user-editable.
#'
#' @details
#' Semantics:
#' \itemize{
#'   \item **Precedence.** An external change always wins, overwriting a value
#'     the user had typed into the control.
#'   \item **User edits.** Editing the control writes back to the store, so
#'     manual overrides work exactly as they do for static defaults.
#'   \item **Reset.** The module's Reset button restores the reactive's
#'     *current* value, not the value it held at startup, because
#'     [get_default()] resolves the reactive when the reset observer runs.
#'   \item **Recognised forms.** Only `reactive()` and `reactiveVal` are treated
#'     as reactive defaults (via [shiny::is.reactive()]). A plain function is
#'     kept as a literal default value.
#' }
#'
#' Control sync is cosmetic and uses a generic `sendInputMessage()`, which covers
#' the standard text, numeric, checkbox, select, colour and switch inputs. A
#' composite widget that ignores that message will simply not re-display the new
#' value; the plot is still correct, because the render reads the store.
#'
#' @param defaults A named list of default values, or `NULL`. Individual entries
#'   may be a `reactive()`/`reactiveVal`.
#' @param input The Shiny `input` object from inside `moduleServer()`.
#' @param session The Shiny `session` object from inside `moduleServer()`.
#'
#' @return `NULL` when `defaults` holds no reactive entries, in which case
#'   modules behave exactly as they did before. Otherwise a list with two
#'   functions, `has(key)` and `get(key)`, for [setup_auto_update_logic()] to
#'   read.
#'
#' @seealso [setup_auto_update_logic()], [get_default()]
#'
#' @importFrom shiny reactiveValues observeEvent isolate is.reactive
#'
#' @author Jared Andrews
#' @export
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'
#'     ui <- fluidPage(
#'         viz_select_input("sample", "Sample", c("S1", "S2", "S3")),
#'         dittoViz_scatterPlotInputsUI("p", mtcars),
#'         dittoViz_scatterPlotOutputUI("p")
#'     )
#'
#'     server <- function(input, output, session) {
#'         # The plot title follows the selected sample, but stays editable.
#'         dittoViz_scatterPlotServer(
#'             "p",
#'             data = reactive(mtcars),
#'             defaults = list(main = reactive(input$sample))
#'         )
#'     }
#'
#'     shinyApp(ui, server)
#' }
setup_reactive_defaults <- function(defaults, input, session) {
    keys <- .reactive_default_keys(defaults)
    if (length(keys) == 0) {
        return(NULL)
    }

    store <- reactiveValues()
    for (key in keys) {
        store[[key]] <- isolate(defaults[[key]]())
    }

    lapply(keys, function(key) {
        source_reactive <- defaults[[key]]

        # Priority puts the store ahead of outputs, so the render sees the new value in this flush.
        observeEvent(source_reactive(),
            {
                value <- source_reactive()
                if (!identical(store[[key]], value)) {
                    store[[key]] <- value
                }
                session$sendInputMessage(key, list(value = value))
            },
            priority = 1000, ignoreNULL = FALSE
        )

        observeEvent(input[[key]],
            {
                value <- input[[key]]
                if (!identical(store[[key]], value)) {
                    store[[key]] <- value
                }
            },
            ignoreInit = TRUE, ignoreNULL = FALSE
        )
    })

    list(
        has = function(key) key %in% keys,
        get = function(key) store[[key]]
    )
}


#' Names of `defaults` entries that are reactive
#'
#' @param defaults A named list of default values, or `NULL`.
#'
#' @return A character vector of names, possibly empty.
#'
#' @importFrom shiny is.reactive
#'
#' @author Jared Andrews
#' @noRd
.reactive_default_keys <- function(defaults) {
    if (!is.list(defaults) || length(defaults) == 0 || is.null(names(defaults))) {
        return(character(0))
    }
    is_reactive <- vapply(defaults, is.reactive, logical(1))
    names(defaults)[is_reactive & nzchar(names(defaults))]
}


#' Extract the input name from an `input$key` expression
#'
#' Used by [setup_auto_update_logic()] to recognise which parameter a call such
#' as `isolate_fn(input$main)` is reading, so the value can be sourced from the
#' reactive-defaults store instead. Anything that is not a direct `input$key` or
#' `input[["key"]]` access yields `NULL` and is read normally.
#'
#' @param expr A language object, typically from `substitute()`.
#'
#' @return A single character string, or `NULL`.
#'
#' @author Jared Andrews
#' @noRd
.input_key <- function(expr) {
    if (!is.call(expr) || length(expr) != 3L || !identical(expr[[2L]], quote(input))) {
        return(NULL)
    }

    if (identical(expr[[1L]], quote(`$`))) {
        return(as.character(expr[[3L]]))
    }

    if (identical(expr[[1L]], quote(`[[`)) && is.character(expr[[3L]]) && length(expr[[3L]]) == 1L) {
        return(expr[[3L]])
    }

    NULL
}
