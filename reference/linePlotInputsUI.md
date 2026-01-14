# Input UI components for the linePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`linePlotServer()`](https://j-andrews7.github.io/vizModules/reference/linePlotServer.md)
and
[`linePlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/linePlotOutputUI.md)
functions.

## Usage

``` r
linePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`linePlot()`](https://j-andrews7.github.io/vizModules/reference/linePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`linePlot()`](https://j-andrews7.github.io/vizModules/reference/linePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/linePlotOutputUI.md),
[`linePlotServer()`](https://j-andrews7.github.io/vizModules/reference/linePlotServer.md),
[`linePlotApp()`](https://j-andrews7.github.io/vizModules/reference/linePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(vizModules)
data(mtcars)
linePlotInputsUI("linePlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="linePlot-linePlotTabsetPanel" data-tabsetid="2250">
#>     <li class="active">
#>       <a href="#tab-2250-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2250-2" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2250">
#>     <div class="tab-pane active" data-value="Data" id="tab-2250-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-x.value-label" for="linePlot-x.value">Select X values:</label>
#>             <div>
#>               <select id="linePlot-x.value" class="shiny-input-select" multiple="multiple"><option value="mpg" selected>mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="linePlot-x.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-y.value-label" for="linePlot-y.value">Select Y values:</label>
#>             <div>
#>               <select id="linePlot-y.value" class="shiny-input-select" multiple="multiple"><option value="mpg">mpg</option>
#> <option value="cyl" selected>cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="linePlot-y.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-plot.type-label" for="linePlot-plot.type">Plot type: </label>
#>             <div>
#>               <select id="linePlot-plot.type" class="shiny-input-select"><option value="lines" selected>lines</option>
#> <option value="markers">markers</option>
#> <option value="lines+markers">lines+markers</option></select>
#>               <script type="application/json" data-for="linePlot-plot.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-line.type-label" for="linePlot-line.type">Line type:</label>
#>             <div>
#>               <select id="linePlot-line.type" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>               <script type="application/json" data-for="linePlot-line.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-group.by-label" for="linePlot-group.by">Group by:</label>
#>             <div>
#>               <select id="linePlot-group.by" class="shiny-input-select"><option value="" selected></option></select>
#>               <script type="application/json" data-for="linePlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-palette-label" for="linePlot-palette">Select palette:</label>
#>             <div>
#>               <select id="linePlot-palette" class="shiny-input-select"><option value="BrBG">BrBG</option>
#> <option value="PiYG">PiYG</option>
#> <option value="PRGn">PRGn</option>
#> <option value="PuOr">PuOr</option>
#> <option value="RdBu">RdBu</option>
#> <option value="RdGy">RdGy</option>
#> <option value="RdYlBu">RdYlBu</option>
#> <option value="RdYlGn">RdYlGn</option>
#> <option value="Spectral">Spectral</option>
#> <option value="Accent">Accent</option>
#> <option value="Dark2">Dark2</option>
#> <option value="Paired" selected>Paired</option>
#> <option value="Pastel1">Pastel1</option>
#> <option value="Pastel2">Pastel2</option>
#> <option value="Set1">Set1</option>
#> <option value="Set2">Set2</option>
#> <option value="Set3">Set3</option>
#> <option value="Blues">Blues</option>
#> <option value="BuGn">BuGn</option>
#> <option value="BuPu">BuPu</option>
#> <option value="GnBu">GnBu</option>
#> <option value="Greens">Greens</option>
#> <option value="Greys">Greys</option>
#> <option value="Oranges">Oranges</option>
#> <option value="OrRd">OrRd</option>
#> <option value="PuBu">PuBu</option>
#> <option value="PuBuGn">PuBuGn</option>
#> <option value="PuRd">PuRd</option>
#> <option value="Purples">Purples</option>
#> <option value="RdPu">RdPu</option>
#> <option value="Reds">Reds</option>
#> <option value="YlGn">YlGn</option>
#> <option value="YlGnBu">YlGnBu</option>
#> <option value="YlOrBr">YlOrBr</option>
#> <option value="YlOrRd">YlOrRd</option>
#> <option value="npg">npg</option>
#> <option value="aaas">aaas</option>
#> <option value="nejm">nejm</option>
#> <option value="lancet">lancet</option>
#> <option value="jama">jama</option>
#> <option value="jco">jco</option>
#> <option value="ucscgb">ucscgb</option>
#> <option value="d3-category10">d3-category10</option>
#> <option value="d3-category20">d3-category20</option>
#> <option value="d3-category20b">d3-category20b</option>
#> <option value="d3-category20c">d3-category20c</option>
#> <option value="igv">igv</option>
#> <option value="locuszoom">locuszoom</option>
#> <option value="uchicago-default">uchicago-default</option>
#> <option value="uchicago-light">uchicago-light</option>
#> <option value="uchicago-dark">uchicago-dark</option>
#> <option value="cosmic">cosmic</option>
#> <option value="simpsons">simpsons</option>
#> <option value="futurama">futurama</option>
#> <option value="rickandmorty">rickandmorty</option>
#> <option value="startrek">startrek</option>
#> <option value="tron">tron</option>
#> <option value="frontiers">frontiers</option>
#> <option value="flatui">flatui</option>
#> <option value="gsea">gsea</option>
#> <option value="material-red">material-red</option>
#> <option value="material-pink">material-pink</option>
#> <option value="material-purple">material-purple</option>
#> <option value="material-deep-purple">material-deep-purple</option>
#> <option value="material-indigo">material-indigo</option>
#> <option value="material-blue">material-blue</option>
#> <option value="material-light-blue">material-light-blue</option>
#> <option value="material-cyan">material-cyan</option>
#> <option value="material-teal">material-teal</option>
#> <option value="material-green">material-green</option>
#> <option value="material-light-green">material-light-green</option>
#> <option value="material-lime">material-lime</option>
#> <option value="material-yellow">material-yellow</option>
#> <option value="material-amber">material-amber</option>
#> <option value="material-orange">material-orange</option>
#> <option value="material-deep-orange">material-deep-orange</option>
#> <option value="material-brown">material-brown</option>
#> <option value="material-grey">material-grey</option>
#> <option value="material-blue-grey">material-blue-grey</option>
#> <option value="dPBIYlBu">dPBIYlBu</option>
#> <option value="dPBIYlPu">dPBIYlPu</option>
#> <option value="dPBIPuGn">dPBIPuGn</option>
#> <option value="dPBIPuOr">dPBIPuOr</option>
#> <option value="dPBIRdBu">dPBIRdBu</option>
#> <option value="dPBIRdGy">dPBIRdGy</option>
#> <option value="dPBIRdGn">dPBIRdGn</option>
#> <option value="qMSOStd">qMSOStd</option>
#> <option value="qMSO12">qMSO12</option>
#> <option value="qMSO15">qMSO15</option>
#> <option value="qMSOBuWarm">qMSOBuWarm</option>
#> <option value="qMSOBu">qMSOBu</option>
#> <option value="qMSOBu2">qMSOBu2</option>
#> <option value="qMSOBuGn">qMSOBuGn</option>
#> <option value="qMSOGn">qMSOGn</option>
#> <option value="qMSOGnYl">qMSOGnYl</option>
#> <option value="qMSOYl">qMSOYl</option>
#> <option value="qMSOYlOr">qMSOYlOr</option>
#> <option value="qMSOOr">qMSOOr</option>
#> <option value="qMSOOrRd">qMSOOrRd</option>
#> <option value="qMSORdOr">qMSORdOr</option>
#> <option value="qMSORd">qMSORd</option>
#> <option value="qMSORdPu">qMSORdPu</option>
#> <option value="qMSOPu">qMSOPu</option>
#> <option value="qMSOPu2">qMSOPu2</option>
#> <option value="qMSOMed">qMSOMed</option>
#> <option value="qMSOPap">qMSOPap</option>
#> <option value="qMSOMrq">qMSOMrq</option>
#> <option value="qMSOSlp">qMSOSlp</option>
#> <option value="qMSOAsp">qMSOAsp</option>
#> <option value="qPBI">qPBI</option>
#> <option value="sPBIGn">sPBIGn</option>
#> <option value="sPBIGy1">sPBIGy1</option>
#> <option value="sPBIRd">sPBIRd</option>
#> <option value="sPBIYl">sPBIYl</option>
#> <option value="sPBIGy2">sPBIGy2</option>
#> <option value="sPBIBu">sPBIBu</option>
#> <option value="sPBIOr">sPBIOr</option>
#> <option value="sPBIPu">sPBIPu</option>
#> <option value="sPBIYlGn">sPBIYlGn</option>
#> <option value="sPBIRdPu">sPBIRdPu</option>
#> <option value="ag_GrnYl">ag_GrnYl</option>
#> <option value="ag_Sunset">ag_Sunset</option>
#> <option value="ArmyRose">ArmyRose</option>
#> <option value="Earth">Earth</option>
#> <option value="Fall">Fall</option>
#> <option value="Geyser">Geyser</option>
#> <option value="TealRose">TealRose</option>
#> <option value="Temps">Temps</option>
#> <option value="Tropic">Tropic</option>
#> <option value="Antique">Antique</option>
#> <option value="Bold">Bold</option>
#> <option value="Pastel">Pastel</option>
#> <option value="Prism">Prism</option>
#> <option value="Safe">Safe</option>
#> <option value="Vivid">Vivid</option>
#> <option value="BluGrn">BluGrn</option>
#> <option value="BluYl">BluYl</option>
#> <option value="BrwnYl">BrwnYl</option>
#> <option value="Burg">Burg</option>
#> <option value="BurgYl">BurgYl</option>
#> <option value="DarkMint">DarkMint</option>
#> <option value="Emrld">Emrld</option>
#> <option value="Magenta">Magenta</option>
#> <option value="Mint">Mint</option>
#> <option value="OrYel">OrYel</option>
#> <option value="Peach">Peach</option>
#> <option value="PinkYl">PinkYl</option>
#> <option value="Purp">Purp</option>
#> <option value="PurpOr">PurpOr</option>
#> <option value="RedOr">RedOr</option>
#> <option value="Sunset">Sunset</option>
#> <option value="SunsetDark">SunsetDark</option>
#> <option value="Teal">Teal</option>
#> <option value="TealGrn">TealGrn</option>
#> <option value="polarnight">polarnight</option>
#> <option value="snowstorm">snowstorm</option>
#> <option value="frost">frost</option>
#> <option value="aurora">aurora</option>
#> <option value="lumina">lumina</option>
#> <option value="mountain_forms">mountain_forms</option>
#> <option value="silver_mine">silver_mine</option>
#> <option value="lake_superior">lake_superior</option>
#> <option value="victory_bonds">victory_bonds</option>
#> <option value="halifax_harbor">halifax_harbor</option>
#> <option value="moose_pond">moose_pond</option>
#> <option value="algoma_forest">algoma_forest</option>
#> <option value="rocky_mountain">rocky_mountain</option>
#> <option value="red_mountain">red_mountain</option>
#> <option value="baie_mouton">baie_mouton</option>
#> <option value="afternoon_prarie">afternoon_prarie</option>
#> <option value="magma">magma</option>
#> <option value="inferno">inferno</option>
#> <option value="plasma">plasma</option>
#> <option value="viridis">viridis</option>
#> <option value="cividis">cividis</option>
#> <option value="rocket">rocket</option>
#> <option value="mako">mako</option>
#> <option value="turbo">turbo</option>
#> <option value="ocean.algae">ocean.algae</option>
#> <option value="ocean.deep">ocean.deep</option>
#> <option value="ocean.dense">ocean.dense</option>
#> <option value="ocean.gray">ocean.gray</option>
#> <option value="ocean.haline">ocean.haline</option>
#> <option value="ocean.ice">ocean.ice</option>
#> <option value="ocean.matter">ocean.matter</option>
#> <option value="ocean.oxy">ocean.oxy</option>
#> <option value="ocean.phase">ocean.phase</option>
#> <option value="ocean.solar">ocean.solar</option>
#> <option value="ocean.thermal">ocean.thermal</option>
#> <option value="ocean.turbid">ocean.turbid</option>
#> <option value="ocean.balance">ocean.balance</option>
#> <option value="ocean.curl">ocean.curl</option>
#> <option value="ocean.delta">ocean.delta</option>
#> <option value="ocean.amp">ocean.amp</option>
#> <option value="ocean.speed">ocean.speed</option>
#> <option value="ocean.tempo">ocean.tempo</option>
#> <option value="BrowntoBlue.10">BrowntoBlue.10</option>
#> <option value="BrowntoBlue.12">BrowntoBlue.12</option>
#> <option value="BluetoDarkOrange.12">BluetoDarkOrange.12</option>
#> <option value="BluetoDarkOrange.18">BluetoDarkOrange.18</option>
#> <option value="DarkRedtoBlue.12">DarkRedtoBlue.12</option>
#> <option value="DarkRedtoBlue.18">DarkRedtoBlue.18</option>
#> <option value="BluetoGreen.14">BluetoGreen.14</option>
#> <option value="BluetoGray.8">BluetoGray.8</option>
#> <option value="BluetoOrangeRed.14">BluetoOrangeRed.14</option>
#> <option value="BluetoOrange.10">BluetoOrange.10</option>
#> <option value="BluetoOrange.12">BluetoOrange.12</option>
#> <option value="BluetoOrange.8">BluetoOrange.8</option>
#> <option value="LightBluetoDarkBlue.10">LightBluetoDarkBlue.10</option>
#> <option value="LightBluetoDarkBlue.7">LightBluetoDarkBlue.7</option>
#> <option value="Categorical.12">Categorical.12</option>
#> <option value="GreentoMagenta.16">GreentoMagenta.16</option>
#> <option value="SteppedSequential.5">SteppedSequential.5</option>
#> <option value="jcolors-default">jcolors-default</option>
#> <option value="jcolors-pal2">jcolors-pal2</option>
#> <option value="jcolors-pal3">jcolors-pal3</option>
#> <option value="jcolors-pal4">jcolors-pal4</option>
#> <option value="jcolors-pal5">jcolors-pal5</option>
#> <option value="jcolors-pal6">jcolors-pal6</option>
#> <option value="jcolors-pal7">jcolors-pal7</option>
#> <option value="jcolors-pal8">jcolors-pal8</option>
#> <option value="jcolors-pal9">jcolors-pal9</option>
#> <option value="jcolors-pal10">jcolors-pal10</option>
#> <option value="jcolors-pal11">jcolors-pal11</option>
#> <option value="jcolors-pal12">jcolors-pal12</option>
#> <option value="jcolors-rainbow">jcolors-rainbow</option>
#> <option value="jet">jet</option>
#> <option value="simspec">simspec</option>
#> <option value="GdRd">GdRd</option>
#> <option value="alphabet">alphabet</option>
#> <option value="alphabet2">alphabet2</option>
#> <option value="glasbey">glasbey</option>
#> <option value="polychrome">polychrome</option>
#> <option value="stepped">stepped</option>
#> <option value="parade">parade</option>
#> <option value="seurat.16">seurat.16</option>
#> <option value="seurat.32">seurat.32</option>
#> <option value="seurat.64">seurat.64</option>
#> <option value="seurat">seurat</option>
#> <option value="stripe">stripe</option>
#> <option value="stripe.16">stripe.16</option>
#> <option value="stripe.32">stripe.32</option>
#> <option value="stripe.64">stripe.64</option></select>
#>               <script type="application/json" data-for="linePlot-palette" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="linePlot-flip.y" type="checkbox" class="sw-switchInput" data-input-id="linePlot-flip.y" data-on-text="ON" data-off-text="OFF" data-label-text="Flip Y axis:" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="linePlot-flip.x" type="checkbox" class="sw-switchInput" data-input-id="linePlot-flip.x" data-on-text="ON" data-off-text="OFF" data-label-text="Flip X axis:" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <input id="linePlot-order.by" type="checkbox" class="sw-switchInput" data-input-id="linePlot-order.by" data-on-text="y axis" data-off-text="x axis" data-label-text="Order plot by:" data-label-width="auto" data-handle-width="auto" data-size=""/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-facet.by-label" for="linePlot-facet.by">Facet by: </label>
#>             <div>
#>               <select id="linePlot-facet.by" class="shiny-input-select"><option value="" selected></option></select>
#>               <script type="application/json" data-for="linePlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-facet.scales-label" for="linePlot-facet.scales">Facet scales</label>
#>             <div>
#>               <select id="linePlot-facet.scales" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="linePlot-facet.scales" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-y.adjustment-label" for="linePlot-y.adjustment">Adjust the y axis:</label>
#>             <div>
#>               <select id="linePlot-y.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="linePlot-y.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-x.adjustment-label" for="linePlot-x.adjustment">Adjust the x axis:</label>
#>             <div>
#>               <select id="linePlot-x.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="linePlot-x.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-2250-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror axis lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.linecolor">Axis line color</label>
#>             <input id="linePlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.linewidth-label" for="linePlot-axis.linewidth">Axis line width</label>
#>             <input id="linePlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickfont.size-label" for="linePlot-axis.tickfont.size">Tick label size</label>
#>             <input id="linePlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.tickfont.color">Tick label color</label>
#>             <input id="linePlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickfont.family-label" for="linePlot-axis.tickfont.family">Tick label font</label>
#>             <div>
#>               <select id="linePlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="linePlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickangle.x-label" for="linePlot-axis.tickangle.x">X-axis tick label angle</label>
#>             <input id="linePlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickangle.y-label" for="linePlot-axis.tickangle.y">Y-axis tick label angle</label>
#>             <input id="linePlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.ticks-label" for="linePlot-axis.ticks">Tick position</label>
#>             <div>
#>               <select id="linePlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="linePlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.tickcolor">Tick mark color</label>
#>             <input id="linePlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.ticklen-label" for="linePlot-axis.ticklen">Tick mark length</label>
#>             <input id="linePlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickwidth-label" for="linePlot-axis.tickwidth">Tick mark width</label>
#>             <input id="linePlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <input id="linePlot-auto.update" type="checkbox" class="sw-switchInput" data-input-id="linePlot-auto.update" data-on-text="ON" data-off-text="OFF" data-label-text="Auto Update" data-label-width="auto" data-handle-width="auto" data-size="mini"/>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="linePlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="linePlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="linePlot-download.type-label" for="linePlot-download.type">Download Format</label>
#>       <div>
#>         <select id="linePlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="linePlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
