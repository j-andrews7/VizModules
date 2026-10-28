# Pick the comparisons a `defaults` list asks for from those on offer

The Comparisons selector is repopulated from the data whenever its
grouping columns change, so a `stat.pairs` default cannot simply be
written into the UI. The modules instead select, from each fresh set of
choices, the ones `defaults$stat.pairs` names. A pair matches in either
orientation, so `"Mid vs Entry"` selects the `"Entry vs Mid"` choice.

## Usage

``` r
default_stat_pairs(defaults, pair_strings)
```

## Arguments

- defaults:

  A named list of module defaults, or `NULL`.

- pair_strings:

  Character vector of `"A vs B"` choices on offer, as from
  [`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/generate_pair_strings.md).

## Value

The elements of `pair_strings` that `defaults$stat.pairs` names. When it
names none, `""`, which is what the selector needs to show an empty
selection (and means every pair is tested).

## See also

[`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/generate_pair_strings.md),
[`parse_pair_strings()`](https://j-andrews7.github.io/VizModules/reference/parse_pair_strings.md),
[`reset_stats_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_stats_inputs.md)

## Author

Jared Andrews

## Examples

``` r
choices <- c("Entry vs Mid", "Entry vs Late", "Mid vs Late")
default_stat_pairs(list(stat.pairs = "Mid vs Entry"), choices)
#> [1] "Entry vs Mid"
default_stat_pairs(NULL, choices)
#> [1] ""
```
