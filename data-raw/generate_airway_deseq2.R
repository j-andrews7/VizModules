library(airway)
library(DESeq2)

data("airway")
airway$dex <- relevel(airway$dex, ref = "untrt")

dds <- DESeqDataSet(airway, design = ~dex)
dds <- DESeq(dds)
res <- results(dds, contrast = c("dex", "trt", "untrt"))

airway_deseq2 <- as.data.frame(res)
airway_deseq2$ensembl <- row.names(airway_deseq2)
airway_deseq2$symbol <- rowData(dds)$symbol

save(airway_deseq2, file = "data/airway_deseq2.rda", compress = "xz")
