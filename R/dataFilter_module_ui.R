#' UI component for the dataFilter module
#'
#' Renders an interactive DT table that allows users to filter rows of a data
#' frame. Place this in the UI where you want the filterable table to appear,
#' using an `id` that matches the one passed to [dataFilterServer()].
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny `tagList` containing the DT table output.
#'
#' @import shiny
#' @importFrom DT dataTableOutput
#'
#' @export
#' @author Jacob Martin
#' @seealso [dataFilterServer()]
#' @examples
#' library(VizModules)
#' dataFilterUI("myFilter")
dataFilterUI <- function(id) {
    ns <- NS(id)
    tagList(
        DT::dataTableOutput(ns("table"))
    )
}
