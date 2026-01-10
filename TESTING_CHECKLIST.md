# Manual Testing Checklist

This document outlines the manual testing that should be performed to validate the fix.

## Prerequisites

1. Install R and required dependencies
2. Load the package: `devtools::load_all()`
3. Run the test app: `source("test_scatter_facet_highlight.R")`

## Test Scenarios

### Scenario 1: No Faceting (Baseline)
- [  ] Set split.by to nothing (no faceting)
- [  ] Highlight points using "Annotate by" = species, "Points to highlight" = setosa
- [  ] Verify: Only setosa points are highlighted (no panels)
- [  ] Verify: Auto-annotations appear on highlighted points

### Scenario 2: Single Split Variable
- [  ] Set split.by = Species
- [  ] Set "Annotate by" = group
- [  ] Set "Points to highlight" = A
- [  ] Click "Update Plot"
- [  ] Verify: Points with group=A are highlighted in all Species panels
- [  ] Verify: Gray "other" points are NOT highlighted
- [  ] Verify: Annotations appear in correct panels (not just first panel)

### Scenario 3: Two Split Variables (Main Issue Case)
- [  ] Set split.by = Species, group (both selected)
- [  ] Set "Annotate by" = group
- [  ] Set "Points to highlight" = A
- [  ] Click "Update Plot"
- [  ] Verify: Points are ONLY highlighted in "Species: *, Group: A" panels
- [  ] Verify: Points are NOT highlighted in "Species: *, Group: B" panels
- [  ] Verify: Annotations appear in the "Group: A" panels only

### Scenario 4: show.others = FALSE
- [  ] Set split.by = Species, group
- [  ] Uncheck "Show others"
- [  ] Set "Annotate by" = group
- [  ] Set "Points to highlight" = A
- [  ] Click "Update Plot"
- [  ] Verify: Only points belonging to each panel are shown (no gray points)
- [  ] Verify: Highlighting works correctly

### Scenario 5: split.show.all.others = FALSE
- [  ] Set split.by = Species, group
- [  ] Uncheck "Show split others"
- [  ] Set "Annotate by" = group
- [  ] Set "Points to highlight" = A
- [  ] Click "Update Plot"
- [  ] Verify: Behavior is correct (points from other split groups not shown)
- [  ] Verify: Highlighting works correctly

### Scenario 6: Manual Annotations (Box Select)
- [  ] Set split.by = Species, group
- [  ] Set "Annotate by" = group
- [  ] Use plotly's box select tool to select points
- [  ] Verify: Annotations only appear in the panel where points were selected
- [  ] Verify: No annotations appear for "show.others" points even if selected

### Scenario 7: Different Data (mtcars)
- [  ] Switch to mtcars dataset
- [  ] Set split.by = cyl (convert to factor first if needed)
- [  ] Set color.by = gear
- [  ] Set "Annotate by" = gear
- [  ] Set "Points to highlight" = 4
- [  ] Verify: Highlighting works correctly across different dataset

## Visual Verification

For each test, take screenshots or notes of:
1. Which panels show highlighted points
2. Where annotations appear
3. Whether gray "other" points are highlighted (they shouldn't be)

## Bug Verification

The original issue showed this behavior (WRONG):
![Wrong behavior](https://github.com/user-attachments/assets/e0e75576-fbaa-4c2a-bc41-24fe0c8f3b87)

After the fix, you should see:
- Red highlighted points ONLY in the "Group: A" panels (top two panels)
- No red highlighting in the "Group: B" panels (bottom two panels)
- Annotations appearing in all panels where points are highlighted

## Edge Cases to Test

1. [  ] Empty "Points to highlight" field
2. [  ] Non-existent value in "Points to highlight"
3. [  ] Very large datasets (performance)
4. [  ] Switching between different split.by configurations
5. [  ] Clearing annotations and re-adding them

## Performance Check

- [  ] Time to update plot with highlighting (should be < 2 seconds for iris)
- [  ] No console errors or warnings
- [  ] Smooth interaction with plotly controls

## Regression Testing

- [  ] Other plot features still work (contours, ellipses, trajectories, etc.)
- [  ] Non-scatter plots not affected (if any use similar logic)
- [  ] Legend still displays correctly
- [  ] Color panels and shape panels work correctly

## Sign-off

Once all tests pass:
- Tester name: _______________
- Date: _______________
- Issues found: _______________
- Notes: _______________
