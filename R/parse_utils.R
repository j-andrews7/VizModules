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
