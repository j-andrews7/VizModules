# Input UI components for the Histogram module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_HistogramServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramServer.md)
and
[`plotthis_HistogramOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramOutputUI.md)
functions.

## Usage

``` r
plotthis_HistogramInputsUI(
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
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `group_by_sep` - Separator for group columns (not applicable in UI
  context)

- `group_name` - Group legend name (handled by plotly)

- `xtrans` - X-axis transformation (not implemented in UI)

- `ytrans` - Y-axis transformation (not implemented in UI)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `split_by_sep` - Only applies if `split_by` is used

- `flip` - Flip axes (not implemented in current UI)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `expand` - Axis expansion (not implemented)

- `seed` - Random seed (not applicable)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `design` - Only applies if `split_by` is used

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X Data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group By", default: "")

- `bins` - Number of bins (UI: "Number of Bins", default: NA)

- `binwidth` - Width of bins (UI: "Bin Width", default: NA)

- `use_trend` - Show only trend line (UI: "Trend Line Only", default:
  FALSE)

- `add_trend` - Add trend line to histogram (UI: "Add Trend to
  Histogram", default: FALSE)

- `trend_skip_zero` - Skip zero values in trend (UI: "Skip Zero Values",
  default: FALSE)

- `trend_alpha` - Trend line transparency (UI: "Trend Line Alpha",
  default: 1)

- `trend_linewidth` - Trend line width (UI: "Trend Line Width", default:
  0.8)

- `trend_pt_size` - Trend point size (UI: "Trend Point Size", default:
  1.5)

- `position` - Position adjustment (UI: "Position", default: "identity")

- `alpha` - Histogram fill transparency (UI: "Plot Alpha", default: 1)

- `add_bars` - Add rug plot (UI: "Add Rug Plot", default: FALSE)

- `bar_height` - Rug bar height (UI: "Rug Bar Height", default: 0.04)

- `bar_alpha` - Rug bar transparency (UI: "Rug Bar Alpha", default: 1)

- `bar_width` - Rug bar width (UI: "Rug Bar Width", default: 1)

- `facet_by` - Faceting variable (UI: "Facet By", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Number of Columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Number of Rows", default:
  NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

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

[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_HistogramOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramOutputUI.md),
[`plotthis_HistogramServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramServer.md),
[`plotthis_HistogramApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_HistogramInputsUI("histogram", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="histogram-histogramPlotTabsetPanel" data-tabsetid="4292">
#>     <li class="active">
#>       <a href="#tab-4292-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-4" data-toggle="tab" data-bs-toggle="tab" data-value="Rug">Rug</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-6" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4292-7" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="4292">
#>     <div class="tab-pane active" data-value="Data" id="tab-4292-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1116803">
#>             <label class="control-label" id="histogram-x.data-label" for="histogram-x.data">X Data</label>
#>             <div>
#>               <select id="histogram-x.data" class="shiny-input-select"><option value=""></option>
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
#>               <script type="application/json" data-for="histogram-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1116803', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the x-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1010954">
#>             <label class="control-label" id="histogram-group.by-label" for="histogram-group.by">Group By</label>
#>             <div>
#>               <select id="histogram-group.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="histogram-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1010954', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Columns to group the data for plotting For those plotting functions that do not support multiple groups, They will be concatenated into one column, using `group_by_sep` as the separator'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-4292-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8000977">
#>             <label class="control-label" id="histogram-facet.by-label" for="histogram-facet.by">Facet By</label>
#>             <div>
#>               <select id="histogram-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="histogram-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8000977', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3799468">
#>             <label class="control-label" id="histogram-facet.scale-label" for="histogram-facet.scale">Facet Scale</label>
#>             <div>
#>               <select id="histogram-facet.scale" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="histogram-facet.scale" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3799468', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify527010">
#>             <label class="control-label" id="histogram-facet.ncol-label" for="histogram-facet.ncol">Number of Columns</label>
#>             <input id="histogram-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify527010', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9865086">
#>             <label class="control-label" id="histogram-facet.nrow-label" for="histogram-facet.nrow">Number of Rows</label>
#>             <input id="histogram-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9865086', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6041740">
#>             <div class="material-switch">
#>               <label for="histogram-facet.by.row" style="padding-right: 10px;">Facet by Row</label>
#>               <input id="histogram-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="histogram-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6041740', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-4292-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1487828">
#>             <label class="control-label" id="histogram-bins-label" for="histogram-bins">Number of Bins</label>
#>             <input id="histogram-bins" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1487828', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of bins for the histogram.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5387602">
#>             <label class="control-label" id="histogram-bin.width-label" for="histogram-bin.width">Bin Width</label>
#>             <input id="histogram-bin.width" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5387602', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the width of the bins for the histogram.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1257893">
#>             <div class="material-switch">
#>               <label for="histogram-use.trend" style="padding-right: 10px;">Trend Line Only</label>
#>               <input id="histogram-use.trend" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="histogram-use.trend"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1257893', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value. If TRUE, use trend line instead of histogram.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9631817">
#>             <div class="material-switch">
#>               <label for="histogram-trend.skip.zero" style="padding-right: 10px;">Skip Zero Values</label>
#>               <input id="histogram-trend.skip.zero" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="histogram-trend.skip.zero"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9631817', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value. If TRUE, skip the zero count when drawing the trend line.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify469351">
#>             <div class="material-switch">
#>               <label for="histogram-add.trend" style="padding-right: 10px;">Add Trend to Histogram</label>
#>               <input id="histogram-add.trend" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="histogram-add.trend"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify469351', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value. If TRUE, add trend line to the histogram.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1614092">
#>             <label class="control-label" id="histogram-trend.alpha-label" for="histogram-trend.alpha">Trend Line Alpha</label>
#>             <input class="js-range-slider" id="histogram-trend.alpha" data-skin="shiny" data-min="0" data-max="1" data-from="1" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1614092', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the alpha of the trend line and points'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9364874">
#>             <label class="control-label" id="histogram-trend.linewidth-label" for="histogram-trend.linewidth">Trend Line Width</label>
#>             <input id="histogram-trend.linewidth" type="number" class="shiny-input-number form-control" value="0.8" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9364874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the width of the trend line'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9706813">
#>             <label class="control-label" id="histogram-trend.pt.size-label" for="histogram-trend.pt.size">Trend Point Size</label>
#>             <input id="histogram-trend.pt.size" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9706813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the size of the trend points'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7102740">
#>             <label class="control-label" id="histogram-plot.alpha-label" for="histogram-plot.alpha">Plot Alpha</label>
#>             <input class="js-range-slider" id="histogram-plot.alpha" data-skin="shiny" data-min="0" data-max="1" data-from="1" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7102740', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the transparency of the plot.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div id="histogram-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8850909">
#>             <label class="control-label" id="histogram-position-label" for="histogram-position">Position</label>
#>             <div>
#>               <select id="histogram-position" class="shiny-input-select"><option value="identity" selected>identity</option>
#> <option value="stack">stack</option>
#> <option value="dodge">dodge</option>
#> <option value="fill">fill</option></select>
#>               <script type="application/json" data-for="histogram-position" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8850909', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How should we position the values in each bin? Default is "identity". Unlike the default position = "stack" in link[ggplot2:geom_histogram]{ggplot2::geom_histogram} or link[ggplot2:geom_density]{ggplot2::geom_density}, the default position is "identity" to show the actual count or density for each group.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Rug" id="tab-4292-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9768753">
#>             <div class="material-switch">
#>               <label for="histogram-add.bars" style="padding-right: 10px;">Add Rug Plot</label>
#>               <input id="histogram-add.bars" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="histogram-add.bars"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9768753', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value. If TRUE, add lines to the plot to show the data distribution on the bottom.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify348997">
#>             <label class="control-label" id="histogram-bar.height-label" for="histogram-bar.height">Rug Bar Height</label>
#>             <input id="histogram-bar.height" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify348997', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the height of the bars. The actual height will be calculated based on the maximum density or count.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4387573">
#>             <label class="control-label" id="histogram-bar.alpha-label" for="histogram-bar.alpha">Rug Bar Alpha</label>
#>             <input class="js-range-slider" id="histogram-bar.alpha" data-skin="shiny" data-min="0" data-max="1" data-from="1" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4387573', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the alpha of the bars.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6444697">
#>             <label class="control-label" id="histogram-bar.width-label" for="histogram-bar.width">Rug Bar Width</label>
#>             <input id="histogram-bar.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6444697', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the width of the bars.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-4292-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="histogram-download.interactive" tabindex="-1" target="_blank" width="100%">
#>             <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>             Save Interactive
#>           </a>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="histogram-download.format-label" for="histogram-download.format">Download Format</label>
#>             <div>
#>               <select id="histogram-download.format" class="shiny-input-select"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>               <script type="application/json" data-for="histogram-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9948324">
#>             <label class="control-label" id="histogram-margin.t-label" for="histogram-margin.t">Margin Top</label>
#>             <input id="histogram-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9948324', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3146626">
#>             <label class="control-label" id="histogram-margin.b-label" for="histogram-margin.b">Margin Bottom</label>
#>             <input id="histogram-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3146626', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8558819">
#>             <label class="control-label" id="histogram-margin.l-label" for="histogram-margin.l">Margin Left</label>
#>             <input id="histogram-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8558819', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5403377">
#>             <label class="control-label" id="histogram-margin.r-label" for="histogram-margin.r">Margin Right</label>
#>             <input id="histogram-margin.r" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5403377', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8734173">
#>             <label class="control-label" id="histogram-subplot.margin-label" for="histogram-subplot.margin">Subplot Spacing</label>
#>             <input id="histogram-subplot.margin" type="number" class="shiny-input-number form-control" value="0.6" data-update-on="change" min="0" max="5" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8734173', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Spacing between facet panels as a fraction of the plot area. Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5155856">
#>             <label class="control-label" for="histogram-shape.fill">Shape Fill</label>
#>             <input id="histogram-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5155856', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8694593">
#>             <label class="control-label" for="histogram-shape.line.color">Shape Line Color</label>
#>             <input id="histogram-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8694593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8565226">
#>             <label class="control-label" id="histogram-shape.line.width-label" for="histogram-shape.line.width">Shape Line Width</label>
#>             <input id="histogram-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8565226', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3456832">
#>             <label class="control-label" id="histogram-shape.linetype-label" for="histogram-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select id="histogram-shape.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>               <script type="application/json" data-for="histogram-shape.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3456832', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1037">
#>             <label class="control-label" id="histogram-shape.opacity-label" for="histogram-shape.opacity">Shape Opacity</label>
#>             <input id="histogram-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1037', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-4292-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="histogram-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="histogram-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="histogram-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-title.font.family-label" for="histogram-title.font.family">Title Font</label>
#>             <div>
#>               <select id="histogram-title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="histogram-title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-text.colour">Title Color</label>
#>             <input id="histogram-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.title.font.size-label" for="histogram-axis.title.font.size">Axis Title Size</label>
#>             <input id="histogram-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-axis.title.font.color">Axis Title Color</label>
#>             <input id="histogram-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.title.font.family-label" for="histogram-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="histogram-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="histogram-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="histogram-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="histogram-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="histogram-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="histogram-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-axis.linecolor">Axis Line Color</label>
#>             <input id="histogram-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.linewidth-label" for="histogram-axis.linewidth">Axis Line Width</label>
#>             <input id="histogram-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.tickfont.size-label" for="histogram-axis.tickfont.size">Tick Label Size</label>
#>             <input id="histogram-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-axis.tickfont.color">Tick Label Color</label>
#>             <input id="histogram-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.tickfont.family-label" for="histogram-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="histogram-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="histogram-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.tickangle.x-label" for="histogram-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="histogram-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.tickangle.y-label" for="histogram-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="histogram-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.ticks-label" for="histogram-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="histogram-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="histogram-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-axis.tickcolor">Tick Mark Color</label>
#>             <input id="histogram-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.ticklen-label" for="histogram-axis.ticklen">Tick Mark Length</label>
#>             <input id="histogram-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-axis.tickwidth-label" for="histogram-axis.tickwidth">Tick Mark Width</label>
#>             <input id="histogram-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-facet.title.font.size-label" for="histogram-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="histogram-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="histogram-facet.title.font.color">Facet Title Color</label>
#>             <input id="histogram-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-facet.title.font.family-label" for="histogram-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select id="histogram-facet.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="histogram-facet.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-4292-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2051798">
#>             <label class="control-label" id="histogram-hline.intercepts-label" for="histogram-hline.intercepts">Y-intercepts</label>
#>             <input id="histogram-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2051798', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-hline.colors-label" for="histogram-hline.colors">Colors</label>
#>             <input id="histogram-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-hline.widths-label" for="histogram-hline.widths">Widths</label>
#>             <input id="histogram-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-hline.linetypes-label" for="histogram-hline.linetypes">Line types</label>
#>             <input id="histogram-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-hline.opacities-label" for="histogram-hline.opacities">Opacities (0-1)</label>
#>             <input id="histogram-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9452204">
#>             <label class="control-label" id="histogram-vline.intercepts-label" for="histogram-vline.intercepts">X-intercepts</label>
#>             <input id="histogram-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9452204', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-vline.colors-label" for="histogram-vline.colors">Colors</label>
#>             <input id="histogram-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-vline.widths-label" for="histogram-vline.widths">Widths</label>
#>             <input id="histogram-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-vline.linetypes-label" for="histogram-vline.linetypes">Line types</label>
#>             <input id="histogram-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="histogram-vline.opacities-label" for="histogram-vline.opacities">Opacities (0-1)</label>
#>             <input id="histogram-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="histogram-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="histogram-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="histogram-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="histogram-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="histogram-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#> </div>
```
