# The three required roxygen sections

Every module's `*InputsUI()` function must carry all three. They are the contract
between the module and its users: which upstream arguments are wired through, which are
not, and what the module adds on top. A module without them is incomplete.

Write them against the **upstream function's argument list**, not against your UI. Go
through every argument of the plot function you are wrapping and put it in exactly one
of the first two sections.

## 1. Parameters not implemented or with altered functionality

List every upstream argument you did **not** expose, each with a reason. Most of the
reasons repeat across modules:

```r
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::AreaPlot()] parameters are not available via UI inputs:
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `split_by` - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#' - `design` - Only applies if `split_by` is used
#' - `palette` - Managed internally via the palette selection UI
#' - `seed` - Random seed (not applicable)
#' - `combine` - Combine multiple plots (not applicable for plotly)
```

If `ggplotly()` changes or drops a feature — certain geoms, annotations, legend
behaviours — say so here. Users need to know what will not survive the conversion.

## 2. Parameters and defaults

Every argument you **did** expose, with its UI label and default value. This is the
section users read to find `defaults` keys, so the input ID and the label must both be
accurate.

```r
#' @section Plot parameters and defaults:
#' The following [plotthis::AreaPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X values", default: 2nd categorical variable)
#' - `y` - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#' - `group_by` - Grouping variable for area fill (UI: "Group by", default: 3rd categorical variable or "")
#' - `facet_by` - Faceting variable (UI: "Facet by", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet scale", default: "fixed")
#' - `alpha` - Area fill transparency (UI: "Alpha", default: 1)
```

## 3. Parameters implementing new functionality

Everything the module adds that has no upstream equivalent: plotly-specific controls,
reference lines, axis and tick styling, the colour picker. Most of these come from the
uniform helpers, so you can copy the list from a sibling module that uses the same
helpers — but only the ones you actually included.

```r
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#'
#' - `title.font.size` - Plot title font size (UI: "Title Size", default: 26)
#' - `axis.title.font.size` - Axis title font size (UI: "Axis Title Size", default: 18)
#' - `axis.showline` - Show axis border lines (UI: "Show axis lines", default: TRUE)
#' - `axis.tickfont.size` - Size of tick labels (UI: "Tick label size", default: 12)
#' - `hline.intercepts` - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#' - `hline.colors` - Colors for horizontal lines (UI: "Colors", default: "#000000")
#' - `hline.linetypes` - Line types for horizontal lines (UI: "Line types", default: "dashed")
#' - `vline.intercepts` - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#' - `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#' - `palette.colours` - Named character vector mapping group levels to colors, e.g.
#'   `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds the picker; unnamed groups fall
#'   back to the default palette and user edits take precedence.
```

Reference-line parameters (`hline.*`, `vline.*`, `abline.*`) take comma-separated values
so each line can be styled individually — worth stating.

## The rest of the roxygen header

- Title, description, `@param` for every argument, `@return`, `@author`, `@export`.
- `@seealso` linking the upstream function and the other three module functions.
- `@examples` with minimal runnable usage on a small bundled dataset.
- `@importFrom pkg fun` for everything the file calls; then call `fun()` bare in the body.

Regenerate `NAMESPACE` and the `.Rd` files with `devtools::document()`. Never hand-edit
`NAMESPACE`.
