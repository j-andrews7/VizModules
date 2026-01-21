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
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="areaPlot-AreaPlotTabsetPanel" data-tabsetid="1055">
#>     <li class="active">
#>       <a href="#tab-1055-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1055-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1055-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetic">Aesthetic</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1055-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1055">
#>     <div class="tab-pane active" data-value="Data" id="tab-1055-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-x.data-label" for="areaPlot-x.data">X values:</label>
#>             <div>
#>               <select id="areaPlot-x.data" class="shiny-input-select"><option value=""></option>
#> <option value="cyl" selected>cyl</option>
#> <option value="gear">gear</option></select>
#>               <script type="application/json" data-for="areaPlot-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-y.data-label" for="areaPlot-y.data">Y values:</label>
#>             <div>
#>               <select id="areaPlot-y.data" class="shiny-input-select"><option value=""></option>
#> <option value="mpg" selected>mpg</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="areaPlot-y.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-group.by-label" for="areaPlot-group.by">Group by:</label>
#>             <div>
#>               <select id="areaPlot-group.by" class="shiny-input-select"><option value=""></option>
#> <option value=""></option>
#> <option value="gear" selected>gear</option></select>
#>               <script type="application/json" data-for="areaPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-1055-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-facet.by-label" for="areaPlot-facet.by">Facet by:</label>
#>             <div>
#>               <select id="areaPlot-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="gear">gear</option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="areaPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-facet.scale-label" for="areaPlot-facet.scale">Facet scale:</label>
#>             <div>
#>               <select id="areaPlot-facet.scale" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="areaPlot-facet.scale" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-facet.ncol-label" for="areaPlot-facet.ncol">Facet number of columns:</label>
#>             <input id="areaPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-facet.nrow-label" for="areaPlot-facet.nrow">Facet number of rows:</label>
#>             <input id="areaPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="areaPlot-facet.by.row" type="checkbox" class="sw-switchInput" data-input-id="areaPlot-facet.by.row" data-on-text="On" data-off-text="Off" data-label-text="Facet by row:" data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-split.by-label" for="areaPlot-split.by">Split by:</label>
#>             <div>
#>               <select id="areaPlot-split.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="cyl">cyl</option>
#> <option value="gear">gear</option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="areaPlot-split.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetic" id="tab-1055-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="areaPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-theme-label" for="areaPlot-theme">Theme:</label>
#>             <div>
#>               <select id="areaPlot-theme" class="shiny-input-select"><option value="theme_grey">theme_grey</option>
#> <option value="theme_bw">theme_bw</option>
#> <option value="theme_linedraw">theme_linedraw</option>
#> <option value="theme_light">theme_light</option>
#> <option value="theme_dark">theme_dark</option>
#> <option value="theme_minimal">theme_minimal</option>
#> <option value="theme_classic">theme_classic</option>
#> <option value="theme_void">theme_void</option>
#> <option value="theme_this" selected>theme_this</option>
#> <option value="theme_blank">theme_blank</option></select>
#>               <script type="application/json" data-for="areaPlot-theme" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-alpha-label" for="areaPlot-alpha">Alpha:</label>
#>             <input id="areaPlot-alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1055-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.font.size-label" for="areaPlot-axis.font.size">Axis font size</label>
#>             <input id="areaPlot-axis.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-title.font.size-label" for="areaPlot-title.font.size">Title font size</label>
#>             <input id="areaPlot-title.font.size" type="number" class="shiny-input-number form-control" value="28" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-font.type-label" for="areaPlot-font.type">Font:</label>
#>             <div>
#>               <select id="areaPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="areaPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="areaPlot-text.colour">Label colour:</label>
#>             <input id="areaPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="areaPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="areaPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="areaPlot-axis.linecolor">Axis line color</label>
#>             <input id="areaPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.linewidth-label" for="areaPlot-axis.linewidth">Axis line width</label>
#>             <input id="areaPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.tickfont.size-label" for="areaPlot-axis.tickfont.size">Tick label size</label>
#>             <input id="areaPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="areaPlot-axis.tickfont.color">Tick label color</label>
#>             <input id="areaPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.tickfont.family-label" for="areaPlot-axis.tickfont.family">Tick label font</label>
#>             <div>
#>               <select id="areaPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="areaPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.tickangle.x-label" for="areaPlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="areaPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.tickangle.y-label" for="areaPlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="areaPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.ticks-label" for="areaPlot-axis.ticks">Tick position</label>
#>             <div>
#>               <select id="areaPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="areaPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="areaPlot-axis.tickcolor">Tick mark color</label>
#>             <input id="areaPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.ticklen-label" for="areaPlot-axis.ticklen">Tick mark length</label>
#>             <input id="areaPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="areaPlot-axis.tickwidth-label" for="areaPlot-axis.tickwidth">Tick mark width</label>
#>             <input id="areaPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <input id="areaPlot-auto.update" type="checkbox" class="sw-switchInput" data-input-id="areaPlot-auto.update" data-on-text="ON" data-off-text="OFF" data-label-text="Auto Update" data-label-width="auto" data-handle-width="auto" data-size="mini"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="areaPlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="areaPlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="areaPlot-download.type-label" for="areaPlot-download.type">Download Format</label>
#>       <div>
#>         <select id="areaPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="areaPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
