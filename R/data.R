#' Bar dataset for bar and split bar plot examples
#'
#' A small dataset with five groups, two categorical variables, and three
#' numeric variables. Used as the default data for [plotthis_BarPlotApp()]
#' and [plotthis_SplitBarPlotApp()].
#'
#' @format A data frame with 5 rows and 5 columns:
#' \describe{
#'   \item{Group}{Group label (A through E)}
#'   \item{Type}{Category type (Alpha, Beta, or Gamma)}
#'   \item{Values}{Primary numeric values (positive)}
#'   \item{Numbers}{Secondary numeric values (can be negative)}
#'   \item{Score}{Tertiary numeric values (can be negative)}
#' }
#'
#' @source Defined in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' Bar
#'
#' @author Jared Andrews
#' @keywords datasets
"Bar"

#' Example school earnings dataset for dumbbell plots
#'
#' A small dataset of median annual earnings for men and women at six
#' universities, suitable for dumbbell plot examples.
#'
#' @format A data frame with 6 rows and 4 columns:
#' \describe{
#'   \item{School}{University name}
#'   \item{Women}{Median earnings for women (thousands of USD)}
#'   \item{Men}{Median earnings for men (thousands of USD)}
#'   \item{Group}{University type (STEM-heavy or Liberal Arts)}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' example_school_earnings
#'
#' @author Jared Andrews
#' @keywords datasets
"example_school_earnings"

#' Example multi-player skills dataset for radar plots
#'
#' A dataset of skill ratings across five categories for three players,
#' suitable for radar/spider chart examples.
#'
#' @format A data frame with 15 rows and 3 columns:
#' \describe{
#'   \item{category}{Skill category (Speed, Strength, Defense, Stamina, Agility)}
#'   \item{value}{Skill rating (1-10)}
#'   \item{player}{Player identifier (Player A, B, or C)}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' example_skills
#'
#' @author Jared Andrews
#' @keywords datasets
"example_skills"

#' Example roles dataset for ternary plots
#'
#' A dataset of role proportions (journalist, developer, designer) for eleven
#' individuals across two teams, suitable for ternary plot examples.
#'
#' @format A data frame with 11 rows and 5 columns:
#' \describe{
#'   \item{journalist}{Journalist role proportion}
#'   \item{developer}{Developer role proportion}
#'   \item{designer}{Designer role proportion}
#'   \item{label}{Point label (point 1 through point 11)}
#'   \item{team}{Team assignment (Team A or Team B)}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' example_roles
#'
#' @author Jared Andrews
#' @keywords datasets
"example_roles"

#' Gallery sales dataset for the module gallery app
#'
#' A simulated product-sales dataset covering five product lines over four years
#' and four quarters (80 rows total). Designed to showcase bar, box, violin,
#' area, line, scatter, split-bar, density, and histogram plot modules.
#'
#' @format A data frame with 80 rows and 9 columns:
#' \describe{
#'   \item{product_line}{Product category (factor: Electronics, Clothing, Food, Sports, Home)}
#'   \item{year}{Year of the record (factor: 2020-2023)}
#'   \item{quarter}{Quarter of the year (factor: Q1-Q4)}
#'   \item{revenue}{Total quarterly revenue}
#'   \item{profit}{Quarterly profit (can be negative)}
#'   \item{units}{Units sold}
#'   \item{growth_pct}{Year-over-year growth percentage (can be negative)}
#'   \item{rating}{Average customer rating (3.0–5.0)}
#'   \item{online_pct}{Percentage of sales made online (20–80)}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(gallery_sales)
#'
#' @author Jared Andrews
#' @keywords datasets
"gallery_sales"

#' Gallery demographics dataset for the module gallery app
#'
#' A simulated employee survey dataset with 500 rows spanning six departments
#' and four job levels. Designed to showcase violin, box, yPlot, density, and
#' histogram plot modules with realistic numeric distributions.
#'
#' @format A data frame with 500 rows and 9 columns:
#' \describe{
#'   \item{department}{Employee department (factor: Engineering, Marketing, Sales, HR, Finance, Operations)}
#'   \item{job_level}{Job seniority level (factor: Junior, Mid, Senior, Lead)}
#'   \item{gender}{Employee gender (factor: Male, Female)}
#'   \item{age}{Employee age in years}
#'   \item{salary}{Annual salary in USD}
#'   \item{satisfaction}{Job satisfaction score (1–10)}
#'   \item{performance}{Performance rating (1–10)}
#'   \item{tenure_years}{Years with the company}
#'   \item{weekly_hours}{Average weekly hours worked (35–65)}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @examples
#' library(VizModules)
#' head(gallery_demographics)
#'
#' @author Jared Andrews
#' @keywords datasets
"gallery_demographics"
