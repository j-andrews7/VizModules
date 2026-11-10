# Generate uniform Annotation input UI

Creates a standardized tagList of the point highlighting and annotation
inputs shared by modules that draw individual data points. Points are
identified by the values of the column chosen in "Annotate By", which
are also used as the label text.

## Usage

``` r
uniform_annotation_inputs_ui(
  ns,
  defaults = NULL,
  choices = "",
  annotate.note = NULL
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- choices:

  Character vector of column names offered by "Annotate By".

- annotate.note:

  Character, or `NULL`. Extra sentence appended to the "Annotate By"
  tooltip, for module-specific caveats.

## Value

A `tagList` containing the annotation input UI elements.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
ns <- shiny::NS("plot1")
uniform_annotation_inputs_ui(ns, choices = c("", "Species", "Sepal.Length"))
}
```
