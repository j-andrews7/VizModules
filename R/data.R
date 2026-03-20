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

#' Example iris dataset with an additional Group column
#'
#' The built-in \code{iris} dataset extended with a \code{Group} column
#' assigning groups \code{"A"} and \code{"B"} to the first 100 rows and
#' \code{"C"} and \code{"D"} alternating across the remaining 50 rows,
#' for multi-group plotting examples.
#'
#' @format A data frame with 150 rows and 6 columns:
#' \describe{
#'   \item{Sepal.Length}{Sepal length in cm}
#'   \item{Sepal.Width}{Sepal width in cm}
#'   \item{Petal.Length}{Petal length in cm}
#'   \item{Petal.Width}{Petal width in cm}
#'   \item{Species}{Species of iris}
#'   \item{Group}{Arbitrary group label (A or B for rows 1-100; C or D for rows 101-150)}
#' }
#'
#' @source Derived from the built-in \code{iris} dataset.
#'
#' @examples
#' library(VizModules)
#' head(example_iris)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_iris"

#' Example mtcars dataset with key columns as factors
#'
#' The built-in \code{mtcars} dataset with \code{cyl}, \code{gear}, and
#' \code{vs} converted to factors for categorical-aware plotting.
#'
#' @format A data frame with 32 rows and 11 columns:
#' \describe{
#'   \item{mpg}{Miles per gallon}
#'   \item{cyl}{Number of cylinders (factor)}
#'   \item{disp}{Displacement (cu. in.)}
#'   \item{hp}{Gross horsepower}
#'   \item{drat}{Rear axle ratio}
#'   \item{wt}{Weight (1000 lbs)}
#'   \item{qsec}{1/4 mile time}
#'   \item{vs}{Engine shape (factor: 0 = V-shaped, 1 = straight)}
#'   \item{am}{Transmission (0 = automatic, 1 = manual)}
#'   \item{gear}{Number of forward gears (factor)}
#'   \item{carb}{Number of carburetors}
#' }
#'
#' @source Derived from the built-in \code{mtcars} dataset.
#'
#' @examples
#' library(VizModules)
#' head(example_mtcars)
#'
#' @author Jared Andrews
#' @keywords datasets
"example_mtcars"

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
