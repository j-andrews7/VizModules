# The choice values a viz_select_input() was built with, read out of the JSON
# config it renders. `html` is a rendered InputsUI (as.character()), `id` the
# namespaced input id, e.g. "line-group.by".
.select_choices <- function(html, id) {
    html <- paste(html, collapse = "")
    config <- regmatches(html, regexpr(paste0('data-for="', id, '">.*?</script>'), html, perl = TRUE))
    if (length(config) == 0) {
        stop("No viz_select_input config for '", id, "'.", call. = FALSE)
    }
    json <- sub("</script>$", "", sub('^data-for="[^"]+">', "", config))
    jsonlite::fromJSON(json)$options$choices$value
}

# A data frame with an ID column (60 levels, too many to group by), two
# few-level categoricals, a logical and two numerics.
.wide_id_df <- function() {
    data.frame(
        val = seq_len(60),
        val2 = rev(seq_len(60)) / 2,
        id = paste0("gene", seq_len(60)),
        grp = rep(c("a", "b", "c"), 20),
        grp2 = rep(c("x", "y"), 30),
        flag = rep(c(TRUE, FALSE), 30),
        stringsAsFactors = FALSE
    )
}
