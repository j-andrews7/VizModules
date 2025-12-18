createareaPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    # UI definition
    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular areaPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        areaPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(areaPlotOutputUI(name), br())
                })
            )
        )
    )

    # Server function
    server <- function(input, output, session) {

       # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            areaPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    # Return the Shiny app
    shinyApp(ui, server)
}