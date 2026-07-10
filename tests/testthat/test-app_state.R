test_that("app_state_schema_version returns a version string", {
    v <- app_state_schema_version()
    expect_type(v, "character")
    expect_length(v, 1L)
    expect_match(v, "^[0-9]+\\.[0-9]+$")
})

test_that("sanitize_input_snapshot drops transient and non-serialisable keys", {
    snap <- sanitize_input_snapshot(list(
        "x.data" = "mpg",
        "y.data" = "hp",
        "flag" = TRUE,
        "table_rows_all" = 1:10,
        "table_rows_selected" = 2L,
        "table_search" = "abc",
        ".clientdata_output_height" = 400,
        "plot_relayout" = list(x = 1),
        "plotly_hover-A" = list(1),
        "go" = structure(3L, class = "shinyActionButtonValue"),
        "file" = data.frame(name = "a", datapath = "/tmp/a", stringsAsFactors = FALSE)
    ))

    expect_setequal(names(snap), c("x.data", "y.data", "flag"))
    expect_identical(snap$x.data, "mpg")
    expect_true(snap$flag)
})

test_that("sanitize_input_snapshot tolerates NULL / empty input", {
    expect_length(sanitize_input_snapshot(NULL), 0L)
    expect_length(sanitize_input_snapshot(list()), 0L)
})

test_that("serialize_app_state stamps schema version and timestamp", {
    json <- serialize_app_state(list(app = list(name = "figure-builder")))
    parsed <- jsonlite::fromJSON(json, simplifyVector = TRUE)

    expect_identical(parsed$schema_version, app_state_schema_version())
    expect_identical(parsed$app$name, "figure-builder")
    expect_true(nzchar(parsed$app$timestamp))
})

test_that("serialize/deserialize round-trips panels and app inputs", {
    state <- list(
        app = list(name = "figure-builder", vizmodules_version = "0.2.1"),
        app_inputs = list(orientation = "landscape", label_case = "upper"),
        panels = list(
            list(
                module = "scatter", dataset = "example_iris",
                label = "Scatter #1 (example_iris)",
                inputs = list(
                    "x.data" = "Sepal.Length",
                    "y.data" = "Sepal.Width",
                    "groups" = c("a", "b")
                ),
                geometry = list(top = 20, left = 30, width = 300, height = 260)
            )
        )
    )

    back <- deserialize_app_state(serialize_app_state(state))

    expect_length(back$panels, 1L)
    p <- back$panels[[1]]
    expect_identical(p$module, "scatter")
    expect_identical(p$dataset, "example_iris")
    expect_identical(p$inputs$x.data, "Sepal.Length")
    expect_identical(p$inputs$groups, c("a", "b"))
    expect_equal(p$geometry$width, 300)
    expect_identical(back$app_inputs$orientation, "landscape")
})

test_that("deserialize_app_state validates version and structure", {
    expect_error(deserialize_app_state(""), "No app-state JSON")
    expect_error(
        deserialize_app_state('{"panels": []}'),
        "schema_version"
    )
    bad <- sprintf('{"schema_version": "%d.0", "panels": []}',
        as.integer(strsplit(app_state_schema_version(), ".", fixed = TRUE)[[1]][[1]]) + 1L
    )
    expect_error(deserialize_app_state(bad), "Unsupported app-state schema version")
})

test_that("empty state produces an empty panels array", {
    back <- deserialize_app_state(serialize_app_state(list()))
    expect_length(back$panels, 0L)
    expect_true(is.list(back$panels))
})
