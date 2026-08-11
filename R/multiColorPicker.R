#' Compact multi-group color picker input
#'
#' Build a compact Shiny input that assigns colors to a set of groups using a
#' palette or manual hex pickers. The value returned to `input[[inputId]]` is a
#' named character vector of hex colors keyed by group.
#'
#' @details A group's color swatch is a native `<input type="color">`, whose
#' dialog reports a new value for every drag or click inside it. Rather than
#' send each one - rebuilding a dependent plot dozens of times for a single
#' color choice - the input reports once the dialog has closed, detected as the
#' first pointer, key, or scroll event the page sees again (the dialog holds
#' both while it is open) or the browser window regaining focus. Typing in a hex
#' field is coalesced until the user pauses instead. One-shot actions - clicking
#' a palette swatch, "Apply", "Reset", selecting another group, or committing a
#' hex code with Enter or by clicking away - report immediately.
#'
#' The widget reflows to its container: the palette selector shrinks and the
#' buttons wrap below it when narrow, and long group names wrap rather than
#' running under their controls, so it can be dropped into a sidebar or an input
#' grid cell without controls escaping the panel.
#'
#' @param inputId Character. Shiny input id.
#' @param label Optional label displayed above the control.
#' @param groups Character or factor vector of group names.
#' @param palette_options Named list of palettes (each a character vector of
#'   colors). Defaults to the palettes from [default_palettes()].
#' @param selected_palette Optional name of the palette to preselect.
#' @param colors Optional named vector of starting colors. Values are matched to
#'   `groups` by name when provided.
#' @param width Optional CSS width for the container.
#' @param show_text Logical. If `TRUE`, show editable hex text inputs beside the
#'   color pickers.
#' @param compact Logical. If `TRUE`, renders a tighter layout with reduced
#'   spacing, smaller controls, and narrower palette selector.
#' @param panel Logical. If `FALSE`, removes the surrounding panel/well styling
#'   (border, padding, background).
#'
#' @return A UI element that produces a named character vector of colors.
#'
#' @import shiny
#' @importFrom htmltools attachDependencies htmlDependency
#' @importFrom jsonlite toJSON
#'
#' @export
#' @author Jared Andrews
#'
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'     groups <- c("setosa", "virginica", "versicolor")
#'
#'     ui <- fluidPage(
#'         multiColorPicker(
#'             "species_cols",
#'             "Species colors",
#'             groups = groups,
#'             selected_palette = "dittoColors"
#'         ),
#'         verbatimTextOutput("chosen")
#'     )
#'
#'     server <- function(input, output, session) {
#'         output$chosen <- renderPrint(input$species_cols)
#'     }
#'
#'     shinyApp(ui, server)
#' }
multiColorPicker <- function(inputId,
                             label = NULL,
                             groups,
                             palette_options = NULL,
                             selected_palette = NULL,
                             colors = NULL,
                             width = NULL,
                             show_text = TRUE,
                             compact = FALSE,
                             panel = TRUE) {
    .register_multi_color_picker_handler()

    if (missing(inputId) || is.null(inputId) || !nzchar(inputId)) {
        stop("`inputId` must be a non-empty string.")
    }
    if (missing(groups) || length(groups) == 0) {
        stop("`groups` must contain at least one value.")
    }

    groups <- as.character(unique(groups))

    palette_source <- palette_options
    if (is.null(palette_source)) {
        palette_source <- default_palettes()$choices
    }

    palette_lookup <- .flatten_palette_options(palette_source)
    if (length(palette_lookup) == 0) {
        stop("`palette_options` must contain at least one palette.")
    }

    palette_lookup <- lapply(palette_lookup, .normalize_hex)
    if (
        is.null(selected_palette) ||
            is.na(selected_palette) ||
            !selected_palette %in% names(palette_lookup)
    ) {
        selected_palette <- names(palette_lookup)[1]
    }

    if (length(palette_lookup[[selected_palette]]) == 0) {
        stop("The selected palette does not contain any colors.")
    }

    base_colors <- .seed_colors(groups, palette_lookup[[selected_palette]])

    if (!is.null(colors)) {
        override <- .normalize_hex(colors)
        if (is.null(names(override))) {
            idx <- seq_len(min(length(override), length(base_colors)))
            base_colors[idx] <- override[idx]
        } else {
            matched <- intersect(names(override), groups)
            base_colors[matched] <- override[matched]
        }
    }

    initial_colors <- .normalize_hex(base_colors)
    names(initial_colors) <- groups

    palette_json <- toJSON(palette_lookup, auto_unbox = TRUE)
    initial_json <- toJSON(as.list(initial_colors), auto_unbox = TRUE)
    groups_json <- toJSON(groups, auto_unbox = TRUE)

    palette_select <- tags$select(
        id = paste0(inputId, "-palette"),
        class = "mc-palette-select form-control input-sm",
        `aria-label` = "Palette",
        .build_palette_options(palette_source, selected_palette)
    )

    rows <- lapply(seq_along(groups), function(i) {
        grp <- groups[[i]]
        # Index by position, not by name: `initial_colors` is aligned to
        # `groups` by construction, and a name lookup (`[[grp]]`) throws
        # "subscript out of bounds" when a group label is "" (a blank factor
        # level, common in real metadata).
        col_val <- initial_colors[[i]]
        tags$div(
            class = paste("mc-color-row", if (i == 1) "is-active"),
            `data-group` = grp,
            tags$span(class = "mc-group-label", grp),
            tags$input(
                type = "color",
                class = "mc-color-input",
                value = col_val,
                `aria-label` = paste0(grp, " color")
            ),
            if (isTRUE(show_text)) {
                tags$input(
                    type = "text",
                    class = "mc-text-input form-control input-sm",
                    value = col_val,
                    `aria-label` = paste0(grp, " hex code")
                )
            }
        )
    })

    width_style <- if (!is.null(width)) {
        paste0("max-width:", validateCssUnit(width), ";")
    }

    widget <- tags$div(
        class = paste(
            "multi-color-picker shiny-input-container form-group",
            if (isTRUE(compact)) "is-compact" else NULL,
            if (!isTRUE(panel)) "is-plain" else NULL
        ),
        id = inputId,
        style = width_style,
        `data-palettes` = palette_json,
        `data-initial` = initial_json,
        `data-groups` = groups_json,
        `data-default-palette` = selected_palette,
        `data-compact` = if (isTRUE(compact)) "true" else "false",
        tags$div(
            class = "mc-top",
            if (!is.null(label)) {
                tags$label(
                    class = "control-label",
                    `for` = inputId,
                    label
                )
            },
            tags$div(
                class = "mc-actions",
                palette_select,
                tags$div(
                    class = "mc-button-group",
                    tags$button(
                        type = "button",
                        class = "mc-button mc-apply-palette",
                        "Apply"
                    ),
                    tags$button(
                        type = "button",
                        class = "mc-button mc-reset-palette",
                        "Reset"
                    )
                )
            )
        ),
        tags$div(class = "mc-swatch-row", role = "list"),
        tags$div(class = "mc-color-rows", rows)
    )

    attachDependencies(
        widget,
        .multi_color_picker_dependency()
    )
}

#' Update a multiColorPicker input on the client
#'
#' Change the color values assigned to groups in an existing multiColorPicker
#' input from the server side. You can supply explicit colors, apply a palette
#' by name, or reset the widget back to its initial state.
#'
#' @param session The Shiny session object, typically `session`.
#' @param inputId Character. The input id of the multiColorPicker to update.
#' @param colors Optional named character vector of hex colors keyed by group
#'   name. Only groups present in the vector will be updated; others remain
#'   unchanged. Ignored when `palette` or `reset` is provided.
#' @param palette Optional character string giving the name of a palette
#'   (as supplied in the widget's `palette_options`). The palette's colors are
#'   applied in order to the widget's groups' color pickers and the palette
#'   selector is updated to match. Ignored when `reset` is `TRUE`.
#' @param reset Logical. If `TRUE`, reset the widget to its initial state
#'   (colors and selected palette). Overrides `colors` and `palette`.
#'
#' @return Invisibly returns `NULL`. Called for its side effect.
#'
#' @import shiny
#' @export
#' @author Jared Andrews
#'
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'     groups <- c("setosa", "virginica", "versicolor")
#'
#'     ui <- fluidPage(
#'         multiColorPicker(
#'             "species_cols",
#'             "Species colors",
#'             groups = groups,
#'             selected_palette = "dittoColors"
#'         ),
#'         actionButton("randomize", "Randomize colors"),
#'         actionButton("apply_pal", "Apply ggplot2 palette"),
#'         actionButton("reset_cols", "Reset to initial"),
#'         verbatimTextOutput("chosen")
#'     )
#'
#'     server <- function(input, output, session) {
#'         output$chosen <- renderPrint(input$species_cols)
#'
#'         observeEvent(input$randomize, {
#'             new_colors <- setNames(
#'                 sprintf("#%06X", sample(0xFFFFFF, length(groups))),
#'                 groups
#'             )
#'             updateMultiColorPicker(session, "species_cols", colors = new_colors)
#'         })
#'
#'         observeEvent(input$apply_pal, {
#'             updateMultiColorPicker(session, "species_cols", palette = "ggplot2")
#'         })
#'
#'         observeEvent(input$reset_cols, {
#'             updateMultiColorPicker(session, "species_cols", reset = TRUE)
#'         })
#'     }
#'
#'     shinyApp(ui, server)
#' }
updateMultiColorPicker <- function(session, inputId, colors = NULL,
                                   palette = NULL, reset = FALSE) {
    if (missing(session) || is.null(session)) {
        stop("`session` must be a valid Shiny session object.")
    }
    if (missing(inputId) || is.null(inputId) || !nzchar(inputId)) {
        stop("`inputId` must be a non-empty string.")
    }

    # Build the message for the binding's receiveMessage handler.
    if (isTRUE(reset)) {
        msg <- list(reset = TRUE)
    } else if (!is.null(palette)) {
        if (!is.character(palette) || length(palette) != 1 || !nzchar(palette)) {
            stop("`palette` must be a single non-empty string.")
        }
        msg <- list(palette = palette)
    } else if (!is.null(colors) && length(colors) > 0) {
        colors <- .normalize_hex(colors)
        if (is.null(names(colors)) || any(names(colors) == "")) {
            stop("`colors` must be a named character vector with group names.")
        }
        msg <- list(value = lapply(names(colors), function(nm) {
            list(name = nm, value = colors[[nm]])
        }))
    } else {
        stop("One of `colors`, `palette`, or `reset` must be provided.")
    }

    session$sendInputMessage(inputId, msg)

    invisible(NULL)
}

#' HTML dependency for the multi-color picker widget
#'
#' Points htmltools to the bundled JavaScript assets so Shiny can initialize
#' the widget on the client.
#'
#' @return An `htmltools::htmlDependency` object.
#'
#' @importFrom htmltools htmlDependency
#'
#' @author Jared Andrews
#' @rdname INTERNAL_multi_color_picker_dependency
#' @keywords internal
.multi_color_picker_dependency <- function() {
    list(
        htmlDependency(
            name = "multi-color-picker",
            version = as.character(utils::packageVersion("VizModules")),
            src = "src",
            package = "VizModules",
            script = "multiColorPicker.js",
            stylesheet = "multiColorPicker.css"
        ),
        htmlDependency(
            name = "selectize",
            version = as.character(utils::packageVersion("shiny")),
            src = "www/shared/selectize",
            package = "shiny",
            script = c(
                "js/selectize.min.js",
                "accessibility/js/selectize-plugin-a11y.min.js"
            ),
            stylesheet = "css/selectize.bootstrap3.css"
        )
    )
}

#' Register input handler for the multi-color picker
#'
#' Creates the `VizModules.multiColorPicker` input handler that turns the
#' JavaScript payload into a named vector of hex codes.
#'
#' @return Invisibly returns the result of `registerInputHandler()`.
#' 
#' @importFrom stats setNames
#' @importFrom shiny registerInputHandler
#'
#' @author Jared Andrews
#' @rdname INTERNAL_register_multi_color_picker_handler
#' @keywords internal
.register_multi_color_picker_handler <- function() {
    registerInputHandler(
        "VizModules.multiColorPicker",
        function(data, ...) {
            if (is.null(data) || length(data) == 0) {
                return(setNames(character(0), character(0)))
            }

            vals <- vapply(data, function(x) x$value %__% "", character(1))
            nms <- vapply(data, function(x) x$name %__% "", character(1))
            setNames(vals, nms)
        },
        force = TRUE
    )
}

#' Flatten nested palette options
#'
#' Converts a nested list of palette choices into a single-level named list
#' where each entry is a character vector of colors.
#'
#' @param palettes A named list of palettes or nested category lists.
#'
#' @return A flattened named list of palettes.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_flatten_palette_options
#' @keywords internal
.flatten_palette_options <- function(palettes) {
    out <- list()
    if (is.null(palettes) || length(palettes) == 0) {
        return(out)
    }

    if (!is.list(palettes)) {
        stop("`palette_options` must be a list.")
    }

    for (nm in names(palettes)) {
        current <- palettes[[nm]]
        if (is.list(current) && !is.null(names(current))) {
            for (sub_nm in names(current)) {
                out[[sub_nm]] <- current[[sub_nm]]
            }
        } else {
            out[[nm]] <- current
        }
    }

    out
}

#' Build palette select options
#'
#' Creates `option` and `optgroup` tags used by the palette selector input.
#'
#' @param palette_source A named list of palette choices or nested categories.
#' @param selected_palette Optional palette name to mark as selected.
#'
#' @return A `tagList` containing the option/optgroup elements.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_build_palette_options
#' @keywords internal
.build_palette_options <- function(palette_source, selected_palette) {
    opts <- lapply(names(palette_source), function(cat) {
        entry <- palette_source[[cat]]
        if (is.list(entry)) {
            tags$optgroup(
                label = cat,
                lapply(names(entry), function(nm) {
                    tags$option(
                        value = nm,
                        selected = if (nm == selected_palette) {
                            "selected"
                        } else {
                            NULL
                        },
                        nm
                    )
                })
            )
        } else {
            tags$option(
                value = cat,
                selected = if (cat == selected_palette) "selected" else NULL,
                cat
            )
        }
    })

    # Flatten the list so selectInput renders correctly
    do.call(tagList, opts)
}

#' Seed group colors from a palette
#'
#' Recycles palette values to cover all requested groups and names the result.
#'
#' @param groups Character vector of group names.
#' @param palette Character vector of colors to recycle.
#'
#' @return A named character vector of colors aligned to `groups`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_seed_colors
#' @keywords internal
.seed_colors <- function(groups, palette) {
    palette <- .normalize_hex(palette)
    recycled <- rep_len(palette, length(groups))
    stats::setNames(recycled, groups)
}

#' Normalize colors to hex strings
#'
#' Converts color names or shorthand hex values to full `#RRGGBB` strings and
#' returns empty strings for missing values.
#'
#' @param x Character vector of colors or hex codes.
#'
#' @return A character vector of uppercase hex colors.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_normalize_hex
#' @keywords internal
.normalize_hex <- function(x) {
    if (length(x) == 0) {
        return(character(0))
    }

    vapply(
        x,
        function(val) {
            if (is.null(val) || is.na(val) || val == "") {
                return("")
            }

            val <- trimws(as.character(val))
            if (!startsWith(val, "#")) {
                col <- tryCatch(grDevices::col2rgb(val), error = function(...) {
                    NULL
                })
                if (!is.null(col)) {
                    val <- sprintf(
                        "#%02X%02X%02X",
                        col[1, 1],
                        col[2, 1],
                        col[3, 1]
                    )
                }
            } else if (nchar(val) == 4 || nchar(val) == 5) {
                # Expand shorthand hex (#abc -> #aabbcc, #abcd -> #aabbccdd)
                body <- substring(val, 2:nchar(val), 2:nchar(val))
                expanded <- paste(rep(body, each = 2), collapse = "")
                val <- paste0("#", expanded)
            }

            if (!nchar(val) %in% c(7L, 9L)) {
                return("")
            }

            if (nchar(val) == 9L) {
                val <- paste0("#", substring(val, 2, 7))
            }

            toupper(val)
        },
        character(1)
    )
}

#' Null-or-empty coalescing operator
#'
#' Returns the left-hand side unless it is `NULL` or has length zero, in which
#' case the right-hand side is returned.
#'
#' @param x Primary value.
#' @param y Fallback value.
#'
#' @return `x` when present, otherwise `y`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_null_coalesce
#' @keywords internal
`%__%` <- function(x, y) {
    if (is.null(x) || length(x) == 0) y else x
}
