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
  geom_spatraster(data = spr_ex)
star_ex <- st_as_stars(spr_ex)
mapview(star_ex)

# Data Type in Raster -----------------------------------------------------

v_elev <- values(spr_ex)
extract(spr_ex, y = cbind(6.0000, 50.0000))
extract(spr_ex, y = cbind(6.5000, 52.0000))
extract(spr_ex, y = cbind(5.8000, 49.2000))
extract(spr_ex, y = cbind(6.9000, 42.0000))
df_point <- tibble(lon = c(6, 5.9), lat = c(50, 49.96))
extract(spr_ex, y = df_point)
spr_for <- rast("data/spr_forest_nc.tif")
ggplot() +
  geom_spatraster(data = spr_for)
unique(spr_for)
v_binary <- values(spr_for)
mean(v_binary)*100 ## 68.42346
spr_land <- rast("data/spr_land_reclass.tif")
unique(spr_land)
## 1001 = Forest, 1010 = Crop, and 1100 = Urban
extract(spr_land, y = cbind(-79.8063, 36.0701))
cm <- cbind(c(0, 1001, 1010, 1100), c(0, 1, 0, 0))
cm2 <- cbind(c(0, 1001, 1010, 1100), c(0, 0, 1, 0))
cm3 <- cbind(c(0, 1001, 1010, 1100), c(0, 0, 0, 1))
spr_bin <- classify(spr_land, rcl = cm)
spr_crop <- classify(spr_land, rcl = cm2)
spr_urban <- classify(spr_land, rcl = cm3)
unique(spr_bin)
v_bin <- values(spr_bin)
v_crop <- values(spr_crop)
v_urban <- values(spr_urban)
m_bin <- mean(v_bin)*100
m_crop <- mean(v_crop)*100
m_urban <- mean(v_urban)*100

# Exercise ----------------------------------------------------------------

spr_prec_ncne <- rast("data/spr_prec_ncne.tif")
## 162 rows and 532 columns.
## Resolution 0.0083 degrees by 0.0083 degrees.
## Longitude is -79.89181 to -75.45847 and latitude is 35.24153 to 36.59153.
## CRS is EPSG:4326.
## The minimum precipitation is 1063.099976 and the maximum is 1501.5.
ggplot() +
  geom_spatraster(data = spr_prec_ncne)
sf_site <- readRDS("data/sf_finsync_nc.rds")
df_xy <- st_coordinates(sf_site)
df_land <- extract(spr_land, y = df_xy)
cm_land <- cbind(c(0, 1001, 1010, 1100), c(0, 1, 0, 0))
cm_land2 <- cbind(c(0, 1001, 1010, 1100), c(0, 0, 1, 0))
cm_land3 <- cbind(c(0, 1001, 1010, 1100), c(0, 0, 0, 1))
spr_forest <- classify(spr_land, rcl = cm_land)
spr_crop2 <- classify(spr_land, rcl = cm_land2)
spr_urban2 <- classify(spr_land, rcl = cm_land3)
v_forest <- values(spr_forest)
v_crop2 <- values(spr_crop2)
v_urban2 <- values(spr_urban2)
m_forest <- mean(v_forest)*100
m_crop2 <- mean(v_crop2)*100
m_urban2 <- mean(v_urban2)*100
## The most common land use is forest, while urban is 3.1695