# Generate example datasets for module apps
#
# These datasets are what the module gallery, the Figure Builder, and every
# *App() open on (see R/module_showcase.R), so each one carries real structure
# for the features those demos switch on: group differences large enough for
# significance brackets, correlated columns for fit lines, trends for the line
# and area plots, and a few planted outliers for highlighting. Change an effect
# here and tests/testthat/test-showcase.R checks the demos still have something
# to show.
#
# Each dataset seeds its own RNG, so editing one block does not reshuffle the
# values of every block after it.

clamp <- function(x, lo, hi) pmin(pmax(x, lo), hi)

# Sales data: 10 years x 12 months x 6 regions = 720 rows.
# Units follow a per-product trend (Gadgets growing, Widgets flat, Doohickeys
# declining), a Q4 peak, and a per-region scale. Revenue is units times a
# per-product unit price, so revenue ~ units shows one slope per product line.
set.seed(101)
sales_regions <- c("North", "South", "East", "West", "Central", "International")
sales_products <- c("Gadgets", "Widgets", "Doohickeys")
sales_grid <- expand.grid(
    region = sales_regions, month = month.abb, year = 2015:2024,
    KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE
)
n_sales <- nrow(sales_grid)
# 24 rows of each product line per year, so no year is short of any of them.
sales_product <- unlist(lapply(unique(sales_grid$year), function(y) sample(rep(sales_products, 24))))

sales_region_scale <- c(
    North = 260, South = 220, East = 240, West = 280, Central = 180, International = 340
)
sales_product_scale <- c(Gadgets = 0.8, Widgets = 1.2, Doohickeys = 1.0)
sales_product_growth <- c(Gadgets = 1.10, Widgets = 1.02, Doohickeys = 0.93)
sales_season <- setNames(
    c(0.85, 0.80, 0.90, 0.95, 1.00, 0.95, 0.90, 0.92, 1.00, 1.05, 1.25, 1.45),
    month.abb
)
# Thousands of USD per unit.
sales_unit_price <- c(Gadgets = 0.45, Widgets = 0.25, Doohickeys = 0.70)
sales_margin <- c(Gadgets = 0.30, Widgets = 0.22, Doohickeys = 0.12)

sales_units <- round(
    sales_region_scale[sales_grid$region] *
        sales_product_scale[sales_product] *
        sales_product_growth[sales_product]^(sales_grid$year - 2015) *
        sales_season[sales_grid$month] *
        exp(stats::rnorm(n_sales, 0, 0.15))
)
sales_revenue <- sales_units * sales_unit_price[sales_product] * exp(stats::rnorm(n_sales, 0, 0.06))

# Two planted outliers for the scatter plot's highlight demo: a promotion that
# shifted far more units than usual at the normal price, and a clearance sale
# that moved an ordinary number of units at well under half price.
promo_row <- which(sales_grid$year == 2019 & sales_grid$month == "Nov" & sales_grid$region == "West")
clearance_row <- which(sales_grid$year == 2022 & sales_grid$month == "Jun" & sales_grid$region == "International")
sales_units[promo_row] <- round(sales_units[promo_row] * 2.4)
sales_revenue[promo_row] <- sales_units[promo_row] * sales_unit_price[sales_product[promo_row]]
sales_revenue[clearance_row] <- sales_revenue[clearance_row] * 0.4

# Overhead is fixed per sale, so low-volume Doohickey sales run at a loss.
sales_profit <- sales_revenue * sales_margin[sales_product] - stats::rnorm(n_sales, 8, 2)

example_sales <- data.frame(
    region = factor(sales_grid$region, levels = sales_regions),
    revenue = round(unname(sales_revenue), 1),
    year = factor(sales_grid$year),
    month = factor(sales_grid$month, levels = month.abb),
    units = as.integer(sales_units),
    sale_id = paste0("Sale_", seq_len(n_sales)),
    product_line = factor(sales_product, levels = sales_products),
    profit = round(unname(sales_profit), 1)
)

# Population data: 50 years x 8 age groups = 400 rows.
# The young groups shrink and the old groups grow, so a stacked area (or its
# share-of-total view) shows the population ageing.
set.seed(202)
pop_age_groups <- c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+")
pop_start <- c(6000, 5000, 9000, 5500, 5000, 4000, 2800, 1800)
pop_end <- c(4800, 4300, 8500, 6000, 6200, 6500, 5600, 4600)
pop_years <- 1975:2024
pop_frac <- (pop_years - min(pop_years)) / diff(range(pop_years))

pop_counts <- unlist(lapply(pop_frac, function(f) {
    round((pop_start + (pop_end - pop_start) * f) * exp(stats::rnorm(length(pop_age_groups), 0, 0.02)))
}))

example_population <- data.frame(
    year = factor(rep(pop_years, each = length(pop_age_groups))),
    age_group = factor(rep(pop_age_groups, times = length(pop_years)), levels = pop_age_groups),
    count = pop_counts,
    record_id = paste0("Record_", seq_along(pop_counts))
)

# iris with an added Group column for multi-group examples
example_iris <- iris
example_iris$Group <- factor(c(rep(c("A", "B"), 50), rep(c("C", "D"), 25)))

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

# Multi-player skills data for radar plots: a runner, a defender, and a
# playmaker, so the three polygons point in different directions.
example_skills <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Agility", "Vision"), 3),
    value    = c(
        9, 5, 4, 9, 7, 5,
        4, 9, 9, 6, 3, 5,
        6, 5, 6, 6, 9, 9
    ),
    player   = rep(c("Player A", "Player B", "Player C"), each = 6)
)


# For bar and split bar plots: one value per Group x Type, so bars stack by
# Type and every Type facet of a split bar has one bar per Group. Score and
# Numbers are signed, leaning positive for Alpha and negative for Gamma.
set.seed(303)
bar_groups <- c("A", "B", "C", "D", "E", "F")
bar_types <- c("Alpha", "Beta", "Gamma")
bar_grid <- expand.grid(Group = bar_groups, Type = bar_types, KEEP.OUT.ATTRS = FALSE, stringsAsFactors = FALSE)
bar_grid <- bar_grid[order(bar_grid$Group, bar_grid$Type), ]
bar_group_size <- c(A = 22, B = 35, C = 18, D = 41, E = 29, F = 25)
bar_type_share <- c(Alpha = 1, Beta = 0.6, Gamma = 0.35)
bar_type_shift <- c(Alpha = 6, Beta = 0, Gamma = -6)

example_bar <- data.frame(
    Group = bar_grid$Group,
    Type = bar_grid$Type,
    Values = unname(round(
        bar_group_size[bar_grid$Group] * bar_type_share[bar_grid$Type] + stats::rnorm(nrow(bar_grid), 0, 3)
    )),
    Numbers = unname(round(bar_type_shift[bar_grid$Type] * 2 + stats::rnorm(nrow(bar_grid), 0, 9))),
    Score = unname(round(bar_type_shift[bar_grid$Type] + stats::rnorm(nrow(bar_grid), 0, 7))),
    row.names = NULL
)
example_bar$Values <- pmax(example_bar$Values, 1)

# Employee survey data: 500 rows.
# Salary rises steeply with job level and varies by department; age and tenure
# rise with level; remote workers report higher satisfaction in every
# department; long hours lower it. Gender deliberately has no effect.
set.seed(404)
n_emp <- 500
emp_departments <- c("Engineering", "Finance", "Sales", "Marketing", "Operations", "HR")
emp_levels <- c("Entry", "Mid", "Senior", "Lead")

emp_department <- sample(emp_departments, n_emp, replace = TRUE, prob = c(0.26, 0.12, 0.22, 0.14, 0.16, 0.10))
emp_level <- sample(emp_levels, n_emp, replace = TRUE, prob = c(0.35, 0.30, 0.22, 0.13))
emp_level_i <- match(emp_level, emp_levels)
emp_gender <- sample(c("Male", "Female"), n_emp, replace = TRUE)
emp_work_mode <- sample(c("Office", "Remote"), n_emp, replace = TRUE, prob = c(0.55, 0.45))

# Two planted employees for the yPlot highlight demo, at fixed rows so their IDs
# (E042, E137) do not move when the seed does: a thoroughly unhappy remote
# engineer and a delighted office-based salesperson, each against the trend.
unhappy_remote <- 42
happy_office <- 137
emp_department[c(unhappy_remote, happy_office)] <- c("Engineering", "Sales")
emp_work_mode[c(unhappy_remote, happy_office)] <- c("Remote", "Office")

emp_age <- round(clamp(stats::rnorm(n_emp, c(27, 34, 42, 48)[emp_level_i], 5), 21, 67))
emp_tenure <- round(pmin(
    stats::rgamma(n_emp, shape = 2, scale = c(1, 2, 3.5, 5)[emp_level_i]),
    emp_age - 21
), 1)

emp_dept_pay <- c(Engineering = 1.18, Finance = 1.10, Sales = 1.02, Marketing = 0.98, Operations = 0.92, HR = 0.88)
emp_salary <- round(
    c(55000, 72000, 95000, 125000)[emp_level_i] * emp_dept_pay[emp_department] * exp(stats::rnorm(n_emp, 0, 0.10)),
    -2
)

emp_dept_hours <- c(Engineering = 44, Finance = 45, Sales = 43, Marketing = 40, Operations = 41, HR = 38)
emp_hours <- round(emp_dept_hours[emp_department] + c(0, 1, 2, 4)[emp_level_i] + stats::rnorm(n_emp, 0, 3), 1)

emp_satisfaction <- round(clamp(
    6 + ifelse(emp_work_mode == "Remote", 1.3, 0) - 0.12 * (emp_hours - 42) + stats::rnorm(n_emp, 0, 1.2),
    1, 10
), 1)
emp_performance <- round(clamp(5.8 + 0.12 * pmin(emp_tenure, 15) + stats::rnorm(n_emp, 0, 1.2), 1, 10), 1)

emp_ids <- sprintf("E%03d", seq_len(n_emp))
emp_satisfaction[unhappy_remote] <- 1.4
emp_satisfaction[happy_office] <- 9.8

example_demographics <- data.frame(
    department = factor(emp_department, levels = emp_departments),
    job_level = factor(emp_level, levels = emp_levels),
    gender = factor(emp_gender, levels = c("Female", "Male")),
    age = emp_age,
    salary = unname(emp_salary),
    satisfaction = emp_satisfaction,
    performance = emp_performance,
    tenure_years = emp_tenure,
    weekly_hours = unname(emp_hours),
    work_mode = factor(emp_work_mode, levels = c("Office", "Remote")),
    employee_id = emp_ids
)

# Single-cell marker-gene expression data for dot plot examples.
# Mirrors a canonical single-cell "marker dot plot": each cell type expresses
# its own marker genes strongly (high average expression, high percent
# expressed) and the remaining genes weakly.
set.seed(505)
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

# RNA-seq long-format (pseudo-bulk) dataset.
# Mimics pseudo-bulk RNA-seq: 6 immune cell types x 8 canonical marker genes
# x 2 conditions x 3 replicates = 288 rows.
# Includes per-sample log2 CPM values (for yPlot/DensityPlot) and
# pre-summarised avg_expression + pct_expressed (for DotPlot).
set.seed(606)
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
set.seed(707)
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
    # around the condition mean, so the per-group boxplots have real spread
    # while CD4 T and Monocyte still separate cleanly between the conditions.
    alpha <- comp_base_props[[condition]] * 100
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
set.seed(808)
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
