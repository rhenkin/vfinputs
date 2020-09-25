d3_dependency <- function() {
  htmltools::htmlDependency("d3", "5.15.0", c(href = "wwwvfinputs/js/"),
                            script = "d3.min.js"
  )
}

normalize_value <- function(value, data) {
  return((value - min(data))/(max(data) - min(data)))
  }

normalize_whole <- function(data) {
  return ((data - min(data)) / (max(data) - min(data)))
  }

dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}

scale_to <- function(in.min, in.max, out.min, out.max, discrete = F) {
  if (discrete) {
    return(function(value) {
               return( trunc((value - in.min) / (in.max - in.min) * (out.max-0.1 - out.min) + out.min) )
            } )
  }
  else {
    return(function(value) {
      return( (value - in.min) / (in.max - in.min) * (out.max - out.min) + out.min)
    } )
  }
}

validateOrient <- function(orient) {
  return(orient == "bottom" | orient == "top" | orient == "left" | orient == "right")
}

validateScheme <- function(scheme) {

  validSchemes = list("category10" = "Category10",
                      "accent" = "Accent",
                      "dark2" = "Dark2",
                      "paired" = "Paired",
                      "pastel1" = "Pastel1",
                      "pastel2" = "Pastel2",
                      "set1" = "Set1",
                      "set2" = "Set2",
                      "set3" = "Set3",
                      "tableau10" = "Tableau10",
                      "brbg" = "BrBG",
                      "prgn" = "PRGn",
                      "piyg" = "PiYG",
                      "puor" = "PuOr",
                      "rdbu" = "RdBu",
                      "rdgy" = "RdGy",
                      "rdylbu" ="RdYlBu",
                      "rdyglgn"= "RdYlGn",
                      "spectral" = "spectral",
                      "blues" = "blues",
                      "greens" = "greens",
                      "greys" = "greys",
                      "oranges" = "oranges",
                      "purples" = "purples",
                      "reds" = "reds",
                      "turbo" = "turbo",
                      "viridis" = "viridis",
                      "inferno" = "inferno",
                      "magma" = "magma",
                      "plasma" = "plasma",
                      "cividis" = "cividis",
                      "warm" = "warm",
                      "cool" = "cool",
                      "cubehelixdefault" = "CubehelixDefault",
                      "bugn" = "BuGn",
                      "bupu" = "BuPu",
                      "gnbu" = "GnBu",
                      "orrd" = "OrRd",
                      "pubugn" = "PuBuGn",
                      "pubu" = "PuBu",
                      "purd" = "PuRd",
                      "rdpu" = "RdPu",
                      "ylgnbu" = "YlGnBu",
                      "ylgn" = "YlGn",
                      "ylorbr" = "YlOrBr",
                      "ylorrd" = "YlOrRd",
                      "rainbow" = "Rainbow",
                      "sinebow" = "Sinebow")
  if (tolower(scheme) %in% names(validSchemes))
    return(validSchemes[[tolower(scheme)]])
  else stop("Invalid colour scheme or palette chosen. Please use a valid colour scheme name from https://github.com/d3/d3-scale-chromatic.")


}
