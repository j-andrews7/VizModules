# Generate uniform Axes input UI

Creates a standardized tagList of axis-related inputs for use across
plot modules.

## Usage

``` r
.uniform_axes_inputs_ui(
  ns,
  defaults = NULL,
  include.rotate = FALSE,
  include.flip = FALSE
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.rotate:

  Logical; whether to include the "Rotate" input for swapping x and y
  axes (e.g., horizontal bar plots). Default is FALSE.

## Value

A `tagList` containing the axis input UI elements.
