test_that("multiColorPicker builds widget with dependencies and groups", {
  groups <- c("setosa", "virginica")
  widget <- multiColorPicker("species_cols", groups = groups)

  expect_s3_class(widget, "shiny.tag.list")

  deps <- htmltools::findDependencies(widget)
  expect_true(any(vapply(deps, `[[`, "", "name") == "multi-color-picker"))

  container <- widget[[2]]
  expect_equal(container$attribs$id, "species_cols")
  data_groups <- jsonlite::fromJSON(container$attribs[["data-groups"]])
  expect_identical(data_groups, groups)

  initial <- jsonlite::fromJSON(container$attribs[["data-initial"]])
  expect_identical(names(initial), groups)
  expect_true(all(grepl("^#", unlist(initial))))
})

test_that("multiColorPicker respects selected palette and manual overrides", {
  palettes <- list(
    Custom = list(
      Bright = c("#111111", "#222222"),
      Pastel = c("#ABCDEF", "#123456")
    )
  )

  widget <- multiColorPicker(
    "cols",
    groups = c("A", "B", "C"),
    palette_options = palettes,
    selected_palette = "Pastel",
    colors = c(A = "#000000")
  )

  container <- widget[[2]]
  expect_match(container$attribs[["data-default-palette"]], "Pastel")

  initial <- jsonlite::fromJSON(container$attribs[["data-initial"]])
  expect_identical(initial[["A"]], "#000000")
  expect_identical(initial[["B"]], "#123456")
  expect_identical(initial[["C"]], "#ABCDEF")
})

test_that("input handler returns named vector and handles null", {
  .register_multi_color_picker_handler()
  registry <- getFromNamespace("inputHandlers", "shiny")
  handler <- registry$get("vizModules.multiColorPicker")

  data <- list(
    list(name = "setosa", value = "#E69F00"),
    list(name = "virginica", value = "#56B4E9"),
    list(name = "versicolor", value = "#009E73")
  )

  res <- handler(data)
  expect_identical(
    res,
    c("setosa" = "#E69F00", "virginica" = "#56B4E9", "versicolor" = "#009E73")
  )
  expect_identical(handler(NULL), setNames(character(0), character(0)))
})
