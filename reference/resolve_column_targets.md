# Translate column names or positions into DT column targets

Maps a set of columns onto the zero-based `targets` indices DataTables
expects inside a `columnDefs` entry. This is what
[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/reference/dataFilterServer.md)
uses to honour its `hide.columns` argument, but it is useful for any
hand-rolled
[`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html) where
columns are referred to by name rather than by position – hiding them,
setting widths, disabling ordering, and so on.

## Usage

``` r
resolve_column_targets(data, columns, rownames = FALSE)
```

## Arguments

- data:

  A data frame, or a character vector of the column names in the order
  they are passed to
  [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html).

- columns:

  `NULL`, a character vector of column names, or a numeric vector of
  one-based column positions to resolve.

- rownames:

  Logical. Whether the table is drawn with a row-names column (the
  `rownames` argument of
  [`DT::datatable()`](https://rdrr.io/pkg/DT/man/datatable.html)). When
  `TRUE`, row names occupy column 0 and every data column shifts one to
  the right, so the returned targets are shifted to match. Defaults to
  `FALSE`.

## Value

An integer vector of zero-based column indices, possibly empty.

## Details

Columns that do not exist are dropped with a warning rather than raising
an error, so a table fed by a changing data frame keeps rendering when a
column comes and goes.

## See also

[`dataFilterServer()`](https://j-andrews7.github.io/VizModules/reference/dataFilterServer.md)

## Author

Jared Andrews

## Examples

``` r
# Hide two columns of a plain DT table by name.
targets <- resolve_column_targets(iris, c("Petal.Length", "Petal.Width"))
targets
#> [1] 2 3

if (interactive()) {
    DT::datatable(
        iris,
        rownames = FALSE,
        options = list(
            columnDefs = list(list(visible = FALSE, targets = targets))
        )
    )
}
```
