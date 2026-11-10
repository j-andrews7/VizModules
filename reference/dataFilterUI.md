# UI component for the dataFilter module

Renders an interactive DT table that allows users to filter rows of a
data frame. Place this in the UI where you want the filterable table to
appear, using an `id` that matches the one passed to
[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/reference/dataFilterServer.md).

## Usage

``` r
dataFilterUI(id)
```

## Arguments

- id:

  The ID for the Shiny module.

## Value

A Shiny `tagList` containing the DT table output.

## See also

[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/reference/dataFilterServer.md)

## Author

Jacob Martin

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
dataFilterUI("myFilter")
}
```
