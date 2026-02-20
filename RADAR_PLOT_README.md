# Radar Plot Module

A comprehensive radar chart (spider chart) module for VizModules, built on plotly's scatterpolar type.

## Overview

The radar plot module provides interactive, customizable radar charts for visualizing multivariate data. It supports both single and multiple trace plots with extensive styling options.

## Features

- **Single and Multiple Traces**: Display one or multiple overlapping radar traces
- **Fully Interactive**: Zoom, pan, hover tooltips via plotly
- **Customizable Styling**: 
  - Line styles (solid, dashed, dotted, etc.)
  - Marker shapes and sizes
  - Trace colors and opacity
  - Fill options
- **Axis Controls**:
  - Radial axis range and visibility
  - Angular axis direction and rotation
  - Grid colors and styles
- **Shiny Integration**: Complete module with InputsUI, OutputUI, and Server components
- **Auto-update & Reset**: Built-in controls for plot updates

## Files

- `R/radarPlot.R` - Core plotting function
- `R/radarPlot_module_ui.R` - UI components (InputsUI, OutputUI)
- `R/radarPlot_module_server.R` - Server logic
- `R/radarPlot_module_app.R` - Example Shiny app

## Usage

### Basic Radar Plot

```r
library(VizModules)

# Single trace example
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
    value = c(8, 6, 7, 9, 8)
)

fig <- radarPlot(
    df = skills,
    theta = "category",
    r = "value",
    title.text = "Player Skills"
)
```

### Multiple Trace Radar Plot

```r
# Multiple trace example
team_stats <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Speed"), 2),
    value = c(8, 6, 7, 9, 8, 5, 9, 8, 6, 5),
    player = rep(c("Player A", "Player B"), each = 5)
)

fig <- radarPlot(
    df = team_stats,
    theta = "category",
    r = "value",
    group = "player",
    title.text = "Team Comparison",
    colors = c("Player A" = "#1F77B4", "Player B" = "#FF7F0E"),
    opacity = 0.6
)
```

### Shiny App

```r
# Create a Shiny app with multiple radar plots
data_list <- list(
    "Skills" = skills,
    "Team" = team_stats
)

app <- radarPlotApp(data_list)
runApp(app)
```

## Parameters

### radarPlot()

Key parameters for the `radarPlot()` function:

- `df`: Data frame with data to plot
- `theta`: Column name for angular categories (axes)
- `r`: Column name for radial values
- `group`: Optional column for grouping (multiple traces)
- `colors`: Color vector for traces
- `fill`: Fill area under trace ("toself", "tonext", or FALSE)
- `line.width`: Width of trace lines
- `line.dash`: Line style (solid, dot, dash, etc.)
- `marker.size`: Size of markers
- `opacity`: Trace opacity (0-1)
- `radial.range`: Range for radial axis (e.g., c(0, 10))
- `angular.direction`: "clockwise" or "counterclockwise"
- `show.legend`: Whether to show legend

## Data Format

### Single Trace
Data should have two columns:
- One for categories (theta/angular)
- One for values (r/radial)

### Multiple Traces
Data should have three columns:
- One for categories (theta/angular)
- One for values (r/radial)
- One for grouping (creates separate traces)

**Important**: To close the radar polygon, repeat the first category at the end.

## Examples

See `examples_radar_usage.R` for complete examples.

## Screenshots

### Single Trace
![Single Trace Radar Plot](https://github.com/user-attachments/assets/5c5158ed-012a-4780-a5d1-fa986eb90abe)

### Multiple Traces
![Multiple Trace Radar Plot](https://github.com/user-attachments/assets/1e12e11d-d9fe-4ad1-a05c-e22b0bcb9bdb)

## Integration with VizModules

The radar plot module follows the same structure as other VizModules:

```r
# In your Shiny UI
radarPlotInputsUI("radar", data)
radarPlotOutputUI("radar")

# In your Shiny server
radarPlotServer("radar", data = reactive(your_data))
```

## Documentation

Run `devtools::document()` to generate full R documentation (.Rd files) from the roxygen2 comments.

## Author

Jared Andrews
