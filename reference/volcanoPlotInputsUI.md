# Input UI components for the volcanoPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`volcanoPlotServer()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotServer.md)
and
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotOutputUI.md)
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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. This module wraps
[`dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md)
and adds volcano-specific controls.

Additional inputs specific to volcano plots are added to control
significance thresholds and colors:

- `sig.thresh`: Significance threshold (default 0.05)

- `fc.thresh`: Log2 fold change threshold (default 0)

- `volcano.colors`: A multiColorPicker for Up/Down/n.s. group colors
  (defaults: Up="red", Down="blue", n.s.="lightgray")

## Plot parameters and defaults

The following parameters can be accessed via UI inputs and/or the
`defaults` argument:

- `x.by` - X-axis variable (auto-detected from effect size columns:
  log2FoldChange, LFC, logFC)

- `y.by` - Y-axis variable (auto-detected from significance columns:
  padj, pval, adj.p, svalue, FDR, p)

- `color.by` - Coloring variable (default: "group", auto-generated from
  thresholds)

- `y.adj.fxn` - Y adjustment function (default: "neg_log10" for
  -log10(p-value))

- `show.others` - Show others (default: FALSE)

- `hover.data` - Hover data columns (default: c("symbol", x.by, y.by))

- `sig.thresh` - Significance threshold (UI: "Significance Threshold",
  default: 0.05)

- `fc.thresh` - Log2 fold change threshold (UI: "LFC Threshold (log2)",
  default: 0)

- All other
  [`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
  parameters are also available via the wrapped UI

## Parameters controlling additional functionality

The following parameters implementing volcano-specific features are also
available:

- `volcano.colors` - Named color vector for Up/Down/n.s. groups (UI:
  "Group Colors" multiColorPicker)

- `group` - Auto-generated grouping column based on sig.thresh and
  fc.thresh

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotServer.md),
[`volcanoPlotApp()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
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
#>     <div class="multi-color-picker shiny-input-container form-group is-compact " id="volcanoPlot-volcano.colors" data-palettes="{&quot;dittoColors&quot;:[&quot;#E69F00&quot;,&quot;#56B4E9&quot;,&quot;#009E73&quot;,&quot;#F0E442&quot;,&quot;#0072B2&quot;,&quot;#D55E00&quot;,&quot;#CC79A7&quot;,&quot;#666666&quot;,&quot;#AD7700&quot;,&quot;#1C91D4&quot;,&quot;#007756&quot;,&quot;#D5C711&quot;,&quot;#005685&quot;,&quot;#A04700&quot;,&quot;#B14380&quot;,&quot;#4D4D4D&quot;],&quot;dittoColors_full&quot;:[&quot;#E69F00&quot;,&quot;#56B4E9&quot;,&quot;#009E73&quot;,&quot;#F0E442&quot;,&quot;#0072B2&quot;,&quot;#D55E00&quot;,&quot;#CC79A7&quot;,&quot;#666666&quot;,&quot;#AD7700&quot;,&quot;#1C91D4&quot;,&quot;#007756&quot;,&quot;#D5C711&quot;,&quot;#005685&quot;,&quot;#A04700&quot;,&quot;#B14380&quot;,&quot;#4D4D4D&quot;,&quot;#FFBE2D&quot;,&quot;#80C7EF&quot;,&quot;#00F6B3&quot;,&quot;#F4EB71&quot;,&quot;#06A5FF&quot;,&quot;#FF8320&quot;,&quot;#D99BBD&quot;,&quot;#8C8C8C&quot;,&quot;#FFCB57&quot;,&quot;#9AD2F2&quot;,&quot;#2CFFC6&quot;,&quot;#F6EF8E&quot;,&quot;#38B7FF&quot;,&quot;#FF9B4D&quot;,&quot;#E0AFCA&quot;,&quot;#A3A3A3&quot;],&quot;ggplot2&quot;:[&quot;#F8766D&quot;,&quot;#E68613&quot;,&quot;#CD9600&quot;,&quot;#ABA300&quot;,&quot;#7CAE00&quot;,&quot;#0BB702&quot;,&quot;#00BE67&quot;,&quot;#00C19A&quot;,&quot;#00BFC4&quot;,&quot;#00B8E7&quot;,&quot;#00A9FF&quot;,&quot;#8494FF&quot;,&quot;#C77CFF&quot;,&quot;#ED68ED&quot;,&quot;#FF61CC&quot;,&quot;#FF68A1&quot;],&quot;viridis&quot;:[&quot;#440154&quot;,&quot;#482173&quot;,&quot;#433E85&quot;,&quot;#38598C&quot;,&quot;#2D708E&quot;,&quot;#25858E&quot;,&quot;#1E9B8A&quot;,&quot;#2BB07F&quot;,&quot;#51C56A&quot;,&quot;#85D54A&quot;,&quot;#C2DF23&quot;,&quot;#FDE725&quot;],&quot;magma&quot;:[&quot;#000004&quot;,&quot;#120D32&quot;,&quot;#331068&quot;,&quot;#5A167E&quot;,&quot;#7D2482&quot;,&quot;#A3307E&quot;,&quot;#C83E73&quot;,&quot;#E95562&quot;,&quot;#F97C5D&quot;,&quot;#FEA873&quot;,&quot;#FED395&quot;,&quot;#FCFDBF&quot;],&quot;inferno&quot;:[&quot;#000004&quot;,&quot;#140B35&quot;,&quot;#3A0963&quot;,&quot;#60136E&quot;,&quot;#85216B&quot;,&quot;#A92E5E&quot;,&quot;#CB4149&quot;,&quot;#E65D2F&quot;,&quot;#F78311&quot;,&quot;#FCAD12&quot;,&quot;#F5DB4B&quot;,&quot;#FCFFA4&quot;],&quot;plasma&quot;:[&quot;#0D0887&quot;,&quot;#3E049C&quot;,&quot;#6300A7&quot;,&quot;#8707A6&quot;,&quot;#A62098&quot;,&quot;#C03A83&quot;,&quot;#D5546E&quot;,&quot;#E76F5A&quot;,&quot;#F58C46&quot;,&quot;#FDAD32&quot;,&quot;#FCD225&quot;,&quot;#F0F921&quot;],&quot;cividis&quot;:[&quot;#00204D&quot;,&quot;#00306F&quot;,&quot;#2A406C&quot;,&quot;#48526B&quot;,&quot;#5E626E&quot;,&quot;#727374&quot;,&quot;#878479&quot;,&quot;#9E9677&quot;,&quot;#B6A971&quot;,&quot;#D0BE67&quot;,&quot;#EAD357&quot;,&quot;#FFEA46&quot;],&quot;BrBG&quot;:[&quot;#543005&quot;,&quot;#8C510A&quot;,&quot;#BF812D&quot;,&quot;#DFC27D&quot;,&quot;#F6E8C3&quot;,&quot;#F5F5F5&quot;,&quot;#C7EAE5&quot;,&quot;#80CDC1&quot;,&quot;#35978F&quot;,&quot;#01665E&quot;,&quot;#003C30&quot;],&quot;PiYG&quot;:[&quot;#8E0152&quot;,&quot;#C51B7D&quot;,&quot;#DE77AE&quot;,&quot;#F1B6DA&quot;,&quot;#FDE0EF&quot;,&quot;#F7F7F7&quot;,&quot;#E6F5D0&quot;,&quot;#B8E186&quot;,&quot;#7FBC41&quot;,&quot;#4D9221&quot;,&quot;#276419&quot;],&quot;PRGn&quot;:[&quot;#40004B&quot;,&quot;#762A83&quot;,&quot;#9970AB&quot;,&quot;#C2A5CF&quot;,&quot;#E7D4E8&quot;,&quot;#F7F7F7&quot;,&quot;#D9F0D3&quot;,&quot;#A6DBA0&quot;,&quot;#5AAE61&quot;,&quot;#1B7837&quot;,&quot;#00441B&quot;],&quot;PuOr&quot;:[&quot;#7F3B08&quot;,&quot;#B35806&quot;,&quot;#E08214&quot;,&quot;#FDB863&quot;,&quot;#FEE0B6&quot;,&quot;#F7F7F7&quot;,&quot;#D8DAEB&quot;,&quot;#B2ABD2&quot;,&quot;#8073AC&quot;,&quot;#542788&quot;,&quot;#2D004B&quot;],&quot;RdBu&quot;:[&quot;#67001F&quot;,&quot;#B2182B&quot;,&quot;#D6604D&quot;,&quot;#F4A582&quot;,&quot;#FDDBC7&quot;,&quot;#F7F7F7&quot;,&quot;#D1E5F0&quot;,&quot;#92C5DE&quot;,&quot;#4393C3&quot;,&quot;#2166AC&quot;,&quot;#053061&quot;],&quot;RdGy&quot;:[&quot;#67001F&quot;,&quot;#B2182B&quot;,&quot;#D6604D&quot;,&quot;#F4A582&quot;,&quot;#FDDBC7&quot;,&quot;#FFFFFF&quot;,&quot;#E0E0E0&quot;,&quot;#BABABA&quot;,&quot;#878787&quot;,&quot;#4D4D4D&quot;,&quot;#1A1A1A&quot;],&quot;RdYlBu&quot;:[&quot;#A50026&quot;,&quot;#D73027&quot;,&quot;#F46D43&quot;,&quot;#FDAE61&quot;,&quot;#FEE090&quot;,&quot;#FFFFBF&quot;,&quot;#E0F3F8&quot;,&quot;#ABD9E9&quot;,&quot;#74ADD1&quot;,&quot;#4575B4&quot;,&quot;#313695&quot;],&quot;RdYlGn&quot;:[&quot;#A50026&quot;,&quot;#D73027&quot;,&quot;#F46D43&quot;,&quot;#FDAE61&quot;,&quot;#FEE08B&quot;,&quot;#FFFFBF&quot;,&quot;#D9EF8B&quot;,&quot;#A6D96A&quot;,&quot;#66BD63&quot;,&quot;#1A9850&quot;,&quot;#006837&quot;],&quot;Spectral&quot;:[&quot;#9E0142&quot;,&quot;#D53E4F&quot;,&quot;#F46D43&quot;,&quot;#FDAE61&quot;,&quot;#FEE08B&quot;,&quot;#FFFFBF&quot;,&quot;#E6F598&quot;,&quot;#ABDDA4&quot;,&quot;#66C2A5&quot;,&quot;#3288BD&quot;,&quot;#5E4FA2&quot;],&quot;Accent&quot;:[&quot;#7FC97F&quot;,&quot;#BEAED4&quot;,&quot;#FDC086&quot;,&quot;#FFFF99&quot;,&quot;#386CB0&quot;,&quot;#F0027F&quot;,&quot;#BF5B17&quot;,&quot;#666666&quot;],&quot;Dark2&quot;:[&quot;#1B9E77&quot;,&quot;#D95F02&quot;,&quot;#7570B3&quot;,&quot;#E7298A&quot;,&quot;#66A61E&quot;,&quot;#E6AB02&quot;,&quot;#A6761D&quot;,&quot;#666666&quot;],&quot;Paired&quot;:[&quot;#A6CEE3&quot;,&quot;#1F78B4&quot;,&quot;#B2DF8A&quot;,&quot;#33A02C&quot;,&quot;#FB9A99&quot;,&quot;#E31A1C&quot;,&quot;#FDBF6F&quot;,&quot;#FF7F00&quot;,&quot;#CAB2D6&quot;,&quot;#6A3D9A&quot;,&quot;#FFFF99&quot;,&quot;#B15928&quot;],&quot;Pastel1&quot;:[&quot;#FBB4AE&quot;,&quot;#B3CDE3&quot;,&quot;#CCEBC5&quot;,&quot;#DECBE4&quot;,&quot;#FED9A6&quot;,&quot;#FFFFCC&quot;,&quot;#E5D8BD&quot;,&quot;#FDDAEC&quot;,&quot;#F2F2F2&quot;],&quot;Pastel2&quot;:[&quot;#B3E2CD&quot;,&quot;#FDCDAC&quot;,&quot;#CBD5E8&quot;,&quot;#F4CAE4&quot;,&quot;#E6F5C9&quot;,&quot;#FFF2AE&quot;,&quot;#F1E2CC&quot;,&quot;#CCCCCC&quot;],&quot;Set1&quot;:[&quot;#E41A1C&quot;,&quot;#377EB8&quot;,&quot;#4DAF4A&quot;,&quot;#984EA3&quot;,&quot;#FF7F00&quot;,&quot;#FFFF33&quot;,&quot;#A65628&quot;,&quot;#F781BF&quot;],&quot;Set2&quot;:[&quot;#66C2A5&quot;,&quot;#FC8D62&quot;,&quot;#8DA0CB&quot;,&quot;#E78AC3&quot;,&quot;#A6D854&quot;,&quot;#FFD92F&quot;,&quot;#E5C494&quot;,&quot;#B3B3B3&quot;],&quot;Set3&quot;:[&quot;#8DD3C7&quot;,&quot;#FFFFB3&quot;,&quot;#BEBADA&quot;,&quot;#FB8072&quot;,&quot;#80B1D3&quot;,&quot;#FDB462&quot;,&quot;#B3DE69&quot;,&quot;#FCCDE5&quot;,&quot;#D9D9D9&quot;,&quot;#BC80BD&quot;,&quot;#CCEBC5&quot;,&quot;#FFED6F&quot;],&quot;Blues&quot;:[&quot;#F7FBFF&quot;,&quot;#DEEBF7&quot;,&quot;#C6DBEF&quot;,&quot;#9ECAE1&quot;,&quot;#6BAED6&quot;,&quot;#4292C6&quot;,&quot;#2171B5&quot;,&quot;#08519C&quot;,&quot;#08306B&quot;],&quot;BuGn&quot;:[&quot;#F7FCFD&quot;,&quot;#E5F5F9&quot;,&quot;#CCECE6&quot;,&quot;#99D8C9&quot;,&quot;#66C2A4&quot;,&quot;#41AE76&quot;,&quot;#238B45&quot;,&quot;#006D2C&quot;,&quot;#00441B&quot;],&quot;BuPu&quot;:[&quot;#F7FCFD&quot;,&quot;#E0ECF4&quot;,&quot;#BFD3E6&quot;,&quot;#9EBCDA&quot;,&quot;#8C96C6&quot;,&quot;#8C6BB1&quot;,&quot;#88419D&quot;,&quot;#810F7C&quot;,&quot;#4D004B&quot;],&quot;GnBu&quot;:[&quot;#F7FCF0&quot;,&quot;#E0F3DB&quot;,&quot;#CCEBC5&quot;,&quot;#A8DDB5&quot;,&quot;#7BCCC4&quot;,&quot;#4EB3D3&quot;,&quot;#2B8CBE&quot;,&quot;#0868AC&quot;,&quot;#084081&quot;],&quot;Greens&quot;:[&quot;#F7FCF5&quot;,&quot;#E5F5E0&quot;,&quot;#C7E9C0&quot;,&quot;#A1D99B&quot;,&quot;#74C476&quot;,&quot;#41AB5D&quot;,&quot;#238B45&quot;,&quot;#006D2C&quot;,&quot;#00441B&quot;],&quot;Greys&quot;:[&quot;#FFFFFF&quot;,&quot;#F0F0F0&quot;,&quot;#D9D9D9&quot;,&quot;#BDBDBD&quot;,&quot;#969696&quot;,&quot;#737373&quot;,&quot;#525252&quot;,&quot;#252525&quot;,&quot;#000000&quot;],&quot;Oranges&quot;:[&quot;#FFF5EB&quot;,&quot;#FEE6CE&quot;,&quot;#FDD0A2&quot;,&quot;#FDAE6B&quot;,&quot;#FD8D3C&quot;,&quot;#F16913&quot;,&quot;#D94801&quot;,&quot;#A63603&quot;,&quot;#7F2704&quot;],&quot;OrRd&quot;:[&quot;#FFF7EC&quot;,&quot;#FEE8C8&quot;,&quot;#FDD49E&quot;,&quot;#FDBB84&quot;,&quot;#FC8D59&quot;,&quot;#EF6548&quot;,&quot;#D7301F&quot;,&quot;#B30000&quot;,&quot;#7F0000&quot;],&quot;PuBu&quot;:[&quot;#FFF7FB&quot;,&quot;#ECE7F2&quot;,&quot;#D0D1E6&quot;,&quot;#A6BDDB&quot;,&quot;#74A9CF&quot;,&quot;#3690C0&quot;,&quot;#0570B0&quot;,&quot;#045A8D&quot;,&quot;#023858&quot;],&quot;PuBuGn&quot;:[&quot;#FFF7FB&quot;,&quot;#ECE2F0&quot;,&quot;#D0D1E6&quot;,&quot;#A6BDDB&quot;,&quot;#67A9CF&quot;,&quot;#3690C0&quot;,&quot;#02818A&quot;,&quot;#016C59&quot;,&quot;#014636&quot;],&quot;PuRd&quot;:[&quot;#F7F4F9&quot;,&quot;#E7E1EF&quot;,&quot;#D4B9DA&quot;,&quot;#C994C7&quot;,&quot;#DF65B0&quot;,&quot;#E7298A&quot;,&quot;#CE1256&quot;,&quot;#980043&quot;,&quot;#67001F&quot;],&quot;Purples&quot;:[&quot;#FCFBFD&quot;,&quot;#EFEDF5&quot;,&quot;#DADAEB&quot;,&quot;#BCBDDC&quot;,&quot;#9E9AC8&quot;,&quot;#807DBA&quot;,&quot;#6A51A3&quot;,&quot;#54278F&quot;,&quot;#3F007D&quot;],&quot;RdPu&quot;:[&quot;#FFF7F3&quot;,&quot;#FDE0DD&quot;,&quot;#FCC5C0&quot;,&quot;#FA9FB5&quot;,&quot;#F768A1&quot;,&quot;#DD3497&quot;,&quot;#AE017E&quot;,&quot;#7A0177&quot;,&quot;#49006A&quot;],&quot;Reds&quot;:[&quot;#FFF5F0&quot;,&quot;#FEE0D2&quot;,&quot;#FCBBA1&quot;,&quot;#FC9272&quot;,&quot;#FB6A4A&quot;,&quot;#EF3B2C&quot;,&quot;#CB181D&quot;,&quot;#A50F15&quot;,&quot;#67000D&quot;],&quot;YlGn&quot;:[&quot;#FFFFE5&quot;,&quot;#F7FCB9&quot;,&quot;#D9F0A3&quot;,&quot;#ADDD8E&quot;,&quot;#78C679&quot;,&quot;#41AB5D&quot;,&quot;#238443&quot;,&quot;#006837&quot;,&quot;#004529&quot;],&quot;YlGnBu&quot;:[&quot;#FFFFD9&quot;,&quot;#EDF8B1&quot;,&quot;#C7E9B4&quot;,&quot;#7FCDBB&quot;,&quot;#41B6C4&quot;,&quot;#1D91C0&quot;,&quot;#225EA8&quot;,&quot;#253494&quot;,&quot;#081D58&quot;],&quot;YlOrBr&quot;:[&quot;#FFFFE5&quot;,&quot;#FFF7BC&quot;,&quot;#FEE391&quot;,&quot;#FEC44F&quot;,&quot;#FE9929&quot;,&quot;#EC7014&quot;,&quot;#CC4C02&quot;,&quot;#993404&quot;,&quot;#662506&quot;],&quot;YlOrRd&quot;:[&quot;#FFFFCC&quot;,&quot;#FFEDA0&quot;,&quot;#FED976&quot;,&quot;#FEB24C&quot;,&quot;#FD8D3C&quot;,&quot;#FC4E2A&quot;,&quot;#E31A1C&quot;,&quot;#BD0026&quot;,&quot;#800026&quot;]}" data-initial="{&quot;Up&quot;:&quot;#FF0000&quot;,&quot;Down&quot;:&quot;#0000FF&quot;,&quot;n.s.&quot;:&quot;#D3D3D3&quot;}" data-groups="[&quot;Up&quot;,&quot;Down&quot;,&quot;n.s.&quot;]" data-default-palette="dittoColors" data-compact="true">
#>       <div class="mc-top">
#>         <label class="control-label" for="volcanoPlot-volcano.colors">Group Colors</label>
#>         <div class="mc-actions">
#>           <select id="volcanoPlot-volcano.colors-palette" class="mc-palette-select form-control input-sm" aria-label="Palette">
#>             <optgroup label="Defaults">
#>               <option value="dittoColors" selected="selected">dittoColors</option>
#>               <option value="dittoColors_full">dittoColors_full</option>
#>               <option value="ggplot2">ggplot2</option>
#>             </optgroup>
#>             <optgroup label="Viridis">
#>               <option value="viridis">viridis</option>
#>               <option value="magma">magma</option>
#>               <option value="inferno">inferno</option>
#>               <option value="plasma">plasma</option>
#>               <option value="cividis">cividis</option>
#>             </optgroup>
#>             <optgroup label="Diverging">
#>               <option value="BrBG">BrBG</option>
#>               <option value="PiYG">PiYG</option>
#>               <option value="PRGn">PRGn</option>
#>               <option value="PuOr">PuOr</option>
#>               <option value="RdBu">RdBu</option>
#>               <option value="RdGy">RdGy</option>
#>               <option value="RdYlBu">RdYlBu</option>
#>               <option value="RdYlGn">RdYlGn</option>
#>               <option value="Spectral">Spectral</option>
#>             </optgroup>
#>             <optgroup label="Qualitative">
#>               <option value="Accent">Accent</option>
#>               <option value="Dark2">Dark2</option>
#>               <option value="Paired">Paired</option>
#>               <option value="Pastel1">Pastel1</option>
#>               <option value="Pastel2">Pastel2</option>
#>               <option value="Set1">Set1</option>
#>               <option value="Set2">Set2</option>
#>               <option value="Set3">Set3</option>
#>             </optgroup>
#>             <optgroup label="Sequential">
#>               <option value="Blues">Blues</option>
#>               <option value="BuGn">BuGn</option>
#>               <option value="BuPu">BuPu</option>
#>               <option value="GnBu">GnBu</option>
#>               <option value="Greens">Greens</option>
#>               <option value="Greys">Greys</option>
#>               <option value="Oranges">Oranges</option>
#>               <option value="OrRd">OrRd</option>
#>               <option value="PuBu">PuBu</option>
#>               <option value="PuBuGn">PuBuGn</option>
#>               <option value="PuRd">PuRd</option>
#>               <option value="Purples">Purples</option>
#>               <option value="RdPu">RdPu</option>
#>               <option value="Reds">Reds</option>
#>               <option value="YlGn">YlGn</option>
#>               <option value="YlGnBu">YlGnBu</option>
#>               <option value="YlOrBr">YlOrBr</option>
#>               <option value="YlOrRd">YlOrRd</option>
#>             </optgroup>
#>           </select>
#>           <div class="mc-button-group">
#>             <button type="button" class="mc-button mc-apply-palette">Apply</button>
#>             <button type="button" class="mc-button mc-reset-palette">Reset</button>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="mc-swatch-row" role="list"></div>
#>       <div class="mc-color-rows">
#>         <div class="mc-color-row is-active" data-group="Up">
#>           <span class="mc-group-label">Up</span>
#>           <input type="color" class="mc-color-input" value="#FF0000" aria-label="Up color"/>
#>           <input type="text" class="mc-text-input form-control input-sm" value="#FF0000" aria-label="Up hex code"/>
#>         </div>
#>         <div class="mc-color-row " data-group="Down">
#>           <span class="mc-group-label">Down</span>
#>           <input type="color" class="mc-color-input" value="#0000FF" aria-label="Down color"/>
#>           <input type="text" class="mc-text-input form-control input-sm" value="#0000FF" aria-label="Down hex code"/>
#>         </div>
#>         <div class="mc-color-row " data-group="n.s.">
#>           <span class="mc-group-label">n.s.</span>
#>           <input type="color" class="mc-color-input" value="#D3D3D3" aria-label="n.s. color"/>
#>           <input type="text" class="mc-text-input form-control input-sm" value="#D3D3D3" aria-label="n.s. hex code"/>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <h3>Volcano Settings</h3>
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="volcanoPlot-scatterPlotTabsetPanel" data-tabsetid="3680">
#>     <li class="active">
#>       <a href="#tab-3680-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facets">Facets</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend/Scale">Legend/Scale</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-9" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-10" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-11" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3680-12" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="3680">
#>     <div class="tab-pane active" data-value="Data" id="tab-3680-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-x.by-label" for="volcanoPlot-x.by">X Data</label>
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
#>             <label class="control-label" id="volcanoPlot-y.by-label" for="volcanoPlot-y.by">Y Data</label>
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
#>             <label class="control-label" id="volcanoPlot-color.by-label" for="volcanoPlot-color.by">Color By</label>
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
#>             <label class="control-label" id="volcanoPlot-shape.by-label" for="volcanoPlot-shape.by">Shape By</label>
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
#>             <label class="control-label" id="volcanoPlot-split.by-label" for="volcanoPlot-split.by">Split By</label>
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
#>             <label class="control-label" id="volcanoPlot-rows.use-label" for="volcanoPlot-rows.use">Rows Filter</label>
#>             <input id="volcanoPlot-rows.use" type="text" class="shiny-input-text form-control" value="" placeholder="Filter expression, e.g. Sepal.Length &gt; 5" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-3680-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-x.adjustment-label" for="volcanoPlot-x.adjustment">X Adjustment</label>
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
#>             <label class="control-label" id="volcanoPlot-y.adjustment-label" for="volcanoPlot-y.adjustment">Y Adjustment</label>
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
#>             <label class="control-label" id="volcanoPlot-color.adjustment-label" for="volcanoPlot-color.adjustment">Color Adjustment</label>
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
#>             <label class="control-label" id="volcanoPlot-x.adj.fxn-label" for="volcanoPlot-x.adj.fxn">X Adjustment Function</label>
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
#>             <label class="control-label" id="volcanoPlot-y.adj.fxn-label" for="volcanoPlot-y.adj.fxn">Y Adjustment Function</label>
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
#>             <label class="control-label" id="volcanoPlot-color.adj.fxn-label" for="volcanoPlot-color.adj.fxn">Color Adjustment Function</label>
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
#>     <div class="tab-pane" data-value="Points" id="tab-3680-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-size-label" for="volcanoPlot-size">Point Size</label>
#>             <input id="volcanoPlot-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-opacity-label" for="volcanoPlot-opacity">Point Opacity</label>
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
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-plot.order-label" for="volcanoPlot-plot.order">Plot Order</label>
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
#>             <label class="control-label" id="volcanoPlot-shape.panel-label" for="volcanoPlot-shape.panel">Shape Panel</label>
#>             <input id="volcanoPlot-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-3680-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-min.color">Min Color</label>
#>             <input id="volcanoPlot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-max.color">Max Color</label>
#>             <input id="volcanoPlot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-contour.color">Contour Color</label>
#>             <input id="volcanoPlot-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-contour.linetype-label" for="volcanoPlot-contour.linetype">Contour Linetype</label>
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
#>     <div class="tab-pane" data-value="Facets" id="tab-3680-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.nrow-label" for="volcanoPlot-split.nrow">Split Rows</label>
#>             <input id="volcanoPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.ncol-label" for="volcanoPlot-split.ncol">Split Columns</label>
#>             <input id="volcanoPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-multivar.split.dir-label" for="volcanoPlot-multivar.split.dir">Multivar Split Dir</label>
#>             <div>
#>               <select id="volcanoPlot-multivar.split.dir" class="shiny-input-select"><option value="col" selected>col</option>
#> <option value="row">row</option></select>
#>               <script type="application/json" data-for="volcanoPlot-multivar.split.dir" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-split.adjust.scales-label" for="volcanoPlot-split.adjust.scales">Facet Scales</label>
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
#>     <div class="tab-pane" data-value="Annotations" id="tab-3680-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotate.by-label" for="volcanoPlot-annotate.by">Annotate By</label>
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
#>             <label class="control-label" id="volcanoPlot-highlight.points-label" for="volcanoPlot-highlight.points">Points to Highlight</label>
#>             <textarea id="volcanoPlot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-highlight.color">Highlight Fill</label>
#>             <input id="volcanoPlot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-highlight.size-label" for="volcanoPlot-highlight.size">Highlight Size</label>
#>             <input id="volcanoPlot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-highlight.border.color">Highlight Border Color</label>
#>             <input id="volcanoPlot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-highlight.border.width-label" for="volcanoPlot-highlight.border.width">Highlight Border Width</label>
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
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-annotation.color">Annotation Color</label>
#>             <input id="volcanoPlot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.ax-label" for="volcanoPlot-annotation.ax">Annotation X Offset</label>
#>             <input id="volcanoPlot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.ay-label" for="volcanoPlot-annotation.ay">Annotation Y Offset</label>
#>             <input id="volcanoPlot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.size-label" for="volcanoPlot-annotation.size">Annotation Size</label>
#>             <input id="volcanoPlot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-annotation.arrowcolor">Arrow Color</label>
#>             <input id="volcanoPlot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.arrowhead-label" for="volcanoPlot-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="volcanoPlot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-annotation.arrowwidth-label" for="volcanoPlot-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="volcanoPlot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <button id="volcanoPlot-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend/Scale" id="tab-3680-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-legend.show" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.title-label" for="volcanoPlot-legend.color.title">Legend Title</label>
#>             <input id="volcanoPlot-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.size-label" for="volcanoPlot-legend.color.size">Legend Color Size</label>
#>             <input id="volcanoPlot-legend.color.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.shape.size-label" for="volcanoPlot-legend.shape.size">Legend Shape Size</label>
#>             <input id="volcanoPlot-legend.shape.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-legend.color.breaks-label" for="volcanoPlot-legend.color.breaks">Legend Tick Breaks</label>
#>             <input id="volcanoPlot-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-min.value-label" for="volcanoPlot-min.value">Min Value</label>
#>             <input id="volcanoPlot-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-max.value-label" for="volcanoPlot-max.value">Max Value</label>
#>             <input id="volcanoPlot-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-3680-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-trajectory.group.by-label" for="volcanoPlot-trajectory.group.by">Trajectory Group By</label>
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
#>             <label class="control-label" id="volcanoPlot-add.trajectory.by.groups-label" for="volcanoPlot-add.trajectory.by.groups">Add Trajectory By Groups</label>
#>             <input id="volcanoPlot-add.trajectory.by.groups" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. [A,B],[C,D,E]" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-trajectory.arrow.size-label" for="volcanoPlot-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="volcanoPlot-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-3680-9">
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
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-shape.fill">Shape Fill</label>
#>             <input id="volcanoPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-shape.line.color">Shape Line Color</label>
#>             <input id="volcanoPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.line.width-label" for="volcanoPlot-shape.line.width">Shape Line Width</label>
#>             <input id="volcanoPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.linetype-label" for="volcanoPlot-shape.linetype">Shape Linetype</label>
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
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-shape.opacity-label" for="volcanoPlot-shape.opacity">Shape Opacity</label>
#>             <input id="volcanoPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-3680-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hover.data-label" for="volcanoPlot-hover.data">Hover Data</label>
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
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hover.round.digits-label" for="volcanoPlot-hover.round.digits">Hover Round Digits</label>
#>             <input id="volcanoPlot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-3680-11">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hline.intercepts-label" for="volcanoPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="volcanoPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hline.colors-label" for="volcanoPlot-hline.colors">Colors</label>
#>             <input id="volcanoPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hline.widths-label" for="volcanoPlot-hline.widths">Widths</label>
#>             <input id="volcanoPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hline.linetypes-label" for="volcanoPlot-hline.linetypes">Line types</label>
#>             <input id="volcanoPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-hline.opacities-label" for="volcanoPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="volcanoPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <br/>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-vline.intercepts-label" for="volcanoPlot-vline.intercepts">X-intercepts</label>
#>             <input id="volcanoPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-vline.colors-label" for="volcanoPlot-vline.colors">Colors</label>
#>             <input id="volcanoPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-vline.widths-label" for="volcanoPlot-vline.widths">Widths</label>
#>             <input id="volcanoPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-vline.linetypes-label" for="volcanoPlot-vline.linetypes">Line types</label>
#>             <input id="volcanoPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-vline.opacities-label" for="volcanoPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="volcanoPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <br/>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-abline.slopes-label" for="volcanoPlot-abline.slopes">Slopes</label>
#>             <input id="volcanoPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="volcanoPlot-best.fit" style="padding-right: 10px;">Line of best fit:</label>
#>               <input id="volcanoPlot-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="volcanoPlot-best.fit"></label>
#>             </div>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-line.best.smoothness-label" for="volcanoPlot-line.best.smoothness">Smoothness of line of best fit:</label>
#>             <input id="volcanoPlot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-line.best.colour">Line of best fit colour:</label>
#>             <input id="volcanoPlot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="volcanoPlot-linear.model" style="padding-right: 10px;">Linear model line</label>
#>               <input id="volcanoPlot-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="volcanoPlot-linear.model"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-3680-12">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-font.type-label" for="volcanoPlot-font.type">Title Font</label>
#>             <div>
#>               <select id="volcanoPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="volcanoPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-text.colour">Title Color</label>
#>             <input id="volcanoPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.title.font.size-label" for="volcanoPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="volcanoPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="volcanoPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.title.font.family-label" for="volcanoPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="volcanoPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="volcanoPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
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
#>                 <input id="volcanoPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="volcanoPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="volcanoPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.linewidth-label" for="volcanoPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="volcanoPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickfont.size-label" for="volcanoPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="volcanoPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="volcanoPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="volcanoPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickfont.family-label" for="volcanoPlot-axis.tickfont.family">Tick Label Font</label>
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
#>             <label class="control-label" id="volcanoPlot-axis.tickangle.x-label" for="volcanoPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="volcanoPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickangle.y-label" for="volcanoPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="volcanoPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.ticks-label" for="volcanoPlot-axis.ticks">Tick Position</label>
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
#>             <label class="control-label" for="volcanoPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="volcanoPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.ticklen-label" for="volcanoPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="volcanoPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="volcanoPlot-axis.tickwidth-label" for="volcanoPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="volcanoPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="volcanoPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="volcanoPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="volcanoPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="volcanoPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="volcanoPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="volcanoPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="volcanoPlot-download.format-label" for="volcanoPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="volcanoPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="volcanoPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
