#' Model backend registry
#'
#' A pluggable registry that lets any modelling package (drc, mgcv, brms, etc.)
#' be used in the custom-model-lines pipeline without modifying core code. Each
#' **backend** is a small named list that tells the pipeline how to fit a model
#' and how to predict from it.
#'
#' Backends are stored in a package-level environment. The four built-in types
#' (`lm`, `glm`, `loess`, `nls`) are registered automatically when the package
#' loads. Users add new ones with [register_model_backend()].
#'
#' @name model_backends
#' @keywords internal
NULL

# Private registry environment — backends stored by name.
.model_backend_registry <- new.env(parent = emptyenv())


#' Register a model backend
#'
#' Add or replace a model backend in the registry. Once registered, the backend
#' name appears in the model-type dropdown and the custom-model-lines pipeline
#' dispatches through it automatically.
#'
#' A backend is a named list with three required elements:
#' \describe{
#'   \item{`fit`}{A function with signature `function(formula, data, ...)` that
#'     returns a fitted model object. Extra UI fields from the
#'     [multiDynamicInput()] row are forwarded as `...`.}
#'   \item{`predict`}{A function with signature `function(model, newdata)` that
#'     returns a numeric vector of predicted y-values, one per row of
#'     `newdata`.}
#'   \item{`validate_classes`}{Character vector of class names. After fitting,
#'     the pipeline checks `inherits(model, validate_classes)` and rejects the
#'     model if it fails.}
#' }
#'
#' @param name Character string. The name that will appear in the model-type
#'   dropdown (e.g. `"drm"`, `"gam"`).
#' @param backend A named list with elements `fit`, `predict`, and
#'   `validate_classes` as described above.
#'
#' @return Invisibly returns `NULL`. Called for its side effect.
#'
#' @export
#' @author Jacob Martin
#'
#' @examples
#' # Register a custom backend for dose-response curves (requires drc)
#' if (requireNamespace("drc", quietly = TRUE)) {
#'     register_model_backend("drm", list(
#'         fit = function(formula, data, drc_fct = "LL.4", ...) {
#'             fct_map <- list(
#'                 "LL.4" = drc::LL.4, "LL.3" = drc::LL.3,
#'                 "LL.2" = drc::LL.2, "W1.4" = drc::W1.4
#'             )
#'             fct_fn <- fct_map[[drc_fct]]
#'             if (is.null(fct_fn)) stop("Unknown drc family: ", drc_fct)
#'             drc::drm(formula, data = data, fct = fct_fn())
#'         },
#'         predict = function(model, newdata) {
#'             as.numeric(predict(model, newdata = newdata))
#'         },
#'         validate_classes = "drc"
#'     ))
#' }
register_model_backend <- function(name, backend) {
    if (!is.character(name) || length(name) != 1 || !nzchar(name)) {
        stop("`name` must be a single non-empty string.")
    }
    if (!is.list(backend)) {
        stop("`backend` must be a named list with `fit`, `predict`, and `validate_classes`.")
    }
    required <- c("fit", "predict", "validate_classes")
    missing <- setdiff(required, names(backend))
    if (length(missing) > 0) {
        stop("Backend is missing required elements: ", paste(missing, collapse = ", "))
    }
    if (!is.function(backend$fit)) {
        stop("`backend$fit` must be a function(formula, data, ...).")
    }
    if (!is.function(backend$predict)) {
        stop("`backend$predict` must be a function(model, newdata).")
    }
    if (!is.character(backend$validate_classes) || length(backend$validate_classes) == 0) {
        stop("`backend$validate_classes` must be a non-empty character vector.")
    }
    # Optional: extra UI fields this backend contributes to the row_spec.
    # Must be a named list of field specs (same format as row_spec entries).
    if (!is.null(backend$fields) && (!is.list(backend$fields) || is.null(names(backend$fields)))) {
        stop("`backend$fields` must be a named list of field specs or NULL.")
    }
    .model_backend_registry[[name]] <- backend
    invisible(NULL)
}


#' Get a registered model backend
#'
#' Retrieve a model backend from the registry by name.
#'
#' @param name Character string. The backend name (e.g. `"lm"`, `"drm"`).
#'
#' @return The backend list (with `fit`, `predict`, `validate_classes`), or
#'   `NULL` if no backend with that name is registered.
#'
#' @export
#' @author Jacob Martin
#'
#' @examples
#' get_model_backend("lm")
#' get_model_backend("nonexistent")
get_model_backend <- function(name) {
    if (!is.character(name) || length(name) != 1 || !nzchar(name)) {
        return(NULL)
    }
    if (exists(name, envir = .model_backend_registry, inherits = FALSE)) {
        .model_backend_registry[[name]]
    } else {
        NULL
    }
}


#' List registered model backends
#'
#' Returns the names of all currently registered model backends. The built-in
#' backends (`lm`, `glm`, `loess`, `nls`) are always present; any backends
#' added via [register_model_backend()] are included as well.
#'
#' @return A sorted character vector of backend names.
#'
#' @export
#' @author Jacob Martin
#'
#' @examples
#' list_model_backends()
list_model_backends <- function() {
    sort(ls(.model_backend_registry))
}


#' Build a dynamic row_spec from registered backends
#'
#' Constructs the merged `row_spec` for [multiDynamicInput()] by combining the
#' standard model fields (model_type, formula, line_colour, line_width) with
#' any extra `fields` declared by registered backends. Each backend field is
#' tagged with `data-backend` so the client can show/hide it based on the
#' selected model type.
#'
#' @return A named list suitable for the `row_spec` argument of
#'   [multiDynamicInput()].
#'
#' @export
#' @author Jacob Martin
#'
#' @examples
#' build_model_row_spec()
build_model_row_spec <- function() {
    base_spec <- list(
        model_type  = list(type = "select",
            args = list(choices = list_model_backends(), selected = "lm")),
        formula     = list(type = "text",
            args = list(placeholder = "e.g. y ~ poly(x, 2)")),
        line_colour = list(type = "colour",
            args = list(value = "#000000")),
        line_width  = list(type = "numeric",
            args = list(value = 2, min = 0.5, max = 20, step = 0.5))
    )

    # Collect extra fields from all backends, tagging each with its owner
    backend_names <- list_model_backends()
    extra_fields <- list()
    for (bn in backend_names) {
        be <- get_model_backend(bn)
        if (!is.null(be$fields) && length(be$fields) > 0) {
            for (fn in names(be$fields)) {
                spec <- be$fields[[fn]]
                # Tag with the backend name so JS can show/hide
                spec$backend <- bn
                extra_fields[[fn]] <- spec
            }
        }
    }

    c(base_spec, extra_fields)
}
#'
#' Called from `.onLoad()` to seed the registry with the four standard backends.
#'
#' @return Invisibly returns `NULL`.
#'
#' @author Jacob Martin
#' @rdname INTERNAL_register_builtin_backends
#' @keywords internal
.register_builtin_backends <- function() {
    register_model_backend("lm", list(
        fit = function(formula, data, ...) stats::lm(formula, data = data),
        predict = function(model, newdata) as.numeric(stats::predict(model, newdata = newdata)),
        validate_classes = "lm"
    ))
    register_model_backend("glm", list(
        fit = function(formula, data, ...) stats::glm(formula, data = data),
        predict = function(model, newdata) as.numeric(stats::predict(model, newdata = newdata)),
        validate_classes = "glm"
    ))
    register_model_backend("loess", list(
        fit = function(formula, data, ...) stats::loess(formula, data = data),
        predict = function(model, newdata) as.numeric(stats::predict(model, newdata = newdata)),
        validate_classes = "loess"
    ))
    register_model_backend("nls", list(
        fit = function(formula, data, ...) stats::nls(formula, data = data),
        predict = function(model, newdata) as.numeric(stats::predict(model, newdata = newdata)),
        validate_classes = "nls"
    ))
    invisible(NULL)
}
