# Fix for Highlighted Points in Faceted ScatterPlot

## Problem Statement

When faceting was applied to scatterPlots using `split.by` and points were highlighted using the "Points to highlight" feature, the highlighted points would appear in ALL panels, including panels where they were only shown as gray "other" points due to `show.others=TRUE` or `split.show.all.others=TRUE`.

### Example Issue
```r
iris$group <- rep(c("A", "B"), each = 75)
data_list <- list("mtcars" = mtcars, "iris" = iris)
scatterPlotApp(data_list)

# When faceting by Species and Group and highlighting points in Group "A",
# even those points in the Group "B" panels were highlighted incorrectly.
```

Additionally, annotations for highlighted points only showed up in the first panel instead of the correct panel.

## Solution Overview

The fix implements panel-aware point matching that:
1. Determines which panel each trace belongs to
2. Extracts filter values for each panel from subplot titles
3. Matches points to traces while considering panel membership
4. Only highlights/annotates points in their "home" panel

## Implementation Details

### New Helper Functions (plot_mods.R)

#### 1. `.build_panel_filter_map(fig, split.by, plot_data)`
- Maps each trace to its panel (based on xaxis/yaxis references)
- Extracts filter values for each panel from subplot title annotations
- Returns: `list(trace_to_panel, panel_to_filter, n_panels)`

#### 2. `.match_trace_to_data_with_panel(trace, plot_data, x_match_col, y_match_col, split.by, panel_filter)`
- Matches trace points to data points using coordinates
- For faceted plots, additionally checks if data points belong to the trace's panel
- Returns: `list(data_indices, trace_indices)` for matching points

#### 3. `.check_point_panel_membership(point_data, split.by, panel_filter)`
- Checks if a data point's split.by values match the panel's filter
- Returns: `TRUE` if point belongs to panel, `FALSE` otherwise

#### 4. `.parse_panel_title(title_text, split.by)`
- Parses plotly subplot titles to extract filter values
- Handles 1 or 2 split.by variables
- Example: "Species: setosa<br>Group: A" → `list(Species="setosa", Group="A")`

### Updated Server Logic (scatterPlot_module_server.R)

#### Highlighting Section (lines ~254-374)
```r
# Build panel filter map
panel_map <- .build_panel_filter_map(fig, split.by, plot_data)

for (trace in traces) {
    # Get panel info for this trace
    trace_panel_idx <- panel_map$trace_to_panel[i]
    panel_filter <- panel_map$panel_to_filter[[trace_panel_idx]]
    
    # Match points considering panel membership
    matches <- .match_trace_to_data_with_panel(
        trace, plot_data, x_col, y_col, split.by, panel_filter
    )
    
    # Apply highlighting only to matched points
    highlight_mask[matches$trace_indices] <- TRUE
}
```

#### Manual Annotation Section (lines ~403-490)
- Added panel membership check before creating annotations
- Skips annotations for points that don't belong to the selected panel

#### Auto-Annotation Section (lines ~493-591)
- Determines which panel each highlighted point belongs to
- Assigns correct xref/yref for annotations based on panel
- Creates annotations in the correct panels

## Key Features

1. **Works with 0, 1, or 2 split.by variables**
   - 0 split variables: Simple coordinate matching (no panel filtering)
   - 1 split variable: Single faceting dimension
   - 2 split variables: Two faceting dimensions

2. **Handles show.others and split.show.all.others correctly**
   - Points shown in gray due to these settings are not highlighted
   - Only "real" data points in each panel get highlighted

3. **Robust edge case handling**
   - Gracefully handles missing panel filters
   - Fallback to coordinate-only matching if panel structure can't be determined
   - Safe defaults for all operations

4. **Maintains backward compatibility**
   - Non-faceted plots work exactly as before
   - No changes to API or user-facing functionality

## Testing

Use `test_scatter_facet_highlight.R` to verify the fix:

```r
source("test_scatter_facet_highlight.R")
```

### Test Cases
1. No faceting (split.by = NULL)
2. Single split variable (e.g., Species only)
3. Two split variables (e.g., Species and Group)
4. With show.others = TRUE/FALSE
5. With split.show.all.others = TRUE/FALSE
6. Annotations in correct panels

### Expected Behavior
- Points should ONLY be highlighted in panels where they are actual data
- Annotations should appear in the correct panel (not just the first one)
- Gray "other" points should never be highlighted

## Files Changed

1. `R/plot_mods.R` - Added 4 helper functions (~250 lines)
2. `R/scatterPlot_module_server.R` - Updated highlighting and annotation logic (~80 lines modified)
3. `test_scatter_facet_highlight.R` - Test script
4. `.Rbuildignore` - Exclude test files
5. `NEWS.md` - Document the fix

## Technical Notes

### Panel Detection Strategy
Plotly creates subplots with different axis references (x, x2, x3, etc.). We:
1. Map each trace to its axes (xaxis/yaxis properties)
2. Group traces sharing the same axes into panels
3. Extract panel identity from subplot title annotations

### Panel Filter Extraction
Plotly creates title annotations for subplots with specific properties:
- `showarrow = FALSE`
- Positioned at the top of each panel
- Text format: "Variable: value" or "Var1: val1<br>Var2: val2"

We parse these titles to determine which split.by values define each panel.

### Point Matching Algorithm
For each trace point:
1. Find data points with matching x/y coordinates
2. If multiple matches (duplicate coordinates), check panel membership
3. Only match the point that belongs to this trace's panel
4. This prevents highlighting "show.others" points

## Limitations

1. **Panel title parsing dependency**: If dittoViz changes how it formats panel titles, the parsing logic may need updates
2. **Performance**: For very large datasets with many panels, the nested loop in point matching could be slow (though this is unlikely to be noticeable)
3. **Three or more split variables**: Code only handles up to 2 split.by variables (as per dittoViz limitation)

## Future Enhancements

Potential improvements:
1. Cache panel membership lookups for better performance
2. Support for custom panel title formats
3. More robust panel detection (not relying solely on title parsing)
4. Unit tests for helper functions
