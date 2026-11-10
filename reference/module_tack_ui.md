# Create standard tack UI for module inputs

Generates a consistent set of control buttons for VizModules that
includes Auto Update toggle, Update and Reset buttons, and a full source
download button (self-contained HTML of the plot, SVG and PNG images of
it, and the source data and statistics as CSVs).

## Usage

``` r
module_tack_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  Namespace function from the module (e.g., `ns <- NS(id)`).

- defaults:

  Optional named list of default values. Reserved for future use.

## Value

A Shiny tagList containing the standard control buttons and inputs.

## Details

The download button carries the markup the image capture needs: the
class the script binds to, and the module's namespace prefix, which is
how the script works out which plot on the page belongs to this button.
See
[`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/reference/create_source_download_handler.md).

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
library(shiny)
ns <- NS("myModule")
module_tack_ui(ns)
}
```
