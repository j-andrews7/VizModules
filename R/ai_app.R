#' Create an example Modular boxAI Shiny Application
#'
#' This function generates a Shiny application with modular boxAI components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames.
#' @param defaults_list Optional named list of defaults per data set.
#'
#' @return A Shiny app object.
#'
#' @importFrom shiny shinyApp fluidPage titlePanel sidebarLayout sidebarPanel
#'   mainPanel h3 h4 br tags
#' @importFrom shinyjs useShinyjs
#'
#' @export
createBoxAIApp <- function(data_list, defaults_list = NULL) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) stopifnot(is.data.frame(data)))

    ui <- fluidPage(
        useShinyjs(),
        tags$head(
            tags$style(HTML("
                .btn-lg { margin: 5px 0; }
                .shiny-input-container { margin-bottom: 10px; }
            "))
        ),
        titlePanel("Enhanced Modular boxAI"),
        sidebarLayout(
            sidebarPanel(
                width = 3,
                lapply(names(data_list), function(name) {
                    tagList(
                        boxAIInputsUI(
                            name,
                            data_list[[name]],
                            title   = h3(strong(name), style = "color: #2c3e50;"),
                            columns = 1
                        ),
                        hr(style = "border-color: #ecf0f1;")
                    )
                })
            ),
            mainPanel(
                width = 9,
                lapply(names(data_list), function(name) {
                    tagList(
                        h4(strong(name), style = "color: #34495e; margin-bottom: 10px;"),
                        boxAIOutputUI(name),
                        br()
                    )
                })
            )
        )
    )

    server <- function(input, output, session) {
        lapply(names(data_list), function(name) {
            boxAIServer(
                name,
                data = reactive(data_list[[name]]),
                defaults = if (is.null(defaults_list)) NULL else defaults_list[[name]]
            )
        })
    }

    shinyApp(ui, server)
}
