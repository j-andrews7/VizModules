# Custom model-line backends

The `dittoViz_scatterPlot` module can overlay fitted model lines. The built-in types
(`lm`, `glm`, `loess`, `nls`) are registered at load time; `register_model_backend()`
adds more. Call it **before** the app runs.

## Backend spec

A backend is a named list:

| Element | Type | Description |
|---|---|---|
| `fit` | function | `function(formula, data, ...)` — fits the model. Extra UI fields arrive via `...`. |
| `predict` | function | `function(model, newdata)` — numeric y-values for an x-grid. |
| `validate_classes` | character | Class(es) the fitted object must inherit. |
| `fields` | list (optional) | Extra UI fields, shown only when this backend is selected. |

```r
register_model_backend("drm", list(
    fit = function(formula, data, drc_fct = "LL.4", ...) {
        fct_map <- list("LL.4" = drc::LL.4, "LL.3" = drc::LL.3, "W1.4" = drc::W1.4)
        fct_fn <- fct_map[[drc_fct]]
        if (is.null(fct_fn)) stop("Unknown drc family: ", drc_fct)
        drc::drm(formula, data = data, fct = fct_fn())
    },
    predict = function(model, newdata) as.numeric(predict(model, newdata = newdata)),
    validate_classes = "drc",
    fields = list(
        drc_fct = list(type = "select",
                       args = list(choices = c("LL.4", "LL.3", "W1.4"), selected = "LL.4"))
    )
))
```

`"drm"` now appears in the Model Type dropdown, and selecting it reveals a **Drc fct**
control whose value is forwarded to `fit()` as `drc_fct`.

A backend needing nothing beyond the formula omits `fields` entirely:

```r
register_model_backend("gam", list(
    fit = function(formula, data, ...) mgcv::gam(formula, data = data),
    predict = function(model, newdata) as.numeric(predict(model, newdata = newdata)),
    validate_classes = "gam"
))
```

Formula terms are whitelisted for safety, so a GAM using `s()` or `te()` also needs
those added to the whitelist in `.safe_build_model()`.

## How extra fields flow through

Any field in the row that is not one of the four standard keys (`model_type`, `formula`,
`line_colour`, `line_width`) is collected and forwarded as `...` to `fit()`:

```
row value: list(model_type = "drm", formula = "y~x", drc_fct = "LL.3", line_colour = "#000", line_width = 2)
  -> extra_args = list(drc_fct = "LL.3")
  -> .safe_build_model("y~x", data, "drm", drc_fct = "LL.3")
  -> fit(formula, data, drc_fct = "LL.3")
```

## Where to register

| Scenario | Where |
|---|---|
| Inside VizModules | `.register_builtin_backends()` in `R/plot_fit_lines.R`, called from `.onLoad()` in `R/zzz.R` |
| An extension package | your `.onLoad()` in `R/zzz.R` |
| A standalone app | before `shinyApp()`, or in `global.R` |

## API

`register_model_backend(name, backend)`, `get_model_backend(name)`,
`list_model_backends()`, `build_model_row_spec()` (merges `fields` from every registered
backend into the scatter UI's row spec — you do not build that by hand).
