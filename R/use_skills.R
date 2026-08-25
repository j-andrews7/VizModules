#' Install the bundled VizModules agent skills into a project
#'
#' Copies the skills that ship with VizModules into a project's `.claude/skills/`
#' directory, where Claude Code and other tools following the
#' [Agent Skills](https://agentskills.io) convention will discover them.
#'
#' Three skills are provided:
#'
#' \describe{
#'   \item{`vizmodules-app`}{Wiring plot modules into a Shiny app: `defaults`,
#'     `hide.inputs`/`hide.tabs`, the Stats tab, [createModuleApp()], the data
#'     filter table, the figure builder, and source-data export. Ships a generated
#'     inventory of every module's column-mapping keys, colour key, and tab names.}
#'   \item{`vizmodules-custom-module`}{Building a wrapper module on top of a base
#'     module: the namespace contract, reactive `defaults`, avoiding double
#'     renders, manual-edit persistence, and model-line backends.}
#'   \item{`vizmodules-new-module`}{Authoring a module inside this package: the
#'     file trio, the required roxygen sections, the uniform input helpers, and
#'     file templates to copy.}
#' }
#'
#' @param path Directory of the project to install into. The skills are written to
#'   `file.path(path, ".claude", "skills")`, which is created if needed.
#' @param overwrite Logical; if `FALSE` (the default) a skill whose directory
#'   already exists is skipped rather than replaced.
#' @return Invisibly, a character vector of the skill directories written.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' # Install into a temporary project rather than the current one:
#' use_vizmodules_skills(tempdir())
#'
#' \dontrun{
#' # Install into the current project, refreshing any that already exist:
#' use_vizmodules_skills(".", overwrite = TRUE)
#' }
use_vizmodules_skills <- function(path = ".", overwrite = FALSE) {
    if (!is.character(path) || length(path) != 1L || is.na(path)) {
        stop("'path' must be a single directory path.", call. = FALSE)
    }
    if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
        stop("'overwrite' must be TRUE or FALSE.", call. = FALSE)
    }

    src <- system.file("skills", package = "VizModules")
    if (!nzchar(src) || !dir.exists(src)) {
        stop("The bundled skills could not be found in the installed package.", call. = FALSE)
    }

    skills <- list.dirs(src, full.names = FALSE, recursive = FALSE)
    if (length(skills) == 0L) {
        stop("No skills are bundled with this installation.", call. = FALSE)
    }

    dest_root <- file.path(path, ".claude", "skills")
    dir.create(dest_root, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(dest_root)) {
        stop("Could not create '", dest_root, "'.", call. = FALSE)
    }

    written <- character(0)
    for (skill in skills) {
        target <- file.path(dest_root, skill)
        if (dir.exists(target) && !isTRUE(overwrite)) {
            message("Skipped '", skill, "' (already present; use overwrite = TRUE to replace).")
            next
        }
        if (dir.exists(target)) {
            unlink(target, recursive = TRUE)
        }
        ok <- file.copy(file.path(src, skill), dest_root, recursive = TRUE)
        if (!all(ok)) {
            warning("Could not copy skill '", skill, "'.", call. = FALSE)
            next
        }
        written <- c(written, target)
        message("Installed '", skill, "'.")
    }

    if (length(written) > 0L) {
        message(
            "\n", length(written), " skill(s) written to '", dest_root, "'.\n",
            "Restart your agent session if it was already running, so the new ",
            "directory is picked up."
        )
    }

    invisible(written)
}
