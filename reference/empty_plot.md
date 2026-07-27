# Create an empty ggplot2 plot or plotly plot with input text

This function creates an empty ggplot2 or plotly plot and places a
user-provided text string in the middle of the plot.

## Usage

``` r
empty_plot(text = NULL, plotly = FALSE)
```

## Arguments

- text:

  Character scalar to show in plot area.

- plotly:

  Boolean indicating whether to return a plotly object.

## Value

Either a ggplot object or a plotly object if `plotly = TRUE`.

## See also

[`ggplot2::geom_text()`](https://ggplot2.tidyverse.org/reference/geom_text.html),
[`ggplot2::theme_void()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
empty_plot("No data to display")
```
