#' Package on-load hook
#'
#' Registers built-in model backends when the package is loaded.
#'
#' @param libname Library path.
#' @param pkgname Package name.
#'
#' @keywords internal
.onLoad <- function(libname, pkgname) {
    .register_builtin_backends()
}

.pkg_versions <- new.env(parent = emptyenv())

#' Installed version of a package, as a string, looked up once per session
#'
#' [utils::packageVersion()] reads the package's metadata from disk on every
#' call. The HTML dependencies attached to each select input and each rendered
#' figure all ask for a version, so building a module's UI or redrawing its plot
#' would otherwise read the same file dozens of times.
#'
#' @param pkg Package name.
#' @return The version as a character string.
#' @keywords internal
#' @rdname INTERNAL_pkg_version
.pkg_version <- function(pkg = "VizModules") {
    version <- .pkg_versions[[pkg]]
    if (is.null(version)) {
        version <- as.character(utils::packageVersion(pkg))
        .pkg_versions[[pkg]] <- version
    }
    version
}
