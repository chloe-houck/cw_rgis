if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

# Raster Data Format ------------------------------------------------------

spr_ex <- rast("data/spr_example.tif")
writeRaster(x = spr_ex, filename = "data/spr_elev.tif", overwrite = TRUE)
ggplot() +
  geom