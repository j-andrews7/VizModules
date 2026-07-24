# List registered model backends

Returns the names of all currently registered model backends. The
built-in backends (`lm`, `glm`, `loess`, `nls`) are always present; any
backends added via
[`register_model_backend()`](https://j-andrews7.github.io/VizModules/dev/reference/register_model_backend.md)
are included as well.

## Usage

``` r
list_model_backends()
```

## Value

A sorted character vector of backend names.

## Author

Jacob Martin

## Examples

``` r
list_model_backends()
#> [1] "glm"   "lm"    "loess" "nls"  
```
