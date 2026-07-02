#' Parse a string indicating a set of vectors to a list of vectors.
#'
#' Used to parse text inputs into a list of vectors.
#'
#' @param x A string indicating a set of vectors.
#'   Supported formats include `"(a, b), (c)"`, `"<a, b>, <c>"`, or brackets.
#'   Should not contain internal quotes around elements.
#'
#' @return A list like `list(c("a", "b", "c"), c("d", "e"))`.
#'   If the input is "", just returns "". If the input is `NULL`, returns `NULL`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_string_to_list_of_vectors
#' @keywords internal
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
#' @keywords internal
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
#' @export
#' @examples
#' string_to_linetypes("solid, dashed, dotted")
#' string_to_linetypes("")
string_to_linetypes <- function(x) {
    valid_linetypes <- c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")

    if (is.null(x) || identical(x, "")) {
        return("solid")
    }

    # Split string on commas and trim whitespace
    linetypes <- trimws(strsplit(x, ",")[[1]])
    linetypes <- linetypes[linetypes != ""]

    if (length(linetypes) == 0) {
        return("solid")
    }

    # Validate 
    validated <- vapply(linetypes, function(lt) {
        lt_lower <- tolower(lt)
        if (lt_lower %in% valid_linetypes) {
            lt_lower
        } else {
            warning(paste0(
                "Invalid linetype '", lt, "'. Using 'solid' instead. ",
                "Valid options: ", paste(valid_linetypes, collapse = ", ")
            ))
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
#' groups <- c("A", "B", "C")
#' colors <- c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
#' resolve_palette(groups, colors)
#' # Returns: c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
#'
#' # Using default palette
#' resolve_palette(groups, NULL, c("#1B9E77", "#D95F02", "#7570B3"))
#' # Returns: c(A = "#1B9E77", B = "#D95F02", C = "#7570B3")
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
#' if (interactive()) {
#'     library(shiny)
#'     library(plotly)
#'
#'     ui <- fluidPage(
#'         selectInput("x_var", "X variable", choices = names(mtcars), selected = "wt"),
#'         selectInput("y_var", "Y variable", choices = names(mtcars), selected = "mpg"),
#'         checkboxInput("auto.update", "Auto-update", value = TRUE),
#'         actionButton("update", "Update"),
#'         plotlyOutput("myPlot")
#'     )
#'
#'     server <- function(input, output, session) {
#'         output$myPlot <- renderPlotly({
#'             isolate_fn <- setup_auto_update_logic(input)
#'             x_val <- isolate_fn(input$x_var)
#'             y_val <- isolate_fn(input$y_var)
#'             plot_ly(mtcars, x = ~ .data[[x_val]], y = ~ .data[[y_val]], type = "scatter",
#'                 mode = "markers")
#'         })
#'     }
#'
#'     shinyApp(ui, server)
#' }
setup_auto_update_logic <- function(input) {
    auto_update <- input$auto.update
    req(!is.null(auto_update))

    # If update button is required, add dependency on it
    if (!auto_update) {
        input$update
    }

    if (auto_update) identity else isolate
}


#' Safely evaluate a user-provided filter expression against a data frame
#'
#' Parses the expression text, validates that it only contains allowed
#' operations (comparisons, logical operators, column references, and
#' literals), then evaluates it in a restricted environment containing
#' only the data frame columns. Returns a logical vector suitable for
#' row subsetting, or `NULL` if the input is empty or invalid.
#'
#' **Use this function any time a module evaluates a user-typed expression
#' directly** (e.g., a row-filter text input). Never call `eval(str2expression())`
#' on raw user input — doing so allows arbitrary code execution on the server.
#'
#' @param expr_text Character string containing the filter expression
#'   (e.g., `"Sepal.Length > 5 & Species == 'setosa'"`).
#' @param data A `data.frame` whose columns are made available for the expression.
#' @return A logical vector the same length as `nrow(data)`, or `NULL` if the
#'   input is empty, unparseable, or contains disallowed operations.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' safe_eval_filter("Sepal.Length > 5", iris)
#' safe_eval_filter("Sepal.Length > 5 & Species == 'setosa'", iris)
#' safe_eval_filter("", iris) # NULL
#' safe_eval_filter("system('echo pwned')", iris) # NULL + warning
safe_eval_filter <- function(expr_text, data) {
    if (is.null(expr_text) || !nzchar(trimws(expr_text))) {
        return(NULL)
    }

    parsed <- tryCatch(parse(text = expr_text), error = function(e) NULL)
    if (is.null(parsed) || length(parsed) == 0) {
        warning("Could not parse filter expression.")
        return(NULL)
    }

    # Walk the AST and ensure only whitelisted operations are used
    allowed_calls <- c(
        "<", ">", "<=", ">=", "==", "!=",
        "&", "&&", "|", "||", "!",
        "%in%", "c", "is.na", "is.null",
        "(", "-", "+", "*", "/", ":", "%%"
    )
    col_names <- names(data)

    .check_node <- function(node) {
        if (is.atomic(node) || is.null(node)) {
            return(TRUE)
        }
        if (is.symbol(node)) {
            nm <- as.character(node)
            if (nm %in% col_names || nm %in% c("TRUE", "FALSE", "T", "F", "NA", "NULL", "Inf", "NaN")) {
                return(TRUE)
            }
            # Unknown symbol — block it
            return(FALSE)
        }
        if (is.call(node)) {
            fn_name <- as.character(node[[1L]])
            if (!fn_name %in% allowed_calls) {
                return(FALSE)
            }
            # Recursively check all arguments
            for (i in seq_along(node)[-1]) {
                if (!.check_node(node[[i]])) {
                    return(FALSE)
                }
            }
            return(TRUE)
        }
        if (is.pairlist(node)) {
            return(all(vapply(node, .check_node, logical(1))))
        }
        FALSE
    }

    expr <- parsed[[1L]]
    if (!.check_node(expr)) {
        warning(
            "Filter expression contains disallowed operations. ",
            "Only column references, comparisons, and logical operators are permitted."
        )
        return(NULL)
    }

    # Evaluate in a restricted environment with only data columns
    env <- list2env(as.list(data), parent = baseenv())
    tryCatch(
        eval(expr, envir = env),
        error = function(e) {
            warning("Filter expression error: ", e$message)
            NULL
        }
    )
}

#' Safely resolve an adjustment function name to an actual function
#'
#' Validates that the provided function name is in the allowed list before
#' converting it to a function reference. Returns `NULL` for empty strings
#' or unrecognized names.
#'
#' **Use this instead of `eval(str2expression())` when resolving function names
#' from user input** (e.g., a dropdown that selects a transformation like
#' `"log2"` or `"sqrt"`).
#'
#' @param fn_name Character string — name of the adjustment function.
#'   Currently allowed values: `"log2"`, `"log"`, `"log10"`, `"neg_log10"`,
#'   `"log1p"`, `"as.factor"`, `"abs"`, `"sqrt"`.
#' @return The corresponding function, or `NULL` if `fn_name` is empty or
#'   not in the allowed list.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' safe_resolve_adj_fxn("log2") # returns log2
#' safe_resolve_adj_fxn("") # NULL
#' safe_resolve_adj_fxn("system") # warning + NULL
safe_resolve_adj_fxn <- function(fn_name) {
    if (is.null(fn_name) || !nzchar(trimws(fn_name))) {
        return(NULL)
    }

    allowed <- c("log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")
    if (!fn_name %in% allowed) {
        warning("Unrecognized adjustment function: ", fn_name)
        return(NULL)
    }

    match.fun(fn_name)
}

#' Validate a user-provided expression string for safety
#'
#' Parses the expression text and walks the AST to ensure it only contains
#' allowed operations (comparisons, logical operators, column references, and
#' literals). Returns the original string if valid, or `NULL` if the input
#' is empty, unparseable, or contains disallowed operations. This is useful
#' when the expression string must be passed through to a downstream function
#' (e.g., `plotthis::BoxPlot(highlight = ...)`) rather than evaluated directly.
#'
#' **Use this when a module passes a user-typed expression string to an
#' external plotting function** that will evaluate it internally. The string
#' is validated but not executed by this function.
#'
#' @param expr_text Character string containing the expression to validate
#'   (e.g., `"group == 'A' & value > 10"`).
#' @param col_names Character vector of allowed column/symbol names
#'   (typically `names(data)`).
#' @return The original `expr_text` string if safe, or `NULL`.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' validate_expression("Sepal.Length > 5", names(iris))
#' validate_expression("system('echo pwned')", names(iris)) # NULL + warning
#' validate_expression("", names(iris)) # NULL
validate_expression <- function(expr_text, col_names) {
    if (is.null(expr_text) || !nzchar(trimws(expr_text))) {
        return(NULL)
    }

    parsed <- tryCatch(parse(text = expr_text), error = function(e) NULL)
    if (is.null(parsed) || length(parsed) == 0) {
        warning("Could not parse expression.")
        return(NULL)
    }

    allowed_calls <- c(
        "<", ">", "<=", ">=", "==", "!=",
        "&", "&&", "|", "||", "!",
        "%in%", "c", "is.na", "is.null",
        "(", "-", "+", "*", "/", ":", "%%"
    )

    .check_node <- function(node) {
        if (is.atomic(node) || is.null(node)) {
            return(TRUE)
        }
        if (is.symbol(node)) {
            nm <- as.character(node)
            if (nm %in% col_names || nm %in% c("TRUE", "FALSE", "T", "F", "NA", "NULL", "Inf", "NaN")) {
                return(TRUE)
            }
            return(FALSE)
        }
        if (is.call(node)) {
            fn_name <- as.character(node[[1L]])
            if (!fn_name %in% allowed_calls) {
                return(FALSE)
            }
            for (i in seq_along(node)[-1]) {
                if (!.check_node(node[[i]])) {
                    return(FALSE)
                }
            }
            return(TRUE)
        }
        if (is.pairlist(node)) {
            return(all(vapply(node, .check_node, logical(1))))
        }
        FALSE
    }

    expr <- parsed[[1L]]
    if (!.check_node(expr)) {
        warning(
            "Expression contains disallowed operations. ",
            "Only column references, comparisons, and logical operators are permitted."
        )
        return(NULL)
    }

    expr_text
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
#' @param selected A list of parameter names to extract. Note that co-documented
#'   parameters (e.g., `x.by` and `y.by`) should be grouped together in a vector
#'   within the list or an error will be thrown by `extract_roc_text`.
#' @param cap Logical; if TRUE, capitalize the first letter of each description.
#'
#' @return A named list where names are parameter names and values are
#'   their documentation strings. Returns empty strings for parameters
#'   not found in the documentation.
#'
#' @importFrom roclang extract_roc_text
#' 
#' @author Jacob Martin, Jared Andrews
#' @export
get_documentation <- function(package_name, type = "param", selected = NULL, cap = FALSE) {
    docs <- lapply(selected, function(s) {
        doc <- tryCatch(
            extract_roc_text(package_name, type = type, select = s, capitalize = cap),
            error = function(e) NA_character_
        )

        if (length(doc) == 0 || all(is.na(doc))) {
            return("")
        }

        doc |>
            gsub("\\\\n", " ", x = _) |>
            gsub("\\\\", "", x = _) |>
            gsub("code\\{([^}]+)\\}", "`\\1`", x = _) |>
            gsub("\n", " ", x = _) |>
            trimws(x = _)
    })

    # Expand co-documented parameters (e.g., c("x.by", "y.by")) into
    # separate named elements sharing the same documentation string.
    result <- list()
    for (i in seq_along(selected)) {
        param_names <- selected[[i]]
        for (nm in param_names) {
            result[[nm]] <- docs[[i]]
        }
    }
    result
}
