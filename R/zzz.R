#' Sets up the package when it's loaded
#'
#' Adds the content of www to shinyTime/, and registers an inputHandler to massage the output from
#' JavaScript into an R structure.
#'
#' @importFrom shiny addResourcePath registerInputHandler
#'
#' @noRd
#'
.onLoad <- function(libname, pkgname) {
  # Add directory for static resources
  addResourcePath(
    prefix = 'wwwvfinputs',
    directoryPath = system.file('www', package = 'vfinputs')
  )
  registerInputHandler("vfinputs.continuousLegendFilter", function(data, ...) {
    if (is.null(data))
      NULL
    else
      list(start=data[1],end=data[2])
  }, force = TRUE)

  registerInputHandler("vfinputs.discreteLegendFilter", function(data, ...) {
    if (is.null(data))
      NULL
    else
      list(start=data[1],end=data[2])
  }, force = TRUE)

  registerInputHandler("vfinputs.categoricalColorFilter", function(data, ...) {
    if (is.null(data))
      NULL
    else
      data
  }, force = TRUE)

}

#' Cleans up when package is unloaded
#'
#' Reverses the effects from .onLoad
#'
#' @importFrom shiny removeInputHandler
#'
#' @noRd
#'
.onUnload <- function(libpath) {
  removeInputHandler('vfinputs.continuousLegendFilter')
  removeInputHandler('vfinputs.discreteLegendFilter')
  removeInputHandler('vfinputs.categoricalColorFilter')
}
