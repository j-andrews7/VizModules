#' Parse a string indicating a set of vectors to a list of vectors.
#'
#' Used to parse text inputs into a list of vectors.
#'
#' @param x A string indicating a set of vectors.
#'   Supported formats include "(a, b), (c)", "<a, b>, <c>", or brackets.
#'   Should not contain internal quotes around elements.
#'
#' @return A list like `list(c("a", "b", "c"), c("d", "e"))`.
#'   If the input is "", just returns "". If the input is `NULL`, returns `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_string_to_list_of_vectors
.string_to_list_of_vectors <- function(x) {
    if (!is.null(x)) {
        if (x != "") {
            # Regex to find content inside [], (), or <>
            matches <- regmatches(x, gregexpr("\\[.*?\\]|\\(.*?\\)|<.*?>", x))[[1]]

            if (length(matches) > 0) {
                # Remove brackets, split, trim
                x <- lapply(matches, function(m) {
                    content <- substr(m, 2, nchar(m) - 1)
                    items <- strsplit(content, ",")[[1]]
                    trimws(items)
                })
            } else {
                # treat as a single vector if no brackets found
                x <- list(trimws(strsplit(x, ",")[[1]]))
            }
        }
    }

    x
}

#' Parse a string delimited by commas, whitespace, or new lines to a vector.
#'
#' Used to parse text inputs into a vector.
#'
#' @param x A string of elements delimited by comma, whitespace, or new lines,
#'   e.g. "a, b c,d, e".
#'
#' @return A vector of strings like `c("a", "b", "c", "d", "e")`.
#'   If the input is "", just returns "". If the input is `NULL`, returns `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_string_to_vector
.string_to_vector <- function(x) {
    if (!is.null(x)) {
        if (x != "") {
            # Split string to vector based on commas, whitespace, or new lines
            x <- strsplit(x, ",|\\s|,\\s")[[1]]
        }
    }

    x
}

#' Parse and validate linetype string to a vector
#'
#' Parses a comma-separated string of linetypes and validates each element.
#' Invalid linetypes are replaced with "solid" and a warning is issued.
#'
#' @param x A string of linetypes delimited by commas, e.g. "solid, dashed, dotted".
#'   Valid linetypes are: "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#'
#' @return A character vector of validated linetypes.
#'   If the input is "" or NULL, returns "solid".
#'
#' @author Jared Andrews
#' @rdname INTERNAL_string_to_linetypes
.string_to_linetypes <- function(x) {
    valid_linetypes <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")

    if (is.null(x) || identical(x, "")) {
        return("solid")
    }

    # Split string on commas and trim whitespace
    linetypes <- trimws(strsplit(x, ",")[[1]])

    # Remove empty strings that might result from trailing commas
    linetypes <- linetypes[linetypes != ""]

    if (length(linetypes) == 0) {
        return("solid")
    }

    # Validate each linetype
    validated <- vapply(linetypes, function(lt) {
        lt_lower <- tolower(lt)
        if (lt_lower %in% valid_linetypes) {
            lt_lower
        } else {
            warning(paste0("Invalid linetype '", lt, "'. Using 'solid' instead. ",
                "Valid options: ", paste(valid_linetypes, collapse = ", ")))
            "solid"
        }
    }, character(1), USE.NAMES = FALSE)

    validated
}

#' Convert NA or empty string to NULL
#'
#' A helper function to convert NA values or empty strings to NULL.
#' Used to handle Shiny input default values which return NA or "" instead of NULL
#' when the input field is empty. numericInput returns NA, textInput returns "".
#'
#' @param x A value that may be NA or an empty string.
#' @return NULL if x is a single NA value or empty string, otherwise x unchanged.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_na_to_null
#' @keywords internal
.na_to_null <- function(x) {
    if (length(x) == 1 && (is.na(x) || identical(x, ""))) {
        return(NULL)
    }
    x
}

#' Negative log10 transformation
#'
#' A helper function for -log10 transformation.
#'
#' @param x Numeric vector to transform.
#' @return `-log10(x)`
#'
#' @author Jared Andrews
#' @rdname INTERNAL_neglog10
#' @keywords internal
neg_log10 <- function(x) {
    -log10(x)
}

#' Set up auto-update/isolate logic for reactive contexts
#'
#' A helper function that encapsulates the common pattern of handling auto-update
#' functionality in module servers. When auto-update is disabled, it adds a dependency
#' on the update button. Returns a wrapper function that either isolates reactive
#' expressions or passes them through unchanged.
#'
#' @param input The Shiny input object from the module server.
#' @return A function that wraps reactive expressions. Returns `identity` if auto-update
#'   is enabled (expressions will be reactive), or `isolate` if auto-update is disabled
#'   (expressions will not trigger reactivity).
#'
#' @details
#' This function consolidates the following common pattern:
#' \preformatted{
#' auto_update <- input$auto.update
#' if (!auto_update) {
#'     input$update
#' }
#' isolate_fn <- if (auto_update) identity else isolate
#' }
#'
#' Usage in a reactive context:
#' \preformatted{
#' output$plot <- renderPlotly({
#'     isolate_fn <- setup_auto_update_logic(input)
#'     # Now use isolate_fn to wrap input values
#'     x_val <- isolate_fn(input$x.value)
#' })
#' }
#'
#' @export
#' @author Jared Andrews
#' @examples
#' \dontrun{
#' # In a module server function:
#' output$myPlot <- renderPlot({
#'     isolate_fn <- setup_auto_update_logic(input)
#'     # Use isolate_fn to wrap inputs that should respect auto-update setting
#'     ggplot(data(), aes(x = isolate_fn(input$x_var), y = isolate_fn(input$y_var))) +
#'         geom_point()
#' })
#' }
setup_auto_update_logic <- function(input) {
    auto_update <- input$auto.update

    # If update button is required, add dependency on it
    if (!auto_update) {
        input$update
    }

    # Set up wrapper function based on switch state
    if (auto_update) identity else isolate
}
