# Create standard tack UI for module inputs

Generates a consistent set of control buttons for VizModules that
includes Auto Update toggle, Update and Reset buttons, and a full source
download button (self-contained HTML of the plot, source data, and
statistics).

## Usage

``` r
module_tack_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  Namespace function from the module (e.g., `ns <- NS(id)`).

- defaults:

  Optional named list of default values. Reserved for future use.

## Value

A Shiny tagList containing the standard control buttons and inputs.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
library(shiny)
ns <- NS("myModule")
module_tack_ui(ns)
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="myModule-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="myModule-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="myModule-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="myModule-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="myModule-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="myModule-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('myModule-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
