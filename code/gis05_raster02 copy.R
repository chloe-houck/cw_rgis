if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

# Precipitation Example ---------------------------------------------------

spr_prec <- rast("data/spr_prec_us.tif")
ext(spr_prec)
ggplot() +
  geom_spatraster(data = spr_prec)
spr_prec_crop <- crop(x = spr_prec, y = c(-80, -75, 34, 37))
ggplot() +
  geom_spatraster(data = spr_prec_crop)
sf_nc_county <- readRDS("data/sf_nc_county.rds")
ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
spr_prec_nc <- crop(x = spr_prec, y = sf_nc_county)
ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county, alpha = 0.25)

# Merge -------------------------------------------------------------------

spr_nw <- rast("data/spr_prec_ncnw.tif")
spr_ne <- rast("data/spr_prec_ncne.tif")
spr_sw <- rast("data/spr_prec_ncsw.tif")
spr_se <- rast("data/spr_prec_ncse.tif")
ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
ggplot() +
  geom_spatraster(data = spr_ne) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
ggplot() +
  geom_spatraster(data = spr_sw) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
ggplot() +
  geom_spatraster(data = spr_se) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
spr_n <- merge(spr_nw, spr_ne)
ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
list_spr <- list(spr_ne, spr_nw, spr_se, spr_sw)
spr_col <- sprc(list_spr)
spr_merge <- merge(spr_col)
ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
writeRaster(spr_merge, "data/spr_prec_nc.tif", overwrite = TRUE)
spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")
ggplot() +
  geom_spatraster(data = spr_tmp_nc) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
spr_pt_nc <- c(spr_prec_nc, spr_tmp_nc)
spr_pt_nc$precipitation
spr_pt_nc$temperature

# Reprojection ------------------------------------------------------------

spr_prec_nc_proj <- project(x = spr_prec_nc, y = "EPSG:32617")
spr_prec_nc_proj

# Exercise ----------------------------------------------------------------

spr_tmp_nw <- rast("data/spr_tmp_ncnw.tif")
spr_tmp_ne <- rast("data/spr_tmp_ncne.tif")
spr_tmp_sw <- rast("data/spr_tmp_ncsw.tif")
spr_tmp_se <- rast("data/spr_tmp_ncse.tif")
list_tmp <- list(spr_tmp_ne, spr_tmp_nw, spr_tmp_se, spr_tmp_sw)
spr_tmp_col <- sprc(list_tmp)
spr_tmp_merge <- merge(spr_tmp_col)
ggplot() +
  geom_spatraster(data = spr_tmp_merge) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
sf_camden <- filter(sf_nc_county, county == "camden")
ext(sf_camden)
spr_tmp_camden <- crop(x = spr_tmp_merge, y = sf_camden)
ggplot() +
  geom_spatraster(data = spr_tmp_camden) +
  geom_sf(data = sf_nc_county, alpha = 0.25)
spr_tmp_camden_proj <- project(x = spr_tmp_camden, y = "EPSG:32618")
spr_tmp_camden_proj
