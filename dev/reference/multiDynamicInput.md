# Dynamic multi-row input for repeating groups of inputs

A custom Shiny input that lets users dynamically add and remove
**rows**, where each row is a group of heterogeneous inputs (e.g. a
select, a text box, a colour picker, and a numeric input on one line). A
`+ Add` button appends a row; an `X` button on each row deletes it. Rows
are added and removed entirely on the client by cloning a hidden
template and letting Shiny bind the new inputs, mirroring the
architecture of
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/dev/reference/multiColorPicker.md).

## Usage

``` r
multiDynamicInput(
  inputId,
  label = NULL,
  row_spec,
  elements = NULL,
  max_per_row = 4,
  add_label = "+ Add",
  width = NULL,
  panel = TRUE
)
```

## Arguments

- inputId:

  Character. Shiny input id.

- label:

  Optional label displayed next to the add button.

- row_spec:

  A named list describing one row. Each element is itself a list
  specifying a single field, with either:

  - `type` — a string alias: one of `"select"`, `"text"`, `"numeric"`,
    `"slider"`, `"checkbox"`, `"colour"`/`"color"`; or

  - `fn` — an input constructor function (e.g.
    [`shiny::dateInput`](https://rdrr.io/pkg/shiny/man/dateInput.html)).

  plus an optional `args` list of arguments passed to the constructor
  (everything except `inputId`, which is generated per row). The element
  name becomes the key under which that field's value is returned.

- elements:

  Optional initial rows to display on startup. A named list of rows
  (each a named list keyed by the `row_spec` names) in the same shape as
  the return value. For example:
  `list(models1 = list(model_type = "lm", formula = "y ~ x", line_colour = "#FF0000", line_width = 2))`.

- max_per_row:

  Integer. Maximum number of fields on one visual line before wrapping.
  Default `4`.

- add_label:

  Character. Label for the add button. Default `"+ Add"`.

- width:

  Optional CSS width for the container.

- panel:

  Logical. If `FALSE`, removes the surrounding panel/well styling.

## Value

A UI element that produces a named list of rows.

## Details

The value reported to `input[[inputId]]` is a **named list of rows**
(`model1`, `model2`, ...), each a named list keyed by the `row_spec`
names.

The component is generic over input type. Each field in `row_spec` is
described by an input constructor and its arguments, so any Shiny input
that takes `inputId` as its first argument can be used. Common types
have a short `type = "..."` alias.

## Author

Jacob Martin

## Examples

``` r
if (interactive()) {
    library(shiny)

    ui <- fluidPage(
        multiDynamicInput(
            "models",
            label = "Models",
            row_spec = list(
                model_type  = list(type = "select",
                    args = list(choices = c("lm", "glm", "loess", "nls"))),
                formula     = list(type = "text",
                    args = list(placeholder = "y ~ poly(x, 2)")),
                line_colour = list(type = "colour", args = list(value = "#000000"))
            )
        ),
        verbatimTextOutput("chosen")
    )

    server <- function(input, output, session) {
        output$chosen <- renderPrint(input$models)
    }

    shinyApp(ui, server)
}
```
