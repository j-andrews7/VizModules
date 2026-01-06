#' Create a plotly line plot
#'
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly
#'
#' @export
#' @author Jacob Martin
#' 
# Line plot with mode "lines" or "lines+markers" or "markers"

#If data wants a mean value: 


linePlot <- function(reactive.data, x.value, y.value, plot.mode, line.type){
    fig <- plot_ly(
        data = reactive.data,
        x = x.value,
        y = y.value,
        type = "scatter",
        mode = plot.mode,
        line = list(dash = line.type)
    )
    return(fig)
}