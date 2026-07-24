# Resolve a color palette for plot groups

Maps groups to colors using selected colors or a default palette.
Handles named color vectors by matching to group names, fills in missing
colors with fallback values, and ensures the output vector is named and
matches group length.

## Usage

``` r
resolve_palette(groups, selected_colors = NULL, default_palette = NULL)
```

## Arguments

- groups:

  A character vector of group names to assign colors to.

- selected_colors:

  A named or unnamed character vector of colors to use. If named, colors
  are matched to groups by name. If NULL or empty, uses
  `default_palette`.

- default_palette:

  A character vector of fallback colors to use when `selected_colors` is
  NULL/empty or when groups have missing colors. Defaults to "#000000"
  (black) if not provided.

## Value

A named character vector of colors with names corresponding to groups,
or NULL if groups is empty.

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
```
