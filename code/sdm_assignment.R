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