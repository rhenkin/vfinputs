library(shiny)
library(vfinputs)

ui <- fluidPage(
  flowLayout(
    actionButton("update_sel", "Change values selection"),
    categoricalColorFilter("test_discrete_1",
      label = p("Test with values:"), palette = scales::viridis_pal(),
      values = list("a", "b", "c")
    ),
    categoricalColorFilter("test_discrete_2",
      label = p("Test with data:"), data = sort(mtcars$gear),
      palette = RColorBrewer::brewer.pal(8, "Dark2")
    ),
    categoricalColorFilter("test_discrete_3",
      label = p("Test single selection: "), data = sort(mtcars$gear),
      palette = RColorBrewer::brewer.pal(8, "Dark2"), multiple = FALSE
    ),
    categoricalColorFilter("test_discrete_4",
      label = p("Test single selection: "), data = sort(mtcars$gear),
      orient = "right", palette = RColorBrewer::brewer.pal(8, "Dark2"), multiple = FALSE
    )
  ),
  verbatimTextOutput("selection")
)

server <- function(input, output, session) {
  observeEvent(input$update_sel, {
    updateCategoricalFilter(session, "test_discrete_1", select = list("a"), deselect = list("c"))
  })

  observeEvent(input$test_discrete_1, {
    output$selection <- renderPrint({
      if (!is.null(input$test_discrete_1)) {
        format(input$test_discrete_1)
      }
    })
  })
}

shinyApp(ui = ui, server = server)
