# Get a registered model backend

Retrieve a model backend from the registry by name.

## Usage

``` r
get_model_backend(name)
```

## Arguments

- name:

  Character string. The backend name (e.g. `"lm"`, `"drm"`).

## Value

The backend list (with `fit`, `predict`, `validate_classes`), or `NULL`
if no backend with that name is registered.

## Author

Jacob Martin

## Examples

``` r
get_model_backend("lm")
#> $fit
#> function (formula, data, ...) 
#> stats::lm(formula, data = data)
#> <bytecode: 0x5debf7d11368>
#> <environment: 0x5debf7d13c60>
#> 
#> $predict
#> function (model, newdata) 
#> as.numeric(stats::predict(model, newdata = newdata))
#> <bytecode: 0x5debf7d11058>
#> <environment: 0x5debf7d13c60>
#> 
#> $validate_classes
#> [1] "lm"
#> 
get_model_backend("nonexistent")
#> NULL
```
