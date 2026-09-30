# VizModules 0.6.0.9000

## Improved/New Functionality

### Helpers and exported functions

* Exported the helpers that modules share, so modules in extension packages can reuse them instead of keeping copies that drift (#369). Each used to be internal and is documented on the reference site.
  * Facet titles and spacing: `toggle_facet_title_inputs()` (with `main_title_input_ids`) swaps the main-title inputs for the `facet.title.*` inputs while a plot is faceted, and `uniform_subplot_spacing_inputs_ui()` (with `subplot_spacing_defaults()`) provides the subplot spacing controls that `reset_plotly_inputs()` and `apply_facet_subplot_spacing()` already expect.
  * Group colours: `default_group_colors()` validates and hex-normalises a colour mapping in `defaults`, and `reset_group_colors()` restores a group colour picker to it on Reset.
  * Stats tab: `uniform_stats_inputs_ui()`, `reset_stats_inputs()`, `default_stat_pairs()`, `stat_bracket_headroom()` and `note_brackets_skipped()`.
  * Module server boilerplate: `require_data_frame()`, `nz_value()`, `blank_to_null()`, `na_to_null()`, `facet_check()`, `flatten_palette_options()`, `reset_manual_edits()` and `with_stable_seed()`, which keeps jitter from jumping on every rebuild.
  * Drawn values: `as_plotted()`, `adjusted_values()` and `adjustment_fn()`, for anything drawn over an adjusted plot.
  * Point highlighting and labelling: `apply_highlight_styling()`, `create_highlight_annotations()`, `create_selected_annotations()`, `merge_annotation_sets()` and `parse_highlight_values()`.

# VizModules 0.5.0

The one where we make the heatmap module not suck and stop accidentally butchering app CSS.

## Improved/New Functionality

### All modules

* **Source Download** now also saves a `<name>_plot.svg` and a `<name>_plot.png` of each plot (#353). The Figure Builder saves one pair per panel, named after the panel's label.
  * The images are captured in the browser from the graph as displayed, so they include everything applied after the figure was built. The button pauses briefly while capturing; if capture fails, the archive still downloads without them.
  * A WebGL plot (the scatter plot's WebGL toggle) can only be captured as a raster, embedded in an otherwise editable SVG. Turn WebGL off for a fully editable file.
  * A module whose output isn't a plotly graph can draw itself instead, via `vector_svg` and/or `raster_png` functions of `(width, height, res)` on its summary list or on the reactive its server returns. `ComplexHeatmap_HeatmapServer()` provides both.
* Without pandoc, which `htmlwidgets::saveWidget()` needs, the source download now warns and leaves out the self-contained HTML instead of writing an empty `.htm`, so the data and images still download.
* The shared **Legend** tab gained **Show Legend**, **Legend Font** and **Legend Font Color** (#360, #362). The legend can now be hidden in `yPlot`, `freqPlot`, `linePlot`, `dumbbellPlot` and the `plotthis` modules too, and hiding it also hides colorbars and the scatter/`DotPlot` size legend.
* Each module's app now opens on defaults that show more of what it can do, with more interesting example datasets to match.

### Module gallery and Figure Builder

* The module gallery is now a function, `moduleGalleryApp()`, with a tab per module plus the **Figure Builder**. The bundled `inst/apps/module-gallery` app is a thin deployment wrapper around it.
* The `ComplexHeatmap` module can now be added to the **Figure Builder** (#352).
  * The figure export read an SVG out of each panel's plotly graph, so any other kind of panel contributed only its label. A module can now attach a `vector_svg` attribute (a `function(width, height, res)` returning an `<svg>`) to the reactive its server returns, and the export uses that instead.
* `figureBuilderServer()`, `figureBuilderApp()` and `createModuleApp()` accept a `data_list` entry that is a *list* of data frames, as the `ComplexHeatmap` module needs. `createModuleApp()` filters and displays only the primary table (`primary.table`, default the first) and passes the others through untouched. It also gained `sidebar.width`.

### `BoxPlot`, `freqPlot` and `yPlot`

* `stat.pairs` can be set from `defaults`, as `"A vs B"` strings in either order.

### `ComplexHeatmap`

* Added `ComplexHeatmap_HeatmapStaticOutputUI()`, a plain `plotOutput()` of the same heatmap. It gives up cell hover/click, the sub-heatmap and the brush info panel, and with them all of the widget's own chrome. The gallery and `ComplexHeatmap_HeatmapApp()` keep the interactive widget.
* Row and column splits gained an **"Annotation"** method (#349), slicing by one or more annotation columns (several give nested slices). With clustering off it is also the fast path, since no distance matrix is needed.
* New **Filter** tab with expression-based row and column filters (#346), so a subset can be plotted without the `dataFilter` module. Row filters see the matrix data frame; column filters see a `column` field plus any per-sample metadata joined via `column_key`. Filtering runs first, so scaling, annotations, splits and the source download all describe the filtered matrix.
  * Both filters are debounced by 700ms, so typing doesn't redraw the heatmap on every keystroke. The "Adding a New Module" and "Building Custom Modules" vignettes document the pattern for free-text inputs.
* New **Show Row Slice Titles** and **Show Column Slice Titles** checkboxes (#366). Clearing the title box never removed the group names a split titles its slices with (annotation values, or cluster numbers for k-means and hierarchical splits), because `Heatmap()` reads a blank title as "use the group names". Unticking one drops the titles and the space they take. A typed title still replaces them, and a `%s` in it is filled in with each group's name.
* Each annotation track gained **Label Side**, **Label Size** and **Show Legend** controls. Set the last from `defaults` with a `show_legend` field on a `row_annotations`/`column_annotations` row.
* The output UI functions gained `fit.width` (default `TRUE`), fitting the widget's panels to their container on load (#350) instead of `InteractiveComplexHeatmap`'s fixed pixel widths. `heatmap_fit_width()` does the same for apps calling `InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()` directly.
* `ComplexHeatmap_HeatmapApp()`'s default data now exercises the column annotation, split and filter features.

### `dumbbellPlot`

* New **Point Size** input (`point.size` in `dumbbellPlot()`, default 12) (#361).

### `linePlot`

* **Error Bars** can now show the standard deviation (still the default), the standard error of the mean, or a 95% confidence interval (#368), through the new **Error Bar Type** input (`error.type` in `linePlot()`). A confidence interval uses the normal approximation unless the **Confidence Interval Method** input (`error.ci.method`, shown only while a CI is selected) switches it to the t distribution, which is wider for small groups. A group with fewer than two observations is drawn without a bar. The tooltips say what the bars show (the plotted group mean plus or minus that amount).

### `parallelCoordinatesPlot`, `piePlot` and `radarPlot`

* The shape-drawing controls are gone, since plotly's drawing tools need cartesian axes and they did nothing here. The pie and radar modebars no longer offer the drawing buttons either. `uniform_plotly_inputs_ui()` gained `include.shapes` for this.

### `scatterPlot` and `yPlot`

* The **Adjustment Function** now runs before the z-score/relative-to-max **Adjustment** (log10, then z-score), and axis titles read accordingly (`z-score(log10(salary))`). dittoViz does the reverse, which took the log of every below-average value, so those points vanished. The rescaling also skips non-finite values, so a `log(0)` drops that one point instead of making the whole column `NaN`.

### `SplitBarPlot`

* **Facet Scale** now defaults to `"fixed"` rather than `"free_y"`.

### Helpers and exported functions

* Exported `draw_to_svg()` (previously the internal `.draw_to_svg()`) and added `draw_to_png()`. They render any grid or base drawing, for the `vector_svg`/`raster_png` hooks above.
* `safe_eval_filter()` and `validate_expression()` now share one allowlist and AST walker (each had its own copy), with a wider but still pure vocabulary: `grepl`, `startsWith`, `endsWith`, `substr`, `nchar`, `toupper`, `tolower`, `trimws`, `abs`, `round` and `xor`.
* `adjust_column_values()` gained `x.adjustment`, `y.adjustment` and `color.adjustment` (`"z-score"`, `"relative.to.max"`), reproducing exactly what the modules plot. Use it to compute anything drawn over such a plot.
* `create_stat_annotations()` gained `free.y`, stacking each facet panel's brackets above that panel's own data, and `apply_stat_annotations()` then raises each panel's axis separately.
* `apply_legend_styling()` gained `show`, `font.family` and `font.color`, and the new `apply_legend_inputs()` applies the whole **Legend** tab from a module's inputs.
* `collect_source_data()` accepts `inputs_reactive` as a reactive, as documented, as well as a plain list.

## Deprecations and Removals

### Module gallery and Figure Builder

* The Figure Builder no longer accepts `.rds` uploads.
* Removed the bundled `inst/apps/figure-builder` app, since the builder is part of the gallery now.

### `BarPlot` and `SplitBarPlot`

* Removed the **Split By** input. It returns a patchwork object, which `ggplotly()` can't convert, so it never did anything.

### `scatterPlot`

* Removed the built-in `nls` backend for custom model lines. An nls formula names its parameters, which the formula safety check rejects, so it could never fit.

### `ViolinPlot`

* Removed the `plotthis_ViolinPlot` module (`plotthis_ViolinPlotApp()`, `plotthis_ViolinPlotInputsUI()`, `plotthis_ViolinPlotOutputUI()`, `plotthis_ViolinPlotServer()`) (#358). `plotthis` 0.14.0 draws violins with a geom of its own that `ggplotly()` can't convert, and `yPlot` covers the same ground. Use `dittoViz_yPlot` with `defaults = list(plots = "vlnplot")`, adding `"boxplot"`/`"jitter"` for the inner box and points.

## Bug Fixes

### All modules

* **Reset** now discards manually dragged legends, annotations, axis titles and colorbars. It also returns every control to the value it started at; several fallbacks disagreed with the UI (`stat.hide.ns`, the top and right margins, subplot spacing, and a few module-specific ones).
* Stopped the package's stylesheets leaking into host apps (#355). CSS still sucks.
  * `multiColorPicker`'s dropdown, which is parented to `<body>`, was styled through selectize's generic class names. That restyled every `selectInput()` and DT column filter on the page, most visibly rendering long dropdowns as an empty panel. Every plot module has a colour picker, so this affected any app using any module. The rules are now scoped to the picker's own `.mc-palette-dropdown`.
  * The Figure Builder styled `.well`, so embedding it respaced every `sidebarPanel()` on the page. Its rules are now scoped to `.pb-app`.
  * `organize_inputs()` used inline negative margins that assume a padded parent, so in a narrow sidebar the grid overhung and scrolled sideways, and undoing that took `!important`. It now uses a stylesheet and a column gap; only the column count is still inline, as `--viz-input-columns`.
* Faceted plots no longer offer an editable main title, whose empty placeholder sat over the facet panel titles and caught the clicks meant for them. The **Title** inputs are hidden and the facet title inputs shown while a plot is faceted, without re-showing anything hidden via `hide.inputs`. `yPlot` now also counts several Y variables split into panels as faceted.
* Multi-selects no longer drop a deselection made from a value tag's x (or the clear-all x). `viz_select_input()` reports a multi-select when its dropdown closes, and removing a tag never opens it.
* An input that has not reported yet (`NULL`) no longer throws "argument is of length zero" while a module initializes.
* The source download no longer writes the captured plot images (up to tens of MB) into `*_ui_inputs.csv`.
* The **Lines** tab's line-type tooltips list the names actually accepted.

### Module gallery and Figure Builder

* The module gallery passes its `defaults` to the module servers too, so Reset matches the initial state.

### `AreaPlot`

* **Group By** and **Facet By** no longer leave out the dataset's first categorical column when it isn't the X column, which silently dropped a `group.by`/`facet.by` default naming it.

### `BarPlot`, `BoxPlot`, `SplitBarPlot` and `yPlot`

* Axis limits given in `defaults` (`y.min`/`y.max`, or `x.min`/`x.max` in `SplitBarPlot`) are no longer replaced by the data's range at startup; they stand until the plotted columns change. `yPlot`'s keys are now `y.min`/`y.max` too, matching its inputs and Reset (its UI read `min`/`max`).
* **Reset** restores the `BoxPlot` and `BarPlot` y limits for the column it resets `y.data` to. It measured the first numeric column, which clipped a plot whose default `y.data` was another one.

### `BoxPlot`

* **Security:** **Sort X By** was passed straight to `plotthis::BoxPlot()`, which evaluates it, so R code typed there ran on the server. It now goes through the same expression check as every other user-typed expression, allowing summary functions (`mean`, `median`, `sd`, ...) and ignoring anything else with a notification.

### `BoxPlot`, `freqPlot` and `yPlot`

* Boxes, points and significance brackets now line up when a `color.by` group is missing from some `group.by` categories (#356). The new `.align_box_positions()` puts the boxes back on ggplot's coordinates under plotly's `boxmode = "overlay"`, replacing the old faceting workaround.
  * Brackets now use the same dodge as the boxes rather than a formula of their own, and a comparison against a group with no data in that category (an NA p-value) is no longer drawn as "NA" at an invented position.
  * A panel is now identified by its *pair* of axes, which mattered for any facet grid more than one row deep (so most `freqPlot`s). Box width comes from the most crowded x position in the whole figure, so boxes no longer change size between facets.
  * `boxmode = "overlay"` is only set once every box has an explicit position, where it could leave boxes stacked on a categorical tick. The `boxgap`/`boxgroupgap` attributes plotly's schema rejects are no longer set, which silences a pile of rebuild warnings.
* Overlays are now computed from the values drawn, after any Y adjustment, rather than from the raw columns (#319, #365).
  * `yPlot` brackets were drawn at raw heights under a Y adjustment (log10, z-score, ...), far above the axis, and tested on the raw values. Tests, brackets and the **Y Axis Min/Max** now all use the adjusted values; the limits used to be ignored whenever an adjustment was on.
  * `yPlot` and `freqPlot` brackets could be clipped even without an adjustment. `apply_subplot_axis_styling()` queued a copy of each whole axis, which reverted the raised range at build time; it now queues only the styling.
  * Under a free y facet scale, each panel now keeps its own range and its brackets sit above its own data. `yPlot` and `freqPlot` pinned every panel to the **Y Axis Min/Max**, and all three drew brackets at the tallest panel's height (and, after the first panel, on the first panel's axis).
  * A rotated `BoxPlot`, or a `yPlot`/`freqPlot` that includes a ridge plot, puts the values on the x-axis, where brackets were drawn across the category axis. They are now skipped with a notification, and the test results still go in the source download.
* The source download no longer ships a stale statistics CSV after stats are turned off.
* Significance labels for a p-value below 0.0001 read "< 0.0001" rather than rounding to "0".

### `ComplexHeatmap`

* Every module-hosted heatmap silently never drew. `InteractiveComplexHeatmap` registers heatmaps under `validate_heatmap_id()`, which turns each non-word character into `_`, but the module looked up the raw namespaced id (`mymod-heatmap-Heatmap`), found nothing, and returned before `makeInteractiveComplexHeatmap()` could run. A module id always contains a `-`, so every instance rendered an empty shell with no error.
* Default annotations now render their colour pickers and tracks on load. `multiDynamicInput()` reports its initial rows to Shiny before deferred DOM binding, omitted fields backfill from `row_spec`, and the server resolves palettes immediately.
* The `compact = TRUE` widget (and any `output_ui_float = TRUE`) no longer adds a ~10,000px horizontal scrollbar to the host app.
* With **Auto Update** off, the matrix columns, row names, filters and column key no longer redraw the heatmap before **Update**.

### `dataFilter`

* `dataFilterServer()` no longer applies the previous table's row indices to newly supplied data while DT redraws.

### `dumbbellPlot`

* **Colour By** "Y variables" now matches the colour picker, keeps each category's colour across facets, and gives every category a legend entry (only the first had one). `dumbbellPlot()` matches a named `palette.selection` by name.
* A faceted plot now draws a border around every panel rather than only the first, which was the only one with a y axis to draw its edges.

### `dumbbellPlot` and `linePlot`

* **Axis Title Size/Color/Font** and **Facet Title Size/Color/Font** now work (#326), as do **Show X/Y Gridlines** and **Gridline Color** (`dumbbellPlot` ignored all three, `linePlot` the colour). `dumbbellPlot()` and `linePlot()` gained the matching `axis.title.font.*`, `facet.title.font.*`, `show.grid.*` and `grid.color` arguments, and `build_facet_annotations()` gained `axis.title.font` and `facet.title.font`.
* Facet titles now sit directly above their own panel under shared (fixed) axes. `build_facet_annotations()` fell back to an even grid that ignored the panel gaps, which put lower rows' titles up against the row above.
* No more plotly default zero line, which couldn't be turned off. Add one from the **Lines** tab instead (#363).

### `freqPlot`, `scatterPlot` and `yPlot`

* Values containing spaces (e.g. `"CD4 T"`) can now be highlighted when separated by commas or new lines. They were split on the space and so never matched.
* Highlight and selection labels are no longer drawn for points an adjustment leaves undrawable (`NaN`), which plotly placed at an arbitrary spot (#319, #365). Dumbest thing.

### `linePlot`

* A faceted plot no longer repeats every series in the legend once per facet, and one legend click now toggles that series in every panel (#357).
* Multi-axis plots no longer draw an empty placeholder trace that took up a nameless legend entry in every facet, and `show.legend = FALSE` now hides the legend box instead of leaving an empty one.
* Logical and Date columns no longer break the plot; `is_pure_type()` errored on them.
* **Error Bars** sat on the wrong points whenever **Group By** was set, so each series drew other series' bars (the gallery's default line plot included). plotly re-sorts the data by the colour column but not an error bar array handed to it, so `linePlot()` now sorts the same way first. Bars also silently vanished when the data had a column named `y`, which shadowed the argument inside `summarise()`.

### `parallelCoordinatesPlot`

* `parallelCoordinatesPlot()` tolerates a blank line width.

### `scatterPlot`

* Linear, best-fit and custom model lines are now fit to the plotted values (#319, #365). They were fit to the raw columns, so on adjusted axes they were drawn off in their own space. A formula like `mpg ~ hp` models what is shown (don't repeat the adjustment in it), no lines are drawn when `as.factor` makes an axis categorical, and a numeric **Color By** gives one line instead of one per distinct value.
* Fit lines no longer land in the wrong facet panel. Character facets are laid out alphabetically, and multi-row or two-column `split.by` layouts share axes by row and column; lines are now matched to panels by their strip labels.
* A custom model formula calling a function through a namespace (`y ~ base::log(x)`) crashed the render with "the condition has length > 1" instead of reporting a disallowed term, while `y ~ log()(x)` was accepted. `.safe_build_model()` had its own copy of the AST walker and now shares the one in `R/parse_utils.R`. It also returns `NULL` rather than an error for an empty formula.
* With **Auto Update** off, the fit-line controls no longer redraw the plot before **Update**.

### `SplitBarPlot`

* The axis no longer clips a long negative bar beside short positive ones, or inverts when every value is negative.
* **Category Label Position** can be negative again, moving the labels further out from their bars (#367).

### Helpers and exported functions

* `validate_expression()` and `safe_eval_filter()` checked only the first statement of their input. `validate_expression()` returned the whole string for its caller to evaluate, so anything after a `;` or a newline went unexamined, and `safe_eval_filter()` evaluated only the first clause, returning a row mask nobody asked for. Both now reject multi-statement input.
* `draw_to_svg()` returns `NULL` instead of erroring when the build has neither `svglite` nor a working cairo, matching `draw_to_png()`. That includes macOS without XQuartz, where `capabilities("cairo")` is `TRUE` but the device can't load.
* `multiColorPicker()` applies unnamed `colors` in order instead of ignoring them.
* `apply_axis_title_to_annotations()` tolerates annotations without an `xanchor`, and `safe_resolve_adj_fxn("neg_log10")` works from outside the package.

## Documentation

* Added the `ComplexHeatmap_Heatmap` and `dittoViz_freqPlot` modules to the README, and refreshed the skills for the 0.4.0 changes they had missed (#348).
* The `quick-start`, `custom-modules` and `adding-a-new-module` vignettes now point at the bundled agent skill that covers their material, and at `use_vizmodules_skills()` (#347). The skills were previously documented only in the README.
* Fixed out of date vignette examples.
* The bundled skills and the `defaults-and-hiding` and `adding-a-new-module` vignettes now cover the `linePlot` error bar `defaults` keys, the heatmap slice title toggles, `hide.inputs` outranking a module's own show/hide, and two plotting traps behind the #368 fixes (plotly re-sorting by the colour column, and dplyr masking an argument).

# VizModules 0.4.0

## New Modules

* Added a `freqPlot` module (`dittoViz_freqPlotInputsUI()`, `dittoViz_freqPlotOutputUI()`, `dittoViz_freqPlotServer()`, `dittoViz_freqPlotApp()`) wrapping [dittoViz::freqPlot()], for comparing the per-sample composition of a categorical variable across groups. Unlike the other modules it does not plot columns of the incoming data, it tabulates how often each level of the chosen variable occurs within each sample and plots those frequencies, one facet per level. The axis limits, statistics, point annotations and source download therefore all describe that summarised frequency table rather than the input rows.
  * Comes with a new `example_composition` demo dataset containing 1800 simulated single-cell records over twelve donors nested inside two conditions (and crossed with two batches).

* Added a `ComplexHeatmap` module (`ComplexHeatmap_HeatmapInputsUI()`, `ComplexHeatmap_HeatmapOutputUI()`, `ComplexHeatmap_HeatmapServer()`, `ComplexHeatmap_HeatmapApp()`) wrapping [ComplexHeatmap::Heatmap()]. Unlike the other plotly-based modules, its interactive output is delivered via the `InteractiveComplexHeatmap` package (sub-heatmap zoom, cell hover/click/select). The incoming data frame is converted to a numeric matrix (user-selected columns, with an optional row-name column), and a curated subset of `Heatmap()` parameters is exposed via UI inputs.
  * Row and column annotation tracks can be added on the "Annotations" tab dynamically. Row annotations come from extra columns in the input data frame; column annotations need a companion per-sample metadata table, supplied via `data = list(matrix = <data.frame>, column_annotations = <data.frame>)` instead of a plain data frame.
  * The interactive output can be split into independently-placed pieces — `ComplexHeatmap_HeatmapMainOutputUI()`, `ComplexHeatmap_HeatmapSubOutputUI()`, `ComplexHeatmap_HeatmapInfoOutputUI()` — for apps that want the main heatmap, sub-heatmap, and click/brush info panel in separate layout locations. `ComplexHeatmap_HeatmapOutputUI()` also has a `...` passthrough for `InteractiveComplexHeatmapOutput()`'s `layout`, `compact` (a smaller-footprint mode that drops the sub-heatmap panel and floats the click/brush info near the cursor), and other arguments.
  * Comes with a new `example_heatmap_matrix` (30 genes x 12 samples, with row-annotation columns) and `example_heatmap_column_data` (companion per-sample metadata, for column annotations) demo datasets.

## Improved/New Functionality

* The package now contains three agent skills under `inst/skills/`, installable into a project with the new exported `use_vizmodules_skills()`: `vizmodules-app` (wiring modules into an app), `vizmodules-custom-module` (building wrapper modules), and `vizmodules-new-module` (authoring a module in this package). They follow the [Agent Skills](https://agentskills.io) `SKILL.md` convention, so GitHub Copilot, OpenAI Codex, Claude Code, and compatible tools can discover them. `use_vizmodules_skills()` gains a `client` argument (`"agents"` by default, or `"github"`/`"claude"`) to install into `.agents/skills/`, `.github/skills/`, or `.claude/skills/` as needed.
  * Benchmarked against the README's LLM-instruction prompt over 18 paired runs (#341). Building an app  the clear win - half the tokens (66k vs 123k) and 40% of the wall time, with identical correctness. Wrapping a module was inconclusive, and authoring a module was cost-neutral. Every run in both arms passed every assertion, so the skills' measured value is efficiency on lookup-heavy work rather than improved output.
  * Each skill carries the traps that cost benchmark runs real time: `useShinyjs()` being required in a hand-built app for `hide.inputs`/`hide.tabs` to work, pandoc being required by `create_source_download_handler()`, `stat.hide.ns` defaulting to `TRUE` so an enabled Stats tab can draw nothing, and `shiny::testServer()` being unable to drive a plotly output.

* The `dittoViz_yPlot` module gained an "Annotations" tab that highlights and labels individual jitter points, matching the `dittoViz_scatterPlot` module (#340). 
  * The annotation controls are now the exported helpers `uniform_annotation_inputs_ui()` and `reset_annotation_inputs()`, so other modules that draw individual points can pick them up, and `dittoViz_scatterPlot` now uses them rather than its own copy.
  * `dittoViz_yPlot`'s jitter positions are now drawn from a fixed seed, so they no longer reshuffle on every rebuild. Selections and annotations therefore stay attached to the points they were made on, and a plot redrawn with the same settings is reproducible.
  * Box/lasso selections are now matched to their points by index rather than by coordinates, so a label survives the rebuild that the selection itself triggers. Selections are cleared when the plot's structure changes (Y data, grouping, color, shape, facet or plot types), since the indices only describe the layout they were captured on.
* Every module can now be initialized with an explicit group-to-color mapping via `defaults` (#334). Pass a named character vector under the module's color input key, e.g. `defaults = list(palette.colours = c(setosa = "red", virginica = "#0072B2"))`, and the color picker is seeded with it. 
  * Precedence runs picker > `defaults` > the module's stock palette, so a plot can open on a specific palette while every color stays editable, and groups the mapping does not name still get a sensible default. Reset restores the supplied mapping rather than the stock palette. 
  * Keys are `palette.colours` for most modules, `color.panel` for `dittoViz_scatterPlot`, `slice.colors` for `piePlot`, and `trace.colors` for `radarPlot`; the ungrouped single-color controls (`single.point.color`, `single.fill.color`, `single.color`) and the continuous palette selectors (`palette.name`, `gradient.palette`) are now seeded from `defaults` too. Since individual `defaults` entries may be reactive, a parent app can also drive the palette from its own state. `resolve_palette()` gains a `manual_colors` argument implementing the layering.
* The figure builder now passes each panel's `defaults` to the module server as well as to its inputs UI, so registry defaults can seed server-rendered controls such as the color picker.
* Source data downloads are now more robust and now limit to the data actually shown on the plot rather than the entire input dataframe. This makes download snappier and keeps plot source data contained, which is important for publication. The switch to `viz_select_input` (described below) also required some changes to handle empty vectors/`NULL` values appropriately.
* Individual `defaults` entries can now be a `reactive()` or `reactiveVal()`, letting a parent app drive a module parameter from its own state (#325). Previously the only route was `update*Input()` from the parent, which is an asynchronous client round-trip and so re-rendered the plot twice per change (a visible flicker). Reactive defaults are resolved server-side in the same reactive flush as the data, so the plot renders once, while the on-screen control stays populated and user-editable. An external change takes precedence over a value the user has typed, and Reset restores the reactive's current value. Adds the exported helper `setup_reactive_defaults()`; `setup_auto_update_logic()` gains an optional `params` argument to consume its store, and `get_default()` now resolves reactive entries with `isolate()`. Modules with purely static `defaults` are unaffected. Not supported for the scatter module's compound `custom.models` input.
* Wired up `hover.data` and `hover.round.digits` in the `dittoViz_yPlot` module (#317). When no columns are selected, the module reproduces `dittoViz::yPlot()`'s default hover content, so existing plots are unchanged.
* The `dittoViz_yPlot` module's "Y Data" input can now take several columns at once (selecting more than one previously errored while computing the y-axis range). 
  * New "Multivar Aesthetic" and "Multivar Split Dir" controls on the Facet tab expose `dittoViz::yPlot()`'s `multivar.aes`/`multivar.split.dir`, so the selected variables can each get their own facet (the default), sit side by side on the x-axis, or be mapped to the fill legend (in which case the colour picker keys off the variable names, since they are what is being coloured). The y-axis limits span every selected variable, the axis title drops the column name once it no longer describes the shared axis (keeping any adjustment, e.g. `log2(z-score)`), and the facet-specific handling (subplot spacing, boxplot dodging, shared axis titles) now also applies to variable facets. 
  * Statistics are computed separately within each variable's facet; the Stats tab is hidden for the "group" and "color" aesthetics, and when a `split.by` facet is combined with several variables, as significance brackets cannot be placed against those layouts without stuff getting hella complicated in ways the current stats implementation cannot yet handle. Ideally, this will be supported in the future but will take some thoughtful work to implement in a robust way.
* Every module select input is now a virtualised, searchable dropdown built on `shinyWidgets::virtualSelectInput()` (#330). Previously a select fed by a high-cardinality column (e.g. `var` in `dittoViz_yPlot` on a genome-wide table) rendered every option, producing a dropdown that was both slow and impossible to pick from even with max options set. Only the visible slice is rendered now, so tens of thousands of options stay usable, and long lists gain a search box automatically. Adds the exported helpers `viz_select_input()` and `update_viz_select()` for use in custom modules. Three widgets deliberately stay native because client-side JavaScript reads them directly: the figure builder's "Panel labels" menu, `multiColorPicker()`'s palette picker, and `multiDynamicInput()`'s select rows.
* `dataFilterServer()` gains `filter.max.options` (default `50`), capping how many options a factor column's DataTables filter dropdown renders at once. Typing still searches the full set. Note that DT serialises every level of a factor column into the page regardless, so `factor.char.cols = TRUE` remains a poor fit for columns with very many distinct values.
* The `dataFilter` table's controls now sit on a single row for better use of space. With `col.visibility = TRUE` the module used DataTables' `Blfrtip` layout, which stacks the "Columns" button, the page-length select and the search box in three full-width blocks, wasting three rows of vertical space above the table. They now share one flex row with the search box aligned to the far end, styled by CSS the module ships itself.
* Tweaked `multiColorPicker()` layout slightly for easier tetrising into compact UIs. Elements should now reflow more appropriately to prevent label/control overlaps in narrow contexts.
* `multiColorPicker()` no longer reports a value for every step of a colour choice, so a dependent plot is rebuilt once per colour rather than dozens of times. A group's swatch is a native `<input type="color">`, and the browser's colour dialog previousl fired an event for each drag or click inside it (Chrome fires `change` just as often as `input`, rather than only on close). Now, the value is only reported when the input loses focus or the user moves the mouse outside it, preventing most unnecessary re-renders. Typing in a hex field is coalesced until the user pauses instead, while one-shot actions, i.e. palette swatches, "Apply", "Reset", selecting another group, and a hex code committed with Enter or by clicking away, still report immediately.
* Added ability to show/hide columns in the `dataFilter` module with DataTables' built-in column visibility controls. This is useful for hiding columns that are not relevant to the user, or for hiding columns that are used for internal logic but not meant to be displayed. The `hide.columns` argument can be used to specify which columns to hide by default (by name or position), which also removes their filter boxes for a simpler interface, and `col.visibility = TRUE` adds a "Columns" button so users can toggle visibility via the DataTables UI. Hiding is display-only: hidden columns are still present in the returned filtered data, so downstream plotting modules can use them. The name/position lookup behind `hide.columns` is exposed as the new exported helper `resolve_column_targets()`, which turns column names into the zero-based `targets` indices any hand-rolled [DT::datatable()] `columnDefs` entry needs.

## Deprecations and Removals

* Removed the `manual.colors` argument from `dittoViz_scatterPlotServer()`. It was the only module with such an argument, and it hard-overrode the color picker, so the colors it supplied could not be edited. Pass the same named vector as `defaults = list(color.panel = ...)` instead, which every module now understands and which leaves the colors editable.


## Bug Fixes

* Corrected two documentation errors that would mislead anyone following the vignettes. `quick-start`, `defaults-and-hiding`, and `custom-modules` all used `defaults = list(main = ...)` as the worked example for reactive defaults, but no module exposes a plot title: every server passes `main = NULL` and none reads `input$main`, so the example was a silent no-op. The examples now use `color.by`, which modules do read, and the reactive-defaults sections note that an unrecognised key is silently ignored by `get_default()`. Separately, `custom-modules`' "Hiding Base Module Inputs" example passed `hide.inputs` to `*InputsUI()`; that argument belongs to `*Server()`, and since no `*InputsUI()` accepts `...` the example failed with an unused-argument error. Found while benchmarking agent skills against the docs (#341).


* Every module server (and `dataFilterServer()`) now requires its `data` reactive to yield a data frame: values that are not data frames are coerced with `as.data.frame()`, and a `NULL` makes the module wait for data rather than error. A parent app that briefly emits `NULL` can no longer take a plot down with it.
* Fixed modules rendering their plot two or three times for a single change (somewhat related to #325). Several modules compute a value on the server and push it into one of their own inputs with `update*Input()`, which is an asynchronous client round-trip: the plot rendered once with the stale value and again when the client echoed the new one. On load `dittoViz_yPlot` did this three times over (y-axis range, stat comparison pairs, and the rebuilt `multiColorPicker`). 
  * These inputs are now wrapped in `freezeReactiveValue()` so dependents pause until the new value lands, giving a single render. This still applies to `stat.pairs` (`dittoViz_yPlot`, `plotthis_BoxPlot`, `plotthis_ViolinPlot`) and `facet.scale` (`plotthis_BoxPlot`). The colour picker and the y-axis range were handled this way too at first; both have since moved to a server-side store, for the reasons in the #338 entry below. 
  * Added a section in the "Adding a New Module" vignette describing this pattern.
* Fixed an initialization bug in `multiColorPicker()` due to string indexing rather than position, leading to out of bounds errors when a group label was an empty string.
* Fixed the `dittoViz_yPlot` module re-rendering its plot when the user merely switched to the Data tab. The colour picker is built by a `renderUI()` on that tab, and Shiny suspends an output whose tab is hidden, so a change to the palette's groups (setting "Multivar Aesthetic" to "color", say, which keys the palette by variable name) could not rebuild the picker when it happened. The rebuild waited for the tab to be opened, and the value it reported then re-rendered the plot for what was only a tab click. The plot now depends on the *resolved* palette, the group-to-colour mapping it actually draws with (held in a `reactiveVal()`), rather than on the picker's raw value. A rebuilt picker re-seeded from that same resolution therefore changes nothing to re-render for, while a colour the user actually picks comes straight through.
* Fixed every module that uses `multiColorPicker()` rendering its plot an extra time on initialization, and again the first time the user opened the tab the picker lives on (#338). The plot depended on the picker's raw `input$<key>`, which is `NULL` until the browser binds the widget and reports back — so the echo of a mapping the server had just seeded the picker with still counted as a change and rebuilt the plot. An attempt utilizing `freezeReactiveValue()` to guard didn't work: inside a `renderUI()` it pauses only the readers that run after it in the same flush, and at startup the plot output runs first, so the freeze landed too late to pause anything.
  * Every module now reads a server-resolved palette instead. The new exported helper `setup_group_colors()` resolves the group-to-colour mapping as soon as the group set is known and holds it in a `reactiveVal()`, which only invalidates on a real change. A rebuilt picker echoing the palette already in use costs nothing, while a colour the user picks comes straight through. `piePlot` and `radarPlot`, which had no guard at all, are covered for the first time.
  * The picker's palette dropdown no longer carries an HTML `id`. Shiny's select binding claims every `<select>` with one, so each picker was quietly registering a stray `input[["<inputId>-palette"]]` alongside its own value. The widget's JavaScript and CSS both find that element by class, so nothing needed the id.
  * The "Adding a New Module" vignette's "Updating Your Own Inputs From the Server" section now documents this pattern for `renderUI()`-rebuilt widgets.
* The y-axis limits now leave more room for significance brackets, and no longer cost an extra render on the way in. The plot read the raw `input$y.min`/`input$y.max`, which the module had just pushed to the browser, so their echo rebuilt it — the same `freezeReactiveValue()` that could not cover the colour picker was covering these no better.
  * `dittoViz_yPlot`, `plotthis_BoxPlot`, `plotthis_BarPlot` and `plotthis_ViolinPlot` now read a server-side store, the new exported `setup_axis_range()`, so the echo of a limit the module itself set changes nothing while a limit the user types comes straight through. Startup drops a render in each.
  * Brackets are stacked above the data, and nothing had reserved room for them: the axis was silently rescaled at draw time to whatever they needed. Worse, that rescale was applied as an assignment rather than a maximum, so enabling statistics *shrank* a y-axis maximum the user had deliberately set — a plot limited to 0-20 was pulled back to the top of the brackets. `apply_stat_annotations()` gains a `y.max` argument and now only ever raises the top, never lowers it.
  * The new exported `stat_bracket_y_max()` works out how high the brackets will reach, and the three modules that draw them reserve that room up front, so the `y.max` control shows the limit actually in use. It shares the bracket packing with the drawing code, so the two agree exactly, and it honours `hide.ns` (on by default) rather than reserving room for brackets that are never drawn.
* Fixed the `dittoViz_yPlot` reset button calling `updateCheckboxGroupInput()` on its "Plots" select, so resetting left the plot type selection untouched.
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
