#' Compact multi-group color picker input
#'
#' Build a compact Shiny input that assigns colors to a set of groups using a
#' palette or manual hex pickers. The value returned to `input[[inputId]]` is a
#' named character vector of hex colors keyed by group.
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
#'
#' @return A UI element that produces a named character vector of colors.
#'
#' @importFrom htmltools attachDependencies htmlDependency
#' @importFrom jsonlite toJSON
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library(shiny)
#'   groups <- c("setosa", "virginica", "versicolor")
#'
#'   ui <- fluidPage(
#'     multiColorPicker(
#'       "species_cols",
#'       "Species colors",
#'       groups = groups,
#'       selected_palette = "dittoColors"
#'     ),
#'     verbatimTextOutput("chosen")
#'   )
#'
#'   server <- function(input, output, session) {
#'     output$chosen <- renderPrint(input$species_cols)
#'   }
#'
#'   shinyApp(ui, server)
#' }
multiColorPicker <- function(
    inputId,
    label = NULL,
    groups,
    palette_options = NULL,
    selected_palette = NULL,
    colors = NULL,
    width = NULL,
    show_text = TRUE
) {
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
        tags$div(
            class = paste("mc-color-row", if (i == 1) "is-active"),
            `data-group` = grp,
            tags$span(class = "mc-group-label", grp),
            tags$input(
                type = "color",
                class = "mc-color-input",
                value = initial_colors[[grp]],
                `aria-label` = paste0(grp, " color")
            ),
            if (isTRUE(show_text)) {
                tags$input(
                    type = "text",
                    class = "mc-text-input form-control input-sm",
                    value = initial_colors[[grp]],
                    `aria-label` = paste0(grp, " hex code")
                )
            }
        )
    })

    width_style <- if (!is.null(width)) {
        paste0("max-width:", validateCssUnit(width), ";")
    }

    widget <- tags$div(
        class = "multi-color-picker shiny-input-container form-group",
        id = inputId,
        style = width_style,
        `data-palettes` = palette_json,
        `data-initial` = initial_json,
        `data-groups` = groups_json,
        `data-default-palette` = selected_palette,
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

    htmltools::attachDependencies(
        tagList(
            singleton(tags$style(HTML(.multi_color_picker_css()))),
            widget
        ),
        .multi_color_picker_dependency()
    )
}

#' HTML dependency for the multi-color picker widget
#'
#' Points htmltools to the bundled JavaScript assets so Shiny can initialize
#' the widget on the client.
#'
#' @return An `htmltools::htmlDependency` object.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_multi_color_picker_dependency
#' @keywords internal
.multi_color_picker_dependency <- function() {
    htmltools::htmlDependency(
        name = "multi-color-picker",
        version = as.character(utils::packageVersion("vizModules")),
        src = "src",
        package = "vizModules",
        script = "multiColorPicker.js"
    )
}

#' Register input handler for the multi-color picker
#'
#' Creates the `vizModules.multiColorPicker` input handler that turns the
#' JavaScript payload into a named vector of hex codes.
#'
#' @return Invisibly returns the result of `registerInputHandler()`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_register_multi_color_picker_handler
#' @keywords internal
.register_multi_color_picker_handler <- function() {
    registerInputHandler(
        "vizModules.multiColorPicker",
        function(data, ...) {
            if (is.null(data) || length(data) == 0) {
                return(setNames(character(0), character(0)))
            }

            vals <- vapply(data, function(x) x$value %||% "", character(1))
            nms <- vapply(data, function(x) x$name %||% "", character(1))
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
            } else if (nchar(val) == 4) {
                # Expand shorthand hex (#abc -> #aabbcc)
                val <- paste0(
                    "#",
                    paste(
                        rep.int(substring(val, 2:4, 2:4), each = 2),
                        collapse = ""
                    )
                )
            }

            toupper(val)
        },
        character(1)
    )
}

#' CSS for the multi-color picker widget
#'
#' Provides the inline stylesheet used to render the multi-color picker UI.
#'
#' @return A character string containing the CSS rules.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_multi_color_picker_css
#' @keywords internal
.multi_color_picker_css <- function() {
    "
.multi-color-picker {
  border: 1px solid #dee2e6;
  border-radius: 6px;
  padding: 10px;
  background: #ffffff;
  font-size: 13px;
}

.multi-color-picker .mc-top {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 6px;
}

.multi-color-picker .mc-actions {
  display: flex;
  align-items: flex-start;
  gap: 6px;
  margin-left: auto;
}

.multi-color-picker .selectize-control.mc-palette-select {
  width: 150px;
  min-width: 150px;
}

.multi-color-picker .selectize-control.mc-palette-select .selectize-input {
  min-height: 32px;
  padding: 4px 6px;
}

.multi-color-picker .mc-button-group {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.multi-color-picker .mc-palette-select {
  width: 150px;
  padding: 4px 6px;
  font-size: 12px;
}

.multi-color-picker .mc-button {
  padding: 4px 8px;
  font-size: 12px;
  border: 1px solid #ced4da;
  background: #f8f9fa;
  color: #333333;
  border-radius: 4px;
  cursor: pointer;
}

.multi-color-picker .mc-button:hover {
  background: #e9ecef;
}

.multi-color-picker .mc-swatch-row {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
  margin-bottom: 4px;
}

.multi-color-picker .mc-swatch {
  width: 18px;
  height: 18px;
  border-radius: 4px;
  border: 1px solid #ced4da;
  cursor: pointer;
}

.multi-color-picker .mc-swatch:hover {
  outline: 1px solid #6c757d;
}

.multi-color-picker .mc-color-rows {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.multi-color-picker .mc-color-row {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 8px;
  border: 1px solid #e9ecef;
  border-radius: 4px;
  cursor: pointer;
}

.multi-color-picker .mc-color-row.is-active {
  border-color: #94bde7;
  box-shadow: 0 0 0 2px rgba(52, 144, 220, 0.18);
}

.multi-color-picker .mc-group-label {
  flex: 1;
  min-width: 0;
  font-weight: 600;
  font-size: 12px;
}

.multi-color-picker .mc-color-input {
  width: 42px;
  height: 28px;
  padding: 0;
  border: 1px solid #ced4da;
  border-radius: 4px;
}

.multi-color-picker .mc-text-input {
  width: 96px;
  font-size: 12px;
}

.multi-color-picker .mc-option-row,
.multi-color-picker .mc-selected-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 6px;
}

.multi-color-picker .mc-option-label {
  font-weight: 600;
  font-size: 12px;
}

.multi-color-picker .mc-option-swatches {
  display: flex;
  gap: 2px;
  flex-wrap: wrap;
}

.multi-color-picker .mc-option-swatch {
  width: 14px;
  height: 14px;
  border-radius: 3px;
  border: 1px solid #ced4da;
  box-sizing: border-box;
}
"
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
`%||%` <- function(x, y) {
    if (is.null(x) || length(x) == 0) y else x
}
