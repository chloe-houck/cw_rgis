if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               ggeffects,
               sf,
               terra,
               tidyterra,
               exactextractr,
               mapview)

# Linking GIS to Ecology --------------------------------------------------

df_finsync <- read_csv("data/data_finsync_nc.csv")
sf_stl <- filter(df_finsync, site_id == "finsync_nrs_nc-10013")
df_rbs <- pivot_wider(df_finsync, id_cols = c("site_id", "lon", "lat"), names_from = latin, values_from = presence, values_fill = 0) %>% 
  select(site_id, lon, lat, "Lepomis auritus") %>% 
  rename(y = "Lepomis auritus")
sf_rbs <- st_as_sf(df_rbs,coords = c("lon", "lat"), crs = 4326)
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")
sf_rbs_tmp <- extract(x = spr_tmp_nc, y = sf_rbs, bind = TRUE) %>% 
  st_as_sf()
df_rbs_tmp <- sf_rbs_tmp %>% 
  as_tibble() %>% 
  select(-geometry)
ggplot() + 
  geom_spatraster(data = spr_tmp_nc) + 
  geom_sf(data = sf_rbs, aes(color = factor(y))) + 
  scale_fill_viridis_c() + 
  theme_bw()

# Statistical Analysys ----------------------------------------------------

m <- glm(y ~ temperature, data = df_rbs_tmp, family = "binomial")
summary(m)
df_pred <- ggpredict(m,
                     terms = "temperature [all]")
ggplot() + 
  geom_point(data = df_rbs_tmp, aes(x = temperature, y = y)) + 
  geom_line(data = df_pred, aes(x = x, y = predicted)) + 
  geom_ribbon(data = df_pred,
              aes(x = x,
                  ymin = conf.low,
                  ymax = conf.high),
              fill = "grey",
              alpha = 0.2) +  
  labs(x = "Air temperature", y = "Probability of Occurance") + 
  theme_bw()
