# Apply plot title styling to a plotly figure

Applies title font settings from the Shiny input object to an existing
plotly figure. The title is centered horizontally and positioned using
the supplied `title_y` value in the plotly layout.

## Usage

``` r
apply_title_layout(plot, input, isolate_fn, title_y = 0.95, title_x = 0.5)
```

## Arguments

- plot:

  A plotly figure object.

- input:

  Shiny input object containing title font fields.

- isolate_fn:

  Function to isolate reactive values.

- title_y:

  Numeric y position for the plot title in the plotly layout. Defaults
  to `0.95`.

- title_x:

  Numeric position for the title in the plotly layout.

## Value

The modified plotly figure with updated title styling.

## Author

Jacob Martin

## Examples

``` r
if (FALSE) { # \dontrun{
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
input <- list(
    title.font.size = 16, title.font.family = "Arial", title.font.color = "black"
)
apply_title_layout(p, input, isolate_fn = identity)
} # }
```
