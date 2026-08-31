# Output UI components for the ComplexHeatmap module

This should be placed in the UI where the heatmap should be shown.
Unlike the plotly modules, the interactive output is provided by
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
which supplies its own resize and export controls.

## Usage

``` r
ComplexHeatmap_HeatmapOutputUI(id, resizable = TRUE, ...)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; accepted for signature parity with the other module output
  functions but ignored, since the InteractiveComplexHeatmap widget
  manages its own sizing.

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
  e.g. `layout`, `compact`, `width1`/`height1`,
  `title1`/`title2`/`title3`.

## Value

A Shiny UI object for the interactive heatmap.

## Details

This renders the original heatmap, the selected sub-heatmap, and the
click/brush info panel together as one widget, arranged per `layout`
(see
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)
for the available layout strings, e.g. `"(1-2)|3"`, `"1|(2-3)"`,
`"1-2-3"`).

Pass `compact = TRUE` for a smaller footprint (see the ["Compact mode"
article
section](https://jokergoo.github.io/InteractiveComplexHeatmap/articles/shiny_dev.html#compact-mode)):
the sub-heatmap panel is dropped entirely and the click/brush info
floats near the cursor instead of occupying its own static area —
equivalent to
`response = c(action, "brush-output"), output_ui_float = TRUE`, per
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)'s
own docs. `layout` has nothing left to arrange in compact mode, since
only one static panel remains. No server-side change is needed to turn
compact mode on or off.

To place the three components independently anywhere in a custom UI
(separate tabs, cards, columns, etc.), use
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
and
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)
instead of this function. Use one approach or the other, not both, for
the same module `id`. Compact mode is specific to this combined widget:
the separated pieces (`originalHeatmapOutput()`, `subHeatmapOutput()`,
`HeatmapInfoOutput()`, which back the three functions above) don't
accept a `compact` argument at all.

## See also

[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Default combined widget:
ComplexHeatmap_HeatmapOutputUI("heatmap")
#> <div class="container-fluid heatmap_Heatmap_widget">
#>   <div id="heatmap_Heatmap_heatmap_group">
#>     <h5>Original heatmap</h5>
#>     <div id="heatmap_Heatmap_heatmap_resize">
#>       <div class="shiny-plot-output html-fill-item" data-brush-clip="TRUE" data-brush-delay="300" data-brush-delay-type="debounce" data-brush-direction="xy" data-brush-fill="#9cf" data-brush-id="heatmap_Heatmap_heatmap_brush" data-brush-opacity="0.6" data-brush-reset-on-new="FALSE" data-brush-stroke="#f00" data-click-clip="TRUE" data-click-id="heatmap_Heatmap_heatmap_click" id="heatmap_Heatmap_heatmap" style="width:450px;height:350px;"></div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap').html('<p style="position:relative;top:50%;">Making heatmap, please wait...</p>');
#>          </script>
#>     </div>
#>     <script>
#>          $("#heatmap_Heatmap_heatmap_resize").css("width", $("#heatmap_Heatmap_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_heatmap_resize").css("height", $("#heatmap_Heatmap_heatmap").height() + 4);
#>      </script>
#>     <div id="heatmap_Heatmap_heatmap_control" style="display:none;">
#>       <div class="tabbable">
#>         <ul class="nav nav-tabs" data-tabsetid="2639">
#>           <li class="active">
#>             <a href="#tab-2639-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;"><i class='fa fa-search'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2639-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;"><i class='fa fa-brush'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2639-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2639-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>           </li>
#>         </ul>
#>         <div class="tab-content" data-tabsetid="2639">
#>           <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;" id="tab-2639-1">
#>             <div id="heatmap_Heatmap_tabs-search">
#>               <div style="width:250px;float:left;">
#>                 <div class="form-group shiny-input-container">
#>                   <label class="control-label" id="heatmap_Heatmap_keyword-label" for="heatmap_Heatmap_keyword">Keywords</label>
#>                   <input id="heatmap_Heatmap_keyword" type="text" class="shiny-input-text form-control" value="" placeholder="Multiple keywords separated by &#39;,&#39;" data-update-on="change"/>
#>                 </div>
#>               </div>
#>               <div style="width:150px;float:left;padding-top:20px;padding-left:4px;">
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_search_regexpr" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Regular expression</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div style="clear: both;"></div>
#>               <div id="heatmap_Heatmap_search_where" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_search_where-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_where-label" for="heatmap_Heatmap_search_where">Which dimension to search?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_search_where" value="1" checked="checked"/>
#>                     <span>on rows</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_search_where" value="2"/>
#>                     <span>on columns</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div id="heatmap_Heatmap_search_heatmaps" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_heatmaps-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_heatmaps-label" for="heatmap_Heatmap_search_heatmaps">Which heatmaps to search?</label>
#>                 <div class="shiny-options-group">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input type="checkbox" name="heatmap_Heatmap_search_heatmaps" value="" checked="checked"/>
#>                       <span>loading</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div id="heatmap_Heatmap_search_extend" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_extend-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_extend-label" for="heatmap_Heatmap_search_extend">Extend sub-heatmap to all heatmaps and annotations?</label>
#>                 <div class="shiny-options-group">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input type="checkbox" name="heatmap_Heatmap_search_extend" value="1"/>
#>                       <span>yes</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <button id="heatmap_Heatmap_search_action" type="button" class="btn btn-default action-button"><span class="action-label">Search</span></button>
#>             </div>
#>             <p style="display:none;">Search Heatmap</p>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;" id="tab-2639-2">
#>             <div id="heatmap_Heatmap_tabs-brush">
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
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_border_width-label" for="heatmap_Heatmap_color_pickers_border_width">Border width</label>
#>                 <div>
#>                   <select class="shiny-input-select form-control" id="heatmap_Heatmap_color_pickers_border_width"><option value="1" selected>1px</option>
#> <option value="2">2px</option>
#> <option value="3">3px</option></select>
#>                   <script type="application/json" data-for="heatmap_Heatmap_color_pickers_border_width" data-eval="[&quot;render&quot;]">{"render":"{\n\t\t\t\t\t\t\t\t\t\toption: function(item, escape) {\n\t\t\t\t\t\t\t\t\t\t\treturn '<div><hr style=\"border-top:' + item.value + 'px solid black;\"><\/div>'\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}","plugins":["selectize-plugin-a11y"]}</script>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_opacity-label" for="heatmap_Heatmap_color_pickers_opacity">Opacity</label>
#>                 <input class="js-range-slider" id="heatmap_Heatmap_color_pickers_opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>               </div>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-2639-3">
#>             <div id="heatmap_Heatmap_tabs-save-image">
#>               <div id="heatmap_Heatmap_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_heatmap_download_format-label">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_format-label" for="heatmap_Heatmap_heatmap_download_format">Which format?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="1" checked="checked"/>
#>                     <span>png</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="2"/>
#>                     <span>pdf</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="3"/>
#>                     <span>svg</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_width-label" for="heatmap_Heatmap_heatmap_download_image_width">Image width (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_height-label" for="heatmap_Heatmap_heatmap_download_image_height">Image height (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_heatmap_download_button" tabindex="-1" target="_blank">
#>                 <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>                 Save image
#>               </a>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-2639-4">
#>             <div id="heatmap_Heatmap_tabs-resize">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_width-label" for="heatmap_Heatmap_heatmap_input_width">Box width</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_height-label" for="heatmap_Heatmap_heatmap_input_height">Box height</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <button id="heatmap_Heatmap_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap_download_image_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_download_image_height').val($('#heatmap_Heatmap_heatmap').height());
#>              $('#heatmap_Heatmap_heatmap_input_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_input_height').val($('#heatmap_Heatmap_heatmap').height());
#>          </script>
#>     </div>
#>   </div>
#>   <div id="heatmap_Heatmap_sub_heatmap_group" style="width:400; height:350;">
#>     <h5>Selected sub-heatmap</h5>
#>     <div id="heatmap_Heatmap_sub_heatmap_resize">
#>       <div class="shiny-plot-output html-fill-item" id="heatmap_Heatmap_sub_heatmap" style="width:400px;height:350px;"></div>
#>     </div>
#>     <script>
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("width", $("#heatmap_Heatmap_sub_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("height", $("#heatmap_Heatmap_sub_heatmap").height() + 4);
#>      </script>
#>     <div id="heatmap_Heatmap_sub_heatmap_control" style="display:none;">
#>       <div class="tabbable">
#>         <ul class="nav nav-tabs" data-tabsetid="3469">
#>           <li class="active">
#>             <a href="#tab-3469-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;"><i class='fa fa-tasks'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-3469-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;"><i class='fa fa-table'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-3469-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-3469-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>           </li>
#>         </ul>
#>         <div class="tab-content" data-tabsetid="3469">
#>           <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;" id="tab-3469-1">
#>             <div id="heatmap_Heatmap_sub_tabs-setting">
#>               <div>
#>                 <div style="float:left;width:150px">
#>                   <div class="form-group shiny-input-container">
#>                     <div class="checkbox">
#>                       <label>
#>                         <input id="heatmap_Heatmap_show_row_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                         <span>Show row names</span>
#>                       </label>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <div style="float:left;width:160px">
#>                   <div class="form-group shiny-input-container">
#>                     <div class="checkbox">
#>                       <label>
#>                         <input id="heatmap_Heatmap_show_column_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                         <span>Show column names</span>
#>                       </label>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <div style="clear: both;"></div>
#>               </div>
#>               <div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_annotation_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show heatmap annotations</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_cell_fun_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show cell decorations</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_fill_figure_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Fill figure region</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <hr/>
#>               <div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_remove_empty_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Remove empty rows and columns</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 
#>                      <p style="padding-top:4px;">
#>                      Remove <input id="heatmap_Heatmap_post_remove" type="number" class="form-control" min="1" value="1" style="width:60px;display:inline;"/>
#>                      <span id="heatmap_Heatmap_post_remove_which">rows</span> from 
#>                      <select id="heatmap_Heatmap_post_remove_dimension" class="form-control" style="width:auto;display:inline;">
#>                      <option value="top" selected>top</option>
#>                      <option value="bottom">bottom</option>
#>                      <option value="left">left</option>
#>                      <option value="right">right</option></select>
#>                      </p>
#>                          
#>                 <button id="heatmap_Heatmap_post_remove_submit" type="button" class="btn btn-default action-button"><span class="action-label">Remove</span></button>
#>                 <button id="heatmap_Heatmap_post_remove_reset" type="button" class="btn btn-default action-button"><span class="action-label">Reset</span></button>
#>                 <script>
#>                              $('#heatmap_Heatmap_post_remove_dimension').change(function() {
#>                                  if($(this).val() == 1 || $(this).val() == 2) {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('rows');
#>                                  } else {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('columns');
#>                                  }
#>                              });
#>                          </script>
#>               </div>
#>               <hr/>
#>               <p style="max-width:300px;">Click the button below to turn the sub-heatmap into an interactive app.</p>
#>               <button id="heatmap_Heatmap_open_modal" type="button" class="btn btn-default action-button"><span class="action-label">Interactivate sub-heatmap</span></button>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;" id="tab-3469-2">
#>             <div id="heatmap_Heatmap_sub_tabs-table">
#>               <p>Export values in sub-heatmaps as a text table.</p>
#>               <button id="heatmap_Heatmap_open_table" type="button" class="btn btn-default action-button"><span class="action-label">Open table</span></button>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-3469-3">
#>             <div id="heatmap_Heatmap_sub_tabs-save-image">
#>               <div id="heatmap_Heatmap_sub_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_sub_heatmap_download_format-label">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_format-label" for="heatmap_Heatmap_sub_heatmap_download_format">Which format?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="1" checked="checked"/>
#>                     <span>png</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="2"/>
#>                     <span>pdf</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="3"/>
#>                     <span>svg</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_width-label" for="heatmap_Heatmap_sub_heatmap_download_image_width">Image width (in px)</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_height-label" for="heatmap_Heatmap_sub_heatmap_download_image_height">Image height (in px)</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_sub_heatmap_download_button" tabindex="-1" target="_blank">
#>                 <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>                 Save image
#>               </a>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-3469-4">
#>             <div id="heatmap_Heatmap_sub_tabs-resize">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_width-label" for="heatmap_Heatmap_sub_heatmap_input_width">Box width</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_height-label" for="heatmap_Heatmap_sub_heatmap_input_height">Box height</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <button id="heatmap_Heatmap_sub_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <script>
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>              $('#heatmap_Heatmap_sub_heatmap_input_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_input_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>          </script>
#>     </div>
#>   </div>
#>   <div id="heatmap_Heatmap_output_wrapper" style="width: 850px">
#>     <h5>Output</h5>
#>     <div id="heatmap_Heatmap_info" class="shiny-html-output"></div>
#>   </div>
#>   <style>
#>          .heatmap_Heatmap_widget #heatmap_Heatmap_heatmap_group {
#>              display:table-cell;
#>          }
#>          .heatmap_Heatmap_widget #heatmap_Heatmap_sub_heatmap_group {
#>              display:table-cell;
#>          }
#>      </style>
#> </div>
# Same widget, main heatmap on its own row above sub-heatmap + info:
ComplexHeatmap_HeatmapOutputUI("heatmap", layout = "1|(2-3)")
#> <div class="container-fluid heatmap_Heatmap_widget">
#>   <div id="heatmap_Heatmap_heatmap_group">
#>     <h5>Original heatmap</h5>
#>     <div id="heatmap_Heatmap_heatmap_resize">
#>       <div class="shiny-plot-output html-fill-item" data-brush-clip="TRUE" data-brush-delay="300" data-brush-delay-type="debounce" data-brush-direction="xy" data-brush-fill="#9cf" data-brush-id="heatmap_Heatmap_heatmap_brush" data-brush-opacity="0.6" data-brush-reset-on-new="FALSE" data-brush-stroke="#f00" data-click-clip="TRUE" data-click-id="heatmap_Heatmap_heatmap_click" id="heatmap_Heatmap_heatmap" style="width:800px;height:350px;"></div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap').html('<p style="position:relative;top:50%;">Making heatmap, please wait...</p>');
#>          </script>
#>     </div>
#>     <script>
#>          $("#heatmap_Heatmap_heatmap_resize").css("width", $("#heatmap_Heatmap_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_heatmap_resize").css("height", $("#heatmap_Heatmap_heatmap").height() + 4);
#>      </script>
#>     <div id="heatmap_Heatmap_heatmap_control" style="display:none;">
#>       <div class="tabbable">
#>         <ul class="nav nav-tabs" data-tabsetid="6413">
#>           <li class="active">
#>             <a href="#tab-6413-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;"><i class='fa fa-search'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-6413-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;"><i class='fa fa-brush'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-6413-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-6413-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>           </li>
#>         </ul>
#>         <div class="tab-content" data-tabsetid="6413">
#>           <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-search&#39;&gt;&lt;/i&gt;" id="tab-6413-1">
#>             <div id="heatmap_Heatmap_tabs-search">
#>               <div style="width:250px;float:left;">
#>                 <div class="form-group shiny-input-container">
#>                   <label class="control-label" id="heatmap_Heatmap_keyword-label" for="heatmap_Heatmap_keyword">Keywords</label>
#>                   <input id="heatmap_Heatmap_keyword" type="text" class="shiny-input-text form-control" value="" placeholder="Multiple keywords separated by &#39;,&#39;" data-update-on="change"/>
#>                 </div>
#>               </div>
#>               <div style="width:150px;float:left;padding-top:20px;padding-left:4px;">
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_search_regexpr" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Regular expression</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div style="clear: both;"></div>
#>               <div id="heatmap_Heatmap_search_where" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_search_where-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_where-label" for="heatmap_Heatmap_search_where">Which dimension to search?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_search_where" value="1" checked="checked"/>
#>                     <span>on rows</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_search_where" value="2"/>
#>                     <span>on columns</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div id="heatmap_Heatmap_search_heatmaps" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_heatmaps-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_heatmaps-label" for="heatmap_Heatmap_search_heatmaps">Which heatmaps to search?</label>
#>                 <div class="shiny-options-group">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input type="checkbox" name="heatmap_Heatmap_search_heatmaps" value="" checked="checked"/>
#>                       <span>loading</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div id="heatmap_Heatmap_search_extend" class="form-group shiny-input-checkboxgroup shiny-input-container" role="group" aria-labelledby="heatmap_Heatmap_search_extend-label">
#>                 <label class="control-label" id="heatmap_Heatmap_search_extend-label" for="heatmap_Heatmap_search_extend">Extend sub-heatmap to all heatmaps and annotations?</label>
#>                 <div class="shiny-options-group">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input type="checkbox" name="heatmap_Heatmap_search_extend" value="1"/>
#>                       <span>yes</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <button id="heatmap_Heatmap_search_action" type="button" class="btn btn-default action-button"><span class="action-label">Search</span></button>
#>             </div>
#>             <p style="display:none;">Search Heatmap</p>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;" id="tab-6413-2">
#>             <div id="heatmap_Heatmap_tabs-brush">
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
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_border_width-label" for="heatmap_Heatmap_color_pickers_border_width">Border width</label>
#>                 <div>
#>                   <select class="shiny-input-select form-control" id="heatmap_Heatmap_color_pickers_border_width"><option value="1" selected>1px</option>
#> <option value="2">2px</option>
#> <option value="3">3px</option></select>
#>                   <script type="application/json" data-for="heatmap_Heatmap_color_pickers_border_width" data-eval="[&quot;render&quot;]">{"render":"{\n\t\t\t\t\t\t\t\t\t\toption: function(item, escape) {\n\t\t\t\t\t\t\t\t\t\t\treturn '<div><hr style=\"border-top:' + item.value + 'px solid black;\"><\/div>'\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}","plugins":["selectize-plugin-a11y"]}</script>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_opacity-label" for="heatmap_Heatmap_color_pickers_opacity">Opacity</label>
#>                 <input class="js-range-slider" id="heatmap_Heatmap_color_pickers_opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>               </div>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-6413-3">
#>             <div id="heatmap_Heatmap_tabs-save-image">
#>               <div id="heatmap_Heatmap_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_heatmap_download_format-label">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_format-label" for="heatmap_Heatmap_heatmap_download_format">Which format?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="1" checked="checked"/>
#>                     <span>png</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="2"/>
#>                     <span>pdf</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="3"/>
#>                     <span>svg</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_width-label" for="heatmap_Heatmap_heatmap_download_image_width">Image width (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_height-label" for="heatmap_Heatmap_heatmap_download_image_height">Image height (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_heatmap_download_button" tabindex="-1" target="_blank">
#>                 <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>                 Save image
#>               </a>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-6413-4">
#>             <div id="heatmap_Heatmap_tabs-resize">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_width-label" for="heatmap_Heatmap_heatmap_input_width">Box width</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_height-label" for="heatmap_Heatmap_heatmap_input_height">Box height</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <button id="heatmap_Heatmap_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap_download_image_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_download_image_height').val($('#heatmap_Heatmap_heatmap').height());
#>              $('#heatmap_Heatmap_heatmap_input_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_input_height').val($('#heatmap_Heatmap_heatmap').height());
#>          </script>
#>     </div>
#>   </div>
#>   <div id="heatmap_Heatmap_sub_heatmap_group" style="width:400; height:350;">
#>     <h5>Selected sub-heatmap</h5>
#>     <div id="heatmap_Heatmap_sub_heatmap_resize">
#>       <div class="shiny-plot-output html-fill-item" id="heatmap_Heatmap_sub_heatmap" style="width:400px;height:350px;"></div>
#>     </div>
#>     <script>
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("width", $("#heatmap_Heatmap_sub_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("height", $("#heatmap_Heatmap_sub_heatmap").height() + 4);
#>      </script>
#>     <div id="heatmap_Heatmap_sub_heatmap_control" style="display:none;">
#>       <div class="tabbable">
#>         <ul class="nav nav-tabs" data-tabsetid="2656">
#>           <li class="active">
#>             <a href="#tab-2656-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;"><i class='fa fa-tasks'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2656-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;"><i class='fa fa-table'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2656-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-2656-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>           </li>
#>         </ul>
#>         <div class="tab-content" data-tabsetid="2656">
#>           <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;" id="tab-2656-1">
#>             <div id="heatmap_Heatmap_sub_tabs-setting">
#>               <div>
#>                 <div style="float:left;width:150px">
#>                   <div class="form-group shiny-input-container">
#>                     <div class="checkbox">
#>                       <label>
#>                         <input id="heatmap_Heatmap_show_row_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                         <span>Show row names</span>
#>                       </label>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <div style="float:left;width:160px">
#>                   <div class="form-group shiny-input-container">
#>                     <div class="checkbox">
#>                       <label>
#>                         <input id="heatmap_Heatmap_show_column_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                         <span>Show column names</span>
#>                       </label>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <div style="clear: both;"></div>
#>               </div>
#>               <div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_annotation_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show heatmap annotations</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_cell_fun_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show cell decorations</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_fill_figure_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Fill figure region</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <hr/>
#>               <div>
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_remove_empty_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                       <span>Remove empty rows and columns</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>                 
#>                      <p style="padding-top:4px;">
#>                      Remove <input id="heatmap_Heatmap_post_remove" type="number" class="form-control" min="1" value="1" style="width:60px;display:inline;"/>
#>                      <span id="heatmap_Heatmap_post_remove_which">rows</span> from 
#>                      <select id="heatmap_Heatmap_post_remove_dimension" class="form-control" style="width:auto;display:inline;">
#>                      <option value="top" selected>top</option>
#>                      <option value="bottom">bottom</option>
#>                      <option value="left">left</option>
#>                      <option value="right">right</option></select>
#>                      </p>
#>                          
#>                 <button id="heatmap_Heatmap_post_remove_submit" type="button" class="btn btn-default action-button"><span class="action-label">Remove</span></button>
#>                 <button id="heatmap_Heatmap_post_remove_reset" type="button" class="btn btn-default action-button"><span class="action-label">Reset</span></button>
#>                 <script>
#>                              $('#heatmap_Heatmap_post_remove_dimension').change(function() {
#>                                  if($(this).val() == 1 || $(this).val() == 2) {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('rows');
#>                                  } else {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('columns');
#>                                  }
#>                              });
#>                          </script>
#>               </div>
#>               <hr/>
#>               <p style="max-width:300px;">Click the button below to turn the sub-heatmap into an interactive app.</p>
#>               <button id="heatmap_Heatmap_open_modal" type="button" class="btn btn-default action-button"><span class="action-label">Interactivate sub-heatmap</span></button>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;" id="tab-2656-2">
#>             <div id="heatmap_Heatmap_sub_tabs-table">
#>               <p>Export values in sub-heatmaps as a text table.</p>
#>               <button id="heatmap_Heatmap_open_table" type="button" class="btn btn-default action-button"><span class="action-label">Open table</span></button>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-2656-3">
#>             <div id="heatmap_Heatmap_sub_tabs-save-image">
#>               <div id="heatmap_Heatmap_sub_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_sub_heatmap_download_format-label">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_format-label" for="heatmap_Heatmap_sub_heatmap_download_format">Which format?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="1" checked="checked"/>
#>                     <span>png</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="2"/>
#>                     <span>pdf</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="3"/>
#>                     <span>svg</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_width-label" for="heatmap_Heatmap_sub_heatmap_download_image_width">Image width (in px)</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_height-label" for="heatmap_Heatmap_sub_heatmap_download_image_height">Image height (in px)</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_sub_heatmap_download_button" tabindex="-1" target="_blank">
#>                 <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>                 Save image
#>               </a>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-2656-4">
#>             <div id="heatmap_Heatmap_sub_tabs-resize">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_width-label" for="heatmap_Heatmap_sub_heatmap_input_width">Box width</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_height-label" for="heatmap_Heatmap_sub_heatmap_input_height">Box height</label>
#>                 <input id="heatmap_Heatmap_sub_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <button id="heatmap_Heatmap_sub_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <script>
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>              $('#heatmap_Heatmap_sub_heatmap_input_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_input_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>          </script>
#>     </div>
#>   </div>
#>   <div id="heatmap_Heatmap_output_wrapper" style="width: 400px">
#>     <h5>Output</h5>
#>     <div id="heatmap_Heatmap_info" class="shiny-html-output"></div>
#>   </div>
#>   <style>
#>          .heatmap_Heatmap_widget #heatmap_Heatmap_sub_heatmap_group {
#>              display:table-cell;
#>          }
#>          .heatmap_Heatmap_widget #heatmap_Heatmap_output_wrapper {
#>              display:table-cell;
#>          }
#>      </style>
#> </div>
# Compact: no sub-heatmap panel, click/brush info floats near the cursor
ComplexHeatmap_HeatmapOutputUI("heatmap", compact = TRUE)
#> <div class="container-fluid heatmap_Heatmap_widget">
#>   <div id="heatmap_Heatmap_heatmap_group">
#>     <h5>Original heatmap</h5>
#>     <div id="heatmap_Heatmap_heatmap_resize">
#>       <div class="shiny-plot-output html-fill-item" data-brush-clip="TRUE" data-brush-delay="300" data-brush-delay-type="debounce" data-brush-direction="xy" data-brush-fill="#9cf" data-brush-id="heatmap_Heatmap_heatmap_brush" data-brush-opacity="0.6" data-brush-reset-on-new="FALSE" data-brush-stroke="#f00" data-click-clip="TRUE" data-click-id="heatmap_Heatmap_heatmap_click" id="heatmap_Heatmap_heatmap" style="width:450px;height:350px;"></div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap').html('<p style="position:relative;top:50%;">Making heatmap, please wait...</p>');
#>          </script>
#>     </div>
#>     <script>
#>          $("#heatmap_Heatmap_heatmap_resize").css("width", $("#heatmap_Heatmap_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_heatmap_resize").css("height", $("#heatmap_Heatmap_heatmap").height() + 4);
#>      </script>
#>     <div id="heatmap_Heatmap_heatmap_control" style="display:none;">
#>       <div class="tabbable">
#>         <ul class="nav nav-tabs" data-tabsetid="8874">
#>           <li class="active">
#>             <a href="#tab-8874-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;"><i class='fa fa-brush'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-8874-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>           </li>
#>           <li>
#>             <a href="#tab-8874-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>           </li>
#>         </ul>
#>         <div class="tab-content" data-tabsetid="8874">
#>           <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-brush&#39;&gt;&lt;/i&gt;" id="tab-8874-1">
#>             <div id="heatmap_Heatmap_tabs-brush">
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
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_border_width-label" for="heatmap_Heatmap_color_pickers_border_width">Border width</label>
#>                 <div>
#>                   <select class="shiny-input-select form-control" id="heatmap_Heatmap_color_pickers_border_width"><option value="1" selected>1px</option>
#> <option value="2">2px</option>
#> <option value="3">3px</option></select>
#>                   <script type="application/json" data-for="heatmap_Heatmap_color_pickers_border_width" data-eval="[&quot;render&quot;]">{"render":"{\n\t\t\t\t\t\t\t\t\t\toption: function(item, escape) {\n\t\t\t\t\t\t\t\t\t\t\treturn '<div><hr style=\"border-top:' + item.value + 'px solid black;\"><\/div>'\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}","plugins":["selectize-plugin-a11y"]}</script>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_color_pickers_opacity-label" for="heatmap_Heatmap_color_pickers_opacity">Opacity</label>
#>                 <input class="js-range-slider" id="heatmap_Heatmap_color_pickers_opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>               </div>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-8874-2">
#>             <div id="heatmap_Heatmap_tabs-save-image">
#>               <div id="heatmap_Heatmap_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_heatmap_download_format-label">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_format-label" for="heatmap_Heatmap_heatmap_download_format">Which format?</label>
#>                 <div class="shiny-options-group">
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="1" checked="checked"/>
#>                     <span>png</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="2"/>
#>                     <span>pdf</span>
#>                   </label>
#>                   <label class="radio-inline">
#>                     <input type="radio" name="heatmap_Heatmap_heatmap_download_format" value="3"/>
#>                     <span>svg</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_width-label" for="heatmap_Heatmap_heatmap_download_image_width">Image width (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_download_image_height-label" for="heatmap_Heatmap_heatmap_download_image_height">Image height (in px)</label>
#>                 <input id="heatmap_Heatmap_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_heatmap_download_button" tabindex="-1" target="_blank">
#>                 <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>                 Save image
#>               </a>
#>             </div>
#>           </div>
#>           <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-8874-3">
#>             <div id="heatmap_Heatmap_tabs-resize">
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_width-label" for="heatmap_Heatmap_heatmap_input_width">Box width</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <label class="control-label" id="heatmap_Heatmap_heatmap_input_height-label" for="heatmap_Heatmap_heatmap_input_height">Box height</label>
#>                 <input id="heatmap_Heatmap_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>               </div>
#>               <button id="heatmap_Heatmap_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <script>
#>              $('#heatmap_Heatmap_heatmap_download_image_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_download_image_height').val($('#heatmap_Heatmap_heatmap').height());
#>              $('#heatmap_Heatmap_heatmap_input_width').val($('#heatmap_Heatmap_heatmap').width());
#>              $('#heatmap_Heatmap_heatmap_input_height').val($('#heatmap_Heatmap_heatmap').height());
#>          </script>
#>     </div>
#>   </div>
#>   <div id="heatmap_Heatmap_output_wrapper" style="width: 400px">
#>     <h5>Output</h5>
#>     <div id="heatmap_Heatmap_info" class="shiny-html-output"></div>
#>     <script>$(document.body).append( $('#heatmap_Heatmap_output_wrapper').detach() );</script>
#>   </div>
#> </div>
```
