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


# ---- Shared allowlist / walker (.expr_allowed_calls, .expr_check_node) ----
#
# safe_eval_filter() and validate_expression() used to carry verbatim copies of
# both; they now share one. These cover the shared piece directly, and the
# widened string/pattern vocabulary that made sharing worth doing.

str_df <- data.frame(
    gene = c("RPL3", "TP53", "RPS6", "MYC"),
    val = c(1, 9, 3, 7),
    stringsAsFactors = FALSE
)

test_that("the string and pattern helpers evaluate", {
    expect_equal(safe_eval_filter('grepl("^RP", gene)', str_df), c(TRUE, FALSE, TRUE, FALSE))
    expect_equal(safe_eval_filter('startsWith(gene, "RP")', str_df), c(TRUE, FALSE, TRUE, FALSE))
    expect_equal(safe_eval_filter('endsWith(gene, "3")', str_df), c(TRUE, TRUE, FALSE, FALSE))
    expect_equal(safe_eval_filter('substr(gene, 1, 2) == "RP"', str_df), c(TRUE, FALSE, TRUE, FALSE))
    expect_equal(safe_eval_filter("nchar(gene) > 3", str_df), c(TRUE, TRUE, TRUE, FALSE))
    expect_equal(safe_eval_filter('toupper(gene) == "MYC"', str_df), c(FALSE, FALSE, FALSE, TRUE))
    expect_equal(safe_eval_filter('tolower(gene) == "myc"', str_df), c(FALSE, FALSE, FALSE, TRUE))
    expect_equal(safe_eval_filter('trimws(gene) == "MYC"', str_df), c(FALSE, FALSE, FALSE, TRUE))
})

test_that("the numeric and logical additions evaluate", {
    expect_equal(safe_eval_filter("abs(val - 5) > 3", str_df), c(TRUE, TRUE, FALSE, FALSE))
    expect_equal(safe_eval_filter("round(val) == 9", str_df), c(FALSE, TRUE, FALSE, FALSE))
    expect_equal(
        safe_eval_filter('xor(val > 5, gene == "RPL3")', str_df),
        c(TRUE, TRUE, FALSE, TRUE)
    )
})

test_that("validate_expression accepts the same widened vocabulary", {
    expect_identical(
        validate_expression('grepl("^RP", gene)', names(str_df)),
        'grepl("^RP", gene)'
    )
    expect_identical(
        validate_expression('startsWith(gene, "RP")', names(str_df)),
        'startsWith(gene, "RP")'
    )
})

test_that("the widened allowlist still blocks code execution", {
    # These are the cases the allowlist exists for. Adding pure string helpers
    # must not have opened a route to any of them.
    hostile <- c(
        'system("id")',
        'eval(parse(text = "1"))',
        'base::system("id")',
        "utils::head(gene)",
        'get("system")("id")',
        'assign("x", 1)',
        'Sys.getenv("PATH")',
        'file.remove("a")',
        "lapply(gene, print)",
        'do.call("system", list("id"))',
        "(function() 1)()",
        'quote(system("id"))'
    )

    for (expr in hostile) {
        expect_warning(res <- safe_eval_filter(expr, str_df), regexp = "disallowed|parse")
        expect_null(res, info = expr)
    }
})

test_that("a namespaced or extracted call cannot smuggle in an allowed name", {
    # `node[[1]]` is a call rather than a name for these, so the walker must
    # reject them outright rather than flattening to something that matches.
    expect_warning(res <- safe_eval_filter('base::grepl("^RP", gene)', str_df))
    expect_null(res)

    expect_warning(res2 <- safe_eval_filter("str_df$gene", str_df))
    expect_null(res2)
})

test_that("an unknown symbol is still rejected after widening", {
    expect_warning(res <- safe_eval_filter("not_a_column > 1", str_df))
    expect_null(res)

    # A function name on the allowlist is only usable as a call, never as a value.
    expect_warning(res2 <- safe_eval_filter("grepl > 1", str_df))
    expect_null(res2)
})

test_that(".expr_allowed_calls contains no impure entry", {
    # A tripwire: anything capable of I/O, evaluation, or environment access
    # does not belong here, and this is the list both public functions trust.
    forbidden <- c(
        "system", "system2", "shell", "eval", "evalq", "parse", "str2lang",
        "str2expression", "get", "get0", "mget", "assign", "do.call", "Recall",
        "match.fun", "file", "file.remove", "unlink", "readLines", "writeLines",
        "source", "library", "require", "requireNamespace", "loadNamespace",
        "attach", "sys.call", "sys.function", "environment", "globalenv",
        "new.env", "as.environment", "Sys.getenv", "Sys.setenv", "download.file",
        "url", "connection", "readRDS", "saveRDS", "function", "<-", "<<-", "=",
        "::", ":::", "$", "@", "[", "[[", "lapply", "sapply", "vapply", "Map",
        "Reduce", "Filter", "apply", "outer", "quote", "bquote", "substitute"
    )

    expect_length(intersect(.expr_allowed_calls(), forbidden), 0L)
})

test_that(".expr_check_node is what both public functions actually consult", {
    # Guards against the two drifting apart again: one allowlist, one walker.
    expect_true(.expr_check_node(parse(text = 'grepl("a", gene)')[[1L]], "gene"))
    expect_false(.expr_check_node(parse(text = 'system("id")')[[1L]], "gene"))
    # A symbol is permitted only if it names a column.
    expect_true(.expr_check_node(parse(text = "gene")[[1L]], "gene"))
    expect_false(.expr_check_node(parse(text = "gene")[[1L]], "other"))
})
