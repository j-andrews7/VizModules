# Model backend registry

A pluggable registry that lets any modelling package (drc, mgcv, brms,
etc.) be used in the custom-model-lines pipeline without modifying core
code. Each **backend** is a small named list that tells the pipeline how
to fit a model and how to predict from it.

## Details

Backends are stored in a package-level environment. The four built-in
types (`lm`, `glm`, `loess`, `nls`) are registered automatically when
the package loads. Users add new ones with
[`register_model_backend()`](https://j-andrews7.github.io/VizModules/dev/reference/register_model_backend.md).
