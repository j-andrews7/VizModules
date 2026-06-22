# Input UI components for the ViolinPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_ViolinPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotServer.md)
and
[`plotthis_ViolinPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_ViolinPlotInputsUI(
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
[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `x_sep` - Separator for x columns (not applicable in UI context)

- `in_form` - Data input format (not applicable - always long form)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `split_by_sep` - Only applies if `split_by` is used

- `symnum_args` - Significance symbol arguments (the Stats tab manages
  symbol display)

- `keep_empty` - Keep empty values (not implemented)

- `keep_na` - Keep NA values (not implemented)

- `group_by_sep` - Separator for group columns (not applicable in UI
  context)

- `group_name` - Group legend name (handled by plotly)

- `paired_by` - Pairing variable for paired tests (use the Stats tab
  "Paired Test" input instead)

- `x_text_angle` - X-axis text angle (handled by plotly axis settings)

- `step_increase` - Step increase for significance brackets (set via the
  Stats tab "Bracket Spacing")

- `fill_mode` - Fill mode for grouped data (handled automatically)

- `position_dodge_preserve` - Preserve dodge width (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `palreverse` - Reverse the color palette (not implemented)

- `alpha` - Alpha transparency (not implemented in UI)

- `stack` - Stack violins (not implemented)

- `add_beeswarm` - Add beeswarm points (not implemented in UI)

- `beeswarm_method` - Beeswarm arrangement method (not implemented)

- `beeswarm_cex` - Beeswarm point size factor (not implemented)

- `beeswarm_priority` - Beeswarm priority order (not implemented)

- `beeswarm_dodge` - Beeswarm dodge width (not implemented)

- `add_trend` - Add trend line (not implemented in UI)

- `trend_color` - Trend line color (not implemented)

- `trend_linewidth` - Trend line width (not implemented)

- `trend_ptsize` - Trend point size (not implemented)

- `add_stat` - Add statistical annotation (not implemented)

- `stat_name` - Statistical test name (not implemented)

- `stat_color` - Statistical annotation color (not implemented)

- `stat_size` - Statistical annotation size (not implemented)

- `stat_stroke` - Statistical annotation stroke (not implemented)

- `stat_shape` - Statistical annotation shape (not implemented)

- `add_bg` - Add background shading (not implemented)

- `bg_palette` - Background palette (not implemented)

- `bg_palcolor` - Background color (not implemented)

- `bg_alpha` - Background transparency (not implemented)

- `add_line` - Add horizontal line (not implemented in UI - use Lines
  tab)

- `line_color` - Line color (not implemented)

- `line_width` - Line width (not implemented)

- `line_type` - Line type (not implemented)

- `comparisons` - plotthis pairwise comparisons are not passed;
  equivalent pairwise significance testing is provided via the module's
  Stats tab (see "Statistical annotation parameters")

- `ref_group` - Reference group for comparisons (use the Stats tab
  instead)

- `pairwise_method` - Pairwise test method (set via the Stats tab "Test"
  input instead)

- `multiplegroup_comparisons` - Multiple-group comparison flag (use the
  Stats tab instead)

- `multiple_method` - Multiple-group test method (set via the Stats tab
  "Test" input instead)

- `sig_label` - Significance label format (set via the Stats tab
  "Display" input instead)

- `sig_labelsize` - Significance label size (handled by the Stats tab)

- `hide_ns` - Hide non-significant comparisons (use the Stats tab "Hide
  Non-Significant" input)

- `seed` - Random seed (not applicable)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `legend.direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X Data", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y Data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group By", default: "")

- `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default:
  FALSE)

- `sort_x` - Sort X-axis by statistic (UI: "Sort X By", default: "none")

- `y_max` - Maximum Y-axis value (UI: "Y Max", default: calculated)

- `y_min` - Minimum Y-axis value (UI: "Y Min", default: calculated)

- `add_point` - Add jitter points (UI: "Add Jitter Points", default:
  FALSE)

- `pt_size` - Point size (UI: "Point Size", default: 1)

- `pt_alpha` - Point transparency (UI: "Point Alpha", default: 1)

- `jitter_width` - Jitter width (UI: "Jitter Width", default: 0.5)

- `jitter_height` - Jitter height (UI: "Jitter Height", default: 0)

- `pt_color` - Point outline color (UI: "Point Outline Colour", default:
  "#000000")

- `add_box` - Add box plot overlay (UI: "Add Box", default: FALSE)

- `box_color` - Box outline color (UI: "Box Colour", default: "#000000")

- `box_width` - Box width (UI: "Box Width", default: 0.1)

- `box_ptsize` - Box point size (UI: "Box Point Size", default: 2.5)

- `highlight` - Highlight condition (UI: "Highlight", default: "")

- `highlight_color` - Highlight color (UI: "Highlight Colour", default:
  "#000000")

- `highlight_size` - Highlight size (UI: "Highlight Size", default: 1)

- `highlight_alpha` - Highlight transparency (UI: "Highlight Alpha",
  default: 1)

- `facet_by` - Faceting variable (UI: "Facet By", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet By Row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Statistical annotation parameters

The module provides plotly-based significance testing via the Stats tab.
The following inputs are available:

- `stats.enabled` - Enable statistical annotations (UI: "Enable Stats",
  default: FALSE)

- `stat.test` - Test to apply: Wilcoxon, t-test, Kruskal-Wallis, or
  ANOVA (UI: "Test")

- `stat.p.adjust` - P-value adjustment method (UI: "P-value Adjustment",
  default: "holm")

- `stat.display` - Value to display: adjusted p-value, p-value, or
  symbols (UI: "Display")

- `stat.sig.threshold` - Significance threshold for symbols/hiding (UI:
  "Significance Threshold")

- `stat.hide.ns` - Hide non-significant comparisons (UI: "Hide
  Non-Significant", default: FALSE)

- `stat.paired` - Use a paired test (UI: "Paired Test", default: FALSE)

- `stat.pairs` - Group comparisons to test (UI: "Comparisons", multiple
  selection)

- `stat.line.color` - Bracket line color (UI: "Line Color", default:
  "#000000")

- `stat.line.width` - Bracket line width (UI: "Line Width")

- `stat.bracket.style` - Bracket style, capped or flat (UI: "Bracket
  Style")

- `stat.step.increase` - Vertical spacing between stacked brackets (UI:
  "Bracket Spacing")

- `stat.text.bump` - Offset of the significance text above the bracket
  (UI: "Text Offset")

- `stat.bracket.inset` - Horizontal inset of the brackets (UI: "Bracket
  Inset")

- `stat.per.facet` - Compute statistics independently per facet panel
  (UI: "Per Facet Panel")

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis Title Size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis Title
  Color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis Title
  Font", default: "Arial")

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

[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_ViolinPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotOutputUI.md),
[`plotthis_ViolinPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotServer.md),
[`plotthis_ViolinPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_ViolinPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_ViolinPlotInputsUI("ViolinPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="ViolinPlot-ViolinPlotTabsetPanel" data-tabsetid="1890">
#>     <li class="active">
#>       <a href="#tab-1890-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-3" data-toggle="tab" data-bs-toggle="tab" data-value="Highlight">Highlight</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-4" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-5" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-6" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-7" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-8" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1890-9" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1890">
#>     <div class="tab-pane active" data-value="Data" id="tab-1890-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7423262">
#>             <label class="control-label" id="ViolinPlot-x.data-label" for="ViolinPlot-x.data">X Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-x.data"><option value=""></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7423262', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the x-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5492207">
#>             <label class="control-label" id="ViolinPlot-y.data-label" for="ViolinPlot-y.data">Y Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-y.data"><option value=""></option>
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
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5492207', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the y-axis.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6345443">
#>             <label class="control-label" id="ViolinPlot-group.by-label" for="ViolinPlot-group.by">Group By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-group.by"><option value="" selected></option>
#> <option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6345443', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Columns to group the data for plotting For those plotting functions that do not support multiple groups, They will be concatenated into one column, using `group_by_sep` as the separator'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div id="ViolinPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-1890-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1366286">
#>             <label class="control-label" id="ViolinPlot-sort_x-label" for="ViolinPlot-sort_x">Sort X By</label>
#>             <input id="ViolinPlot-sort_x" type="text" class="shiny-input-text form-control" value="" placeholder="mean(y) or mean(-y)" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1366286', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'An expression (in character string) to order x-axis. For example, "mean(y)" will order the x-axis by the mean of y. Default is NULL, which means keeping the original order of x. Note that when keep_empty is TRUE for x, the empty x levels will always be placed at the end of the x-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9302335">
#>             <label class="control-label" id="ViolinPlot-y.max-label" for="ViolinPlot-y.max">Y Max</label>
#>             <input id="ViolinPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9302335', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value or a character string to specify the maximum value of the y-axis. You can also use quantile notation like "q95" to specify the 95th percentile. When comparisons are set and a numeric y_max is provided, it will be used to set the y-axis limit, including the significance labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6511186">
#>             <label class="control-label" id="ViolinPlot-y.min-label" for="ViolinPlot-y.min">Y Min</label>
#>             <input id="ViolinPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6511186', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value or a character string to specify the minimum value of the y-axis. You can also use quantile notation like "q5" to specify the 5th percentile.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5287093">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-add.points" style="padding-right: 10px;">Add Jitter</label>
#>               <input id="ViolinPlot-add.points" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-add.points"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5287093', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value to add (jitter) points to the plot.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2251154">
#>             <label class="control-label" id="ViolinPlot-pt.size-label" for="ViolinPlot-pt.size">Point Size</label>
#>             <input id="ViolinPlot-pt.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2251154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the size of the points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9832668">
#>             <label class="control-label" id="ViolinPlot-pt.alpha-label" for="ViolinPlot-pt.alpha">Point Alpha</label>
#>             <input id="ViolinPlot-pt.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9832668', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the transparency of the points.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1090488">
#>             <label class="control-label" id="ViolinPlot-jitter.width-label" for="ViolinPlot-jitter.width">Jitter Width</label>
#>             <input id="ViolinPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1090488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the width of the jitter. Defaults to 0.5, but when paired_by is provided, it will be set to 0.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify699456">
#>             <label class="control-label" id="ViolinPlot-jitter.height-label" for="ViolinPlot-jitter.height">Jitter Height</label>
#>             <input id="ViolinPlot-jitter.height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify699456', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the height of the jitter.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7776455">
#>             <label class="control-label" for="ViolinPlot-pt.color">Point Outline Colour</label>
#>             <input id="ViolinPlot-pt.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7776455', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string to specify the color of the points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6583222">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-add.box" style="padding-right: 10px;">Add Box</label>
#>               <input id="ViolinPlot-add.box" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-add.box"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6583222', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value to add box plot to the plot.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2592028">
#>             <label class="control-label" for="ViolinPlot-box.color">Box Colour</label>
#>             <input id="ViolinPlot-box.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2592028', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string to specify the color of the box plot.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9183378">
#>             <label class="control-label" id="ViolinPlot-box.width-label" for="ViolinPlot-box.width">Box Width</label>
#>             <input id="ViolinPlot-box.width" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9183378', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the width of the box plot.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1487104">
#>             <label class="control-label" id="ViolinPlot-box.ptsize-label" for="ViolinPlot-box.ptsize">Box Point Size</label>
#>             <input id="ViolinPlot-box.ptsize" type="number" class="shiny-input-number form-control" value="2.5" data-update-on="change" min="0" max="10"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1487104', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the size of the box plot points in the middle.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Highlight" id="tab-1890-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6406805">
#>             <label class="control-label" id="ViolinPlot-highlight-label" for="ViolinPlot-highlight">Highlight</label>
#>             <input id="ViolinPlot-highlight" type="text" class="shiny-input-text form-control" value="" placeholder="E.g. y &gt; 0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6406805', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A vector of character strings to highlight the points. It should be a subset of the row names of the data. If TRUE, it will highlight all points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2012385">
#>             <label class="control-label" for="ViolinPlot-highlight.colour">Highlight Colour</label>
#>             <input id="ViolinPlot-highlight.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2012385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string to specify the color of the highlighted points.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7436213">
#>             <label class="control-label" id="ViolinPlot-highlight.size-label" for="ViolinPlot-highlight.size">Highlight Size</label>
#>             <input id="ViolinPlot-highlight.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7436213', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the size of the highlighted points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8476374">
#>             <label class="control-label" id="ViolinPlot-highlight.alpha-label" for="ViolinPlot-highlight.alpha">Highlight Alpha</label>
#>             <input id="ViolinPlot-highlight.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8476374', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value to specify the transparency of the highlighted points.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-1890-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8536358">
#>             <label class="control-label" id="ViolinPlot-facet.by-label" for="ViolinPlot-facet.by">Facet By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-facet.by"><option value="" selected></option>
#> <option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8536358', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8034125">
#>             <label class="control-label" id="ViolinPlot-facet.scale-label" for="ViolinPlot-facet.scale">Facet Scale</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-facet.scale"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8034125', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify238768">
#>             <label class="control-label" id="ViolinPlot-facet.ncol-label" for="ViolinPlot-facet.ncol">Columns</label>
#>             <input id="ViolinPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify238768', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7953777">
#>             <label class="control-label" id="ViolinPlot-facet.nrow-label" for="ViolinPlot-facet.nrow">Rows</label>
#>             <input id="ViolinPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7953777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8865505">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-facet.by.row" style="padding-right: 10px;">Facet By Row</label>
#>               <input id="ViolinPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8865505', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6000373">
#>             <label class="control-label" id="ViolinPlot-subplot.margin.x-label" for="ViolinPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="ViolinPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6000373', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4327882">
#>             <label class="control-label" id="ViolinPlot-subplot.margin.y-label" for="ViolinPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="ViolinPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4327882', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-1890-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9202758">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-stats.enabled" style="padding-right: 10px;">Enable Stats</label>
#>               <input id="ViolinPlot-stats.enabled" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-stats.enabled"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9202758', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle pairwise statistical testing with bracket annotations on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6160144">
#>             <label class="control-label" id="ViolinPlot-stat.test-label" for="ViolinPlot-stat.test">Test</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-stat.test"><option value="wilcox.test" selected>Wilcoxon</option>
#> <option value="t.test">t-test</option>
#> <option value="kruskal.test">Kruskal-Wallis</option>
#> <option value="anova">ANOVA</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6160144', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Statistical test for comparisons. Wilcoxon and t-test perform pairwise comparisons. Kruskal-Wallis and ANOVA perform omnibus tests.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4357182">
#>             <label class="control-label" id="ViolinPlot-stat.p.adjust-label" for="ViolinPlot-stat.p.adjust">P-value Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-stat.p.adjust"><option value="holm" selected>holm</option>
#> <option value="hochberg">hochberg</option>
#> <option value="hommel">hommel</option>
#> <option value="bonferroni">bonferroni</option>
#> <option value="BH">BH</option>
#> <option value="BY">BY</option>
#> <option value="fdr">fdr</option>
#> <option value="none">none</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4357182', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Method for multiple testing correction applied to all p-values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8973044">
#>             <label class="control-label" id="ViolinPlot-stat.display-label" for="ViolinPlot-stat.display">Display</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-stat.display"><option value="p.adj" selected>Adjusted P-value</option>
#> <option value="p.value">P-value</option>
#> <option value="symbol">Symbols</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8973044', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7690135">
#>             <label class="control-label" id="ViolinPlot-stat.sig.threshold-label" for="ViolinPlot-stat.sig.threshold">Significance Threshold</label>
#>             <input id="ViolinPlot-stat.sig.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7690135', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '(Adjusted, if applied) P-values above this threshold are labeled &#39;ns&#39;. Also used as the boundary for the &#39;*&#39; significance symbol.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1281158">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-stat.hide.ns" style="padding-right: 10px;">Hide Non-Significant</label>
#>               <input id="ViolinPlot-stat.hide.ns" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-stat.hide.ns"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1281158', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hide comparison brackets where the adjusted p-value exceeds the significance threshold'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5386331">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-stat.paired" style="padding-right: 10px;">Paired Test</label>
#>               <input id="ViolinPlot-stat.paired" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-stat.paired"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5386331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform paired tests (Wilcoxon signed-rank or paired t-test). Each group must have the same number of observations in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1290163">
#>             <label class="control-label" id="ViolinPlot-stat.pairs-label" for="ViolinPlot-stat.pairs">Comparisons</label>
#>             <div>
#>               <select id="ViolinPlot-stat.pairs" class="shiny-input-select" multiple="multiple"></select>
#>               <script type="application/json" data-for="ViolinPlot-stat.pairs">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1290163', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select specific pairwise comparisons to display. If empty, all possible pairs are tested.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5109649">
#>             <label class="control-label" for="ViolinPlot-stat.line.color">Line Color</label>
#>             <input id="ViolinPlot-stat.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5109649', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for bracket lines and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5437927">
#>             <label class="control-label" id="ViolinPlot-stat.line.width-label" for="ViolinPlot-stat.line.width">Line Width</label>
#>             <input id="ViolinPlot-stat.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="50" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5437927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of bracket lines in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2417761">
#>             <label class="control-label" id="ViolinPlot-stat.bracket.style-label" for="ViolinPlot-stat.bracket.style">Bracket Style</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-stat.bracket.style"><option value="capped" selected>Capped</option>
#> <option value="flat">Flat</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2417761', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8031441">
#>             <label class="control-label" id="ViolinPlot-stat.step.increase-label" for="ViolinPlot-stat.step.increase">Bracket Spacing</label>
#>             <input id="ViolinPlot-stat.step.increase" type="number" class="shiny-input-number form-control" value="0.06" data-update-on="change" min="0.01" max="0.3" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8031441', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range used as vertical spacing between successive bracket levels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9479137">
#>             <label class="control-label" id="ViolinPlot-stat.text.bump-label" for="ViolinPlot-stat.text.bump">Text Offset</label>
#>             <input id="ViolinPlot-stat.text.bump" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0.005" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9479137', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range for vertical distance between the bracket line and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4073614">
#>             <label class="control-label" id="ViolinPlot-stat.bracket.inset-label" for="ViolinPlot-stat.bracket.inset">Bracket Inset</label>
#>             <input id="ViolinPlot-stat.bracket.inset" type="number" class="shiny-input-number form-control" value="0.025" data-update-on="change" min="0" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4073614', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5147446">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-stat.per.facet" style="padding-right: 10px;">Per Facet Panel</label>
#>               <input id="ViolinPlot-stat.per.facet" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-stat.per.facet"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5147446', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-1890-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9815418">
#>             <label class="control-label" id="ViolinPlot-legend.title.size-label" for="ViolinPlot-legend.title.size">Legend Title Size</label>
#>             <input id="ViolinPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9815418', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3541867">
#>             <label class="control-label" id="ViolinPlot-legend.text.size-label" for="ViolinPlot-legend.text.size">Legend Text Size</label>
#>             <input id="ViolinPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3541867', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-1890-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="ViolinPlot-download.format-label" for="ViolinPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4558402">
#>             <label class="control-label" id="ViolinPlot-margin.t-label" for="ViolinPlot-margin.t">Margin Top</label>
#>             <input id="ViolinPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4558402', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2200247">
#>             <label class="control-label" id="ViolinPlot-margin.b-label" for="ViolinPlot-margin.b">Margin Bottom</label>
#>             <input id="ViolinPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2200247', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify818331">
#>             <label class="control-label" id="ViolinPlot-margin.l-label" for="ViolinPlot-margin.l">Margin Left</label>
#>             <input id="ViolinPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify818331', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3692361">
#>             <label class="control-label" id="ViolinPlot-margin.r-label" for="ViolinPlot-margin.r">Margin Right</label>
#>             <input id="ViolinPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3692361', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1266666">
#>             <label class="control-label" for="ViolinPlot-shape.fill">Shape Fill</label>
#>             <input id="ViolinPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1266666', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7398725">
#>             <label class="control-label" for="ViolinPlot-shape.line.color">Shape Line Color</label>
#>             <input id="ViolinPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7398725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9558662">
#>             <label class="control-label" id="ViolinPlot-shape.line.width-label" for="ViolinPlot-shape.line.width">Shape Line Width</label>
#>             <input id="ViolinPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9558662', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6686745">
#>             <label class="control-label" id="ViolinPlot-shape.linetype-label" for="ViolinPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6686745', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4680894">
#>             <label class="control-label" id="ViolinPlot-shape.opacity-label" for="ViolinPlot-shape.opacity">Shape Opacity</label>
#>             <input id="ViolinPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4680894', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1890-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="ViolinPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-title.font.family-label" for="ViolinPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-title.font.color">Title Color</label>
#>             <input id="ViolinPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-title.font.size-label" for="ViolinPlot-title.font.size">Title Size</label>
#>             <input id="ViolinPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.title.horizontal.position-label" for="ViolinPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="ViolinPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.title.font.size-label" for="ViolinPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="ViolinPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="ViolinPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.title.font.family-label" for="ViolinPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ViolinPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ViolinPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="ViolinPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ViolinPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-grid.color">Gridline Color</label>
#>             <input id="ViolinPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="ViolinPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.linewidth-label" for="ViolinPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="ViolinPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickfont.size-label" for="ViolinPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="ViolinPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="ViolinPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickfont.family-label" for="ViolinPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickangle.x-label" for="ViolinPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="ViolinPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickangle.y-label" for="ViolinPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="ViolinPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.ticks-label" for="ViolinPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="ViolinPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.ticklen-label" for="ViolinPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="ViolinPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickwidth-label" for="ViolinPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="ViolinPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.title.font.size-label" for="ViolinPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="ViolinPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="ViolinPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.title.font.family-label" for="ViolinPlot-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ViolinPlot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-1890-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5381924">
#>             <label class="control-label" id="ViolinPlot-hline.intercepts-label" for="ViolinPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="ViolinPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5381924', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3309537">
#>             <label class="control-label" id="ViolinPlot-hline.colors-label" for="ViolinPlot-hline.colors">Y Colors</label>
#>             <input id="ViolinPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3309537', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6286821">
#>             <label class="control-label" id="ViolinPlot-hline.widths-label" for="ViolinPlot-hline.widths">Y Widths</label>
#>             <input id="ViolinPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6286821', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4525525">
#>             <label class="control-label" id="ViolinPlot-hline.linetypes-label" for="ViolinPlot-hline.linetypes">Y Line Types</label>
#>             <input id="ViolinPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4525525', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8880151">
#>             <label class="control-label" id="ViolinPlot-hline.opacities-label" for="ViolinPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="ViolinPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8880151', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7842018">
#>             <label class="control-label" id="ViolinPlot-vline.intercepts-label" for="ViolinPlot-vline.intercepts">X-intercepts</label>
#>             <input id="ViolinPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7842018', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1380596">
#>             <label class="control-label" id="ViolinPlot-vline.colors-label" for="ViolinPlot-vline.colors">X Colors</label>
#>             <input id="ViolinPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1380596', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2813131">
#>             <label class="control-label" id="ViolinPlot-vline.widths-label" for="ViolinPlot-vline.widths">X Widths</label>
#>             <input id="ViolinPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2813131', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7069465">
#>             <label class="control-label" id="ViolinPlot-vline.linetypes-label" for="ViolinPlot-vline.linetypes">X Line Types</label>
#>             <input id="ViolinPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7069465', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4421869">
#>             <label class="control-label" id="ViolinPlot-vline.opacities-label" for="ViolinPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="ViolinPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4421869', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6776985">
#>             <label class="control-label" id="ViolinPlot-abline.slopes-label" for="ViolinPlot-abline.slopes">Ab Slopes</label>
#>             <input id="ViolinPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6776985', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7007150">
#>             <label class="control-label" id="ViolinPlot-abline.intercepts-label" for="ViolinPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="ViolinPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7007150', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify684065">
#>             <label class="control-label" id="ViolinPlot-abline.colors-label" for="ViolinPlot-abline.colors">Ab Colors</label>
#>             <input id="ViolinPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify684065', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9585035">
#>             <label class="control-label" id="ViolinPlot-abline.widths-label" for="ViolinPlot-abline.widths">Ab Widths</label>
#>             <input id="ViolinPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9585035', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2444835">
#>             <label class="control-label" id="ViolinPlot-abline.linetypes-label" for="ViolinPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="ViolinPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2444835', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9262833">
#>             <label class="control-label" id="ViolinPlot-abline.opacities-label" for="ViolinPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="ViolinPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9262833', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="ViolinPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="ViolinPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="ViolinPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="ViolinPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="ViolinPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="ViolinPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('ViolinPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
