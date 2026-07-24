# Create Plotly axis style list

Constructs a style list for a Plotly axis using values from a Shiny
`input` object, including title font, axis lines, tick appearance, and
gridline settings.

## Usage

``` r
create_axis_styles(
  input,
  axis_side = c("x", "y"),
  isolate_fn = isolate,
  ggplot.axis.styling = TRUE
)
```

## Arguments

- input:

  Shiny input object. Expected to contain axis-related fields such as
  `title.font.family`, `text.colour`, `axis.showline`, `axis.mirror`,
  `axis.linecolor`, `axis.linewidth`, `axis.tickfont.size`,
  `axis.tickfont.color`, `axis.tickfont.family`, `axis.tickangle.x`,
  `axis.tickangle.y`, `axis.ticks`, `axis.tickcolor`, `axis.ticklen`,
  `axis.tickwidth`, `show.grid.x`, `show.grid.y`, and `grid.color`.

- axis_side:

  Character. Which axis to style, either `"x"` or `"y"`. Determines
  whether `axis.tickangle.x` or `axis.tickangle.y` is used for the tick
  angle, and which gridline inputs are applied.

- isolate_fn:

  Function. A function used to isolate Shiny inputs, typically
  [`shiny::isolate`](https://rdrr.io/pkg/shiny/man/isolate.html).
  Defaults to `isolate`.

- ggplot.axis.styling:

  Logical. Whether ggplot axis styling is applied. Defaults to `TRUE`.

## Value

A named list containing Plotly-compatible axis styling components,
including title font, line properties, tick label formatting, and
gridline visibility.

## Details

The function collects axis- and font-related settings from the provided
`input` object and assembles them into a list suitable for use as an
axis specification in Plotly layouts. The tick angle and gridline
visibility are chosen based on the value of `axis_side`. If gridline
inputs are not present in the input object, defaults to showing
gridlines.

## Author

Jacob Martin

## Examples

``` r
# Build a fake input list and use identity as the isolate function
input <- list(
    axis.title.font.size = 14, axis.title.font.family = "Arial",
    axis.title.font.color = "black", axis.tickfont.size = 10,
    axis.tickfont.color = "black", axis.tickfont.family = "Arial",
    axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
    axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1,
    show.grid.x = TRUE, show.grid.y = TRUE, grid.color = "grey90"
)
create_axis_styles(input, axis_side = "x", isolate_fn = identity)
#> $title
#> $title$font
#> $title$font$size
#> [1] 14
#> 
#> $title$font$family
#> [1] "Arial"
#> 
#> $title$font$color
#> [1] "black"
#> 
#> 
#> 
#> $tickfont
#> $tickfont$size
#> [1] 10
#> 
#> $tickfont$color
#> [1] "black"
#> 
#> $tickfont$family
#> [1] "Arial"
#> 
#> 
#> $tickangle
#> [1] 0
#> 
#> $ticks
#> [1] "outside"
#> 
#> $tickcolor
#> [1] "black"
#> 
#> $ticklen
#> [1] 5
#> 
#> $tickwidth
#> [1] 1
#> 
#> $showgrid
#> [1] TRUE
#> 
#> $gridcolor
#> [1] "grey90"
#> 
```
