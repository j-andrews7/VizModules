# VizModules 0.2.0

* Created the Figure Builder app so that users can dynamically construct multi-panel figures 
  using different data sets and plot types on a single page.
  Allows for full page SVG export, source data dump organized per panel, and full customization of plot position and size. 
* All `*OutputUI()` functions gained a `resizable` argument (default `TRUE`).
  When `FALSE`, the plot output is no longer wrapped in
  `shinyjqui::jqui_resizable()`, which avoids a redundant resize handle when the
  output is embedded in a container that already provides resizing (such as the
  Figure Builder app cards).
* Added a new `plotthis_DotPlot` module (`plotthis_DotPlotInputsUI()`,
  `plotthis_DotPlotOutputUI()`, `plotthis_DotPlotServer()`, and the
  `plotthis_DotPlotApp()` convenience wrapper) that wraps `plotthis::DotPlot()`
  for interactive dot plots, including a custom dot-size legend since plotly still lacks that capability.
* Added the `example_markers` dataset, a simulated single-cell marker-gene
  expression table (immune cell types × marker genes) used as the default
  example data for the DotPlot module.
* Added "Source Data" download button at the bottom of every module's
  control panel. The button creates and downloads a ZIP file containing a self-contained HTML of the plotly plot, a CSV of the plot data (retrieved
  via `plotly::plotly_data()`), and for modules with statistics enabled
  (Box / Violin / yPlot), a table of the statistics info. Source downloads
  are now built from the exported `collect_source_data()` and
  `create_source_download_handler()` helpers, and each module server returns its source
  reactive so it can be reused (e.g. by the Figure Builder). Given source data is now required by many journals, this is important.
* Removed old interactive plot download button and associated helper function.
* Removed old dynamically hidden stats download button and associated logic, since stats are now included in the source download when applicable.
* Statistic helper functions are now exported allowing users to annotate plotly graphs with custom statistics: 
`compute_pairwise_stats()`, `create_stat_annotations()`,
`apply_stat_annotations()`, `generate_pair_strings()`, and
`parse_pair_strings()`.
* Exposed `empty_plot()` for use as a placeholder, e.g. if parameters aren't valid for a given plot type, to pass that info to user without ugly error messages.
* Faceting improvements - new internal helpers that control subplot spacing, subplot size, and facet_scale handling.
  This fixes much of the wonkiness for plots with many panels. Uniform inputs added for panel spacing across all modules.
* Axis titles now uniformly added as annotations to allow interactive repositioning.
* Condensed package wide workflows with simple helpers, e.g. `.apply_title_layout()`, resulting in significantly less jank.
* Axis adjustments are now properly reflected in axis/legend titles for appropriate modules, e.g. `yPlot`, `scatterPlot`, `linePlot`.
* Removed a handful of spurious/non-functional inputs, particularly for the `dittoViz_scatterPlot` module.
* Custom `size.by` legends added for `plotthis_DotPlot` and `dittoViz_scatterPlot` modules, since plotly does not yet support these. 

# VizModules 0.1.1

* Minor DESCRIPTION and doc fixes for CRAN compliance.

# VizModules 0.1.0

* Submitted to CRAN.
