#' @title Change a numeric legend filter in the client
#'
#' @details This function only affects the label and JavaScript-implemented axis and brush values and selection.
#'  Re-creating the color strips and changing the ticks and format of values requires deleting and re-creating the legend using `shinyjs`, for example.
#'
#' @param session The `session` object passed to function given to
#'   `shinyServer`.
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param start Beginning of selection interval.
#' @param end End of selection interval.
#' @param minValue Minimum numeric value in the legend (can be higher the maximum for inverted scale).
#' @param maxValue Maximum numeric value in the legend (can be lower the minimum for inverted scale).
#'
#' @seealso [continuousColorFilter()] [discreteColorFilter()]
#'
#' @export
updateNumericFilter <- function(session, inputId, label = NULL, start = NULL, end = NULL, minValue = NULL, maxValue = NULL) {
  message <- dropNulls(list(label = label, start = start, end = end, min = minValue, max = maxValue))
  session$sendInputMessage(inputId, message)
}

#' Change a categorical legend in the client
#'
#' @details This function only affects the label and the selection. Re-creating the items requires deleting and re-creating the legend using `shinyjs`, for example.
#'
#' @param session The `session` object passed to function given to
#'   `shinyServer`.
#' @param inputId The id of the input object.
#' @param label The label to set for the input object.
#' @param select Items to be selected.
#' @param deselect Items to be deselected.
#'
#' @seealso [categoricalColorFilter()]
#'
#' @export
updateCategoricalFilter <- function(session, inputId, label = NULL, select = NULL, deselect = NULL) {
  message <- dropNulls(list(label = label, select = select, deselect = deselect))
  session$sendInputMessage(inputId, message)
}
