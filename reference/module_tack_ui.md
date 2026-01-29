# Create standard tack UI for module inputs

Generates a consistent set of control buttons for VizModules that
includes Auto Update toggle, Update button, Reset button, Download
Interactive Plot button, and Download Format selector. This ensures all
modules have a uniform interface.

## Usage

``` r
module_tack_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  Namespace function from the module (e.g., `ns <- NS(id)`).

- defaults:

  Optional named list of default values. Currently supports:

  - `download.format` - Default download format ("svg" or "png"),
    defaults to "svg"

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
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="myModule-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="myModule-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="myModule-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="myModule-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="myModule-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="myModule-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="myModule-download.format-label" for="myModule-download.format">Download Format</label>
#>       <div>
#>         <select id="myModule-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="myModule-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>

# With custom defaults
module_tack_ui(ns, defaults = list(download.format = "png"))
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="myModule-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="myModule-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="myModule-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="myModule-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="myModule-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="myModule-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="myModule-download.format-label" for="myModule-download.format">Download Format</label>
#>       <div>
#>         <select id="myModule-download.format" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="myModule-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
