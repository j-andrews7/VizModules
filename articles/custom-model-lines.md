# Custom Model Lines in Scatter Plots

The `dittoViz_scatterPlot` module lets users overlay fitted model lines
on their data. Out of the box it supports `lm`, `glm`, `loess`, and
`nls`. This vignette explains how the system works, how to set defaults,
and how to add support for any modelling package (e.g. `drc`, `mgcv`,
`brms`).

## How It Works

The custom model line system has three layers:

1.  **Model backend registry** — a named storage of “recipe cards” that
    tell the pipeline how to fit and predict for each model type.
2.  **UI** — a `multiDynamicInput` widget where users add rows (model
    type, formula, line color and width, plus any backend-specific
    fields).
3.  **Server pipeline** — validates the formula, fits via the backend,
    predicts over an x-grid, and draws the line on the plot.

### The Pipeline

    User fills a row → input$custom.models → .safe_build_model() → backend$fit()
        → .compute_custom_model_fit() → backend$predict() → plotly::add_lines()

A formula validation (AST whitelist) runs before any model is fitted,
blocking arbitrary code execution regardless of backend.

## Using Custom Models in the App

1.  Open a scatter plot app
    (e.g. [`dittoViz_scatterPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.md)).
2.  In the **Lines** tab, toggle **Custom Model Lines** on.
3.  Click **+ Add** to create a model row.
4.  Select a model type, enter a formula using your data’s column names
    (e.g. `revenue ~ poly(units, 2)`), pick line colour and width.
5.  The fitted line appears on the plot.

You can add multiple rows — each draws its own line with independent
settings.

## Setting Defaults

To pre-fill model rows on startup, pass them via the `defaults` argument
to the app or module:

``` r

library(VizModules)

dittoViz_scatterPlotApp(
    data_list = list("sales" = example_sales),
    defaults = list(
        x.by = "revenue",
        y.by = "units",
        custom.model.enable = TRUE,
        custom.models = list(
            models1 = list(
                model_type = "lm",
                formula = "revenue ~ units",
                line_colour = "#1F77B4",
                line_width = 2
            ),
            models2 = list(
                model_type = "loess",
                formula = "revenue ~ units",
                line_colour = "#E63946",
                line_width = 3
            )
        )
    )
)
```

These rows appear pre-filled when the app loads.

Unlike most `defaults` entries, `custom.models` cannot be supplied as a
[`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html). It is
backed by a compound
[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
widget that the generic control-sync used by reactive defaults cannot
drive; pass a plain list.

## Adding a Custom Model Backend

The built-in types (`lm`, `glm`, `loess`, `nls`) are registered
automatically. To add support for another modelling package, call
[`register_model_backend()`](https://j-andrews7.github.io/VizModules/reference/register_model_backend.md)
before the app runs.

### Backend Spec

A backend is a named list with:

| Element | Type | Description |
|----|----|----|
| `fit` | function | `function(formula, data, ...)` — fits the model. Extra UI fields arrive via `...`. |
| `predict` | function | `function(model, newdata)` — returns numeric y-values for an x-grid. |
| `validate_classes` | character | Class(es) the fitted object must inherit (sanity check). |
| `fields` | list (optional) | Extra UI fields specific to this backend (appear when selected). |

### Example: drc (Dose-Response Curves)

``` r

library(VizModules)
library(drc)

register_model_backend("drm", list(
    fit = function(formula, data, drc_fct = "LL.4", ...) {
        fct_map <- list(
            "LL.4" = drc::LL.4, "LL.3" = drc::LL.3, "LL.2" = drc::LL.2,
            "W1.4" = drc::W1.4, "W2.4" = drc::W2.4
        )
        fct_fn <- fct_map[[drc_fct]]
        if (is.null(fct_fn)) stop("Unknown drc family: ", drc_fct)
        drc::drm(formula, data = data, fct = fct_fn())
    },
    predict = function(model, newdata) {
        as.numeric(predict(model, newdata = newdata))
    },
    validate_classes = "drc",
    fields = list(
        drc_fct = list(
            type = "select",
            args = list(choices = c("LL.4", "LL.3", "LL.2", "W1.4", "W2.4"),
                        selected = "LL.4")
        )
    )
))

# Launch — "drm" now appears in the dropdown with a "Drc fct" selector
data(ryegrass, package = "drc")
dittoViz_scatterPlotApp(data_list = list("ryegrass" = ryegrass))
```

When the user selects **drm** from the Model Type dropdown, the **Drc
fct** field appears. The selected value (e.g. `"LL.3"`) is forwarded to
your `fit` function as the `drc_fct` argument.

### Example: mgcv (GAMs)

``` r

register_model_backend("gam", list(
    fit = function(formula, data, ...) {
        mgcv::gam(formula, data = data)
    },
    predict = function(model, newdata) {
        as.numeric(predict(model, newdata = newdata))
    },
    validate_classes = "gam"
    # No extra fields needed — formula handles everything (e.g. y ~ s(x))
))
```

No `fields` needed here because GAM complexity is expressed in the
formula itself (`s()`, `te()`, etc.). Note: you’d need to add `"s"`,
`"te"`, etc. to the formula whitelist in `.safe_build_model()` for this
to work.

## Where to Register Backends

| Scenario | Where to call [`register_model_backend()`](https://j-andrews7.github.io/VizModules/reference/register_model_backend.md) |
|----|----|
| Built into VizModules | Add to `.register_builtin_backends()` in `R/model_backends.R` |
| Extension package | Your package’s [`.onLoad()`](https://j-andrews7.github.io/VizModules/reference/dot-onLoad.md) in `R/zzz.R` |
| Standalone Shiny app | Before [`shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html) or in `global.R` |

## How Extra Fields Flow Through

Any field in the `multiDynamicInput` row that isn’t one of the four
standard keys (`model_type`, `formula`, `line_colour`, `line_width`) is
collected by the server and forwarded as `...` to the backend’s `fit`
function:

    Row value: list(model_type="drm", formula="y~x", drc_fct="LL.3", line_colour="#000", line_width=2)
                                                      ↓
    Server extracts: extra_args = list(drc_fct = "LL.3")
                                                      ↓
    Calls: .safe_build_model("y~x", data, "drm", drc_fct = "LL.3")
                                                      ↓
    Backend receives: fit(formula, data, drc_fct = "LL.3")

## API Reference

| Function | Purpose |
|----|----|
| `register_model_backend(name, backend)` | Add a backend to the registry |
| `get_model_backend(name)` | Retrieve a backend spec |
| [`list_model_backends()`](https://j-andrews7.github.io/VizModules/reference/list_model_backends.md) | List all registered backend names |
| [`build_model_row_spec()`](https://j-andrews7.github.io/VizModules/reference/build_model_row_spec.md) | Build a merged row_spec from all backends (used internally by the scatter UI) |

## Security

The formula AST whitelist is enforced for **all** backends equally. Only
column names, literals, and a fixed set of math/transform functions
(`log`, `sqrt`, `poly`, `exp`, etc.) are permitted in formulas. The
backend’s `fit` function only ever receives a validated `formula` object
— never raw text that could execute arbitrary code.
