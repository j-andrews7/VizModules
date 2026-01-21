# Input UI components for the volcanoPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`volcanoPlotServer()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotServer.md)
and
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotOutputUI.md)
functions.

## Usage

``` r
volcanoPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Volcano Settings",
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
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Additional inputs specific to volcano plots are added to control
significance thresholds and colors:

- `sig.thresh`: Significance threshold (default 0.05)

- `fc.thresh`: Log2 fold change threshold (default 0)

- `color.up`: Color for upregulated genes (default "red")

- `color.down`: Color for downregulated genes (default "blue")

- `color.ns`: Color for non-significant genes (default "lightgray")

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotServer.md),
[`volcanoPlotApp()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data(airway_deseq2)
volcanoPlotInputsUI("volcanoPlot", airway_deseq2)
#> <div class="row">
#>   <div class="col-sm-6">
#>     <div class="form-group shiny-input-container">
#>       <label class="control-label" id="volcanoPlot-sig.thresh-label" for="volcanoPlot-sig.thresh">Significance Threshold:</label>
#>       <input id="volcanoPlot-sig.thresh" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-6">
#>     <div class="form-group shiny-input-container">
#>       <label class="control-label" id="volcanoPlot-fc.thresh-label" for="volcanoPlot-fc.thresh">LFC Threshold (log2):</label>
#>       <input id="volcanoPlot-fc.thresh" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.25"/>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-6">
#>     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>       <label class="control-label" for="volcanoPlot-color.up">Up Color</label>
#>       <input id="volcanoPlot-color.up" type="text" class="form-control shiny-colour-input" data-init-value="red" data-show-colour="both" data-palette="square"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-6">
#>     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>       <label class="control-label" for="volcanoPlot-color.down">Down Color</label>
#>       <input id="volcanoPlot-color.down" type="text" class="form-control shiny-colour-input" data-init-value="blue" data-show-colour="both" data-palette="square"/>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-6">
#>     <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>       <label class="control-label" for="volcanoPlot-color.ns">N.S. Color</label>
#>       <input id="volcanoPlot-color.ns" type="text" class="form-control shiny-colour-input" data-init-value="lightgray" data-show-colour="both" data-palette="square"/>
#>     </div>
#>   </div>
#> </div>
#> <h3>Volcano Settings</h3>
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="volcanoPlot-scatterPlotTabsetPanel" data-tabsetid="6227">
#>     <li class="active">
#>       <a href="#tab-6227-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facets">Facets</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend/Scale">Legend/Scale</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-9" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-10" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-11" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6227-12" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6227">
#>     <div class="tab-pane active" data-value="Data" id="tab-6227-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-x.by-label" for="volcanoPlot-x.by">X-axis variable</label>
#>             <div>
#>               <select id="volcanoPlot-x.by" class="shiny-input-select"><option value=""></option>
#> <option value="baseMean">baseMean</option>
#> <option value="log2FoldChange" selected>log2FoldChange</option>
#> <option value="lfcSE">lfcSE</option>
#> <option value="stat">stat</option>
#> <option value="pvalue">pvalue</option>
#> <option value="padj">padj</option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-x.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-y.by-label" for="volcanoPlot-y.by">Y-axis variable</label>
#>             <div>
#>               <select id="volcanoPlot-y.by" class="shiny-input-select"><option value=""></option>
#> <option value="baseMean">baseMean</option>
#> <option value="log2FoldChange">log2FoldChange</option>
#> <option value="lfcSE">lfcSE</option>
#> <option value="stat">stat</option>
#> <option value="pvalue">pvalue</option>
#> <option value="padj" selected>padj</option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-y.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-color.by-label" for="volcanoPlot-color.by">Color by</label>
#>             <div>
#>               <select id="volcanoPlot-color.by" class="shiny-input-select"><option value=""></option>
#> <option value="baseMean">baseMean</option>
#> <option value="log2FoldChange">log2FoldChange</option>
#> <option value="lfcSE">lfcSE</option>
#> <option value="stat">stat</option>
#> <option value="pvalue">pvalue</option>
#> <option value="padj">padj</option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group" selected>group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-color.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.by-label" for="volcanoPlot-shape.by">Shape by</label>
#>             <div>
#>               <select id="volcanoPlot-shape.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-shape.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.by-label" for="volcanoPlot-split.by">Split by</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="volcanoPlot-split.by" multiple="multiple"><option value="" selected></option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-split.by">{"maxItems":2,"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-rows.use-label" for="volcanoPlot-rows.use">Rows to plot</label>
#>             <input id="volcanoPlot-rows.use" type="text" class="shiny-input-text form-control" value="" placeholder="Filter expression, e.g. Sepal.Length &gt; 5" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-6227-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-x.adjustment-label" for="volcanoPlot-x.adjustment">X-axis adjustment</label>
#>             <div>
#>               <select id="volcanoPlot-x.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="volcanoPlot-x.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-y.adjustment-label" for="volcanoPlot-y.adjustment">Y-axis adjustment</label>
#>             <div>
#>               <select id="volcanoPlot-y.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="volcanoPlot-y.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-color.adjustment-label" for="volcanoPlot-color.adjustment">Color adjustment</label>
#>             <div>
#>               <select id="volcanoPlot-color.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="volcanoPlot-color.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-x.adj.fxn-label" for="volcanoPlot-x.adj.fxn">X-axis adjustment function</label>
#>             <div>
#>               <select id="volcanoPlot-x.adj.fxn" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="volcanoPlot-x.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-y.adj.fxn-label" for="volcanoPlot-y.adj.fxn">Y-axis adjustment function</label>
#>             <div>
#>               <select id="volcanoPlot-y.adj.fxn" class="shiny-input-select"><option value=""></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10" selected>neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="volcanoPlot-y.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-color.adj.fxn-label" for="volcanoPlot-color.adj.fxn">Color adjustment function</label>
#>             <div>
#>               <select id="volcanoPlot-color.adj.fxn" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="volcanoPlot-color.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-6227-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-size-label" for="volcanoPlot-size">Point size</label>
#>             <input id="volcanoPlot-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-opacity-label" for="volcanoPlot-opacity">Point opacity</label>
#>             <input id="volcanoPlot-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-show.others" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Show others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show split others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-plot.order-label" for="volcanoPlot-plot.order">Plot order</label>
#>             <div>
#>               <select id="volcanoPlot-plot.order" class="shiny-input-select"><option value="unordered" selected>unordered</option>
#> <option value="increasing">increasing</option>
#> <option value="decreasing">decreasing</option>
#> <option value="randomize">randomize</option></select>
#>               <script type="application/json" data-for="volcanoPlot-plot.order" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.panel-label" for="volcanoPlot-shape.panel">Shape panel</label>
#>             <input id="volcanoPlot-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-6227-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-min.color">Min color</label>
#>             <input id="volcanoPlot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-max.color">Max color</label>
#>             <input id="volcanoPlot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-contour.color">Contour color</label>
#>             <input id="volcanoPlot-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-contour.linetype-label" for="volcanoPlot-contour.linetype">Contour linetype</label>
#>             <div>
#>               <select id="volcanoPlot-contour.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dashed">dashed</option>
#> <option value="dotted">dotted</option>
#> <option value="dotdash">dotdash</option>
#> <option value="longdash">longdash</option>
#> <option value="twodash">twodash</option></select>
#>               <script type="application/json" data-for="volcanoPlot-contour.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="volcanoPlot-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facets" id="tab-6227-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.nrow-label" for="volcanoPlot-split.nrow">Split nrow</label>
#>             <input id="volcanoPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.ncol-label" for="volcanoPlot-split.ncol">Split ncol</label>
#>             <input id="volcanoPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-multivar.split.dir-label" for="volcanoPlot-multivar.split.dir">Multivar split dir</label>
#>             <div>
#>               <select id="volcanoPlot-multivar.split.dir" class="shiny-input-select"><option value="col" selected>col</option>
#> <option value="row">row</option></select>
#>               <script type="application/json" data-for="volcanoPlot-multivar.split.dir" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.adjust.scales-label" for="volcanoPlot-split.adjust.scales">Facet scales</label>
#>             <div>
#>               <select id="volcanoPlot-split.adjust.scales" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="volcanoPlot-split.adjust.scales" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-6227-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotate.by-label" for="volcanoPlot-annotate.by">Annotate by</label>
#>             <div>
#>               <select id="volcanoPlot-annotate.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="baseMean">baseMean</option>
#> <option value="log2FoldChange">log2FoldChange</option>
#> <option value="lfcSE">lfcSE</option>
#> <option value="stat">stat</option>
#> <option value="pvalue">pvalue</option>
#> <option value="padj">padj</option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-annotate.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="shiny-input-textarea form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-highlight.points-label" for="volcanoPlot-highlight.points">Points to highlight</label>
#>             <textarea id="volcanoPlot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-highlight.color">Highlight color</label>
#>             <input id="volcanoPlot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-highlight.size-label" for="volcanoPlot-highlight.size">Highlight size</label>
#>             <input id="volcanoPlot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-highlight.border.color">Highlight border color</label>
#>             <input id="volcanoPlot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-highlight.border.width-label" for="volcanoPlot-highlight.border.width">Highlight border width</label>
#>             <input id="volcanoPlot-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate highlighted points</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-annotation.color">Annotation color</label>
#>             <input id="volcanoPlot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.ax-label" for="volcanoPlot-annotation.ax">Annotation x-axis offset</label>
#>             <input id="volcanoPlot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.ay-label" for="volcanoPlot-annotation.ay">Annotation y-axis offset</label>
#>             <input id="volcanoPlot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.size-label" for="volcanoPlot-annotation.size">Annotation size</label>
#>             <input id="volcanoPlot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-annotation.arrowcolor">Arrow color</label>
#>             <input id="volcanoPlot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.arrowhead-label" for="volcanoPlot-annotation.arrowhead">Arrowhead style</label>
#>             <input id="volcanoPlot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.arrowwidth-label" for="volcanoPlot-annotation.arrowwidth">Arrow linewidth</label>
#>             <input id="volcanoPlot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <button id="volcanoPlot-annotation.clear" type="button" class="btn btn-default action-button">
#>             <span class="action-label">Clear annotations</span>
#>           </button>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend/Scale" id="tab-6227-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-legend.show" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Enable legend</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.title-label" for="volcanoPlot-legend.color.title">Legend title</label>
#>             <input id="volcanoPlot-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.size-label" for="volcanoPlot-legend.color.size">Legend color size</label>
#>             <input id="volcanoPlot-legend.color.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.shape.size-label" for="volcanoPlot-legend.shape.size">Legend shape size</label>
#>             <input id="volcanoPlot-legend.shape.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.breaks-label" for="volcanoPlot-legend.color.breaks">Legend tick breaks</label>
#>             <input id="volcanoPlot-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-min.value-label" for="volcanoPlot-min.value">Min value</label>
#>             <input id="volcanoPlot-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-max.value-label" for="volcanoPlot-max.value">Max value</label>
#>             <input id="volcanoPlot-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-6227-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-trajectory.group.by-label" for="volcanoPlot-trajectory.group.by">Trajectory group by</label>
#>             <div>
#>               <select id="volcanoPlot-trajectory.group.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol">symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-trajectory.group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-add.trajectory.by.groups-label" for="volcanoPlot-add.trajectory.by.groups">Add trajectory by groups</label>
#>             <input id="volcanoPlot-add.trajectory.by.groups" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. [A,B],[C,D,E]" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-trajectory.arrow.size-label" for="volcanoPlot-trajectory.arrow.size">Trajectory arrow size</label>
#>             <input id="volcanoPlot-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-6227-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-download.format-label" for="volcanoPlot-download.format">Download format</label>
#>             <div>
#>               <select id="volcanoPlot-download.format" class="shiny-input-select"><option value="svg" selected>svg</option>
#> <option value="png">png</option></select>
#>               <script type="application/json" data-for="volcanoPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-shape.fill">Shape fill</label>
#>             <input id="volcanoPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-shape.line.color">Shape line color</label>
#>             <input id="volcanoPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.line.width-label" for="volcanoPlot-shape.line.width">Shape line width</label>
#>             <input id="volcanoPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.linetype-label" for="volcanoPlot-shape.linetype">Shape linetype</label>
#>             <div>
#>               <select id="volcanoPlot-shape.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>               <script type="application/json" data-for="volcanoPlot-shape.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.opacity-label" for="volcanoPlot-shape.opacity">Shape opacity</label>
#>             <input id="volcanoPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-6227-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable contour</span>
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
#>                 <input id="volcanoPlot-show.grid.lines" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hover.data-label" for="volcanoPlot-hover.data">Hover data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="volcanoPlot-hover.data" multiple="multiple"><option value=""></option>
#> <option value="baseMean">baseMean</option>
#> <option value="log2FoldChange">log2FoldChange</option>
#> <option value="lfcSE">lfcSE</option>
#> <option value="stat">stat</option>
#> <option value="pvalue">pvalue</option>
#> <option value="padj">padj</option>
#> <option value="ensembl">ensembl</option>
#> <option value="symbol" selected>symbol</option>
#> <option value="group">group</option></select>
#>               <script type="application/json" data-for="volcanoPlot-hover.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hover.round.digits-label" for="volcanoPlot-hover.round.digits">Hover round digits</label>
#>             <input id="volcanoPlot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-6227-11">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-add.xline-label" for="volcanoPlot-add.xline">Add xlines</label>
#>             <input id="volcanoPlot-add.xline" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-add.yline-label" for="volcanoPlot-add.yline">Add ylines</label>
#>             <input id="volcanoPlot-add.yline" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-xline.linetype-label" for="volcanoPlot-xline.linetype">xline linetype</label>
#>             <div>
#>               <select id="volcanoPlot-xline.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dashed">dashed</option>
#> <option value="dotted">dotted</option>
#> <option value="dotdash">dotdash</option>
#> <option value="longdash">longdash</option>
#> <option value="twodash">twodash</option></select>
#>               <script type="application/json" data-for="volcanoPlot-xline.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-yline.linetype-label" for="volcanoPlot-yline.linetype">yline linetype</label>
#>             <div>
#>               <select id="volcanoPlot-yline.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dashed">dashed</option>
#> <option value="dotted">dotted</option>
#> <option value="dotdash">dotdash</option>
#> <option value="longdash">longdash</option>
#> <option value="twodash">twodash</option></select>
#>               <script type="application/json" data-for="volcanoPlot-yline.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-xline.color">xline color</label>
#>             <input id="volcanoPlot-xline.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-yline.color">yline color</label>
#>             <input id="volcanoPlot-yline.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="volcanoPlot-best.fit" type="checkbox" class="sw-switchInput" data-input-id="volcanoPlot-best.fit" data-on-text="On" data-off-text="Off" data-label-text="Line of best fit:" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-line.best.smoothness-label" for="volcanoPlot-line.best.smoothness">Smoothness of line of best fit:</label>
#>             <input id="volcanoPlot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-line.best.colour">Line of best fit colour:</label>
#>             <input id="volcanoPlot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="volcanoPlot-linear.model" type="checkbox" class="sw-switchInput" data-input-id="volcanoPlot-linear.model" data-on-text="On" data-off-text="Off" data-label-text="Linear model line" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-6227-12">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.linecolor">Axis line color</label>
#>             <input id="volcanoPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.linewidth-label" for="volcanoPlot-axis.linewidth">Axis line width</label>
#>             <input id="volcanoPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickfont.size-label" for="volcanoPlot-axis.tickfont.size">Tick label size</label>
#>             <input id="volcanoPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.tickfont.color">Tick label color</label>
#>             <input id="volcanoPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickfont.family-label" for="volcanoPlot-axis.tickfont.family">Tick label font</label>
#>             <div>
#>               <select id="volcanoPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="volcanoPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickangle.x-label" for="volcanoPlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="volcanoPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickangle.y-label" for="volcanoPlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="volcanoPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.ticks-label" for="volcanoPlot-axis.ticks">Tick position</label>
#>             <div>
#>               <select id="volcanoPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="volcanoPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.tickcolor">Tick mark color</label>
#>             <input id="volcanoPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.ticklen-label" for="volcanoPlot-axis.ticklen">Tick mark length</label>
#>             <input id="volcanoPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickwidth-label" for="volcanoPlot-axis.tickwidth">Tick mark width</label>
#>             <input id="volcanoPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <input id="volcanoPlot-auto.update" type="checkbox" class="sw-switchInput" data-input-id="volcanoPlot-auto.update" data-on-text="ON" data-off-text="OFF" data-label-text="Auto Update" data-label-width="auto" data-handle-width="auto" data-size="mini"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="volcanoPlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="volcanoPlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="volcanoPlot-download.type-label" for="volcanoPlot-download.type">Download Format</label>
#>       <div>
#>         <select id="volcanoPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="volcanoPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
