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

- `split_by_sep` - Separator for multiple split_by columns (not yet
  implemented)

- `size_name` - Size legend name (not yet implemented)

- `fill_name` - Fill legend name (not yet implemented)

- `fill_cutoff_name` - Fill cutoff legend name (not yet implemented)

- `theme` - ggplot2 theme (managed internally)

- `theme_args` - Theme arguments (not yet implemented)

- `palcolor` - Managed internally via the palette selection UI

- `x_text_angle` - X-axis text angle (handled by axis.tickangle.x)

- `keep_empty` - Keep empty factor levels (not yet implemented)

- `keep_na` - Keep NA values (not yet implemented)

- `combine` - Combine multiple plots (not applicable for plotly)

- `seed` - Random seed (not applicable)

- `nrow` - Only applies if `split_by` is used with combine

- `ncol` - Only applies if `split_by` is used with combine

- `byrow` - Only applies if `split_by` is used with combine

- `axes` - Only applies if `split_by` is used with combine

- `axis_titles` - Only applies if `split_by` is used with combine

- `guides` - Only applies if `split_by` is used with combine

- `design` - Only applies if `split_by` is used with combine

## Plot parameters and defaults

The following
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X Values", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y Values", default: 3rd categorical
  variable)

- `size_by` - Numeric column mapped to dot size (UI: "Size By", default:
  "" = count)

- `fill_by` - Numeric column mapped to dot fill (UI: "Fill By", default:
  "")

- `fill_cutoff` - Cutoff applied to the fill column (UI: "Fill Cutoff",
  default: NA)

- `flip` - Flip the x and y axes (UI: "Rotate (swap X/Y)", default:
  FALSE)

- `split_by` - Split variable for separate plots (UI: "Split By",
  default: "")

- `facet_by` - Faceting variable (UI: "Facet By", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palette` - Continuous fill palette (UI: "Color Palette", default:
  "Spectral")

- `alpha` - Dot fill transparency (UI: "Alpha", default: 1)

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
library(VizModules)
data(mtcars)
plotthis_DotPlotInputsUI("DotPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="DotPlot-DotPlotTabsetPanel" data-tabsetid="6364">
#>     <li class="active">
#>       <a href="#tab-6364-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6364-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6364-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6364-4" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6364-5" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6364-6" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6364">
#>     <div class="tab-pane active" data-value="Data" id="tab-6364-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5438312">
#>             <label class="control-label" id="DotPlot-x.data-label" for="DotPlot-x.data">X Values</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-x.data"><option value=""></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5438312', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character vector specifying the column to use for the x-axis. A numeric column is expected.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1990008">
#>             <label class="control-label" id="DotPlot-y.data-label" for="DotPlot-y.data">Y Values</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-y.data"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1990008', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character vector specifying the column to use for the y-axis. A factor/character column is expected.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6450548">
#>             <label class="control-label" id="DotPlot-size.by-label" for="DotPlot-size.by">Size By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-size.by"><option value="" selected></option>
#> <option value="mpg">mpg</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6450548', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which column to use as the size of the dots. It must be a numeric column. If not provided, the size will be the count of the instances for each &#39;y&#39; in &#39;x&#39;. For &#39;ScatterPlot&#39;, it can be a single numeric value to specify the size of the dots.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7502398">
#>             <label class="control-label" id="DotPlot-fill.by-label" for="DotPlot-fill.by">Fill By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-fill.by"><option value="" selected></option>
#> <option value="mpg">mpg</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7502398', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which column to use as the fill the dots. It must be a numeric column. If not provided, all dots will be filled with the same color at the middle of the palette.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2709779">
#>             <label class="control-label" id="DotPlot-fill.cutoff-label" for="DotPlot-fill.cutoff">Fill Cutoff</label>
#>             <input id="DotPlot-fill.cutoff" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2709779', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the cutoff for the fill column.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-6364-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8756219">
#>             <label class="control-label" id="DotPlot-facet.by-label" for="DotPlot-facet.by">Facet By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-facet.by"><option value="" selected></option>
#> <option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8756219', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by `split_by` and generate multiple plots and combine them into one using `patchwork::wrap_plots`'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8517431">
#>             <label class="control-label" id="DotPlot-facet.scale-label" for="DotPlot-facet.scale">Facet Scale</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-facet.scale"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8517431', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See `ggplot2::facet_wrap`'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify458494">
#>             <label class="control-label" id="DotPlot-facet.ncol-label" for="DotPlot-facet.ncol">Columns</label>
#>             <input id="DotPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify458494', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3810569">
#>             <label class="control-label" id="DotPlot-facet.nrow-label" for="DotPlot-facet.nrow">Rows</label>
#>             <input id="DotPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3810569', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1833121">
#>             <div class="material-switch">
#>               <label for="DotPlot-facet.by.row" style="padding-right: 10px;">Facet by Row</label>
#>               <input id="DotPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="DotPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1833121', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A logical value indicating whether to fill the plots by row. Default is TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9217996">
#>             <label class="control-label" id="DotPlot-split.by-label" for="DotPlot-split.by">Split By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-split.by"><option value="" selected></option>
#> <option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9217996', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'The column(s) to split data by and plot separately.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-6364-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9061868">
#>             <label class="control-label" id="DotPlot-palette.name-label" for="DotPlot-palette.name">Color Palette</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-palette.name"><option value="dittoColors">dittoColors</option>
#> <option value="dittoColors_full">dittoColors_full</option>
#> <option value="ggplot2">ggplot2</option>
#> <option value="viridis">viridis</option>
#> <option value="magma">magma</option>
#> <option value="inferno">inferno</option>
#> <option value="plasma">plasma</option>
#> <option value="cividis">cividis</option>
#> <option value="BrBG">BrBG</option>
#> <option value="PiYG">PiYG</option>
#> <option value="PRGn">PRGn</option>
#> <option value="PuOr">PuOr</option>
#> <option value="RdBu">RdBu</option>
#> <option value="RdGy">RdGy</option>
#> <option value="RdYlBu">RdYlBu</option>
#> <option value="RdYlGn">RdYlGn</option>
#> <option value="Spectral" selected>Spectral</option>
#> <option value="Accent">Accent</option>
#> <option value="Dark2">Dark2</option>
#> <option value="Paired">Paired</option>
#> <option value="Pastel1">Pastel1</option>
#> <option value="Pastel2">Pastel2</option>
#> <option value="Set1">Set1</option>
#> <option value="Set2">Set2</option>
#> <option value="Set3">Set3</option>
#> <option value="Blues">Blues</option>
#> <option value="BuGn">BuGn</option>
#> <option value="BuPu">BuPu</option>
#> <option value="GnBu">GnBu</option>
#> <option value="Greens">Greens</option>
#> <option value="Greys">Greys</option>
#> <option value="Oranges">Oranges</option>
#> <option value="OrRd">OrRd</option>
#> <option value="PuBu">PuBu</option>
#> <option value="PuBuGn">PuBuGn</option>
#> <option value="PuRd">PuRd</option>
#> <option value="Purples">Purples</option>
#> <option value="RdPu">RdPu</option>
#> <option value="Reds">Reds</option>
#> <option value="YlGn">YlGn</option>
#> <option value="YlGnBu">YlGnBu</option>
#> <option value="YlOrBr">YlOrBr</option>
#> <option value="YlOrRd">YlOrRd</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9061868', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A character string specifying the palette to use. A named list or vector can be used to specify the palettes for different `split_by` values.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1929433">
#>             <label class="control-label" id="DotPlot-alpha-label" for="DotPlot-alpha">Alpha</label>
#>             <input id="DotPlot-alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1929433', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A numeric value specifying the transparency of the plot.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-6364-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="DotPlot-download.format-label" for="DotPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8643752">
#>             <label class="control-label" id="DotPlot-margin.t-label" for="DotPlot-margin.t">Margin Top</label>
#>             <input id="DotPlot-margin.t" type="number" class="shiny-input-number form-control" value="100" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8643752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify132727">
#>             <label class="control-label" id="DotPlot-margin.b-label" for="DotPlot-margin.b">Margin Bottom</label>
#>             <input id="DotPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify132727', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8856603">
#>             <label class="control-label" id="DotPlot-margin.l-label" for="DotPlot-margin.l">Margin Left</label>
#>             <input id="DotPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8856603', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3915421">
#>             <label class="control-label" id="DotPlot-margin.r-label" for="DotPlot-margin.r">Margin Right</label>
#>             <input id="DotPlot-margin.r" type="number" class="shiny-input-number form-control" value="140" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3915421', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify761764">
#>             <label class="control-label" id="DotPlot-subplot.margin-label" for="DotPlot-subplot.margin">Subplot Spacing</label>
#>             <input id="DotPlot-subplot.margin" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify761764', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Spacing between facet panels as a fraction of the plot area (e.g. 0.04). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6467813">
#>             <label class="control-label" for="DotPlot-shape.fill">Shape Fill</label>
#>             <input id="DotPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6467813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9166539">
#>             <label class="control-label" for="DotPlot-shape.line.color">Shape Line Color</label>
#>             <input id="DotPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9166539', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8345086">
#>             <label class="control-label" id="DotPlot-shape.line.width-label" for="DotPlot-shape.line.width">Shape Line Width</label>
#>             <input id="DotPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8345086', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5012471">
#>             <label class="control-label" id="DotPlot-shape.linetype-label" for="DotPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5012471', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6021448">
#>             <label class="control-label" id="DotPlot-shape.opacity-label" for="DotPlot-shape.opacity">Shape Opacity</label>
#>             <input id="DotPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6021448', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-6364-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="DotPlot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>               <input id="DotPlot-rotate" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="DotPlot-rotate"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-title.font.family-label" for="DotPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>             <label class="control-label" for="DotPlot-title.font.color">Title Color</label>
#>             <input id="DotPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-title.font.size-label" for="DotPlot-title.font.size">Title Size</label>
#>             <input id="DotPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.title.horizontal.position-label" for="DotPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="DotPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.title.font.size-label" for="DotPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="DotPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="DotPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.title.font.family-label" for="DotPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>                 <input id="DotPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="DotPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="DotPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="DotPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-grid.color">Gridline Color</label>
#>             <input id="DotPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="DotPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.linewidth-label" for="DotPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="DotPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.tickfont.size-label" for="DotPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="DotPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="DotPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.tickfont.family-label" for="DotPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>             <label class="control-label" id="DotPlot-axis.tickangle.x-label" for="DotPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="DotPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.tickangle.y-label" for="DotPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="DotPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.ticks-label" for="DotPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="DotPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.ticklen-label" for="DotPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="DotPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-axis.tickwidth-label" for="DotPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="DotPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-facet.title.font.size-label" for="DotPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="DotPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="DotPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="DotPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="DotPlot-facet.title.font.family-label" for="DotPlot-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="DotPlot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>     <div class="tab-pane" data-value="Lines" id="tab-6364-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4689590">
#>             <label class="control-label" id="DotPlot-hline.intercepts-label" for="DotPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="DotPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4689590', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8863742">
#>             <label class="control-label" id="DotPlot-hline.colors-label" for="DotPlot-hline.colors">Y Colors</label>
#>             <input id="DotPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8863742', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6705485">
#>             <label class="control-label" id="DotPlot-hline.widths-label" for="DotPlot-hline.widths">Y Widths</label>
#>             <input id="DotPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6705485', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3937777">
#>             <label class="control-label" id="DotPlot-hline.linetypes-label" for="DotPlot-hline.linetypes">Y Line Types</label>
#>             <input id="DotPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3937777', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5512907">
#>             <label class="control-label" id="DotPlot-hline.opacities-label" for="DotPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="DotPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5512907', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2424927">
#>             <label class="control-label" id="DotPlot-vline.intercepts-label" for="DotPlot-vline.intercepts">X-intercepts</label>
#>             <input id="DotPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2424927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2032089">
#>             <label class="control-label" id="DotPlot-vline.colors-label" for="DotPlot-vline.colors">X Colors</label>
#>             <input id="DotPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2032089', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify683417">
#>             <label class="control-label" id="DotPlot-vline.widths-label" for="DotPlot-vline.widths">X Widths</label>
#>             <input id="DotPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify683417', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3072738">
#>             <label class="control-label" id="DotPlot-vline.linetypes-label" for="DotPlot-vline.linetypes">X Line Types</label>
#>             <input id="DotPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3072738', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9931180">
#>             <label class="control-label" id="DotPlot-vline.opacities-label" for="DotPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="DotPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9931180', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1163092">
#>             <label class="control-label" id="DotPlot-abline.slopes-label" for="DotPlot-abline.slopes">Ab Slopes</label>
#>             <input id="DotPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1163092', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7154231">
#>             <label class="control-label" id="DotPlot-abline.intercepts-label" for="DotPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="DotPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7154231', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2261088">
#>             <label class="control-label" id="DotPlot-abline.colors-label" for="DotPlot-abline.colors">Ab Colors</label>
#>             <input id="DotPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2261088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1333486">
#>             <label class="control-label" id="DotPlot-abline.widths-label" for="DotPlot-abline.widths">Ab Widths</label>
#>             <input id="DotPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1333486', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9272817">
#>             <label class="control-label" id="DotPlot-abline.linetypes-label" for="DotPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="DotPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9272817', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8941226">
#>             <label class="control-label" id="DotPlot-abline.opacities-label" for="DotPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="DotPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8941226', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="DotPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="DotPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="DotPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="DotPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="DotPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-4" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="DotPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>   </div>
#> </div>
```
