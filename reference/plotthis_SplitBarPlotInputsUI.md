# Input UI components for the SplitBarPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_SplitBarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotServer.md)
and
[`plotthis_SplitBarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_SplitBarPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `y` - Y-axis variable (automatically set from data structure)

- `y_sep` - Separator for y columns (not applicable in UI context)

- `flip` - Flip axes (not implemented in current UI)

- `split_by_sep` - Separator for split columns (not applicable in UI
  context)

- `order_y` - Y-axis ordering rules (handled by default logic)

- `lineheight` - Text line height (not applicable in plotly)

- `max_charwidth` - Maximum character width (not applicable in plotly)

- `fill_by_sep` - Separator for fill columns (not applicable in UI
  context)

- `fill_name` - Fill legend name (handled by plotly)

- `direction_pos_name` - Positive direction name (not implemented)

- `direction_neg_name` - Negative direction name (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `keep_empty` - Keep empty values (not implemented)

- `keep_na` - Keep NA values (not implemented)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `seed` - Random seed (not applicable)

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `design` - Only applies if `split_by` is used

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X values", default: 2nd numeric variable)

- `fill_by` - Fill color variable (UI: "Fill by", default: 2nd variable)

- `alpha_by` - Variable for alpha transparency (UI: "Alpha by", default:
  "")

- `alpha_reverse` - Reverse alpha order (UI: "Alpha reverse", default:
  FALSE)

- `alpha_name` - Alpha legend name (UI: "Alpha name", default: "")

- `bar_height` - Height of bars (UI: "Bar height", default: 0.9)

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet scale", default:
  "free_y")

- `facet_ncol` - Number of facet columns (UI: "Facet number of columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Facet number of rows",
  default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by row", default:
  TRUE)

- `split_by` - Split variable (UI: "Split by", default: "")

- `x_min` - Minimum X-axis value (UI: "X-axis min", default: calculated
  from data)

- `x_max` - Maximum X-axis value (UI: "X-axis max", default: calculated
  from data)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `label.on.y.axis` - Show category labels on the Y axis instead of on
  the plot (UI: "Labels on Y axis", default: FALSE). When enabled, the
  text position slider is hidden and labels appear as Y-axis tick
  labels.

- `text.position` - Position of category labels along the X axis (UI:
  "Position of category labels", default: 0). Only visible when
  `label.on.y.axis` is FALSE.

- `axis.font.size` - Axis title font size (UI: "Axis font size",
  default: 18)

- `title.font.size` - Plot title font size (UI: "Title font size",
  default: 28)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `text.colour` - Color for axis labels (UI: "Label colour", default:
  "#000000")

- `axis.showline` - Show axis border lines (UI: "Show axis lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror axis
  lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X major
  gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y major
  gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis line color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis line width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick label size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick label color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick label
  font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis tick label angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis tick label angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick mark color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick mark length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick mark width",
  default: 1)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line types",
  default: "dashed")

- `vline.opacities` - Opacities for vertical lines (UI: "Opacities
  (0-1)", default: "1")

- `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes",
  default: "")

- `abline.intercepts` - Y-intercepts for diagonal lines (UI:
  "Y-intercepts", default: "")

- `abline.colors` - Colors for diagonal lines (UI: "Colors", default:
  "#000000")

- `abline.widths` - Widths for diagonal lines (UI: "Widths", default:
  "1")

- `abline.linetypes` - Line types for diagonal lines (UI: "Line types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

## See also

[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_SplitBarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotOutputUI.md),
[`plotthis_SplitBarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotServer.md),
[`plotthis_SplitBarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
mtcars$cyl <- as.factor(mtcars$cyl)
plotthis_SplitBarPlotInputsUI("splitBarPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="splitBarPlot-SplitBarPlotTabsetPanel" data-tabsetid="9708">
#>     <li class="active">
#>       <a href="#tab-9708-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9708-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9708-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9708-4" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9708-5" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9708-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9708">
#>     <div class="tab-pane active" data-value="Data" id="tab-9708-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4172644">
#>             <label class="control-label" id="splitBarPlot-x.data-label" for="splitBarPlot-x.data">X values</label>
#>             <div>
#>               <select id="splitBarPlot-x.data" class="shiny-input-select"><option value=""></option>
#> <option value="mpg" selected>mpg</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="splitBarPlot-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4172644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the x-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7269488">
#>             <label class="control-label" id="splitBarPlot-y.data-label" for="splitBarPlot-y.data">Y values</label>
#>             <div>
#>               <select id="splitBarPlot-y.data" class="shiny-input-select"><option value=""></option>
#> <option value="cyl" selected>cyl</option></select>
#>               <script type="application/json" data-for="splitBarPlot-y.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7269488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select the categorical column to use for the Y axis groupings'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6376855">
#>             <label class="control-label" id="splitBarPlot-fill.by-label" for="splitBarPlot-fill.by">Fill by</label>
#>             <div>
#>               <select id="splitBarPlot-fill.by" class="shiny-input-select"><option value=""></option>
#> <option value="mpg" selected>mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="splitBarPlot-fill.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6376855', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A variable used to fill the bars. Both character/factor and numeric columns are accepted. If `TRUE` (default), the bars will be filled by the x-axis values, If `FALSE`, the bars will be filled a single color (the first color in the palette). ONLY works when `group_by` is NULL. When `group_by` is not NULL, the bars will be filled by the `group_by` variable.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-9708-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3964100">
#>             <label class="control-label" id="splitBarPlot-facet.by-label" for="splitBarPlot-facet.by">Facet by</label>
#>             <div>
#>               <select id="splitBarPlot-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="cyl">cyl</option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="splitBarPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3964100', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9594826">
#>             <label class="control-label" id="splitBarPlot-facet.scale-label" for="splitBarPlot-facet.scale">Facet scale</label>
#>             <div>
#>               <select id="splitBarPlot-facet.scale" class="shiny-input-select"><option value="fixed">fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y" selected>free_y</option></select>
#>               <script type="application/json" data-for="splitBarPlot-facet.scale" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9594826', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2986581">
#>             <label class="control-label" id="splitBarPlot-facet.ncol-label" for="splitBarPlot-facet.ncol">Facet number of columns</label>
#>             <input id="splitBarPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2986581', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify502012">
#>             <label class="control-label" id="splitBarPlot-facet.nrow-label" for="splitBarPlot-facet.nrow">Facet number of rows</label>
#>             <input id="splitBarPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify502012', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5761874">
#>             <div class="material-switch">
#>               <label for="splitBarPlot-facet.by.row" style="padding-right: 10px;">Facet by row</label>
#>               <input id="splitBarPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="splitBarPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5761874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2179058">
#>             <label class="control-label" id="splitBarPlot-split.by-label" for="splitBarPlot-split.by">Split by</label>
#>             <div>
#>               <select id="splitBarPlot-split.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="cyl">cyl</option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="splitBarPlot-split.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2179058', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The column(s) to split data by and plot separately.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-9708-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="splitBarPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1258563">
#>             <label class="control-label" id="splitBarPlot-alpha.by-label" for="splitBarPlot-alpha.by">Alpha by</label>
#>             <div>
#>               <select id="splitBarPlot-alpha.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option>
#> <option value="mpg">mpg</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="splitBarPlot-alpha.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1258563', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string indicating the column name to use for the transparency of the bars.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9381526">
#>             <div class="material-switch">
#>               <label for="splitBarPlot-alpha.reverse" style="padding-right: 10px;">Alpha reverse</label>
#>               <input id="splitBarPlot-alpha.reverse" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="splitBarPlot-alpha.reverse"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9381526', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to reverse the transparency.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8012751">
#>             <label class="control-label" id="splitBarPlot-alpha.name-label" for="splitBarPlot-alpha.name">Alpha name</label>
#>             <input id="splitBarPlot-alpha.name" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8012751', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string indicating the legend name of the transparency.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7580536">
#>             <label class="control-label" id="splitBarPlot-bar.height-label" for="splitBarPlot-bar.height">Bar height</label>
#>             <input id="splitBarPlot-bar.height" type="number" class="shiny-input-number form-control" value="0.9" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7580536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value indicating the height of the bars.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5325652">
#>             <label class="control-label" id="splitBarPlot-axis.scale.factor-label" for="splitBarPlot-axis.scale.factor">Factor to which the bars fill the axis</label>
#>             <input class="js-range-slider" id="splitBarPlot-axis.scale.factor" data-skin="shiny" data-min="0" data-max="5" data-from="1.2" data-step="0.2" data-grid="true" data-grid-num="8.33333333333333" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5325652', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scale factor controlling how much of the axis range the bars fill. Values above 1 extend beyond the data range'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5468048">
#>             <div class="material-switch">
#>               <label for="splitBarPlot-label.on.y.axis" style="padding-right: 10px;">Labels on Y axis</label>
#>               <input id="splitBarPlot-label.on.y.axis" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="splitBarPlot-label.on.y.axis"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5468048', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, category labels are shown as Y-axis tick labels instead of being placed on the plot area'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify959265">
#>             <label class="control-label" id="splitBarPlot-text.position-label" for="splitBarPlot-text.position">Position of category labels: </label>
#>             <input class="js-range-slider" id="splitBarPlot-text.position" data-skin="shiny" data-min="0" data-max="100" data-from="0" data-step="1" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify959265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Adjust the horizontal position of category labels along the X axis when labels are shown on the plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-9708-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3883498">
#>             <label class="control-label" id="splitBarPlot-x.min-label" for="splitBarPlot-x.min">X-axis min:</label>
#>             <input id="splitBarPlot-x.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3883498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value indicating the minimum value of the x axis.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1723519">
#>             <label class="control-label" id="splitBarPlot-x.max-label" for="splitBarPlot-x.max">X-axis max:</label>
#>             <input id="splitBarPlot-x.max" type="number" class="shiny-input-number form-control" value="472" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1723519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value indicating the maximum value of the x axis.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-9708-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="splitBarPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="splitBarPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="splitBarPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-title.font.family-label" for="splitBarPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select id="splitBarPlot-title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="splitBarPlot-title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="splitBarPlot-text.colour">Title Color</label>
#>             <input id="splitBarPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.title.font.size-label" for="splitBarPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="splitBarPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="splitBarPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="splitBarPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.title.font.family-label" for="splitBarPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="splitBarPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="splitBarPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="splitBarPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="splitBarPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="splitBarPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="splitBarPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="splitBarPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="splitBarPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.linewidth-label" for="splitBarPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="splitBarPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.tickfont.size-label" for="splitBarPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="splitBarPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="splitBarPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="splitBarPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.tickfont.family-label" for="splitBarPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="splitBarPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="splitBarPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.tickangle.x-label" for="splitBarPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="splitBarPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.tickangle.y-label" for="splitBarPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="splitBarPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.ticks-label" for="splitBarPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="splitBarPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="splitBarPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="splitBarPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="splitBarPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.ticklen-label" for="splitBarPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="splitBarPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-axis.tickwidth-label" for="splitBarPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="splitBarPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-9708-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6907258">
#>             <label class="control-label" id="splitBarPlot-hline.intercepts-label" for="splitBarPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="splitBarPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907258', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-hline.colors-label" for="splitBarPlot-hline.colors">Colors</label>
#>             <input id="splitBarPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-hline.widths-label" for="splitBarPlot-hline.widths">Widths</label>
#>             <input id="splitBarPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-hline.linetypes-label" for="splitBarPlot-hline.linetypes">Line types</label>
#>             <input id="splitBarPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-hline.opacities-label" for="splitBarPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="splitBarPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6752085">
#>             <label class="control-label" id="splitBarPlot-vline.intercepts-label" for="splitBarPlot-vline.intercepts">X-intercepts</label>
#>             <input id="splitBarPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6752085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-vline.colors-label" for="splitBarPlot-vline.colors">Colors</label>
#>             <input id="splitBarPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-vline.widths-label" for="splitBarPlot-vline.widths">Widths</label>
#>             <input id="splitBarPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-vline.linetypes-label" for="splitBarPlot-vline.linetypes">Line types</label>
#>             <input id="splitBarPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="splitBarPlot-vline.opacities-label" for="splitBarPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="splitBarPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="splitBarPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="splitBarPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="splitBarPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="splitBarPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="splitBarPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="splitBarPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="splitBarPlot-download.format-label" for="splitBarPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="splitBarPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="splitBarPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
