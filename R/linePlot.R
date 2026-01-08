#' Apply axis styling to all subplot axes in a plotly figure
#'
#' When using plotly subplots (e.g., via split.by in dittoViz), axis styling
#' must be applied to all subplot axes (xaxis, xaxis2, xaxis3, etc.) individually.
#' This helper function detects how many subplots exist and applies the provided
#' axis styling to all of them.
#'
#' @param fig A plotly figure object.
#' @param xaxis_style A named list of axis styling parameters for x-axes.
#' @param yaxis_style A named list of axis styling parameters for y-axes.
#'
#' @return The modified plotly figure with axis styling applied to all subplots.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_apply_subplot_axis_styling
#' @keywords internal
.apply_subplot_axis_styling <- function(fig, xaxis_style, yaxis_style) {
    # Extract the layout to determine how many subplots exist
    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    layout_names <- names(fig$x$layout)
    
    # Handle empty layout
    if (is.null(layout_names) || length(layout_names) == 0) {
        return(fig)
    }

    # Find all xaxis and yaxis entries (xaxis, xaxis2, xaxis3, etc.)
    xaxis_names <- grep("^xaxis[0-9]*$", layout_names, value = TRUE)
    yaxis_names <- grep("^yaxis[0-9]*$", layout_names, value = TRUE)

    # If no subplot x-axes detected, apply to main xaxis
    if (length(xaxis_names) == 0) {
        xaxis_names <- "xaxis"
    }
    
    # If no subplot y-axes detected, apply to main yaxis
    if (length(yaxis_names) == 0) {
        yaxis_names <- "yaxis"
    }

    # Build a list of layout updates
    layout_updates <- list()

    # Apply x-axis styling to all x-axes
    for (xaxis_name in xaxis_names) {
        # Preserve existing axis properties and merge with new styling
        existing_axis <- fig$x$layout[[xaxis_name]]
        if (!is.null(existing_axis)) {
            layout_updates[[xaxis_name]] <- modifyList(existing_axis, xaxis_style)
        } else {
            layout_updates[[xaxis_name]] <- xaxis_style
        }
    }

    # Apply y-axis styling to all y-axes
    for (yaxis_name in yaxis_names) {
        # Preserve existing axis properties and merge with new styling
        existing_axis <- fig$x$layout[[yaxis_name]]
        if (!is.null(existing_axis)) {
            layout_updates[[yaxis_name]] <- modifyList(existing_axis, yaxis_style)
        } else {
            layout_updates[[yaxis_name]] <- yaxis_style
        }
        
        # For subplots with matched axes (yaxis2, yaxis3, etc.), explicitly ensure
        # showline and mirror properties are set even if matches="y" is present.
        # This forces plotly to render the axis lines on all subplot borders.
        if (yaxis_name != "yaxis" && !is.null(layout_updates[[yaxis_name]]$matches)) {
            # Force border styling properties for matched axes
            # This overrides plotly's default behavior of hiding borders on matched axes
            style_props <- c("showline", "mirror", "linecolor", "linewidth")
            for (prop in style_props) {
                if (!is.null(yaxis_style[[prop]])) {
                    layout_updates[[yaxis_name]][[prop]] <- yaxis_style[[prop]]
                }
            }
        }
    }
}
#' Create a plotly line plot
#'
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly subplot
#' @importFrom dplyr group_by do pull sym
#'
#' @export
#' @author Jacob Martin

linePlot <- function(reactive.data, x.value, y.value, plot.mode, line.type, colour.group.by, palette.selection, show.legend, facet.by = NULL,
                    axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                    axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside", 
                    axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "Click To Edit Title", title.font.size = 14, title.font.family = "Arial",
                    title.text.color = "black", axis.range.x = NULL, axis.range.y = NULL, y.title = NULL, x.title = NULL, flip.x = NULL, flip.y = NULL){
    
    #Unique x axis styling for linePlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor,ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        range = axis.range.x, title = x.title, autorange = flip.x
    )

    #Y axis styling by editing unique aspects of the x axis styling 
    yaxis_style <- xaxis_style
    yaxis_style$tickangle <- axis.tickangle.y
    yaxis_style$range <- axis.range.y
    yaxis_style$title <- y.title



    if (!is.null(facet.by) && facet.by != ""){
        plots <- reactive.data |>
            group_by(!!sym(facet.by)) |>
            do(p = plot_ly(
                data = .data,
                x = x.value,
                y = y.value,
                type = "scatter",
                mode = plot.mode,
                line = list(dash = line.type),
                color = colour.group.by,
                colors = palette.selection,
                showlegend = show.legend
            )) |>
            pull(p)
        
        fig <- subplot(plots, nrows = 1, shareX = TRUE, shareY = TRUE, titleX = TRUE, titleY = TRUE)
        fig <- .apply_subplot_axis_styling(fig, xaxis_style = xaxis_style, yaxis_style = yaxis_style)

    } else {

    fig <- plot_ly(
        data = reactive.data,
        x = x.value,
        y = y.value,
        type = "scatter",
        mode = plot.mode,
        line = list(dash = line.type),
        color = colour.group.by,
        colors = palette.selection,
        showlegend = show.legend
    )
    
    }
    fig <- fig |> layout(
        title = list(
            text = title.text, 
            font = list(size = title.font.size, family = title.font.family, color = title.text.color),
            x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)
        ),
        margin = list(t = 80),
        showlegend = TRUE,
        xaxis = list(  # ← KEY: Always works here
            showline = axis.showline,
            mirror = axis.mirror,
            linecolor = axis.linecolor,
            linewidth = axis.linewidth,
            tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
            tickangle = axis.tickangle.x,
            ticks = axis.ticks,
            tickcolor = axis.tickcolor,
            ticklen = axis.ticklen,
            tickwidth = axis.tickwidth,
            range = axis.range.x,
            title = x.title,
            autorange = flip.x
        ),
        yaxis = list(
            showline = axis.showline,
            mirror = axis.mirror,
            linecolor = axis.linecolor,
            linewidth = axis.linewidth,
            tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
            tickangle = axis.tickangle.y,
            ticks = axis.ticks,
            tickcolor = axis.tickcolor,
            ticklen = axis.ticklen,
            tickwidth = axis.tickwidth,
            range = axis.range.y,
            title = y.title,
            autorange = flip.y
        )
    )
    return(fig)
}