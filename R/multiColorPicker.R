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
multiColorPicker <- function(inputId,
                             label = NULL,
                             groups,
                             palette_options = NULL,
                             selected_palette = NULL,
                             colors = NULL,
                             width = NULL,
                             show_text = TRUE) {
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
  if (is.null(selected_palette) || is.na(selected_palette) || !selected_palette %in% names(palette_lookup)) {
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

  palette_select <- shiny::tags$select(
    id = paste0(inputId, "-palette"),
    class = "mc-palette-select form-control input-sm",
    `aria-label` = "Palette",
    .build_palette_options(palette_source, selected_palette)
  )

  rows <- lapply(seq_along(groups), function(i) {
    grp <- groups[[i]]
    shiny::tags$div(
      class = paste("mc-color-row", if (i == 1) "is-active"),
      `data-group` = grp,
      shiny::tags$span(class = "mc-group-label", grp),
      shiny::tags$input(
        type = "color",
        class = "mc-color-input",
        value = initial_colors[[grp]],
        `aria-label` = paste0(grp, " color")
      ),
      if (isTRUE(show_text)) {
        shiny::tags$input(
          type = "text",
          class = "mc-text-input form-control input-sm",
          value = initial_colors[[grp]],
          `aria-label` = paste0(grp, " hex code")
        )
      }
    )
  })

  width_style <- if (!is.null(width)) {
    paste0("max-width:", shiny::validateCssUnit(width), ";")
  }

  widget <- shiny::tags$div(
    class = "multi-color-picker shiny-input-container form-group",
    id = inputId,
    style = width_style,
    `data-palettes` = palette_json,
    `data-initial` = initial_json,
    `data-groups` = groups_json,
    `data-default-palette` = selected_palette,
    shiny::tags$div(
      class = "mc-top",
      if (!is.null(label)) shiny::tags$label(class = "control-label", `for` = inputId, label),
      shiny::tags$div(
        class = "mc-actions",
        palette_select,
        shiny::tags$button(
          type = "button", class = "mc-button mc-apply-palette",
          "Apply"
        ),
        shiny::tags$button(
          type = "button", class = "mc-button mc-reset-palette",
          "Reset"
        )
      )
    ),
    shiny::tags$div(class = "mc-swatch-row", role = "list"),
    shiny::tags$div(class = "mc-color-rows", rows)
  )

  htmltools::attachDependencies(
    shiny::tagList(
      shiny::singleton(shiny::tags$style(shiny::HTML(.multi_color_picker_css()))),
      widget
    ),
    .multi_color_picker_dependency()
  )
}

.multi_color_picker_dependency <- function() {
  htmltools::htmlDependency(
    name = "multi-color-picker",
    version = as.character(utils::packageVersion("vizModules")),
    src = "src",
    package = "vizModules",
    script = "multiColorPicker.js"
  )
}

.register_multi_color_picker_handler <- function() {
  shiny::registerInputHandler(
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

.build_palette_options <- function(palette_source, selected_palette) {
  opts <- lapply(names(palette_source), function(cat) {
    entry <- palette_source[[cat]]
    if (is.list(entry)) {
      shiny::tags$optgroup(
        label = cat,
        lapply(names(entry), function(nm) {
          shiny::tags$option(
            value = nm,
            selected = if (nm == selected_palette) "selected" else NULL,
            nm
          )
        })
      )
    } else {
      shiny::tags$option(
        value = cat,
        selected = if (cat == selected_palette) "selected" else NULL,
        cat
      )
    }
  })

  # Flatten the list so selectInput renders correctly
  do.call(shiny::tagList, opts)
}

.seed_colors <- function(groups, palette) {
  palette <- .normalize_hex(palette)
  recycled <- rep_len(palette, length(groups))
  stats::setNames(recycled, groups)
}

.normalize_hex <- function(x) {
  if (length(x) == 0) {
    return(character(0))
  }

  vapply(x, function(val) {
    if (is.null(val) || is.na(val) || val == "") {
      return("")
    }

    val <- trimws(as.character(val))
    if (!startsWith(val, "#")) {
      col <- tryCatch(grDevices::col2rgb(val), error = function(...) NULL)
      if (!is.null(col)) {
        val <- sprintf("#%02X%02X%02X", col[1, 1], col[2, 1], col[3, 1])
      }
    } else if (nchar(val) == 4) {
      # Expand shorthand hex (#abc -> #aabbcc)
      val <- paste0("#", paste(rep.int(substring(val, 2:4, 2:4), each = 2), collapse = ""))
    }

    toupper(val)
  }, character(1))
}

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
  align-items: center;
  gap: 6px;
  margin-left: auto;
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
"
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0) y else x
}
