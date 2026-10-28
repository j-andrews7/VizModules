# Extract a caller-supplied group color mapping from `defaults`

Looks up `key` in a module's `defaults` and returns it as a named vector
of hex colors suitable for
[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.md)
and
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md).
Values may be given as R color names (`"red"`) or hex codes; both are
normalized to `#RRGGBB`. Anything that is not a fully named character
vector is ignored, consistent with
[`get_default()`](https://j-andrews7.github.io/VizModules/reference/get_default.md)'s
silent-fallback contract.

## Usage

``` r
default_group_colors(defaults, key)
```

## Arguments

- defaults:

  A named list of default values, or `NULL`.

- key:

  Character string — the color input's id, e.g. `"palette.colours"`.

## Value

A named character vector of hex colors, or `NULL` when `defaults`
supplies no usable mapping.

## See also

[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.md),
[`get_default()`](https://j-andrews7.github.io/VizModules/reference/get_default.md),
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.md),
[`reset_group_colors()`](https://j-andrews7.github.io/VizModules/reference/reset_group_colors.md)

## Author

Jared Andrews

## Examples

``` r
default_group_colors(list(palette.colours = c(A = "red", B = "#00FF00")), "palette.colours")
#>         A         B 
#> "#FF0000" "#00FF00" 
default_group_colors(list(palette.colours = c("red", "blue")), "palette.colours")
#> NULL
```
