# The "Plot with WebGL" toggle for a module's point layers

On (the default), the plot's points switch to WebGL once there are
enough of them (see
[`auto_webgl()`](https://j-andrews7.github.io/VizModules/reference/auto_webgl.md));
off, they always stay SVG, so SVG downloads stay fully vector. Read it
in the module's plot step with `!isFALSE(isolate_fn(input$webgl))`, so a
client that has not reported it yet counts as on.

## Usage

``` r
webgl_input(ns, defaults = NULL)
```

## Arguments

- ns:

  The module's namespace function.

- defaults:

  The module's `defaults`, whose `webgl` entry sets the value.

## Value

A tooltipped checkbox input with id `webgl`.

## See also

[`auto_webgl()`](https://j-andrews7.github.io/VizModules/reference/auto_webgl.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
webgl_input(shiny::NS("plot"))
webgl_input(shiny::NS("plot"), defaults = list(webgl = FALSE))
}
```
