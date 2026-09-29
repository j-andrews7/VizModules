# Example sales dataset

A simulated product-sales dataset: one sale for each month of 2015-2024
in each of six regions (720 rows), with each year's sales split evenly
across three product lines. Units sold follow a trend per product line
(Gadgets growing, Widgets flat, Doohickeys declining), peak in November
and December, and scale by region. Revenue is units times a per-product
unit price, so revenue against units falls on one line per product line.
Two sales are planted outliers: `Sale_352`, a promotion that shifted far
more units than usual, and `Sale_540`, a clearance sale at well under
half price. Designed to showcase the scatter, line, parallel coordinates
and pie plot modules.

## Usage

``` r
example_sales
```

## Format

A data frame with 720 rows and 8 columns:

- region:

  Region of the sale (factor: North, South, East, West, Central,
  International)

- revenue:

  Revenue of the sale (thousands of USD)

- year:

  The year (factor: 2015-2024)

- month:

  The month (factor: Jan-Dec)

- units:

  Units sold (integer)

- sale_id:

  Unique sale identifier

- product_line:

  Product line (factor: Gadgets, Widgets, Doohickeys)

- profit:

  Profit on the sale after a fixed overhead (thousands of USD; negative
  for a few low-volume Doohickey sales)

## Source

Generated in data-raw/generate_example_data.R.

## Author

Jared Andrews
