# Create an example Modular AreaPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
AreaPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which AreaPlot modules will be
  created. That is, UI inputs and an area plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(vizModules)
# Create sample data with time series and multiple groups
set.seed(7)
months <- rep(month.abb, each = 4)
regions <- rep(c("North", "South", "East", "West"), 12)
sales <- data.frame(
    month = factor(months, levels = month.abb),
    region = factor(regions),
    revenue = round(runif(48, 50, 200) + rep(seq(0, 55, 5), each = 4), 1),
    units = sample(100:500, 48, replace = TRUE)
)

# Population data across age groups over time
years <- rep(2015:2024, each = 5)
age_groups <- rep(c("0-17", "18-34", "35-54", "55-74", "75+"), 10)
population <- data.frame(
    year = factor(years),
    age_group = factor(age_groups, levels = c("0-17", "18-34", "35-54", "55-74", "75+")),
    count = round(rnorm(50, mean = 5000, sd = 800) + rep(seq(0, 900, 100), each = 5))
)

data_list <- list("sales" = sales, "population" = population)
app <- AreaPlotApp(data_list)
#> Warning: 'x' is NULL so the result will be NULL
#> Error in ans[npos] <- rep(no, length.out = len)[npos]: replacement has length zero
if (interactive()) runApp(app)
```
