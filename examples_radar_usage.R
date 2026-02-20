# Example usage of the radar plot module
# This script demonstrates how to use the radarPlot function and radarPlotApp

library(VizModules)

# Example 1: Single trace radar chart
# Create player skills data
# NOTE: Polygon is automatically closed by the function - no need to repeat first point
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina"),
    value = c(8, 6, 7, 9)
)

# Create a simple radar plot
fig <- radarPlot(
    df = skills,
    theta = "category",
    r = "value",
    title.text = "Player Skills"
)
print(fig)

# Example 2: Multiple trace radar chart
# Create team comparison data
# NOTE: Polygon is automatically closed for each trace - no need to repeat first point
team_stats <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina"), 2),
    value = c(8, 6, 7, 9, 5, 9, 8, 6),
    player = rep(c("Player A", "Player B"), each = 4)
)

# Create a multi-trace radar plot with custom styling
fig2 <- radarPlot(
    df = team_stats,
    theta = "category",
    r = "value",
    group = "player",
    title.text = "Team Comparison",
    colors = c("Player A" = "#1F77B4", "Player B" = "#FF7F0E"),
    opacity = 0.6,
    radial.range = c(0, 10)
)
print(fig2)

# Example 3: Using the Shiny app
# Prepare data for the app
data_list <- list(
    "Player Skills" = skills,
    "Team Stats" = team_stats
)

# Launch the interactive Shiny app
# Uncomment the line below to run the app
# app <- radarPlotApp(data_list)
# runApp(app)
