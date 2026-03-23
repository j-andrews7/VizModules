# Create standard tack UI for module inputs

Generates a consistent set of control buttons for VizModules that
includes Auto Update toggle, Update and Reset buttons, an optional Stats
download button, and the "Plotly" tab containing plot margin and shape
annotation controls.

## Usage

``` r
module_tack_ui(ns, defaults = NULL, has.stats = FALSE)
```

## Arguments

- ns:

  Namespace function from the module (e.g., `ns <- NS(id)`).

- defaults:

  Optional named list of default values. Reserved for future use.

- has.stats:

  Logical; if TRUE, include a "Save Stats" download button. Default
  FALSE.

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
#>         <input id="myModule-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="myModule-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="myModule-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="myModule-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#> </div>
```
