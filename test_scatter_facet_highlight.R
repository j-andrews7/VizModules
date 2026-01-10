# Test script for faceted scatterPlot highlighting fix
# This tests the issue described in: 
# https://github.com/j-andrews7/vizModules/issues/XX
# 
# The issue: When faceting is applied and points are highlighted, the points 
# should only be highlighted in panels where they are "real" data, not in 
# panels where they appear due to show.others or split.show.all.others.

library(shiny)
library(devtools)

# Load the package
devtools::load_all()

# Setup test data as described in the issue
iris$group <- rep(c("A", "B"), each = 75)
data_list <- list("mtcars" = mtcars, "iris" = iris)

# Create the app
app <- scatterPlotApp(data_list)

# Run the app
cat("\n=== Testing ScatterPlot with Faceting and Highlighting ===\n")
cat("1. The app will launch with mtcars and iris datasets\n")
cat("2. Navigate to the iris plot\n")
cat("3. Set the following:\n")
cat("   - X-axis: Sepal.Length\n")
cat("   - Y-axis: Sepal.Width\n")
cat("   - Split by: Species, group (select both)\n")
cat("   - Annotate by: group\n")
cat("   - Points to highlight: A\n")
cat("4. Click 'Update Plot'\n")
cat("\n")
cat("Expected behavior:\n")
cat("- Points with group='A' should ONLY be highlighted in the 'Species: *, Group: A' panels\n")
cat("- Points with group='A' should NOT be highlighted in the 'Species: *, Group: B' panels\n")
cat("  (even though they appear there as gray points due to show.others)\n")
cat("\n")
cat("Also test:\n")
cat("- With 1 split variable (just Species)\n")
cat("- With 0 split variables (no faceting)\n")
cat("- With show.others = FALSE\n")
cat("- With split.show.all.others = FALSE\n")
cat("- Annotations should appear in the correct panels\n")
cat("\n")

if (interactive()) {
    runApp(app)
}
