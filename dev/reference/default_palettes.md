# Color palette options for palettePicker

Returns a list of predefined color palettes grouped by category
(Defaults, Viridis, Diverging, Qualitative, Sequential) for use with
color picker UI components.

## Usage

``` r
default_palettes()
```

## Value

A named list with two elements: `choices` (a nested list of palette name
to color vector mappings, grouped by category) and `textColor` (a
character vector of text colors for each palette).

## Author

Jared Andrews

## Examples

``` r
pals <- default_palettes()
names(pals$choices)
#> [1] "Defaults"    "Viridis"     "Diverging"   "Qualitative" "Sequential" 
```
