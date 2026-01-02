# Parse a string indicating a set of vectors to a list of vectors.

Used to parse text inputs into a list of vectors.

## Usage

``` r
.string_to_list_of_vectors(x)
```

## Arguments

- x:

  A string indicating a set of vectors. Supported formats include "(a,
  b), (c)", "\<a, b\>, ", or brackets. Should not contain internal
  quotes around elements.

## Value

A list like `list(c("a", "b", "c"), c("d", "e"))`. If the input is "",
just returns "". If the input is `NULL`, returns `NULL`.

## Author

Jared Andrews
