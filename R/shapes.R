#' Add color strip
#'
#' @param color A valid CSS color name
#' @param x The x position of the `rect` shape relative to a container
#' @param y The y position of the `rect` shape relative to a container
#' @param width The width of the `rect`
#' @param height The height of the `rect`
#'
#' @return A `rect` element with the `color` argument as fill and stroke
#'
#' @import shiny
colorStrip <- function(color, x = 0, y = 0,  width = 1, height = 30)  {

  tag("rect", list ("x" = x,
                           "y" = y,
                          "width" = width,
                          "height" = height,
                          "style" = paste0("fill: ", color,"; stroke:", color)))
}

#' Add a color-label block
#'
#' @param i The index of the item to be created
#' @param tag_name An HTML element tag
#' @param class The HTML element class that will enable interaction
#' @param color_map A list of colors from where the corresponding item color will be retrieved
#' @param values A list of values from which the corresponding item label will be retrieved
#'
#' @return An HTML element with pointer cursor, a colored square and a label
#'
#' @import shiny
categoryBlock <- function(i,values, tag_name, class, color_map) {
  tag(tag_name,
      list(
        values[i],
        "class" = class,
        "data-value" = values[i],
        "style" = paste0("cursor: pointer; --color: ", color_map[i])
      ))
}

#' Add list of category items
#'
#' @param orient Orientation of the legend. Can be `"bottom"` (default, horizontal with labels below), `"top"` (horizontal with labels above), `"left"` (vertical with labels on the left)
#'  and `"right"` (vertical with labels on the right).
#' @param input_id The CSS class used to trigger interactions
#' @param color_map A list of colors from where the corresponding item color will be retrieved
#' @param values A list of values from which the corresponding item label will be retrieved
#'
#' @return A list of the same length as values, containing either `"span"` or `"div"` elements depending on the chosen orientation.
#'
#' @seealso [categoricalLegend()]
#'
addCategoryBlocks <- function(orient, input_id, color_map, values) {

    tag_name <- ifelse((orient == "bottom") |  (orient == "top"), "span", "div")

    lapply(1:length(values), categoryBlock, tag_name = tag_name,
            class = input_id, color_map = color_map, values = values)
}

#' Add list of colored strips
#'
#' @param n_strips Number of strips to be added
#' @param color_map A list of colors corresponding to the number of strips
#' @param orient Orientation of the legend. Can be `"bottom"` (default, horizontal with labels below), `"top"` (horizontal with labels above), `"left"` (vertical with labels on the left)
#'  and `"right"` (vertical with labels on the right).
#' @param pos_function A function to convert from index number to pixels
#' @param size The length of the list in pixels
#' @param thickness The height or width of the list in pixels
#'
#' @return A list of SVG `rect` shapes.
#'
#' @seealso [numericLegend()]
#'
addColorStrips <- function(n_strips, color_map, orient, pos_function, size, thickness = 20) {

  return (switch(orient,
         "bottom" = lapply(1:n_strips, function(i) {
                        colorStrip(color = color_map[i],
                        x = pos_function(i-1),
                         y = 20,
                        width = size/n_strips,
                        height= thickness) }),
         "top" =  lapply(1:n_strips, function(i) {
                        colorStrip(color = color_map[i],
                        x = pos_function(i-1),
                        y = 25,
                        width = size/n_strips,
                        height= thickness) }),
         "right" =  lapply(1:n_strips, function(i) {
           colorStrip(color = color_map[i],
                        y = pos_function(i-1),
                        x = 30,
                        height = size/n_strips,
                        width= thickness) }),
         "left" =  lapply(1:n_strips, function(i) {
           colorStrip(color = color_map[i],
                        y = pos_function(i-1),
                        x = 15,
                        height = size/n_strips,
                        width = thickness) }),

         )
  ) #return

}
