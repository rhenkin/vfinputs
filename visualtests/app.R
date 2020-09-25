# source("R/utils.R")
# source("R/drawShapes.R")
# source("R/baseLegends.R")
# source("R/colorFilters.R")
# source("R/update.R")

devtools::load_all('.', reset = TRUE, export_all = FALSE)

ui <- fluidPage(
      #Test ORIENT and COLOR -----------------------------------------------------------
      flowLayout(continuousColorFilter("test_bottom", label = p("Test orientation and color"), minValue = 0, maxValue = 200, palette = scales::viridis_pal()),
      continuousColorFilter("test_top", minValue = 0, maxValue = 200,
                            orient = "top", palette = scales::viridis_pal()),
      continuousColorFilter("test_left", minValue = 0, maxValue = 200,
                            orient = "left", palette = scales::viridis_pal()),
      continuousColorFilter("test_right", minValue = 0, maxValue = 200,
                            orient = "right", palette = colorRampPalette(rev(c("#67001F", "#B2182B", "#D6604D", "#F4A582", "#FDDBC7", "#F7F7F7", "#D1E5F0", "#92C5DE", "#4393C3", "#2166AC", "#053061") )))),

      #Testing DATA and OPTION TICKS and FORMAT -------------------------------
      flowLayout(continuousColorFilter("test", label = p("Test data, tick and format options"), data = mtcars$mpg, palette = colorRamps::blue2red),
                 continuousColorFilter("test1", data = mtcars$mpg, palette = colorRamps::blue2red, options = list(ticks = 2)),
                 continuousColorFilter("test2", data = mtcars$mpg, palette = colorRamps::blue2red, options = list(ticks = 2, format = "d")),
                 continuousColorFilter("test3", data = mtcars$mpg, palette = colorRamps::blue2red, options = list(hide_brush_labels = TRUE))),

      #Test SIZE and ORIENT ---------------------------------------------------
      flowLayout(continuousColorFilter("test_bottom1", label = p("Test size and orientation"), minValue = 0, maxValue = 200, size = 200, palette = scales::viridis_pal()),
                 continuousColorFilter("test_top1", minValue = 0, maxValue = 200, orient = "top",
                                      size = 100, palette = scales::viridis_pal()),
                 continuousColorFilter("test_left1", minValue = 0, maxValue = 200, orient = "left",
                                      size = 50, palette = scales::viridis_pal()),
                 continuousColorFilter("test_right1", minValue = 0, maxValue = 200,  orient = "right",
                                      size = 150, palette = scales::viridis_pal())),

      #Test THICKNESS and ORIENT ----------------------------------------------
      flowLayout(continuousColorFilter("test_bottom_thick", label = p("Test thickness, orientation and offset"), minValue = 0, maxValue = 200, palette = scales::viridis_pal(), thickness = 50),
                 continuousColorFilter("test_top_thick", minValue = 0, maxValue = 200, orient = "top",
                                       thickness = 50, palette = scales::viridis_pal()),
                 continuousColorFilter("test_left_thick", minValue = 0, maxValue = 200, orient = "left",
                                       thickness = 50, palette = scales::viridis_pal()),
                 continuousColorFilter("test_right_thick", minValue = 0, maxValue = 200,  orient = "right",
                                       thickness = 50, palette = scales::viridis_pal())),

      #Test THICKNESS and ORIENT ----------------------------------------------
      flowLayout(continuousColorFilter("test_bottom_thick2", label = p("Test thickness and orientation"), minValue = 0, maxValue = 200, palette = scales::viridis_pal(), thickness = 10),
                 continuousColorFilter("test_top_thick2", minValue = 0, maxValue = 200, orient = "top",
                                       thickness = 10, palette = scales::viridis_pal()),
                 continuousColorFilter("test_left_thick2", minValue = 0, maxValue = 2000, orient = "left",
                                       thickness = 10, palette = scales::viridis_pal()),
                          continuousColorFilter("test_right_thick2", minValue = 0, maxValue = 2000,  orient = "right",
                                       thickness = 10,  palette = scales::viridis_pal())),
      #Test OFFSET ------------------------------------------------------------
      flowLayout(continuousColorFilter("test_left_offset1", label = p("Test thickness, orientation and offset"),
                                       orient="left",minValue = 0, offset=15,maxValue = 20000, palette = scales::viridis_pal()),
                 continuousColorFilter("test_rightt_offset1",
                                       orient="right",minValue = 0, offset=-15,maxValue = 20000, palette = scales::viridis_pal())),
      flowLayout(continuousColorFilter("test_ticks1", data = mtcars$mpg, palette = colorRamps::blue2red, options = list(ticks = 0)),
                 continuousColorFilter("test_ticks2", data = mtcars$mpg, palette = colorRamps::blue2red, options = list(ticks = 2))),

      #categoricalColorFilter("test5", data = sort(mtcars$gear), orient = "right", scheme = "category10"),
      verbatimTextOutput("selection")
)

server <- function(input, output, session) {

  # output$selection <- renderPrint(
  #   if (!is.null(input$test))
  #   paste0(input$test$start,",",input$test$end)
  # )

  observeEvent(input$test, {

    output$selection <- renderPrint(
      if (!is.null(input$test)) {
        paste0(input$test$start,",",input$test$end)
        })


  })
}

shinyApp(ui = ui, server = server)
