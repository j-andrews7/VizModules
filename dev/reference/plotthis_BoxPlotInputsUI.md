# Input UI components for the BoxPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BoxPlotServer.md)
and
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BoxPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_BoxPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
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

- `base` - Base plot type box/violin/bar (fixed to "box" in this module)

- `fill_mode` - Fill mode for grouped data (handled automatically)

- `position_dodge_preserve` - Preserve dodge width (not implemented)

- `add_errorbar` - Add error bars (only for base = "bar"; not
  implemented)

- `errorbar_color` - Error bar color (not implemented)

- `errorbar_width` - Error bar cap width (not implemented)

- `errorbar_linewidth` - Error bar line width (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `palreverse` - Reverse the color palette (not implemented)

- `alpha` - Alpha transparency (not implemented in UI)

- `stack` - Stack boxplots (not implemented)

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
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X data", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group by", default: "")

- `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default:
  FALSE)

- `sort_x` - Sort X-axis by statistic (UI: "Sort X by", default: "")

- `y_max` - Maximum Y-axis value (UI: "Max Value of Y Axis", default:
  calculated)

- `y_min` - Minimum Y-axis value (UI: "Min Value of Y Axis", default:
  calculated)

- `add_point` - Add jitter points (UI: "Add Jitter Points", default:
  FALSE)

- `pt_size` - Point size (UI: "Point Size", default: 1)

- `pt_alpha` - Point transparency (UI: "Point Alpha", default: 1)

- `jitter_width` - Jitter width (UI: "Jitter Width", default: 0.3)

- `pt_color` - Point outline color (UI: "Point Outline Colour", default:
  "#000000")

- `highlight` - Highlight condition (UI: "Highlight", default: "")

- `highlight_color` - Highlight color (UI: "Highlight Colour", default:
  "#000000")

- `highlight_size` - Highlight size (UI: "Highlight Size", default: 1)

- `highlight_alpha` - Highlight transparency (UI: "Highlight Alpha",
  default: 1)

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Statistical annotation parameters

The module provides plotly-based significance testing via the Stats tab
(a reimplementation of the plotthis significance-testing features). The
following inputs are available:

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

- `boxplot.width` - Width of boxplot (UI: "Boxplot Width", default: 0.8)

- `show.outliers` - Show outlier points (UI: "Show Outliers", default:
  TRUE)

- `axis.title.font.size` - Axis title font size (UI: "Axis title size",
  default: 18)

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

[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md),
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BoxPlotOutputUI.md),
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BoxPlotServer.md),
[`plotthis_BoxPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BoxPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="BoxPlot-BoxPlotTabsetPanel" data-tabsetid="9155">
#>     <li class="active">
#>       <a href="#tab-9155-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-3" data-toggle="tab" data-bs-toggle="tab" data-value="Highlight">Highlight</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-4" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-5" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-6" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-7" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-8" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9155-9" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9155">
#>     <div class="tab-pane active" data-value="Data" id="tab-9155-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7277020">
#>             <label class="control-label" id="BoxPlot-x.data-label" for="BoxPlot-x.data">X Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-x.data"><option value=""></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7277020', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the x-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8725874">
#>             <label class="control-label" id="BoxPlot-y.data-label" for="BoxPlot-y.data">Y Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-y.data"><option value=""></option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8725874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to plot for the y-axis.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3819816">
#>             <label class="control-label" id="BoxPlot-group.by-label" for="BoxPlot-group.by">Group By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-group.by"><option value="" selected></option>
#> <option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3819816', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Columns to group the data for plotting For those plotting functions that do not support multiple groups, They will be concatenated into one column, using `group_by_sep` as the separator'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8927457">
#>             <div class="material-switch">
#>               <label for="BoxPlot-show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="BoxPlot-show.outliers" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-show.outliers"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8927457', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether outlier points beyond the whiskers are displayed on the boxplot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div id="BoxPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-9155-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8438703">
#>             <label class="control-label" id="BoxPlot-boxplot.width-label" for="BoxPlot-boxplot.width">Boxplot Width</label>
#>             <input id="BoxPlot-boxplot.width" type="number" class="shiny-input-number form-control" value="0.8" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8438703', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the relative width of each boxplot, where 1 fills the entire available space'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7297612">
#>             <label class="control-label" id="BoxPlot-sort_x-label" for="BoxPlot-sort_x">Sort X By</label>
#>             <input id="BoxPlot-sort_x" type="text" class="shiny-input-text form-control" value="" placeholder="mean(y data col name)" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7297612', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'An R expression string (e.g., `"mean(y)"`) to order x-axis categories.  Default `NULL` keeps the original order. When `keep_empty_x` is `TRUE`, empty levels are placed last.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify384150">
#>             <label class="control-label" id="BoxPlot-y.max-label" for="BoxPlot-y.max">Max Value of Y Axis</label>
#>             <input id="BoxPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-Inf" max="Inf"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify384150', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3338233">
#>             <label class="control-label" id="BoxPlot-y.min-label" for="BoxPlot-y.min">Y Axis Min</label>
#>             <input id="BoxPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-Inf" max="Inf"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3338233', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7492726">
#>             <div class="material-switch">
#>               <label for="BoxPlot-add.points" style="padding-right: 10px;">Add Jitter Points</label>
#>               <input id="BoxPlot-add.points" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-add.points"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7492726', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical; add jittered or beeswarm points to the plot.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9131580">
#>             <label class="control-label" id="BoxPlot-pt.size-label" for="BoxPlot-pt.size">Point Size</label>
#>             <input id="BoxPlot-pt.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9131580', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric size of the points.  Default computed from data size: `min(3000 / nrow(data), 0.6)`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2043291">
#>             <label class="control-label" id="BoxPlot-pt.alpha-label" for="BoxPlot-pt.alpha">Point Alpha</label>
#>             <input id="BoxPlot-pt.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2043291', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric transparency of the points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4717556">
#>             <label class="control-label" id="BoxPlot-jitter.width-label" for="BoxPlot-jitter.width">Jitter Width</label>
#>             <input id="BoxPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4717556', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric width of the jitter.  Defaults to `0.5`, but set to `0` when `paired_by` is provided.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3851831">
#>             <label class="control-label" for="BoxPlot-pt.color">Point Outline Colour</label>
#>             <input id="BoxPlot-pt.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3851831', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of the points.  When `add_beeswarm = TRUE` and `pt_color` is `NULL`, points are coloured by the fill variable.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Highlight" id="tab-9155-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3927519">
#>             <label class="control-label" id="BoxPlot-highlight-label" for="BoxPlot-highlight">Highlight</label>
#>             <input id="BoxPlot-highlight" type="text" class="shiny-input-text form-control" value="" placeholder="E.g. col name &gt; 0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3927519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A specification of points to highlight: `TRUE` (all), a numeric index vector, a logical expression string, or a character vector of row names.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2183385">
#>             <label class="control-label" for="BoxPlot-highlight.colour">Highlight Colour</label>
#>             <input id="BoxPlot-highlight.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2183385', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Colour of highlighted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify72090">
#>             <label class="control-label" id="BoxPlot-highlight.size-label" for="BoxPlot-highlight.size">Highlight Size</label>
#>             <input id="BoxPlot-highlight.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify72090', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Size of highlighted points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3637122">
#>             <label class="control-label" id="BoxPlot-highlight.alpha-label" for="BoxPlot-highlight.alpha">Highlight Alpha</label>
#>             <input id="BoxPlot-highlight.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3637122', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Alpha of highlighted points.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-9155-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5261067">
#>             <label class="control-label" id="BoxPlot-facet.by-label" for="BoxPlot-facet.by">Facet By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-facet.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5261067', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8441634">
#>             <label class="control-label" id="BoxPlot-facet.scale-label" for="BoxPlot-facet.scale">Facet Scale</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-facet.scale"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8441634', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1359912">
#>             <label class="control-label" id="BoxPlot-facet.ncol-label" for="BoxPlot-facet.ncol">Columns</label>
#>             <input id="BoxPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1359912', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3764673">
#>             <label class="control-label" id="BoxPlot-facet.nrow-label" for="BoxPlot-facet.nrow">Rows</label>
#>             <input id="BoxPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3764673', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2633087">
#>             <div class="material-switch">
#>               <label for="BoxPlot-facet.by.row" style="padding-right: 10px;">Facet by Row</label>
#>               <input id="BoxPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2633087', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4978530">
#>             <label class="control-label" id="BoxPlot-subplot.margin.x-label" for="BoxPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="BoxPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4978530', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify195253">
#>             <label class="control-label" id="BoxPlot-subplot.margin.y-label" for="BoxPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="BoxPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify195253', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-9155-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify871839">
#>             <div class="material-switch">
#>               <label for="BoxPlot-stats.enabled" style="padding-right: 10px;">Enable Stats</label>
#>               <input id="BoxPlot-stats.enabled" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-stats.enabled"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify871839', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle pairwise statistical testing with bracket annotations on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9959626">
#>             <label class="control-label" id="BoxPlot-stat.test-label" for="BoxPlot-stat.test">Test</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-stat.test"><option value="wilcox.test" selected>Wilcoxon</option>
#> <option value="t.test">t-test</option>
#> <option value="kruskal.test">Kruskal-Wallis</option>
#> <option value="anova">ANOVA</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9959626', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Statistical test for comparisons. Wilcoxon and t-test perform pairwise comparisons. Kruskal-Wallis and ANOVA perform omnibus tests.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9421322">
#>             <label class="control-label" id="BoxPlot-stat.p.adjust-label" for="BoxPlot-stat.p.adjust">P-value Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-stat.p.adjust"><option value="holm" selected>holm</option>
#> <option value="hochberg">hochberg</option>
#> <option value="hommel">hommel</option>
#> <option value="bonferroni">bonferroni</option>
#> <option value="BH">BH</option>
#> <option value="BY">BY</option>
#> <option value="fdr">fdr</option>
#> <option value="none">none</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9421322', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Method for multiple testing correction applied to all p-values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1243735">
#>             <label class="control-label" id="BoxPlot-stat.display-label" for="BoxPlot-stat.display">Display</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-stat.display"><option value="p.adj" selected>Adjusted P-value</option>
#> <option value="p.value">P-value</option>
#> <option value="symbol">Symbols</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1243735', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1151893">
#>             <label class="control-label" id="BoxPlot-stat.sig.threshold-label" for="BoxPlot-stat.sig.threshold">Significance Threshold</label>
#>             <input id="BoxPlot-stat.sig.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1151893', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '(Adjusted, if applied) P-values above this threshold are labeled &#39;ns&#39;. Also used as the boundary for the &#39;*&#39; significance symbol.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3666881">
#>             <div class="material-switch">
#>               <label for="BoxPlot-stat.hide.ns" style="padding-right: 10px;">Hide Non-Significant</label>
#>               <input id="BoxPlot-stat.hide.ns" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-stat.hide.ns"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3666881', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hide comparison brackets where the adjusted p-value exceeds the significance threshold'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4710400">
#>             <div class="material-switch">
#>               <label for="BoxPlot-stat.paired" style="padding-right: 10px;">Paired Test</label>
#>               <input id="BoxPlot-stat.paired" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-stat.paired"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4710400', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform paired tests (Wilcoxon signed-rank or paired t-test). Each group must have the same number of observations in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7841724">
#>             <label class="control-label" id="BoxPlot-stat.pairs-label" for="BoxPlot-stat.pairs">Comparisons</label>
#>             <div>
#>               <select id="BoxPlot-stat.pairs" class="shiny-input-select" multiple="multiple"></select>
#>               <script type="application/json" data-for="BoxPlot-stat.pairs">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7841724', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select specific pairwise comparisons to display. If empty, all possible pairs are tested.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4903928">
#>             <label class="control-label" for="BoxPlot-stat.line.color">Line Color</label>
#>             <input id="BoxPlot-stat.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4903928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for bracket lines and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1019510">
#>             <label class="control-label" id="BoxPlot-stat.line.width-label" for="BoxPlot-stat.line.width">Line Width</label>
#>             <input id="BoxPlot-stat.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="50" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1019510', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of bracket lines in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9434597">
#>             <label class="control-label" id="BoxPlot-stat.bracket.style-label" for="BoxPlot-stat.bracket.style">Bracket Style</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-stat.bracket.style"><option value="capped" selected>Capped</option>
#> <option value="flat">Flat</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9434597', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7061395">
#>             <label class="control-label" id="BoxPlot-stat.step.increase-label" for="BoxPlot-stat.step.increase">Bracket Spacing</label>
#>             <input id="BoxPlot-stat.step.increase" type="number" class="shiny-input-number form-control" value="0.06" data-update-on="change" min="0.01" max="0.3" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7061395', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range used as vertical spacing between successive bracket levels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5022642">
#>             <label class="control-label" id="BoxPlot-stat.text.bump-label" for="BoxPlot-stat.text.bump">Text Offset</label>
#>             <input id="BoxPlot-stat.text.bump" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0.005" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5022642', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range for vertical distance between the bracket line and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5299348">
#>             <label class="control-label" id="BoxPlot-stat.bracket.inset-label" for="BoxPlot-stat.bracket.inset">Bracket Inset</label>
#>             <input id="BoxPlot-stat.bracket.inset" type="number" class="shiny-input-number form-control" value="0.025" data-update-on="change" min="0" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5299348', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2584264">
#>             <div class="material-switch">
#>               <label for="BoxPlot-stat.per.facet" style="padding-right: 10px;">Per Facet Panel</label>
#>               <input id="BoxPlot-stat.per.facet" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-stat.per.facet"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2584264', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-9155-6">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7117534">
#>             <label class="control-label" id="BoxPlot-legend.title.size-label" for="BoxPlot-legend.title.size">Legend Title Size</label>
#>             <input id="BoxPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7117534', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9684625">
#>             <label class="control-label" id="BoxPlot-legend.text.size-label" for="BoxPlot-legend.text.size">Legend Text Size</label>
#>             <input id="BoxPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9684625', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-9155-7">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="BoxPlot-download.format-label" for="BoxPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6610778">
#>             <label class="control-label" id="BoxPlot-margin.t-label" for="BoxPlot-margin.t">Margin Top</label>
#>             <input id="BoxPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6610778', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7962506">
#>             <label class="control-label" id="BoxPlot-margin.b-label" for="BoxPlot-margin.b">Margin Bottom</label>
#>             <input id="BoxPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7962506', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify732092">
#>             <label class="control-label" id="BoxPlot-margin.l-label" for="BoxPlot-margin.l">Margin Left</label>
#>             <input id="BoxPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify732092', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8847428">
#>             <label class="control-label" id="BoxPlot-margin.r-label" for="BoxPlot-margin.r">Margin Right</label>
#>             <input id="BoxPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8847428', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8267003">
#>             <label class="control-label" for="BoxPlot-shape.fill">Shape Fill</label>
#>             <input id="BoxPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8267003', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7257639">
#>             <label class="control-label" for="BoxPlot-shape.line.color">Shape Line Color</label>
#>             <input id="BoxPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7257639', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3673290">
#>             <label class="control-label" id="BoxPlot-shape.line.width-label" for="BoxPlot-shape.line.width">Shape Line Width</label>
#>             <input id="BoxPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3673290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5234284">
#>             <label class="control-label" id="BoxPlot-shape.linetype-label" for="BoxPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5234284', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4698789">
#>             <label class="control-label" id="BoxPlot-shape.opacity-label" for="BoxPlot-shape.opacity">Shape Opacity</label>
#>             <input id="BoxPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4698789', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-9155-8">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="BoxPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="BoxPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-title.font.family-label" for="BoxPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-title.font.color">Title Color</label>
#>             <input id="BoxPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-title.font.size-label" for="BoxPlot-title.font.size">Title Size</label>
#>             <input id="BoxPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.title.horizontal.position-label" for="BoxPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="BoxPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.title.font.size-label" for="BoxPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="BoxPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="BoxPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.title.font.family-label" for="BoxPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-grid.color">Gridline Color</label>
#>             <input id="BoxPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="BoxPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.linewidth-label" for="BoxPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="BoxPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.size-label" for="BoxPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="BoxPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="BoxPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.family-label" for="BoxPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickangle.x-label" for="BoxPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="BoxPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickangle.y-label" for="BoxPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="BoxPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticks-label" for="BoxPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="BoxPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticklen-label" for="BoxPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="BoxPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickwidth-label" for="BoxPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="BoxPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.title.font.size-label" for="BoxPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="BoxPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="BoxPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.title.font.family-label" for="BoxPlot-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="BoxPlot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>     <div class="tab-pane" data-value="Lines" id="tab-9155-9">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify985664">
#>             <label class="control-label" id="BoxPlot-hline.intercepts-label" for="BoxPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="BoxPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify985664', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5160349">
#>             <label class="control-label" id="BoxPlot-hline.colors-label" for="BoxPlot-hline.colors">Y Colors</label>
#>             <input id="BoxPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5160349', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4497338">
#>             <label class="control-label" id="BoxPlot-hline.widths-label" for="BoxPlot-hline.widths">Y Widths</label>
#>             <input id="BoxPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4497338', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5494615">
#>             <label class="control-label" id="BoxPlot-hline.linetypes-label" for="BoxPlot-hline.linetypes">Y Line Types</label>
#>             <input id="BoxPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5494615', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6495062">
#>             <label class="control-label" id="BoxPlot-hline.opacities-label" for="BoxPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="BoxPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6495062', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1590349">
#>             <label class="control-label" id="BoxPlot-vline.intercepts-label" for="BoxPlot-vline.intercepts">X-intercepts</label>
#>             <input id="BoxPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1590349', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2937508">
#>             <label class="control-label" id="BoxPlot-vline.colors-label" for="BoxPlot-vline.colors">X Colors</label>
#>             <input id="BoxPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2937508', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8912848">
#>             <label class="control-label" id="BoxPlot-vline.widths-label" for="BoxPlot-vline.widths">X Widths</label>
#>             <input id="BoxPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8912848', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5880786">
#>             <label class="control-label" id="BoxPlot-vline.linetypes-label" for="BoxPlot-vline.linetypes">X Line Types</label>
#>             <input id="BoxPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5880786', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6332315">
#>             <label class="control-label" id="BoxPlot-vline.opacities-label" for="BoxPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="BoxPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6332315', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2595095">
#>             <label class="control-label" id="BoxPlot-abline.slopes-label" for="BoxPlot-abline.slopes">Ab Slopes</label>
#>             <input id="BoxPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2595095', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3182127">
#>             <label class="control-label" id="BoxPlot-abline.intercepts-label" for="BoxPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="BoxPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3182127', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3392539">
#>             <label class="control-label" id="BoxPlot-abline.colors-label" for="BoxPlot-abline.colors">Ab Colors</label>
#>             <input id="BoxPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3392539', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7607611">
#>             <label class="control-label" id="BoxPlot-abline.widths-label" for="BoxPlot-abline.widths">Ab Widths</label>
#>             <input id="BoxPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7607611', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify108725">
#>             <label class="control-label" id="BoxPlot-abline.linetypes-label" for="BoxPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="BoxPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify108725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify631374">
#>             <label class="control-label" id="BoxPlot-abline.opacities-label" for="BoxPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="BoxPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify631374', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="BoxPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="BoxPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="BoxPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="BoxPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="BoxPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="BoxPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('BoxPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
