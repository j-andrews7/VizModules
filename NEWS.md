# VizModules 0.1.2

* Added a new `plotthis_DotPlot` module (`plotthis_DotPlotInputsUI()`,
  `plotthis_DotPlotOutputUI()`, `plotthis_DotPlotServer()`, and the
  `plotthis_DotPlotApp()` convenience wrapper) that wraps `plotthis::DotPlot()`
  for interactive dot plots, including a custom dot-size legend.
* Added the `example_markers` dataset, a simulated single-cell marker-gene
  expression table (immune cell types × marker genes) used as the default
  example data for the DotPlot module.
* Added an "Interactive Summary" download button at the bottom of every module's
  control panel. The button produces a self-contained interactive HTML report
  containing the plotly plot, a searchable table of the plot data (retrieved
  via `plotly::plotly_data()`), and for modules with statistics enabled
  (Box / Violin / yPlot) a table of the statistics summary.
* Statistic helper functions are now public function allowing users to annotate plotly graphs with custom statistics: 
'''r
compute_pairwise_stats()
create_stat_annotations()
apply_stat_annotations()
generate_pair_strings()
parse_pair_strings()
write_stats_csv()
'''
* Faceting improvements - New internal helpers that control subplot spacing, subplot size, and facet_scale handling.
* Condensed package wide workflows with simple helpers.

# VizModules 0.1.1

* Minor DESCRIPTION and doc fixes for CRAN compliance.

# VizModules 0.1.0

* Submitted to CRAN.
