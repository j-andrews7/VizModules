#' Example sales dataset for module apps
#'
#' A dataset containing simulated sales records across years, months, and regions.
#'
#' @format A data frame with 720 rows and 6 columns:
#' \describe{
#'   \item{sale_id}{Unique sale record identifier}
#'   \item{year}{Year of the sale}
#'   \item{month}{Month of the sale}
#'   \item{region}{Sales region}
#'   \item{revenue}{Revenue amount}
#'   \item{units}{Units sold}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(example_sales)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_sales"

#' Example population dataset for module apps
#'
#' A dataset containing simulated population counts across years and age groups.
#'
#' @format A data frame with 400 rows and 4 columns:
#' \describe{
#'   \item{record_id}{Unique population record identifier}
#'   \item{year}{Year of the record}
#'   \item{age_group}{Age group}
#'   \item{count}{Population count}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(example_population)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_population"
