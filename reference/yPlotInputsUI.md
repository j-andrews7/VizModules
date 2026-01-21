# Input UI components for the yPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`yPlotServer()`](https://j-andrews7.github.io/vizModules/reference/yPlotServer.md)
and
[`yPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/yPlotOutputUI.md)
functions.

## Usage

``` r
yPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html) can
be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`vizModules::organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`vizModules::yPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/yPlotOutputUI.md),
[`vizModules::yPlotServer()`](https://j-andrews7.github.io/vizModules/reference/yPlotServer.md),
[`vizModules::yPlotApp()`](https://j-andrews7.github.io/vizModules/reference/yPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data(mtcars)
yPlotInputsUI("yPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="yPlot-yPlotTabsetPanel" data-tabsetid="7008">
#>     <li class="active">
#>       <a href="#tab-7008-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-2" data-toggle="tab" data-bs-toggle="tab" data-value="Plot Type">Plot Type</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-3" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-4" data-toggle="tab" data-bs-toggle="tab" data-value="Jitter">Jitter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-5" data-toggle="tab" data-bs-toggle="tab" data-value="Box">Box</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-6" data-toggle="tab" data-bs-toggle="tab" data-value="Violin">Violin</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-7" data-toggle="tab" data-bs-toggle="tab" data-value="Ridge">Ridge</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-8" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-9" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-7008-10" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="7008">
#>     <div class="tab-pane active" data-value="Data" id="tab-7008-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-var-label" for="yPlot-var">Select Y data (var):</label>
#>             <div>
#>               <select id="yPlot-var" class="shiny-input-select"><option value=""></option>
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
#>               <script type="application/json" data-for="yPlot-var">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-group.by-label" for="yPlot-group.by">Group by:</label>
#>             <div>
#>               <select id="yPlot-group.by" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="yPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-color.by-label" for="yPlot-color.by">Color by:</label>
#>             <div>
#>               <select id="yPlot-color.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-color.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-shape.by-label" for="yPlot-shape.by">Shape by:</label>
#>             <div>
#>               <select id="yPlot-shape.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-shape.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="yPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plot Type" id="tab-7008-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="yPlot-plots" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="yPlot-plots-label">
#>             <label class="control-label" id="yPlot-plots-label" for="yPlot-plots">Plot types to show:</label>
#>             <div class="shiny-options-group">
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="yPlot-plots" value="vlnplot" checked="checked"/>
#>                   <span>Violin</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="yPlot-plots" value="boxplot" checked="checked"/>
#>                   <span>Box</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="yPlot-plots" value="jitter" checked="checked"/>
#>                   <span>Jitter</span>
#>                 </label>
#>               </div>
#>               <div class="checkbox">
#>                 <label>
#>                   <input type="checkbox" name="yPlot-plots" value="ridgeplot"/>
#>                   <span>Ridge</span>
#>                 </label>
#>               </div>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <span class="help-block">Order matters: first selected will be in back, last in front</span>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-7008-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-y.max-label" for="yPlot-y.max">Max Value of Y Axis:</label>
#>             <input id="yPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-y.min-label" for="yPlot-y.min">Min Value of Y Axis:</label>
#>             <input id="yPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="yPlot-do.raster" type="checkbox" class="sw-switchInput" data-input-id="yPlot-do.raster" data-on-text="On" data-off-text="Off" data-label-text="Rasterize jitter: " data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-raster.dpi-label" for="yPlot-raster.dpi">Raster DPI:</label>
#>             <input id="yPlot-raster.dpi" type="number" class="shiny-input-number form-control" value="300" data-update-on="change" min="100" max="1200"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Jitter" id="tab-7008-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.size-label" for="yPlot-jitter.size">Jitter Point Size:</label>
#>             <input id="yPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.width-label" for="yPlot-jitter.width">Jitter Width:</label>
#>             <input id="yPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-jitter.color">Jitter Point Color</label>
#>             <input id="yPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.shape.legend.size-label" for="yPlot-jitter.shape.legend.size">Shape Legend Size:</label>
#>             <input id="yPlot-jitter.shape.legend.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="yPlot-jitter.shape.legend.show" type="checkbox" class="sw-switchInput" data-input-id="yPlot-jitter.shape.legend.show" data-on-text="Show" data-off-text="Hide" data-label-text="Show Shape Legend: " data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.position.dodge-label" for="yPlot-jitter.position.dodge">Jitter Position Dodge:</label>
#>             <input id="yPlot-jitter.position.dodge" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Box" id="tab-7008-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.width-label" for="yPlot-boxplot.width">Boxplot Width:</label>
#>             <input id="yPlot-boxplot.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="2"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-boxplot.color">Boxplot Color</label>
#>             <input id="yPlot-boxplot.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="yPlot-boxplot.show.outliers" type="checkbox" class="sw-switchInput" data-input-id="yPlot-boxplot.show.outliers" data-on-text="Show" data-off-text="Hide" data-label-text="Show Outliers: " data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.outlier.size-label" for="yPlot-boxplot.outlier.size">Outlier Size:</label>
#>             <input id="yPlot-boxplot.outlier.size" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="yPlot-boxplot.fill" type="checkbox" class="sw-switchInput" data-input-id="yPlot-boxplot.fill" data-on-text="Fill" data-off-text="No Fill" data-label-text="Fill Boxplot: " data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.position.dodge-label" for="yPlot-boxplot.position.dodge">Boxplot Position Dodge:</label>
#>             <input id="yPlot-boxplot.position.dodge" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.lineweight-label" for="yPlot-boxplot.lineweight">Boxplot Line Weight:</label>
#>             <input id="yPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Violin" id="tab-7008-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.lineweight-label" for="yPlot-vlnplot.lineweight">Violin Line Weight:</label>
#>             <input id="yPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.width-label" for="yPlot-vlnplot.width">Violin Width:</label>
#>             <input id="yPlot-vlnplot.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.scaling-label" for="yPlot-vlnplot.scaling">Violin Scaling:</label>
#>             <div>
#>               <select id="yPlot-vlnplot.scaling" class="shiny-input-select"><option value="area" selected>area</option>
#> <option value="count">count</option>
#> <option value="width">width</option></select>
#>               <script type="application/json" data-for="yPlot-vlnplot.scaling" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.quantiles-label" for="yPlot-vlnplot.quantiles">Violin Quantiles (comma-separated, 0-1):</label>
#>             <input id="yPlot-vlnplot.quantiles" type="text" class="shiny-input-text form-control" value="" placeholder="e.g., 0.25, 0.5, 0.75" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Ridge" id="tab-7008-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.lineweight-label" for="yPlot-ridgeplot.lineweight">Ridge Line Weight:</label>
#>             <input id="yPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="5"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.scale-label" for="yPlot-ridgeplot.scale">Ridge Scale (overlap):</label>
#>             <input id="yPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.5" max="3"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.ymax.expansion-label" for="yPlot-ridgeplot.ymax.expansion">Ridge Y-max Expansion:</label>
#>             <input id="yPlot-ridgeplot.ymax.expansion" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.shape-label" for="yPlot-ridgeplot.shape">Ridge Shape:</label>
#>             <div>
#>               <select id="yPlot-ridgeplot.shape" class="shiny-input-select"><option value="smooth" selected>smooth</option>
#> <option value="hist">hist</option></select>
#>               <script type="application/json" data-for="yPlot-ridgeplot.shape" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.bins-label" for="yPlot-ridgeplot.bins">Ridge Bins (for hist):</label>
#>             <input id="yPlot-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="5" max="100"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.binwidth-label" for="yPlot-ridgeplot.binwidth">Ridge Binwidth:</label>
#>             <input id="yPlot-ridgeplot.binwidth" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-7008-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-add.line-label" for="yPlot-add.line">Add Y interception line (comma-separated):</label>
#>             <input id="yPlot-add.line" type="text" class="shiny-input-text form-control" value="" placeholder="e.g., 0, 1, 2" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-line.color">Line Color:</label>
#>             <input id="yPlot-line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-line.linewidth-label" for="yPlot-line.linewidth">Line Width:</label>
#>             <input id="yPlot-line.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-line.linetype-label" for="yPlot-line.linetype">Line Type:</label>
#>             <div>
#>               <select id="yPlot-line.linetype" class="shiny-input-select"><option value="solid">solid</option>
#> <option value="dashed" selected>dashed</option>
#> <option value="dotted">dotted</option>
#> <option value="dotdash">dotdash</option>
#> <option value="longdash">longdash</option>
#> <option value="twodash">twodash</option></select>
#>               <script type="application/json" data-for="yPlot-line.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-line.opacity-label" for="yPlot-line.opacity">Line Opacity:</label>
#>             <input id="yPlot-line.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-7008-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.by-label" for="yPlot-split.by">Split by (facet):</label>
#>             <div>
#>               <select id="yPlot-split.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-split.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.adjust-label" for="yPlot-split.adjust">Facet scaling: </label>
#>             <div>
#>               <select id="yPlot-split.adjust" class="shiny-input-select"><option value="fixed">fixed</option>
#> <option value="free" selected>free</option>
#> <option value="free_y">free_y</option>
#> <option value="free_x">free_x</option></select>
#>               <script type="application/json" data-for="yPlot-split.adjust" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.ncol-label" for="yPlot-split.ncol">Split number of columns:</label>
#>             <div>
#>               <select id="yPlot-split.ncol" class="shiny-input-select"><option value=""></option>
#> <option value="1">1</option>
#> <option value="2">2</option>
#> <option value="3">3</option>
#> <option value="4" selected>4</option>
#> <option value="5">5</option>
#> <option value="6">6</option>
#> <option value="7">7</option>
#> <option value="8">8</option>
#> <option value="9">9</option>
#> <option value="10">10</option></select>
#>               <script type="application/json" data-for="yPlot-split.ncol">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.nrow-label" for="yPlot-split.nrow">Split number of rows:</label>
#>             <div>
#>               <select id="yPlot-split.nrow" class="shiny-input-select"><option value=""></option>
#> <option value="1">1</option>
#> <option value="2">2</option>
#> <option value="3">3</option>
#> <option value="4" selected>4</option>
#> <option value="5">5</option>
#> <option value="6">6</option>
#> <option value="7">7</option>
#> <option value="8">8</option>
#> <option value="9">9</option>
#> <option value="10">10</option></select>
#>               <script type="application/json" data-for="yPlot-split.nrow">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-7008-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="yPlot-x.labels.rotate" type="checkbox" class="sw-switchInput" data-input-id="yPlot-x.labels.rotate" data-on-text="Rotate" data-off-text="Don&#39;t Rotate" data-label-text="Rotate X labels: " data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-font.type-label" for="yPlot-font.type">Font type:</label>
#>             <div>
#>               <select id="yPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="yPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.linecolor">Axis line color</label>
#>             <input id="yPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.linewidth-label" for="yPlot-axis.linewidth">Axis line width</label>
#>             <input id="yPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.size-label" for="yPlot-axis.tickfont.size">Tick label size</label>
#>             <input id="yPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickfont.color">Tick label color</label>
#>             <input id="yPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.family-label" for="yPlot-axis.tickfont.family">Tick label font</label>
#>             <div>
#>               <select id="yPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="yPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.x-label" for="yPlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="yPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.y-label" for="yPlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="yPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticks-label" for="yPlot-axis.ticks">Tick position</label>
#>             <div>
#>               <select id="yPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="yPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickcolor">Tick mark color</label>
#>             <input id="yPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticklen-label" for="yPlot-axis.ticklen">Tick mark length</label>
#>             <input id="yPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickwidth-label" for="yPlot-axis.tickwidth">Tick mark width</label>
#>             <input id="yPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-text.colour">Axis title colour:</label>
#>             <input id="yPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <input id="yPlot-auto.update" type="checkbox" class="sw-switchInput" data-input-id="yPlot-auto.update" data-on-text="ON" data-off-text="OFF" data-label-text="Auto Update" data-label-width="auto" data-handle-width="auto" data-size="mini"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="yPlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="yPlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="yPlot-download.type-label" for="yPlot-download.type">Download Format</label>
#>       <div>
#>         <select id="yPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="yPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
