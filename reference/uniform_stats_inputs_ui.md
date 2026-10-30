# Generate uniform Stats input UI

Creates a standardized tagList of statistical testing inputs for use
across plot modules that support pairwise comparisons (BoxPlot, yPlot,
freqPlot).

## Usage

``` r
uniform_stats_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the stats input UI elements.

## See also

[`reset_stats_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_stats_inputs.md),
[`default_stat_pairs()`](https://j-andrews7.github.io/VizModules/reference/default_stat_pairs.md),
[`stat_bracket_headroom()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_headroom.md),
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md),
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_stat_annotations.md)

## Author

Jared Andrews

## Examples

``` r
uniform_stats_inputs_ui(shiny::NS("stats"))
#> <div class="form-group shiny-input-container" id="tipify1077446">
#>   <div class="material-switch">
#>     <label for="stats-stats.enabled" style="padding-right: 10px;">Enable Stats</label>
#>     <input id="stats-stats.enabled" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="stats-stats.enabled"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1077446', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle pairwise statistical testing with bracket annotations on the plot'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify9142980">
#>   <label class="control-label" id="stats-stat.test-label" for="stats-stat.test">Test</label>
#>   <div id="stats-stat.test" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="stats-stat.test">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Wilcoxon","t-test","Kruskal-Wallis","ANOVA"],"value":["wilcox.test","t.test","kruskal.test","anova"]}},"config":{"multiple":false,"search":false,"selectedValue":"wilcox.test","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9142980', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Statistical test for comparisons. Wilcoxon and t-test perform pairwise comparisons. Kruskal-Wallis and ANOVA perform omnibus tests.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify1438035">
#>   <label class="control-label" id="stats-stat.p.adjust-label" for="stats-stat.p.adjust">P-value Adjustment</label>
#>   <div id="stats-stat.p.adjust" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="stats-stat.p.adjust">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"],"value":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"holm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1438035', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Method for multiple testing correction applied to all p-values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify2651872">
#>   <label class="control-label" id="stats-stat.display-label" for="stats-stat.display">Display</label>
#>   <div id="stats-stat.display" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="stats-stat.display">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Adjusted P-value","P-value","Symbols"],"value":["p.adj","p.value","symbol"]}},"config":{"multiple":false,"search":false,"selectedValue":"p.adj","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2651872', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1484631">
#>   <label class="control-label" id="stats-stat.sig.threshold-label" for="stats-stat.sig.threshold">Significance Threshold</label>
#>   <input id="stats-stat.sig.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1484631', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '(Adjusted, if applied) P-values above this threshold are labeled &#39;ns&#39;. Also used as the boundary for the &#39;*&#39; significance symbol.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4142487">
#>   <div class="material-switch">
#>     <label for="stats-stat.hide.ns" style="padding-right: 10px;">Hide Non-Significant</label>
#>     <input id="stats-stat.hide.ns" type="checkbox" checked="checked"/>
#>     <label class="switch label-success bg-success" for="stats-stat.hide.ns"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4142487', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hide comparison brackets where the adjusted p-value exceeds the significance threshold'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1089497">
#>   <div class="material-switch">
#>     <label for="stats-stat.paired" style="padding-right: 10px;">Paired Test</label>
#>     <input id="stats-stat.paired" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="stats-stat.paired"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1089497', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform paired tests (Wilcoxon signed-rank or paired t-test). Each group must have the same number of observations in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify2470780">
#>   <label class="control-label" id="stats-stat.pairs-label" for="stats-stat.pairs">Comparisons</label>
#>   <div id="stats-stat.pairs" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>     <script type="application/json" data-for="stats-stat.pairs">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2470780', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select specific pairwise comparisons to display. If empty, all possible pairs are tested.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5906431">
#>   <label class="control-label" for="stats-stat.line.color">Line Color</label>
#>   <input id="stats-stat.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5906431', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for bracket lines and annotation text'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3282673">
#>   <label class="control-label" id="stats-stat.line.width-label" for="stats-stat.line.width">Line Width</label>
#>   <input id="stats-stat.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="50" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3282673', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of bracket lines in pixels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify7329705">
#>   <label class="control-label" id="stats-stat.bracket.style-label" for="stats-stat.bracket.style">Bracket Style</label>
#>   <div id="stats-stat.bracket.style" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="stats-stat.bracket.style">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Capped","Flat"],"value":["capped","flat"]}},"config":{"multiple":false,"search":false,"selectedValue":"capped","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7329705', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7279052">
#>   <label class="control-label" id="stats-stat.step.increase-label" for="stats-stat.step.increase">Bracket Spacing</label>
#>   <input id="stats-stat.step.increase" type="number" class="shiny-input-number form-control" value="0.06" data-update-on="change" min="0.01" max="0.3" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7279052', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range used as vertical spacing between successive bracket levels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5457234">
#>   <label class="control-label" id="stats-stat.text.bump-label" for="stats-stat.text.bump">Text Offset</label>
#>   <input id="stats-stat.text.bump" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0.005" max="0.2" step="0.005"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5457234', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range for vertical distance between the bracket line and annotation text'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7337463">
#>   <label class="control-label" id="stats-stat.bracket.inset-label" for="stats-stat.bracket.inset">Bracket Inset</label>
#>   <input id="stats-stat.bracket.inset" type="number" class="shiny-input-number form-control" value="0.025" data-update-on="change" min="0" max="0.2" step="0.005"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7337463', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9333583">
#>   <div class="material-switch">
#>     <label for="stats-stat.per.facet" style="padding-right: 10px;">Per Facet Panel</label>
#>     <input id="stats-stat.per.facet" type="checkbox" checked="checked"/>
#>     <label class="switch label-success bg-success" for="stats-stat.per.facet"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9333583', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.'})}, 500)});</script>
```
