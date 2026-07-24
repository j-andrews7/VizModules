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
