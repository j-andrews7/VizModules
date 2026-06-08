# ui <- fluidPage(
#     title = "VizModules Panel Builder",
#     shinyjs::useShinyjs(),
#     tags$head(tags$style(app_css), tags$script(app_js)),
#     titlePanel("VizModules Panel Builder"),
#     sidebarLayout(
#         sidebarPanel(
#             width = 4,
#             actionButton("pb_add", "Add Plot",
#                 icon = icon("plus"), class = "btn-primary"
#             ),
#             helpText(
#                 "Add VizModules plots to the canvas, then drag them by their",
#                 "title bar and resize from the bottom-right corner."
#             ),
#             hr(),
#             h4("Load Data"),
#             helpText(
#                 "Upload a CSV, TSV or RDS file to make it available as a",
#                 "dataset when adding plots."
#             ),
#             textInput("pb_data_name", "Dataset name (optional):",
#                 placeholder = "Defaults to the file name"
#             ),
#             fileInput("pb_data_file", "Data file:",
#                 accept = c(".csv", ".tsv", ".txt", ".rds", ".RDS")
#             ),
#             actionButton("pb_data_add", "Add dataset", icon = icon("upload")),
#             hr(),
#             h4("Canvas"),
#             selectInput("pb_orientation", "Page size:",
#                 choices = c("A4 portrait" = "portrait",
#                             "A4 landscape" = "landscape")
#             ),
#             tags$button("Download Panel (SVG)",
#                 id = "pb_download", type = "button",
#                 class = "btn btn-success", onclick = "pbDownloadSVG()"
#             ),
#             hr(),
#             h4("Plot Controls"),
#             selectInput("pb_controls_select", "Show controls for:",
#                 choices = character(0)
#             ),
#             div(
#                 id = "pb_controls_container",
#                 div(
#                     class = "pb-empty-hint", id = "pb_controls_empty",
#                     "Add a plot to configure its controls here."
#                 )
#             )
#         ),
#         mainPanel(
#             width = 8,
#             div(
#                 id = "pb_canvas_scroll",
#                 div(
#                     id = "pb_canvas", class = "a4-portrait",
#                     div(class = "pb-empty-hint", id = "pb_canvas_empty",
#                         "No plots yet. Click \"Add Plot\" to begin.")
#                 )
#             ),
#             hr(),
#             h4("Data Table"),
#             p("Filtering a plot's table subsets only that plot's data.",
#                 style = "color: grey; font-size: 12px;"
#             ),
#             selectInput("pb_table_select", "Show table for:",
#                 choices = character(0)
#             ),
#             div(
#                 id = "pb_table_container",
#                 div(
#                     class = "pb-empty-hint", id = "pb_table_empty",
#                     "Add a plot to view and filter its data here."
#                 )
#             )
#         )
#     )
# )