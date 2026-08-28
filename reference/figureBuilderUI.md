# UI component for the Figure Builder module

Renders the full multi-panel **Figure Builder** interface (sidebar
controls plus the free-form A4 canvas) as a namespaced Shiny module.
Place this in the UI where you want the builder to appear, using an `id`
that matches the one passed to
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md).

## Usage

``` r
figureBuilderUI(id, title = "VizModules Figure Builder")
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` given to
  [`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md).

- title:

  A character string used as the header shown above the builder
  (default: `"VizModules Figure Builder"`). Pass `NULL` to omit the
  header, which is useful when the host page supplies its own title.

## Value

A Shiny `tagList` containing the Figure Builder UI.

## Details

Unlike
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)
(which returns a complete, standalone app), this function returns a
`tagList` you can drop into any page, so the builder can be embedded
alongside other content and instantiated more than once (each instance
keeps its own namespace, canvas, and downloads).

The returned UI bundles the JavaScript and CSS the canvas needs, and
calls
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html),
so no extra setup is required in the host app.

## See also

[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md),
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
figureBuilderUI("figure_builder")
#> <h2>VizModules Figure Builder</h2>
#> <div class="row">
#>   <div class="col-sm-4">
#>     <form class="well" role="complementary">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <button class="btn btn-default action-button btn-primary btn-block" id="figure_builder-pb_add" type="button"><span class="action-icon"><i class="fas fa-plus" role="presentation" aria-label="plus icon"></i></span><span class="action-label">Add Plot</span></button>
#>         </div>
#>         <div class="col-sm-6">
#>           <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-primary btn-block" download href="" id="figure_builder-download.source" tabindex="-1" target="_blank">
#>             <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>             Source Data &amp; Plots
#>           </a>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('figure_builder-download.source', 'tooltip', {'container': 'body', 'placement': 'bottom', 'trigger': 'hover', 'title': 'Download a ZIP of the source data, HTML plots, and statistics (if applied) for all plots on the canvas.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <span class="help-block">
#>         Add plots, then drag them by their title bar and resize
#>         from the bottom-right corner.
#>       </span>
#>       <details class="pb-details">
#>         <summary>Load Data</summary>
#>         <span class="help-block">
#>           Upload a CSV, TSV, TXT, or RDS file to make it available
#>           as a dataset when adding plots.
#>         </span>
#>         <div class="shiny-split-layout">
#>           <div style="width: 50.000%;">
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="figure_builder-pb_data_name-label" for="figure_builder-pb_data_name">Dataset name (optional):</label>
#>               <input id="figure_builder-pb_data_name" type="text" class="shiny-input-text form-control" value="" placeholder="Defaults to the file name" data-update-on="change"/>
#>             </div>
#>           </div>
#>           <div style="width: 50.000%;">
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="figure_builder-pb_data_file-label" for="figure_builder-pb_data_file">File:</label>
#>               <div class="input-group">
#>                 <label class="input-group-btn input-group-prepend">
#>                   <span class="btn btn-default btn-file">
#>                     Browse...
#>                     <input id="figure_builder-pb_data_file" class="shiny-input-file" name="figure_builder-pb_data_file" type="file" style="position: absolute !important; top: -99999px !important; left: -99999px !important;" accept=".csv,.tsv,.txt,.rds,.RDS"/>
#>                   </span>
#>                 </label>
#>                 <input type="text" class="form-control" placeholder="No file selected" readonly="readonly"/>
#>               </div>
#>               <div id="figure_builder-pb_data_file_progress" class="progress active shiny-file-input-progress">
#>                 <div class="progress-bar"></div>
#>               </div>
#>             </div>
#>           </div>
#>         </div>
#>         <button id="figure_builder-pb_data_add" type="button" class="btn btn-default action-button"><span class="action-icon"><i class="fas fa-upload" role="presentation" aria-label="upload icon"></i></span><span class="action-label">Add dataset</span></button>
#>       </details>
#>       <hr/>
#>       <h3>Canvas</h3>
#>       <div class="shiny-split-layout">
#>         <div style="width: 50.000%;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="figure_builder-pb_orientation-label" for="figure_builder-pb_orientation">Page size:</label>
#>             <div id="figure_builder-pb_orientation" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="figure_builder-pb_orientation">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["A4 portrait","A4 landscape"],"value":["portrait","landscape"]}},"config":{"multiple":false,"search":false,"selectedValue":"portrait","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div style="width: 50.000%;">
#>           <div class="form-group shiny-input-container pb-label-case">
#>             <label class="control-label" id="figure_builder-pb_label_case-label" for="figure_builder-pb_label_case">Panel labels:</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="figure_builder-pb_label_case"><option value="upper" selected>Uppercase (A, B, C)</option>
#> <option value="none">None</option>
#> <option value="lower">Lowercase (a, b, c)</option></select>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <button id="figure_builder-pb_download" type="button" class="btn btn-success btn-block pb-download-svg">Download Full Figure (SVG)</button>
#>       <hr/>
#>       <h3>Plot Controls</h3>
#>       <div class="form-group shiny-input-container" style="width:100%;">
#>         <label class="control-label" id="figure_builder-pb_controls_select-label" for="figure_builder-pb_controls_select">Show controls for:</label>
#>         <div id="figure_builder-pb_controls_select" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>           <script type="application/json" data-for="figure_builder-pb_controls_select">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":false,"search":false,"hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>         </div>
#>       </div>
#>       <div id="figure_builder-pb_controls_container">
#>         <div class="pb-empty-hint" id="figure_builder-pb_controls_empty">Add a plot to configure its controls here.</div>
#>       </div>
#>     </form>
#>   </div>
#>   <div class="col-sm-8" role="main">
#>     <div id="figure_builder-pb_canvas_scroll" class="pb-canvas-scroll">
#>       <div id="figure_builder-pb_canvas" class="pb-canvas a4-portrait">
#>         <div class="pb-empty-hint" id="figure_builder-pb_canvas_empty">No plots yet. Click "Add Plot" to begin.</div>
#>       </div>
#>     </div>
#>     <hr/>
#>     <h4>Data Filtering</h4>
#>     <p style="color: grey; font-size: 12px;">
#>       Filtering a plot's table subsets only that plot's data. 
#>       Specific numeric filters can be applied by entering a range like '1 ... 10'.
#>     </p>
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="figure_builder-pb_table_select-label" for="figure_builder-pb_table_select">Show table for:</label>
#>       <div id="figure_builder-pb_table_select" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>         <script type="application/json" data-for="figure_builder-pb_table_select">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":false,"search":false,"hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>       </div>
#>     </div>
#>     <div id="figure_builder-pb_table_container">
#>       <div class="pb-empty-hint" id="figure_builder-pb_table_empty">Add a plot to view and filter its data here.</div>
#>     </div>
#>   </div>
#> </div>
```
