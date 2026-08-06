# VizModules 0.4.0.9000

## New Modules

* Added a `ComplexHeatmap` module (`ComplexHeatmap_HeatmapInputsUI()`, `ComplexHeatmap_HeatmapOutputUI()`, `ComplexHeatmap_HeatmapServer()`, `ComplexHeatmap_HeatmapApp()`) wrapping [ComplexHeatmap::Heatmap()]. Unlike the other plotly-based modules, its interactive output is delivered via the `InteractiveComplexHeatmap` package (sub-heatmap zoom, cell hover/click/select). The incoming data frame is converted to a numeric matrix (user-selected columns, with an optional row-name column), and a curated subset of `Heatmap()` parameters (colors, clustering, labels, splitting) is exposed via UI inputs. `ComplexHeatmap`, `InteractiveComplexHeatmap`, and `circlize` are Bioconductor dependencies kept in `Suggests` with runtime guards, so the rest of the package installs without them. Ships a new `example_matrix_df` demo dataset (column-scaled `mtcars`).

## Improved/New Functionality

* Individual `defaults` entries can now be a `reactive()` or `reactiveVal()`, letting a parent app drive a module parameter from its own state (#325). Previously the only route was `update*Input()` from the parent, which is an asynchronous client round-trip and so re-rendered the plot twice per change (a visible flicker). Reactive defaults are resolved server-side in the same reactive flush as the data, so the plot renders once, while the on-screen control stays populated and user-editable. An external change takes precedence over a value the user has typed, and Reset restores the reactive's current value. Adds the exported helper `setup_reactive_defaults()`; `setup_auto_update_logic()` gains an optional `params` argument to consume its store, and `get_default()` now resolves reactive entries with `isolate()`. Modules with purely static `defaults` are unaffected. Not supported for the scatter module's compound `custom.models` input.
* Wired up `hover.data` and `hover.round.digits` in the `dittoViz_yPlot` module (#317). When no columns are selected, the module reproduces `dittoViz::yPlot()`'s default hover content, so existing plots are unchanged.
* Tweaked `multiColorPicker()` layout slightly for easier tetrising into compact UIs.
* Added ability to show/hide columns in the `dataFilter` module with DataTables' built-in column visibility controls. This is useful for hiding columns that are not relevant to the user, or for hiding columns that are used for internal logic but not meant to be displayed. The `hide.columns` argument can be used to specify which columns to hide by default, and users can toggle visibility via the DataTables UI.
* Changed to server-side rendering of `var` element for `dittoViz_yPlot` module, which is much more performant when many options exist (e.g. genes).

## Bug Fixes

* Fixed modules rendering their plot two or three times for a single change (somewhat related to #325). Several modules compute a value on the server and push it into one of their own inputs with `update*Input()`, which is an asynchronous client round-trip: the plot rendered once with the stale value and again when the client echoed the new one. On load `dittoViz_yPlot` did this three times over (y-axis range, stat comparison pairs, and the rebuilt `multiColorPicker`). 
  * These inputs are now wrapped in `freezeReactiveValue()` so dependents pause until the new value lands, giving a single render. Applied to the y-axis range (`dittoViz_yPlot`, `plotthis_BoxPlot`, `plotthis_BarPlot`, `plotthis_ViolinPlot`), `stat.pairs` (`dittoViz_yPlot`, `plotthis_BoxPlot`, `plotthis_ViolinPlot`), `facet.scale` (`plotthis_BoxPlot`), and the rebuilt colour picker in all modules with a palette selector. 
  * Added a section in the "Adding a New Module" vignette describing this pattern.
* Fixed an initialization bug in `multiColorPicker()` due to string indexing rather than position, leading to out of bounds errors when a group label was an empty string.
* Fixed axis titles not reflecting applied data adjustments in the `dittoViz_yPlot`, `dittoViz_scatterPlot`, and `linePlot` modules (#321). The annotation-persistence feature added in 0.3.0 was re-applying the previously captured title text on every rebuild, clobbering the freshly generated adjustment-aware label (e.g. `log2(units)`). Axis titles carrying an active adjustment are now always regenerated, while a manually edited title with no adjustment still persists and the dragged title position persists in all cases. `finalize_manual_edits()` gains a `regen_keys` argument to drive this. Axis titles are also regenerated (rather than persisted) when the plotted variable for that axis changes, via the new exported helper `reset_axis_title_text()`, since a manual title only makes sense for the variable it was written for. Shared axis titles in faceted `linePlot`/`dumbbellPlot` figures (built via `build_facet_annotations()`) are now tagged as axis annotations so their dragged position survives label changes; as a result they now pick up the axis-title font settings rather than the facet-title font settings.
* The main plot title is now blank by default in the `dittoViz_yPlot` and `dittoViz_scatterPlot` modules (previously dittoViz's `main = "make"` auto-generated a title from the variable name and regenerated it on every re-render). Users can still add a title interactively by editing it on the plot.


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
