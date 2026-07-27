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
#> <bytecode: 0x556c26b3ab08>
#> <environment: 0x556c26b3cd00>
#> 
#> $predict
#> function (model, newdata) 
#> as.numeric(stats::predict(model, newdata = newdata))
#> <bytecode: 0x556c26b3a7f8>
#> <environment: 0x556c26b3cd00>
#> 
#> $validate_classes
#> [1] "lm"
#> 
get_model_backend("nonexistent")
#> NULL
```
