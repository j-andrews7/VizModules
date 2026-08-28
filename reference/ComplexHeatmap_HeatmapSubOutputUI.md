# Sub-heatmap output UI component for the ComplexHeatmap module

Renders *only* the selected sub-heatmap panel (the zoomed-in view of a
brushed/selected region), via
[`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html).
See
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md)
for how the separated output pieces fit together.

## Usage

``` r
ComplexHeatmap_HeatmapSubOutputUI(
  id,
  title = NULL,
  width = 400,
  height = 350,
  ...
)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used for
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)
  and any other output pieces for the same heatmap.

- title:

  Optional panel title. `NULL` (the default) omits the title.

- width, height:

  Panel dimensions in pixels.

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html).

## Value

A Shiny UI object for the sub-heatmap panel.

## See also

[`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
ComplexHeatmap_HeatmapSubOutputUI("heatmap", title = "Selected region")
#> <div id="heatmap_Heatmap_sub_heatmap_group" style="width:400; height:350;">
#>   <h5>Selected region</h5>
#>   <div id="heatmap_Heatmap_sub_heatmap_resize">
#>     <div class="shiny-plot-output html-fill-item" id="heatmap_Heatmap_sub_heatmap" style="width:400px;height:350px;"></div>
#>   </div>
#>   <script>
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("width", $("#heatmap_Heatmap_sub_heatmap").width() + 4);
#>          $("#heatmap_Heatmap_sub_heatmap_resize").css("height", $("#heatmap_Heatmap_sub_heatmap").height() + 4);
#>      </script>
#>   <div id="heatmap_Heatmap_sub_heatmap_control" style="display:none;">
#>     <div class="tabbable">
#>       <ul class="nav nav-tabs" data-tabsetid="7831">
#>         <li class="active">
#>           <a href="#tab-7831-1" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;"><i class='fa fa-tasks'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-7831-2" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;"><i class='fa fa-table'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-7831-3" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;"><i class='fa fa-images'></i></a>
#>         </li>
#>         <li>
#>           <a href="#tab-7831-4" data-toggle="tab" data-bs-toggle="tab" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;"><i class='fa fa-expand-arrows-alt'></i></a>
#>         </li>
#>       </ul>
#>       <div class="tab-content" data-tabsetid="7831">
#>         <div class="tab-pane active" data-value="&lt;i class=&#39;fa fa-tasks&#39;&gt;&lt;/i&gt;" id="tab-7831-1">
#>           <div id="heatmap_Heatmap_sub_tabs-setting">
#>             <div>
#>               <div style="float:left;width:150px">
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_row_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show row names</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div style="float:left;width:160px">
#>                 <div class="form-group shiny-input-container">
#>                   <div class="checkbox">
#>                     <label>
#>                       <input id="heatmap_Heatmap_show_column_names_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                       <span>Show column names</span>
#>                     </label>
#>                   </div>
#>                 </div>
#>               </div>
#>               <div style="clear: both;"></div>
#>             </div>
#>             <div>
#>               <div class="form-group shiny-input-container">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input id="heatmap_Heatmap_show_annotation_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                     <span>Show heatmap annotations</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input id="heatmap_Heatmap_show_cell_fun_checkbox" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                     <span>Show cell decorations</span>
#>                   </label>
#>                 </div>
#>               </div>
#>               <div class="form-group shiny-input-container">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input id="heatmap_Heatmap_fill_figure_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                     <span>Fill figure region</span>
#>                   </label>
#>                 </div>
#>               </div>
#>             </div>
#>             <hr/>
#>             <div>
#>               <div class="form-group shiny-input-container">
#>                 <div class="checkbox">
#>                   <label>
#>                     <input id="heatmap_Heatmap_remove_empty_checkbox" type="checkbox" class="shiny-input-checkbox"/>
#>                     <span>Remove empty rows and columns</span>
#>                   </label>
#>                 </div>
#>               </div>
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
#>               <button id="heatmap_Heatmap_post_remove_submit" type="button" class="btn btn-default action-button"><span class="action-label">Remove</span></button>
#>               <button id="heatmap_Heatmap_post_remove_reset" type="button" class="btn btn-default action-button"><span class="action-label">Reset</span></button>
#>               <script>
#>                              $('#heatmap_Heatmap_post_remove_dimension').change(function() {
#>                                  if($(this).val() == 1 || $(this).val() == 2) {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('rows');
#>                                  } else {
#>                                      $('#heatmap_Heatmap_post_remove_which').text('columns');
#>                                  }
#>                              });
#>                          </script>
#>             </div>
#>             <hr/>
#>             <p style="max-width:300px;">Click the button below to turn the sub-heatmap into an interactive app.</p>
#>             <button id="heatmap_Heatmap_open_modal" type="button" class="btn btn-default action-button"><span class="action-label">Interactivate sub-heatmap</span></button>
#>           </div>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-table&#39;&gt;&lt;/i&gt;" id="tab-7831-2">
#>           <div id="heatmap_Heatmap_sub_tabs-table">
#>             <p>Export values in sub-heatmaps as a text table.</p>
#>             <button id="heatmap_Heatmap_open_table" type="button" class="btn btn-default action-button"><span class="action-label">Open table</span></button>
#>           </div>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-images&#39;&gt;&lt;/i&gt;" id="tab-7831-3">
#>           <div id="heatmap_Heatmap_sub_tabs-save-image">
#>             <div id="heatmap_Heatmap_sub_heatmap_download_format" class="form-group shiny-input-radiogroup shiny-input-container shiny-input-container-inline" role="radiogroup" aria-labelledby="heatmap_Heatmap_sub_heatmap_download_format-label">
#>               <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_format-label" for="heatmap_Heatmap_sub_heatmap_download_format">Which format?</label>
#>               <div class="shiny-options-group">
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="1" checked="checked"/>
#>                   <span>png</span>
#>                 </label>
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="2"/>
#>                   <span>pdf</span>
#>                 </label>
#>                 <label class="radio-inline">
#>                   <input type="radio" name="heatmap_Heatmap_sub_heatmap_download_format" value="3"/>
#>                   <span>svg</span>
#>                 </label>
#>               </div>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_width-label" for="heatmap_Heatmap_sub_heatmap_download_image_width">Image width (in px)</label>
#>               <input id="heatmap_Heatmap_sub_heatmap_download_image_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_sub_heatmap_download_image_height-label" for="heatmap_Heatmap_sub_heatmap_download_image_height">Image height (in px)</label>
#>               <input id="heatmap_Heatmap_sub_heatmap_download_image_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <a aria-disabled="true" class="btn btn-default shiny-download-link disabled" download href="" id="heatmap_Heatmap_sub_heatmap_download_button" tabindex="-1" target="_blank">
#>               <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>               Save image
#>             </a>
#>           </div>
#>         </div>
#>         <div class="tab-pane" data-value="&lt;i class=&#39;fa fa-expand-arrows-alt&#39;&gt;&lt;/i&gt;" id="tab-7831-4">
#>           <div id="heatmap_Heatmap_sub_tabs-resize">
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_width-label" for="heatmap_Heatmap_sub_heatmap_input_width">Box width</label>
#>               <input id="heatmap_Heatmap_sub_heatmap_input_width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <div class="form-group shiny-input-container">
#>               <label class="control-label" id="heatmap_Heatmap_sub_heatmap_input_height-label" for="heatmap_Heatmap_sub_heatmap_input_height">Box height</label>
#>               <input id="heatmap_Heatmap_sub_heatmap_input_height" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>             </div>
#>             <button id="heatmap_Heatmap_sub_heatmap_input_size_button" type="button" class="btn btn-default action-button"><span class="action-label">Change image size</span></button>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <script>
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_download_image_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>              $('#heatmap_Heatmap_sub_heatmap_input_width').val($('#heatmap_Heatmap_sub_heatmap').width());
#>              $('#heatmap_Heatmap_sub_heatmap_input_height').val($('#heatmap_Heatmap_sub_heatmap').height());
#>          </script>
#>   </div>
#> </div>
```
