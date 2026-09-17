if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)
df_fish <- read_csv("data/data_finsync_nc.csv")

## Made the first map.

sf_site <- df_fish %>%
  distinct(site_id, lon, lat) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326)
mapview(sf_site)
saveRDS(sf_site, "data/sf_finsync_nc.rds")

## Transforming the data.

sf_ft_wgs <- slice(sf_site, c(1, 2))
sf_ft_utm <- transform(sf_ft_wgs, crs = 32617)
mapview(sf_ft_wgs)
st_distance(sf_ft_utm)

## 2.6 Exercise

df_quakes <- as_tibble(quakes)
sf_quakes <- df_quakes %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)
mapview(sf_quakes)
sf_ft_quakes <- slice(sf_quakes, c(1, 2))
sf_ft_quakes_proj <- transform(sf_ft_quakes, crs = 32760)
mapview(sf_ft_quakes)
st_distance(sf_ft_quakes_proj)
saveRDS(sf_site, "data/sf_quakes.rds")