library(tidyverse)
library(xml2)
library(magick)

files <- c(
  file.path("..", "assets", "climate_classifications", list.files("assets/climate_classifications/")),
  file.path("..", "assets", "suitability", list.files("assets/suitability/")),
  file.path("..", "assets", "suitability_irrig", list.files("assets/suitability_irrig/")),
  file.path("..", "assets", "nbr", list.files("assets/nbr/"))
)

size <- 350
ncol <- 9
width <- size * ncol
height <- size * length(files)/ncol

coords <- tibble(
  x = rep(seq(0, width - size, size), length(files)/ncol),
  y = rep(seq(0, height - size, size), each = ncol),
  file = files
)

g <- read_xml(glue::glue('<svg width="{width}" height="{height}" xmlns="http://www.w3.org/2000/svg"></svg>'))

pwalk(coords, \(x, y, file) g |>
  xml_add_child(
    "image", 
    width = size, heigth = size, x = x, y = y,
    href = file)
)
  
g |> write_xml("png/test.svg")
