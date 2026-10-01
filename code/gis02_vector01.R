if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)
rm(list = ls())

# Read and Export ---------------------------------------------------------

sf_nc_county <- st_read(dsn = "data/nc.shp", quiet = TRUE)
st_write(sf_nc_county, dsn = "data/sf_nc_county.shp", append = FALSE)
saveRDS(sf_nc_county, file = "data/sf_nc_county.rds")
sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")

# Point -------------------------------------------------------------------

sf_site <- readRDS("data/sf_finsync_nc.rds")
mapview(sf_site, col.regions = "black", legend = FALSE)
sf_site_f10 <- slice(sf_site, 1:10)
mapview(sf_site_f10, col.regions = "black", legend = FALSE)

# Line --------------------------------------------------------------------

sf_str <- readRDS("data/sf_stream_gi.rds")
mapview(sf_str, color = "blue", legend = FALSE)

# Polygon -----------------------------------------------------------------

sf_nc_county <- readRDS("data/sf_nc_county.rds")
mapview(sf_nc_county, col.regions = "pink", legend = FALSE)
sf_nc_gi <- sf_nc_county %>% 
  filter(county == "guilford")
mapview(sf_nc_gi, col.regions = "pink", legend = FALSE)

# Static Map in ggplot Format ---------------------------------------------

ggplot() +
  geom_sf(data = sf_nc_county)
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str, color = "blue")
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str, color = "blue") +
  geom_sf(data = sf_site)

# Exercise ----------------------------------------------------------------

sf_str_as <- readRDS(file = "data/sf_stream_as.rds")
CRS1 <- st_crs(sf_str_as)
CRS2 <- st_crs(sf_nc_county)
identical(CRS1, CRS2)
## They don't
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as, color = "darkblue")
sf_nc_as <- sf_nc_county %>% 
  filter(county == "ashe")
ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as, color = "darkblue")
