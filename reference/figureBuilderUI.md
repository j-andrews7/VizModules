# UI component for the Figure Builder module

Renders the full multi-panel **Figure Builder** interface (sidebar
controls plus the free-form A4 canvas) as a namespaced Shiny module.
Place this in the UI where you want the builder to appear, using an `id`
that matches the one passed to
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md).

## Usage

``` r
figureBuilderUI(id, title = "VizModules Figure Builder")
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` given to
  [`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md).

- title:

  A character string used as the header shown above the builder
  (default: `"VizModules Figure Builder"`). Pass `NULL` to omit the
  header, which is useful when the host page supplies its own title.

## Value

A Shiny `tagList` containing the Figure Builder UI.

## Details

Unlike
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)
(which returns a complete, standalone app), this function returns a
`tagList` you can drop into any page, so the builder can be embedded
alongside other content and instantiated more than once (each instance
keeps its own namespace, canvas, and downloads). The module gallery,
[`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.md),
embeds it this way as its **Figure Builder** tab.

The returned UI bundles the JavaScript and CSS the canvas needs, and
calls
[`shinyjs::useShinyjs()`](https://rdrr.io/pkg/shinyjs/man/useShinyjs.html),
so no extra setup is required in the host app.

## See also

[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md),
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md),
[`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
figureBuilderUI("figure_builder")
}
```
