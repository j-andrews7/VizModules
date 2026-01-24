# Input UI components for the AreaPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`AreaPlotServer()`](https://j-andrews7.github.io/vizModules/reference/AreaPlotServer.md)
and
[`AreaPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/AreaPlotOutputUI.md)
functions.

## Usage

``` r
AreaPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `design` - Only applies if `split_by` is used

- `split_by_sep` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `palette` - Managed internally via the palette selection UI

## Plot parameters and defaults

The following
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X values", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y values", default: 2nd numeric variable)

- `group_by` - Grouping variable for area fill (UI: "Group by", default:
  3rd categorical variable or "")

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Facet number of columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Facet number of rows",
  default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

- `theme` - ggplot2 theme (UI: "Theme", default: "theme_this")

- `alpha` - Area fill transparency (UI: "Alpha", default: 1)

- `scale_y` - Scale y-axis by total (UI: "Scale y-axis by total",
  default: FALSE)

- `legend_direction` - Legend orientation (UI: "Legend direction",
  default: "vertical")

## See also

[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`AreaPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/AreaPlotOutputUI.md),
[`AreaPlotServer()`](https://j-andrews7.github.io/vizModules/reference/AreaPlotServer.md),
[`AreaPlotApp()`](https://j-andrews7.github.io/vizModules/reference/AreaPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(vizModules)
# Needs at least 2 categorical variables for grouping and x-axis
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$gear <- as.factor(mtcars$gear)
AreaPlotInputsUI("areaPlot", mtcars)
#> Warning: 'x' is NULL so the result will be NULL
#> Error in ans[npos] <- rep(no, length.out = len)[npos]: replacement has length zero
```
