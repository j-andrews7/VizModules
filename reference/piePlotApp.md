# Create an example Modular piePlot Shiny Application

This function generates a Shiny application with modular piePlot
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
piePlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which piePlot modules will be created.
  That is, UI inputs and a pie plot will be generated for each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- piePlotApp(data_list)
if (interactive()) runApp(app)
```
