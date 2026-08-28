# Tests for the virtualised select helpers used by every module input.

# Pull the JSON config that virtualSelectInput() embeds alongside the widget.
config_of <- function(tag) {
    html <- as.character(tag)
    jsonlite::fromJSON(sub(".*<script[^>]*>(\\{.*\\})</script>.*", "\\1", html))
}

test_that("viz_select_input builds a virtual-select widget", {
    ui <- as.character(viz_select_input("v", "Label", choices = c("a", "b", "c")))

    expect_true(grepl('class="virtual-select"', ui, fixed = TRUE))
    expect_true(grepl('id="v"', ui, fixed = TRUE))
})

test_that("viz_select_input labels the empty 'no selection' choice", {
    cfg <- config_of(viz_select_input("v", "Label", choices = c("", "a")))

    expect_equal(cfg$options$choices$value, c("", "a"))
    expect_equal(cfg$options$choices$label, c("(none)", "a"))
})

test_that("viz_select_input mirrors selectInput's first-choice default", {
    single <- config_of(viz_select_input("v", "L", choices = c("a", "b")))
    multi <- config_of(viz_select_input("v", "L", choices = c("a", "b"), multiple = TRUE))

    expect_equal(single$config$selectedValue, "a")
    expect_null(multi$config$selectedValue)
})

test_that("viz_select_input turns search on only once the list is long", {
    short <- config_of(viz_select_input("v", "L", choices = letters[1:5]))
    long <- config_of(viz_select_input("v", "L", choices = letters))
    forced <- config_of(viz_select_input("v", "L", choices = letters[1:5], search = TRUE))

    expect_false(short$config$search)
    expect_true(long$config$search)
    expect_true(forced$config$search)
})

test_that("viz_select_input keeps the input snapshot free of menu state", {
    # stateInput = TRUE would add an `input$v_open` that modules would then
    # record in their source download.
    expect_false(config_of(viz_select_input("v", "L", choices = letters[1:3]))$stateInput)
})

test_that("viz_select_input passes extra virtual-select properties through", {
    cfg <- config_of(viz_select_input("v", "L", choices = letters[1:3], optionsCount = 25))

    expect_equal(cfg$config$optionsCount, 25)
    # The dropdown renders on <body> so the input grid cannot clip it.
    expect_equal(cfg$config$dropboxWrapper, "body")
})

test_that("viz_select_input handles a very large choice set", {
    cfg <- config_of(viz_select_input("v", "Y Data", choices = paste0("GENE", seq_len(50000))))

    expect_length(cfg$options$choices$value, 50000)
    expect_true(cfg$config$search)
})

test_that("named and nested choices survive relabelling", {
    named <- .label_empty_choice(c("Violin" = "vlnplot", "Box" = "boxplot"))
    expect_equal(unname(named), c("vlnplot", "boxplot"))
    expect_equal(names(named), c("Violin", "Box"))

    grouped <- list(Sequential = c("viridis", "magma"))
    expect_identical(.label_empty_choice(grouped), grouped)
})

test_that("a repeated choice is only rendered once", {
    # Several UIs prepend "" to a choice vector that already starts with one.
    cfg <- config_of(viz_select_input("v", "L", choices = c("", "", "a")))

    expect_equal(cfg$options$choices$value, c("", "a"))
    expect_equal(cfg$options$choices$label, c("(none)", "a"))
    expect_equal(.label_empty_choice(c("a", "b", "a")), c(a = "a", b = "b"))
})

test_that("update_viz_select sends an update without error", {
    mod <- function(id) {
        moduleServer(id, function(input, output, session) {
            observeEvent(input$go, {
                update_viz_select(session, "v", choices = c("", "a"), selected = "a")
            })
        })
    }

    expect_no_error(testServer(mod, session$setInputs(go = 1)))
})

# virtual-select's setOptions() blanks the widget value, so new choices must
# always ship a value alongside them.
update_message <- function(current, ...) {
    captured <- NULL
    session <- list(
        input = if (is.null(current)) list() else list(v = current),
        sendInputMessage = function(inputId, message) captured <<- message
    )

    update_viz_select(session, "v", ...)
    captured
}

test_that("update_viz_select keeps the current value when it is still a choice", {
    expect_equal(update_message("b", choices = c("a", "b", "c"))$value, "b")
    expect_equal(update_message("", choices = c("", "a"))$value, "")
})

test_that("update_viz_select falls back to the first choice when the value is gone", {
    expect_equal(update_message("b", choices = c("x", "y"))$value, "x")
    # No value has ever been reported by the client.
    expect_equal(update_message(NULL, choices = c("x", "y"))$value, "x")
})

test_that("update_viz_select leaves the value alone when choices are unchanged", {
    expect_null(update_message("b")$value)
    expect_equal(update_message("b", selected = "c")$value, "c")
})

test_that("update_viz_select respects an explicit selection over the current value", {
    expect_equal(update_message("b", choices = c("a", "b"), selected = "a")$value, "a")
})

test_that("dataFilter caps the options rendered by factor filter dropdowns", {
    d <- data.frame(g = factor(paste0("lvl", 1:200)), v = seq_len(200))
    widget <- DT::datatable(
        d,
        filter = list(position = "top", settings = list(select = list(maxOptions = 50))),
        selection = "none", rownames = FALSE
    )

    expect_equal(widget$x$filterSettings$select$maxOptions, 50)
})
