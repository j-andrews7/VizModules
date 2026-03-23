# Example multi-player skills dataset for radar plots

A dataset of skill ratings across five categories for three players,
suitable for radar/spider chart examples.

## Usage

``` r
example_skills
```

## Format

A data frame with 15 rows and 3 columns:

- category:

  Skill category (Speed, Strength, Defense, Stamina, Agility)

- value:

  Skill rating (1-10)

- player:

  Player identifier (Player A, B, or C)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
example_skills
#>    category value   player
#> 1     Speed     8 Player A
#> 2  Strength     6 Player A
#> 3   Defense     7 Player A
#> 4   Stamina     9 Player A
#> 5   Agility     7 Player A
#> 6     Speed     5 Player B
#> 7  Strength     9 Player B
#> 8   Defense     8 Player B
#> 9   Stamina     6 Player B
#> 10  Agility     4 Player B
#> 11    Speed     7 Player C
#> 12 Strength     7 Player C
#> 13  Defense     5 Player C
#> 14  Stamina     8 Player C
#> 15  Agility     9 Player C
```
