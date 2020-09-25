#' Add a visual filter input for continuous values
#'
#' @inheritDotParams numericLegend
#' @param inputId The `input` slot that will be used to access the value.
#' @return A visual filter input control that can be added to a UI definition.
#'
#' @family visual filters
#' @seealso [discreteColorFilter()] [categoricalColorFilter()]
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   continuousColorFilter("filter", minValue = 0, maxValue = 200, palette = scales::viridis_pal()),
#'   verbatimTextOutput("value")
#' )
#' server <- function(input, output) {
#'   output$value <- output$selection <- renderPrint({
#'   if (!is.null(input$filter)) {
#'     paste0(input$filter$start, ",", input$filter$end)
#'     }
#'   })
#' }
#' shinyApp(ui, server)
#'
#' ui <- fluidPage(
#'   continuousColorFilter("filter", data = mtcars$mpg, colors = c("#FF0000", "#0000FF")),
#'   verbatimTextOutput("value")
#' )
#' server <- function(input, output) {
#'   output$value <- output$selection <- renderPrint({
#'   if (!is.null(input$filter)) {
#'     paste0(input$filter$start, ",", input$filter$end)
#'     }
#'   })
#' }
#' shinyApp(ui, server)
#'
#' }
#'
#' @section Server value:
#' `start` and `end` bounds of a selection. The default value (or empty selection) is `NULL`.
#'
#' @import shiny
#' @export
continuousColorFilter <- function(inputId, ...) {

  aux_deps <- singleton(
    tags$head(
      tags$script(src = "wwwvfinputs/js/axisfilter.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "wwwvfinputs/css/style.css")
    )
  )

  tagList(
    numericLegend(inputId = inputId, class = "continuous-color-filter", ...),
    singleton(tags$head(
      tags$script(src = "wwwvfinputs/js/continuousLegendFilterBinding.js")
    )),
    d3_dependency(),
    aux_deps
  )
}

#' Add a visual filter input for discrete values
#'
#' @inheritDotParams numericLegend
#' @param inputId The `input` slot that will be used to access the value.
#' @return A visual filter input control that can be added to a UI definition.
#'
#' @family visual filters
#' @seealso [numericLegend()]
#'
#' @section Server value:
#' `start` and `end` bounds of a selection. The default value (or empty selection) is `NULL`.
#'
#' @import shiny
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   discreteColorFilter("filter", minValue = 0, maxValue = 200, n = 5,
#'                         palette = scales::viridis_pal()),
#'   verbatimTextOutput("value")
#' )
#' server <- function(input, output) {
#'   output$value <- output$selection <- renderPrint({
#'   if (!is.null(input$filter)) {
#'     paste0(input$filter$start, ",", input$filter$end)
#'   }
#' })
#' }
#' shinyApp(ui, server)
#' }
#'
#' @section Server value:
#' `start` and `end` bounds of a selection. The default value is null.
#'
#' @import shiny
#' @export
discreteColorFilter <- function(inputId, ...) {

  aux_deps <- singleton(
    tags$head(
      tags$script(src="wwwvfinputs/js/axisfilter.js"),
      tags$link(rel="stylesheet", type="text/css", href="wwwvfinputs/css/style.css")
    )
  )

  tagList(
    numericLegend(inputId = inputId, class = "discrete-color-filter", ...),
    singleton(tags$head(
      tags$script(src="wwwvfinputs/js/discreteLegendFilterBinding.js"))),
    d3_dependency(),
    aux_deps
    )
}

#' Add a visual filter input for categorical data
#'
#' @inheritDotParams categoricalLegend
#' @param inputId The `input` slot that will be used to access the value.
#'
#' @return A visual filter input control that can be added to a UI definition
#'
#' @family visual filters
#' @seealso [categoricalLegend()]
#'
#' @section Server value:
#' `start` and `end` bounds of a selection. The default value (or empty selection) is `NULL`.
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fluidPage(
#'   categoricalColorFilter("filter", data = sort(mtcars$gear), orient = "right",
#'                            palette = RColorBrewer::brewer.pal(8, "Dark2")),
#'   verbatimTextOutput("value")
#' )
#' server <- function(input, output) {
#'   output$value <- output$selection <- renderPrint({
#'   if (!is.null(input$filter)) {
#'     format(input$filter)
#'   }
#' })
#' }
#'
#' shinyApp(ui, server)
#'
#' ui <- fluidPage(
#'   categoricalColorFilter("filter", label = p("Categorical filter:"),
#'                            palette = RColorBrewer::brewer.pal(3, "Accent"),
#'                            values = list("a","b","c")),
#'   verbatimTextOutput("values")
#' )
#' server <- function(input, output) {
#'   output$value <- output$selection <- renderPrint({
#'   if (!is.null(input$filter)) {
#'     format(input$filter)
#'   }
#' })
#' }
#' shinyApp(ui, server)
#'
#' }
#'
#' @import shiny
#' @export
categoricalColorFilter <- function(inputId, ...) {

  aux_deps <- singleton(
    tags$head(
      tags$script(src = "wwwvfinputs/js/visualscales.js"),
      tags$script(src = "wwwvfinputs/js/axisfilter.js"),
      tags$script(src = "wwwvfinputs/js/colorutils.js"),
      tags$link(rel = "stylesheet", type = "text/css", href = "wwwvfinputs/css/style.css")
    )
  )

  tagList(
    categoricalLegend(inputId = inputId, class = "categorical-color-filter",  ...),
    singleton(tags$head(
      tags$script(src = "wwwvfinputs/js/categoricalFilterBinding.js")
    )),
    d3_dependency(),
    aux_deps,
  )
}



