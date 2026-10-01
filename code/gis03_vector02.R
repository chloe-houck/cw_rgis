if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)
rm(list = ls())
sf_site <- readRDS ("data/sf_finsync_nc.rds")
sf_nc_county <- readRDS("data/sf_nc_county.rds")
mapview(sf_nc_county, legend = FALSE) + mapview(sf_site, legend = FALSE)
sf_site_join <- st_join(x = sf_site, y = sf_nc_county)
sf_site_guilford <- filter(sf_site_join, county == "guilford")
sf_site_clay <- filter(sf_site_join, county == "clay")
sf_str <- readRDS("data/sf_stream_gi.rds")
ggplot() +
  geom_sf(data = sf_str, color = "blue") +
  geom_sf(data = sf_site_guilford, color = "hotpink")
sf_str_proj <- st_transform(sf_str, crs = 32617)
v_str_l <- st_length(sf_str_proj)
head(v_str_l)
sf_str_w_len <- sf_str %>% 
  mutate(length = v_str_l)
sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617)
v_area <- st_area(sf_nc_county)
# print the first 10 elements
head(v_area)
sf_nc_county_w_area <- sf_nc_county %>% 
    mutate(area = v_area)
(sf_nc_county_w_area <- sf_nc_county %>% 
    st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate area calculation
    mutate(area = st_area(.)) %>%       # calculate area of each polygon and store it in a new column
    st_transform(crs = 4326))           # transform back to geographic CRS (wgs84) for consistency with other layers
sf_nc_county_1000 <- sf_nc_county_w_area %>% 
    mutate(area = as.numeric(area) / 1e+6) %>%  
    filter(area > 1000)
ggplot() +
  geom_sf(data = sf_nc_county)

# Exercise ----------------------------------------------------------------


sf_quakes <- readRDS("data/sf_quakes.rds")
sf_nz <- readRDS("data/sf_nz.rds")
mapview(sf_nz)
mapview(sf_quakes)
sf_quakes_join <- st_join(x = sf_quakes, y = sf_nz)
sf_quakes_nz <- drop_na(sf_quakes_join, fid)
nrow(sf_quakes_nz) ## There's 0..?
df_n <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n = n())
sf_n_site <- left_join(x = sf_nc_county, y = df_n)
sf_n10 <- filter(sf_n_site, n > 10)
ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_n_site, color = "grey") +
  geom_sf(data = sf_n10, color = "salmon")
