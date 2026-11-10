# Input UI components for the BoxPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotServer.md)
and
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_BoxPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html);
  it is resolved with
  [`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) to
  seed the control, and the module then keeps it live (see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md)).

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
to the `defaults` argument. Nearly all parameters for
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `x_sep` - Separator for x columns (not applicable in UI context)

- `in_form` - Data input format (not applicable - always long form)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `split_by_sep` - Only applies if `split_by` is used

- `symnum_args` - Significance symbol arguments (the Stats tab manages
  symbol display)

- `keep_empty` - Keep empty values (not implemented)

- `keep_na` - Keep NA values (not implemented)

- `group_by_sep` - Separator for group columns (not applicable in UI
  context)

- `group_name` - Group legend name (handled by plotly)

- `paired_by` - Pairing variable for paired tests (use the Stats tab
  "Paired Test" input instead)

- `x_text_angle` - X-axis text angle (handled by plotly axis settings)

- `step_increase` - Step increase for significance brackets (set via the
  Stats tab "Bracket Spacing")

- `base` - Base plot type box/violin/bar (fixed to "box" in this module)

- `fill_mode` - Fill mode for grouped data (handled automatically)

- `position_dodge_preserve` - Preserve dodge width (not implemented)

- `add_errorbar` - Add error bars (only for base = "bar"; not
  implemented)

- `errorbar_color` - Error bar color (not implemented)

- `errorbar_width` - Error bar cap width (not implemented)

- `errorbar_linewidth` - Error bar line width (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `palreverse` - Reverse the color palette (not implemented)

- `alpha` - Alpha transparency (not implemented in UI)

- `stack` - Stack boxplots (not implemented)

- `add_beeswarm` - Add beeswarm points (not implemented in UI)

- `beeswarm_method` - Beeswarm arrangement method (not implemented)

- `beeswarm_cex` - Beeswarm point size factor (not implemented)

- `beeswarm_priority` - Beeswarm priority order (not implemented)

- `beeswarm_dodge` - Beeswarm dodge width (not implemented)

- `add_trend` - Add trend line (not implemented in UI)

- `trend_color` - Trend line color (not implemented)

- `trend_linewidth` - Trend line width (not implemented)

- `trend_ptsize` - Trend point size (not implemented)

- `add_stat` - Add statistical annotation (not implemented)

- `stat_name` - Statistical test name (not implemented)

- `stat_color` - Statistical annotation color (not implemented)

- `stat_size` - Statistical annotation size (not implemented)

- `stat_stroke` - Statistical annotation stroke (not implemented)

- `stat_shape` - Statistical annotation shape (not implemented)

- `add_bg` - Add background shading (not implemented)

- `bg_palette` - Background palette (not implemented)

- `bg_palcolor` - Background color (not implemented)

- `bg_alpha` - Background transparency (not implemented)

- `add_line` - Add horizontal line (not implemented in UI - use Lines
  tab)

- `line_color` - Line color (not implemented)

- `line_width` - Line width (not implemented)

- `line_type` - Line type (not implemented)

- `comparisons` - plotthis pairwise comparisons are not passed;
  equivalent pairwise significance testing is provided via the module's
  Stats tab (see "Statistical annotation parameters")

- `ref_group` - Reference group for comparisons (use the Stats tab
  instead)

- `pairwise_method` - Pairwise test method (set via the Stats tab "Test"
  input instead)

- `multiplegroup_comparisons` - Multiple-group comparison flag (use the
  Stats tab instead)

- `multiple_method` - Multiple-group test method (set via the Stats tab
  "Test" input instead)

- `sig_label` - Significance label format (set via the Stats tab
  "Display" input instead)

- `sig_labelsize` - Significance label size (handled by the Stats tab)

- `hide_ns` - Hide non-significant comparisons (use the Stats tab "Hide
  Non-Significant" input)

- `seed` - Random seed (not applicable)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `legend.direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X data", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group by", default: "")

- `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default:
  FALSE)

- `sort_x` - Sort X-axis by statistic (UI: "Sort X by", default: ""). An
  expression evaluated once per x group over all the data, e.g.
  `mean(salary)`; a faceted plot shares the one order across its panels

- `y_max` - Maximum Y-axis value (UI: "Max Value of Y Axis", default:
  calculated)

- `y_min` - Minimum Y-axis value (UI: "Min Value of Y Axis", default:
  calculated)

- `add_point` - Add jitter points (UI: "Add Jitter Points", default:
  FALSE)

- `pt_size` - Point size (UI: "Point Size", default: 1)

- `pt_alpha` - Point transparency (UI: "Point Alpha", default: 1)

- `jitter_width` - Jitter width (UI: "Jitter Width", default: 0.3)

- `pt_color` - Point outline color (UI: "Point Outline Colour", default:
  "#000000")

- `highlight` - Highlight condition (UI: "Highlight", default: "")

- `highlight_color` - Highlight color (UI: "Highlight Colour", default:
  "#000000")

- `highlight_size` - Highlight size (UI: "Highlight Size", default: 1)

- `highlight_alpha` - Highlight transparency (UI: "Highlight Alpha",
  default: 1)

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Statistical annotation parameters

The module provides plotly-based significance testing via the Stats tab
(a reimplementation of the plotthis significance-testing features). The
following inputs are available:

- `stats.enabled` - Enable statistical annotations (UI: "Enable Stats",
  default: FALSE)

- `stat.test` - Test to apply: Wilcoxon, t-test, Kruskal-Wallis, or
  ANOVA (UI: "Test")

- `stat.p.adjust` - P-value adjustment method (UI: "P-value Adjustment",
  default: "holm")

- `stat.display` - Value to display: adjusted p-value, p-value, or
  symbols (UI: "Display")

- `stat.sig.threshold` - Significance threshold for symbols/hiding (UI:
  "Significance Threshold")

- `stat.hide.ns` - Hide non-significant comparisons (UI: "Hide
  Non-Significant", default: TRUE)

- `stat.paired` - Use a paired test (UI: "Paired Test", default: FALSE)

- `stat.pairs` - Group comparisons to test (UI: "Comparisons", multiple
  selection, default: all pairs). As a default, a character vector of
  `"A vs B"` strings naming levels of `x.data` (or of `group.by`, when
  set), e.g. `c("Entry vs Mid", "Mid vs Senior")`; either order matches

- `stat.line.color` - Bracket line color (UI: "Line Color", default:
  "#000000")

- `stat.line.width` - Bracket line width (UI: "Line Width")

- `stat.bracket.style` - Bracket style, capped or flat (UI: "Bracket
  Style")

- `stat.step.increase` - Vertical spacing between stacked brackets (UI:
  "Bracket Spacing")

- `stat.text.bump` - Offset of the significance text above the bracket
  (UI: "Text Offset")

- `stat.bracket.inset` - Horizontal inset of the brackets (UI: "Bracket
  Inset")

- `stat.per.facet` - Compute statistics independently per facet panel
  (UI: "Per Facet Panel")

Brackets are stacked above the data, so none are drawn while the plot is
rotated (the values then run along the x-axis); the test results are
still included in the source data download. Under a free y facet scale
("free", "free_y") each panel's brackets sit above that panel's own
data, and the Y axis min/max are not applied.

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `webgl` - Draw the points with WebGL once there are 5,000 or more, as
  set by the `VizModules.webgl.threshold` option (UI: "Plot with WebGL",
  default: TRUE)

- `boxplot.width` - Width of boxplot (UI: "Boxplot Width", default: 0.8)

- `x.order` - Order of the X groups (UI: "X Order", drag and drop,
  default: the column's factor level order, else sorted). As a default,
  a character vector of levels of `x.data`; levels it leaves out follow
  in their default order. Ignored while `sort_x` is set, and not shown
  for an X with more than 20 groups

- `show.outliers` - Show outlier points (UI: "Show Outliers", default:
  TRUE)

- `axis.title.font.size` - Axis title font size (UI: "Axis title size",
  default: 18)

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis Title Size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis Title
  Color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis Title
  Font", default: "Arial")

- `axis.showline` - Show axis border lines (UI: "Show axis lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror axis
  lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X major
  gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y major
  gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis line color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis line width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick label size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick label color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick label
  font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis tick label angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis tick label angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick mark color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick mark length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick mark width",
  default: 1)

- `axis.scientific` - Write numeric tick labels in scientific notation
  (UI: "Scientific Notation Ticks", default: FALSE; when off they never
  switch to it). See
  [`apply_tick_notation()`](https://j-andrews7.github.io/VizModules/reference/apply_tick_notation.md)

- `axis.padding.x` - Space between the data and the plot area's edges
  along X, as a fraction of the data's extent at each end (UI: "X Axis
  Padding", default: NA = the plot's own). See
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)

- `legend.show` - Show the legend and any colorbar (UI: "Show Legend",
  default: TRUE)

- `legend.font.family` - Font family of the legend title and labels (UI:
  "Legend Font", default: "Arial")

- `legend.font.color` - Font color of the legend title and labels (UI:
  "Legend Font Color", default: "#000000")

- `legend.title.size` - Legend title font size (UI: "Legend Title Size",
  default: 14)

- `legend.text.size` - Legend entry label font size (UI: "Legend Text
  Size", default: 12)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line types",
  default: "dashed")

- `vline.opacities` - Opacities for vertical lines (UI: "Opacities
  (0-1)", default: "1")

- `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes",
  default: "")

- `abline.intercepts` - Y-intercepts for diagonal lines (UI:
  "Y-intercepts", default: "")

- `abline.colors` - Colors for diagonal lines (UI: "Colors", default:
  "#000000")

- `abline.widths` - Widths for diagonal lines (UI: "Widths", default:
  "1")

- `abline.linetypes` - Line types for diagonal lines (UI: "Line types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

- `palette.colours` - Named character vector mapping group levels to
  colors, e.g. `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds
  the picker; unnamed groups fall back to the default palette and user
  edits take precedence.

## See also

[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_BoxPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotOutputUI.md),
[`plotthis_BoxPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotServer.md),
[`plotthis_BoxPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BoxPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
data(mtcars)
plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
}
```
