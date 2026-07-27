# VizModules 0.3.0

## New Modules

* Turned the Figure Builder into a reusable, namespaced Shiny module (`figureBuilderUI()` / `figureBuilderServer()`), so it can be embedded inside a larger app and instantiated more than once, just like the plot modules. `figureBuilderApp()` is now a thin wrapper around this module and keeps its existing behaviour. The canvas CSS/JS was made namespace-safe (class-based, per-instance) so multiple builders can coexist on one page.
  * Panel labels (a, b, c ...) now render live on the canvas as soon as they are chosen from the "Panel labels" menu (and renumber as panels are added, removed, or dragged), instead of only appearing in the exported SVG.
  * Moved the Figure Builder app into an exported `figureBuilderApp()` function so it can be launched directly (`figureBuilderApp()`), seeded with custom datasets via `data_list`, extended with custom modules via `module_registry`, and returned either as a `shinyApp()` object or as separate `ui`/`server` components (`return_components = TRUE`). The bundled `inst/apps/figure-builder` app is now a thin wrapper around this function.
  * Added to Gallery App.


## Improved/New Functionality

* Facet/split selectors across all modules now only offer valid faceting variables. Faceting (or splitting) is restricted to **categorical columns** (character or factor) with **fewer than 50 unique values**; numeric columns and high-cardinality categoricals are no longer selectable, preventing accidental creation of an unwieldy number of panels. This is powered by a new internal helper, `.facet_check()`, whose output populates the facet/split input choices.
* Simplified boxplot outlier hiding to rely on native plotly `boxpoints = FALSE` behaviour (via ggplot2's `outlier.shape = NA` in the `plotthis_BoxPlot` module and `dittoViz::yPlot`'s `boxplot.show.outliers` argument in `dittoViz_yPlot`), rather than post-hoc marker manipulation. Removed the now-unused internal helper `.remove_boxplot_outliers()`. This is more robust with plotly 4.12.0+.
* Added a new reusable custom Shiny input, `multiDynamicInput()` (with `updateMultiDynamicInput()`), that lets users dynamically add and remove rows of heterogeneous inputs. Each row is described by a generic `row_spec` (a named list of field specs using either a `type` alias — `select`, `text`, `numeric`, `slider`, `checkbox`, `colour` — or an arbitrary input constructor via `fn`), a `+ Add` button appends rows, each row has an `X` delete button, and fields wrap to a new line after `max_per_row` (default 4). The value returned to the server is a named list of rows (`model1`, `model2`, ...), each a named list keyed by the field names. Add/delete are handled client-side, and values are read back generically via each field's registered Shiny input binding, so any input type is supported.
  * Added vignette `vignette("using-custom-shiny-inputs")` documenting `multiDynamicInput()` usage: row_spec definition, pre-filling with `elements`, reading values, and server-side updates.
* Added generic modeling capabilities to `dittoViz_scatterPlot module`. The module's custom-model feature now supports **multiple** models at once via `multiDynamicInput()`: add as many rows as you like, each with its own model type (`lm`/`glm`/`loess`/`nls`), formula, line colour, and line width, and every valid model is fitted against the active (filtered) data and overlaid as its own line (respecting faceting). Formulas are validated by the internal `.safe_build_model()` helper to ensure safety. 
  * This includes the ability to add custom model backends via `register_model_backend()`, `get_model_backend()`, `list_model_backends()`, and `build_model_row_spec()`. Backends declare a `fit` function, a `predict` function, validated output classes, and optional extra UI `fields` that appear/hide dynamically based on the selected model type. The four built-in backends (lm, glm, loess, nls) are registered automatically at package load. Extra UI fields from backends are forwarded to `fit()` via `...`.
  * Added vignette `vignette("custom-model-lines")` documenting the model backend registry: how the pipeline works, setting model defaults, registering custom backends (with drc and mgcv examples), and how extra fields flow through to the fit function.
* Pass `defaults`, `hide.inputs`, and `hide.tabs` arguments to the module app factory functions in all module app wrappers, so that users can pre-fill or hide controls when testing modules in isolation.
* More intelligent input hiding logic so that when individual inputs are hidden (via `hide.inputs` or dynamically in response to other inputs), the remaining controls reflow to fill the space and no empty gaps are left in the UI. Input grids are now laid out with a wrapping flexbox container via `organize_inputs()`. Optional elements are handled gracefully.
* Added continuous color-scale trimming controls ("Lower Quantile", "Upper Quantile", "Lower Cutoff", and "Upper Cutoff") to the `plotthis_DotPlot`, `plotthis_BarPlot`, and `plotthis_SplitBarPlot` modules, exposing the new `lower_quantile`/`upper_quantile`/`lower_cutoff`/`upper_cutoff` arguments from plotthis 0.13.0. These controls appear only when the selected fill column is numeric.
* Added dot border controls ("Border Color" and "Border Size") to the `plotthis_DotPlot` module, exposing the new `border_color` and `border_size` arguments from plotthis 0.13.0. `border_color` is limited to a single constant color in the module UI.
* Updated the `plotthis_DotPlot` "Fill Cutoff" control to pair a numeric value with a new "Fill Cutoff Direction" selector (`<`, `<=`, `>`, `>=`), matching plotthis 0.13.0's string-expression `fill_cutoff` (e.g. `"< 18"`).
* Added annotation persistence, i.e. annotation positions persist when the plot is re-rendered. This extends to axis/facet titles and custom annotations, which means much less finagling during iterative editing.


## Bug Fixes

* Fixed broken input hiding when using `hide.inputs` and `hide.tabs` arguments in module app wrappers due to lazy UI injection via `renderUI`, which effectively overwrote the `hide` calls. `renderUI` also re-renders the input UIs every time a dataset changes - now if the dataset changes, the inputs are re-rendered but the `hide` calls are re-applied to maintain the hidden state.
* Fixed an error in `plotthis_SplitBarPlot` where the categorical text position input was not respected if the axes were flipped. Now the text position input is respected regardless of axis orientation.
* Export numerous internal helper functions for use in custom modules, particularly those related to axes, faceting, and layouts. It became apparent these were necessary as initial work began on `sciVizModules`. 
* Fixed a bug in `dittoViz_yPlot` where plot selection and outlier hiding were not respected appropriately due to a typo in the `boxplot.show.outliers` input name.
* Fixed a bug in `dittoViz_scatterPlot` where 2 `split.by` inputs caused an error due to improper checks for empty strings on a vector of elements.
* Fixed a bug in `dittoViz_scatterPlot` where highlight aesthetics weren't applied when a categorical x-axis was used.


## Deprecations and Removals

* Removed `ternaryPlot` module, as it is just a bad plot that's impossible to actually interpret or really utilize effectively.

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
* Condensed package wide workflows with simple helpers, e.g. `apply_title_layout()`, resulting in significantly less jank.
* Axis adjustments are now properly reflected in axis/legend titles for appropriate modules, e.g. `yPlot`, `scatterPlot`, `linePlot`.
* Removed a handful of spurious/non-functional inputs, particularly for the `dittoViz_scatterPlot` module.
* Custom `size.by` legends added for `plotthis_DotPlot` and `dittoViz_scatterPlot` modules, since plotly does not yet support these. 
* Update docstrings to reflect new inputs and features and clarify which parameters of underlying plotting functions may not be implemented.
* Various border fixes for faceted plots.

# VizModules 0.1.1

* Minor DESCRIPTION and doc fixes for CRAN compliance.

# VizModules 0.1.0

* Submitted to CRAN.
