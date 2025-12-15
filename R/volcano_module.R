shh <- suppressPackageStartupMessages
shh(library("airway"))
shh(library("magrittr"))
shh(library("DESeq2"))
shh(library("PCAtools"))

data("airway")
airway$dex <- relevel(airway$dex, ref = "untrt")
dds <- DESeqDataSet(airway, design = ~ dex)
dds <- DESeq(dds)
vst <- assay(vst(dds))

deseq.res1 <- as.data.frame(results(dds, contrast = c("dex", "trt", "untrt")))

# Create DE gene categories for up/downregulated
deseq.res1$group <- "Insignificant"
deseq.res1$group[deseq.res1$padj < 0.05 & deseq.res1$log2FoldChange > log2(1.5)] <- "Upregulated"
deseq.res1$group[deseq.res1$padj < 0.05 & deseq.res1$log2FoldChange < -log2(1.5)] <- "Downregulated"
deseq.res1$symbol <- rowData(dds)$symbol

# dds <- DESeqDataSet(airway, design = ~ cell)
# dds <- DESeq(dds)
# deseq.res2 <- results(dds, contrast = c("cell", "N080611", "N052611"))
# deseq.res3 <- results(dds, contrast = c("cell", "N61311", "N080611"))
# deseq.res4 <- results(dds, contrast = c("cell", "N080611", "N61311"))
# res <- list("trt v untrt" = as.data.frame(deseq.res1), 
#             "N080611vN052611" = as.data.frame(deseq.res2), 
#             "N61311vN080611" = as.data.frame(deseq.res3), 
#             "N080611vN61311" = as.data.frame(deseq.res4))

volcanoPlotOutputUI <- function(id) {
    scatterPlotOutputUI(id)
}

volcanoPlotInputsUI <- function(id, data, defaults = NULL, title = "Volcano Settings", columns = 2) {
    # Add a few extra inputs to control the DE thresholds
    ns <- NS(id)

    extras <- tagList(
        numericInput(ns("sig.thresh"), "Significance Threshold:",
            value = ifelse("sig.thresh" %in% names(defaults),
                ifelse(is.numeric(defaults[["sig.thresh"]]), defaults[["sig.thresh"]], 0.05),
                0.05
            ),
            max = 1,
            min = 0,
            step = 0.05
        ),
        numericInput(ns("fc.thresh"), "LFC Threshold:",
            value = ifelse("fc.thresh" %in% names(defaults),
                ifelse(is.numeric(defaults[["fc.thresh"]]), defaults[["fc.thresh"]], 0),
                0
            ),
            min = 0,
            step = 0.25
        )
    )

    outs <- scatterPlotInputsUI(id = id, data = data, defaults = defaults, title = h3(title), columns = columns)

    tagList(extras, outs)
}

volcanoPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = c("Trajectory", "Facets")) {
    moduleServer(id, function(input, output, session) {
 
        observeEvent(input$fc.thresh, {
            dat <- data()
            dat$group <- "Insignificant"
            dat$group[dat$padj < input$sig.thresh & dat$log2FoldChange > log2(input$fc.thresh)] <- "Upregulated"
            dat$group[dat$padj < input$sig.thresh & dat$log2FoldChange < -log2(input$fc.thresh)] <- "Downregulated"
            data(dat)
        })
        scatterPlotServer(id = id, data = data, hide.inputs = hide.inputs, hide.tabs = hide.tabs)
    })
}

createVolcanoPlotApp <- function(df) {
    # Validate input
    stopifnot(is.data.frame(df))

    # UI definition
    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular volcanoPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                volcanoPlotInputsUI("volc", df)
            ),
            mainPanel(
                # Add the module output UI for each data frame
                volcanoPlotOutputUI("volc")
            )
        )
    )

    # Server function
    server <- function(input, output, session) {
        # Add the module server for each data frame
        volcanoPlotServer("volc", data = reactive(df))
    }

    # Return the Shiny app
    shinyApp(ui, server)
}