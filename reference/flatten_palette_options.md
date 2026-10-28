# Flatten nested palette options

Converts a nested list of palette choices into a single-level named list
where each entry is a character vector of colors.

## Usage

``` r
flatten_palette_options(palettes)
```

## Arguments

- palettes:

  A named list of palettes or nested category lists.

## Value

A flattened named list of palettes.

## See also

[`default_palettes()`](https://j-andrews7.github.io/VizModules/reference/default_palettes.md),
[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.md)

## Author

Jared Andrews

## Examples

``` r
pal_lookup <- flatten_palette_options(default_palettes()[["choices"]])
head(names(pal_lookup))
#> [1] "dittoColors"      "dittoColors_full" "ggplot2"          "viridis"         
#> [5] "magma"            "inferno"         
```
