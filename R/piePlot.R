#' Create a plotly pie chart
#'
#' @param df A data frame where each row already represents a summarized slice
#'   (e.g., counts per category) with label and value columns.
#' @param labels Name of the column to use for the slice labels.
#' @param values Name of the column to use for the aggregated values.
#' @param colors Optional character vector of hex colors for the slices.
#'   If named, values are matched to the values in `labels`; otherwise colours
#'   are recycled in data order.
#' @param palette Optional character vector of fallback colors used when
#'   `colors` is not supplied or missing values are present.
#' @param hole A numeric value between 0 and 1 for the hole size
#'   (0 for pie, >0 for donut).
#' @param textinfo A character string for the text info to show.
#'   Any combination of "label", "text", "value", "percent" joined with a "+"
#'   or "none".
#' @param textposition Position of the text relative to the slice: "auto",
#'   "inside", "outside", or "none".
#' @param insidetextorientation Orientation for inside text: "auto", "horizontal",
#'   "radial", or "tangential".
#' @param sort Logical, whether to sort slices by their values.
#' @param direction Direction of slices: "counterclockwise" or "clockwise".
#' @param rotation Starting angle of the first slice in degrees.
#' @param show.legend Logical, whether to display the legend.
#' @param legend.orientation Legend orientation, either "h" (horizontal) or "v" (vertical).
#' @param legend.x,legend.y Numeric legend position offsets.
#' @param legend.font.family,legend.font.size,legend.font.color Font settings for the legend text.
#' @param title.text Plot title text.
#' @param title.font.family,title.font.size,title.font.color Font settings for the title text.
#' @param title.x Horizontal position for the plot title (0 = left, 1 = right).
#' @param text.font.family,text.font.size,text.font.color Font settings for the slice labels.
#' @param slice.line.color,slice.line.width Border styling for the slices.
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
