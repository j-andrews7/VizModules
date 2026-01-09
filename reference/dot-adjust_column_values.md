# Adjust numeric column values in a data frame using mathematical transformations

Applies common mathematical transformations (logarithmic, absolute
value, square root) to a specified numeric column in a data frame.
Returns original data frame unchanged when no transformation is
specified or input is invalid.

## Usage

``` r
.adjust_column_values(df, col_names, transformation = NULL)
```

## Arguments

- df:

  A data frame containing the column to be transformed

- col_names:

  `character(1)` Name of the column to transform Must be a vector e.g.
  c("Species", "Region")

- transformation:

  `character(1)` or `NULL`. One of
  `c("", "log2", "log", "log10", "neg_log10", "log1p", "abs", "sqrt")`.
  Use `""` or `NULL` for no transformation.

## Value

A data frame identical to input `df` but with specified column
transformed

## Details

Supported transformations include:

- `"log2"`:

  \\\log_2(x)\\ - base 2 logarithm

- `"log"`:

  \\\ln(x)\\ - natural logarithm (base \\e \approx 2.718\\)

- `"log10"`:

  \\\log\_{10}(x)\\ - base 10 logarithm

- `"neg_log10"`:

  \\-\log\_{10}(x)\\ - negative base 10 logarithm (p-values)

- `"log1p"`:

  \\\ln(1+x)\\ - natural log of (1 + x), stable for values near 0

- `"abs"`:

  \\\|x\|\\ - absolute value

- `"sqrt"`:

  \\\sqrt{x}\\ - square root

## Author

Jacob Martin
