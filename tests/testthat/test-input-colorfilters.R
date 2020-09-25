context("Testing arguments of legends")
test_that("wrong argument combination fail", {
  # Missing data or min/maxvalue
  expect_error(continuousColorFilter("filter", colors = c("red", "blue")))
  # Missing colors or palette
  expect_error(continuousColorFilter("filter", data = mtcars$mpg))
  # More than one color is needed for interpolation
  expect_error(continuousColorFilter("filter", data = mtcars$mpg, colors = c("red")))

  # Palette in continuous filter should be a function, not a list of colors
  expect_error(continuousColorFilter("filter", data = mtcars$mpg, palette = c("red", "blue")))

  # Min or max value must be numeric
  expect_error(continuousColorFilter("filter", minValue = 5, maxValue = "10", colors = c("red", "blue")))

  # Missing data or min/maxvalue
  expect_error(discreteColorFilter("filter", colors = c("red", "blue")))
  # Missing colors or palette
  expect_error(discreteColorFilter("filter", data = mtcars$mpg))
  # More than one color is needed for interpolation
  expect_error(discreteColorFilter("filter", data = mtcars$mpg, colors = c("red")))
  # Invalid orientation
  expect_error(discreteColorFilter("filter", data = mtcars$mpg, colors = c("red", "blue"), orient = "up" ))

  # More than one color is needed for interpolation
  expect_error(categoricalColorFilter("filter", values = list("a", "b", "c"), colors = c("red")))
  # Length of values and palette do not match
  expect_error(categoricalColorFilter("filter", values = c("a", "b", "c"), palette = list("red", "blue")))

})

context("Update input controls")

test_that("Numeric and categorical filters work with modules", {

  createModuleSession <- function(moduleId) {
    session <- as.environment(list(
      ns = shiny::NS(moduleId),
      sendInputMessage = function(inputId, message) {
        session$lastInputMessage = list(id = inputId, message = message)
      }
    ))
    session
  }

  sessA <- createModuleSession("modA")

  updateNumericFilter(sessA, "filter", label = "One", start = 5, end = 10, minValue = 0, maxValue = 20)

  resultA <- sessA$lastInputMessage

  expect_equal("filter", resultA$id)
  expect_equal("One", resultA$message$label)
  expect_equal(5, resultA$message$start)
  expect_equal(10, resultA$message$end)
  expect_equal(0, resultA$message$min)
  expect_equal(20, resultA$message$max)

  sessB <- createModuleSession("modB")

  updateCategoricalFilter(sessB, "filter", label = "One", select = c("b"), deselect = c("c"))

  resultB <- sessB$lastInputMessage

  expect_equal("filter", resultB$id)
  expect_equal("One", resultB$message$label)
  expect_equal(c("b"), resultB$message$select)
  expect_equal(c("c"), resultB$message$deselect)

})
