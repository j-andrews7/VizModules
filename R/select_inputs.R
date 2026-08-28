#' Create a select input that scales to very large choice sets
#'
#' A drop-in replacement for [shiny::selectInput()] built on
#' [shinyWidgets::virtualSelectInput()]. The underlying `virtual-select`
#' library renders only the visible slice of the choice list, so a column with
#' tens of thousands of unique values stays responsive and readable instead of
#' producing an unusable wall of options.
#'
#' Defaults are chosen so this behaves like [shiny::selectInput()]:
#' when `selected` is not supplied and `multiple = FALSE`, the first choice is
#' selected. An empty-string choice (the "no selection" convention used
#' throughout this package) is relabelled `"(none)"` so it is visible in the
#' dropdown, while its value remains `""`.
#'
#' @param inputId The `input` slot that will be used to access the value.
#' @param label Display label for the control, or `NULL` for no label.
#' @param choices A vector or named list of values to select from, in the same
#'   form accepted by [shiny::selectInput()].
#' @param selected The initially selected value(s). Defaults to the first
#'   choice for single selects and nothing for multiple selects.
#' @param multiple Logical, whether multiple values can be selected.
#' @param search Logical, whether to show a search box. Defaults to `NULL`,
#'   which enables the search box once there are more than 10 choices.
#' @param width The width of the input, e.g. `"100%"` or `"400px"`.
#' @param ... Further arguments passed to
#'   [shinyWidgets::virtualSelectInput()], including any raw `virtual-select`
#'   property such as `optionsCount` or `zIndex`.
#'
#' @return A `shiny.tag` object to be included in a UI definition.
#'
#' @import shiny
#' @importFrom htmltools attachDependencies
#' @importFrom stats setNames
#' @importFrom utils modifyList
#' @export
#'
#' @author Jared Andrews
#' @seealso [update_viz_select()], [shinyWidgets::virtualSelectInput()]
#' @examples
#' library(VizModules)
#' viz_select_input("gene", "Gene", choices = c("", paste0("GENE", 1:1000)))
viz_select_input <- function(inputId, label, choices, selected = NULL, multiple = FALSE,
                             search = NULL, width = "100%", ...) {
    choices <- .label_empty_choice(choices)

    if (is.null(search)) {
        search <- length(unlist(choices, use.names = FALSE)) > 10
    }

    # Mirror selectInput(), which selects the first choice for single selects.
    if (is.null(selected) && !multiple && length(choices) > 0) {
        selected <- unlist(choices, use.names = FALSE)[1]
    }

    dots <- list(...)
    args <- list(
        inputId = inputId,
        label = label,
        choices = choices,
        selected = selected,
        multiple = multiple,
        search = search,
        width = width,
        showValueAsTags = multiple,
        autoSelectFirstOption = FALSE,
        # The `_open` companion input would otherwise pollute the input snapshot
        # taken for the source download.
        stateInput = FALSE,
        updateOn = if (multiple) "close" else "change",
        # Render the dropdown on <body> so it is not clipped by the input grid,
        # tabsets, or the figure builder's panels.
        dropboxWrapper = "body",
        # Body-wrapped dropdowns must clear Bootstrap's modal stacking context
        # (1050 in BS3, 1055 in BS5) or they render behind an open modal.
        zIndex = 1060
    )

    attachDependencies(
        do.call(shinyWidgets::virtualSelectInput, modifyList(args, dots)),
        .viz_select_dependency(),
        append = TRUE
    )
}


#' HTML dependency for viz_select_input
#'
#' Ships the small script that keeps Bootstrap's modal focus trap from stealing
#' focus away from a body-rendered virtual-select dropdown.
#'
#' @return An `htmltools::htmlDependency` object.
#'
#' @importFrom htmltools htmlDependency
#'
#' @author Jared Andrews
#' @rdname INTERNAL_viz_select_dependency
#' @keywords internal
.viz_select_dependency <- function() {
    htmlDependency(
        name = "viz-select",
        version = as.character(utils::packageVersion("VizModules")),
        src = "src",
        package = "VizModules",
        script = "vizSelect.js"
    )
}


#' Update a select input created by viz_select_input
#'
#' Companion to [viz_select_input()], wrapping
#' [shinyWidgets::updateVirtualSelect()] so the empty-string "no selection"
#' choice is relabelled consistently with the UI side.
#'
#' Unlike [shinyWidgets::updateVirtualSelect()], supplying `choices` without a
#' `selected` does not clear the widget: the current value is kept when it is
#' still one of the new choices, and the first choice is selected otherwise.
#' This mirrors [shiny::updateSelectInput()], which never leaves a single select
#' with no value.
#'
#' @param session The `session` object passed to the module server function.
#' @param inputId The id of the input to update.
#' @param choices New choices for the input, or `NULL` to leave them unchanged.
#' @param selected New value(s) to select. When `NULL` and `choices` is given,
#'   the current value is kept if it is still valid, falling back to the first
#'   choice. When `NULL` and `choices` is not given, the selection is left
#'   unchanged.
#' @param ... Further arguments passed to
#'   [shinyWidgets::updateVirtualSelect()].
#'
#' @return No return value, called for its side effect of updating the input.
#'
#' @import shiny
#' @export
#'
#' @author Jared Andrews
#' @seealso [viz_select_input()], [shinyWidgets::updateVirtualSelect()]
#' @examples
#' library(shiny)
#' library(VizModules)
#'
#' server <- function(input, output, session) {
#'     observeEvent(input$reset, {
#'         update_viz_select(session, "gene", choices = c("", "GENE1", "GENE2"))
#'     })
#' }
update_viz_select <- function(session, inputId, choices = NULL, selected = NULL, ...) {
    if (!is.null(choices)) {
        choices <- .label_empty_choice(choices)
        if (is.null(selected)) {
            # virtual-select's setOptions() blanks the value, so always send one.
            current <- tryCatch(isolate(session$input[[inputId]]), error = function(e) NULL)
            selected <- .keep_or_first_choice(current, choices)
        }
    }

    shinyWidgets::updateVirtualSelect(
        inputId = inputId,
        choices = choices,
        selected = selected,
        session = session,
        ...
    )
}


#' Carry a selection over to a new set of choices
#'
#' @param current The widget's current value, or `NULL`.
#' @param choices The new choices, already passed through `.label_empty_choice()`.
#'
#' @return The still-valid part of `current`, or the first choice value.
#'
#' @keywords internal
#' @noRd
.keep_or_first_choice <- function(current, choices) {
    values <- as.character(unlist(choices, use.names = FALSE))
    if (length(values) == 0) {
        return(character(0))
    }

    kept <- as.character(current)[as.character(current) %in% values]
    if (length(kept) > 0) kept else values[1]
}


#' Give the empty-string choice a visible label
#'
#' Modules use `""` to mean "no selection". `virtual-select` renders that as a
#' blank row, so name it while leaving the value untouched. Nested lists
#' (option groups) are passed through unchanged.
#'
#' @param choices A vector or list of choices.
#'
#' @return The choices, with any `""` value given the name `"(none)"` and any
#'   repeated value dropped.
#'
#' @keywords internal
#' @noRd
.label_empty_choice <- function(choices) {
    if (length(choices) == 0 || !is.atomic(choices)) {
        return(choices)
    }

    values <- as.character(choices)
    labels <- if (is.null(names(choices))) values else names(choices)
    labels[!nzchar(labels)] <- values[!nzchar(labels)]
    labels[!nzchar(values)] <- "(none)"

    # Callers often prepend "" to a vector that already carries one, which would
    # otherwise render "(none)" twice.
    keep <- !duplicated(values)

    setNames(values[keep], labels[keep])
}
