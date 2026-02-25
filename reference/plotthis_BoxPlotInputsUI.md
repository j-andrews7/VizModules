# Input UI components for the BoxPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotServer.md)
and
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotOutputUI.md)
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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
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

- `symnum_args` - Significance symbol arguments (not implemented)

- `flip` - Flip axes (not implemented in current UI)

- `keep_empty` - Keep empty values (not implemented)

- `keep_na` - Keep NA values (not implemented)

- `group_by_sep` - Separator for group columns (not applicable in UI
  context)

- `group_name` - Group legend name (handled by plotly)

- `paired_by` - Pairing variable for paired tests (not implemented)

- `x_text_angle` - X-axis text angle (handled by plotly axis settings)

- `step_increase` - Step increase for significance brackets (not
  implemented)

- `fill_mode` - Fill mode for grouped data (handled automatically)

- `fill_reverse` - Reverse fill order (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

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

- `comparisons` - Group comparisons for significance tests (not
  implemented)

- `ref_group` - Reference group for comparisons (not implemented)

- `pairwise_method` - Pairwise test method (not implemented)

- `multiplegroup_comparisons` - Multiple group comparison flag (not
  implemented)

- `multiple_method` - Multiple group test method (not implemented)

- `sig_label` - Significance label format (not implemented)

- `sig_labelsize` - Significance label size (not implemented)

- `hide_ns` - Hide non-significant comparisons (not implemented)

- `seed` - Random seed (not applicable)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X data", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group by", default: "")

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

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `boxplot.width` - Width of boxplot (UI: "Boxplot Width", default: 0.8)

- `show.outliers` - Show outlier points (UI: "Show Outliers", default:
  TRUE)

- `axis.font.size` - Axis title font size (UI: "Axis font size",
  default: 18)

- `title.font.size` - Plot title font size (UI: "Title font size",
  default: 28)

- `font.type` - Font family for plot text (UI: "Font", default: "Arial")

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

[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotOutputUI.md),
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotServer.md),
[`plotthis_BoxPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="BoxPlot-BoxPlotTabsetPanel" data-tabsetid="1750">
#>     <li class="active">
#>       <a href="#tab-1750-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1750-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1750-3" data-toggle="tab" data-bs-toggle="tab" data-value="Highlight">Highlight</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1750-4" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1750-5" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1750-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1750">
#>     <div class="tab-pane active" data-value="Data" id="tab-1750-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-x.data-label" for="BoxPlot-x.data">X data</label>
#>             <div>
#>               <select id="BoxPlot-x.data" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="BoxPlot-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.data-label" for="BoxPlot-y.data">Y data</label>
#>             <div>
#>               <select id="BoxPlot-y.data" class="shiny-input-select"><option value=""></option>
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
#>               <script type="application/json" data-for="BoxPlot-y.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-group.by-label" for="BoxPlot-group.by">Group by</label>
#>             <div>
#>               <select id="BoxPlot-group.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="BoxPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="BoxPlot-show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="BoxPlot-show.outliers" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-show.outliers"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="BoxPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-1750-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-boxplot.width-label" for="BoxPlot-boxplot.width">Boxplot Width</label>
#>             <input id="BoxPlot-boxplot.width" type="number" class="shiny-input-number form-control" value="0.8" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-sort_x-label" for="BoxPlot-sort_x">Sort X by</label>
#>             <div>
#>               <select id="BoxPlot-sort_x" class="shiny-input-select"><option value="" selected></option>
#> <option value="mean_asc">mean_asc</option>
#> <option value="mean_desc">mean_desc</option>
#> <option value="mean">mean</option>
#> <option value="median_asc">median_asc</option>
#> <option value="median_desc">median_desc</option>
#> <option value="median">median</option></select>
#>               <script type="application/json" data-for="BoxPlot-sort_x">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.max-label" for="BoxPlot-y.max">Max Value of Y Axis</label>
#>             <input id="BoxPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-Inf" max="Inf"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.min-label" for="BoxPlot-y.min">Min Value of Y Axis</label>
#>             <input id="BoxPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-Inf" max="Inf"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="BoxPlot-add.points" style="padding-right: 10px;">Add Jitter Points</label>
#>               <input id="BoxPlot-add.points" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-add.points"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-pt.size-label" for="BoxPlot-pt.size">Point Size</label>
#>             <input id="BoxPlot-pt.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="100"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-pt.alpha-label" for="BoxPlot-pt.alpha">Point Alpha</label>
#>             <input id="BoxPlot-pt.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-jitter.width-label" for="BoxPlot-jitter.width">Jitter Width</label>
#>             <input id="BoxPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-pt.color">Point Outline Colour</label>
#>             <input id="BoxPlot-pt.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Highlight" id="tab-1750-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight-label" for="BoxPlot-highlight">Highlight</label>
#>             <input id="BoxPlot-highlight" type="text" class="shiny-input-text form-control" value="" placeholder="E.g. col name &gt; 0" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-highlight.colour">Highlight Colour</label>
#>             <input id="BoxPlot-highlight.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight.size-label" for="BoxPlot-highlight.size">Highlight Size</label>
#>             <input id="BoxPlot-highlight.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight.alpha-label" for="BoxPlot-highlight.alpha">Highlight Alpha</label>
#>             <input id="BoxPlot-highlight.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-1750-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.by-label" for="BoxPlot-facet.by">Facet by</label>
#>             <div>
#>               <select id="BoxPlot-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="BoxPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.scale-label" for="BoxPlot-facet.scale">Facet Scale</label>
#>             <div>
#>               <select id="BoxPlot-facet.scale" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="BoxPlot-facet.scale" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.ncol-label" for="BoxPlot-facet.ncol">Columns</label>
#>             <input id="BoxPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.nrow-label" for="BoxPlot-facet.nrow">Rows</label>
#>             <input id="BoxPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="BoxPlot-facet.by.row" style="padding-right: 10px;">Facet by Row</label>
#>               <input id="BoxPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1750-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="BoxPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="BoxPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="BoxPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-font.type-label" for="BoxPlot-font.type">Title Font</label>
#>             <div>
#>               <select id="BoxPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="BoxPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-text.colour">Title Color</label>
#>             <input id="BoxPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.title.font.size-label" for="BoxPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="BoxPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="BoxPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.title.font.family-label" for="BoxPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="BoxPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="BoxPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="BoxPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="BoxPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.linewidth-label" for="BoxPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="BoxPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.size-label" for="BoxPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="BoxPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="BoxPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.family-label" for="BoxPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="BoxPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="BoxPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickangle.x-label" for="BoxPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="BoxPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickangle.y-label" for="BoxPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="BoxPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticks-label" for="BoxPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="BoxPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="BoxPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="BoxPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticklen-label" for="BoxPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="BoxPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickwidth-label" for="BoxPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="BoxPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-1750-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-hline.intercepts-label" for="BoxPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="BoxPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-hline.colors-label" for="BoxPlot-hline.colors">Colors</label>
#>             <input id="BoxPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-hline.widths-label" for="BoxPlot-hline.widths">Widths</label>
#>             <input id="BoxPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-hline.linetypes-label" for="BoxPlot-hline.linetypes">Line types</label>
#>             <input id="BoxPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-hline.opacities-label" for="BoxPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="BoxPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-vline.intercepts-label" for="BoxPlot-vline.intercepts">X-intercepts</label>
#>             <input id="BoxPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-vline.colors-label" for="BoxPlot-vline.colors">Colors</label>
#>             <input id="BoxPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-vline.widths-label" for="BoxPlot-vline.widths">Widths</label>
#>             <input id="BoxPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-vline.linetypes-label" for="BoxPlot-vline.linetypes">Line types</label>
#>             <input id="BoxPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-vline.opacities-label" for="BoxPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="BoxPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
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
#>         <label for="BoxPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="BoxPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="BoxPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="BoxPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="BoxPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="BoxPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="BoxPlot-download.format-label" for="BoxPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="BoxPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="BoxPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
