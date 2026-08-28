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
        tags$head(tags$style(.data_filter_css())),
        DT::dataTableOutput(ns("table"))
    )
}

.data_filter_css <- function() {
    HTML("
/* Keeps the colvis button, page-length select and search box on one row.
   DataTables' default `Blfrtip` stacks each in its own full-width block,
   which wastes three rows of vertical space above the table. */
.vizmodules-dt-toolbar {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 0.35rem;
}
.vizmodules-dt-toolbar > .dt-buttons,
.vizmodules-dt-toolbar > .dataTables_length,
.vizmodules-dt-toolbar > .dataTables_filter {
    float: none;
    margin: 0;
    white-space: nowrap;
}
/* Push the search box to the far end, away from the left-aligned controls. */
.vizmodules-dt-toolbar > .dataTables_filter { margin-left: auto; }
.vizmodules-dt-toolbar label {
    display: flex;
    align-items: center;
    gap: 0.35rem;
    margin-bottom: 0;
}
.vizmodules-dt-toolbar .dataTables_length select,
.vizmodules-dt-toolbar .dataTables_filter input {
    width: auto;
    display: inline-block;
}
")
}
