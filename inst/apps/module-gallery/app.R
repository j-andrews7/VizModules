library(shiny)
library(vizModules)

# Sample data for modules
mtcars <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear),
    vs = factor(vs)
)

iris$Group <- c(rep(c("A", "B"), 50), rep(c("C", "D"), 25))

iris_summary <- {
    iris_summary <- as.data.frame(table(iris$Species))
    names(iris_summary) <- c("Species", "Count")
    iris_summary
}

volcano_data <- {
    data(airway_deseq2, package = "vizModules", envir = environment())
    airway_deseq2
}

ui <- navbarPage(
    "vizModules Gallery",
    tabPanel(
        "AreaPlot",
        sidebarLayout(
            sidebarPanel(AreaPlotInputsUI("area", iris, title = h3("AreaPlot Settings"))),
            mainPanel(AreaPlotOutputUI("area"))
        )
    ),
    tabPanel(
        "BarPlot",
        sidebarLayout(
            sidebarPanel(BarPlotInputsUI("bar", mtcars, title = h3("BarPlot Settings"))),
            mainPanel(BarPlotOutputUI("bar"))
        )
    ),
    tabPanel(
        "BoxPlot",
        sidebarLayout(
            sidebarPanel(BoxPlotInputsUI("box", mtcars, title = h3("BoxPlot Settings"))),
            mainPanel(BoxPlotOutputUI("box"))
        )
    ),
    tabPanel(
        "LinePlot",
        sidebarLayout(
            sidebarPanel(linePlotInputsUI("line", mtcars, title = h3("LinePlot Settings"))),
            mainPanel(linePlotOutputUI("line"))
        )
    ),
    tabPanel(
        "PiePlot",
        sidebarLayout(
            sidebarPanel(piePlotInputsUI("pie", iris_summary, title = h3("PiePlot Settings"))),
            mainPanel(piePlotOutputUI("pie"))
        )
    ),
    tabPanel(
        "ScatterPlot",
        sidebarLayout(
            sidebarPanel(scatterPlotInputsUI("scatter", mtcars, title = h3("ScatterPlot Settings"))),
            mainPanel(scatterPlotOutputUI("scatter"))
        )
    ),
    tabPanel(
        "VolcanoPlot",
        sidebarLayout(
            sidebarPanel(volcanoPlotInputsUI("volcano", volcano_data, title = h3("VolcanoPlot Settings"))),
            mainPanel(volcanoPlotOutputUI("volcano"))
        )
    )
)

server <- function(input, output, session) {
    AreaPlotServer("area", data = reactive(iris))
    BarPlotServer("bar", data = reactive(mtcars))
    BoxPlotServer("box", data = reactive(mtcars))
    linePlotServer("line", data = reactive(mtcars))
    piePlotServer("pie", data = reactive(iris_summary))
    scatterPlotServer("scatter", data = reactive(mtcars))
    volcanoPlotServer("volcano", data = reactive(volcano_data))
}

shinyApp(ui, server)
