# Resolve a color palette for plot groups

Maps groups to colors using selected colors or a default palette.
Handles named color vectors by matching to group names, fills in missing
colors with fallback values, and ensures the output vector is named and
matches group length.

## Usage

``` r
resolve_palette(
  groups,
  selected_colors = NULL,
  default_palette = NULL,
  manual_colors = NULL
)
```

## Arguments

- groups:

  A character vector of group names to assign colors to.

- selected_colors:

  A named or unnamed character vector of colors to use. If named, colors
  are matched to groups by name. If NULL or empty, uses `manual_colors`
  or `default_palette`.

- default_palette:

  A character vector of fallback colors to use when no other source
  supplies a color for a group. Defaults to "#000000" (black) if not
  provided.

- manual_colors:

  An optional named character vector of caller-supplied colors,
  typically taken from a module's `defaults`. Used for groups that
  `selected_colors` does not name.

## Value

A named character vector of colors with names corresponding to groups,
or NULL if groups is empty.

## Details

Colors are layered in order of increasing precedence: `default_palette`,
then `manual_colors`, then `selected_colors`. A user's on-screen choice
therefore always wins over a caller-supplied mapping, and a
caller-supplied mapping wins over the module's stock palette.

## Author

Jared Andrews

## Examples

``` r
groups <- c("A", "B", "C")
colors <- c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
resolve_palette(groups, colors)
#>         A         B         C 
#> "#FF0000" "#00FF00" "#0000FF" 
# Returns: c(A = "#FF0000", B = "#00FF00", C = "#0000FF")

# Using default palette
resolve_palette(groups, NULL, c("#1B9E77", "#D95F02", "#7570B3"))
#>         A         B         C 
#> "#1B9E77" "#D95F02" "#7570B3" 
# Returns: c(A = "#1B9E77", B = "#D95F02", C = "#7570B3")

# Caller-supplied mapping fills groups the user has not picked
resolve_palette(groups, c(A = "#FF0000"), "#CCCCCC", c(B = "#00FF00", C = "#0000FF"))
#>         A         B         C 
#> "#FF0000" "#00FF00" "#0000FF" 
# Returns: c(A = "#FF0000", B = "#00FF00", C = "#0000FF")
```
