# VizModules module inventory

Function names follow `<Module>InputsUI` / `<Module>OutputUI` / `<Module>Server` /
`<Module>App` for every row. Note the capitalisation: the dittoViz modules are
`dittoViz_scatterPlot*` and `dittoViz_yPlot*` (lowercase plot name), the plotthis ones
are `plotthis_BoxPlot*` etc. (capitalised).

## Column-mapping keys and colour keys

These are the `defaults` / `hide.inputs` keys you will actually use. **They are not
uniform across modules** — check the row before writing a key.

| Module | Wraps | Mapping keys | Colour key | Stats tab |
|---|---|---|---|---|
| `dittoViz_scatterPlot` | `dittoViz::scatterPlot` | `x.by` `y.by` `color.by` `shape.by` `size.by` `split.by` | `color.panel` | — |
| `dittoViz_yPlot` | `dittoViz::yPlot` | `var` `group.by` `color.by` `shape.by` `split.by` `plots` `y.min` `y.max` | `palette.colours` | **yes** |
| `plotthis_AreaPlot` | `plotthis::AreaPlot` | `x.data` `y.data` `group.by` `facet.by` | `palette.colours` | — |
| `plotthis_BarPlot` | `plotthis::BarPlot` | `x.data` `y.data` `group.by` `fill.by` `split.by` `facet.by` `y.min` `y.max` | `palette.colours` | — |
| `plotthis_BoxPlot` | `plotthis::BoxPlot` | `x.data` `y.data` `group.by` `facet.by` `y.min` `y.max` | `palette.colours` | **yes** |
| `plotthis_DensityPlot` | `plotthis::DensityPlot` | `x.data` `group.by` `facet.by` | `palette.colours` | — |
| `plotthis_DotPlot` | `plotthis::DotPlot` | `x.data` `y.data` `fill.by` `size.by` `facet.by` | `palette.name` (continuous) | — |
| `plotthis_Histogram` | `plotthis::Histogram` | `x.data` `group.by` `facet.by` | `palette.colours` | — |
| `plotthis_SplitBarPlot` | `plotthis::SplitBarPlot` | `x.data` `y.data` `fill.by` `split.by` `facet.by` `x.min` `x.max` | `palette.colours` | — |
| `plotthis_ViolinPlot` | `plotthis::ViolinPlot` | `x.data` `y.data` `group.by` `facet.by` `y.min` `y.max` | `palette.colours` | **yes** |
| `linePlot` | native (`linePlot()`) | `x.value` `y.value` `group.by` `facet.by` | `palette.colours` | — |
| `dumbbellPlot` | native (`dumbbellPlot()`) | `x.value` `y.value` `colour.by` `facet.by` | `palette.colours` | — |
| `piePlot` | native (`piePlot()`) | `labels` `values` | `slice.colors` | — |
| `radarPlot` | native (`radarPlot()`) | `r` `theta` `group` | `trace.colors` | — |
| `parallelCoordinatesPlot` | native | `dimensions` `color.by` | `palette.colours` | — |
| `ComplexHeatmap_Heatmap` | `ComplexHeatmap::Heatmap` | `matrix.cols` `rowname.col` `name` | `palette` (name) | — |

`ComplexHeatmap_Heatmap` is the odd one out: its output is **not** plotly. It renders
through `InteractiveComplexHeatmap`, so plotly-specific advice does not apply to it.

The colour key takes a **named character vector** mapping group level to colour, e.g.
`defaults = list(palette.colours = c(Healthy = "#0072B2", Disease = "red"))`. Unnamed
groups fall back to the stock palette; the user can still edit every colour.

## Tab names for `hide.tabs`

| Module | Tabs |
|---|---|
| `dittoViz_scatterPlot` | Data, Adjustments, Points, Colors, Facet, Annotations, Legend, Trajectory, Lines, Axes, Plotly, Extras |
| `dittoViz_yPlot` | Data, Adjustments, Jitter, Box, Violin, Ridge, Stats, Facet, Annotations, Legend, Axes, Lines, Plotly |
| `plotthis_BoxPlot`, `plotthis_ViolinPlot` | Data, Adjustments, Highlight, Facet, Stats, Legend, Axes, Lines, Plotly |
| `plotthis_AreaPlot`, `plotthis_DotPlot`, `linePlot`, `dumbbellPlot` | Data, Facet, Aesthetics, Legend, Axes, Lines, Plotly |
| `plotthis_DensityPlot`, `plotthis_Histogram` | Data, Facet, Aesthetics, Rug, Legend, Axes, Lines, Plotly |
| `plotthis_BarPlot`, `plotthis_SplitBarPlot` | Data, Facet, Aesthetics, Adjustments, Legend, Axes, Lines, Plotly |
| `piePlot` | Data, Aesthetics, Labels, Plotly |
| `parallelCoordinatesPlot` | Data, Aesthetics, Labels, Title, Plotly |
| `radarPlot` | Data, Aesthetics, Axes, Plotly (plus per-trace styling tabs) |
| `ComplexHeatmap_Heatmap` | Matrix, Colors, Clustering, Labels, Annotations |

## Shared tab input keys

Inputs on the Axes / Legend / Lines / Plotly tabs come from shared helpers, so they use
the same keys in every module. Full lists are on their help pages —
`?uniform_axes_inputs_ui`, `?uniform_legend_inputs_ui`, `?uniform_lines_inputs_ui`,
`?uniform_plotly_inputs_ui`. The ones you will reach for most:

- Axes: `axis.title.font.size` (18), `title.font.size` (26), `axis.showline` (TRUE), `show.grid.x` / `show.grid.y` (TRUE), `axis.tickfont.size` (12), `axis.tickangle.x` (0)
- Legend: `legend.title.size`, `legend.text.size`
- Lines: `hline.intercepts`, `vline.intercepts`, `abline.slopes` — comma-separated strings, with matching `*.colors` / `*.widths` / `*.linetypes` / `*.opacities`
- Plotly: `download.format`, `subplot.margin.x`, `subplot.margin.y`

## Bundled example datasets

`example_bar`, `example_demographics`, `example_heatmap_column_data`,
`example_heatmap_matrix`, `example_iris`, `example_markers`, `example_mtcars`,
`example_population`, `example_rnaseq`, `example_sales`, `example_school_earnings`,
`example_skills`.

`example_rnaseq` (288 x 7) is the richest for grouped comparisons:
`cell_type` (factor: CD4 T, CD8 T, B Cell, NK Cell, Monocyte, pDC), `gene` (factor),
`condition` (factor: Healthy, Disease), `replicate` (factor: Rep1-3), `log2_cpm`
(numeric), `avg_expression` (numeric), `neg_log10_pval` (numeric).

`example_heatmap_matrix` (30 x 15) is genes (rows) x samples (columns), shaped for
`ComplexHeatmap_Heatmap`: `gene` (id), `pathway` (factor row annotation), `mean_expression`
(numeric row annotation), plus 12 sample columns (`Healthy_1..6`, `Disease_1..6`).
`example_heatmap_column_data` (12 x 4) is its companion sample-metadata table
(`sample`, `condition`, `batch`, `library_size`) for demonstrating column annotations —
pass both together as `data = list(matrix = example_heatmap_matrix, column_annotations =
example_heatmap_column_data)`.

Each `*App()` opens on a dataset chosen to suit it: scatter/line/area/pie/parallel →
`example_sales`; yPlot/box/violin/density/histogram → `example_demographics`; bar and
split bar → `example_bar`; dot → `example_markers`; radar → `example_skills`; dumbbell →
`example_school_earnings`; heatmap → `example_heatmap_matrix`.

## Not yet wrapped

`dittoViz::freqPlot`, `dittoViz::barPlot`, `dittoViz::ridgePlot`, and
`dittoViz::scatterHexPlot` have no module. If a user asks for one, say so rather than
inventing a function name.
