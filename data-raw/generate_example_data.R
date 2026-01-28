# Generate example datasets for module apps

set.seed(7)

# Sales data: 10 years × 12 months × 6 regions = 720 rows
years_sales <- rep(2015:2024, each = 72)
months <- rep(rep(month.abb, each = 6), 10)
regions <- rep(c("North", "South", "East", "West", "Central", "International"), 120)

example_sales <- data.frame(
    sale_id = paste0("Sale_", seq_len(720)),
    year = factor(years_sales),
    month = factor(months, levels = month.abb),
    region = factor(regions),
    revenue = round(runif(720, 50, 200) + rep(seq(0, 350, length.out = 720)), 1),
    units = sample(100:500, 720, replace = TRUE)
)

# Population data: 50 years × 8 age groups = 400 rows
years <- rep(1975:2024, each = 8)
age_groups <- rep(c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+"), 50)

example_population <- data.frame(
    record_id = paste0("Record_", seq_len(400)),
    year = factor(years),
    age_group = factor(
        age_groups,
        levels = c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+")
    ),
    count = round(rnorm(400, mean = 5000, sd = 800) + rep(seq(0, 3900, length.out = 400)))
)

usethis::use_data(example_sales, example_population, overwrite = TRUE)
