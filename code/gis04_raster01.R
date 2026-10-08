if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)