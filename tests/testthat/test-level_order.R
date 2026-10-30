test_that("level_order_choices lists the present levels in drawing order", {
    df <- data.frame(
        f = factor(c("b", "a", "b"), levels = c("c", "b", "a")),
        ch = c("y", "x", "z"),
        num = 1:3,
        stringsAsFactors = FALSE
    )
    # Factor level order, with unused levels dropped; sorted values otherwise.
    expect_equal(level_order_choices(df, "f"), c("b", "a"))
    expect_equal(level_order_choices(df, "ch"), c("x", "y", "z"))

    # The order given goes first; unknown levels are ignored, the rest follow.
    expect_equal(level_order_choices(df, "ch", c("z", "nope")), c("z", "x", "y"))
    expect_equal(level_order_choices(df, "ch", list("y", "x")), c("y", "x", "z"))

    expect_null(level_order_choices(df, "num"))
    expect_null(level_order_choices(df, "missing"))
    expect_null(level_order_choices(df, ""))
    expect_null(level_order_choices(NULL, "f"))
    expect_null(level_order_choices(df, "ch", max.levels = 2))
    expect_null(level_order_choices(data.frame(e = character(0)), "e"))
})

test_that("apply_level_order re-levels the column and leaves the default order alone", {
    df <- example_iris
    out <- apply_level_order(df, "Species", c("virginica", "setosa"))
    expect_equal(levels(out$Species), c("virginica", "setosa", "versicolor"))
    expect_equal(as.character(out$Species), as.character(df$Species))

    ch <- data.frame(g = c("b", "a", "c"), v = 1:3, stringsAsFactors = FALSE)
    expect_equal(levels(apply_level_order(ch, "g", "c")$g), c("c", "a", "b"))

    expect_identical(apply_level_order(df, "Species", NULL), df)
    expect_identical(apply_level_order(df, "Species", character(0)), df)
    expect_identical(apply_level_order(df, "Species", levels(df$Species)), df)
    expect_identical(apply_level_order(df, "Species", "not a level"), df)
    expect_identical(apply_level_order(df, "Sepal.Length", c("1", "2")), df)
    expect_identical(apply_level_order(df, "missing", "a"), df)
    expect_identical(apply_level_order(ch, "g", c("a", "b", "c")), ch)
})

test_that("level_order_input renders its items in one grid cell", {
    el <- level_order_input("box-x.order", "X Order", items = c("Disease", "Healthy"))
    html <- as.character(el)
    expect_match(html, "vizmodules-level-order", fixed = TRUE)
    expect_match(html, "jqui-orderInput", fixed = TRUE)
    expect_match(html, 'data-value="Disease".*data-value="Healthy"')

    # A single tag, so organize_inputs() keeps it in a single cell.
    expect_s3_class(el, "shiny.tag")
    expect_s3_class(level_order_input("x", "X", items = NULL), "shiny.tag")
    expect_match(as.character(level_order_input("x", "X", tooltip = "Drag me")), "Drag me", fixed = TRUE)
})

# A minimal module around setup_level_order(), recording what it sends the control.
.order_module <- function(id, data, column, defaults = NULL) {
    moduleServer(id, function(input, output, session) {
        col <- if (is.function(column)) column else reactive(input[[column]])
        store <- setup_level_order(input, session, data, col, defaults)
        list(store = store)
    })
}

test_that("setup_level_order holds the order dragged and survives a stale report", {
    sent <- new.env()
    sent$items <- list()
    local_mocked_bindings(updateOrderInput = function(session, inputId, items, ...) {
        sent$items[[length(sent$items) + 1]] <- items
        invisible(NULL)
    })
    last_sent <- function() sent$items[[length(sent$items)]]

    df <- reactiveVal(data.frame(
        g = c("a", "b", "c", "a"), h = c("x", "y", "x", "y"), n = 1:4, stringsAsFactors = FALSE
    ))

    shiny::testServer(
        .order_module,
        args = list(id = "m", data = df, column = "col", defaults = list(x.order = c("c", "b"))),
        {
            session$setInputs(col = "g")
            # A new column starts from the defaults, sent to the control.
            expect_equal(store(), c("c", "b", "a"))
            expect_equal(last_sent(), c("c", "b", "a"))
            n <- length(sent$items)

            # A report from before the update arrived (a different set) is put right.
            session$setInputs(x.order = c("q", "r"))
            expect_equal(length(sent$items), n + 1)
            expect_equal(last_sent(), c("c", "b", "a"))
            expect_equal(store(), c("c", "b", "a"))

            # The echo is taken without another update.
            session$setInputs(x.order = c("c", "b", "a"))
            expect_equal(length(sent$items), n + 1)

            # A drag sets the order, back to the default drops it.
            session$setInputs(x.order = c("b", "a", "c"))
            expect_equal(store(), c("b", "a", "c"))
            expect_equal(length(sent$items), n + 1)
            session$setInputs(x.order = c("a", "b", "c"))
            expect_null(store())
            session$setInputs(x.order = c("c", "a", "b"))

            # New data for the same column keeps the order for what is left.
            df(subset(df(), g != "a"))
            session$flushReact()
            expect_equal(store(), c("c", "b"))
            expect_equal(last_sent(), c("c", "b"))
            session$setInputs(x.order = c("c", "b"))

            # Reset goes back to the defaults.
            session$setInputs(x.order = c("b", "c"))
            expect_null(store())
            session$setInputs(reset = 1)
            expect_equal(store(), c("c", "b"))

            # A numeric column empties (and so hides) the control.
            session$setInputs(col = "n")
            expect_null(store())
            expect_equal(last_sent(), character(0))

            # A new column ignores default levels it does not have.
            session$setInputs(col = "h")
            expect_null(store())
            expect_equal(last_sent(), c("x", "y"))
        }
    )
})

test_that("setup_level_order follows a reactive default", {
    local_mocked_bindings(updateOrderInput = function(...) invisible(NULL))
    default_order <- reactiveVal(NULL)
    shiny::testServer(
        .order_module,
        args = list(
            id = "m", data = reactive(example_iris), column = reactive("Species"),
            defaults = list(x.order = reactive(default_order()))
        ),
        {
            session$flushReact()
            expect_null(store())
            default_order("virginica")
            session$flushReact()
            expect_equal(store(), c("virginica", "setosa", "versicolor"))
        }
    )
})
