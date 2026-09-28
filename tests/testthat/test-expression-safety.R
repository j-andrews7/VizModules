test_df <- data.frame(
    x = c(1, 2, 3, 4, 5),
    y = c(10, 20, 30, 40, 50),
    group = c("A", "A", "B", "B", "C"),
    stringsAsFactors = FALSE
)

str_df <- data.frame(
    gene = c("RPL3", "TP53", "RPS6", "MYC"),
    val = c(1, 9, 3, 7),
    stringsAsFactors = FALSE
)

# ---- What the two public expression functions accept ----

test_that("safe_eval_filter evaluates allowed expressions to the right mask", {
    cases <- list(
        "x > 3" = c(FALSE, FALSE, FALSE, TRUE, TRUE),
        "x > 1 & group == 'B'" = c(FALSE, FALSE, TRUE, TRUE, FALSE),
        "group %in% c('A', 'C')" = c(TRUE, TRUE, FALSE, FALSE, TRUE),
        "x + y > 30" = c(FALSE, FALSE, TRUE, TRUE, TRUE),
        "!group == 'A'" = c(FALSE, FALSE, TRUE, TRUE, TRUE),
        "x == 3" = c(FALSE, FALSE, TRUE, FALSE, FALSE),
        "TRUE" = TRUE
    )
    for (expr in names(cases)) {
        expect_equal(safe_eval_filter(expr, test_df), cases[[expr]], info = expr)
    }
    expect_equal(safe_eval_filter("is.na(x)", data.frame(x = c(1, NA, 3))), c(FALSE, TRUE, FALSE))
})

test_that("the widened string, numeric and logical vocabulary evaluates", {
    cases <- list(
        'grepl("^RP", gene)' = c(TRUE, FALSE, TRUE, FALSE),
        'startsWith(gene, "RP")' = c(TRUE, FALSE, TRUE, FALSE),
        'endsWith(gene, "3")' = c(TRUE, TRUE, FALSE, FALSE),
        'substr(gene, 1, 2) == "RP"' = c(TRUE, FALSE, TRUE, FALSE),
        "nchar(gene) > 3" = c(TRUE, TRUE, TRUE, FALSE),
        'toupper(gene) == "MYC"' = c(FALSE, FALSE, FALSE, TRUE),
        'tolower(gene) == "myc"' = c(FALSE, FALSE, FALSE, TRUE),
        'trimws(gene) == "MYC"' = c(FALSE, FALSE, FALSE, TRUE),
        "abs(val - 5) > 3" = c(TRUE, TRUE, FALSE, FALSE),
        "round(val) == 9" = c(FALSE, TRUE, FALSE, FALSE),
        'xor(val > 5, gene == "RPL3")' = c(TRUE, TRUE, FALSE, TRUE)
    )
    for (expr in names(cases)) {
        expect_equal(safe_eval_filter(expr, str_df), cases[[expr]], info = expr)
    }
})

test_that("validate_expression returns allowed expressions unchanged", {
    cols <- c("x", "y", "group", "gene")
    for (expr in c(
        "x > 5", "x > 1 & group == 'B'", "group %in% c('A', 'C')", "x + y > 30",
        "is.na(x)", "x == TRUE", 'grepl("^RP", gene)', 'startsWith(gene, "RP")'
    )) {
        expect_identical(validate_expression(expr, cols), expr, info = expr)
    }
})

test_that("validate_expression: does not evaluate the expression", {
    # If this were evaluated, it would error; validate_expression should just return it
    result <- validate_expression("x / 0 > 1", c("x"))
    expect_identical(result, "x / 0 > 1")
})

test_that("blank input is NULL for every expression function", {
    for (blank in list(NULL, "", "   ")) {
        expect_null(safe_eval_filter(blank, test_df))
        expect_null(validate_expression(blank, c("x")))
        expect_null(safe_resolve_adj_fxn(blank))
    }
})

test_that("an unparseable expression returns NULL with a warning", {
    expect_warning(expect_null(safe_eval_filter("x >>>> 3", test_df)), "Could not parse")
    expect_warning(expect_null(validate_expression("x >>>> 3", c("x"))), "Could not parse")
})

# ---- What they refuse ----

test_that("both public functions block code execution and unknown names", {
    # These are the cases the allowlist exists for. Adding pure string helpers
    # must not have opened a route to any of them.
    hostile_df <- data.frame(x = 1:4, y = 4:1, group = c("A", "A", "B", "C"), gene = str_df$gene)
    hostile <- c(
        "system('echo pwned')",
        'system("id")',
        "file.remove('important.txt')",
        'file.remove("a")',
        "library(malicious)",
        "eval(parse(text = 'rm()'))",
        'eval(parse(text = "1"))',
        "x <- 999",
        "nonexistent_col > 3",
        'base::system("id")',
        "utils::head(gene)",
        'get("system")("id")',
        'assign("x", 1)',
        'Sys.getenv("PATH")',
        "lapply(gene, print)",
        'do.call("system", list("id"))',
        "(function() 1)()",
        'quote(system("id"))'
    )

    for (expr in hostile) {
        expect_warning(res <- safe_eval_filter(expr, hostile_df), regexp = "disallowed|parse", info = expr)
        expect_null(res, info = expr)
        expect_warning(res <- validate_expression(expr, names(hostile_df)), regexp = "disallowed|parse", info = expr)
        expect_null(res, info = expr)
    }
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

# ---- safe_resolve_adj_fxn ----

test_that("safe_resolve_adj_fxn resolves the unexported neg_log10 for any caller", {
    # A caller whose frame cannot see the package's internals, as user code
    # calling the exported function cannot. The function object is inlined so
    # the call does not depend on finding it by name from there.
    caller <- eval(
        bquote(function() .(safe_resolve_adj_fxn)("neg_log10")),
        envir = new.env(parent = baseenv())
    )
    fn <- caller()
    expect_true(is.function(fn))
    expect_equal(fn(100), -2)
})

test_that("safe_resolve_adj_fxn resolves only its adjustment functions", {
    for (nm in c("log2", "log", "log10", "abs", "sqrt", "log1p", "as.factor")) {
        expect_identical(safe_resolve_adj_fxn(nm), match.fun(nm), info = nm)
    }
    for (nm in c("system", "eval", "readLines")) {
        expect_warning(res <- safe_resolve_adj_fxn(nm), "Unrecognized", info = nm)
        expect_null(res, info = nm)
    }
})


# ---- Sort keys (.sort_allowed_calls, the BoxPlot module's "Sort X By") ----
#
# plotthis::BoxPlot() runs sort_x through rlang::parse_expr() inside
# summarise(), so the text a user types there is code.

test_that("sort keys: summary functions over data columns are accepted", {
    cols <- names(test_df)
    for (expr in c("mean(y)", "-median(y)", "max(y) - min(y)", "sum(x * y) / length(y)", "sd(y)")) {
        expect_identical(.validate_expression_with(expr, cols, .sort_allowed_calls()), expr)
    }
})

test_that("sort keys: code execution is rejected", {
    cols <- names(test_df)
    for (expr in c(
        "system('echo pwned')",
        "length(cat('pwned'))",
        "mean(y); system('echo pwned')",
        "base::mean(y)",
        "mean(get('y'))",
        "mean(unknown_col)"
    )) {
        expect_warning(
            res <- .validate_expression_with(expr, cols, .sort_allowed_calls()),
            info = expr
        )
        expect_null(res, info = expr)
    }
})

test_that("sort keys: the summary vocabulary stays out of row filters", {
    # mean() and friends are fine for a per-group sort key but meaningless in a
    # row filter, so they are added for sort keys only.
    expect_false("mean" %in% .expr_allowed_calls())
    expect_warning(expect_null(validate_expression("y > mean(y)", names(test_df))))
})

test_that("sort keys: the vocabulary is a superset of the shared one", {
    expect_true(all(.expr_allowed_calls() %in% .sort_allowed_calls()))
})


# ---- Shared allowlist / walker (.expr_allowed_calls, .expr_check_node) ----
#
# safe_eval_filter() and validate_expression() used to carry verbatim copies of
# both; they now share one. These cover the shared piece directly, and the
# widened string/pattern vocabulary that made sharing worth doing.

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


# --- Multi-statement input ----------------------------------------------------
# A `;` or a newline in the box used to be answered by working on the first
# statement and ignoring the rest. For safe_eval_filter() that quietly returned
# the wrong mask; for validate_expression(), which hands its *input string* back
# to a caller that evaluates it, everything after the `;` escaped the allowlist.

test_that("validate_expression rejects multi-statement input", {
    expect_warning(
        res <- validate_expression("x > 1; system('id')", c("x")),
        "single statement"
    )
    expect_null(res)

    # The contract that matters: the unchecked text must never come back out.
    expect_false(identical(res, "x > 1; system('id')"))

    # A newline separates statements just as a semicolon does, and a
    # textAreaInput invites exactly that.
    expect_warning(
        expect_null(validate_expression("x > 1\nsystem('id')", c("x"))),
        "single statement"
    )

    # Even when every statement would pass on its own.
    expect_warning(
        expect_null(validate_expression("x > 1; x < 5", c("x"))),
        "single statement"
    )
})

test_that("safe_eval_filter rejects multi-statement input", {
    df <- data.frame(x = 1:3)

    expect_warning(
        res <- safe_eval_filter("x > 1; x < 3", df),
        "single statement"
    )
    # Previously returned FALSE TRUE TRUE -- the first clause alone, with the
    # second silently dropped.
    expect_null(res)

    expect_warning(
        expect_null(safe_eval_filter("x > 1\nx < 3", df)),
        "single statement"
    )
})

test_that("a single statement is unaffected by the multi-statement guard", {
    df <- data.frame(x = 1:3)
    expect_equal(safe_eval_filter("x > 1", df), c(FALSE, TRUE, TRUE))
    expect_equal(validate_expression("x > 1", c("x")), "x > 1")

    # A trailing semicolon parses to one expression, so it still works.
    expect_equal(safe_eval_filter("x > 1;", df), c(FALSE, TRUE, TRUE))
})


# --- The shared walker --------------------------------------------------------

test_that(".expr_check_node takes the allowlist as an argument", {
    expr <- quote(y ~ log(x))

    # The filter vocabulary has no `~`, so the default rejects a formula...
    expect_false(.expr_check_node(expr, c("x", "y")))
    # ...and the formula vocabulary accepts it.
    expect_true(.expr_check_node(expr, c("x", "y"), .formula_allowed_calls()))

    # The rejection rules do not vary with the vocabulary: a call in function
    # position is refused under both.
    expect_false(
        .expr_check_node(quote(y ~ base::log(x)), c("x", "y"), .formula_allowed_calls())
    )
})

test_that(".formula_allowed_calls is a pure, formula-shaped vocabulary", {
    allowed <- .formula_allowed_calls()
    expect_true(all(c("~", "+", "I", "poly", "log") %in% allowed))
    forbidden <- c(
        "system", "eval", "parse", "get", "assign", "::", "$", "[", "[[",
        "function", "<-", "source", "library", "do.call"
    )
    expect_length(intersect(allowed, forbidden), 0)
})
