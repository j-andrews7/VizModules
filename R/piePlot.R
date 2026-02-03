#' Create a plotly pie chart
#'
#' @param df A data frame where each row already represents a summarized slice
#'   (e.g., counts per category) with label and value columns.
#' @param labels Character, name of the column to use for the slice labels.
#' @param values Character, name of the column to use for the aggregated values (slice sizes).
#' @param colors Optional character vector of hex colors for the slices.
#'   If named, values are matched to the values in \code{labels}; otherwise colours
#'   are recycled in data order.
#' @param palette Optional character vector of fallback colors used when
#'   \code{colors} is not supplied or missing values are present.
#' @param hole Numeric value between 0 and 1 for the hole size
#'   (0 for pie chart, >0 for donut chart). Default: 0.
#' @param textinfo Character string specifying the text info to show on slices.
#'   Any combination of "label", "text", "value", "percent" joined with a "+"
#'   (e.g., "label+percent") or "none" to hide text. Default: "label+percent".
#' @param textposition Character, position of the text relative to the slice.
#'   Options: "auto", "inside", "outside", or "none". Default: "auto".
#' @param insidetextorientation Character, orientation for inside text.
#'   Options: "auto", "horizontal", "radial", or "tangential". Default: "auto".
#' @param sort Logical, whether to sort slices by their values in descending order. Default: TRUE.
#' @param direction Character, direction of slice progression. Options: "counterclockwise" or "clockwise". Default: "counterclockwise".
#' @param rotation Numeric, starting angle of the first slice in degrees (0-360). Default: 0.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param legend.orientation Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".
#' @param legend.x Numeric, horizontal legend position offset (0-1, where 0=left, 1=right). Default: 0.5.
#' @param legend.y Numeric, vertical legend position offset (-1 to 1). Default: -0.1.
#' @param legend.font.family Character, font family for the legend text. Default: "Arial".
#' @param legend.font.size Numeric, font size for the legend text. Default: 12.
#' @param legend.font.color Character, hex color for the legend text. Default: "#000000".
#' @param title.text Character, main plot title text. Default: "".
#' @param title.font.family Character, font family for the title text. Default: "Arial".
#' @param title.font.size Numeric, font size for the title text. Default: 18.
#' @param title.font.color Character, hex color for the title text. Default: "#000000".
#' @param title.x Numeric, horizontal position for the plot title (0-1, where 0=left, 0.5=center, 1=right). Default: 0.5.
#' @param text.font.family Character, font family for the slice labels. Default: "Arial".
#' @param text.font.size Numeric, font size for the slice labels. Default: 12.
#' @param text.font.color Character, hex color for the slice labels. Default: "#000000".
#' @param slice.line.color Character, hex color for slice borders. Default: "#FFFFFF" (white).
#' @param slice.line.width Numeric, width of slice borders in pixels. Set to 0 for no borders. Default: 0.
#'
#' @examples
#' status_counts <- data.frame(
#'     status = c("Upregulated", "Downregulated", "Not significant"),
#'     n = c(12, 7, 3)
#' )
#'
#' piePlot(
#'     df = status_counts,
#'     labels = "status",
#'     values = "n",
#'     palette = c("#1B9E77", "#D95F02", "#7570B3"),
#'     sort = FALSE,
#'     title.text = "Genes by status"
#' )
#'
#' @return A plotly object.
#'
#' @importFrom stats reformulate
#' @import plotly
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlot <- function(df, labels, values,
                    colors = NULL,
                    palette = NULL,
                    hole = 0,
                    textinfo = "label+percent",
                    textposition = "auto",
                    insidetextorientation = "auto",
                    sort = TRUE,
                    direction = "counterclockwise",
                    rotation = 0,
                    show.legend = TRUE,
                    legend.orientation = "h",
                    legend.x = 0.5,
                    legend.y = -0.1,
                    legend.font.family = "Arial",
                    legend.font.size = 12,
                    legend.font.color = "#000000",
                    title.text = "",
                    title.font.family = "Arial",
                    title.font.size = 18,
                    title.font.color = "#000000",
                    title.x = 0.5,
                    text.font.family = "Arial",
                    text.font.size = 12,
                    text.font.color = "#000000",
                    slice.line.color = "#FFFFFF",
                    slice.line.width = 0) {
    stopifnot(is.data.frame(df))

    if (!labels %in% names(df)) {
        stop("`labels` must refer to a column in `df`.")
    }
    if (!values %in% names(df)) {
        stop("`values` must refer to a column in `df`.")
    }

    label_values <- as.character(df[[labels]])

    # Establish a fallback palette so colours are always available
    fallback_palette <- palette
    if (is.null(fallback_palette)) {
        fallback_palette <- tryCatch(plotthis::palette_list[[1]], error = function(...) NULL)
    }
    if (is.null(fallback_palette)) {
        fallback_palette <- default_palettes()$choices$Defaults$dittoColors
    }
    if (is.null(fallback_palette) || length(fallback_palette) == 0) {
        fallback_palette <- "#1F77B4"
    }
    fallback_palette <- unname(fallback_palette)

    colour_vector <- colors
    if (is.null(colour_vector) || length(colour_vector) == 0) {
        colour_vector <- rep_len(fallback_palette, length(label_values))
    } else if (!is.null(names(colour_vector)) && any(nzchar(names(colour_vector)))) {
        mapped <- colour_vector[match(label_values, names(colour_vector))]
        missing_map <- is.na(mapped)
        if (any(missing_map)) {
            mapped[missing_map] <- rep_len(fallback_palette, sum(missing_map))
        }
        colour_vector <- mapped
    } else {
        colour_vector <- rep_len(colour_vector, length(label_values))
    }

    hole <- min(max(hole, 0), 0.99)

    fig <- plot_ly(
        data = df,
        type = "pie",
        labels = reformulate(labels),
        values = reformulate(values),
        hole = hole,
        sort = sort,
        direction = direction,
        rotation = rotation,
        textinfo = textinfo,
        textposition = textposition,
        insidetextorientation = insidetextorientation,
        marker = list(
            colors = colour_vector,
            line = list(color = slice.line.color, width = slice.line.width)
        ),
        textfont = list(
            family = text.font.family,
            size = text.font.size,
            color = text.font.color
        )
    )

    fig <- layout(
        fig,
        title = list(
            text = title.text,
            font = list(
                family = title.font.family,
                size = title.font.size,
                color = title.font.color
            ),
            x = title.x,
            xanchor = "center",
            y = 0.95,
            yanchor = "top",
            pad = list(t = 20)
        ),
        margin = list(t = 80),
        showlegend = show.legend,
        legend = list(
            orientation = legend.orientation,
            x = legend.x,
            y = legend.y,
            font = list(
                family = legend.font.family,
                size = legend.font.size,
                color = legend.font.color
            )
        )
    )

    return(fig)
}
