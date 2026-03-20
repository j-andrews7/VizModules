# Generate example datasets for module apps

set.seed(7)

# Sales data: 10 years × 12 months × 6 regions = 720 rows
years_sales <- rep(2015:2024, each = 72)
months <- rep(rep(month.abb, each = 6), 10)
regions <- rep(c("North", "South", "East", "West", "Central", "International"), 120)

example_sales <- data.frame(
    region = factor(regions),
    revenue = round(runif(720, 50, 200) + rep(seq(0, 350, length.out = 720)), 1),
    year = factor(years_sales),
    month = factor(months, levels = month.abb),
    units = sample(100:500, 720, replace = TRUE),
    sale_id = paste0("Sale_", seq_len(720))
)

# Population data: 50 years × 8 age groups = 400 rows
years <- rep(1975:2024, each = 8)
age_groups <- rep(c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+"), 50)

example_population <- data.frame(
    year = factor(years),
    age_group = factor(
        age_groups,
        levels = c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+")
    ),
    count = round(rnorm(400, mean = 5000, sd = 800) + rep(seq(0, 3900, length.out = 400))),
    record_id = paste0("Record_", seq_len(400))
)

# iris with an added Group column for multi-group examples
example_iris <- iris
example_iris$Group <- c(rep(c("A", "B"), 50), rep(c("C", "D"), 25))

# mtcars with key columns as factors
example_mtcars <- transform(
    mtcars,
    cyl  = factor(cyl),
    gear = factor(gear),
    vs   = factor(vs)
)

# School-earnings data for dumbbell plots
example_school_earnings <- data.frame(
    School = c("MIT", "Stanford", "Harvard", "Yale", "Princeton", "Columbia"),
    Women  = c(94, 96, 112, 188, 91, 129),
    Men    = c(52, 101, 165, 145, 148, 155),
    Group  = c("STEM-heavy", "STEM-heavy", "Liberal Arts", "Liberal Arts",
               "Liberal Arts", "STEM-heavy")
)

# Multi-player skills data for radar plots
example_skills <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Agility"), 3),
    value    = c(8, 6, 7, 9, 7, 5, 9, 8, 6, 4, 7, 7, 5, 8, 9),
    player   = rep(c("Player A", "Player B", "Player C"), each = 5)
)

# Roles data for ternary plots
example_roles <- data.frame(
    journalist = c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20),
    developer  = c(25, 10, 20, 60, 80, 90, 70, 20,  5, 10, 10),
    designer   = c( 0, 20,  5, 35, 10,  0, 10, 70, 80, 80, 70),
    label      = paste("point", seq_len(11)),
    team       = c(rep("Team A", 6), rep("Team B", 5))
)

usethis::use_data(
    example_sales, example_population,
    example_iris, example_mtcars,
    example_school_earnings, example_skills, example_roles,
    gallery_sales, gallery_demographics,
    overwrite = TRUE
)
