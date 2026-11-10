# Set the notation of a figure's numeric tick labels

Tick labels of large or small numbers can come out in scientific
notation (`1e+05`) or not depending only on which breaks an axis happens
to get, since a ggplot converted with
[`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
carries the labels R's [`format()`](https://rdrr.io/r/base/format.html)
gave its breaks as fixed tick text. This sets the notation explicitly
instead, for every x and y axis of the figure.

## Usage

``` r
apply_tick_notation(fig, scientific = FALSE)
```

## Arguments

- fig:

  A plotly figure.

- scientific:

  Logical. Whether numeric tick labels use scientific notation. Default
  `FALSE`.

## Value

The built plotly figure with its tick labels updated.

## Details

Fixed tick text is rewritten only on axes whose labels are all numbers
that match the tick positions (or are 10, 2, or e raised to them, for a
log scale), so categorical axes, even ones whose categories look like
numbers, and formatted labels (`"25%"`, `"$1,000"`) are left alone. With
`scientific = FALSE`, only labels already in scientific notation are
rewritten; with `TRUE`, every numeric label is written as a power of ten
(1.5 times 10 to the 5th). Axes plotly labels itself get
`exponentformat = "power"` when `scientific` is `TRUE`, and are
otherwise left to plotly, whose default abbreviates large numbers
(`100k`) rather than using scientific notation.

Axes marked with
[`mark_overlay_axes()`](https://j-andrews7.github.io/VizModules/reference/mark_overlay_axes.md)
are left alone.

## See also

[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md),
which applies this from the Axes tab's "Scientific Notation Ticks"
input.

## Author

Jared Andrews

## Examples

``` r
p <- ggplot2::ggplot(data.frame(x = c("a", "b"), y = c(1e5, 3e5)), ggplot2::aes(x, y)) +
    ggplot2::geom_col()
fig <- plotly::ggplotly(p)
apply_tick_notation(fig)$x$layout$yaxis$ticktext
#> [1] "0"      "100000" "200000" "300000"
apply_tick_notation(fig, scientific = TRUE)$x$layout$yaxis$ticktext
#> [1] "0"                "1×10<sup>5</sup>" "2×10<sup>5</sup>" "3×10<sup>5</sup>"
```
