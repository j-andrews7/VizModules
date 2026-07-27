# Register a model backend

Add or replace a model backend in the registry. Once registered, the
backend name appears in the model-type dropdown and the
custom-model-lines pipeline dispatches through it automatically.

## Usage

``` r
register_model_backend(name, backend)
```

## Arguments

- name:

  Character string. The name that will appear in the model-type dropdown
  (e.g. `"drm"`, `"gam"`).

- backend:

  A named list with elements `fit`, `predict`, and `validate_classes` as
  described above.

## Value

Invisibly returns `NULL`. Called for its side effect.

## Details

A backend is a named list with three required elements:

- `fit`:

  A function with signature `function(formula, data, ...)` that returns
  a fitted model object. Extra UI fields from the
  [`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
  row are forwarded as `...`.

- `predict`:

  A function with signature `function(model, newdata)` that returns a
  numeric vector of predicted y-values, one per row of `newdata`.

- `validate_classes`:

  Character vector of class names. After fitting, the pipeline checks
  `inherits(model, validate_classes)` and rejects the model if it fails.

## Author

Jacob Martin

## Examples

``` r
# Register a custom backend for dose-response curves (requires drc)
if (requireNamespace("drc", quietly = TRUE)) {
}
#> NULL
```
