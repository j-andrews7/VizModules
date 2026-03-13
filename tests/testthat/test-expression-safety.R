# --------------------------------------------------------------------------
# Tests for safe_eval_filter(), safe_resolve_adj_fxn(), validate_expression()
# --------------------------------------------------------------------------

test_df <- data.frame(
    x = c(1, 2, 3, 4, 5),
    y = c(10, 20, 30, 40, 50),
    group = c("A", "A", "B", "B", "C"),
    stringsAsFactors = FALSE
)

# ---- safe_eval_filter ----

test_that("safe_eval_filter: simple comparison returns correct logical vector", {
    result <- safe_eval_filter("x > 3", test_df)
    expect_equal(result, c(FALSE, FALSE, FALSE, TRUE, TRUE))
})

test_that("safe_eval_filter: compound expression works", {
    result <- safe_eval_filter("x > 1 & group == 'B'", test_df)
    expect_equal(result, c(FALSE, FALSE, TRUE, TRUE, FALSE))
})

test_that("safe_eval_filter: %in% operator works", {
    result <- safe_eval_filter("group %in% c('A', 'C')", test_df)
    expect_equal(result, c(TRUE, TRUE, FALSE, FALSE, TRUE))
})

test_that("safe_eval_filter: arithmetic in expression works", {
    result <- safe_eval_filter("x + y > 30", test_df)
    expect_equal(result, c(FALSE, FALSE, TRUE, TRUE, TRUE))
})

test_that("safe_eval_filter: negation operator works", {
    result <- safe_eval_filter("!group == 'A'", test_df)
    expect_equal(result, c(FALSE, FALSE, TRUE, TRUE, TRUE))
})

test_that("safe_eval_filter: is.na works", {
    df_na <- data.frame(x = c(1, NA, 3))
    result <- safe_eval_filter("is.na(x)", df_na)
    expect_equal(result, c(FALSE, TRUE, FALSE))
})

test_that("safe_eval_filter: NULL input returns NULL", {
    expect_null(safe_eval_filter(NULL, test_df))
})

test_that("safe_eval_filter: empty string returns NULL", {
    expect_null(safe_eval_filter("", test_df))
})

test_that("safe_eval_filter: whitespace-only returns NULL", {
    expect_null(safe_eval_filter("   ", test_df))
})

test_that("safe_eval_filter: unparseable expression returns NULL with warning", {
    expect_warning(
        result <- safe_eval_filter("x >>>> 3", test_df),
        "Could not parse"
    )
    expect_null(result)
})

test_that("safe_eval_filter: system() call is blocked", {
    expect_warning(
        result <- safe_eval_filter("system('echo pwned')", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: file.remove() call is blocked", {
    expect_warning(
        result <- safe_eval_filter("file.remove('important.txt')", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: library() call is blocked", {
    expect_warning(
        result <- safe_eval_filter("library(malicious)", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: eval/parse nested attack is blocked", {
    expect_warning(
        result <- safe_eval_filter("eval(parse(text = 'system(\"whoami\")'))", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: assignment is blocked", {
    expect_warning(
        result <- safe_eval_filter("x <- 999", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: unknown symbol is blocked", {
    expect_warning(
        result <- safe_eval_filter("nonexistent_col > 3", test_df),
        "disallowed"
    )
    expect_null(result)
})

test_that("safe_eval_filter: runtime error returns NULL with warning", {
    # Reference a column that passes AST validation but causes a runtime error
    df_err <- data.frame(a = c("x", "y", "z"))
    expect_warning(
        result <- safe_eval_filter("a + 1 > 2", df_err),
        "Filter expression error"
    )
    expect_null(result)
})

test_that("safe_eval_filter: TRUE/FALSE literals allowed", {
    result <- safe_eval_filter("TRUE", test_df)
    expect_true(result)
})

test_that("safe_eval_filter: numeric literal comparison", {
    result <- safe_eval_filter("x == 3", test_df)
    expect_equal(result, c(FALSE, FALSE, TRUE, FALSE, FALSE))
})

# ---- safe_resolve_adj_fxn ----

test_that("safe_resolve_adj_fxn: resolves log2", {
    fn <- safe_resolve_adj_fxn("log2")
    expect_identical(fn, log2)
})

test_that("safe_resolve_adj_fxn: resolves log", {
    fn <- safe_resolve_adj_fxn("log")
    expect_identical(fn, log)
})

test_that("safe_resolve_adj_fxn: resolves log10", {
    fn <- safe_resolve_adj_fxn("log10")
    expect_identical(fn, log10)
})

test_that("safe_resolve_adj_fxn: resolves abs", {
    fn <- safe_resolve_adj_fxn("abs")
    expect_identical(fn, abs)
})

test_that("safe_resolve_adj_fxn: resolves sqrt", {
    fn <- safe_resolve_adj_fxn("sqrt")
    expect_identical(fn, sqrt)
})

test_that("safe_resolve_adj_fxn: resolves log1p", {
    fn <- safe_resolve_adj_fxn("log1p")
    expect_identical(fn, log1p)
})

test_that("safe_resolve_adj_fxn: resolves as.factor", {
    fn <- safe_resolve_adj_fxn("as.factor")
    expect_identical(fn, as.factor)
})

test_that("safe_resolve_adj_fxn: resolves neg_log10", {
    fn <- safe_resolve_adj_fxn("neg_log10")
    expect_equal(fn(100), -2)
})

test_that("safe_resolve_adj_fxn: NULL input returns NULL", {
    expect_null(safe_resolve_adj_fxn(NULL))
})

test_that("safe_resolve_adj_fxn: empty string returns NULL", {
    expect_null(safe_resolve_adj_fxn(""))
})

test_that("safe_resolve_adj_fxn: whitespace-only returns NULL", {
    expect_null(safe_resolve_adj_fxn("   "))
})

test_that("safe_resolve_adj_fxn: system is blocked", {
    expect_warning(
        result <- safe_resolve_adj_fxn("system"),
        "Unrecognized"
    )
    expect_null(result)
})

test_that("safe_resolve_adj_fxn: eval is blocked", {
    expect_warning(
        result <- safe_resolve_adj_fxn("eval"),
        "Unrecognized"
    )
    expect_null(result)
})

test_that("safe_resolve_adj_fxn: arbitrary string is blocked", {
    expect_warning(
        result <- safe_resolve_adj_fxn("readLines"),
        "Unrecognized"
    )
    expect_null(result)
})

# ---- validate_expression ----

test_that("validate_expression: valid comparison returns original string", {
    expr <- "x > 5"
    result <- validate_expression(expr, c("x", "y"))
    expect_identical(result, expr)
})

test_that("validate_expression: compound expression returns original string", {
    expr <- "x > 1 & group == 'B'"
    result <- validate_expression(expr, c("x", "group"))
    expect_identical(result, expr)
})

test_that("validate_expression: %in% expression returns original string", {
    expr <- "group %in% c('A', 'C')"
    result <- validate_expression(expr, c("group"))
    expect_identical(result, expr)
})

test_that("validate_expression: arithmetic expression returns original string", {
    expr <- "x + y > 30"
    result <- validate_expression(expr, c("x", "y"))
    expect_identical(result, expr)
})

test_that("validate_expression: is.na allowed", {
    expr <- "is.na(x)"
    result <- validate_expression(expr, c("x"))
    expect_identical(result, expr)
})

test_that("validate_expression: NULL input returns NULL", {
    expect_null(validate_expression(NULL, c("x")))
})

test_that("validate_expression: empty string returns NULL", {
    expect_null(validate_expression("", c("x")))
})

test_that("validate_expression: whitespace-only returns NULL", {
    expect_null(validate_expression("   ", c("x")))
})

test_that("validate_expression: unparseable expression returns NULL with warning", {
    expect_warning(
        result <- validate_expression("x >>>> 3", c("x")),
        "Could not parse"
    )
    expect_null(result)
})

test_that("validate_expression: system() call is blocked", {
    expect_warning(
        result <- validate_expression("system('echo pwned')", c("x")),
        "disallowed"
    )
    expect_null(result)
})

test_that("validate_expression: file.remove() call is blocked", {
    expect_warning(
        result <- validate_expression("file.remove('foo')", c("x")),
        "disallowed"
    )
    expect_null(result)
})

test_that("validate_expression: eval/parse attack is blocked", {
    expect_warning(
        result <- validate_expression("eval(parse(text='rm()'))", c("x")),
        "disallowed"
    )
    expect_null(result)
})

test_that("validate_expression: assignment is blocked", {
    expect_warning(
        result <- validate_expression("x <- 999", c("x")),
        "disallowed"
    )
    expect_null(result)
})

test_that("validate_expression: unknown symbol is blocked", {
    expect_warning(
        result <- validate_expression("mystery_var > 3", c("x", "y")),
        "disallowed"
    )
    expect_null(result)
})

test_that("validate_expression: TRUE/FALSE literals allowed", {
    result <- validate_expression("x == TRUE", c("x"))
    expect_identical(result, "x == TRUE")
})

test_that("validate_expression: does not evaluate the expression", {
    # If this were evaluated, it would error; validate_expression should just return it
    result <- validate_expression("x / 0 > 1", c("x"))
    expect_identical(result, "x / 0 > 1")
})
