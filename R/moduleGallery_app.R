#' Launch the VizModules module gallery
#'
#' Builds the **VizModules Gallery**: one tab per plot module, each opening on a
#' bundled example dataset with the module's main features already switched on
#' (significance brackets, highlighted and labelled points, fit lines, reference
#' lines, annotation tracks and splits, and so on), plus a **Figure Builder** tab
#' for composing several modules into one multi-panel figure and exporting it as
#' an editable SVG.
#'
#' Every tab carries the module's full set of controls and a filterable data
#' table beneath the plot, so the gallery doubles as a tour of what each module
#' can do. The example settings each tab opens on are the same ones the
#' module's own `*App()` function (e.g. [plotthis_BoxPlotApp()]) and the Figure
#' Builder start from, so any of them can be reproduced by passing the same
#' `defaults` to the module in your own app.
#'
#' The **Heatmap** tab needs the Bioconductor packages \pkg{ComplexHeatmap},
#' \pkg{InteractiveComplexHeatmap} and \pkg{circlize}, and is left out when
#' they are not installed.
#'
#' The Figure Builder tab embeds [figureBuilderUI()] / [figureBuilderServer()]
#' on the bundled example datasets. To run a standalone Figure Builder, or one
#' on your own datasets or modules, use [figureBuilderApp()].
#'
#' @param title A character string used as the navbar title and page title.
#' @param return_components Logical. When `FALSE` (the default) a
#'   [shiny::shinyApp()] object is returned. When `TRUE` a named list with `ui`
#'   and `server` elements is returned instead, which is convenient for
#'   deployment scripts that need an explicit `shinyApp(ui, server)` call.
#'
#' @return Either a [shiny::shinyApp()] object, or (when
#'   `return_components = TRUE`) a list with elements `ui` and `server`.
#'
#' @import shiny
#'
#' @export
#' @author Jared Andrews
#' @seealso [figureBuilderApp()], [createModuleApp()]
#' @examples
#' library(VizModules)
#' app <- moduleGalleryApp()
#' if (interactive()) runApp(app)
#'
#' # The UI and server separately, e.g. for a deployment app.R:
#' parts <- moduleGalleryApp(return_components = TRUE)
#' if (interactive()) shinyApp(parts$ui, parts$server)
moduleGalleryApp <- function(title = "VizModules Gallery", return_components = FALSE) {
    showcase <- .module_showcase()
    datasets <- .example_datasets()
    info <- .gallery_package_info()

    module_tabs <- lapply(names(showcase), function(id) .gallery_module_tab(id, showcase[[id]]))

    ui <- do.call(navbarPage, c(
        list(
            title = title,
            id = "active_tab",
            position = "static-top",
            header = .gallery_header(info)
        ),
        list(.gallery_about_tab(info)),
        module_tabs,
        list(tabPanel("Figure Builder", value = "figure_builder", figureBuilderUI("figure_builder")))
    ))

    server <- function(input, output, session) {
        lapply(names(showcase), function(id) {
            mod <- showcase[[id]]
            entry <- datasets[[mod$dataset]]

            # A multi-table entry (the heatmap's matrix plus its per-sample
            # metadata) has only its primary table filtered and shown; the rest
            # rides along to the module untouched.
            parts <- .app_entry_parts(entry, mod$primary.table)
            filtered_data <- dataFilterServer(paste0(id, "_filter"), reactive(parts$primary))
            server_data <- if (is.data.frame(entry)) {
                filtered_data
            } else {
                reactive(parts$rebuild(filtered_data()))
            }

            # Built once, on the full dataset, with the tab's showcase defaults.
            output[[paste0(id, "_inputs_ui")]] <- renderUI({
                mod$inputs_ui(
                    id, entry,
                    defaults = mod$defaults,
                    title = h3(paste(mod$tab_label, "Settings"))
                )
            })

            # The same defaults the inputs were built with, so Reset returns to them.
            mod$server_fn(id, data = server_data, defaults = mod$defaults)
        })

        figureBuilderServer("figure_builder")
    }

    if (isTRUE(return_components)) {
        return(list(ui = ui, server = server))
    }

    shinyApp(ui, server)
}


#' One module's gallery tab: its controls beside the plot and data table
#'
#' @param id The module id, used as the module's namespace.
#' @param mod The module's [.module_showcase()] entry.
#'
#' @return A [shiny::tabPanel()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gallery_module_tab
#' @keywords internal
.gallery_module_tab <- function(id, mod) {
    tabPanel(
        mod$tab_label,
        value = id,
        sidebarLayout(
            sidebarPanel(
                width = 4,
                uiOutput(paste0(id, "_inputs_ui"))
            ),
            mainPanel(
                width = 8,
                mod$output_ui(id),
                hr(),
                h4("Data Table"),
                p("Filtering the data table will update the plot.",
                    style = "color: grey; font-size: 12px;"
                ),
                dataFilterUI(paste0(id, "_filter"))
            )
        )
    )
}


#' Package details shown on the gallery's About tab and navbar
#'
#' @return A list with `title`, `description`, `authors`, `version`,
#'   `repo_url`, `docs_url` and `cran_url`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gallery_package_info
#' @keywords internal
.gallery_package_info <- function() {
    desc <- utils::packageDescription("VizModules")
    field <- function(name) {
        value <- desc[[name]]
        if (is.null(value) || is.na(value) || !nzchar(trimws(value))) NA_character_ else value
    }

    authors <- tryCatch({
        people <- eval(str2expression(field("Authors@R")))
        paste(
            vapply(seq_along(people), function(i) {
                trimws(paste(c(people[[i]]$given, people[[i]]$family), collapse = " "))
            }, character(1)),
            collapse = ", "
        )
    }, error = function(e) NA_character_)
    if (is.na(authors) || !nzchar(trimws(authors))) {
        authors <- field("Author")
    }
    if (is.na(authors)) {
        authors <- "Unavailable"
    }

    urls <- trimws(strsplit(if (is.na(field("URL"))) "" else field("URL"), ",")[[1]])
    docs_url <- urls[grepl("github\\.io|pkgdown", urls)][1]
    repo_url <- urls[grepl("github\\.com", urls)][1]

    list(
        title = field("Title"),
        description = field("Description"),
        authors = gsub("[[:space:]]+", " ", trimws(authors)),
        version = as.character(utils::packageVersion("VizModules")),
        docs_url = if (is.na(docs_url)) "https://j-andrews7.github.io/VizModules/" else docs_url,
        repo_url = if (is.na(repo_url)) "https://github.com/j-andrews7/VizModules" else repo_url,
        cran_url = "https://cran.r-project.org/package=VizModules"
    )
}


#' The gallery's About tab
#'
#' @param info The list from [.gallery_package_info()].
#'
#' @return A [shiny::tabPanel()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gallery_about_tab
#' @keywords internal
.gallery_about_tab <- function(info) {
    link <- function(url) tags$a(href = url, target = "_blank", rel = "noopener noreferrer", url)

    tabPanel(
        "About",
        value = "about",
        fluidPage(
            fluidRow(
                column(
                    width = 9,
                    h2("About VizModules"),
                    p(info$title),
                    p(info$description),
                    tags$p(tags$strong("Authors: "), info$authors),
                    p(
                        "This gallery showcases VizModules' interactive Shiny modules on",
                        "bundled example datasets. Each tab opens with the module's main",
                        "features switched on, and every control can be changed from its",
                        "sidebar. The", tags$strong("Figure Builder"), "tab lets you compose",
                        "multiple modules into a free-form, multi-panel figure and export it",
                        "as a single editable SVG."
                    ),
                    tags$p(tags$strong("Repository: "), link(info$repo_url)),
                    tags$p(tags$strong("Documentation: "), link(info$docs_url)),
                    tags$p(tags$strong("CRAN package page: "), link(info$cran_url))
                )
            )
        )
    )
}


#' The gallery's navbar header: styling, and the repo/docs/version links
#'
#' @param info The list from [.gallery_package_info()].
#'
#' @return A [shiny::tagList()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_gallery_header
#' @keywords internal
.gallery_header <- function(info) {
    external <- function(url, ...) {
        tags$a(class = "repo-link", href = url, target = "_blank", rel = "noopener noreferrer", ...)
    }

    tagList(
        shinyjs::useShinyjs(),
        tags$head(
            tags$style(HTML(paste(
                ".navbar { margin-bottom: 0; }",
                # Keep all tabs on a single row by tightening link padding.
                ".navbar-nav > li > a {",
                "  padding-left: 9px;",
                "  padding-right: 9px;",
                "  font-size: 13px;",
                "}",
                ".navbar .navbar-collapse { flex-wrap: nowrap; }",
                ".navbar-nav { white-space: nowrap; }",
                ".navbar .navbar-right .navbar-version-label {",
                "  color: #9d9d9d;",
                "  display: block;",
                "  padding: 15px 9px;",
                "}",
                ".navbar .navbar-right a.repo-link {",
                "  display: flex;",
                "  align-items: center;",
                "  gap: 5px;",
                "  padding-left: 9px;",
                "  padding-right: 9px;",
                "}",
                sep = "\n"
            ))),
            # navbarPage() has no slot for right-aligned items, so they are
            # rendered hidden below and moved into the navbar once it exists.
            tags$script(HTML(paste(
                "(function() {",
                "  function addNavbarItems() {",
                "    var navContainer = document.querySelector('.navbar .navbar-collapse') ||",
                "      document.querySelector('.navbar .container-fluid') ||",
                "      document.querySelector('.navbar .container');",
                "    var extras = document.getElementById('navbar-right-items');",
                "    if (!navContainer || !extras || navContainer.querySelector('.navbar-right')) {",
                "      return;",
                "    }",
                "    var extraNav = extras.querySelector('ul.navbar-right');",
                "    if (extraNav) {",
                "      navContainer.appendChild(extraNav.cloneNode(true));",
                "    }",
                "  }",
                "  if (document.readyState === 'loading') {",
                "    document.addEventListener('DOMContentLoaded', addNavbarItems);",
                "  } else {",
                "    addNavbarItems();",
                "  }",
                "})();",
                sep = "\n"
            )))
        ),
        tags$div(
            id = "navbar-right-items",
            style = "display: none;",
            tags$ul(
                class = "nav navbar-nav navbar-right",
                tags$li(external(info$repo_url, icon("github"), "Repo")),
                tags$li(external(info$docs_url, "Docs")),
                tags$li(tags$span(class = "navbar-version-label", paste0("v", info$version)))
            )
        )
    )
}
