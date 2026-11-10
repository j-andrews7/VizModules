# CRAN caps a package's whole check at 10 minutes, and most of these tests draw
# real plots, which costs a fixed ~0.3 s or more per figure however small the
# data. So on CRAN a test that loops over many variants of one feature (each
# adjustment, plot type, or way of storing a column) runs only the `keep` ones,
# chosen as those that exercise what the test guards; CI (which sets
# NOT_CRAN=true) and devtools::test() run every variant.

# The test as skip_on_cran() sees it.
.on_cran <- function() {
    !interactive() && !isTRUE(as.logical(Sys.getenv("NOT_CRAN", "false")))
}

# `cases` on CI and locally; only `cases[keep]` on CRAN.
.cran_cases <- function(cases, keep = 1) {
    if (.on_cran()) cases[keep] else cases
}
