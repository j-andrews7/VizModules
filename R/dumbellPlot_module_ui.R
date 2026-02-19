dumbellPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    adj.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    inputs <- list(
        "Data" = tagList(
          selectInput(ns("x.value"), "Select X values (max 2):",
          selected = if (length(num.choices) >= 3) num.choices[2:3] else num.choices[2],
          choices = num.choices, multiple = TRUE
          ),
          selectInput(ns("y.value"), "Select Y value:",
          selected = if (length(cat.choices) > 1) cat.choices[2] else "",
          choices = cat.choices, multiple = FALSE
          ),
          selectInput(ns("x.adjustment"), "X Adjustment:",
            choices = adj.choices,
            selected = ifelse("x.adjustment" %in% names(defaults),
                ifelse(defaults[["x.adjustment"]] %in% adj.choices, defaults[["x.adjustment"]], ""),
                ""
            )
          ),
          selectInput(ns("colour.by"), "Colour by:",
            choices = c("X variables", "Y variables"),
            selected = "X variables"
          )
        ),

        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:",
            selected = "", choices = cat.choices
            ),
            selectInput(ns("facet.scales"), "Facet scales",
            choices   = c("fixed", "free", "free_x", "free_y"),
            selected  = ifelse("facet.scales" %in% names(defaults),
                ifelse(defaults[["facet.scales"]] %in% c("fixed", "free", "free_x", "free_y"),
                defaults[["facet.scales"]], "fixed"
                ),
                "fixed"
            )
            )
        ),

        "Aesthetics" = tagList(
          uiOutput(ns("palette.selection")),
          colourpicker::colourInput(ns("line.colour"), "Colour Of conectors", value = "red")
        ),

        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
        )


    organize_inputs(
        inputs,
        id = ns("dumbellPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}





dumbellPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("dumbellPlot"))
    )
}
