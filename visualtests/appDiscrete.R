library(shiny)
library(vfinputs)

ui <- fluidPage(
      flowLayout(discreteColorFilter("test_discrete_1", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                 data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_2", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                 orient="top", data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_3", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                     options = list(format=".2f"), orient="left", data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_4", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                    options = list(format=".2f"), thickness=10, offset= 5,orient="right", data = mtcars$mpg, n =5)),
      flowLayout(discreteColorFilter("test_discrete_a", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                    data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_b", palette = RColorBrewer::brewer.pal(10, "RdBu"), size = 250,
                                     data = mtcars$mpg, options = list(format = "d")),
                 discreteColorFilter("test_discrete_c", colors = list("#ff0000", "white", "#0000ff") , offset = 0,
                                     size = 200, data = mtcars$mpg, n = 3)),
      flowLayout(discreteColorFilter("test_discrete_aa", label = p("Test discrete palette"), palette = scales::viridis_pal(),
                                     data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_bb",  palette = scales::viridis_pal(),
                                     data = mtcars$mpg, n =10),
                 discreteColorFilter("test_discrete_cc",  palette = scales::viridis_pal(),
                                     data = mtcars$mpg, n =15)),
      flowLayout(discreteColorFilter("test_discrete_aaa", label = p("Test discrete palette"),  colors = list("#ff0000", "white", "#0000ff") ,
                                     data = mtcars$mpg, n =5),
                 discreteColorFilter("test_discrete_bbb",   colors = list("#ff0000", "white", "#0000ff") ,
                                     data = mtcars$mpg, n =10),
                 discreteColorFilter("test_discrete_ccc",   palette = list("#ff0000", "white", "#0000ff") ,
                                     data = mtcars$mpg, n =15)),
      verbatimTextOutput("selection")
)

server <- function(input, output, session) {


  observeEvent(input$test, {

    output$selection <- renderPrint(
      if (!is.null(input$test)) {
        paste0(input$test$start,",",input$test$end)
        })


  })
}

shinyApp(ui = ui, server = server)
