# Input UI components for the BoxPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`BoxPlotServer()`](https://j-andrews7.github.io/vizModules/reference/boxPlotServer.md)
and
[`BoxPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/boxPlotOutputUI.md)
functions.

## Usage

``` r
BoxPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`BoxPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/boxPlotOutputUI.md),
[`BoxPlotServer()`](https://j-andrews7.github.io/vizModules/reference/boxPlotServer.md),
`createBoxPlotApp()`

## Author

Jacob Martin

## Examples

``` r
library(vizModules)
data(mtcars)
BoxPlotInputsUI("BoxPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="BoxPlot-BoxPlotTabsetPanel" data-tabsetid="6444">
#>     <li class="active">
#>       <a href="#tab-6444-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-4" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-5" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-6" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-7" data-toggle="tab" data-bs-toggle="tab" data-value="Palette">Palette</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-8" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6444-9" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6444">
#>     <div class="tab-pane active" data-value="Data" id="tab-6444-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-x.data-label" for="BoxPlot-x.data">Select X data:</label>
#>             <div>
#>               <select id="BoxPlot-x.data" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="BoxPlot-x.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.data-label" for="BoxPlot-y.data">Select Y data:</label>
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
#>             <label class="control-label" id="BoxPlot-group.by-label" for="BoxPlot-group.by">Group by:</label>
#>             <div>
#>               <select id="BoxPlot-group.by" class="shiny-input-select"><option value=""></option>
#> <option value="NULL" selected>NULL</option></select>
#>               <script type="application/json" data-for="BoxPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-6444-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-sort_x-label" for="BoxPlot-sort_x">Sort the X axis by: </label>
#>             <div>
#>               <select id="BoxPlot-sort_x" class="shiny-input-select"><option value="none" selected>none</option>
#> <option value="mean_asc">mean_asc</option>
#> <option value="mean_desc">mean_desc</option>
#> <option value="mean">mean</option>
#> <option value="median_asc">median_asc</option>
#> <option value="median_desc">median_desc</option>
#> <option value="median">median</option></select>
#>               <script type="application/json" data-for="BoxPlot-sort_x" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-flip" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-flip" data-on-text="Flipped" data-off-text="Not Flipped" data-label-text="Flip the Plot: " data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-stack" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-stack" data-on-text="Stacked" data-off-text="Not Stacked" data-label-text="Stack Plot: " data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.max-label" for="BoxPlot-y.max">Max Value of Y Axis:</label>
#>             <input id="BoxPlot-y.max" type="number" class="shiny-input-number form-control" value="472" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-y.min-label" for="BoxPlot-y.min">Min Value of Y Axis:</label>
#>             <input id="BoxPlot-y.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-aspect.ratio-label" for="BoxPlot-aspect.ratio">Aspect Ratio:</label>
#>             <input id="BoxPlot-aspect.ratio" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="100"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-6444-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-add.points" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-add.points" data-on-text="Points" data-off-text="No Points" data-label-text="Add Jitter Points: " data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-pt.size-label" for="BoxPlot-pt.size">Point Size:</label>
#>             <input id="BoxPlot-pt.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="100"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-pt.alpha-label" for="BoxPlot-pt.alpha">Point Alpha:</label>
#>             <input id="BoxPlot-pt.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-jitter.width-label" for="BoxPlot-jitter.width">Jitter Width:</label>
#>             <input id="BoxPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-jitter.height-label" for="BoxPlot-jitter.height">Jitter Height: </label>
#>             <input id="BoxPlot-jitter.height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-pt.color">Point outline colour</label>
#>             <input id="BoxPlot-pt.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-6444-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-add.line-label" for="BoxPlot-add.line">Add Y interception line:</label>
#>             <input id="BoxPlot-add.line" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="472"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight-label" for="BoxPlot-highlight">Highlight:</label>
#>             <input id="BoxPlot-highlight" type="text" class="shiny-input-text form-control" value="" placeholder="E.g. y &gt; 0" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-highlight.colour">Highlight colour:</label>
#>             <input id="BoxPlot-highlight.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight.size-label" for="BoxPlot-highlight.size">Highlight size:</label>
#>             <input id="BoxPlot-highlight.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-highlight.alpha-label" for="BoxPlot-highlight.alpha">Highlight alpha</label>
#>             <input id="BoxPlot-highlight.alpha" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-font.type-label" for="BoxPlot-font.type">Font type:</label>
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
#>             <label class="control-label" for="BoxPlot-text.colour">Axis title colour:</label>
#>             <input id="BoxPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-6444-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-add.trend" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-add.trend" data-on-text="Trend Added" data-off-text="Trend Not Added" data-label-text="Add Median Point" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-trend.pt.size-label" for="BoxPlot-trend.pt.size">Trend Point Size:</label>
#>             <input id="BoxPlot-trend.pt.size" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="40"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-trend.colour">Colour of trend:</label>
#>             <input id="BoxPlot-trend.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-trend.line.width-label" for="BoxPlot-trend.line.width">Trend line width:</label>
#>             <input id="BoxPlot-trend.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-6444-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-add.stat-label" for="BoxPlot-add.stat">Add Stats:</label>
#>             <div>
#>               <select id="BoxPlot-add.stat" class="shiny-input-select"><option value="mean" selected>mean</option>
#> <option value="sd">sd</option>
#> <option value="median">median</option>
#> <option value="var">var</option></select>
#>               <script type="application/json" data-for="BoxPlot-add.stat" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-stat.color">Stats Colour:</label>
#>             <input id="BoxPlot-stat.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-stat.size-label" for="BoxPlot-stat.size">Stat Size:</label>
#>             <input id="BoxPlot-stat.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-stat.stroke-label" for="BoxPlot-stat.stroke">Stat Stroke:</label>
#>             <input id="BoxPlot-stat.stroke" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-stat.shape-label" for="BoxPlot-stat.shape">Stat Shape:</label>
#>             <input id="BoxPlot-stat.shape" type="number" class="shiny-input-number form-control" value="25" data-update-on="change" min="0" max="100"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Palette" id="tab-6444-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-palette-label" for="BoxPlot-palette">Plot Palette:</label>
#>             <div>
#>               <select id="BoxPlot-palette" class="shiny-input-select"><option value="BrBG">BrBG</option>
#> <option value="PiYG">PiYG</option>
#> <option value="PRGn">PRGn</option>
#> <option value="PuOr">PuOr</option>
#> <option value="RdBu">RdBu</option>
#> <option value="RdGy">RdGy</option>
#> <option value="RdYlBu">RdYlBu</option>
#> <option value="RdYlGn">RdYlGn</option>
#> <option value="Spectral">Spectral</option>
#> <option value="Accent">Accent</option>
#> <option value="Dark2">Dark2</option>
#> <option value="Paired" selected>Paired</option>
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
#> <option value="YlOrRd">YlOrRd</option>
#> <option value="npg">npg</option>
#> <option value="aaas">aaas</option>
#> <option value="nejm">nejm</option>
#> <option value="lancet">lancet</option>
#> <option value="jama">jama</option>
#> <option value="jco">jco</option>
#> <option value="ucscgb">ucscgb</option>
#> <option value="d3-category10">d3-category10</option>
#> <option value="d3-category20">d3-category20</option>
#> <option value="d3-category20b">d3-category20b</option>
#> <option value="d3-category20c">d3-category20c</option>
#> <option value="igv">igv</option>
#> <option value="locuszoom">locuszoom</option>
#> <option value="uchicago-default">uchicago-default</option>
#> <option value="uchicago-light">uchicago-light</option>
#> <option value="uchicago-dark">uchicago-dark</option>
#> <option value="cosmic">cosmic</option>
#> <option value="simpsons">simpsons</option>
#> <option value="futurama">futurama</option>
#> <option value="rickandmorty">rickandmorty</option>
#> <option value="startrek">startrek</option>
#> <option value="tron">tron</option>
#> <option value="frontiers">frontiers</option>
#> <option value="flatui">flatui</option>
#> <option value="gsea">gsea</option>
#> <option value="material-red">material-red</option>
#> <option value="material-pink">material-pink</option>
#> <option value="material-purple">material-purple</option>
#> <option value="material-deep-purple">material-deep-purple</option>
#> <option value="material-indigo">material-indigo</option>
#> <option value="material-blue">material-blue</option>
#> <option value="material-light-blue">material-light-blue</option>
#> <option value="material-cyan">material-cyan</option>
#> <option value="material-teal">material-teal</option>
#> <option value="material-green">material-green</option>
#> <option value="material-light-green">material-light-green</option>
#> <option value="material-lime">material-lime</option>
#> <option value="material-yellow">material-yellow</option>
#> <option value="material-amber">material-amber</option>
#> <option value="material-orange">material-orange</option>
#> <option value="material-deep-orange">material-deep-orange</option>
#> <option value="material-brown">material-brown</option>
#> <option value="material-grey">material-grey</option>
#> <option value="material-blue-grey">material-blue-grey</option>
#> <option value="dPBIYlBu">dPBIYlBu</option>
#> <option value="dPBIYlPu">dPBIYlPu</option>
#> <option value="dPBIPuGn">dPBIPuGn</option>
#> <option value="dPBIPuOr">dPBIPuOr</option>
#> <option value="dPBIRdBu">dPBIRdBu</option>
#> <option value="dPBIRdGy">dPBIRdGy</option>
#> <option value="dPBIRdGn">dPBIRdGn</option>
#> <option value="qMSOStd">qMSOStd</option>
#> <option value="qMSO12">qMSO12</option>
#> <option value="qMSO15">qMSO15</option>
#> <option value="qMSOBuWarm">qMSOBuWarm</option>
#> <option value="qMSOBu">qMSOBu</option>
#> <option value="qMSOBu2">qMSOBu2</option>
#> <option value="qMSOBuGn">qMSOBuGn</option>
#> <option value="qMSOGn">qMSOGn</option>
#> <option value="qMSOGnYl">qMSOGnYl</option>
#> <option value="qMSOYl">qMSOYl</option>
#> <option value="qMSOYlOr">qMSOYlOr</option>
#> <option value="qMSOOr">qMSOOr</option>
#> <option value="qMSOOrRd">qMSOOrRd</option>
#> <option value="qMSORdOr">qMSORdOr</option>
#> <option value="qMSORd">qMSORd</option>
#> <option value="qMSORdPu">qMSORdPu</option>
#> <option value="qMSOPu">qMSOPu</option>
#> <option value="qMSOPu2">qMSOPu2</option>
#> <option value="qMSOMed">qMSOMed</option>
#> <option value="qMSOPap">qMSOPap</option>
#> <option value="qMSOMrq">qMSOMrq</option>
#> <option value="qMSOSlp">qMSOSlp</option>
#> <option value="qMSOAsp">qMSOAsp</option>
#> <option value="qPBI">qPBI</option>
#> <option value="sPBIGn">sPBIGn</option>
#> <option value="sPBIGy1">sPBIGy1</option>
#> <option value="sPBIRd">sPBIRd</option>
#> <option value="sPBIYl">sPBIYl</option>
#> <option value="sPBIGy2">sPBIGy2</option>
#> <option value="sPBIBu">sPBIBu</option>
#> <option value="sPBIOr">sPBIOr</option>
#> <option value="sPBIPu">sPBIPu</option>
#> <option value="sPBIYlGn">sPBIYlGn</option>
#> <option value="sPBIRdPu">sPBIRdPu</option>
#> <option value="ag_GrnYl">ag_GrnYl</option>
#> <option value="ag_Sunset">ag_Sunset</option>
#> <option value="ArmyRose">ArmyRose</option>
#> <option value="Earth">Earth</option>
#> <option value="Fall">Fall</option>
#> <option value="Geyser">Geyser</option>
#> <option value="TealRose">TealRose</option>
#> <option value="Temps">Temps</option>
#> <option value="Tropic">Tropic</option>
#> <option value="Antique">Antique</option>
#> <option value="Bold">Bold</option>
#> <option value="Pastel">Pastel</option>
#> <option value="Prism">Prism</option>
#> <option value="Safe">Safe</option>
#> <option value="Vivid">Vivid</option>
#> <option value="BluGrn">BluGrn</option>
#> <option value="BluYl">BluYl</option>
#> <option value="BrwnYl">BrwnYl</option>
#> <option value="Burg">Burg</option>
#> <option value="BurgYl">BurgYl</option>
#> <option value="DarkMint">DarkMint</option>
#> <option value="Emrld">Emrld</option>
#> <option value="Magenta">Magenta</option>
#> <option value="Mint">Mint</option>
#> <option value="OrYel">OrYel</option>
#> <option value="Peach">Peach</option>
#> <option value="PinkYl">PinkYl</option>
#> <option value="Purp">Purp</option>
#> <option value="PurpOr">PurpOr</option>
#> <option value="RedOr">RedOr</option>
#> <option value="Sunset">Sunset</option>
#> <option value="SunsetDark">SunsetDark</option>
#> <option value="Teal">Teal</option>
#> <option value="TealGrn">TealGrn</option>
#> <option value="polarnight">polarnight</option>
#> <option value="snowstorm">snowstorm</option>
#> <option value="frost">frost</option>
#> <option value="aurora">aurora</option>
#> <option value="lumina">lumina</option>
#> <option value="mountain_forms">mountain_forms</option>
#> <option value="silver_mine">silver_mine</option>
#> <option value="lake_superior">lake_superior</option>
#> <option value="victory_bonds">victory_bonds</option>
#> <option value="halifax_harbor">halifax_harbor</option>
#> <option value="moose_pond">moose_pond</option>
#> <option value="algoma_forest">algoma_forest</option>
#> <option value="rocky_mountain">rocky_mountain</option>
#> <option value="red_mountain">red_mountain</option>
#> <option value="baie_mouton">baie_mouton</option>
#> <option value="afternoon_prarie">afternoon_prarie</option>
#> <option value="magma">magma</option>
#> <option value="inferno">inferno</option>
#> <option value="plasma">plasma</option>
#> <option value="viridis">viridis</option>
#> <option value="cividis">cividis</option>
#> <option value="rocket">rocket</option>
#> <option value="mako">mako</option>
#> <option value="turbo">turbo</option>
#> <option value="ocean.algae">ocean.algae</option>
#> <option value="ocean.deep">ocean.deep</option>
#> <option value="ocean.dense">ocean.dense</option>
#> <option value="ocean.gray">ocean.gray</option>
#> <option value="ocean.haline">ocean.haline</option>
#> <option value="ocean.ice">ocean.ice</option>
#> <option value="ocean.matter">ocean.matter</option>
#> <option value="ocean.oxy">ocean.oxy</option>
#> <option value="ocean.phase">ocean.phase</option>
#> <option value="ocean.solar">ocean.solar</option>
#> <option value="ocean.thermal">ocean.thermal</option>
#> <option value="ocean.turbid">ocean.turbid</option>
#> <option value="ocean.balance">ocean.balance</option>
#> <option value="ocean.curl">ocean.curl</option>
#> <option value="ocean.delta">ocean.delta</option>
#> <option value="ocean.amp">ocean.amp</option>
#> <option value="ocean.speed">ocean.speed</option>
#> <option value="ocean.tempo">ocean.tempo</option>
#> <option value="BrowntoBlue.10">BrowntoBlue.10</option>
#> <option value="BrowntoBlue.12">BrowntoBlue.12</option>
#> <option value="BluetoDarkOrange.12">BluetoDarkOrange.12</option>
#> <option value="BluetoDarkOrange.18">BluetoDarkOrange.18</option>
#> <option value="DarkRedtoBlue.12">DarkRedtoBlue.12</option>
#> <option value="DarkRedtoBlue.18">DarkRedtoBlue.18</option>
#> <option value="BluetoGreen.14">BluetoGreen.14</option>
#> <option value="BluetoGray.8">BluetoGray.8</option>
#> <option value="BluetoOrangeRed.14">BluetoOrangeRed.14</option>
#> <option value="BluetoOrange.10">BluetoOrange.10</option>
#> <option value="BluetoOrange.12">BluetoOrange.12</option>
#> <option value="BluetoOrange.8">BluetoOrange.8</option>
#> <option value="LightBluetoDarkBlue.10">LightBluetoDarkBlue.10</option>
#> <option value="LightBluetoDarkBlue.7">LightBluetoDarkBlue.7</option>
#> <option value="Categorical.12">Categorical.12</option>
#> <option value="GreentoMagenta.16">GreentoMagenta.16</option>
#> <option value="SteppedSequential.5">SteppedSequential.5</option>
#> <option value="jcolors-default">jcolors-default</option>
#> <option value="jcolors-pal2">jcolors-pal2</option>
#> <option value="jcolors-pal3">jcolors-pal3</option>
#> <option value="jcolors-pal4">jcolors-pal4</option>
#> <option value="jcolors-pal5">jcolors-pal5</option>
#> <option value="jcolors-pal6">jcolors-pal6</option>
#> <option value="jcolors-pal7">jcolors-pal7</option>
#> <option value="jcolors-pal8">jcolors-pal8</option>
#> <option value="jcolors-pal9">jcolors-pal9</option>
#> <option value="jcolors-pal10">jcolors-pal10</option>
#> <option value="jcolors-pal11">jcolors-pal11</option>
#> <option value="jcolors-pal12">jcolors-pal12</option>
#> <option value="jcolors-rainbow">jcolors-rainbow</option>
#> <option value="jet">jet</option>
#> <option value="simspec">simspec</option>
#> <option value="GdRd">GdRd</option>
#> <option value="alphabet">alphabet</option>
#> <option value="alphabet2">alphabet2</option>
#> <option value="glasbey">glasbey</option>
#> <option value="polychrome">polychrome</option>
#> <option value="stepped">stepped</option>
#> <option value="parade">parade</option>
#> <option value="seurat.16">seurat.16</option>
#> <option value="seurat.32">seurat.32</option>
#> <option value="seurat.64">seurat.64</option>
#> <option value="seurat">seurat</option>
#> <option value="stripe">stripe</option>
#> <option value="stripe.16">stripe.16</option>
#> <option value="stripe.32">stripe.32</option>
#> <option value="stripe.64">stripe.64</option></select>
#>               <script type="application/json" data-for="BoxPlot-palette" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-background.colour" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-background.colour" data-on-text="On" data-off-text="Off" data-label-text="Background colour:" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-background.palette-label" for="BoxPlot-background.palette">Background Palette:</label>
#>             <div>
#>               <select id="BoxPlot-background.palette" class="shiny-input-select"><option value="BrBG">BrBG</option>
#> <option value="PiYG">PiYG</option>
#> <option value="PRGn">PRGn</option>
#> <option value="PuOr">PuOr</option>
#> <option value="RdBu">RdBu</option>
#> <option value="RdGy">RdGy</option>
#> <option value="RdYlBu">RdYlBu</option>
#> <option value="RdYlGn">RdYlGn</option>
#> <option value="Spectral">Spectral</option>
#> <option value="Accent">Accent</option>
#> <option value="Dark2">Dark2</option>
#> <option value="Paired" selected>Paired</option>
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
#> <option value="YlOrRd">YlOrRd</option>
#> <option value="npg">npg</option>
#> <option value="aaas">aaas</option>
#> <option value="nejm">nejm</option>
#> <option value="lancet">lancet</option>
#> <option value="jama">jama</option>
#> <option value="jco">jco</option>
#> <option value="ucscgb">ucscgb</option>
#> <option value="d3-category10">d3-category10</option>
#> <option value="d3-category20">d3-category20</option>
#> <option value="d3-category20b">d3-category20b</option>
#> <option value="d3-category20c">d3-category20c</option>
#> <option value="igv">igv</option>
#> <option value="locuszoom">locuszoom</option>
#> <option value="uchicago-default">uchicago-default</option>
#> <option value="uchicago-light">uchicago-light</option>
#> <option value="uchicago-dark">uchicago-dark</option>
#> <option value="cosmic">cosmic</option>
#> <option value="simpsons">simpsons</option>
#> <option value="futurama">futurama</option>
#> <option value="rickandmorty">rickandmorty</option>
#> <option value="startrek">startrek</option>
#> <option value="tron">tron</option>
#> <option value="frontiers">frontiers</option>
#> <option value="flatui">flatui</option>
#> <option value="gsea">gsea</option>
#> <option value="material-red">material-red</option>
#> <option value="material-pink">material-pink</option>
#> <option value="material-purple">material-purple</option>
#> <option value="material-deep-purple">material-deep-purple</option>
#> <option value="material-indigo">material-indigo</option>
#> <option value="material-blue">material-blue</option>
#> <option value="material-light-blue">material-light-blue</option>
#> <option value="material-cyan">material-cyan</option>
#> <option value="material-teal">material-teal</option>
#> <option value="material-green">material-green</option>
#> <option value="material-light-green">material-light-green</option>
#> <option value="material-lime">material-lime</option>
#> <option value="material-yellow">material-yellow</option>
#> <option value="material-amber">material-amber</option>
#> <option value="material-orange">material-orange</option>
#> <option value="material-deep-orange">material-deep-orange</option>
#> <option value="material-brown">material-brown</option>
#> <option value="material-grey">material-grey</option>
#> <option value="material-blue-grey">material-blue-grey</option>
#> <option value="dPBIYlBu">dPBIYlBu</option>
#> <option value="dPBIYlPu">dPBIYlPu</option>
#> <option value="dPBIPuGn">dPBIPuGn</option>
#> <option value="dPBIPuOr">dPBIPuOr</option>
#> <option value="dPBIRdBu">dPBIRdBu</option>
#> <option value="dPBIRdGy">dPBIRdGy</option>
#> <option value="dPBIRdGn">dPBIRdGn</option>
#> <option value="qMSOStd">qMSOStd</option>
#> <option value="qMSO12">qMSO12</option>
#> <option value="qMSO15">qMSO15</option>
#> <option value="qMSOBuWarm">qMSOBuWarm</option>
#> <option value="qMSOBu">qMSOBu</option>
#> <option value="qMSOBu2">qMSOBu2</option>
#> <option value="qMSOBuGn">qMSOBuGn</option>
#> <option value="qMSOGn">qMSOGn</option>
#> <option value="qMSOGnYl">qMSOGnYl</option>
#> <option value="qMSOYl">qMSOYl</option>
#> <option value="qMSOYlOr">qMSOYlOr</option>
#> <option value="qMSOOr">qMSOOr</option>
#> <option value="qMSOOrRd">qMSOOrRd</option>
#> <option value="qMSORdOr">qMSORdOr</option>
#> <option value="qMSORd">qMSORd</option>
#> <option value="qMSORdPu">qMSORdPu</option>
#> <option value="qMSOPu">qMSOPu</option>
#> <option value="qMSOPu2">qMSOPu2</option>
#> <option value="qMSOMed">qMSOMed</option>
#> <option value="qMSOPap">qMSOPap</option>
#> <option value="qMSOMrq">qMSOMrq</option>
#> <option value="qMSOSlp">qMSOSlp</option>
#> <option value="qMSOAsp">qMSOAsp</option>
#> <option value="qPBI">qPBI</option>
#> <option value="sPBIGn">sPBIGn</option>
#> <option value="sPBIGy1">sPBIGy1</option>
#> <option value="sPBIRd">sPBIRd</option>
#> <option value="sPBIYl">sPBIYl</option>
#> <option value="sPBIGy2">sPBIGy2</option>
#> <option value="sPBIBu">sPBIBu</option>
#> <option value="sPBIOr">sPBIOr</option>
#> <option value="sPBIPu">sPBIPu</option>
#> <option value="sPBIYlGn">sPBIYlGn</option>
#> <option value="sPBIRdPu">sPBIRdPu</option>
#> <option value="ag_GrnYl">ag_GrnYl</option>
#> <option value="ag_Sunset">ag_Sunset</option>
#> <option value="ArmyRose">ArmyRose</option>
#> <option value="Earth">Earth</option>
#> <option value="Fall">Fall</option>
#> <option value="Geyser">Geyser</option>
#> <option value="TealRose">TealRose</option>
#> <option value="Temps">Temps</option>
#> <option value="Tropic">Tropic</option>
#> <option value="Antique">Antique</option>
#> <option value="Bold">Bold</option>
#> <option value="Pastel">Pastel</option>
#> <option value="Prism">Prism</option>
#> <option value="Safe">Safe</option>
#> <option value="Vivid">Vivid</option>
#> <option value="BluGrn">BluGrn</option>
#> <option value="BluYl">BluYl</option>
#> <option value="BrwnYl">BrwnYl</option>
#> <option value="Burg">Burg</option>
#> <option value="BurgYl">BurgYl</option>
#> <option value="DarkMint">DarkMint</option>
#> <option value="Emrld">Emrld</option>
#> <option value="Magenta">Magenta</option>
#> <option value="Mint">Mint</option>
#> <option value="OrYel">OrYel</option>
#> <option value="Peach">Peach</option>
#> <option value="PinkYl">PinkYl</option>
#> <option value="Purp">Purp</option>
#> <option value="PurpOr">PurpOr</option>
#> <option value="RedOr">RedOr</option>
#> <option value="Sunset">Sunset</option>
#> <option value="SunsetDark">SunsetDark</option>
#> <option value="Teal">Teal</option>
#> <option value="TealGrn">TealGrn</option>
#> <option value="polarnight">polarnight</option>
#> <option value="snowstorm">snowstorm</option>
#> <option value="frost">frost</option>
#> <option value="aurora">aurora</option>
#> <option value="lumina">lumina</option>
#> <option value="mountain_forms">mountain_forms</option>
#> <option value="silver_mine">silver_mine</option>
#> <option value="lake_superior">lake_superior</option>
#> <option value="victory_bonds">victory_bonds</option>
#> <option value="halifax_harbor">halifax_harbor</option>
#> <option value="moose_pond">moose_pond</option>
#> <option value="algoma_forest">algoma_forest</option>
#> <option value="rocky_mountain">rocky_mountain</option>
#> <option value="red_mountain">red_mountain</option>
#> <option value="baie_mouton">baie_mouton</option>
#> <option value="afternoon_prarie">afternoon_prarie</option>
#> <option value="magma">magma</option>
#> <option value="inferno">inferno</option>
#> <option value="plasma">plasma</option>
#> <option value="viridis">viridis</option>
#> <option value="cividis">cividis</option>
#> <option value="rocket">rocket</option>
#> <option value="mako">mako</option>
#> <option value="turbo">turbo</option>
#> <option value="ocean.algae">ocean.algae</option>
#> <option value="ocean.deep">ocean.deep</option>
#> <option value="ocean.dense">ocean.dense</option>
#> <option value="ocean.gray">ocean.gray</option>
#> <option value="ocean.haline">ocean.haline</option>
#> <option value="ocean.ice">ocean.ice</option>
#> <option value="ocean.matter">ocean.matter</option>
#> <option value="ocean.oxy">ocean.oxy</option>
#> <option value="ocean.phase">ocean.phase</option>
#> <option value="ocean.solar">ocean.solar</option>
#> <option value="ocean.thermal">ocean.thermal</option>
#> <option value="ocean.turbid">ocean.turbid</option>
#> <option value="ocean.balance">ocean.balance</option>
#> <option value="ocean.curl">ocean.curl</option>
#> <option value="ocean.delta">ocean.delta</option>
#> <option value="ocean.amp">ocean.amp</option>
#> <option value="ocean.speed">ocean.speed</option>
#> <option value="ocean.tempo">ocean.tempo</option>
#> <option value="BrowntoBlue.10">BrowntoBlue.10</option>
#> <option value="BrowntoBlue.12">BrowntoBlue.12</option>
#> <option value="BluetoDarkOrange.12">BluetoDarkOrange.12</option>
#> <option value="BluetoDarkOrange.18">BluetoDarkOrange.18</option>
#> <option value="DarkRedtoBlue.12">DarkRedtoBlue.12</option>
#> <option value="DarkRedtoBlue.18">DarkRedtoBlue.18</option>
#> <option value="BluetoGreen.14">BluetoGreen.14</option>
#> <option value="BluetoGray.8">BluetoGray.8</option>
#> <option value="BluetoOrangeRed.14">BluetoOrangeRed.14</option>
#> <option value="BluetoOrange.10">BluetoOrange.10</option>
#> <option value="BluetoOrange.12">BluetoOrange.12</option>
#> <option value="BluetoOrange.8">BluetoOrange.8</option>
#> <option value="LightBluetoDarkBlue.10">LightBluetoDarkBlue.10</option>
#> <option value="LightBluetoDarkBlue.7">LightBluetoDarkBlue.7</option>
#> <option value="Categorical.12">Categorical.12</option>
#> <option value="GreentoMagenta.16">GreentoMagenta.16</option>
#> <option value="SteppedSequential.5">SteppedSequential.5</option>
#> <option value="jcolors-default">jcolors-default</option>
#> <option value="jcolors-pal2">jcolors-pal2</option>
#> <option value="jcolors-pal3">jcolors-pal3</option>
#> <option value="jcolors-pal4">jcolors-pal4</option>
#> <option value="jcolors-pal5">jcolors-pal5</option>
#> <option value="jcolors-pal6">jcolors-pal6</option>
#> <option value="jcolors-pal7">jcolors-pal7</option>
#> <option value="jcolors-pal8">jcolors-pal8</option>
#> <option value="jcolors-pal9">jcolors-pal9</option>
#> <option value="jcolors-pal10">jcolors-pal10</option>
#> <option value="jcolors-pal11">jcolors-pal11</option>
#> <option value="jcolors-pal12">jcolors-pal12</option>
#> <option value="jcolors-rainbow">jcolors-rainbow</option>
#> <option value="jet">jet</option>
#> <option value="simspec">simspec</option>
#> <option value="GdRd">GdRd</option>
#> <option value="alphabet">alphabet</option>
#> <option value="alphabet2">alphabet2</option>
#> <option value="glasbey">glasbey</option>
#> <option value="polychrome">polychrome</option>
#> <option value="stepped">stepped</option>
#> <option value="parade">parade</option>
#> <option value="seurat.16">seurat.16</option>
#> <option value="seurat.32">seurat.32</option>
#> <option value="seurat.64">seurat.64</option>
#> <option value="seurat">seurat</option>
#> <option value="stripe">stripe</option>
#> <option value="stripe.16">stripe.16</option>
#> <option value="stripe.32">stripe.32</option>
#> <option value="stripe.64">stripe.64</option></select>
#>               <script type="application/json" data-for="BoxPlot-background.palette" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-6444-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.by-label" for="BoxPlot-facet.by">Facet by:</label>
#>             <div>
#>               <select id="BoxPlot-facet.by" class="shiny-input-select"><option value=""></option>
#> <option value="NULL" selected>NULL</option></select>
#>               <script type="application/json" data-for="BoxPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.scale-label" for="BoxPlot-facet.scale">Facet scale:</label>
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
#>             <label class="control-label" id="BoxPlot-facet.ncol-label" for="BoxPlot-facet.ncol">Facet number of columns:</label>
#>             <input id="BoxPlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-facet.nrow-label" for="BoxPlot-facet.nrow">Facet number of rows:</label>
#>             <input id="BoxPlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-facet.by.row" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-facet.by.row" data-on-text="On" data-off-text="Off" data-label-text="Facet by row:" data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="BoxPlot-combine" type="checkbox" class="sw-switchInput" data-input-id="BoxPlot-combine" data-on-text="On" data-off-text="Off" data-label-text="Combine plots:" data-label-width="auto" data-handle-width="auto" data-size="" checked="checked"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-6444-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="BoxPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.linecolor">Axis line color</label>
#>             <input id="BoxPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.linewidth-label" for="BoxPlot-axis.linewidth">Axis line width</label>
#>             <input id="BoxPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.size-label" for="BoxPlot-axis.tickfont.size">Tick label size</label>
#>             <input id="BoxPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="BoxPlot-axis.tickfont.color">Tick label color</label>
#>             <input id="BoxPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickfont.family-label" for="BoxPlot-axis.tickfont.family">Tick label font</label>
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
#>             <label class="control-label" id="BoxPlot-axis.tickangle.x-label" for="BoxPlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="BoxPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickangle.y-label" for="BoxPlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="BoxPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticks-label" for="BoxPlot-axis.ticks">Tick position</label>
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
#>             <label class="control-label" for="BoxPlot-axis.tickcolor">Tick mark color</label>
#>             <input id="BoxPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.ticklen-label" for="BoxPlot-axis.ticklen">Tick mark length</label>
#>             <input id="BoxPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="BoxPlot-axis.tickwidth-label" for="BoxPlot-axis.tickwidth">Tick mark width</label>
#>             <input id="BoxPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <button id="BoxPlot-update" type="button" class="btn btn-default action-button">
#>   <span class="action-label">Update Plot</span>
#> </button>
#> <button class="btn btn-default action-button btn-secondary" id="BoxPlot-reset" type="button">
#>   <span class="action-label">Reset Defaults</span>
#> </button>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="BoxPlot-download.type-label" for="BoxPlot-download.type">Download Format:</label>
#>   <div>
#>     <select id="BoxPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>     <script type="application/json" data-for="BoxPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>   </div>
#> </div>
#> <br/>
```
