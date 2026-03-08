# Create an Interactive Parallel Coordinates Plot with plotly

Generates a customizable interactive parallel coordinates plot using
plotly, supporting dimension selection, color mapping, and font styling.

## Usage

``` r
parallelCoordinatesPlot(
  data,
  dimensions,
  color.by = NULL,
  color.scale = "Viridis",
  line.opacity = 0.5,
  line.width = 1,
  show.colorbar = TRUE,
  label.font.size = 12,
  label.font.color = "black",
  label.font.family = "Arial",
  tick.font.size = 10,
  tick.font.color = "black",
  tick.font.family = "Arial",
  title.text = "",
  title.font.size = 16,
  title.font.family = "Arial",
  title.text.color = "black",
  bgcolor = "#FFFFFF"
)
```

## Arguments

- data:

  A data.frame or tibble containing the data to plot.

- dimensions:

  Character vector of column names to use as dimensions (axes). Must
  contain at least two columns. Non-numeric columns are mapped to
  integers.

- color.by:

  Optional character, column name to color lines by. Numeric columns use
  a continuous colorscale; categorical columns are mapped to integers
  and displayed with the same colorscale. Default: NULL.

- color.scale:

  Character, plotly colorscale name for line coloring. Options include
  "Viridis", "Cividis", "Inferno", "Magma", "Plasma", "Blues", "Greens",
  "Reds", "Oranges", "RdBu", "RdYlBu", "Spectral", "Jet", "Hot", "Cool",
  "Portland". Default: "Viridis".

- line.opacity:

  Numeric, opacity of lines between 0 and 1. Default: 0.5.

- line.width:

  Numeric, width of lines in pixels. Default: 1.

- show.colorbar:

  Logical, whether to show the colorbar. Default: TRUE.

- label.font.size:

  Numeric, font size for dimension labels. Default: 12.

- label.font.color:

  Character, hex color for dimension labels. Default: "black".

- label.font.family:

  Character, font family for dimension labels. Default: "Arial".

- tick.font.size:

  Numeric, font size for axis tick labels. Default: 10.

- tick.font.color:

  Character, hex color for axis tick labels. Default: "black".

- tick.font.family:

  Character, font family for axis tick labels. Default: "Arial".

- title.text:

  Character, main title text for the plot. Default: "".

- title.font.size:

  Numeric, font size for plot title. Default: 16.

- title.font.family:

  Character, font family for plot title. Default: "Arial".

- title.text.color:

  Character, hex color for plot title text. Default: "black".

- bgcolor:

  Character, hex color for the plot background. Default: "#FFFFFF".

## Value

A plotly object representing the interactive parallel coordinates plot.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
fig <- parallelCoordinatesPlot(
  data = mtcars,
  dimensions = c("mpg", "cyl", "disp", "hp", "wt"),
  color.by = "mpg",
  color.scale = "Viridis",
  line.opacity = 0.6
)
```
