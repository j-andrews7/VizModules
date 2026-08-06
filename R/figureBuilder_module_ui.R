#' UI component for the Figure Builder module
#'
#' Renders the full multi-panel **Figure Builder** interface (sidebar controls
#' plus the free-form A4 canvas) as a namespaced Shiny module. Place this in the
#' UI where you want the builder to appear, using an `id` that matches the one
#' passed to [figureBuilderServer()].
#'
#' Unlike [figureBuilderApp()] (which returns a complete, standalone app), this
#' function returns a `tagList` you can drop into any page, so the builder can be
#' embedded alongside other content and instantiated more than once (each
#' instance keeps its own namespace, canvas, and downloads).
#'
#' The returned UI bundles the JavaScript and CSS the canvas needs, and calls
#' [shinyjs::useShinyjs()], so no extra setup is required in the host app.
#'
#' @param id The ID for the Shiny module. Must match the `id` given to
#'   [figureBuilderServer()].
#' @param title A character string used as the header shown above the builder
#'   (default: `"VizModules Figure Builder"`). Pass `NULL` to omit the header,
#'   which is useful when the host page supplies its own title.
#'
#' @return A Shiny `tagList` containing the Figure Builder UI.
#'
#' @import shiny
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jared Andrews
#' @seealso [figureBuilderServer()], [figureBuilderApp()]
#' @examples
#' library(VizModules)
#' figureBuilderUI("figure_builder")
figureBuilderUI <- function(id, title = "VizModules Figure Builder") {
    ns <- NS(id)

    tagList(
        shinyjs::useShinyjs(),
        tags$head(tags$style(.figure_builder_css()), tags$script(.figure_builder_js())),
        if (!is.null(title)) titlePanel(title),
        sidebarLayout(
            sidebarPanel(
                width = 4,
                fluidRow(
                    column(
                        6,
                        actionButton(ns("pb_add"), "Add Plot",
                            icon = icon("plus"), class = "btn-primary btn-block"
                        )
                    ),
                    column(
                        6,
                        tipify(
                            downloadButton(ns("download.source"), "Source Data & Plots",
                                class = "btn-primary btn-block"
                            ),
                            paste(
                                "Download a ZIP of the source data, HTML plots, and",
                                "statistics (if applied) for all plots on the canvas."
                            ),
                            options = list(container = "body")
                        )
                    )
                ),
                helpText(
                    "Add plots, then drag them by their title bar and resize",
                    "from the bottom-right corner."
                ),
                # 'Load Data' is collapsed by default so it only occupies space
                # when the user actually wants to upload a dataset.
                tags$details(
                    class = "pb-details",
                    tags$summary("Load Data"),
                    helpText(
                        "Upload a CSV, TSV, TXT, or RDS file to make it available",
                        "as a dataset when adding plots."
                    ),
                    splitLayout(
                        textInput(ns("pb_data_name"), "Dataset name (optional):",
                            placeholder = "Defaults to the file name"
                        ),
                        fileInput(ns("pb_data_file"), "File:",
                            accept = c(".csv", ".tsv", ".txt", ".rds", ".RDS")
                        )
                    ),
                    actionButton(ns("pb_data_add"), "Add dataset",
                        icon = icon("upload")
                    )
                ),
                hr(),
                h3("Canvas"),
                splitLayout(
                    selectInput(ns("pb_orientation"), "Page size:",
                        choices = c(
                            "A4 portrait" = "portrait",
                            "A4 landscape" = "landscape"
                        )
                    ),
                    # selectize = FALSE keeps a plain <select> in the DOM so the
                    # client-side SVG export can read the chosen value directly.
                    selectInput(ns("pb_label_case"), "Panel labels:",
                        choices = c(
                            "Uppercase (A, B, C)" = "upper",
                            "None" = "none",
                            "Lowercase (a, b, c)" = "lower"
                        ),
                        selectize = FALSE
                    ) |> tagAppendAttributes(class = "pb-label-case")
                ),
                # The SVG export is handled client-side; a delegated click handler
                # (bound by class) finds this button's sibling canvas by namespace,
                # so no inline onclick or hardcoded id is needed.
                tags$button("Download Full Figure (SVG)",
                    id = ns("pb_download"), type = "button",
                    class = "btn btn-success btn-block pb-download-svg"
                ),
                hr(),
                h3("Plot Controls"),
                selectInput(ns("pb_controls_select"), "Show controls for:",
                    choices = character(0)
                ),
                div(
                    id = ns("pb_controls_container"),
                    div(
                        class = "pb-empty-hint", id = ns("pb_controls_empty"),
                        "Add a plot to configure its controls here."
                    )
                )
            ),
            mainPanel(
                width = 8,
                div(
                    id = ns("pb_canvas_scroll"), class = "pb-canvas-scroll",
                    div(
                        id = ns("pb_canvas"), class = "pb-canvas a4-portrait",
                        div(
                            class = "pb-empty-hint", id = ns("pb_canvas_empty"),
                            "No plots yet. Click \"Add Plot\" to begin."
                        )
                    )
                ),
                hr(),
                h4("Data Filtering"),
                p("Filtering a plot's table subsets only that plot's data. ",
                    "Specific numeric filters can be applied by entering a range like '1 ... 10'.",
                    style = "color: grey; font-size: 12px;"
                ),
                selectInput(ns("pb_table_select"), "Show table for:",
                    choices = character(0)
                ),
                div(
                    id = ns("pb_table_container"),
                    div(
                        class = "pb-empty-hint", id = ns("pb_table_empty"),
                        "Add a plot to view and filter its data here."
                    )
                )
            )
        )
    )
}
