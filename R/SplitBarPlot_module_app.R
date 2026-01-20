SplitBarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular SplitBarPlots"),
        sidebarLayout(
            sidebarPanel(
                lapply(names(data_list), function(name) {
                    tagList(
                        SplitBarPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(SplitBarPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        lapply(names(data_list), function(name) {
            SplitBarPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
