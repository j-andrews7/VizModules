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

#' Resolve a color palette for plot groups
#'
#' Maps groups to colors using selected colors or a default palette. Handles
#' named color vectors by matching to group names, fills in missing colors with
#' fallback values, and ensures the output vector is named and matches group length.
#'
#' @param groups A character vector of group names to assign colors to.
#' @param selected_colors A named or unnamed character vector of colors to use.
#'   If named, colors are matched to groups by name. If NULL or empty, uses
#'   `default_palette`.
#' @param default_palette A character vector of fallback colors to use when
#'   `selected_colors` is NULL/empty or when groups have missing colors.
#'   Defaults to "#000000" (black) if not provided.
#'
#' @return A named character vector of colors with names corresponding to groups,
#'   or NULL if groups is empty.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' \dontrun{
#' groups <- c("A", "B", "C")
#' colors <- c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
#' resolve_palette(groups, colors)
#' # Returns: c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
#'
#' # Using default palette
#' resolve_palette(groups, NULL, c("#1B9E77", "#D95F02", "#7570B3"))
#' }
resolve_palette <- function(groups, selected_colors = NULL, default_palette = NULL) {
    if (length(groups) == 0) {
        return(NULL)
    }

    colors <- selected_colors
    if (is.null(colors) || length(colors) == 0) {
        colors <- default_palette
    }

    if (is.null(colors) || length(colors) == 0) {
        colors <- "#000000"
    }

    if (!is.null(names(colors)) && any(nzchar(names(colors)))) {
        colors <- colors[match(groups, names(colors))]
    }

    if (any(is.na(colors))) {
        na_idx <- which(is.na(colors))
        fallback <- if (!is.null(default_palette) && length(default_palette) > 0) default_palette else "#000000"
        colors[na_idx] <- rep_len(fallback, length(na_idx))
    }

    colors <- rep_len(colors, length(groups))
    stats::setNames(colors[seq_along(groups)], groups)
}

#' Set up auto-update/isolate logic for reactive contexts
#'
#' A helper function that encapsulates the common pattern of handling auto-update
#' functionality in module servers. When auto-update is disabled, it adds a dependency
#' on the update button. Returns a wrapper function that either isolates reactive
#' expressions or passes them through unchanged.
#'
#' @param input The Shiny input object from the module server,
#'   should have both `auto.update` (boolean) and `update` (button) inputs.
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

#' Extract parameter documentation from an R function help page
#'
#' Parses the Rd documentation for a given function and extracts
#' parameter descriptions for specified parameter names.
#'
#' @param package_name A string in the format "package::function" indicating
#'   which function's documentation to parse.
#' @param type The type of documentation section to extract. Currently only
#'   "param" is supported.
#' @param selected A character vector of parameter names to extract.
#' @param cap Logical; if TRUE, capitalize the first letter of each description.
#'
#' @return A named list where names are parameter names and values are
#'   their documentation strings. Returns empty strings for parameters
#'   not found in the documentation.
#'
#' @author Jacob Martin, Jared Andrews
#' @rdname INTERNAL_get_documentation
#' @keywords internal
.get_documentation <- function(package_name, type = "param", selected = NULL, cap = FALSE) {
    # Parse package::function format
    parts <- strsplit(package_name, "::")[[1]]
    if (length(parts) != 2) {
        stop("package_name must be in 'package::function' format")
    }
    pkg <- parts[1]
    fn <- parts[2]

    result <- stats::setNames(
        as.list(rep("", length(selected))),
        selected
    )

    tryCatch({
        # Get the Rd object for the function
        rd <- utils:::.getHelpFile(help(fn, package = (pkg)))

        if (type == "param") {
            # Find \\arguments sections
            for (item in rd) {
                tag <- attr(item, "Rd_tag")
                if (!is.null(tag) && tag == "\\arguments") {
                    # Each child of \\arguments is an \\item
                    for (arg_item in item) {
                        arg_tag <- attr(arg_item, "Rd_tag")
                        if (!is.null(arg_tag) && arg_tag == "\\item") {
                            # First element is param name, rest is description
                            if (length(arg_item) >= 2) {
                                param_name <- paste(unlist(arg_item[[1]]), collapse = "")
                                param_desc <- paste(unlist(arg_item[[2]]), collapse = "")
                                param_desc <- trimws(gsub("\\s+", " ", param_desc))

                                if (param_name %in% selected) {
                                    if (cap && nzchar(param_desc)) {
                                        param_desc <- paste0(
                                            toupper(substring(param_desc, 1, 1)),
                                            substring(param_desc, 2)
                                        )
                                    }
                                    result[[param_name]] <- param_desc
                                }
                            }
                        }
                    }
                }
            }
        }
    }, error = function(e) {
        warning(paste("Could not extract documentation for", package_name, ":", e$message))
    })

    result
}
