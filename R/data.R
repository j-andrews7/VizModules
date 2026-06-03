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
#' @source Generated in data-raw/generate_example_data.R.
#'
#' @author Jacob Martin
#' @keywords datasets
"example_bar"

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
#' @source Generated in data-raw/generate_example_data.R.
#'
#' @author Jacob Martin
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
#' @author Jacob Martin
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
#' @source Generated in data-raw/generate_example_data.R.
#'
#' @author Jacob Martin
#' @keywords datasets
"example_roles"

#' Example sales dataset
#'
#' A simulated product-sales dataset (720 rows total).
#' Designed to showcase bar, box, violin,
#' area, line, scatter, split-bar, density, and histogram plot modules.
#'
#' @format A data frame with 720 rows and 7 columns:
#' \describe{
#'   \item{region}{Region of the sale (factor: North, South, East, West, Central, International)}
#'   \item{revenue}{Revenue for month}
#'   \item{year}{The year}
#'   \item{month}{The month}
#'   \item{units}{Units sold}
#'   \item{sale_id}{Unique sale identifier}
#'   \item{product_line}{Product line (factor: Gadgets, Widgets, Doohickeys)}
#' }
#'
#' @source Generated in data-raw/generate_example_data.R.
#'
#' @author Jared Andrews
#' @keywords datasets
"example_sales"

#' Example demographics dataset
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
#' @author Jared Andrews
#' @keywords datasets
"example_demographics"

#' Example grouped iris dataset
#'
#' The classic iris dataset with an added 'Group' column to facilitate multi-group plot examples.
#'
#' @format A data frame with 150 rows and 6 columns:
#' \describe{
#'   \item{Sepal.Length}{Sepal length in cm}
#'   \item{Sepal.Width}{Sepal width in cm}
#'   \item{Petal.Length}{Petal length in cm}
#'   \item{Petal.Width}{Petal width in cm}
#'   \item{Species}{Species of the iris (factor: setosa, versicolor, virginica)}
#'   \item{Group}{Group assignment (factor: A, B, C, D)}
#' }
#'
#' @source Generated from the classic iris dataset.
#'
#' @author Jared Andrews
#' @keywords datasets
"example_iris"

#' Example mtcars dataset with factors
#'
#' The classic mtcars dataset with key numeric columns converted to factors for categorical plotting examples.
#'
#' @format A data frame with 32 rows and 11 columns:
#' \describe{
#'   \item{mpg}{Miles per gallon}
#'   \item{cyl}{Number of cylinders (factor)}
#'   \item{disp}{Displacement (cubic inches)}
#'   \item{hp}{Gross horsepower}
#'   \item{drat}{Rear axle ratio}
#'   \item{wt}{Weight (1000 lbs)}
#'   \item{qsec}{1/4 mile time}
#'   \item{vs}{Engine (0 = V-shaped, 1 = straight) (factor)}
#'   \item{am}{Transmission (0 = automatic, 1 = manual) (factor)}
#'   \item{gear}{Number of forward gears (factor)}
#'   \item{carb}{Number of carburetors (factor)}
#' }
#' @source Generated from the classic mtcars dataset.
#'
#' @author Jared Andrews
#' @keywords datasets
"example_mtcars"

#' Example population dataset
#' A simulated population dataset with 400 rows covering 50 years and 8 age groups.
#' Designed for line, area, and stacked bar plot examples.
#' 
#' @format A data frame with 400 rows and 4 columns:
#' \describe{
#'   \item{year}{Year of the population record (factor: 1975–2024)}
#'   \item{age_group}{Age group category (factor: 0-9, 10-17, 18-34, 35-44, 45-54, 55-64, 65-74, 75+)}
#'   \item{count}{Population count for the given year and age group}
#'   \item{record_id}{Unique identifier for each population record}
#' }
#' 
#' @source Generated in data-raw/generate_example_data.R.
#' 
#' @author Jared Andrews
#' @keywords datasets
"example_population"

#' Example single-cell marker gene dataset for dot plots
#'
#' A simulated single-cell marker-gene expression dataset with 104 rows
#' covering eight immune cell types and thirteen canonical marker genes.
#' Each cell type strongly expresses its own marker genes (high average
#' expression and percent expressed) and weakly expresses the rest, making it
#' a realistic example for [plotthis_DotPlotApp()] where dot size encodes the
#' percent of cells expressing a gene and dot fill encodes average expression.
#'
#' @format A data frame with 104 rows and 4 columns:
#' \describe{
#'   \item{cell_type}{Immune cell type (factor: CD4 T, CD8 T, B, NK, Monocyte, Dendritic, Plasma, Platelet)}
#'   \item{gene}{Marker gene symbol (factor with 13 levels, e.g. CD3D, MS4A1, NKG7,
#'     LYZ, MZB1, PPBP)}
#'   \item{avg_expression}{Average expression of the gene in the cell type}
#'   \item{pct_expressed}{Percent of cells in the cell type expressing the gene}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @author Jacob Martin
#' @keywords datasets
"example_markers"

#' Example RNA-seq dataset for the RNA-seq showcase app
#'
#' A simulated pseudo-bulk RNA-seq dataset with 288 rows covering six immune
#' cell types, eight canonical marker genes, two conditions (Healthy / Disease),
#' and three biological replicates per condition. Marker genes are strongly
#' expressed in their canonical cell type; Disease replicates include a
#' simulated ~1.2 log2FC upregulation for marker genes, making biological
#' comparisons visually informative.
#'
#' The dataset is designed to simultaneously support three VizModules plot types:
#' \itemize{
#'   \item **DotPlot** – summarised \code{avg_expression} and \code{pct_expressed}
#'     columns per cell type × gene × condition combination.
#'   \item **yPlot** – per-replicate \code{log2_cpm} values grouped by
#'     \code{cell_type} and coloured by \code{condition}.
#'   \item **DensityPlot** – per-replicate \code{log2_cpm} values grouped by
#'     \code{condition} and faceted by \code{cell_type}.
#' }
#'
#' @format A data frame with 288 rows and 7 columns:
#' \describe{
#'   \item{cell_type}{Immune cell type (factor: CD4 T, CD8 T, B Cell, NK Cell, Monocyte, pDC)}
#'   \item{gene}{Gene symbol (factor: CD3D, CD8A, MS4A1, NKG7, LYZ, LILRA4, CD14, GNLY)}
#'   \item{condition}{Experimental condition (factor: Healthy, Disease)}
#'   \item{replicate}{Biological replicate (factor: Rep1, Rep2, Rep3)}
#'   \item{log2_cpm}{Simulated log2 counts-per-million expression value}
#'   \item{avg_expression}{Mean log2_cpm across replicates for this cell_type × gene × condition}
#'   \item{pct_expressed}{Percent of replicates with log2_cpm > 0.5 for this combination}
#' }
#'
#' @source Simulated in data-raw/generate_example_data.R.
#'
#' @author Jacob Martin
#' @keywords datasets
"example_rnaseq"