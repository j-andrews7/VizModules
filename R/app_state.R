#' VizModules app-state schema version
#'
#' Returns the schema version string embedded in every document produced by
#' [serialize_app_state()]. Bump the *major* component when a change would stop
#' an older reader from loading a newer document; bump the *minor* component for
#' backwards-compatible additions.
#'
#' @return A length-one character string, e.g. `"1.0"`.
#'
#' @export
#' @author Jared Andrews
#' @seealso [serialize_app_state()], [deserialize_app_state()]
#' @examples
#' app_state_schema_version()
app_state_schema_version <- function() {
    "1.0"
}

# Input names that are transient UI plumbing rather than user-meaningful state.
# Anything matching one of these regexes is dropped from a saved snapshot so the
# document only stores values that can be replayed as module defaults.
.app_state_transient_patterns <- function() {
    c(
        "^\\.clientdata_", # Shiny client bookkeeping
        "_rows_all$", "_rows_current$", "_rows_selected$", # DT row state
        "_columns_selected$", "_cells_selected$", "_cell_clicked$", # DT selections
        "_state$", "_search$", "_search_columns$", # DT search/order state
        "plotly_", # plotly event streams (relayout/hover/click/...)
        "_relayout$", "_afterplot$" # plotly relayout callbacks
    )
}

#' Strip transient keys from a Shiny input snapshot
#'
#' Takes the result of `reactiveValuesToList(input)` and removes entries that
#' cannot (or should not) be persisted and replayed: DataTables row/search
#' state, plotly event streams, Shiny client-data, file-input payloads, and
#' action-button counters. The remaining named list contains only values that
#' can be handed back to a module's `*InputsUI(defaults = ...)` argument to
#' restore its configuration.
#'
#' @param inputs A named list of input values, typically produced by
#'   `shiny::reactiveValuesToList(input)`.
#'
#' @return A named list containing only the serialisable, replayable inputs.
#'   Returns an empty named list when `inputs` is `NULL` or empty.
#'
#' @export
#' @author Jared Andrews
#' @seealso [serialize_app_state()]
#' @examples
#' sanitize_input_snapshot(list(
#'     "x.data" = "mpg",
#'     "table_rows_all" = 1:10,
#'     ".clientdata_output_height" = 400
#' ))
sanitize_input_snapshot <- function(inputs) {
    if (is.null(inputs) || length(inputs) == 0L) {
        return(stats::setNames(list(), character(0)))
    }

    keys <- names(inputs)
    if (is.null(keys)) {
        return(stats::setNames(list(), character(0)))
    }

    patterns <- .app_state_transient_patterns()
    transient <- Reduce(
        function(acc, pat) acc | grepl(pat, keys),
        patterns,
        init = rep(FALSE, length(keys))
    )

    keep <- !transient
    for (i in which(keep)) {
        keep[i] <- .app_state_is_serialisable(inputs[[i]])
    }

    stats::setNames(inputs[keep], keys[keep])
}

# TRUE when a single input value can be stored in JSON and replayed as a
# default. File inputs (data frames / lists carrying a `datapath`) and action
# buttons (integer counters tagged `shinyActionButtonValue`) are rejected.
.app_state_is_serialisable <- function(value) {
    if (is.null(value)) {
        return(TRUE)
    }
    if (inherits(value, "shinyActionButtonValue")) {
        return(FALSE)
    }
    # File inputs arrive as a data frame (or list) with a `datapath` column.
    if (is.data.frame(value) && "datapath" %in% names(value)) {
        return(FALSE)
    }
    if (is.list(value) && !is.null(names(value)) && "datapath" %in% names(value)) {
        return(FALSE)
    }
    is.atomic(value) || is.list(value)
}

#' Serialise a VizModules app state to JSON
#'
#' Wraps a plain state `list` into the versioned VizModules app-state document
#' and encodes it as JSON with [jsonlite::toJSON()]. The `schema_version` field
#' (see [app_state_schema_version()]) is always stamped onto the output, and a
#' capture timestamp is added under `app$timestamp` when one is not already
#' present.
#'
#' The document is deliberately app-agnostic: any VizModules app can adopt the
#' same contract. The recognised top-level keys are:
#' \describe{
#'   \item{`app`}{Metadata list (e.g. `name`, `vizmodules_version`,
#'     `timestamp`).}
#'   \item{`app_inputs`}{Named list of app-level inputs (e.g. canvas
#'     orientation, panel-label case).}
#'   \item{`panels`}{An unnamed list of panel descriptors. Each panel is itself
#'     a list with (at least) `module` (registry key), `dataset` (dataset name),
#'     and `inputs` (a sanitised input snapshot); optional `label`, `filter`,
#'     and `geometry` entries round-trip when present.}
#' }
#'
#' @param state A named list describing the app state. Any of the keys above may
#'   be supplied; missing keys are simply omitted.
#' @param pretty Logical; pass-through to [jsonlite::toJSON()] controlling
#'   whitespace/indentation. Defaults to `TRUE`.
#'
#' @return A length-one character string containing the JSON document.
#'
#' @importFrom jsonlite toJSON
#' @export
#' @author Jared Andrews
#' @seealso [deserialize_app_state()], [sanitize_input_snapshot()]
#' @examples
#' state <- list(
#'     app = list(name = "figure-builder"),
#'     app_inputs = list(orientation = "portrait"),
#'     panels = list(
#'         list(module = "scatter", dataset = "example_iris",
#'              inputs = list("x.data" = "Sepal.Length"))
#'     )
#' )
#' cat(serialize_app_state(state))
serialize_app_state <- function(state, pretty = TRUE) {
    if (is.null(state)) {
        state <- list()
    }
    stopifnot(is.list(state))

    doc <- list(schema_version = app_state_schema_version())

    app <- if (is.null(state$app)) list() else state$app
    if (is.null(app$timestamp)) {
        app$timestamp <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
    }
    doc$app <- app

    if (!is.null(state$app_inputs)) {
        doc$app_inputs <- state$app_inputs
    }

    # `panels` must serialise as a JSON array even when empty or singular, so it
    # is left unnamed and encoded below with auto_unbox switched off per element.
    doc$panels <- if (is.null(state$panels)) list() else state$panels

    jsonlite::toJSON(
        doc,
        auto_unbox = TRUE,
        null = "null",
        na = "null",
        pretty = pretty
    )
}

#' Parse and validate a VizModules app-state document
#'
#' Decodes a JSON document produced by [serialize_app_state()] and validates its
#' structure: a `schema_version` string with a supported *major* version, and a
#' `panels` array. It is the inverse of [serialize_app_state()].
#'
#' @param json A length-one character string of JSON, or a connection/path
#'   accepted by [jsonlite::fromJSON()].
#'
#' @return A named list with elements `schema_version`, `app`, `app_inputs`
#'   (may be absent), and `panels` (always a list, possibly empty). Each panel
#'   is a named list.
#'
#' @importFrom jsonlite fromJSON
#' @export
#' @author Jared Andrews
#' @seealso [serialize_app_state()]
#' @examples
#' json <- serialize_app_state(list(
#'     panels = list(list(module = "bar", dataset = "example_bar"))
#' ))
#' state <- deserialize_app_state(json)
#' state$panels[[1]]$module
deserialize_app_state <- function(json) {
    if (is.null(json) || (is.character(json) && !nzchar(json[[1]]))) {
        stop("No app-state JSON provided.", call. = FALSE)
    }

    parsed <- tryCatch(
        jsonlite::fromJSON(json, simplifyVector = TRUE, simplifyDataFrame = FALSE),
        error = function(e) {
            stop("Could not parse app-state JSON: ", conditionMessage(e), call. = FALSE)
        }
    )

    if (!is.list(parsed)) {
        stop("App-state document must be a JSON object.", call. = FALSE)
    }

    version <- parsed$schema_version
    if (is.null(version) || !is.character(version) || length(version) != 1L) {
        stop("App-state document is missing a valid 'schema_version'.", call. = FALSE)
    }

    supported <- app_state_schema_version()
    if (.app_state_major(version) != .app_state_major(supported)) {
        stop(
            sprintf(
                "Unsupported app-state schema version '%s' (this build reads '%s').",
                version, supported
            ),
            call. = FALSE
        )
    }

    panels <- parsed$panels
    if (is.null(panels)) {
        panels <- list()
    }
    if (!is.list(panels)) {
        stop("App-state 'panels' must be a JSON array.", call. = FALSE)
    }
    if (!is.null(panels$module)) {
        # A lone panel object decoded to a named list rather than a length-1
        # array; wrap it so callers always iterate over a list of panels.
        panels <- list(panels)
    }

    parsed$panels <- panels
    parsed
}

# Extract the major component of a "major.minor" version string.
.app_state_major <- function(version) {
    strsplit(version, ".", fixed = TRUE)[[1]][[1]]
}
