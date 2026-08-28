# Compact multi-group color picker input

Build a compact Shiny input that assigns colors to a set of groups using
a palette or manual hex pickers. The value returned to
`input[[inputId]]` is a named character vector of hex colors keyed by
group.

## Usage

``` r
multiColorPicker(
  inputId,
  label = NULL,
  groups,
  palette_options = NULL,
  selected_palette = NULL,
  colors = NULL,
  width = NULL,
  show_text = TRUE,
  compact = FALSE,
  panel = TRUE
)
```

## Arguments

- inputId:

  Character. Shiny input id.

- label:

  Optional label displayed above the control.

- groups:

  Character or factor vector of group names.

- palette_options:

  Named list of palettes (each a character vector of colors). Defaults
  to the palettes from
  [`default_palettes()`](https://j-andrews7.github.io/VizModules/dev/reference/default_palettes.md).

- selected_palette:

  Optional name of the palette to preselect.

- colors:

  Optional named vector of starting colors. Values are matched to
  `groups` by name when provided.

- width:

  Optional CSS width for the container.

- show_text:

  Logical. If `TRUE`, show editable hex text inputs beside the color
  pickers.

- compact:

  Logical. If `TRUE`, renders a tighter layout with reduced spacing,
  smaller controls, and narrower palette selector.

- panel:

  Logical. If `FALSE`, removes the surrounding panel/well styling
  (border, padding, background).

## Value

A UI element that produces a named character vector of colors.

## Details

A group's color swatch is a native `<input type="color">`, whose dialog
reports a new value for every drag or click inside it. Rather than send
each one - rebuilding a dependent plot dozens of times for a single
color choice - the input reports once the dialog has closed, detected as
the first pointer, key, or scroll event the page sees again (the dialog
holds both while it is open) or the browser window regaining focus.
Typing in a hex field is coalesced until the user pauses instead.
One-shot actions - clicking a palette swatch, "Apply", "Reset",
selecting another group, or committing a hex code with Enter or by
clicking away - report immediately.

The widget reflows to its container: the palette selector shrinks and
the buttons wrap below it when narrow, and long group names wrap rather
than running under their controls, so it can be dropped into a sidebar
or an input grid cell without controls escaping the panel.

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)
    groups <- c("setosa", "virginica", "versicolor")

    ui <- fluidPage(
        multiColorPicker(
            "species_cols",
            "Species colors",
            groups = groups,
            selected_palette = "dittoColors"
        ),
        verbatimTextOutput("chosen")
    )

    server <- function(input, output, session) {
        output$chosen <- renderPrint(input$species_cols)
    }

    shinyApp(ui, server)
}
```
