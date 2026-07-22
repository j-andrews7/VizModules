# Plan: Extensible model fitting pipeline for custom model backends

## Goal

Make the custom model line system **pluggable** so that any modelling package
(drc, mgcv, brms, survival, etc.) can be used without modifying the core
pipeline code. Currently `.safe_build_model()` and `.compute_custom_model_fit()`
are hardcoded to `lm/glm/loess/nls`. The new design lets users (or module
developers) register a **model backend** — a small spec that says how to fit and
predict — and the pipeline dispatches to it automatically.

---

## Design: Model backend registry

A **model backend** is a named list with three elements:

```r
list(
  fit     = function(formula, data, ...) { ... },   # returns a fitted model object
  predict = function(model, newdata) { ... },        # returns numeric vector of y values
  validate_classes = "drc"                           # class(es) the fitted object must inherit
)
```

Backends are stored in a **package-level registry** (an environment). The
built-in types (`lm`, `glm`, `loess`, `nls`) are registered at load time.
Users add new ones with a public helper:

```r
register_model_backend("drm", list(
  fit = function(formula, data, ...) {
    drc::drm(formula, data = data, fct = drc::LL.4(), ...)
  },
  predict = function(model, newdata) {
    as.numeric(predict(model, newdata = newdata))
  },
  validate_classes = "drc"
))
```

The `...` in `fit` is key: extra arguments from the UI row (like `drc_fct`)
flow through as `...`, so the backend controls what it does with them.

---

## Changes

### 1. New file: `R/model_backends.R`

Contains:

- `.model_backend_registry` — a private environment storing backends by name.
- `register_model_backend(name, backend)` — **exported**. Validates the spec
  and inserts it into the registry. Backends can be overwritten (e.g. a user
  can replace `"lm"` if they want custom validation logic).
- `get_model_backend(name)` — **exported**. Returns the backend spec or NULL.
- `list_model_backends()` — **exported**. Returns a character vector of
  registered backend names.

All three public functions will have full roxygen documentation and `@export`
tags.
- `.register_builtin_backends()` — **internal**, called from `.onLoad()`.
  Registers `lm`, `glm`, `loess`, `nls` with the trivial implementations
  that match today's hardcoded behavior.

#### Built-in backends (registered at load time)

| Name    | `fit`                                        | `predict`                  | `validate_classes` |
|---------|----------------------------------------------|----------------------------|--------------------|
| `lm`    | `lm(formula, data = data)`                   | `predict(model, newdata)`  | `"lm"`             |
| `glm`   | `glm(formula, data = data)`                  | `predict(model, newdata)`  | `"glm"`            |
| `loess` | `loess(formula, data = data)`                | `predict(model, newdata)`  | `"loess"`          |
| `nls`   | `nls(formula, data = data)`                  | `predict(model, newdata)`  | `"nls"`            |

These are identical to today's behavior so nothing changes for existing users.

### 2. Update `.safe_build_model()` in `R/plot_fit_lines.R`

Current signature:

```r
.safe_build_model(formula_text, data, fit_fn_name)
```

New signature:

```r
.safe_build_model(formula_text, data, fit_fn_name, ...)
```

Changes:
- Replace the hardcoded `fn_map` lookup with `get_model_backend(fit_fn_name)`.
  Return `NULL` with a warning if not found.
- Keep all existing formula validation (parse, AST whitelist, `as.formula`).
  This protects against arbitrary code regardless of backend.
- At the fitting step, call `backend$fit(formula, data, ...)` instead of
  `fit_fn(formula, data = data)`.
- Validate the result class against `backend$validate_classes` instead of the
  hardcoded `c("lm", "glm", "loess", "nls")`.

The `...` lets the scatter server (or any caller) pass backend-specific extra
arguments (e.g. `drc_fct = drc::LL.4()`) without `.safe_build_model` knowing
what they are.

### 3. Update `.compute_custom_model_fit()` in `R/plot_fit_lines.R`

Current approach: always calls `predict(model, newdata)` (with a special case
for lmer/glmer).

New approach:
- Accept an optional `backend` argument (the backend spec, or NULL).
- If `backend` is non-NULL and has a `predict` function, use
  `backend$predict(model, newdata)`.
- Otherwise fall back to the existing generic `predict(model, newdata)` path
  (preserves backward compatibility for any model object passed directly).

### 4. Update the scatter server model loop

In `R/dittoViz_ScatterPlot_module_server.R` (~line 852), the loop currently
passes `fit_fn_name = row$model_type` to `.safe_build_model()`. Change it to
also forward any extra fields from the row as `...`:

```r
# Collect extra fields (everything except the known UI keys)
known_keys <- c("model_type", "formula", "line_colour", "line_width")
extra_args <- row[!names(row) %in% known_keys]

user_model <- do.call(.safe_build_model, c(
    list(formula_text = formula_text,
         data         = data(),
         fit_fn_name  = row$model_type),
    extra_args
))
```

And when calling `.add_custom_model_lines_to_subplots`, pass the backend so
`.compute_custom_model_fit` can use the custom predict:

```r
backend <- get_model_backend(row$model_type)
```

This means `.add_custom_model_lines_to_subplots` will need to accept and
forward a `backend` argument.

### 5. Update `.add_custom_model_lines_to_subplots()`

Add an optional `backend = NULL` parameter. Pass it through to
`.compute_custom_model_fit()` so the custom predict function is used.

### 6. Update the `model_type` choices in the UI

In `R/uniform_ui_inputs.R`, the `model_type` select currently has hardcoded
choices `c("lm", "glm", "loess", "nls")`. Change this to pull from the
registry:

```r
args = list(choices = list_model_backends())
```

This way, when a user registers a `"drm"` backend in their app's `global.R`
or server function, it automatically appears in the dropdown.

### 7. Register builtins in `.onLoad()`

In `R/zzz.R` (or wherever `.onLoad` lives), call
`.register_builtin_backends()`.

---

## drc example (not implemented here, but shows the pattern)

A user (or a future VizModules extension) registers the drc backend in their
app code:

```r
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
  validate_classes = "drc"
))
```

They'd add `drc_fct` as a field in their own row_spec, and the pipeline
handles the rest — `.safe_build_model` forwards `drc_fct` via `...` to
`backend$fit`, which uses it to pick the family.

---

## Files summary

| File | Action |
|------|--------|
| `R/model_backends.R` | **New** — registry, register/get/list helpers, builtin registration. |
| `R/plot_fit_lines.R` | **Modify** — `.safe_build_model()`, `.compute_custom_model_fit()`, `.add_custom_model_lines_to_subplots()` dispatch through backends. |
| `R/dittoViz_ScatterPlot_module_server.R` | **Modify** — forward extra row fields as `...` and pass backend to line-drawing fn. |
| `R/uniform_ui_inputs.R` | **Modify** — model_type choices from `list_model_backends()`. |
| `R/zzz.R` | **New** — `.onLoad()` that calls `.register_builtin_backends()`. No existing `.onLoad` in the package. |
| `_pkgdown.yml` | **Modify** — add new exports to reference. |

---

## What does NOT change

- The formula validation (parse + AST whitelist) stays exactly the same for
  all backends. This is security-critical and backend-agnostic.
- The `multiDynamicInput` widget itself doesn't change.
- The plotting/trace-adding logic in `.add_custom_model_lines_to_subplots`
  stays the same — it just gets a `backend` parameter to pass through.
- All existing behavior is preserved: the four built-in backends produce
  identical results to today's hardcoded code.
