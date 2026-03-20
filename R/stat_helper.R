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
#' @param sig.threshold Numeric; significance threshold. P-values above this
#'   are labeled "ns". Default 0.05.
#'
#' @return A data.frame with columns: `group1`, `group2`, `p.value`, `p.adj`,
#'   `p.signif`, `test`, `facet_level`, `x_level` (when `group.by` is set).
#'
#' @importFrom stats wilcox.test t.test kruskal.test aov p.adjust
#'
#' @author Jared Andrews, Jacob Martin
#' @rdname INTERNAL_compute_pairwise_stats
#' @keywords internal
.compute_pairwise_stats <- function(df, x, y,
                                    pairs = NULL,
                                    test = "wilcox.test",
                                    p.adjust.method = "holm",
                                    paired = FALSE,
                                    group.by = NULL,
                                    facet.by = NULL,
                                    per.facet = TRUE,
                                    sig.threshold = 0.05) {
    # Helper to run a single test on two vectors
    .run_test <- function(vals1, vals2, test_type, paired_test) {
        if (length(vals1) < 2 || length(vals2) < 2) return(NA_real_)
        tryCatch({
            result <- switch(test_type,
                "wilcox.test" = stats::wilcox.test(vals1, vals2, paired = paired_test),
                "t.test" = stats::t.test(vals1, vals2, paired = paired_test),
                stop("Unsupported pairwise test: ", test_type)
            )
            result$p.value
        }, error = function(e) NA_real_)
    }

    # Helper to convert p-value to significance symbol
    .p_to_signif <- function(p) {
        ifelse(is.na(p), "NA",
            ifelse(p <= 0.0001, "****",
                ifelse(p <= 0.001, "***",
                    ifelse(p <= 0.01, "**",
                        ifelse(p <= sig.threshold, "*", "ns")))))
    }

    # Core function to compute stats for a single data subset
    .compute_for_subset <- function(sub_df, facet_level = NA_character_) {
        if (test %in% c("kruskal.test", "anova")) {
            return(.compute_omnibus(sub_df, facet_level))
        }
        return(.compute_pairwise(sub_df, facet_level))
    }

    # Omnibus tests (kruskal, anova) - one result per x-level or overall
    .compute_omnibus <- function(sub_df, facet_level) {
        if (!is.null(group.by) && nzchar(group.by)) {
            # Test group.by levels within each x-level
            x_levels <- unique(as.character(sub_df[[x]]))
            results <- lapply(x_levels, function(xlev) {
                x_sub <- sub_df[as.character(sub_df[[x]]) == xlev, ]
                grp_vals <- as.character(x_sub[[group.by]])
                if (length(unique(grp_vals)) < 2) return(NULL)
                p_val <- tryCatch({
                    if (test == "kruskal.test") {
                        stats::kruskal.test(x_sub[[y]] ~ factor(x_sub[[group.by]]))$p.value
                    } else {
                        summary(stats::aov(as.formula(paste0("`", y, "` ~ factor(`", group.by, "`)")),
                            data = x_sub))[[1]][["Pr(>F)"]][1]
                    }
                }, error = function(e) NA_real_)
                data.frame(
                    group1 = "all", group2 = "all", p.value = p_val,
                    test = test, facet_level = facet_level, x_level = xlev,
                    stringsAsFactors = FALSE
                )
            })
            do.call(rbind, Filter(Negate(is.null), results))
        } else {
            # Test across x-levels overall
            if (length(unique(as.character(sub_df[[x]]))) < 2) return(NULL)
            p_val <- tryCatch({
                if (test == "kruskal.test") {
                    stats::kruskal.test(sub_df[[y]] ~ factor(sub_df[[x]]))$p.value
                } else {
                    summary(stats::aov(as.formula(paste0("`", y, "` ~ factor(`", x, "`)")),
                        data = sub_df))[[1]][["Pr(>F)"]][1]
                }
            }, error = function(e) NA_real_)
            data.frame(
                group1 = "all", group2 = "all", p.value = p_val,
                test = test, facet_level = facet_level, x_level = NA_character_,
                stringsAsFactors = FALSE
            )
        }
    }

    # Pairwise tests (wilcox, t-test)
    .compute_pairwise <- function(sub_df, facet_level) {
        if (!is.null(group.by) && nzchar(group.by)) {
            # Compare group.by levels within each x-level
            x_levels <- unique(as.character(sub_df[[x]]))
            grp_levels <- unique(as.character(sub_df[[group.by]]))
            if (length(grp_levels) < 2) return(NULL)

            grp_pairs <- if (!is.null(pairs)) {
                pairs
            } else {
                utils::combn(grp_levels, 2, simplify = FALSE)
            }

            results <- lapply(x_levels, function(xlev) {
                x_sub <- sub_df[as.character(sub_df[[x]]) == xlev, ]
                pair_results <- lapply(grp_pairs, function(pr) {
                    vals1 <- x_sub[as.character(x_sub[[group.by]]) == pr[1], y]
                    vals2 <- x_sub[as.character(x_sub[[group.by]]) == pr[2], y]
                    p_val <- .run_test(vals1, vals2, test, paired)
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
            # Standard: compare x-levels pairwise
            x_levels <- unique(as.character(sub_df[[x]]))
            if (length(x_levels) < 2) return(NULL)

            test_pairs <- if (!is.null(pairs)) {
                pairs
            } else {
                utils::combn(x_levels, 2, simplify = FALSE)
            }

            results <- lapply(test_pairs, function(pr) {
                vals1 <- sub_df[as.character(sub_df[[x]]) == pr[1], y]
                vals2 <- sub_df[as.character(sub_df[[x]]) == pr[2], y]
                p_val <- .run_test(vals1, vals2, test, paired)
                data.frame(
                    group1 = pr[1], group2 = pr[2], p.value = p_val,
                    test = test, facet_level = facet_level, x_level = NA_character_,
                    stringsAsFactors = FALSE
                )
            })
            do.call(rbind, results)
        }
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
    stats_df$p.adj <- stats::p.adjust(stats_df$p.value, method = p.adjust.method)
    stats_df$p.signif <- .p_to_signif(stats_df$p.adj)
    stats_df
}


#' Create plotly shapes and annotations for statistical test results
#'
#' Converts results from [.compute_pairwise_stats()] into plotly-compatible
#' shapes (brackets) and annotations (text labels). Sorts comparisons so that
#' small-gap brackets are closest to the data and large-gap brackets are higher.
#'
#' @param stats_df Data frame from [.compute_pairwise_stats()].
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
#' @author Jared Andrews, Jacob Martin
#' @rdname INTERNAL_create_stat_annotations
#' @keywords internal
.create_stat_annotations <- function(stats_df, fig, df, x, y,
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

    if (is.null(stats_df) || nrow(stats_df) == 0) return(empty_result)

    # Filter non-significant if requested
    if (hide.ns) {
        stats_df <- stats_df[!is.na(stats_df$p.adj) & stats_df$p.adj <= sig.threshold, ]
        if (nrow(stats_df) == 0) return(empty_result)
    }

    # Remove omnibus tests (kruskal/anova) - they don't have pairwise brackets
    omnibus_df <- stats_df[stats_df$group1 == "all", ]
    pairwise_df <- stats_df[stats_df$group1 != "all", ]

    all_annotations <- list()
    all_shapes <- list()

    # --- Omnibus test annotation (ANOVA / Kruskal-Wallis) ---
    # Place a single draggable text annotation in the bottom-left using paper coords.
    if (nrow(omnibus_df) > 0) {
        # Build a combined label from all omnibus results
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

        all_annotations[[length(all_annotations) + 1]] <- list(
            text = omnibus_text,
            x = 0.01, y = -0.12,
            xref = "paper", yref = "paper",
            xanchor = "left", yanchor = "top",
            showarrow = FALSE,
            font = list(size = font.size - 1, color = line.color),
            captureevents = TRUE
        )
    }

    if (nrow(pairwise_df) == 0) {
        return(list(annotations = all_annotations, shapes = all_shapes, y.max = NULL))
    }

    # Determine x-axis order (1-based for ggplotly categorical axes)
    if (is.null(x.order)) {
        col_data <- df[[x]]
        x.order <- if (is.factor(col_data)) levels(col_data) else unique(as.character(col_data))
    }

    # Y-axis range from data
    v_min <- min(df[[y]], na.rm = TRUE)
    v_max <- max(df[[y]], na.rm = TRUE)
    v_range <- v_max - v_min
    v_unit <- v_range * step.increase
    bump <- v_range * text.bump
    tick_height <- v_range * 0.02
    global_y_max <- v_max

    # Helper to get x-position for a group label.
    # ggplotly categorical axes use 1-based numeric positions (like R factors).
    .get_x_pos <- function(group_label, x_level = NA) {
        if (!is.null(group.by) && nzchar(group.by) && !is.na(x_level)) {
            # Nested grouping: position within the x-level category
            x_idx <- match(x_level, x.order)  # 1-based
            grp_levels <- unique(as.character(df[[group.by]]))
            n_grps <- length(grp_levels)
            grp_idx <- match(group_label, grp_levels) - 1
            if (n_grps == 1) return(x_idx)
            offset <- (grp_idx / (n_grps - 1) - 0.5) * 0.8
            x_idx + offset
        } else {
            match(group_label, x.order)  # 1-based
        }
    }

    # Build facet-level to axis-pair mapping from the plotly figure.
    # ggplotly stores facet strip labels as layout annotations with xref="paper".
    # In multi-row layouts, strip labels sit at different y-positions matching
    # the top of the corresponding yaxis domain. We perform a 2D match:
    #   strip x-position -> closest xaxis column (by domain midpoint)
    #   strip y-position -> closest yaxis row (by domain top)
    # Then convert layout names (xaxis2, yaxis) to trace refs (x2, y).
    facet_axis_map <- list()
    if (!is.null(facet.by) && nzchar(facet.by) && !is.null(fig)) {
        layout <- fig$x$layout

        # Collect all x-axes with domain midpoints
        # Layout names: xaxis, xaxis2, xaxis3, ... -> trace refs: x, x2, x3, ...
        x_axes <- list()
        y_axes <- list()
        for (nm in names(layout)) {
            if (grepl("^xaxis", nm)) {
                ax <- layout[[nm]]
                if (!is.null(ax$domain)) {
                    # Convert layout name to trace ref: "xaxis" -> "x", "xaxis2" -> "x2"
                    trace_ref <- sub("^xaxis", "x", nm)
                    mid <- (ax$domain[1] + ax$domain[2]) / 2
                    x_axes[[trace_ref]] <- mid
                }
            } else if (grepl("^yaxis", nm)) {
                ax <- layout[[nm]]
                if (!is.null(ax$domain)) {
                    trace_ref <- sub("^yaxis", "y", nm)
                    domain_top <- ax$domain[2]
                    y_axes[[trace_ref]] <- domain_top
                }
            }
        }

        # Find strip label annotations (xref="paper", yref="paper")
        # Axis labels (x/y titles) are at (0.5, 0) or (0, 0.5) - skip those.
        # Strip labels have x near a column midpoint and y near a row top.
        annots <- layout$annotations
        if (!is.null(annots) && length(x_axes) > 0 && length(y_axes) > 0) {
            for (a in annots) {
                if (is.null(a$xref) || a$xref != "paper") next
                if (is.null(a$text) || !nzchar(a$text)) next
                # Skip axis title annotations (at edges: x~0 or y~0)
                if (isTRUE(a$x == 0) || isTRUE(a$y == 0)) next

                # Match x-position to closest xaxis column
                best_x <- NULL
                best_x_dist <- Inf
                for (xref in names(x_axes)) {
                    dist <- abs(x_axes[[xref]] - a$x)
                    if (dist < best_x_dist) {
                        best_x_dist <- dist
                        best_x <- xref
                    }
                }

                # Match y-position to closest yaxis row (by domain top)
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
        }
    }

    # Process by facet level if applicable
    facet_levels <- unique(pairwise_df$facet_level)
    if (all(is.na(facet_levels))) facet_levels <- NA_character_

    all_annotations <- list()
    all_shapes <- list()
    global_y_max <- v_max

    for (flev in facet_levels) {
        if (is.na(flev)) {
            facet_rows <- pairwise_df[is.na(pairwise_df$facet_level), ]
            yref <- "y"
            xref <- "x"
        } else {
            facet_rows <- pairwise_df[!is.na(pairwise_df$facet_level) &
                pairwise_df$facet_level == flev, ]
            # Look up axis pair for this facet level
            if (length(facet_axis_map) > 0 && flev %in% names(facet_axis_map)) {
                xref <- facet_axis_map[[flev]]$x
                yref <- facet_axis_map[[flev]]$y
            } else {
                xref <- "x"
                yref <- "y"
            }
        }

        if (nrow(facet_rows) == 0) next

        # Calculate gap for each comparison and sort (small gaps first = closest to data)
        facet_rows$x0_pos <- mapply(.get_x_pos, facet_rows$group1, facet_rows$x_level)
        facet_rows$x1_pos <- mapply(.get_x_pos, facet_rows$group2, facet_rows$x_level)
        facet_rows$gap <- abs(facet_rows$x1_pos - facet_rows$x0_pos)
        facet_rows <- facet_rows[order(facet_rows$gap), ]

        # Compute inset endpoints: shrink each bracket by a fixed amount on each side
        facet_rows$x0_raw <- pmin(facet_rows$x0_pos, facet_rows$x1_pos)
        facet_rows$x1_raw <- pmax(facet_rows$x0_pos, facet_rows$x1_pos)
        facet_rows$x0_draw <- facet_rows$x0_raw + bracket.inset
        facet_rows$x1_draw <- facet_rows$x1_raw - bracket.inset

        # Assign y-levels using interval packing within gap groups.
        # Within each gap group, pack brackets onto the fewest y-levels
        # by checking x-range overlap (with the drawn/inset positions).
        gap_groups <- unique(facet_rows$gap)
        # y_levels tracks occupied x-intervals per level (list of lists)
        # Each level is a list of c(x0, x1) intervals already placed there.
        y_levels <- list()
        facet_rows$y_level <- NA_integer_

        for (gg in gap_groups) {
            group_idx <- which(facet_rows$gap == gg)
            for (idx in group_idx) {
                bx0 <- facet_rows$x0_draw[idx]
                bx1 <- facet_rows$x1_draw[idx]
                placed <- FALSE
                for (lev in seq_along(y_levels)) {
                    # Check if this bracket overlaps any existing interval on this level
                    overlaps <- FALSE
                    for (interval in y_levels[[lev]]) {
                        if (bx0 < interval[2] && bx1 > interval[1]) {
                            overlaps <- TRUE
                            break
                        }
                    }
                    if (!overlaps) {
                        y_levels[[lev]][[length(y_levels[[lev]]) + 1]] <- c(bx0, bx1)
                        facet_rows$y_level[idx] <- lev
                        placed <- TRUE
                        break
                    }
                }
                if (!placed) {
                    y_levels[[length(y_levels) + 1]] <- list(c(bx0, bx1))
                    facet_rows$y_level[idx] <- length(y_levels)
                }
            }
        }

        # Draw brackets at their assigned y-levels
        for (i in seq_len(nrow(facet_rows))) {
            row <- facet_rows[i, ]
            y_bar <- v_max + v_unit * row$y_level

            x0 <- row$x0_draw
            x1 <- row$x1_draw
            x_mid <- (x0 + x1) / 2

            # Determine label text
            label <- switch(display,
                "symbol" = row$p.signif,
                "p.value" = if (is.na(row$p.value)) "NA" else format(round(row$p.value, 4), scientific = FALSE),
                "p.adj" = if (is.na(row$p.adj)) "NA" else format(round(row$p.adj, 4), scientific = FALSE)
            )

            # Create shapes based on bracket style
            if (bracket.style == "capped") {
                # Left vertical tick
                all_shapes[[length(all_shapes) + 1]] <- list(
                    type = "line",
                    line = list(color = line.color, width = line.width),
                    xref = xref, yref = yref,
                    x0 = x0, x1 = x0,
                    y0 = y_bar - tick_height, y1 = y_bar
                )
                # Horizontal bar
                all_shapes[[length(all_shapes) + 1]] <- list(
                    type = "line",
                    line = list(color = line.color, width = line.width),
                    xref = xref, yref = yref,
                    x0 = x0, x1 = x1,
                    y0 = y_bar, y1 = y_bar
                )
                # Right vertical tick
                all_shapes[[length(all_shapes) + 1]] <- list(
                    type = "line",
                    line = list(color = line.color, width = line.width),
                    xref = xref, yref = yref,
                    x0 = x1, x1 = x1,
                    y0 = y_bar - tick_height, y1 = y_bar
                )
            } else {
                # Flat: single horizontal line
                all_shapes[[length(all_shapes) + 1]] <- list(
                    type = "line",
                    line = list(color = line.color, width = line.width),
                    xref = xref, yref = yref,
                    x0 = x0, x1 = x1,
                    y0 = y_bar, y1 = y_bar
                )
            }

            # Text annotation above the bracket
            all_annotations[[length(all_annotations) + 1]] <- list(
                text = label,
                x = x_mid, y = y_bar + bump,
                xref = xref, yref = yref,
                showarrow = FALSE,
                font = list(size = font.size, color = line.color)
            )

            top <- y_bar + bump
            if (top > global_y_max) global_y_max <- top
        }
    }

    global_y_max <- global_y_max + v_unit

    # When faceting exists but per-facet is disabled (all facet_levels are NA),
    # replicate the annotations/shapes onto every subplot panel.
    if (length(facet_axis_map) > 0 && all(is.na(unique(pairwise_df$facet_level)))) {
        # Get unique axis pairs from the facet map (skip the first = default x/y)
        axis_pairs <- unique(lapply(facet_axis_map, function(p) p))
        # Remove the default pair already used (x/y)
        extra_pairs <- Filter(function(p) !(p$x == "x" && p$y == "y"), axis_pairs)

        if (length(extra_pairs) > 0) {
            # Copy existing annotations/shapes to each extra panel
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
    }

    list(annotations = all_annotations, shapes = all_shapes, y.max = global_y_max)
}


#' Apply statistical annotation shapes and annotations to a plotly figure
#'
#' Appends the shapes and annotations from [.create_stat_annotations()] to
#' an existing plotly figure's layout. Adjusts the y-axis range to accommodate
#' the annotation brackets.
#'
#' @param fig A plotly figure object.
#' @param stat_result List with `annotations`, `shapes`, and `y.max` as returned
#'   by [.create_stat_annotations()].
#' @param y.min Numeric or NULL; minimum y-axis value. If NULL, the existing
#'   y-axis range is preserved.
#'
#' @return The modified plotly figure.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_apply_stat_annotations
#' @keywords internal
.apply_stat_annotations <- function(fig, stat_result, y.min = NULL) {
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
    # (faceted plots have yaxis, yaxis2, etc. - one per row)
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
            # Add a small buffer below the minimum so whiskers/points don't
            # sit flush against the bottom edge (plotly's auto-padding is
            # lost when we set an explicit range).
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
#' @author Jared Andrews
#' @rdname INTERNAL_generate_pair_strings
#' @keywords internal
.generate_pair_strings <- function(df, x, group.by = NULL) {
    if (!is.null(group.by) && nzchar(group.by) && group.by %in% names(df)) {
        grp_levels <- unique(as.character(df[[group.by]]))
        if (length(grp_levels) < 2) return(character(0))
        pairs_list <- utils::combn(grp_levels, 2, simplify = FALSE)
    } else {
        x_levels <- unique(as.character(df[[x]]))
        if (length(x_levels) < 2) return(character(0))
        pairs_list <- utils::combn(x_levels, 2, simplify = FALSE)
    }
    vapply(pairs_list, paste, character(1), collapse = " vs ")
}


#' Parse pair strings from UI into list of length-2 vectors
#'
#' Converts the "group1 vs group2" strings from the comparison selector
#' back into a list of length-2 character vectors for [.compute_pairwise_stats()].
#'
#' @param pair_strings Character vector of pair strings from UI input.
#'
#' @return A list of length-2 character vectors, or NULL if input is empty.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_parse_pair_strings
#' @keywords internal
.parse_pair_strings <- function(pair_strings) {
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
#' @param stats_df Data frame from [.compute_pairwise_stats()], or NULL.
#' @param file Character; path to the output file.
#' @param p.adjust.method Character; p-value correction method used.
#' @param sig.threshold Numeric; significance threshold used.
#'
#' @return Called for side effects; writes to `file`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_write_stats_csv
#' @keywords internal
.write_stats_csv <- function(stats_df, file, p.adjust.method = "holm",
                             sig.threshold = 0.05) {
    if (is.null(stats_df) || nrow(stats_df) == 0) {
        writeLines("No stats computed. Enable stats and update the plot first.", file)
        return(invisible(NULL))
    }

    # Build metadata header lines
    header <- c(
        paste0("# P-value adjustment method: ", p.adjust.method),
        paste0("# Significance threshold: ", sig.threshold),
        "#",
        "# Significance symbols:",
        "#   **** : p <= 0.0001",
        "#   ***  : p <= 0.001",
        "#   **   : p <= 0.01",
        paste0("#   *    : p <= ", sig.threshold),
        paste0("#   ns   : p > ", sig.threshold),
        "#"
    )

    # Add correction method column to the data
    stats_df$p.adjust.method <- p.adjust.method

    # Reorder columns for clarity
    col_order <- c("group1", "group2", "test", "p.value", "p.adjust.method",
                   "p.adj", "p.signif")
    extra_cols <- setdiff(names(stats_df), col_order)
    stats_df <- stats_df[, c(col_order, extra_cols), drop = FALSE]

    # Write header + CSV
    con <- file(file, open = "wt")
    on.exit(close(con))
    writeLines(header, con)
    utils::write.csv(stats_df, con, row.names = FALSE)
    invisible(NULL)
}
