# Create ggplot axis styling theme arguments

Creates ggplot2 theme arguments for axis borders and lines based on user
inputs. This function handles axis styling through ggplot2 themes rather
than plotly overlays, which provides better control especially when
faceting is used.

## Usage

``` r
create_ggplot_axis_style(input, isolate_fn = isolate)
```

## Arguments

- input:

  Shiny input object containing axis styling parameters.

- isolate_fn:

  Function to use for isolating reactive values (default: isolate).

## Value

A named list of ggplot2 theme arguments to be passed to theme_args
parameter.

## Details

When faceting is enabled, panel borders are always shown for the full
plot. When faceting is disabled:

- If both axis.showline and axis.mirror are TRUE: Full panel border

- If only axis.showline is TRUE: Axis lines on x and y axes only

- Otherwise: No borders

## Author

Jacob Martin

## Examples

``` r
input <- list(
    axis.showline = TRUE, axis.mirror = TRUE,
    axis.linecolor = "black", axis.linewidth = 1
)
create_ggplot_axis_style(input, isolate_fn = identity)
#> $panel.border
#> <ggplot2::element_rect>
#>  @ fill         : logi NA
#>  @ colour       : chr "black"
#>  @ linewidth    : num 1
#>  @ linetype     : NULL
#>  @ linejoin     : NULL
#>  @ inherit.blank: logi FALSE
#> 
#> $axis.line
#> <ggplot2::element_blank>
#> 
#> $axis.ticks
#> <ggplot2::element_blank>
#> 
```
