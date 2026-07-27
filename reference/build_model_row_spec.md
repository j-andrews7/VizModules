# Build a dynamic row_spec from registered backends

Constructs the merged `row_spec` for
[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
by combining the standard model fields (model_type, formula,
line_colour, line_width) with any extra `fields` declared by registered
backends. Each backend field is tagged with `data-backend` so the client
can show/hide it based on the selected model type.

## Usage

``` r
build_model_row_spec()
```

## Value

A named list suitable for the `row_spec` argument of
[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md).

## Author

Jacob Martin

## Examples

``` r
build_model_row_spec()
#> $model_type
#> $model_type$type
#> [1] "select"
#> 
#> $model_type$args
#> $model_type$args$choices
#> [1] "glm"   "lm"    "loess" "nls"  
#> 
#> $model_type$args$selected
#> [1] "lm"
#> 
#> 
#> 
#> $formula
#> $formula$type
#> [1] "text"
#> 
#> $formula$args
#> $formula$args$placeholder
#> [1] "e.g. y ~ poly(x, 2)"
#> 
#> 
#> 
#> $line_colour
#> $line_colour$type
#> [1] "colour"
#> 
#> $line_colour$args
#> $line_colour$args$value
#> [1] "#000000"
#> 
#> 
#> 
#> $line_width
#> $line_width$type
#> [1] "numeric"
#> 
#> $line_width$args
#> $line_width$args$value
#> [1] 2
#> 
#> $line_width$args$min
#> [1] 0.5
#> 
#> $line_width$args$max
#> [1] 20
#> 
#> $line_width$args$step
#> [1] 0.5
#> 
#> 
#> 
```
