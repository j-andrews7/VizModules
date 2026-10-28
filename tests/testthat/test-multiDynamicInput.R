test_that("multiDynamicInput builds widget with template and initial elements", {
    spec <- list(
        column = list(type = "select", args = list(choices = c("pathway", "score"))),
        side = list(type = "select", args = list(choices = c("Left", "Right"))),
        label_side = list(type = "select", args = list(label = "Label Side", choices = c("Bottom", "Top"))),
        label_size = list(type = "numeric", args = list(label = "Label Size", value = 10, min = 1, step = 0.5))
    )

    # Partial elements (omitting label_side and label_size) should have missing fields
    # completed from row_spec in the initial payload
    elements <- list(
        row1 = list(column = "pathway", side = "Left")
    )

    widget <- multiDynamicInput("row_ann", label = "Row Annotations", row_spec = spec, elements = elements)
    expect_true(inherits(widget, "shiny.tag"))

    deps <- htmltools::findDependencies(widget)
    dep_names <- vapply(deps, `[[`, "", "name")
    expect_true("multi-dynamic-input" %in% dep_names)

    initial_json <- widget$attribs[["data-initial"]]
    initial <- jsonlite::fromJSON(initial_json, simplifyVector = FALSE)
    expect_length(initial, 1)

    fields <- initial[[1]]$fields
    field_keys <- vapply(fields, `[[`, "", "key")
    expect_equal(field_keys, c("column", "side", "label_side", "label_size"))

    # Verify defaulted values
    field_vals <- stats::setNames(lapply(fields, `[[`, "value"), field_keys)
    expect_equal(field_vals$column, "pathway")
    expect_equal(field_vals$side, "Left")
    expect_equal(field_vals$label_side, "Bottom")
    expect_equal(field_vals$label_size, 10)
})

test_that(".mdi_value_to_payload completes missing fields from row_spec", {
    spec <- list(
        model_type = list(type = "select", args = list(choices = c("lm", "glm"), selected = "lm")),
        formula = list(type = "text", args = list(value = "y ~ x")),
        width = list(type = "numeric", args = list(value = 2))
    )

    elements <- list(
        list(model_type = "glm")
    )

    payload <- .mdi_value_to_payload(elements, names(spec), spec)
    expect_length(payload, 1)

    fields <- payload[[1]]$fields
    field_map <- stats::setNames(lapply(fields, `[[`, "value"), vapply(fields, `[[`, "", "key"))
    expect_equal(field_map$model_type, "glm")
    expect_equal(field_map$formula, "y ~ x")
    expect_equal(field_map$width, 2)
})

test_that(".register_multi_dynamic_input_handler parses initial and client payload accurately", {
    handler <- shiny:::inputHandlers$get("VizModules.multiDynamicInput")
    expect_true(is.function(handler))

    payload <- list(
        `_prefix` = "row annotations",
        rows = list(
            list(fields = list(
                list(key = "column", value = "pathway"),
                list(key = "side", value = "Left"),
                list(key = "label_side", value = "Bottom"),
                list(key = "label_size", value = 10)
            ))
        )
    )

    res <- handler(payload)
    expect_true(is.list(res))
    expect_named(res, "row annotations1")
    expect_equal(res[["row annotations1"]]$column, "pathway")
    expect_equal(res[["row annotations1"]]$side, "Left")
    expect_equal(res[["row annotations1"]]$label_side, "Bottom")
    expect_equal(res[["row annotations1"]]$label_size, 10)

    # Empty payload returns empty named list
    empty_res <- handler(list(`_prefix` = "row", rows = list()))
    expect_equal(empty_res, stats::setNames(list(), character(0)))
})

test_that("a multi-select field reports its items in the order picked, and can be pre-filled so", {
    handler <- shiny:::inputHandlers$get("VizModules.multiDynamicInput")
    # The client sends a multi-select's items as an array, which arrives as a list.
    payload <- list(
        `_prefix` = "trajectories",
        rows = list(
            list(fields = list(list(key = "groups", value = list("C", "A", "B")))),
            list(fields = list(list(key = "groups", value = list())))
        )
    )
    res <- handler(payload)
    expect_identical(res$trajectories1$groups, c("C", "A", "B"))
    expect_identical(res$trajectories2$groups, character(0))

    spec <- list(groups = list(type = "select", args = list(choices = c("A", "B", "C"), multiple = TRUE)))
    widget <- multiDynamicInput("traj", "Trajectories", row_spec = spec,
        elements = list(t1 = list(groups = c("C", "A"))))
    html <- as.character(widget)
    expect_match(html, "<select[^>]*multiple", perl = TRUE)
    initial <- regmatches(html, regexpr('data-initial="[^"]*"', html))
    initial <- jsonlite::fromJSON(gsub("&quot;", "\"", sub('^data-initial="(.*)"$', "\\1", initial)),
        simplifyVector = FALSE)
    expect_equal(unlist(initial[[1]]$fields[[1]]$value), c("C", "A"))
})

test_that("updateMultiDynamicInput sends named rows as a JSON array", {
    captured <- NULL
    session <- list(sendInputMessage = function(inputId, message) captured <<- message)

    # Row names, as the scatter module's Trajectories reset and a heatmap
    # annotation default carry, would otherwise serialise to a JSON object,
    # which the client cannot iterate.
    updateMultiDynamicInput(session, "traj", elements = .trajectory_rows(list(c("A", "B"), c("B", "C"))))
    expect_null(names(captured$value))
    json <- jsonlite::toJSON(captured, auto_unbox = TRUE)
    expect_match(json, '^\\{"value":\\[', perl = TRUE)
    expect_equal(unlist(captured$value[[2]]$fields[[1]]$value), c("B", "C"))

    updateMultiDynamicInput(session, "traj", clear = TRUE)
    expect_identical(captured, list(clear = TRUE))
})
