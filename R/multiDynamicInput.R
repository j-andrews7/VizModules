#' Dynamic multi-row input for repeating groups of inputs
#'
#' A custom Shiny input that lets users dynamically add and remove **rows**,
#' where each row is a group of heterogeneous inputs (e.g. a select, a text box,
#' a colour picker, and a numeric input on one line). A `+ Add` button appends a
#' row; an `X` button on each row deletes it. Rows are added and removed entirely
#' on the client by cloning a hidden template and letting Shiny bind the new
#' inputs, mirroring the architecture of [multiColorPicker()].
#'
#' The value reported to `input[[inputId]]` is a **named list of rows**
#' (`model1`, `model2`, ...), each a named list keyed by the `row_spec` names.
#'
#' The component is generic over input type. Each field in `row_spec` is
#' described by an input constructor and its arguments, so any Shiny input that
#' takes `inputId` as its first argument can be used. Common types have a short
#' `type = "..."` alias.
#'
#' @param inputId Character. Shiny input id.
#' @param label Optional label displayed next to the add button.
#' @param row_spec A named list describing one row. Each element is itself a
#'   list specifying a single field, with either:
#'   \itemize{
#'     \item `type` — a string alias: one of `"select"`, `"text"`,
#'       `"numeric"`, `"slider"`, `"checkbox"`, `"colour"`/`"color"`; or
#'     \item `fn` — an input constructor function (e.g. `shiny::dateInput`).
#'   }
#'   plus an optional `args` list of arguments passed to the constructor
#'   (everything except `inputId`, which is generated per row). The element name
#'   becomes the key under which that field's value is returned.
#' @param elements Optional initial rows to display on startup. A named list of
#'   rows (each a named list keyed by the `row_spec` names) in the same shape
#'   as the return value. For example:
#'   `list(models1 = list(model_type = "lm", formula = "y ~ x", line_colour = "#FF0000", line_width = 2))`.
#' @param max_per_row Integer. Maximum number of fields on one visual line
#'   before wrapping. Default `4`.
#' @param add_label Character. Label for the add button. Default `"+ Add"`.
#' @param width Optional CSS width for the container.
#' @param panel Logical. If `FALSE`, removes the surrounding panel/well styling.
#'
#' @return A UI element that produces a named list of rows.
#'
#' @import shiny
#' @importFrom htmltools attachDependencies htmlDependency
#'
#' @export
#' @author Jacob Martin
#'
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'
#'     ui <- fluidPage(
#'         multiDynamicInput(
#'             "models",
#'             label = "Models",
#'             row_spec = list(
#'                 model_type  = list(type = "select",
#'                     args = list(choices = c("lm", "glm", "loess", "nls"))),
#'                 formula     = list(type = "text",
#'                     args = list(placeholder = "y ~ poly(x, 2)")),
#'                 line_colour = list(type = "colour", args = list(value = "#000000"))
#'             )
#'         ),
#'         verbatimTextOutput("chosen")
#'     )
#'
#'     server <- function(input, output, session) {
#'         output$chosen <- renderPrint(input$models)
#'     }
#'
#'     shinyApp(ui, server)
#' }
multiDynamicInput <- function(inputId,
                             label = NULL,
                             row_spec,
                             elements = NULL,
                             max_per_row = 4,
                             add_label = "+ Add",
                             width = NULL,
                             panel = TRUE) {
    .register_multi_dynamic_input_handler()

    if (missing(inputId) || is.null(inputId) || !nzchar(inputId)) {
        stop("`inputId` must be a non-empty string.")
    }
    if (missing(row_spec) || !is.list(row_spec) || length(row_spec) == 0 ||
        is.null(names(row_spec)) || any(!nzchar(names(row_spec)))) {
        stop("`row_spec` must be a non-empty *named* list of field specs.")
    }

    max_per_row <- as.integer(max_per_row)
    if (is.na(max_per_row) || max_per_row < 1) max_per_row <- 4L
    field_keys <- names(row_spec)

    # Build one blank field, leaving a placeholder in place of the row index so
    # the client can stamp out uniquely-id'd copies per row.
    basis <- as.integer(100 / max_per_row)
    build_field <- function(key, field_id) {
        spec <- row_spec[[key]]
        fn <- .mdi_resolve_fn(spec)
        args <- if (!is.null(spec$args)) spec$args else list()
        if (is.null(args$label)) args$label <- .mdi_prettify(key)
        control <- do.call(fn, c(list(inputId = field_id), args))
        # Backend-specific fields are hidden by default; JS reveals them
        # when the matching model_type is selected.
        backend_attr <- spec$backend
        field_style <- sprintf("flex: 1 1 calc(%d%% - 8px); min-width: 120px;", basis)
        if (!is.null(backend_attr)) {
            field_style <- paste0(field_style, " display: none;")
        }
        tags$div(
            class = "mdi-field",
            `data-key` = key,
            `data-backend` = backend_attr,
            style = field_style,
            control
        )
    }

    # Hidden template row: a real row is a clone of this with __ROWIDX__ replaced.
    template_fields <- lapply(field_keys, function(key) {
        build_field(key, paste0(inputId, "-__ROWIDX__-", key))
    })
    template <- tags$template(
        class = "mdi-row-template",
        tags$div(
            class = "mdi-row",
            tags$div(class = "mdi-fields", template_fields),
            tags$button(
                type = "button",
                class = "mdi-delete",
                title = "Delete this row",
                `aria-label` = "Delete this row",
                HTML("&times;")
            )
        )
    )

    width_style <- if (!is.null(width)) {
        paste0("max-width:", validateCssUnit(width), ";")
    }

    value_json <- if (!is.null(elements)) {
        jsonlite::toJSON(unname(.mdi_value_to_payload(elements, field_keys)), auto_unbox = TRUE)
    } else {
        "[]"
    }

    # Row-name prefix derived from label: lowercase, no trailing spaces.
    row_prefix <- if (!is.null(label) && nzchar(trimws(label))) {
        tolower(trimws(label))
    } else {
        "row"
    }

    widget <- tags$div(
        class = paste(
            "multi-dynamic-input shiny-input-container form-group",
            if (!isTRUE(panel)) "is-plain" else NULL
        ),
        id = inputId,
        style = width_style,
        `data-keys` = jsonlite::toJSON(field_keys, auto_unbox = TRUE),
        `data-initial` = value_json,
        `data-input-id` = inputId,
        `data-row-prefix` = row_prefix,
        tags$div(
            class = "mdi-top",
            if (!is.null(label)) {
                tags$label(class = "control-label", `for` = inputId, label)
            },
            tags$button(
                type = "button",
                class = "mdi-add btn btn-default btn-sm",
                add_label
            )
        ),
        tags$div(class = "mdi-rows"),
        template
    )

    htmltools::attachDependencies(widget, .multi_dynamic_input_dependency())
}


#' Update a multiDynamicInput input on the client
#'
#' Replace all rows of an existing [multiDynamicInput()] from the server, or
#' clear it entirely.
#'
#' @param session The Shiny session object, typically `session`.
#' @param inputId Character. The input id of the multiDynamicInput to update.
#' @param elements Optional named list of rows (same shape as the return value) to
#'   set. Ignored when `clear = TRUE`.
#' @param clear Logical. If `TRUE`, remove all rows. Overrides `elements`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect.
#'
#' @import shiny
#' @export
#' @author Jacob Martin
updateMultiDynamicInput <- function(session, inputId, elements = NULL, clear = FALSE) {
    if (missing(session) || is.null(session)) {
        stop("`session` must be a valid Shiny session object.")
    }
    if (missing(inputId) || is.null(inputId) || !nzchar(inputId)) {
        stop("`inputId` must be a non-empty string.")
    }

    if (isTRUE(clear)) {
        msg <- list(clear = TRUE)
    } else if (!is.null(elements)) {
        msg <- list(value = .mdi_value_to_payload(elements, NULL))
    } else {
        stop("Provide `elements` to set rows, or `clear = TRUE` to empty.")
    }

    session$sendInputMessage(inputId, msg)
    invisible(NULL)
}


#' Convert a rows value into the client JSON payload
#'
#' @param value A named list of rows (each a named list of field values).
#' @param field_keys Optional character vector of field keys to enforce order;
#'   `NULL` uses each row's own names.
#' @return A list of `{ fields: [{ key, value }, ...] }` row objects.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_mdi_value_to_payload
#' @keywords internal
.mdi_value_to_payload <- function(value, field_keys) {
    if (is.null(value) || length(value) == 0) {
        return(list())
    }
    lapply(value, function(row) {
        keys <- if (!is.null(field_keys)) field_keys else names(row)
        fields <- lapply(keys, function(key) {
            list(key = key, value = row[[key]])
        })
        list(fields = fields)
    })
}


#' HTML dependency for the multi-dynamic input widget
#'
#' @return An `htmltools::htmlDependency` object.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_multi_dynamic_input_dependency
#' @keywords internal
.multi_dynamic_input_dependency <- function() {
    list(
        htmltools::htmlDependency(
            name = "multi-dynamic-input",
            version = as.character(utils::packageVersion("VizModules")),
            src = "src",
            package = "VizModules",
            script = "multiDynamicInput.js",
            stylesheet = "multiDynamicInput.css"
        ),
        # Ensure colourpicker's binding + library are always loaded so
        # dynamically cloned colour inputs can be initialized.
        htmltools::htmlDependency(
            name = "colourpicker-binding",
            version = as.character(utils::packageVersion("colourpicker")),
            src = "srcjs",
            package = "colourpicker",
            script = "input_binding_colour.js"
        ),
        htmltools::htmlDependency(
            name = "colourpicker-lib",
            version = "1.6",
            src = "www/shared/colourpicker",
            package = "colourpicker",
            script = c("js/colourpicker.min.js"),
            stylesheet = c("css/colourpicker.min.css")
        )
    )
}


#' Register input handler for the multi-dynamic input
#'
#' Turns the JavaScript payload (an array of rows, each with a `fields` array of
#' `{key, value}`) into the named-list-of-named-lists R structure.
#'
#' @return Invisibly returns the result of `registerInputHandler()`.
#'
#' @importFrom stats setNames
#' @importFrom shiny registerInputHandler
#'
#' @author Jacob Martin
#' @rdname INTERNAL_register_multi_dynamic_input_handler
#' @keywords internal
.register_multi_dynamic_input_handler <- function() {
    registerInputHandler(
        "VizModules.multiDynamicInput",
        function(data, ...) {
            if (is.null(data) || length(data) == 0) {
                return(stats::setNames(list(), character(0)))
            }
            prefix <- data[["_prefix"]] %||% "row"
            rows <- data[["rows"]] %||% list()
            if (length(rows) == 0) {
                return(stats::setNames(list(), character(0)))
            }
            out <- lapply(rows, function(row) {
                fields <- row$fields
                if (is.null(fields) || length(fields) == 0) {
                    return(stats::setNames(list(), character(0)))
                }
                vals <- lapply(fields, function(f) f$value)
                names(vals) <- vapply(fields, function(f) f$key %||% "", character(1))
                vals
            })
            names(out) <- paste0(prefix, seq_along(out))
            out
        },
        force = TRUE
    )
}


#' Resolve a field spec to an input constructor function
#'
#' @param spec A single field spec from `row_spec`.
#' @return An input constructor function.
#'
#' @importFrom colourpicker colourInput
#'
#' @author Jacob Martin
#' @rdname INTERNAL_mdi_resolve_fn
#' @keywords internal
.mdi_resolve_fn <- function(spec) {
    if (!is.null(spec$fn)) {
        if (!is.function(spec$fn)) stop("Field `fn` must be a function.")
        return(spec$fn)
    }
    if (is.null(spec$type)) {
        stop("Each field spec must have a `type` or an `fn`.")
    }
    switch(tolower(spec$type),
        select   = shiny::selectInput,
        text     = shiny::textInput,
        numeric  = shiny::numericInput,
        slider   = shiny::sliderInput,
        checkbox = shiny::checkboxInput,
        colour   = colourpicker::colourInput,
        color    = colourpicker::colourInput,
        stop("Unknown field type: ", spec$type)
    )
}


#' Prettify a field key into a label
#'
#' @param key A field key string.
#' @return A human-friendly label.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_mdi_prettify
#' @keywords internal
.mdi_prettify <- function(key) {
    out <- gsub("[._]", " ", key)
    paste0(toupper(substring(out, 1, 1)), substring(out, 2))
}



