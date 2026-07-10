#' Server logic for the Figure Builder module
#'
#' Powers the multi-panel **Figure Builder** module rendered by
#' [figureBuilderUI()]. Users can add any VizModules plot module to a free-form
#' A4 canvas, drag and resize each plot, filter each plot's data independently,
#' label panels automatically, and export the whole figure as a single editable
#' SVG (or bundle every plot's source data, HTML plot, and statistics into one
#' `.zip`).
#'
#' Call this from your app's server with the same `id` you passed to
#' [figureBuilderUI()]. Because it is a proper Shiny module, several Figure
#' Builders can coexist on one page, each with its own namespace and canvas.
#'
#' @param id The ID for the Shiny module. Must match the `id` given to
#'   [figureBuilderUI()].
#' @param data_list An optional named list of data frames that seed the dataset
#'   registry. If `NULL` (the default), the bundled example datasets (plus a
#'   `sales_by_product` summary suited to the pie plot) are used. At least one
#'   element is required and every element must be a data frame.
#' @param module_registry An optional named list describing the plot modules to
#'   offer. If `NULL` (the default), all bundled VizModules modules are offered.
#'   Each entry is itself a list with components: `label` (character, shown in the
#'   picker), `dataset` (character, the dataset name its `defaults` were written
#'   for), `inputs_ui`, `output_ui`, and `server_fn` (the module's three
#'   functions), and `defaults` (a named list of input defaults applied only when
#'   `dataset` is the chosen dataset).
#'
#' @return Invisibly returns `NULL`; called for its side effects (wiring up the
#'   Figure Builder module's reactive logic).
#'
#' @import shiny
#' @importFrom stats aggregate setNames
#'
#' @export
#' @author Jared Andrews
#' @seealso [figureBuilderUI()], [figureBuilderApp()]
#' @examples
#' library(VizModules)
#' if (interactive()) {
#'     ui <- fluidPage(figureBuilderUI("figure_builder"))
#'     server <- function(input, output, session) {
#'         figureBuilderServer("figure_builder")
#'     }
#'     shinyApp(ui, server)
#' }
figureBuilderServer <- function(id, data_list = NULL, module_registry = NULL) {
    # --- Validate / resolve inputs
    if (is.null(data_list)) {
        data_list <- .figure_builder_data()
    }
    stopifnot(is.list(data_list), length(data_list) >= 1)
    for (df in data_list) {
        stopifnot(is.data.frame(df))
    }

    if (is.null(module_registry)) {
        module_registry <- .figure_builder_registry()
    }
    stopifnot(is.list(module_registry), length(module_registry) >= 1)

    # The datasets that seed the dataset registry. Users can add their own
    # datasets at runtime via the "Load Data" section (see the server below),
    # which are appended to this catalogue.
    initial_datasets <- data_list

    # Choices for the "add plot" module picker (label shown, key returned).
    module_choices <- setNames(
        names(module_registry),
        vapply(module_registry, function(m) m$label, character(1))
    )

    moduleServer(id, function(input, output, session) {
        ns <- session$ns

        # Registry of datasets available to the "Add Plot" dialog.
        dataset_store <- reactiveVal(initial_datasets)

        # Reactive bookkeeping for the panels currently on the canvas.
        rv <- reactiveValues(
            panel_ids = character(0), # ordered vector of active panel ids
            labels    = list(), # pid -> display label
            counter   = 0L # monotonic id source
        )

        # Per-panel data snapshots (fixed at creation time) and the observers that
        # power each card's remove button. Storing the data in reactiveValues lets
        # us null it out on removal so any lingering reactive reads short-circuit
        # via req() instead of erroring.
        panel_data <- reactiveValues()

        # Per-panel source reactives returned by each module server. Used to bundle
        # every plot's interactive source (plot + data + inputs) into one download.
        panel_sources <- reactiveValues()
        panel_observers <- new.env(parent = emptyenv())

        observeEvent(input$pb_data_add, {
            file <- input$pb_data_file

            if (is.null(file)) {
                showNotification("Choose a file to load first.", type = "warning")
                return(invisible(NULL))
            }

            ext <- tolower(tools::file_ext(file$name))
            df <- tryCatch(
                {
                    switch(ext,
                        csv = utils::read.csv(file$datapath,
                            stringsAsFactors = FALSE, check.names = FALSE
                        ),
                        tsv = utils::read.delim(file$datapath,
                            stringsAsFactors = FALSE, check.names = FALSE
                        ),
                        txt = utils::read.delim(file$datapath,
                            stringsAsFactors = FALSE, check.names = FALSE
                        ),
                        rds = readRDS(file$datapath),
                        stop("Unsupported file type '.", ext, "'.")
                    )
                },
                error = function(e) e
            )

            if (inherits(df, "error")) {
                showNotification(paste("Could not read file:", conditionMessage(df)),
                    type = "error", duration = 8
                )
                return(invisible(NULL))
            }

            if (!is.data.frame(df)) {
                df <- tryCatch(as.data.frame(df, check.names = FALSE),
                    error = function(e) NULL
                )
            }

            if (!is.data.frame(df) || nrow(df) == 0L || ncol(df) == 0L) {
                showNotification("File must contain a non-empty data frame.",
                    type = "error", duration = 8
                )
                return(invisible(NULL))
            }

            nm <- trimws(input$pb_data_name)

            if (!nzchar(nm)) {
                nm <- tools::file_path_sans_ext(basename(file$name))
            }

            store <- dataset_store()

            # Ensure a unique name so existing datasets are never overwritten.
            base <- nm
            i <- 1L

            while (nm %in% names(store)) {
                i <- i + 1L
                nm <- paste0(base, " (", i, ")")
            }

            store[[nm]] <- df
            dataset_store(store)
            updateTextInput(session, "pb_data_name", value = "")

            showNotification(
                sprintf(
                    "Added dataset '%s' (%d rows x %d cols).",
                    nm, nrow(df), ncol(df)
                ),
                type = "message"
            )
        })

        observeEvent(input$pb_orientation, {
            if (identical(input$pb_orientation, "landscape")) {
                shinyjs::removeClass(ns("pb_canvas"), "a4-portrait")
                shinyjs::addClass(ns("pb_canvas"), "a4-landscape")
            } else {
                shinyjs::removeClass(ns("pb_canvas"), "a4-landscape")
                shinyjs::addClass(ns("pb_canvas"), "a4-portrait")
            }
        })

        observeEvent(input$pb_add, {
            showModal(modalDialog(
                title = "Add a Plot",
                selectInput(ns("pb_new_module"), "Plot type:",
                    choices = module_choices, selectize = FALSE
                ),
                selectInput(ns("pb_new_dataset"), "Dataset:",
                    choices = names(dataset_store()), selectize = FALSE
                ),
                footer = tagList(
                    modalButton("Cancel"),
                    actionButton(ns("pb_add_confirm"), "Add",
                        class = "btn-primary"
                    )
                ),
                easyClose = TRUE
            ))
        })

        # Suggest the module's preferred dataset when the plot type changes.
        observeEvent(input$pb_new_module, {
            mod <- module_registry[[input$pb_new_module]]
            if (!is.null(mod) && mod$dataset %in% names(dataset_store())) {
                updateSelectInput(session, "pb_new_dataset",
                    selected = mod$dataset
                )
            }
        })

        # --- Create a panel
        observeEvent(input$pb_add_confirm, {
            datasets <- dataset_store()
            mod_key <- input$pb_new_module
            ds_name <- input$pb_new_dataset
            mod <- module_registry[[mod_key]]
            req(mod, ds_name %in% names(datasets))
            removeModal()

            rv$counter <- rv$counter + 1L
            pid <- paste0("panel", rv$counter)
            data_snapshot <- datasets[[ds_name]]
            panel_data[[pid]] <- data_snapshot

            label <- sprintf("%s #%d (%s)", mod$label, rv$counter, ds_name)
            # Only apply built-in defaults when the dataset they target is chosen.
            defaults <- if (identical(ds_name, mod$dataset)) mod$defaults else list()

            # Hide empty-state hints once the first panel is added.
            shinyjs::hide(ns("pb_canvas_empty"))
            shinyjs::hide(ns("pb_controls_empty"))
            shinyjs::hide(ns("pb_table_empty"))

            # 1) Plot card on the canvas (draggable via the hover toolbar's grip,
            #    resizable from the corner). The toolbar only appears on hover and
            #    is excluded from the SVG export, so the card stays free of chrome.
            card <- div(
                id = ns(paste0(pid, "_card")),
                class = "viz-panel-card",
                # Pin every new card to the top-left of the canvas. `position` is
                # forced inline (with !important) so nothing in the cascade or any
                # jQuery UI wrapper can drop the card back into normal document flow
                # where the cards would stack vertically down the page.
                style = "position:absolute !important; top:20px; left:20px;",
                div(
                    class = "viz-panel-toolbar",
                    span(
                        class = "viz-panel-drag", title = label,
                        icon("grip-vertical")
                    ),
                    tags$button(
                        id = ns(paste0(pid, "_remove")),
                        class = "viz-panel-remove action-button",
                        type = "button", title = "Remove plot",
                        icon("times")
                    )
                ),
                div(class = "viz-panel-body", mod$output_ui(ns(pid), resizable = FALSE))
            )
            insertUI(
                selector = paste0("#", ns("pb_canvas")), where = "beforeEnd",
                ui = shinyjqui::jqui_draggable(
                    shinyjqui::jqui_resizable(card),
                    options = list(handle = ".viz-panel-drag", containment = "parent")
                ),
                immediate = TRUE
            )

            # 2) Controls for this panel (hidden until selected in the dropdown).
            insertUI(
                selector = paste0("#", ns("pb_controls_container")), where = "beforeEnd",
                ui = div(
                    id = ns(paste0(pid, "_controls")),
                    class = "pb-controls-pane",
                    style = "display:none;",
                    mod$inputs_ui(ns(pid), data_snapshot, defaults = defaults)
                ),
                immediate = TRUE
            )

            # 3) Data-filter table for this panel (hidden until selected).
            insertUI(
                selector = paste0("#", ns("pb_table_container")), where = "beforeEnd",
                ui = div(
                    id = ns(paste0(pid, "_table")),
                    class = "pb-table-pane",
                    style = "display:none;",
                    dataFilterUI(ns(paste0(pid, "_filter")))
                ),
                immediate = TRUE
            )

            # 4) Wire up the servers. The dataset is fixed; the filter feeds the
            #    plot. Reads short-circuit once the panel's data is removed. The
            #    sub-module servers are called with bare ids so they namespace
            #    themselves within this module's namespace (see the wrapper pattern).
            panel_reactive <- reactive({
                d <- panel_data[[pid]]
                req(d)
                d
            })

            filtered <- dataFilterServer(paste0(pid, "_filter"), panel_reactive)

            # The module server returns a reactive yielding its interactive source
            # (plot + data + inputs); keep it so we can bundle every panel together.
            panel_sources[[pid]] <- mod$server_fn(pid, data = filtered)

            # 5) Per-panel remove handler (tracked so it can be destroyed on remove).
            panel_observers[[pid]] <- observeEvent(
                input[[paste0(pid, "_remove")]],
                {
                    remove_panel(pid)
                },
                ignoreInit = TRUE
            )

            # 6) Register the panel and focus it in both dropdowns.
            rv$labels[[pid]] <- label
            rv$panel_ids <- c(rv$panel_ids, pid)
            refresh_selectors(selected = pid)
        })

        remove_panel <- function(pid) {
            if (!pid %in% rv$panel_ids) {
                return(invisible(NULL))
            }
            # Destroy the jQuery UI interactions before pulling the DOM nodes so the
            # remaining cards are never disturbed by orphaned handlers.
            shinyjqui::jqui_draggable(paste0("#", ns(paste0(pid, "_card"))),
                operation = "destroy"
            )
            shinyjqui::jqui_resizable(paste0("#", ns(paste0(pid, "_card"))),
                operation = "destroy"
            )
            removeUI(selector = paste0("#", ns(paste0(pid, "_card"))), immediate = TRUE)
            removeUI(selector = paste0("#", ns(paste0(pid, "_controls"))), immediate = TRUE)
            removeUI(selector = paste0("#", ns(paste0(pid, "_table"))), immediate = TRUE)

            # Tear down the panel's bookkeeping so its controls/table cannot linger.
            if (!is.null(panel_observers[[pid]])) {
                panel_observers[[pid]]$destroy()
                rm(list = pid, envir = panel_observers)
            }
            panel_data[[pid]] <- NULL
            panel_sources[[pid]] <- NULL
            rv$labels[[pid]] <- NULL
            rv$panel_ids <- setdiff(rv$panel_ids, pid)

            if (length(rv$panel_ids) == 0L) {
                shinyjs::show(ns("pb_canvas_empty"))
                shinyjs::show(ns("pb_controls_empty"))
                shinyjs::show(ns("pb_table_empty"))
            }
            refresh_selectors()
        }

        # Keep both selectors in sync with the active panels
        refresh_selectors <- function(selected = NULL) {
            choices <- setNames(
                rv$panel_ids,
                vapply(rv$panel_ids, function(p) rv$labels[[p]], character(1))
            )
            pick <- function(current) {
                if (!is.null(selected)) {
                    return(selected)
                }
                if (!is.null(current) && current %in% rv$panel_ids) {
                    return(current)
                }
                if (length(rv$panel_ids)) rv$panel_ids[[1]] else NULL
            }
            updateSelectInput(session, "pb_controls_select",
                choices = choices, selected = pick(isolate(input$pb_controls_select))
            )
            updateSelectInput(session, "pb_table_select",
                choices = choices, selected = pick(isolate(input$pb_table_select))
            )
        }

        # Swap visible controls
        observeEvent(input$pb_controls_select,
            {
                sel <- input$pb_controls_select
                for (p in rv$panel_ids) {
                    if (identical(p, sel)) {
                        shinyjs::show(ns(paste0(p, "_controls")))
                    } else {
                        shinyjs::hide(ns(paste0(p, "_controls")))
                    }
                }
            },
            ignoreNULL = FALSE
        )

        # Swap visible table
        observeEvent(input$pb_table_select,
            {
                sel <- input$pb_table_select
                for (p in rv$panel_ids) {
                    if (identical(p, sel)) {
                        shinyjs::show(ns(paste0(p, "_table")))
                    } else {
                        shinyjs::hide(ns(paste0(p, "_table")))
                    }
                }
            },
            ignoreNULL = FALSE
        )

        # Summary download
        # Bundle every panel's interactive summary (plot + data + inputs) into a
        # single .zip. We collect each panel's summary reactive (returned by its
        # module server) and hand a named list of summaries to
        # create_source_download_handler, which writes one set of files per panel.
        output$download.source <- create_source_download_handler(
            data_list = reactive({
                ids <- rv$panel_ids

                validate(need(
                    length(ids) > 0,
                    "Add at least one plot before downloading."
                ))

                sources <- lapply(ids, function(p) {
                    sr <- panel_sources[[p]]
                    if (is.null(sr)) {
                        return(NULL)
                    }
                    # Skip (rather than abort the whole download) if a single
                    # panel's source cannot be built.
                    tryCatch(sr(), error = function(e) {
                        warning(
                            "Could not build source for panel '", p, "': ",
                            conditionMessage(e)
                        )
                        NULL
                    })
                })

                names(sources) <- vapply(
                    ids,
                    function(p) rv$labels[[p]], character(1)
                )

                sources[!vapply(sources, is.null, logical(1))]
            }),
            filename_base = "panel_source"
        )

        invisible(NULL)
    })
}
