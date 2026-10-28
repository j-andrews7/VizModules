# Evaluate a plot expression under a fixed random seed

Builds a plot with a reproducible random stream so randomised layers
(jitter, most notably) land in the same place on every rebuild. Without
this, any input change re-draws the jitter offsets, which makes points
appear to jump around and leaves anything anchored to a point's position
pointing at stale coordinates. The caller's random stream is restored
afterwards.

## Usage

``` r
with_stable_seed(expr, seed = 42L)
```

## Arguments

- expr:

  Expression producing the plot. Evaluated lazily, after the seed is
  set.

- seed:

  Integer. Seed to build under.

## Value

The value of `expr`.

## Author

Jared Andrews

## Examples

``` r
with_stable_seed(runif(2))
#> [1] 0.9148060 0.9370754
with_stable_seed(runif(2))
#> [1] 0.9148060 0.9370754
```
