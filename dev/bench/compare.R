# Compare two benchmark runs from dev/bench/bench.R.
# Usage: Rscript dev/bench/compare.R <before.csv> <after.csv>
args <- commandArgs(trailingOnly = TRUE)
b <- utils::read.csv(args[[1]])
a <- utils::read.csv(args[[2]])
m <- merge(b, a, by = c("module", "rows", "change"), suffixes = c(".before", ".after"))
m <- m[order(m$rows, m$module, m$change), ]
arrow <- function(x, y) paste(round(x), "->", round(y))
out <- with(m, data.frame(
    module, rows, change,
    startup_builds = arrow(startup_builds.before, startup_builds.after),
    builds = arrow(builds.before, builds.after),
    total_ms = arrow(total_ms.before, total_ms.after),
    payload_kb = arrow(payload_kb.before, payload_kb.after),
    ui_ms = arrow(ui_ms.before, ui_ms.after)
))
print(out, row.names = FALSE)
