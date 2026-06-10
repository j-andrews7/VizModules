#' Compute pairwise statistical tests between groups
#'
#' Performs pairwise statistical tests between groups defined by a categorical
#' variable. Supports Wilcoxon rank-sum, t-test, Kruskal-Wallis, and ANOVA.
#' Handles nested grouping (comparing color.by groups within each x-level)
#' and per-facet testing.
#'
#' @param df Data frame containing the data.
#' @param x Character; column name of the categorical x-axis variable.
#' @param y Character; column name of the numeric response variable.
#' @param pairs List of length-2 character vectors specifying group pairs to test.
#'   If NULL (default), tests all unique pairwise combinations.
#' @param test Character; statistical test to use. One of `"wilcox.test"`,
#'   `"t.test"`, `"kruskal.test"`, or `"anova"`.
#' @param p.adjust.method Character; method for p-value adjustment via
#'   [stats::p.adjust()]. Default `"holm"`.
#' @param paired Logical; whether to perform paired tests (only for
#'   `"wilcox.test"` and `"t.test"`). Default FALSE.
#' @param group.by Character or NULL; column for nested grouping. When set,
#'   comparisons are made between levels of `group.by` within each level of `x`.
#' @param facet.by Character or NULL; column for faceting. When set and
#'   `per.facet = TRUE`, tests run independently per facet panel.
#' @param per.facet Logical; if TRUE and `facet.by` is set, run tests
#'   independently per facet panel. Default TRUE.
#' @param sig.threshold Numeric; significance threshold for `*` vs `ns`.
#'   P-values at or below this are labeled `*`; above are labeled `ns`. Default 0.05.
#'   See `sig.levels` for the multi-star thresholds.
#' @param sig.levels Named numeric vector; upper p-value bounds for multi-star
#'   significance symbols. Names are the displayed symbols and values are the
#'   thresholds. Default `c("****" = 0.0001, "***" = 0.001, "**" = 0.01)`.
#'   Any number of levels can be provided. Evaluated from smallest to largest
#'   threshold so the most significant symbol always wins.
#'
#' @return A data.frame with columns: `group1`, `group2`, `p.value`, `p.adj`,
#'   `p.signif`, `test`, `facet_level`, `x_level` (when `group.by` is set).
#'
#' @importFrom stats wilcox.test t.test kruskal.test aov p.adjust as.formula
#'
#' @examples
#' compute_pairwise_stats(
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     test = "wilcox.test"
#' )
#'
#' # Custom significance levels: only two-star tiers, lower threshold for *
#' compute_pairwise_stats(
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     test = "wilcox.test",
#'     sig.threshold = 0.01,
#'     sig.levels = c("**" = 0.001, "***" = 0.0001)
#' )
#'
#' @author Jared Andrews, Jacob Martin
#' @export
compute_pairwise_stats <- function(df, x, y,
                                    pairs = NULL,
                                    test = "wilcox.test",
                                    p.adjust.method = "holm",
                                    paired = FALSE,
                                    group.by = NULL,
                                    facet.by = NULL,
                                    per.facet = TRUE,
                                    sig.threshold = 0.05,
                                    sig.levels = c("****" = 0.0001, "***" = 0.001, "**" = 0.01)) {
    .compute_for_subset <- function(sub_df, facet_level = NA_character_) {
        if (test %in% c("kruskal.test", "anova")) {
            return(.compute_omnibus(sub_df, x, y, test, group.by, facet_level))
        }
        .compute_pairwise(sub_df, x, y, test, paired, pairs, group.by, facet_level)
    }

    # Run tests, optionally per facet
    if (!is.null(facet.by) && nzchar(facet.by) && per.facet) {
        facet_levels <- unique(as.character(df[[facet.by]]))
        all_results <- lapply(facet_levels, function(flev) {
            sub <- df[as.character(df[[facet.by]]) == flev, ]
            .compute_for_subset(sub, facet_level = flev)
        })
        stats_df <- do.call(rbind, Filter(Negate(is.null), all_results))
    } else {
        stats_df <- .compute_for_subset(df)
    }

    if (is.null(stats_df) || nrow(stats_df) == 0) {
        return(data.frame(
            group1 = character(0), group2 = character(0),
            p.value = numeric(0), p.adj = numeric(0), p.signif = character(0),
            test = character(0), facet_level = character(0), x_level = character(0),
            stringsAsFactors = FALSE
        ))
    }

    # Adjust p-values across all tests
    stats_df$p.adj <- p.adjust(stats_df$p.value, method = p.adjust.method)
    stats_df$p.signif <- .p_to_signif(stats_df$p.adj, sig.threshold, sig.levels)
    stats_df
}


# --- Internal helpers for compute_pairwise_stats -----------------------------

#' Run a single pairwise test on two numeric vectors
#' @noRd
.run_pairwise_test <- function(vals1, vals2, test_type, paired_test) {
    if (length(vals1) < 2 || length(vals2) < 2) {
        return(NA_real_)
    }
    tryCatch(
        {
            result <- switch(test_type,
                "wilcox.test" = wilcox.test(vals1, vals2, paired = paired_test),
                "t.test" = t.test(vals1, vals2, paired = paired_test),
                stop("Unsupported pairwise test: ", test_type)
            )
            result$p.value
        },
        error = function(e) NA_real_
    )
}

#' Convert p-values to significance symbols
#' @noRd
.p_to_signif <- function(p, sig.threshold, sig.levels) {
    out <- ifelse(is.na(p), "NA", ifelse(p <= sig.threshold, "*", "ns"))
    for (nm in names(sort(sig.levels, decreasing = TRUE))) {
        out[!is.na(p) & p <= sig.levels[[nm]]] <- nm
    }
    out
}

#' Compute omnibus tests (Kruskal-Wallis or ANOVA) for a data subset
#' @noRd
.compute_omnibus <- function(sub_df, x, y, test, group.by, facet_level) {
    if (!is.null(group.by) && nzchar(group.by)) {
        x_levels <- unique(as.character(sub_df[[x]]))
        results <- lapply(x_levels, function(xlev) {
            x_sub <- sub_df[as.character(sub_df[[x]]) == xlev, ]
            grp_vals <- as.character(x_sub[[group.by]])
            if (length(unique(grp_vals)) < 2) {
                return(NULL)
            }
            p_val <- tryCatch(
                {
                    if (test == "kruskal.test") {
                        kruskal.test(x_sub[[y]] ~ factor(x_sub[[group.by]]))$p.value
                    } else {
                        summary(aov(as.formula(paste0("`", y, "` ~ factor(`", group.by, "`)")),
                            data = x_sub
                        ))[[1]][["Pr(>F)"]][1]
                    }
                },
                error = function(e) NA_real_
            )
            data.frame(
                group1 = "all", group2 = "all", p.value = p_val,
                test = test, facet_level = facet_level, x_level = xlev,
                stringsAsFactors = FALSE
            )
        })
        do.call(rbind, Filter(Negate(is.null), results))
    } else {
        if (length(unique(as.character(sub_df[[x]]))) < 2) {
            return(NULL)
        }
        p_val <- tryCatch(
            {
                if (test == "kruskal.test") {
                    kruskal.test(sub_df[[y]] ~ factor(sub_df[[x]]))$p.value
                } else {
                    summary(aov(as.formula(paste0("`", y, "` ~ factor(`", x, "`)")),
                        data = sub_df
                    ))[[1]][["Pr(>F)"]][1]
                }
            },
            error = function(e) NA_real_
        )
        data.frame(
            group1 = "all", group2 = "all", p.value = p_val,
            test = test, facet_level = facet_level, x_level = NA_character_,
            stringsAsFactors = FALSE
        )
    }
}

#' Compute pairwise tests (Wilcoxon or t-test) for a data subset
#' @noRd
.compute_pairwise <- function(sub_df, x, y, test, paired, pairs, group.by, facet_level) {
    if (!is.null(group.by) && nzchar(group.by)) {
        x_levels <- unique(as.character(sub_df[[x]]))
        grp_levels <- unique(as.character(sub_df[[group.by]]))
        if (length(grp_levels) < 2) {
            return(NULL)
        }

        grp_pairs <- if (!is.null(pairs)) {
            pairs
        } else {
            combn(grp_levels, 2, simplify = FALSE)
        }

        results <- lapply(x_levels, function(xlev) {
            x_sub <- sub_df[as.character(sub_df[[x]]) == xlev, ]
            pair_results <- lapply(grp_pairs, function(pr) {
                vals1 <- x_sub[as.character(x_sub[[group.by]]) == pr[1], y]
                vals2 <- x_sub[as.character(x_sub[[group.by]]) == pr[2], y]
                p_val <- .run_pairwise_test(vals1, vals2, test, paired)
                data.frame(
                    group1 = pr[1], group2 = pr[2], p.value = p_val,
                    test = test, facet_level = facet_level, x_level = xlev,
                    stringsAsFactors = FALSE
                )
            })
            do.call(rbind, pair_results)
        })
        do.call(rbind, results)
    } else {
        x_levels <- unique(as.character(sub_df[[x]]))
        if (length(x_levels) < 2) {
            return(NULL)
        }

        test_pairs <- if (!is.null(pairs)) {
            pairs
        } else {
            combn(x_levels, 2, simplify = FALSE)
        }

        results <- lapply(test_pairs, function(pr) {
            vals1 <- sub_df[as.character(sub_df[[x]]) == pr[1], y]
            vals2 <- sub_df[as.character(sub_df[[x]]) == pr[2], y]
            p_val <- .run_pairwise_test(vals1, vals2, test, paired)
            data.frame(
                group1 = pr[1], group2 = pr[2], p.value = p_val,
                test = test, facet_level = facet_level, x_level = NA_character_,
                stringsAsFactors = FALSE
            )
        })
        do.call(rbind, results)
    }
}


#' Create plotly shapes and annotations for statistical test results
#'
#' Converts results from [compute_pairwise_stats()] into plotly-compatible
#' shapes (brackets) and annotations (text labels). Sorts comparisons so that
#' small-gap brackets are closest to the data and large-gap brackets are higher.
#'
#' @param stats_df Data frame from [compute_pairwise_stats()].
#' @param fig A plotly figure object. Used to detect subplot axis pairs for
#'   faceted plots.
#' @param df The original data frame.
#' @param x Character; x-axis column name.
#' @param y Character; y-axis column name.
#' @param display Character; what to display: `"p.adj"`, `"p.value"`, or
#'   `"symbol"`. Default `"p.adj"`.
#' @param hide.ns Logical; hide non-significant results. Default FALSE.
#' @param sig.threshold Numeric; significance threshold for determining
#'   non-significant results. Default 0.05.
#' @param line.color Character; color for bracket lines. Default `"#000000"`.
#' @param line.width Numeric; width of bracket lines. Default 1.
#' @param bracket.style Character; `"capped"` for ggpubr-style brackets with
#'   vertical ticks, or `"flat"` for a single horizontal line. Default `"capped"`.
#' @param group.by Character or NULL; nested grouping column.
#' @param facet.by Character or NULL; faceting column.
#' @param x.order Character vector; order of x-axis categories. If NULL, derived
#'   from unique values of `x` column.
#' @param font.size Numeric; size of annotation text. Default 12.
#' @param step.increase Numeric; fraction of y-range for spacing between
#'   successive brackets. Default 0.06.
#' @param text.bump Numeric; fraction of y-range for vertical distance of
#'   text above the bracket line. Default 0.04.
#' @param bracket.inset Numeric; fixed amount to inset each bracket endpoint
#'   from the group center position. Creates visual separation between
#'   adjacent brackets at the same y-level. Default 0.025.
#'
#' @return A list with components:
#'   \describe{
#'     \item{annotations}{List of plotly annotation objects.}
#'     \item{shapes}{List of plotly shape objects.}
#'     \item{y.max}{Numeric; maximum y value needed to accommodate all annotations.}
#'   }
#'
#' @importFrom utils combn
#'
#' @examples
#' stats_df <- compute_pairwise_stats(
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     test = "wilcox.test"
#' )
#'
#' fig <- plotly::plot_ly(
#'     data = example_iris, x = ~Species, y = ~Sepal.Length, type = "box"
#' )
#'
#' stat_result <- create_stat_annotations(
#'     stats_df = stats_df,
#'     fig = fig,
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     display = "symbol"
#' )
#'
#' names(stat_result)
#'
#' @author Jared Andrews, Jacob Martin
#' @export
create_stat_annotations <- function(stats_df, fig, df, x, y,
                                     display = "p.adj",
                                     hide.ns = FALSE,
                                     sig.threshold = 0.05,
                                     line.color = "#000000",
                                     line.width = 1,
                                     bracket.style = "capped",
                                     group.by = NULL,
                                     facet.by = NULL,
                                     x.order = NULL,
                                     font.size = 12,
                                     step.increase = 0.06,
                                     text.bump = 0.04,
                                     bracket.inset = 0.025) {
    empty_result <- list(annotations = list(), shapes = list(), y.max = NULL)

    if (is.null(stats_df) || nrow(stats_df) == 0) {
        return(empty_result)
    }

    # Filter non-significant if requested
    if (hide.ns) {
        stats_df <- stats_df[!is.na(stats_df$p.adj) & stats_df$p.adj <= sig.threshold, ]
        if (nrow(stats_df) == 0) {
            return(empty_result)
        }
    }

    # Separate omnibus from pairwise results
    omnibus_df <- stats_df[stats_df$group1 == "all", ]
    pairwise_df <- stats_df[stats_df$group1 != "all", ]

    all_annotations <- list()
    all_shapes <- list()

    # Handle omnibus annotation
    if (nrow(omnibus_df) > 0) {
        all_annotations <- .build_omnibus_annotation(
            omnibus_df, display, font.size, line.color
        )
    }

    if (nrow(pairwise_df) == 0) {
        return(list(annotations = all_annotations, shapes = all_shapes, y.max = NULL))
    }

    # Determine x-axis order
    if (is.null(x.order)) {
        col_data <- df[[x]]
        x.order <- if (is.factor(col_data)) levels(col_data) else unique(as.character(col_data))
    }

    # Y-axis range from data
    v_max <- max(df[[y]], na.rm = TRUE)
    v_range <- v_max - min(df[[y]], na.rm = TRUE)
    v_unit <- v_range * step.increase
    bump <- v_range * text.bump
    tick_height <- v_range * 0.02

    # Build facet axis map
    facet_axis_map <- .build_facet_axis_map(fig, facet.by)

    # Process brackets per facet level
    facet_levels <- unique(pairwise_df$facet_level)
    if (all(is.na(facet_levels))) facet_levels <- NA_character_

    all_annotations <- list()
    all_shapes <- list()
    global_y_max <- v_max

    for (flev in facet_levels) {
        if (is.na(flev)) {
            facet_rows <- pairwise_df[is.na(pairwise_df$facet_level), ]
            xref <- "x"
            yref <- "y"
        } else {
            facet_rows <- pairwise_df[!is.na(pairwise_df$facet_level) &
                pairwise_df$facet_level == flev, ]
            if (length(facet_axis_map) > 0 && flev %in% names(facet_axis_map)) {
                xref <- facet_axis_map[[flev]]$x
                yref <- facet_axis_map[[flev]]$y
            } else {
                xref <- "x"
                yref <- "y"
            }
        }

        if (nrow(facet_rows) == 0) next

        # Compute x-positions and sort by gap
        facet_rows$x0_pos <- mapply(
            .get_x_pos, facet_rows$group1, facet_rows$x_level,
            MoreArgs = list(x.order = x.order, group.by = group.by, df = df)
        )
        facet_rows$x1_pos <- mapply(
            .get_x_pos, facet_rows$group2, facet_rows$x_level,
            MoreArgs = list(x.order = x.order, group.by = group.by, df = df)
        )
        facet_rows$gap <- abs(facet_rows$x1_pos - facet_rows$x0_pos)
        facet_rows <- facet_rows[order(facet_rows$gap), ]

        # Compute inset endpoints
        facet_rows$x0_raw <- pmin(facet_rows$x0_pos, facet_rows$x1_pos)
        facet_rows$x1_raw <- pmax(facet_rows$x0_pos, facet_rows$x1_pos)
        facet_rows$x0_draw <- facet_rows$x0_raw + bracket.inset
        facet_rows$x1_draw <- facet_rows$x1_raw - bracket.inset

        # Pack brackets into y-levels
        facet_rows$y_level <- .pack_bracket_levels(facet_rows)

        # Generate bracket shapes and annotations
        bracket_result <- .create_bracket_shapes(
            facet_rows, v_max, v_unit, bump, tick_height,
            display, bracket.style, line.color, line.width,
            font.size, xref, yref
        )
        all_shapes <- c(all_shapes, bracket_result$shapes)
        all_annotations <- c(all_annotations, bracket_result$annotations)
        if (bracket_result$y_max > global_y_max) {
            global_y_max <- bracket_result$y_max
        }
    }

    global_y_max <- global_y_max + v_unit

    # Replicate annotations to extra facet panels when per-facet is disabled
    if (length(facet_axis_map) > 0 && all(is.na(unique(pairwise_df$facet_level)))) {
        replicated <- .replicate_to_facet_panels(
            all_annotations, all_shapes, facet_axis_map
        )
        all_annotations <- replicated$annotations
        all_shapes <- replicated$shapes
    }

    # Re-add omnibus annotation if present
    if (nrow(omnibus_df) > 0) {
        omnibus_annots <- .build_omnibus_annotation(
            omnibus_df, display, font.size, line.color
        )
        all_annotations <- c(omnibus_annots, all_annotations)
    }

    list(annotations = all_annotations, shapes = all_shapes, y.max = global_y_max)
}


# --- Internal helpers for create_stat_annotations ----------------------------

#' Get x-position for a group label on plotly categorical axis
#' @noRd
.get_x_pos <- function(group_label, x_level, x.order, group.by, df) {
    if (!is.null(group.by) && nzchar(group.by) && !is.na(x_level)) {
        x_idx <- match(x_level, x.order)
        grp_levels <- unique(as.character(df[[group.by]]))
        n_grps <- length(grp_levels)
        grp_idx <- match(group_label, grp_levels) - 1
        if (n_grps == 1) {
            return(x_idx)
        }
        offset <- (grp_idx / (n_grps - 1) - 0.5) * 0.8
        x_idx + offset
    } else {
        match(group_label, x.order)
    }
}

#' Build omnibus test annotation (ANOVA / Kruskal-Wallis)
#' @noRd
.build_omnibus_annotation <- function(omnibus_df, display, font.size, line.color) {
    test_name <- if (omnibus_df$test[1] == "kruskal.test") "Kruskal-Wallis" else "ANOVA"
    omnibus_labels <- vapply(seq_len(nrow(omnibus_df)), function(i) {
        row <- omnibus_df[i, ]
        p_text <- switch(display,
            "symbol" = row$p.signif,
            "p.value" = if (is.na(row$p.value)) "NA" else format(round(row$p.value, 4), scientific = FALSE),
            "p.adj" = if (is.na(row$p.adj)) "NA" else format(round(row$p.adj, 4), scientific = FALSE)
        )
        facet_prefix <- if (!is.na(row$facet_level)) paste0(row$facet_level, ": ") else ""
        x_prefix <- if (!is.na(row$x_level)) paste0(row$x_level, ": ") else ""
        paste0(facet_prefix, x_prefix, "p=", p_text)
    }, character(1))

    omnibus_text <- paste0(test_name, ": ", paste(omnibus_labels, collapse = "; "))

    list(list(
        text = omnibus_text,
        x = 0.01, y = -0.12,
        xref = "paper", yref = "paper",
        xanchor = "left", yanchor = "top",
        showarrow = FALSE,
        font = list(size = font.size - 1, color = line.color),
        captureevents = TRUE
    ))
}

#' Build facet-level to plotly axis-pair mapping from figure layout
#' @noRd
.build_facet_axis_map <- function(fig, facet.by) {
    facet_axis_map <- list()
    if (is.null(facet.by) || !nzchar(facet.by) || is.null(fig)) {
        return(facet_axis_map)
    }

    layout <- fig$x$layout

    # Collect axes with domain midpoints
    x_axes <- list()
    y_axes <- list()
    for (nm in names(layout)) {
        if (grepl("^xaxis", nm)) {
            ax <- layout[[nm]]
            if (!is.null(ax$domain)) {
                trace_ref <- sub("^xaxis", "x", nm)
                x_axes[[trace_ref]] <- (ax$domain[1] + ax$domain[2]) / 2
            }
        } else if (grepl("^yaxis", nm)) {
            ax <- layout[[nm]]
            if (!is.null(ax$domain)) {
                trace_ref <- sub("^yaxis", "y", nm)
                y_axes[[trace_ref]] <- ax$domain[2]
            }
        }
    }

    # Match strip label annotations to axis pairs
    annots <- layout$annotations
    if (is.null(annots) || length(x_axes) == 0 || length(y_axes) == 0) {
        return(facet_axis_map)
    }

    for (a in annots) {
        if (is.null(a$xref) || a$xref != "paper") next
        if (is.null(a$text) || !nzchar(a$text)) next
        if (isTRUE(a$x == 0) || isTRUE(a$y == 0)) next

        best_x <- NULL
        best_x_dist <- Inf
        for (xref in names(x_axes)) {
            dist <- abs(x_axes[[xref]] - a$x)
            if (dist < best_x_dist) {
                best_x_dist <- dist
                best_x <- xref
            }
        }

        best_y <- NULL
        best_y_dist <- Inf
        for (yref in names(y_axes)) {
            dist <- abs(y_axes[[yref]] - a$y)
            if (dist < best_y_dist) {
                best_y_dist <- dist
                best_y <- yref
            }
        }

        if (!is.null(best_x) && !is.null(best_y)) {
            facet_axis_map[[a$text]] <- list(x = best_x, y = best_y)
        }
    }

    facet_axis_map
}

#' Pack brackets into non-overlapping y-levels using interval packing
#' @noRd
.pack_bracket_levels <- function(facet_rows) {
    gap_groups <- unique(facet_rows$gap)
    y_levels <- list()
    y_level_out <- rep(NA_integer_, nrow(facet_rows))

    for (gg in gap_groups) {
        group_idx <- which(facet_rows$gap == gg)
        for (idx in group_idx) {
            bx0 <- facet_rows$x0_draw[idx]
            bx1 <- facet_rows$x1_draw[idx]
            placed <- FALSE
            for (lev in seq_along(y_levels)) {
                overlaps <- FALSE
                for (interval in y_levels[[lev]]) {
                    if (bx0 < interval[2] && bx1 > interval[1]) {
                        overlaps <- TRUE
                        break
                    }
                }
                if (!overlaps) {
                    y_levels[[lev]][[length(y_levels[[lev]]) + 1]] <- c(bx0, bx1)
                    y_level_out[idx] <- lev
                    placed <- TRUE
                    break
                }
            }
            if (!placed) {
                y_levels[[length(y_levels) + 1]] <- list(c(bx0, bx1))
                y_level_out[idx] <- length(y_levels)
            }
        }
    }
    y_level_out
}

#' Create bracket shapes and text annotations for a set of comparisons
#' @noRd
.create_bracket_shapes <- function(facet_rows, v_max, v_unit, bump, tick_height,
                                    display, bracket.style, line.color, line.width,
                                    font.size, xref, yref) {
    shapes <- list()
    annotations <- list()
    local_y_max <- v_max

    for (i in seq_len(nrow(facet_rows))) {
        row <- facet_rows[i, ]
        y_bar <- v_max + v_unit * row$y_level

        x0 <- row$x0_draw
        x1 <- row$x1_draw
        x_mid <- (x0 + x1) / 2

        label <- switch(display,
            "symbol" = row$p.signif,
            "p.value" = if (is.na(row$p.value)) "NA" else format(round(row$p.value, 4), scientific = FALSE),
            "p.adj" = if (is.na(row$p.adj)) "NA" else format(round(row$p.adj, 4), scientific = FALSE)
        )

        if (bracket.style == "capped") {
            shapes[[length(shapes) + 1]] <- list(
                type = "line",
                line = list(color = line.color, width = line.width),
                xref = xref, yref = yref,
                x0 = x0, x1 = x0,
                y0 = y_bar - tick_height, y1 = y_bar
            )
            shapes[[length(shapes) + 1]] <- list(
                type = "line",
                line = list(color = line.color, width = line.width),
                xref = xref, yref = yref,
                x0 = x0, x1 = x1,
                y0 = y_bar, y1 = y_bar
            )
            shapes[[length(shapes) + 1]] <- list(
                type = "line",
                line = list(color = line.color, width = line.width),
                xref = xref, yref = yref,
                x0 = x1, x1 = x1,
                y0 = y_bar - tick_height, y1 = y_bar
            )
        } else {
            shapes[[length(shapes) + 1]] <- list(
                type = "line",
                line = list(color = line.color, width = line.width),
                xref = xref, yref = yref,
                x0 = x0, x1 = x1,
                y0 = y_bar, y1 = y_bar
            )
        }

        annotations[[length(annotations) + 1]] <- list(
            text = label,
            x = x_mid, y = y_bar + bump,
            xref = xref, yref = yref,
            showarrow = FALSE,
            font = list(size = font.size, color = line.color)
        )

        top <- y_bar + bump
        if (top > local_y_max) local_y_max <- top
    }

    list(shapes = shapes, annotations = annotations, y_max = local_y_max)
}

#' Replicate annotations/shapes to extra facet panels
#' @noRd
.replicate_to_facet_panels <- function(all_annotations, all_shapes, facet_axis_map) {
    axis_pairs <- unique(lapply(facet_axis_map, function(p) p))
    extra_pairs <- Filter(function(p) !(p$x == "x" && p$y == "y"), axis_pairs)

    if (length(extra_pairs) > 0) {
        base_annotations <- all_annotations
        base_shapes <- all_shapes
        for (pair in extra_pairs) {
            for (a in base_annotations) {
                a$xref <- pair$x
                a$yref <- pair$y
                all_annotations[[length(all_annotations) + 1]] <- a
            }
            for (s in base_shapes) {
                s$xref <- pair$x
                s$yref <- pair$y
                all_shapes[[length(all_shapes) + 1]] <- s
            }
        }
    }

    list(annotations = all_annotations, shapes = all_shapes)
}


#' Apply statistical annotation shapes and annotations to a plotly figure
#'
#' Appends the shapes and annotations from [create_stat_annotations()] to
#' an existing plotly figure's layout. Adjusts the y-axis range to accommodate
#' the annotation brackets.
#'
#' @param fig A plotly figure object.
#' @param stat_result List with `annotations`, `shapes`, and `y.max` as returned
#'   by [create_stat_annotations()].
#' @param y.min Numeric or NULL; minimum y-axis value. If NULL, the existing
#'   y-axis range is preserved.
#'
#' @return The modified plotly figure.
#'
#' @examples
#' stats_df <- compute_pairwise_stats(
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     test = "wilcox.test"
#' )
#' fig <- plotly::plot_ly(
#'     data = example_iris, x = ~Species, y = ~Sepal.Length, type = "box"
#' )
#' stat_result <- create_stat_annotations(
#'     stats_df = stats_df,
#'     fig = fig,
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     display = "symbol"
#' )
#' apply_stat_annotations(fig, stat_result)
#'
#' @author Jared Andrews
#' @export
apply_stat_annotations <- function(fig, stat_result, y.min = NULL) {
    if (length(stat_result$annotations) == 0 && length(stat_result$shapes) == 0) {
        return(fig)
    }

    # Append new shapes to any existing shapes
    existing_shapes <- fig$x$layout$shapes
    if (is.null(existing_shapes)) existing_shapes <- list()
    fig$x$layout$shapes <- c(existing_shapes, stat_result$shapes)

    # Append new annotations to any existing annotations
    existing_annots <- fig$x$layout$annotations
    if (is.null(existing_annots)) existing_annots <- list()
    fig$x$layout$annotations <- c(existing_annots, stat_result$annotations)

    # Adjust y-axis range to accommodate brackets on ALL y-axes
    if (!is.null(stat_result$y.max)) {
        y_axis_names <- grep("^yaxis", names(fig$x$layout), value = TRUE)
        if (length(y_axis_names) == 0) y_axis_names <- "yaxis"

        for (yax_name in y_axis_names) {
            existing_yaxis <- fig$x$layout[[yax_name]]
            if (is.null(existing_yaxis)) existing_yaxis <- list()

            y_lo <- y.min
            if (is.null(y_lo) && !is.null(existing_yaxis$range)) {
                y_lo <- existing_yaxis$range[1]
            }
            if (!is.null(y_lo)) {
                y_span <- stat_result$y.max - y_lo
                y_lo <- y_lo - y_span * 0.02
            }
            existing_yaxis$range <- c(y_lo, stat_result$y.max)
            fig$x$layout[[yax_name]] <- existing_yaxis
        }
    }

    fig
}


#' Generate comparison pair strings from data columns
#'
#' Creates formatted pair strings for populating the comparison selector UI.
#' Handles both standard x-axis comparisons and nested group.by comparisons.
#'
#' @param df Data frame containing the data.
#' @param x Character; x-axis column name.
#' @param group.by Character or NULL; nested grouping column.
#'
#' @return A character vector of pair strings in "group1 vs group2" format.
#'
#' @importFrom utils combn
#'
#' @examples
#' generate_pair_strings(example_iris, x = "Species")
#'
#' @author Jared Andrews
#' @export
generate_pair_strings <- function(df, x, group.by = NULL) {
    if (!is.null(group.by) && nzchar(group.by) && group.by %in% names(df)) {
        grp_levels <- unique(as.character(df[[group.by]]))
        if (length(grp_levels) < 2) {
            return(character(0))
        }
        pairs_list <- combn(grp_levels, 2, simplify = FALSE)
    } else {
        x_levels <- unique(as.character(df[[x]]))
        if (length(x_levels) < 2) {
            return(character(0))
        }
        pairs_list <- combn(x_levels, 2, simplify = FALSE)
    }
    vapply(pairs_list, paste, character(1), collapse = " vs ")
}


#' Parse pair strings from UI into list of length-2 vectors
#'
#' Converts the "group1 vs group2" strings from the comparison selector
#' back into a list of length-2 character vectors for [compute_pairwise_stats()].
#'
#' @param pair_strings Character vector of pair strings from UI input.
#'
#' @return A list of length-2 character vectors, or NULL if input is empty.
#'
#' @examples
#' parse_pair_strings(c("setosa vs versicolor", "versicolor vs virginica"))
#'
#' @author Jared Andrews
#' @export
parse_pair_strings <- function(pair_strings) {
    if (is.null(pair_strings) || length(pair_strings) == 0 ||
        all(!nzchar(pair_strings))) {
        return(NULL)
    }
    pair_strings <- pair_strings[nzchar(pair_strings)]
    lapply(strsplit(pair_strings, " vs "), trimws)
}


#' Write stats table CSV with metadata header
#'
#' Writes the stats data frame to a CSV file with a metadata header block
#' containing the p-value correction method, significance threshold, and
#' symbol legend.
#'
#' @param stats_df Data frame from [compute_pairwise_stats()], or NULL.
#' @param file Character; path to the output file.
#' @param p.adjust.method Character; p-value correction method used.
#' @param sig.threshold Numeric; significance threshold used for `*` vs `ns`.
#' @param sig.levels Named numeric vector; the multi-star thresholds passed to
#'   [compute_pairwise_stats()]. Used to generate the symbol legend in the
#'   header. Default `c("****" = 0.0001, "***" = 0.001, "**" = 0.01)`.
#'
#' @return Called for side effects; writes to `file`.
#'
#' @importFrom utils write.csv
#'
#' @examples
#' stats_df <- compute_pairwise_stats(
#'     df = example_iris,
#'     x = "Species",
#'     y = "Sepal.Length",
#'     test = "wilcox.test"
#' )
#' tmp <- tempfile(fileext = ".csv")
#' write_stats_csv(stats_df, tmp)
#' file.remove(tmp)
#'
#' @author Jared Andrews
#' @export
write_stats_csv <- function(stats_df, file, p.adjust.method = "holm",
                            sig.threshold = 0.05,
                            sig.levels = c("****" = 0.0001, "***" = 0.001, "**" = 0.01)) {
    if (is.null(stats_df) || nrow(stats_df) == 0) {
        writeLines("No stats computed. Enable stats and update the plot first.", file)
        return(invisible(NULL))
    }

    # Build symbol legend lines from sig.levels (sorted most to least significant)
    sig_lines <- vapply(
        names(sort(sig.levels)),
        function(nm) sprintf("#   %-4s : p <= %s", nm, sig.levels[[nm]]),
        character(1)
    )

    # Build metadata header lines
    header <- c(
        paste0("# P-value adjustment method: ", p.adjust.method),
        paste0("# Significance threshold: ", sig.threshold),
        "#",
        "# Significance symbols:",
        sig_lines,
        paste0("#   *    : p <= ", sig.threshold),
        paste0("#   ns   : p > ", sig.threshold),
        "#"
    )

    # Add correction method column to the data
    stats_df$p.adjust.method <- p.adjust.method

    # Reorder columns for clarity
    col_order <- c(
        "group1", "group2", "test", "p.value", "p.adjust.method",
        "p.adj", "p.signif"
    )
    extra_cols <- setdiff(names(stats_df), col_order)
    stats_df <- stats_df[, c(col_order, extra_cols), drop = FALSE]

    # Write header + CSV
    con <- file(file, open = "wt")
    on.exit(close(con))
    writeLines(header, con)
    write.csv(stats_df, con, row.names = FALSE)
    invisible(NULL)
}
