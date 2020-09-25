#' Create a numeric legend
#'
#' Create a color legend based on given data and palette or colors. Also passes on data- attributes for optional JS interaction.
#'
#' @param inputId The `input` slot that will be used to access the value.
#' @param label Display label for the control, or `NULL` for no label.
#' @param class The CSS class of the input div element to match with any brush-defining functions. Default classes for brushes are either `"continuous-color-filter"` or `"discrete-color-filter"`.
#' @param n Number of color strips in the legend. Default is `100`.
#' @param minValue Minimum numeric value in the legend (can be higher the maximum for inverted scale).
#' @param maxValue Maximum numeric value in the legend (can be lower the minimum for inverted scale).
#' @param data Alternative vector to extract numeric minimum and maximum values.
#' @param colors  Colours to interpolate; must be a valid argument to
#'   [grDevices::col2rgb()]. This can be a character vector of
#'   `"#RRGGBB"` or  `"#RRGGBBAA"`, colour names from
#'   [grDevices::colors()], or a positive integer that indexes into
#'   [grDevices::palette()].
#' @param palette A function that outputs a list of colors
#' @param options Configuration options for brush and scale. Use `ticks` to specify number of ticks or a list of specific tick values
#' , `format` to a d3-format-compatible formatting string (see \url{https://github.com/d3/d3-format} for valid formats) and
#' `hide_brush_labels` as `TRUE` to hide the brush interval.
#' @param orient Orientation of the legend. Can be `"bottom"` (default, horizontal with labels below), `"top"` (horizontal with labels above), `"left"` (vertical with labels on the left)
#'  and `"right"` (vertical with labels on the right).
#' @param size Absolute length in pixels of the color bar; becomes width or height depending on value of `orient`. Default is `200`.
#' @param thickness Absolute thickness in pixels of the color bar; opposite of size depending on value of `orient`. Default is `20`.
#' @param offset Left offset for scale to allow long labels. Default is `0`.
#'
#' @return A numeric color legend control that can be added to a UI definition
#'
#' @family base legend
#' @seealso [discreteColorFilter()] [continuousColorFilter()] [categoricalColorFilter()]
#'
#' @import shiny
#' @export
numericLegend <- function(inputId, label = NULL, class = "", n = 100, minValue = NULL, maxValue = NULL, data = NULL, colors = NULL,
                          palette = NULL, options = NULL, orient = "bottom", size = 200, thickness = 20, offset = 0) {

  # Data options are passed to JavaScript to set up the brush
  data_options <- list()

  if (!validateOrient(orient))
    stop(paste0(inputId, ": orient must be 'bottom', 'top', 'right' or 'left'"))

  # For convenience the function can receive a column of a dataframe/vector/list as an argument
  # Min and max values are then automatically calculated
  data_neutral <- NULL
  if (!is.null(data)) {
    data_min <- min(data)
    data_max <- max(data)
  }
  else if (((is.null(minValue)) || is.null(maxValue)) ||
    (!is.numeric(minValue) || !is.numeric(maxValue))) {
    stop(paste0(inputId, ": Either a vector/list or minimum and maximum numeric data values must be provided."))
  }
  else {
    if (is.numeric(minValue) & is.numeric(maxValue)) {
      data_min <- minValue
      data_max <- maxValue
    }
    else stop(paste0(inputId, ": minValue or maxValue must be numeric"))
  }

  data_options[["numcolors"]] <- n
  numcolors <- n

  # Color validation
  if (!is.null(palette)) {
    if (!is.null(colors)) stop(paste0(inputId,": Only one of colors or palette should be passed."))

    if (is.function(palette)) {
      color_map <- palette(numcolors)
    }
    else if (class == "discrete-color-filter") {
      if (is.list(palette) | is.vector(palette)) {
        numcolors <- length(palette)
        data_options[["numcolors"]] <- length(palette)
        color_map <- palette
      }
      else stop(paste0(inputId,": Palette must be either a function that receives a number of colors or a list of colors"))
    }
    else {
      stop(paste0(inputId,": Palette must be a function that receives a number of colors"))
    }
  }

  else if (!is.null(colors)) {
    if (length(colors) > 1) {
      color_map <- scales::colour_ramp(colors)(seq(0, 1, length = numcolors))
    }
    else {
      stop(paste0(inputId,": At least two colors must be provided for simple linear interpolation if a palette is not provided"))
    }
  }
  else {
    stop(paste0(inputId,": Either a palette or two colors for interpolation must be defined"))
  }

  # div_container_size <- paste0("width: ", htmltools::validateCssUnit(containerWidth), "; height: ", htmltools::validateCssUnit(containerHeight))
  div_container_size <- paste0("width: 100% ; height: 100%")
  svg_width <- NULL
  svg_height <- NULL


  if ((orient == "bottom") | (orient == "top")) {
    svg_width <- size + offset + 40
    svg_height <- thickness + 80

    stylesize0 <-
      paste0("width: ", htmltools::validateCssUnit(svg_width), ";")
    stylesize <-
      paste0(stylesize0, "height: ", htmltools::validateCssUnit(svg_height), "px")
  }
  else {
    svg_width <- offset + thickness + 120
    svg_height <- size + 20

    stylesize0 <-
      paste0("height: ", htmltools::validateCssUnit(svg_height), ";")
    stylesize <-
      paste0(
        stylesize0,
        "width: ",
        htmltools::validateCssUnit(svg_width),
        "px"
      )
  }

  svg_size <- list("width" = svg_width, "height" = svg_height)

  if (!missing(options)) {
    if (!is.null(options$ticks)) {
      if (!is.numeric(options$ticks) & (length(options$ticks) < 1)) {
        stop(paste0(inputId,"Ticks must be a number or a list of numbers"))
      }
      else {
        data_options[["ticks"]] <- options$ticks
      }
    }

    # Format is not validated when running the Shiny app
    if (!is.null(options$format)) {
      data_options[["format"]] <- options$format
    }

    if (!is.null(options$hide_brush_labels)) {
      data_options[["hide_brush_labels"]] <- options$hide_brush_labels
    }
  }

  inner_width <- ifelse((orient == "bottom" | orient == "top"), size, thickness) + offset # svg_size$width - 40 + offset;
  inner_height <- ifelse((orient == "bottom" | orient == "top"), thickness, size) # svg_size$height - 10

  legend_scale <- scale_to(0, numcolors, 0, ifelse((orient == "bottom" | orient == "top"), inner_width, inner_height))

  # colormap <- lapply(1:numcolors, FUN = function(x,cmap) { return(cmap[x]) }, cmap = color_map)

  # Create a group of svg rects based on the color map above
  strips <-
    tag("g", tagList(
      addColorStrips(
        numcolors,
        color_map,
        orient,
        legend_scale,
        ifelse((orient == "bottom" | orient == "top"), inner_width, inner_height),
        thickness
      )
    ))

  # Positioning the group element that defines where the gradient, axis and brush are drawn
  # For the right-oriented filters, we need to position them based on the width of the drawing area
  left_offset <- list(
    "bottom" = 20 + offset,
    "top" = 20 + offset,
    "right" = inner_width - thickness - 25,
    "left" = 30 + offset
  )


  g <- tag("g", list(
    "id" = paste0("g-filter-", inputId),
    "transform" = paste0("translate(", left_offset[[orient]], ",5)"),
    strips
  ))

  # clipRect <- tag("rect", list("width" = svg_size$width, "height" = svg_size$height))
  # defs <- tag("defs", tagList(tag("clipPath", list("id" = paste0("clip-", inputId), clipRect))))

  svg <- tag("svg", list(
    "xmlns" = "http://www.w3.org/2000/svg",
    "viewBox" = paste("0 0", svg_size$width, svg_size$height),
    "class" = "filter-svg",
    "id" = paste0("svg-filter-", inputId),
    "width" = svg_size$width,
    "height" = svg_size$height,
    # "clip-path" = paste0("url(#clip-",inputId,")"),
    # defs,
    g
  ))

  div(
    class = "form-group shiny-input-container",
    style = div_container_size,
    tags$label(
      label,
      class = "control-label",
      class = if (is.null(label)) "shiny-label-null",
      `for` = inputId
    ), tags$div(
      id = inputId,
      class = class,
      style = stylesize,
      "data-size" = jsonlite::toJSON(list("width" = inner_width, "height" = inner_height), auto_unbox = TRUE),
      "data-orient" = orient,
      "data-min" = data_min,
      "data-max" = data_max,
      "data-thickness" = thickness,
      "data-options" = jsonlite::toJSON(data_options, auto_unbox = TRUE),
      tagList(svg)
    )
  )
}

#' Create a categorical legend
#'
#' Create a color legend based on given data and palette or colors. Also passes on data- attributes for optional JS interaction.
#'
#' @param inputId The `input` slot that will be used to access the value.
#' @param label Display label for the control, or `NULL` for no label.
#' @param class The CSS class of the input div element to match with any filter toggling functions. Default class is `"categorical-color-filter"`.
#' @param values List of character vectors that will match with the colors or palette in the order provided by both.
#' @param data Alternative vector to extract values with `"unique()"` function.
#' @param colors  Colours to match with values; must be a valid argument to
#'   [grDevices::col2rgb()]. This can be a character vector of
#'   `"#RRGGBB"` or  `"#RRGGBBAA"`, colour names from
#'   [grDevices::colors()], or a positive integer that indexes into
#'   [grDevices::palette()].
#' @param palette A function that outputs a list of colors.
#' @param orient Orientation of the legend. Can be `"bottom"` (default, horizontal with labels below), `"top"` (horizontal with labels above), `"left"` (vertical with labels on the left)
#'  and `"right"` (vertical with labels on the right).
#' @param size Absolute length in pixels of the color bar; becomes width or height depending on value of `orient`. Default is `220`.
#' @param multiple Is selection of multiple items allowed? Default is `TRUE`. With `FALSE`, selecting one item will de-select the others.
#' @return A categorical color legend control that can be added to a UI definition
#'
#' @family base legend
#' @seealso [discreteColorFilter()] [continuousColorFilter()] [categoricalColorFilter()]
#'
#' @import shiny
#' @export
categoricalLegend <- function(inputId, label = NULL, class = "", values = NULL, data = NULL, colors = NULL,
                              palette = NULL, orient = "bottom", size = 220, multiple = TRUE) {


  if (!validateOrient(orient))
    stop(paste0(inputId, ": orient must be 'bottom', 'top', 'right' or 'left'"))

  if (!is.null(values)) {
    if (!is.null(data)) stop(paste0(inputId,": Only one of values or data should be passed."))

    if (!is.list(values) & !is.vector(values)) {
      stop(paste0(inputId,": Values must be provided in a list."))
    }

  }

  if (!is.null(data)) {
    # if (typeof(data) == "character") stop("Invalid data type")
    if (mode(data) == "numeric") {
      message(paste0(inputId,": Numeric data type might yield unexpected results."))
    }
    values <- unique(data)
  }
  if (is.null(data) & is.null(values)) {
    stop(paste0(inputId,": At least one of data or values must be provided."))
  }

  numcolors <- length(values)

  # Color validation
  if (!is.null(palette)) {
    # If palette is a function, that's all good
    if (is.function(palette)) {
      color_map <- palette(numcolors)
    }
    else if (is.vector(palette) | is.list(palette)) {
      # If palette is either a list or a vector, we check if the numbers match
      if (length(palette) != numcolors)
        stop(paste0(inputId,": The number of values must match the number of colors."))
      else
        color_map <- palette
    }
    else {
      stop(paste0(inputId,": Palette must either be a function that receives a number of colors or a list of colors."))
    }
  }
  else if (!is.null(colors)) {
    # If colors are passed, we need at least two because we will generate a discrete palette through interpolation
    if (length(colors) > 1) {
      color_map <- scales::colour_ramp(colors)(seq(0, 1, length = numcolors))
    }
    else {
       stop(paste0(inputId,": At least two colors must be provided for simple linear interpolation if a palette is not provided."))
    }
  }
  else {
    stop(paste0(inputId,": Either a palette or two colors for interpolation must be provided"))
  }


  if ((orient == "bottom") | (orient == "top")) {
    stylesize0 <- paste0("width: ", htmltools::validateCssUnit(size), ";")
    stylesize <- paste0(stylesize0, "height: 90px")
    svg_size <- list("width" = size, "height" = 90)
  }
  else {
    stylesize0 <- paste0("height: ", htmltools::validateCssUnit(size), ";")
    stylesize <- paste0(stylesize0, "width: 90px")
    svg_size <- list("width" = 90, "height" = size)
  }

  tag_head <- {
    if (orient == "left") {
      tags$head(tags$style(
        paste0(".", inputId, "{
                    display: inline-flex;
                    align-items: center;
                    margin-right: 1em;
                    } .", inputId, "::after {
                    content: \"\";
                    width: 20px;
                    height: 15px;
                    margin-left: 0.5em;
                    margin-right: 0.25em;
                    background: var(--color);
                    }
                    .selected::after { border: solid 1.5px black; }
                    .selected { font-weight: bold; }")
      ))
    }
    else {
      tags$head(tags$style(
        paste0(".", inputId, "{
                            display: inline-flex;
                            align-items: center;
                            margin-right: 1em;
                            } .", inputId, "::before {
                            content: \"\";
                            width: 20px;
                            height: 15px;
                            margin-left: 0.5em;
                            margin-right: 0.25em;
                            background: var(--color);
                            }
                            .selected::before { border: solid 1.5px black; }
                            .selected { font-weight: bold; }")
      ))
    }
  }

  category_blocks <-
    tag("g", tagList(
      addCategoryBlocks(
        orient = "orient",
        input_id = inputId,
        color_map = color_map,
        values = values
      )
    ))

  div(
    class = "form-group shiny-input-container",
    style = stylesize0,
    tags$label(
      label,
      class = "control-label",
      class = if (is.null(label)) "shiny-label-null",
      `for` = inputId
    ), tags$div(
      id = inputId,
      class = class,
      style = stylesize,
      "data-multiple" = multiple,
      tagList(tag_head, category_blocks)
    )
  )
}
