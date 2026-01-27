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
#>   <ul class="nav nav-tabs shiny-tab-input" id="ViolinPlot-ViolinPlotTabsetPanel" data-tabsetid="5170">
#>     <li class="active">
#>       <a href="#tab-5170-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-3" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-4" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-6" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5170-7" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5170">
#>     <div class="tab-pane active" data-value="Data" id="tab-5170-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-x.data-label" for="ViolinPlot-x.data">Select X data</label>
#>             <div>
#>               <select id="ViolinPlot-x.data" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="ViolinPlot-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-y.data-label" for="ViolinPlot-y.data">Select Y data</label>
#>             <div>
#>               <select id="ViolinPlot-y.data" class="shiny-input-select"><option value=""></option>
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
#>               <script type="application/json" data-for="ViolinPlot-y.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-group.by-label" for="ViolinPlot-group.by">Group by</label>
#>             <div>
#>               <select id="ViolinPlot-group.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="ViolinPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div id="ViolinPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-5170-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-sort_x-label" for="ViolinPlot-sort_x">Sort X axis by</label>
#>             <div>
#>               <select id="ViolinPlot-sort_x" class="shiny-input-select"><option value="none" selected>none</option>
#> <option value="mean_asc">mean_asc</option>
#> <option value="mean_desc">mean_desc</option>
#> <option value="mean">mean</option>
#> <option value="median_asc">median_asc</option>
#> <option value="median_desc">median_desc</option>
#> <option value="median">median</option></select>
#>               <script type="application/json" data-for="ViolinPlot-sort_x" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-stack" style="padding-right: 10px;">Stack Plot</label>
#>               <input id="ViolinPlot-stack" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-stack"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-y.max-label" for="ViolinPlot-y.max">Max Value of Y Axis</label>
#>             <input id="ViolinPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-y.min-label" for="ViolinPlot-y.min">Min Value of Y Axis</label>
#>             <input id="ViolinPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-aspect.ratio-label" for="ViolinPlot-aspect.ratio">Aspect Ratio</label>
#>             <input id="ViolinPlot-aspect.ratio" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="100"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-add.points" style="padding-right: 10px;">Add Jitter Points</label>
#>               <input id="ViolinPlot-add.points" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-add.points"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-pt.size-label" for="ViolinPlot-pt.size">Point Size</label>
#>             <input id="ViolinPlot-pt.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="100"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-pt.alpha-label" for="ViolinPlot-pt.alpha">Point Alpha</label>
#>             <input id="ViolinPlot-pt.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-jitter.width-label" for="ViolinPlot-jitter.width">Jitter Width</label>
#>             <input id="ViolinPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-jitter.height-label" for="ViolinPlot-jitter.height">Jitter Height</label>
#>             <input id="ViolinPlot-jitter.height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-pt.color">Point outline colour</label>
#>             <input id="ViolinPlot-pt.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-add.box" style="padding-right: 10px;">Add Box</label>
#>               <input id="ViolinPlot-add.box" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-add.box"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-box.color">Box colour</label>
#>             <input id="ViolinPlot-box.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-box.width-label" for="ViolinPlot-box.width">Box Width</label>
#>             <input id="ViolinPlot-box.width" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-box.ptsize-label" for="ViolinPlot-box.ptsize">Box Point Size</label>
#>             <input id="ViolinPlot-box.ptsize" type="number" class="shiny-input-number form-control" value="2.5" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-5170-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-add.line-label" for="ViolinPlot-add.line">Add Y interception line</label>
#>             <input id="ViolinPlot-add.line" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="10.4" max="37.629"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-line.colour">Y Intercept line colour</label>
#>             <input id="ViolinPlot-line.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-line.width-label" for="ViolinPlot-line.width">Line width</label>
#>             <input id="ViolinPlot-line.width" type="number" class="shiny-input-number form-control" value="0.6" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-line.type-label" for="ViolinPlot-line.type">Line type</label>
#>             <input id="ViolinPlot-line.type" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="40"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-highlight-label" for="ViolinPlot-highlight">Highlight</label>
#>             <input id="ViolinPlot-highlight" type="text" class="shiny-input-text form-control" value="" placeholder="E.g. y &gt; 0" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-highlight.colour">Highlight colour</label>
#>             <input id="ViolinPlot-highlight.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-highlight.size-label" for="ViolinPlot-highlight.size">Highlight size</label>
#>             <input id="ViolinPlot-highlight.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-highlight.alpha-label" for="ViolinPlot-highlight.alpha">Highlight alpha</label>
#>             <input id="ViolinPlot-highlight.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-5170-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-add.stat-label" for="ViolinPlot-add.stat">Add Stats</label>
#>             <div>
#>               <select id="ViolinPlot-add.stat" class="shiny-input-select"><option value="" selected></option>
#> <option value="mean">mean</option>
#> <option value="sd">sd</option>
#> <option value="median">median</option>
#> <option value="var">var</option></select>
#>               <script type="application/json" data-for="ViolinPlot-add.stat">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-stat.color">Stats Colour</label>
#>             <input id="ViolinPlot-stat.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-stat.size-label" for="ViolinPlot-stat.size">Stat Size</label>
#>             <input id="ViolinPlot-stat.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-stat.stroke-label" for="ViolinPlot-stat.stroke">Stat Stroke</label>
#>             <input id="ViolinPlot-stat.stroke" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-stat.shape-label" for="ViolinPlot-stat.shape">Stat Shape</label>
#>             <input id="ViolinPlot-stat.shape" type="number" class="shiny-input-number form-control" value="25" data-update-on="change" min="0" max="100"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-5170-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.by-label" for="ViolinPlot-facet.by">Facet by</label>
#>             <div>
#>               <select id="ViolinPlot-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="ViolinPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.scale-label" for="ViolinPlot-facet.scale">Facet scale</label>
#>             <div>
#>               <select id="ViolinPlot-facet.scale" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="ViolinPlot-facet.scale" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.ncol-label" for="ViolinPlot-facet.ncol">Facet number of columns</label>
#>             <input id="ViolinPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-facet.nrow-label" for="ViolinPlot-facet.nrow">Facet number of rows</label>
#>             <input id="ViolinPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-facet.by.row" style="padding-right: 10px;">Facet by row</label>
#>               <input id="ViolinPlot-facet.by.row" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-facet.by.row"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-5170-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-text.colour">Axis title colour</label>
#>             <input id="ViolinPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="ViolinPlot-flip" style="padding-right: 10px;">Flip horizontal</label>
#>               <input id="ViolinPlot-flip" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="ViolinPlot-flip"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-font.type-label" for="ViolinPlot-font.type">Font type</label>
#>             <div>
#>               <select id="ViolinPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="ViolinPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ViolinPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
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
#>                 <input id="ViolinPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ViolinPlot-show.major.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X major gridlines</span>
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
#>                 <input id="ViolinPlot-show.major.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y major gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.linecolor">Axis line color</label>
#>             <input id="ViolinPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.linewidth-label" for="ViolinPlot-axis.linewidth">Axis line width</label>
#>             <input id="ViolinPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickfont.size-label" for="ViolinPlot-axis.tickfont.size">Tick label size</label>
#>             <input id="ViolinPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.tickfont.color">Tick label color</label>
#>             <input id="ViolinPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickfont.family-label" for="ViolinPlot-axis.tickfont.family">Tick label font</label>
#>             <div>
#>               <select id="ViolinPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="ViolinPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickangle.x-label" for="ViolinPlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="ViolinPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickangle.y-label" for="ViolinPlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="ViolinPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.ticks-label" for="ViolinPlot-axis.ticks">Tick position</label>
#>             <div>
#>               <select id="ViolinPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="ViolinPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="ViolinPlot-axis.tickcolor">Tick mark color</label>
#>             <input id="ViolinPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.ticklen-label" for="ViolinPlot-axis.ticklen">Tick mark length</label>
#>             <input id="ViolinPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-axis.tickwidth-label" for="ViolinPlot-axis.tickwidth">Tick mark width</label>
#>             <input id="ViolinPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-5170-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-hline.intercepts-label" for="ViolinPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="ViolinPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-hline.colors-label" for="ViolinPlot-hline.colors">Colors</label>
#>             <input id="ViolinPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-hline.widths-label" for="ViolinPlot-hline.widths">Widths</label>
#>             <input id="ViolinPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-hline.linetypes-label" for="ViolinPlot-hline.linetypes">Line types</label>
#>             <input id="ViolinPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-hline.opacities-label" for="ViolinPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="ViolinPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <hr/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-vline.intercepts-label" for="ViolinPlot-vline.intercepts">X-intercepts</label>
#>             <input id="ViolinPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-vline.colors-label" for="ViolinPlot-vline.colors">Colors</label>
#>             <input id="ViolinPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-vline.widths-label" for="ViolinPlot-vline.widths">Widths</label>
#>             <input id="ViolinPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-vline.linetypes-label" for="ViolinPlot-vline.linetypes">Line types</label>
#>             <input id="ViolinPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-vline.opacities-label" for="ViolinPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="ViolinPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <hr/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.slopes-label" for="ViolinPlot-abline.slopes">Slopes</label>
#>             <input id="ViolinPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.intercepts-label" for="ViolinPlot-abline.intercepts">Y-intercepts</label>
#>             <input id="ViolinPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.colors-label" for="ViolinPlot-abline.colors">Colors</label>
#>             <input id="ViolinPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.widths-label" for="ViolinPlot-abline.widths">Widths</label>
#>             <input id="ViolinPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.linetypes-label" for="ViolinPlot-abline.linetypes">Line types</label>
#>             <input id="ViolinPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="ViolinPlot-abline.opacities-label" for="ViolinPlot-abline.opacities">Opacities (0-1)</label>
#>             <input id="ViolinPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="ViolinPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="ViolinPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="ViolinPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="ViolinPlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="ViolinPlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="ViolinPlot-download.type-label" for="ViolinPlot-download.type">Download Format</label>
#>       <div>
#>         <select id="ViolinPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="ViolinPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
