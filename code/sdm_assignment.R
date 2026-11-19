if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview,
               stars,
               terra,
               tidyterra,
               exactextractr,
               ggeffects)
df_finsync <- read_csv("data/data_finsync_nc.csv")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")
df_mmc <- pivot_wider(df_finsync, id_cols = c("site_id", "lon", "lat"), names_from = latin, values_from = presence, values_fill = 0) %>% 
  select(site_id, lon, lat, "Noturus insignis") %>% 
  rename(y = "Noturus insignis")
sf_mmc <- st_as_sf(df_mmc,coords = c("lon", "lat"), crs = 4326)
sf_mmc_tmp <- extract(x = spr_tmp_nc, y = sf_mmc, bind = TRUE) %>% 
  st_as_sf()
df_mmc_tmp <- sf_mmc_tmp %>% 
  as_tibble() %>% 
  select(-geometry)
ggplot() + 
  geom_spatraster(data = spr_tmp_nc) + 
  geom_sf(data = sf_mmc, aes(color = factor(y))) + 
  scale_fill_viridis_c() + 
  theme_bw()
m <- glm(y ~ temperature, data = df_mmc_tmp, family = "binomial")
summary(m)
df_pred <- ggpredict(m,
                     terms = "temperature [all]")
ggplot() + 
  geom_point(data = df_mmc_tmp, aes(x = temperature, y = y)) + 
  geom_line(data = df_pred, aes(x = x, y = predicted)) + 
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "grey",
              alpha = 0.2) +  
  labs(x = "Air temperature in °C", y = "Probability of Occurance") + 
  theme_bw()
