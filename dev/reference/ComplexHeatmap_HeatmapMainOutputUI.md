# Main heatmap output UI component for the ComplexHeatmap module

Renders *only* the original (main) interactive heatmap panel, via
[`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html).
Use this together with
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapSubOutputUI.md)
and/or
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)
to place the three interactive components independently in a custom
layout, instead of
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapOutputUI.md)'s
single combined widget. All pieces used for one heatmap must share the
same module `id` as the
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)
call — no server-side changes are needed to switch between the combined
and separated forms.

## Usage

``` r
ComplexHeatmap_HeatmapMainOutputUI(
  id,
  title = NULL,
  width = 450,
  height = 350,
  ...
)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used for
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)
  and any other output pieces for the same heatmap.

- title:

  Optional panel title. `NULL` (the default) omits the title.

- width, height:

  Panel dimensions in pixels.

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html),
  e.g. `action`, `response`, `brush_opt`.

## Value

A Shiny UI object for the main interactive heatmap panel.

## See also

[`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
ComplexHeatmap_HeatmapMainOutputUI("heatmap", title = "Heatmap")
#> <div id="heatmap_Heatmap_heatmap_group">
#>   <h5>Heatmap</h5>
#>   <div id="heatmap_Heatmap_heatmap_resize">
#>     <div class="shiny-plot-output html-fill-item" data-brush-clip="TRUE" data-brush-delay="300" data-brush-delay-type="debounce" data-brush-direction="xy" data-brush-fill="#9cf" data-brush-id="heatmap_Heatmap_heatmap_brush" data-brush-opacity="0.6" data-brush-reset-on-new="FALSE" data-brush-stroke="#f00" data-click-clip="TRUE" data-click-id="heatmap_Heatmap_heatmap_click" id="heatmap_Heatmap_heatmap" style="width:450px;height:350px;"></div>
#>     <script>
#>              $('#heatmap_Heatmap_heatmap').html('<p style="position:relative;top:50%;">Making heatmap, please wait...</p>');
#>          </script>
#>   </div>
#>   <script>
#>          $("#heatmap_Heatmap_heatmap_resize").css("width", $("#heatmap_Heatmap_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_heatmap_resize").css("height", $("#heatmap_Heatmap_heatmap").height() + 4);
#>      </script>
#>   <div id="heatmap_Heatmap_heatmap_control" style="display:none;">
#>     <div class="tabbable">
#>       <ul class="nav nav-tabs" data-tabsetid="8308">
#>         <li class="active">
#>           <a href="#tab-8308-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;"><i class='fa fa-search'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-8308-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;"><i class='fa fa-brush'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-8308-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-8308-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>         </li>
#>       </ul>
#>       <div class="tab-content" data-tabsetid="8308">
#>         <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;" id="tab-8308-1">
#>           <div id="heatmap_Heatmap_tabs-search">
#>             <div style="width:250px;float:left;">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_keyword-label" for="heatmap_Heatmap_keyword">Keywords</label>
#>                 <input id="heatmap_Heatmap_keyword" type="text" class="shiny-input-text form-control" value="" placeholder="Multiple keywords separated by &#39;,&#39;" data-update-on="change"/>
#>               </div>
#>             </div>
#>             <div style="width:150px;float:left;padding-top:20px;padding-left:4px;">
#>               <div class="form-group shiny-input-container">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input id="heatmap_Heatmap_search_regexpr" type="checkbox" class="shiny-input-checkbox"/>
#>                     <span>Regular expression</span>
#>                   </label>
#>                 </div>
#>               </div>
#>             </div>
#>             <div style="clear: both;"></div>
#>             <div id="heatmap_Heatmap_search_where" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_search_where-label">
#>               <label class="control-label" id="heatmap_Heatmap_search_where-label" for="heatmap_Heatmap_search_where">Which dimension to search?</label>
#>               <div class="shiny-options-group">
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_search_where" value="1" checked="checked"/>
#>                   <span>on rows</span>
#>                 </label>
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_search_where" value="2"/>
#>                   <span>on columns</span>
#>                 </label>
#>               </div>
#>             </div>
#>             <div id="heatmap_Heatmap_search_heatmaps" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_heatmaps-label">
#>               <label class="control-label" id="heatmap_Heatmap_search_heatmaps-label" for="heatmap_Heatmap_search_heatmaps">Which heatmaps to search?</label>
#>               <div class="shiny-options-group">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input type="checkbox" name="heatmap_Heatmap_search_heatmaps" value="" checked="checked"/>
#>                     <span>loading</span>
#>                   </label>
#>                 </div>
#>               </div>
#>             </div>
#>             <div id="heatmap_Heatmap_search_extend" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_extend-label">
#>               <label class="control-label" id="heatmap_Heatmap_search_extend-label" for="heatmap_Heatmap_search_extend">Extend sub-heatmap to all heatmaps and annotations?</label>
#>               <div class="shiny-options-group">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input type="checkbox" name="heatmap_Heatmap_search_extend" value="1"/>
#>                     <span>yes</span>
#>                   </label>
#>                 </div>
#>               </div>
#>             </div>
#>             <button id="heatmap_Heatmap_search_action" type="button" class="btn btn-default action-button"><span class="action-label">Search</span></button>
#>           </div>
#>           <p style="display:none;">Search Heatmap</p>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;" id="tab-8308-2">
#>           <div id="heatmap_Heatmap_tabs-brush">
#>             
#>                              <div class="form-group shiny-input-container" style="float:left; width:120px;">
#>                              <label>Brush border</label>
#>                              <div id="heatmap_Heatmap_color_pickers_border"></div>
#>                              </div>
#>                              <div class="form-group shiny-input-container" style="float:left; width:120px;">
#>                              <label>Brush fill</label>
#>                              <div id="heatmap_Heatmap_color_pickers_fill"></div>
#>                              </div>
#>                              <div style="clear:both;"></div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_color_pickers_border_width-label" for="heatmap_Heatmap_color_pickers_border_width">Border width</label>
#>               <div>
#>                 <select class="shiny-input-select form-control" id="heatmap_Heatmap_color_pickers_border_width"><option value="1" selected>1px</option>
#> <option value="2">2px</option>
#> <option value="3">3px</option></select>
#>                 <script type="application/json" data-for="heatmap_Heatmap_color_pickers_border_width" data-eval="[&quot;render&quot;]">{"render":"{\n\t\t\t\t\t\t\t\t\t\toption: function(item, escape) {\n\t\t\t\t\t\t\t\t\t\t\treturn '<div><hr style=\"border-top:' + item.value + 'px solid black;\"><\/div>'\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}","plugins":["selectize-plugin-a11y"]}</script>
#>               </div>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_color_pickers_opacity-label" for="heatmap_Heatmap_color_pickers_opacity">Opacity</label>
#>               <input class="js-range-slider" id="heatmap_Heatmap_color_pickers_opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-8308-3">
#>           <div id="heatmap_Heatmap_tabs-save-image">
#>             <div id="heatmap_Heatmap_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_heatmap_download_format-label">
#>               <label class="control-label" id="heatmap_Heatmap_heatmap_download_format-label" for="heatmap_Heatmap_heatmap_download_format">Which format?</label>
#>               <div class="shiny-options-group">
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="1" checked="checked"/>
#>                   <span>png</span>
#>                 </label>
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="2"/>
#>                   <span>pdf</span>
#>                 </label>
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="3"/>
#>                   <span>svg</span>
#>                 </label>
#>               </div>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_width-label" for="heatmap_Heatmap_heatmap_download_image_width">Image width (in px)</label>
#>               <input id="heatmap_Heatmap_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_height-label" for="heatmap_Heatmap_heatmap_download_image_height">Image height (in px)</label>
#>               <input id="heatmap_Heatmap_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_heatmap_download_button" tabindex="-1" target="_blank">
#>               <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>               Save image
#>             </a>
#>           </div>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-8308-4">
#>           <div id="heatmap_Heatmap_tabs-resize">
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_heatmap_input_width-label" for="heatmap_Heatmap_heatmap_input_width">Box width</label>
#>               <input id="heatmap_Heatmap_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_heatmap_input_height-label" for="heatmap_Heatmap_heatmap_input_height">Box height</label>
#>               <input id="heatmap_Heatmap_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <button id="heatmap_Heatmap_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <script>
#>              $('#heatmap_Heatmap_heatmap_download_image_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_download_image_height').val($('#heatmap_Heatmap_heatmap').height());
#>              $('#heatmap_Heatmap_heatmap_input_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_input_height').val($('#heatmap_Heatmap_heatmap').height());
#>          </script>
#>   </div>
#> </div>
```
