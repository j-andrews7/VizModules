# Require a data frame from a module's data reactive

Wraps the `data` reactive every module server receives so that
downstream readers always see a data frame. A `NULL` value (which a
parent app can emit briefly while switching datasets) becomes a silent
[`shiny::req()`](https://rdrr.io/pkg/shiny/man/req.html) skip rather
than an error cascade through every observer, and anything else is
coerced with
[`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html) before
use.

## Usage

``` r
require_data_frame(data)
```

## Arguments

- data:

  A `reactive` returning a data frame or an object coercible to one.

## Value

A `reactive` returning a data frame with at least one column.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# First line of a module server, before anything reads `data()`:
data <- require_data_frame(data)
} # }
```
