# Input UI components for the DotPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_DotPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotServer.md)
and
[`plotthis_DotPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_DotPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html);
  it is resolved with
  [`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) to
  seed the control, and the module then keeps it live (see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md)).

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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `legend.direction` - Legend orientation (plotly allows interactive
  adjustment)

- `x_sep` - Separator for multiple x columns (not yet implemented)

- `y_sep` - Separator for multiple y columns (not yet implemented)

- `split_by` - Split variable for separate plots (doesn't work with
  plotly; `facet_by` available instead)

- `split_by_sep` - Separator for multiple `split_by` columns (`split_by`
  not used in module)

- `size_name` - Size legend name (plotly allows interactive editing)

- `fill_name` - Fill legend name (not yet implemented)

- `fill_cutoff_name` - Fill cutoff legend name (not yet implemented)

- `theme` - ggplot2 theme (managed internally)

- `theme_args` - Theme arguments (not yet implemented)

- `palcolor` - Managed internally via the palette selection UI

- `border_alpha` - Dot border transparency (not exposed; uses the
  plotthis default of 1)

- `add_bg` - Add background stripes/shading (not yet implemented)

- `bg_palette` - Background palette (not yet implemented)

- `bg_palcolor` - Background palette colors (not yet implemented)

- `bg_alpha` - Background alpha (not yet implemented)

- `bg_direction` - Background stripe direction (not yet implemented)

- `x_text_angle` - X-axis text angle (handled by axis.tickangle.x)

- `keep_empty` - Keep empty factor levels (not yet implemented)

- `keep_na` - Keep NA values (not yet implemented)

- `combine` - Combine multiple plots (not applicable as `split_by` is
  not implemented)

- `seed` - Random seed (not applicable)

- `nrow` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

- `ncol` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

- `byrow` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

- `axes` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

- `axis_titles` - Only applies if `split_by` is used with combine
  (`split_by` not used in module)

- `guides` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

- `design` - Only applies if `split_by` is used with combine (`split_by`
  not used in module)

## Plot parameters and defaults

The following
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
and custom parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `x` - X-axis variable (UI: "X Values", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y Values", default: 3rd categorical
  variable)

- `size_by` - Numeric column mapped to dot size (UI: "Size By", default:
  "" = count)

- `size_min` - Minimum dot size (UI: "Min Dot Size", default: 1)

- `size_max` - Maximum dot size (UI: "Max Dot Size", default: 6)

- `size.scale.min` - `size_by` value drawn at the minimum dot size,
  where the size legend starts (UI: "Size Scale Min", default: NA = the
  column's minimum); smaller values are drawn at the minimum size. Shown
  while `size_by` is set

- `size.scale.max` - `size_by` value drawn at the maximum dot size,
  where the size legend ends (UI: "Size Scale Max", default: NA = the
  column's maximum); larger values are drawn at the maximum size. Shown
  while `size_by` is set

- `fill_by` - Numeric column mapped to dot fill (UI: "Fill By", default:
  "")

- `fill_cutoff` - Cutoff applied to the fill column (UI: "Fill Cutoff",
  default: NA)

- `fill_cutoff_direction` - Direction of the fill cutoff (UI: "Fill
  Cutoff Direction", default: "\<"); combined with `fill_cutoff` into a
  `plotthis` expression such as `"< 18"`.

- `flip` - Flip the x and y axes (UI: "Rotate (swap X/Y)", default:
  FALSE)

- `facet_by` - Faceting variable (UI: "Facet By", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palette.name` - Continuous fill palette (UI: "Color Palette",
  default: "Spectral")

- `palreverse` - Reverse the color palette (UI: "Reverse palette",
  default: FALSE)

- `alpha` - Dot fill transparency (UI: "Alpha", default: 1)

- `border_color` - Dot border color; only constant colors are supported
  (UI: "Border Color", default: "black")

- `border_size` - Dot border stroke width (UI: "Border Size", default:
  0.5)

- `lower_quantile` - Lower quantile for the continuous fill color scale
  (UI: "Lower Quantile", default: 0)

- `upper_quantile` - Upper quantile for the continuous fill color scale
  (UI: "Upper Quantile", default: 1)

- `lower_cutoff` - Explicit lower cutoff for the continuous fill color
  scale (UI: "Lower Cutoff", default: NA); overrides `lower_quantile`
  when set

- `upper_cutoff` - Explicit upper cutoff for the continuous fill color
  scale (UI: "Upper Cutoff", default: NA); overrides `upper_quantile`
  when set

- `size.legend.x` - Custom size-legend x position (UI: "Size Legend X
  Position", default: 1.04); nudges the manual size legend (drawn when
  `size.by` is set) along the x-axis.

- `size.legend.y` - Custom size-legend y position (UI: "Size Legend Y
  Position", default: 0.35); nudges the manual size legend (drawn when
  `size.by` is set) along the y-axis.

- `legend.show` - Show the legend, colorbar and size legend (UI: "Show
  Legend", default: TRUE)

- `legend.font.family` - Font family of the legend title and labels (UI:
  "Legend Font", default: "Arial")

- `legend.font.color` - Font color of the legend title and labels (UI:
  "Legend Font Color", default: "#000000")

- `legend.title.size` - Legend title font size (UI: "Legend Title Size",
  default: 14)

- `legend.text.size` - Legend entry label font size (UI: "Legend Text
  Size", default: 12)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `webgl` - Draw the points with WebGL once there are 5,000 or more, as
  set by the `VizModules.webgl.threshold` option (UI: "Plot with WebGL",
  default: TRUE)

## See also

[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_DotPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotOutputUI.md),
[`plotthis_DotPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotServer.md),
[`plotthis_DotPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
data(mtcars)
plotthis_DotPlotInputsUI("DotPlot", mtcars)
}
```
