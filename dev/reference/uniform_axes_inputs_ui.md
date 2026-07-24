# Generate uniform Axes input UI

Creates a standardized tagList of axis-related inputs for use across
plot modules.

## Usage

``` r
uniform_axes_inputs_ui(
  ns,
  defaults = NULL,
  include.rotate = FALSE,
  include.flip = FALSE
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.rotate:

  Logical; whether to include the "Rotate" input for swapping x and y
  axes (e.g., horizontal bar plots). Default is FALSE.

- include.flip:

  Logical; whether to include the "Flip" input for flipping the axis.
  Default is FALSE.

## Value

A `tagList` containing the axis input UI elements.

## Author

Jared Andrews Jacob Martin

## Examples

``` r
ns <- shiny::NS("plot")
uniform_axes_inputs_ui(ns)
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.family-label" for="plot-title.font.family">Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-title.font.color">Title Color</label>
#>   <input id="plot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.size-label" for="plot-title.font.size">Title Size</label>
#>   <input id="plot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.horizontal.position-label" for="plot-axis.title.horizontal.position">Title position</label>
#>   <input id="plot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.size-label" for="plot-axis.title.font.size">Axis Title Size</label>
#>   <input id="plot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.title.font.color">Axis Title Color</label>
#>   <input id="plot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.family-label" for="plot-axis.title.font.family">Axis Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Mirror Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show X Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Y Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-grid.color">Gridline Color</label>
#>   <input id="plot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.linecolor">Axis Line Color</label>
#>   <input id="plot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.linewidth-label" for="plot-axis.linewidth">Axis Line Width</label>
#>   <input id="plot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.size-label" for="plot-axis.tickfont.size">Tick Label Size</label>
#>   <input id="plot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickfont.color">Tick Label Color</label>
#>   <input id="plot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.family-label" for="plot-axis.tickfont.family">Tick Label Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.x-label" for="plot-axis.tickangle.x">X Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.y-label" for="plot-axis.tickangle.y">Y Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticks-label" for="plot-axis.ticks">Tick Position</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickcolor">Tick Mark Color</label>
#>   <input id="plot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticklen-label" for="plot-axis.ticklen">Tick Mark Length</label>
#>   <input id="plot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickwidth-label" for="plot-axis.tickwidth">Tick Mark Width</label>
#>   <input id="plot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.size-label" for="plot-facet.title.font.size">Facet Subplot Title Size</label>
#>   <input id="plot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-facet.title.font.color">Facet Title Color</label>
#>   <input id="plot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.family-label" for="plot-facet.title.font.family">Facet Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
uniform_axes_inputs_ui(ns, include.rotate = TRUE, include.flip = TRUE)
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>     <input id="plot-rotate" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-rotate"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-flip.x" style="padding-right: 10px;">Flip X Axis</label>
#>     <input id="plot-flip.x" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-flip.x"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-flip.y" style="padding-right: 10px;">Flip Y Axis</label>
#>     <input id="plot-flip.y" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-flip.y"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.family-label" for="plot-title.font.family">Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-title.font.color">Title Color</label>
#>   <input id="plot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.size-label" for="plot-title.font.size">Title Size</label>
#>   <input id="plot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.horizontal.position-label" for="plot-axis.title.horizontal.position">Title position</label>
#>   <input id="plot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.size-label" for="plot-axis.title.font.size">Axis Title Size</label>
#>   <input id="plot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.title.font.color">Axis Title Color</label>
#>   <input id="plot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.family-label" for="plot-axis.title.font.family">Axis Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Mirror Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show X Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Y Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-grid.color">Gridline Color</label>
#>   <input id="plot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.linecolor">Axis Line Color</label>
#>   <input id="plot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.linewidth-label" for="plot-axis.linewidth">Axis Line Width</label>
#>   <input id="plot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.size-label" for="plot-axis.tickfont.size">Tick Label Size</label>
#>   <input id="plot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickfont.color">Tick Label Color</label>
#>   <input id="plot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.family-label" for="plot-axis.tickfont.family">Tick Label Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.x-label" for="plot-axis.tickangle.x">X Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.y-label" for="plot-axis.tickangle.y">Y Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticks-label" for="plot-axis.ticks">Tick Position</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickcolor">Tick Mark Color</label>
#>   <input id="plot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticklen-label" for="plot-axis.ticklen">Tick Mark Length</label>
#>   <input id="plot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickwidth-label" for="plot-axis.tickwidth">Tick Mark Width</label>
#>   <input id="plot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.size-label" for="plot-facet.title.font.size">Facet Subplot Title Size</label>
#>   <input id="plot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-facet.title.font.color">Facet Title Color</label>
#>   <input id="plot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.family-label" for="plot-facet.title.font.family">Facet Title Font</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>   </div>
#> </div>
```
