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
