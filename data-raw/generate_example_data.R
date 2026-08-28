# Generate example datasets for module apps

set.seed(7)

# Sales data: 10 years × 12 months × 6 regions = 720 rows
years_sales <- rep(2015:2024, each = 72)
months <- rep(rep(month.abb, each = 6), 10)
regions <- rep(c("North", "South", "East", "West", "Central", "International"), 120)

example_sales <- data.frame(
    region = factor(regions),
    revenue = round(runif(720, 50, 200) + rep(seq(0, 350, length.out = 720)), 1),
    year = factor(years_sales),
    month = factor(months, levels = month.abb),
    units = sample(100:500, 720, replace = TRUE),
    sale_id = paste0("Sale_", seq_len(720)),
    product_line = sample(c("Gadgets", "Widgets", "Doohickeys"), 720, replace = TRUE)
)

# Population data: 50 years × 8 age groups = 400 rows
years <- rep(1975:2024, each = 8)
age_groups <- rep(c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+"), 50)

example_population <- data.frame(
    year = factor(years),
    age_group = factor(
        age_groups,
        levels = c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+")
    ),
    count = round(rnorm(400, mean = 5000, sd = 800) + rep(seq(0, 3900, length.out = 400))),
    record_id = paste0("Record_", seq_len(400))
)

# iris with an added Group column for multi-group examples
example_iris <- iris
example_iris$Group <- c(rep(c("A", "B"), 50), rep(c("C", "D"), 25))

# mtcars with key columns as factors
example_mtcars <- transform(
    mtcars,
    cyl  = factor(cyl),
    gear = factor(gear),
    vs   = factor(vs)
)

# School-earnings data for dumbbell plots
example_school_earnings <- data.frame(
    School = c("MIT", "Stanford", "Harvard", "Yale", "Princeton", "Columbia"),
    Women = c(94, 96, 112, 188, 91, 129),
    Men = c(52, 101, 165, 145, 148, 155),
    Group = c(
        "STEM-heavy", "STEM-heavy", "Liberal Arts", "Liberal Arts",
        "Liberal Arts", "STEM-heavy"
    )
)

# Multi-player skills data for radar plots
example_skills <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Agility"), 3),
    value    = c(8, 6, 7, 9, 7, 5, 9, 8, 6, 4, 7, 7, 5, 8, 9),
    player   = rep(c("Player A", "Player B", "Player C"), each = 5)
)


# For barplots and splitbar plots where a single value is what makes sense
example_bar <- data.frame(
    Group = c("A", "B", "C", "D", "E"),
    Type = c("Alpha", "Beta", "Alpha", "Gamma", "Beta"),
    Values = c(22, 35, 18, 41, 29),
    Numbers = c(15, -8, 22, -5, 12),
    Score = c(7, -3, 15, 8, -2)
)

# Grouping and fill data for demographics examples
example_demographics <- data.frame(
    department = factor(sample(c("HR", "Sales", "Engineering", "Marketing", "Finance", "Operations"),
        500,
        replace = TRUE
    )),
    job_level = factor(sample(c("Entry", "Mid", "Senior", "Lead"), 500, replace = TRUE)),
    gender = factor(sample(c("Male", "Female"), 500, replace = TRUE)),
    age = round(rnorm(500, mean = 35, sd = 12)),
    salary = round(rnorm(500, mean = 70000, sd = 15000)),
    satisfaction = round(runif(500, min = 1, max = 10), 1),
    performance = round(rnorm(500, mean = 6, sd = 1.5), 1),
    tenure_years = round(rnorm(500, mean = 5, sd = 3), 1),
    weekly_hours = round(rnorm(500, mean = 40, sd = 5), 1)
)

# Single-cell marker-gene expression data for dot plot examples.
# Mirrors a canonical single-cell "marker dot plot": each cell type expresses
# its own marker genes strongly (high average expression, high percent
# expressed) and the remaining genes weakly.
cell_types <- c("CD4 T", "CD8 T", "B", "NK", "Monocyte", "Dendritic", "Plasma", "Platelet")
marker_genes <- c(
    "CD3D", "IL7R", "CD8A", "GZMK", "MS4A1", "CD79A",
    "NKG7", "GNLY", "LYZ", "CD14", "FCER1A", "MZB1", "PPBP"
)
cell_type_markers <- list(
    "CD4 T"     = c("CD3D", "IL7R"),
    "CD8 T"     = c("CD3D", "CD8A", "GZMK"),
    "B"         = c("MS4A1", "CD79A"),
    "NK"        = c("NKG7", "GNLY"),
    "Monocyte"  = c("LYZ", "CD14"),
    "Dendritic" = c("LYZ", "FCER1A"),
    "Plasma"    = c("MZB1", "CD79A"),
    "Platelet"  = c("PPBP")
)
marker_grid <- expand.grid(
    cell_type = cell_types, gene = marker_genes,
    KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE
)
is_marker <- mapply(
    function(ct, g) g %in% cell_type_markers[[ct]],
    marker_grid$cell_type, marker_grid$gene
)
avg_expression <- numeric(nrow(marker_grid))
pct_expressed <- numeric(nrow(marker_grid))
avg_expression[is_marker]  <- round(runif(sum(is_marker), 1.8, 4.0), 2)
avg_expression[!is_marker] <- round(runif(sum(!is_marker), 0.0, 0.8), 2)
pct_expressed[is_marker]   <- round(runif(sum(is_marker), 55, 98), 1)
pct_expressed[!is_marker]  <- round(runif(sum(!is_marker), 0, 25), 1)

# RNA-seq long-format dataset for the RNA-seq showcase app.
# Mimics pseudo-bulk RNA-seq: 6 immune cell types x 8 canonical marker genes
# x 2 conditions x 3 replicates = 288 rows.
# Includes per-sample log2 CPM values (for yPlot/DensityPlot) and
# pre-summarised avg_expression + pct_expressed (for DotPlot).
rnaseq_cell_types <- factor(
    c("CD4 T", "CD8 T", "B Cell", "NK Cell", "Monocyte", "pDC"),
    levels = c("CD4 T", "CD8 T", "B Cell", "NK Cell", "Monocyte", "pDC")
)
rnaseq_genes <- factor(
    c("CD3D", "CD8A", "MS4A1", "NKG7", "LYZ", "LILRA4", "CD14", "GNLY"),
    levels = c("CD3D", "CD8A", "MS4A1", "NKG7", "LYZ", "LILRA4", "CD14", "GNLY")
)
rnaseq_conditions <- factor(c("Healthy", "Disease"), levels = c("Healthy", "Disease"))
rnaseq_replicates <- factor(paste0("Rep", 1:3))

# Define which genes are canonical markers for each cell type
rnaseq_cell_markers <- list(
    "CD4 T"    = c("CD3D"),
    "CD8 T"    = c("CD3D", "CD8A"),
    "B Cell"   = c("MS4A1"),
    "NK Cell"  = c("NKG7", "GNLY"),
    "Monocyte" = c("LYZ", "CD14"),
    "pDC"      = c("LILRA4")
)

rnaseq_grid <- expand.grid(
    cell_type = rnaseq_cell_types,
    gene      = rnaseq_genes,
    condition = rnaseq_conditions,
    replicate = rnaseq_replicates,
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
)

is_rnaseq_marker <- mapply(
    function(ct, g) g %in% rnaseq_cell_markers[[ct]],
    rnaseq_grid$cell_type, rnaseq_grid$gene
)

# Simulate log2 CPM: markers are high; Disease adds a ~1.2 log2FC boost
base_expr <- numeric(nrow(rnaseq_grid))
base_expr[is_rnaseq_marker]  <- round(runif(sum(is_rnaseq_marker), 4.0, 7.5), 2)
base_expr[!is_rnaseq_marker] <- round(runif(sum(!is_rnaseq_marker), 0.0, 1.5), 2)

disease_boost <- ifelse(rnaseq_grid$condition == "Disease" & is_rnaseq_marker,
    round(rnorm(nrow(rnaseq_grid), mean = 1.2, sd = 0.3), 2), 0)
rep_noise <- round(rnorm(nrow(rnaseq_grid), mean = 0, sd = 0.25), 2)

log2_cpm <- pmax(base_expr + disease_boost + rep_noise, 0)

# Summary columns: average expression and simulated -log10(p-value) per cell_type x gene x condition
# (used by DotPlot tab — size encodes significance, fill encodes expression level)
rnaseq_grid$log2_cpm <- log2_cpm

summary_key <- paste(rnaseq_grid$cell_type, rnaseq_grid$gene, rnaseq_grid$condition)
avg_expr_map <- tapply(rnaseq_grid$log2_cpm, summary_key, mean)

# Simulate -log10(p-value): canonical markers get small p (high -log10), non-markers get large p (low -log10)
neg_log10_p_map <- tapply(
    seq_along(summary_key), summary_key,
    function(idx) {
        is_mk <- is_rnaseq_marker[idx[1]]
        if (is_mk) round(runif(1, 2.5, 5.0), 2) else round(runif(1, 0.1, 1.2), 2)
    }
)

rnaseq_grid$avg_expression <- round(as.numeric(avg_expr_map[summary_key]), 2)
rnaseq_grid$neg_log10_pval <- as.numeric(neg_log10_p_map[summary_key])

example_rnaseq <- data.frame(
    cell_type = factor(rnaseq_grid$cell_type, levels = levels(rnaseq_cell_types)),
    gene = factor(rnaseq_grid$gene, levels = levels(rnaseq_genes)),
    condition = factor(rnaseq_grid$condition, levels = levels(rnaseq_conditions)),
    replicate = factor(rnaseq_grid$replicate),
    log2_cpm = rnaseq_grid$log2_cpm,
    avg_expression = rnaseq_grid$avg_expression,
    neg_log10_pval = rnaseq_grid$neg_log10_pval
)

example_markers <- data.frame(
    cell_type = factor(marker_grid$cell_type, levels = cell_types),
    gene = factor(marker_grid$gene, levels = marker_genes),
    avg_expression = avg_expression,
    pct_expressed = pct_expressed
)




# Single-cell-style composition data for the freqPlot module.
# dittoViz::freqPlot() tabulates the frequency of `var` within each sample and
# compares those per-sample frequencies across groups, so it needs several
# samples nested inside each group (each sample mapping to exactly one value of
# every grouping column). No other bundled dataset has that shape.
# 12 donors x 150 cells = 1800 rows.
comp_cell_types <- c("CD4 T", "CD8 T", "B", "NK", "Monocyte", "Dendritic")
comp_samples <- sprintf("P%02d", 1:12)
comp_conditions <- rep(c("Healthy", "Disease"), each = 6)
# Batch is crossed with condition so it is a valid, non-confounded `color.by`.
comp_batches <- rep(c("B1", "B2", "B2", "B1", "B1", "B2"), times = 2)
comp_cells_per_sample <- 150

# Disease expands the monocyte compartment and depletes CD4 T cells.
comp_base_props <- list(
    Healthy = c("CD4 T" = 0.30, "CD8 T" = 0.20, "B" = 0.15, "NK" = 0.10,
                "Monocyte" = 0.18, "Dendritic" = 0.07),
    Disease = c("CD4 T" = 0.18, "CD8 T" = 0.17, "B" = 0.12, "NK" = 0.08,
                "Monocyte" = 0.35, "Dendritic" = 0.10)
)

# Per-cell-type transcriptome complexity, so the numeric QC columns are not noise.
comp_gene_means <- c("CD4 T" = 1800, "CD8 T" = 1900, "B" = 2100, "NK" = 2000,
                     "Monocyte" = 2600, "Dendritic" = 2400)

comp_rows <- lapply(seq_along(comp_samples), function(i) {
    condition <- comp_conditions[i]
    # Dirichlet draw (gamma-normalised) gives each donor its own composition
    # around the condition mean, so the per-group boxplots have real spread.
    alpha <- comp_base_props[[condition]] * 60
    props <- stats::rgamma(length(alpha), shape = alpha, rate = 1)
    props <- props / sum(props)

    counts <- as.vector(stats::rmultinom(1, comp_cells_per_sample, props))
    types <- rep(comp_cell_types, times = counts)

    data.frame(
        sample = comp_samples[i],
        condition = condition,
        batch = comp_batches[i],
        cell_type = types,
        n_genes = round(stats::rnorm(length(types), comp_gene_means[types], 350)),
        percent_mito = round(stats::rgamma(length(types), shape = 2, scale = 1.9), 2),
        stringsAsFactors = FALSE
    )
})

example_composition <- do.call(rbind, comp_rows)
example_composition$n_genes <- pmax(example_composition$n_genes, 200L)
example_composition$percent_mito <- pmin(example_composition$percent_mito, 25)
example_composition <- data.frame(
    cell_id = sprintf("cell_%04d", seq_len(nrow(example_composition))),
    sample = factor(example_composition$sample, levels = comp_samples),
    condition = factor(example_composition$condition, levels = c("Healthy", "Disease")),
    batch = factor(example_composition$batch, levels = c("B1", "B2")),
    cell_type = factor(example_composition$cell_type, levels = comp_cell_types),
    n_genes = as.integer(example_composition$n_genes),
    percent_mito = example_composition$percent_mito,
    stringsAsFactors = FALSE
)

# Gene-expression-style data for the ComplexHeatmap module: an observations
# (genes, rows) x samples (columns) matrix, shaped the way heatmap input
# typically is, with unscaled log2-CPM-like values (not pre-z-scored, since the
# module's own row/column scaling control needs real signal to demonstrate on).
# `example_heatmap_matrix` carries two row-annotation columns (`pathway`
# categorical, `mean_expression` numeric); the companion
# `example_heatmap_column_data` is a per-sample metadata table (keyed by
# `sample`) for demonstrating column annotations.
# 3 pathways x 10 genes = 30 genes; 2 conditions x 2 batches x 3 reps = 12 samples.
heatmap_pathways <- list(
    "Immune" = c("CD3D", "CD3E", "CD8A", "IL7R", "CD4", "GZMB", "PRF1", "IFNG", "TNF", "IL2RA"),
    "Metabolic" = c("PCK1", "G6PC", "PFKL", "ALDOA", "LDHA", "HK2", "PGK1", "ENO1", "GAPDH", "PKM"),
    "Cell Cycle" = c("MKI67", "CCNB1", "CCNE1", "CDK1", "CDK2", "PCNA", "TOP2A", "BUB1", "AURKA", "PLK1")
)
heatmap_genes <- unlist(heatmap_pathways, use.names = FALSE)
heatmap_gene_pathway <- rep(names(heatmap_pathways), each = 10)
n_heatmap_genes <- length(heatmap_genes)

heatmap_samples <- c(paste0("Healthy_", 1:6), paste0("Disease_", 1:6))
heatmap_condition <- rep(c("Healthy", "Disease"), each = 6)
heatmap_batch <- rep(rep(c("B1", "B2"), each = 3), times = 2)

# Metabolic (housekeeping-like) genes run broadly high in every sample; Immune
# and Cell Cycle genes start lower so the Disease boost below is visible
# against them.
heatmap_baseline <- ifelse(heatmap_gene_pathway == "Metabolic",
    stats::runif(n_heatmap_genes, 6, 8),
    stats::runif(n_heatmap_genes, 2, 4)
)

# Disease boosts Immune genes (activation) and Cell Cycle genes (proliferation);
# Metabolic genes are left flat, so the three pathways move independently
# rather than as one block, giving clustering/splitting/scaling something real
# to recover.
heatmap_expr <- vapply(seq_along(heatmap_samples), function(j) {
    boost <- if (heatmap_condition[j] == "Disease") {
        ifelse(heatmap_gene_pathway == "Immune", stats::rnorm(n_heatmap_genes, 1.6, 0.3),
            ifelse(heatmap_gene_pathway == "Cell Cycle", stats::rnorm(n_heatmap_genes, 1.1, 0.3), 0)
        )
    } else {
        0
    }
    noise <- stats::rnorm(n_heatmap_genes, 0, 0.4)
    pmax(heatmap_baseline + boost + noise, 0)
}, numeric(n_heatmap_genes))
colnames(heatmap_expr) <- heatmap_samples
heatmap_expr <- round(heatmap_expr, 2)

example_heatmap_matrix <- data.frame(
    gene = heatmap_genes,
    pathway = factor(heatmap_gene_pathway, levels = names(heatmap_pathways)),
    mean_expression = round(rowMeans(heatmap_expr), 2),
    heatmap_expr,
    check.names = FALSE,
    stringsAsFactors = FALSE
)

example_heatmap_column_data <- data.frame(
    sample = factor(heatmap_samples, levels = heatmap_samples),
    condition = factor(heatmap_condition, levels = c("Healthy", "Disease")),
    batch = factor(heatmap_batch, levels = c("B1", "B2")),
    library_size = round(stats::rnorm(length(heatmap_samples), mean = 5e6, sd = 6e5)),
    stringsAsFactors = FALSE
)

# internal = FALSE (the default) saves one .rda per object under data/, which
# is what every example_* dataset actually ships as (LazyData: true in
# DESCRIPTION makes them directly accessible, no NAMESPACE export needed).
# internal = TRUE would instead bundle everything into a single R/sysdata.rda
# and stop these from being public datasets at all -- do not set it.
usethis::use_data(
    example_iris, example_mtcars,
    example_bar, example_school_earnings,
    example_skills,
    example_sales, example_population, example_demographics,
    example_markers, example_rnaseq,
    example_composition,
    example_heatmap_matrix, example_heatmap_column_data,
    overwrite = TRUE
)
