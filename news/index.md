# Changelog

## VizModules 0.2.0

- Created the Figure Builder app so that users can dynamically construct
  multi-panel figures using different data sets and plot types on a
  single page. Allows for full page SVG export, source data dump
  organized per panel, and full customization of plot position and size.
- All `*OutputUI()` functions gained a `resizable` argument (default
  `TRUE`). When `FALSE`, the plot output is no longer wrapped in
  [`shinyjqui::jqui_resizable()`](https://yang-tang.github.io/shinyjqui/reference/Interactions.html),
  which avoids a redundant resize handle when the output is embedded in
  a container that already provides resizing (such as the Figure Builder
  app cards).
- Added a new `plotthis_DotPlot` module
  ([`plotthis_DotPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotInputsUI.md),
  [`plotthis_DotPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotOutputUI.md),
  [`plotthis_DotPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotServer.md),
  and the
  [`plotthis_DotPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_DotPlotApp.md)
  convenience wrapper) that wraps
  [`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
  for interactive dot plots, including a custom dot-size legend since
  plotly still lacks that capability.
- Added the `example_markers` dataset, a simulated single-cell
  marker-gene expression table (immune cell types × marker genes) used
  as the default example data for the DotPlot module.
- Added “Source Data” download button at the bottom of every module’s
  control panel. The button creates and downloads a ZIP file containing
  a self-contained HTML of the plotly plot, a CSV of the plot data
  (retrieved via
  [`plotly::plotly_data()`](https://rdrr.io/pkg/plotly/man/plotly_data.html)),
  and for modules with statistics enabled (Box / Violin / yPlot), a
  table of the statistics info. Source downloads are now built from the
  exported
  [`collect_source_data()`](https://j-andrews7.github.io/VizModules/reference/collect_source_data.md)
  and
  [`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md)
  helpers, and each module server returns its source reactive so it can
  be reused (e.g. by the Figure Builder). Given source data is now
  required by many journals, this is important.
- Removed old interactive plot download button and associated helper
  function.
- Removed old dynamically hidden stats download button and associated
  logic, since stats are now included in the source download when
  applicable.
- Statistic helper functions are now exported allowing users to annotate
  plotly graphs with custom statistics:
  [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md),
  [`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md),
  [`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_stat_annotations.md),
  [`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/generate_pair_strings.md),
  and
  [`parse_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/parse_pair_strings.md).
- Exposed
  [`empty_plot()`](https://j-andrews7.github.io/VizModules/reference/empty_plot.md)
  for use as a placeholder, e.g. if parameters aren’t valid for a given
  plot type, to pass that info to user without ugly error messages.
- Faceting improvements - new internal helpers that control subplot
  spacing, subplot size, and facet_scale handling. This fixes much of
  the wonkiness for plots with many panels. Still imperfect, but much
  improved.
- Condensed package wide workflows with simple helpers,
  e.g. `.apply_title_layout()`, resulting in significantly less jank.

## VizModules 0.1.1

CRAN release: 2026-04-08

- Minor DESCRIPTION and doc fixes for CRAN compliance.

## VizModules 0.1.0

- Submitted to CRAN.
