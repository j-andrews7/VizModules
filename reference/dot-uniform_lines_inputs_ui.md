# Generate uniform Lines input UI

Creates a standardized tagList of line-related inputs (horizontal,
vertical, and diagonal lines) for use across plot modules.

## Usage

``` r
.uniform_lines_inputs_ui(ns, defaults = NULL, include.fit.lines = FALSE)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.fit.lines:

  Logical; whether to include "line of best fit" and "linear model line"
  inputs. Only applicable for scatter plots. Default is FALSE.

## Value

A `tagList` containing the line input UI elements.
