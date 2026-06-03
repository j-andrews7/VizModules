library(VizModules)

# DotPlot needs one summary row per cell_type x gene x condition
dotplot_data <- unique(
    example_rnaseq[, c("cell_type", "gene", "condition", "avg_expression", "neg_log10_pval")]
)

# BarPlot: mean expression per gene per cell type, to show which genes dominate each cell type
barplot_data <- do.call(rbind, lapply(
    split(example_rnaseq, list(example_rnaseq$cell_type, example_rnaseq$condition)),
    function(df) {
        gene_means <- tapply(df$log2_cpm, df$gene, mean)
        data.frame(
            cell_type = df$cell_type[1],
            condition = df$condition[1],
            gene = names(gene_means),
            mean_log2_cpm = as.numeric(gene_means),
            stringsAsFactors = FALSE
        )
    }
))
barplot_data$cell_type <- factor(barplot_data$cell_type, levels = levels(example_rnaseq$cell_type))
barplot_data$gene <- factor(barplot_data$gene, levels = levels(example_rnaseq$gene))
barplot_data$condition <- factor(barplot_data$condition, levels = levels(example_rnaseq$condition))

question_banner <- function(question) {
    wellPanel(
        style = "background:#f0f7ff; border-left:4px solid #2c7bb6; padding:10px 14px; margin-bottom:12px;",
        tags$p(
            tags$strong("\U0001f9ea "), question,
            style = "margin:0; font-size:14px;"
        )
    )
}

modules <- list(
    list(
        id = "dotplot",
        label = "Marker Dot Plot",
        data = dotplot_data,
        inputs_ui = plotthis_DotPlotInputsUI,
        output_ui = plotthis_DotPlotOutputUI,
        server_fn = plotthis_DotPlotServer,
        question = "Which genes are statistically significant markers for each immune cell type?",
        defaults = list(
            "x.data" = "gene",
            "y.data" = "cell_type",
            "size.by" = "neg_log10_pval",
            "fill.by" = "avg_expression",
            "split.by" = "condition",
            "palette" = "RdBu"
        )
    ),
    list(
        id = "yplot",
        label = "Disease Effect on Expression",
        data = example_rnaseq,
        inputs_ui = dittoViz_yPlotInputsUI,
        output_ui = dittoViz_yPlotOutputUI,
        server_fn = dittoViz_yPlotServer,
        question = "Does disease upregulate canonical marker expression, and in which cell types is this strongest?",
        defaults = list(
            "var" = "log2_cpm",
            "group.by" = "cell_type",
            "color.by" = "condition",
            "split.by" = "gene",
            "plots" = c("boxplot", "jitter"),
            "split.adjust" = "free",
            "axis.tickangle.x" = 60,
            "subplot.margin" = 0.18
        )
    ),
    list(
        id = "barplot",
        label = "Marker Gene Dominance",
        data = barplot_data,
        inputs_ui = plotthis_BarPlotInputsUI,
        output_ui = plotthis_BarPlotOutputUI,
        server_fn = plotthis_BarPlotServer,
        question = "Which marker genes dominate expression in each cell type, and does disease change this?",
        defaults = list(
            "x.data" = "cell_type",
            "y.data" = "mean_log2_cpm",
            "group.by" = "gene",
            "fill.by" = "gene",
            "facet.by" = "gene",
            "palette" = "Set2",
            "split.adjust" = "free_x"
        )
    )
)

build_tab <- function(mod) {
    tabPanel(
        mod$label,
        value = mod$id,
        sidebarLayout(
            sidebarPanel(
                width = 4,
                question_banner(mod$question),
                uiOutput(paste0(mod$id, "_inputs_ui"))
            ),
            mainPanel(
                width = 8,
                mod$output_ui(mod$id),
                hr(),
                h4("Data Table"),
                p("Filter the table below to subset the plot.", style = "color:grey; font-size:12px;"),
                dataFilterUI(paste0(mod$id, "_filter"))
            )
        )
    )
}

about_tab <- tabPanel(
    "About",
    value = "about",
    fluidPage(fluidRow(column(
        width = 8,
        h2("Immune RNA-seq Showcase"),
        p(
            "Simulated pseudo-bulk RNA-seq data from six human immune cell types,",
            " demonstrating three VizModules plot types.",
            " Each tab is built around a biological question the plot is designed to answer."
        ),
        h3("Dataset"),
        tags$ul(
            tags$li(tags$strong("Cell types: "), "CD4 T, CD8 T, B Cell, NK Cell, Monocyte, pDC"),
            tags$li(
                tags$strong("Genes: "),
                "8 canonical immune markers — CD3D, CD8A, MS4A1, NKG7, LYZ, LILRA4, CD14, GNLY"
            ),
            tags$li(tags$strong("Conditions: "), "Healthy vs Disease (3 biological replicates each)"),
            tags$li(
                tags$strong("Expression: "),
                "Simulated log2 CPM. Canonical marker genes are strongly expressed in their cell type.",
                " Disease replicates carry a ~1.2 log2FC upregulation for those markers."
            ),
            tags$li(
                tags$strong("Significance: "),
                "Simulated -log10(p-value) per gene x cell type x condition.",
                " Canonical markers have high values (2.5-5); non-markers are near zero."
            )
        ),
        h3("Tabs"),
        tags$dl(
            tags$dt(tags$strong("1. Marker Dot Plot")),
            tags$dd(
                tags$em("Which genes are statistically significant markers for each immune cell type?"),
                tags$br(),
                "Dot size = -log10(p-value); fill = average expression.",
                " Larger, darker dots in a single row point to strong, specific markers."
            ),
            br(),
            tags$dt(tags$strong("2. Disease Effect on Expression")),
            tags$dd(
                tags$em("Does disease upregulate canonical marker expression, and in which cell types?"),
                tags$br(),
                "Boxplot + jitter faceted by gene, grouped by cell type, coloured by condition.",
                " Higher Disease boxes in a cell type's own marker gene panel indicate upregulation."
            ),
            br(),
            tags$dt(tags$strong("3. Marker Gene Dominance")),
            tags$dd(
                tags$em("Which marker genes dominate expression in each cell type, and does disease change this?"),
                tags$br(),
                "Grouped bar chart of mean log2 CPM per gene per cell type, split by condition.",
                " Tall bars in a single cell type confirm marker specificity."
            )
        )
    )))
)

ui <- navbarPage(
    title = "Immune RNA-seq Showcase",
    id = "nav",
    about_tab,
    build_tab(modules[[1]]),
    build_tab(modules[[2]]),
    build_tab(modules[[3]])
)

server <- function(input, output, session) {
    lapply(modules, function(mod) {
        filtered <- dataFilterServer(
            paste0(mod$id, "_filter"),
            reactive(mod$data)
        )
        output[[paste0(mod$id, "_inputs_ui")]] <- renderUI({
            mod$inputs_ui(mod$id, mod$data, defaults = mod$defaults)
        })
        mod$server_fn(mod$id, filtered)
    })
}

shinyApp(ui, server)
