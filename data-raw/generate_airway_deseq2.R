library(airway)
library(DESeq2)
library(edgeR)
library(limma)

data("airway")
airway$dex <- relevel(airway$dex, ref = "untrt")

# DESeq2 analysis
dds <- DESeqDataSet(airway, design = ~dex)
dds <- DESeq(dds)
res <- results(dds, contrast = c("dex", "trt", "untrt"))

airway_deseq2 <- as.data.frame(res)
airway_deseq2$ensembl <- row.names(airway_deseq2)
airway_deseq2$symbol <- rowData(dds)$symbol

save(airway_deseq2, file = "data/airway_deseq2.rda", compress = "xz")

# edgeR analysis
group <- airway$dex
dge <- DGEList(counts = assay(airway), group = group)
keep <- filterByExpr(dge, group = group)
dge <- dge[keep, , keep.lib.sizes = FALSE]
dge <- calcNormFactors(dge)

design <- model.matrix(~group)
dge <- estimateDisp(dge, design)
fit_ql <- glmQLFit(dge, design)
qlf <- glmQLFTest(fit_ql, coef = 2)

airway_edger <- topTags(qlf, n = Inf)$table
airway_edger$ensembl <- row.names(airway_edger)
airway_edger$symbol <- rowData(airway)$symbol[match(airway_edger$ensembl, row.names(airway))]

save(airway_edger, file = "data/airway_edger.rda", compress = "xz")

# limma-voom analysis
v <- voom(dge, design, plot = FALSE)
fit <- lmFit(v, design)
fit <- eBayes(fit, trend = TRUE)
airway_voom <- topTable(fit, coef = 2, number = Inf)
airway_voom$ensembl <- row.names(airway_voom)
airway_voom$symbol <- rowData(airway)$symbol[match(airway_voom$ensembl, row.names(airway))]

save(airway_voom, file = "data/airway_voom.rda", compress = "xz")
