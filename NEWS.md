# VizModules 0.2.0

* All `*OutputUI()` functions gained a `resizable` argument (default `TRUE`).
  When `FALSE`, the plot output is no longer wrapped in
  `shinyjqui::jqui_resizable()`, which avoids a redundant resize handle when the
  output is embedded in a container that already provides resizing (such as the
  Panel Builder app cards).
* Added a new `plotthis_DotPlot` module (`plotthis_DotPlotInputsUI()`,
  `plotthis_DotPlotOutputUI()`, `plotthis_DotPlotServer()`, and the
  `plotthis_DotPlotApp()` convenience wrapper) that wraps `plotthis::DotPlot()`
  for interactive dot plots, including a custom dot-size legend since plotly still lacks that capability.
* Added the `example_markers` dataset, a simulated single-cell marker-gene
  expression table (immune cell types × marker genes) used as the default
  example data for the DotPlot module.
* Added an "Interactive Summary" download button at the bottom of every module's
  control panel. The button produces a self-contained interactive HTML report
  containing the plotly plot, a full table of the plot data (retrieved
  via `plotly::plotly_data()`), and for modules with statistics enabled
  (Box / Violin / yPlot), a table of the statistics summary. Summary downloads
  are now built from the exported `create_interactive_summary_data()` and
  `.create_download_file()` helpers, and each module server returns its summary
  reactive so it can be reused (e.g. by the Panel Builder).
* The Panel Builder app's *Download Summary* button now bundles every plot on
  the canvas into a single `.zip` (one set of files per panel), built entirely
  in R via `.create_download_file()`.
* Fixed a Panel Builder bug where plots added after the first few rendered blank.
  Newly inserted plots are now nudged to resize once Plotly finishes its
  asynchronous render, so every plot on the canvas draws regardless of how many
  are added.
* Statistic helper functions are now public function allowing users to annotate plotly graphs with custom statistics: 
`compute_pairwise_stats()`, `create_stat_annotations()`,
`apply_stat_annotations()`, `generate_pair_strings()`,
`parse_pair_strings()`, and `write_stats_csv()`.
* Faceting improvements - new internal helpers that control subplot spacing, subplot size, and facet_scale handling. This fixes much of the wonkiness for plots with many panels.
* Condensed package wide workflows with simple helpers e.g. `.apply_title_layout()`.

# VizModules 0.1.1

* Minor DESCRIPTION and doc fixes for CRAN compliance.

# VizModules 0.1.0

* Submitted to CRAN.
