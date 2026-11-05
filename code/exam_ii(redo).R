# Exam II
# By submitting this exam on time, you will obtain 55 points
# 15 questions in total, with each worth 3 points
# Points will be awarded if your code produces the expected result(s)

if (!require(pacman)) install.packages("pacman")
library(pacman)

# call packages -----------------------------------------------------------

# Execute the following lines of code to call packages
p_load(tidyverse,
       sf,
       terra,
       exactextractr,
       tidyterra)

# To answer the following questions, use the data below:
df_site <- read_csv("data/data_finsync_nc.csv") %>% 
  distinct(site_id, 
           lon, 
           lat)

sf_nc_county <- readRDS("data/sf_nc_county.rds")

# vector data analysis ----------------------------------------------------

# Q1. 
# `df_site` currently has no coordinate reference system (CRS). 
# Convert it to an `sf` object and assign the WGS 84 CRS (EPSG: 4326). 
# Save the resulting object as `sf_site`.
sf_site <- st_as_sf(df_site, coords = c("lon", "lat"), crs = 4326)

# Q2.
# From `sf_nc_county`, select only the county polygons of the following counties: 
#   "guilford", "randolph", "davidson", and "forsyth". 
# Save the result as `sf_four`.
sf_four <- filter(sf_nc_county, when_any(county == "guilford", county == "randolph", county == "davidson", county == "forsyth"))

# Q3. 
# Perform a spatial join to identify sites in `sf_site` that fall within 
#   the four selected counties stored in `sf_four`. 
# Make sure that the output object is a POINT layer after spatial join.
# Remove any rows without a `county` value and save the result as `sf_site_four`.
sf_site_four <- st_join(x = sf_site, y = sf_four, left = FALSE)

# Q4. 
# Create a map showing the four selected counties (`sf_four`) 
#   and the sampling sites (`sf_site_four`) overlaid on the same plot. 
ggplot() +
  geom_sf(data = sf_site_four) +
  geom_sf(data = sf_four, alpha = 0.25)

# Q5. 
# Calculate the pairwise distances among all sites in `sf_site_four`
#   with the appropriate CRS, UTM Zone 17N (EPSG: 32617) 
#   so that distances are measured in meters. 
# Then, find the maximum distance among all site pairs.
# 
# ENTER YOUR ANSWER HERE:

# raster-vector interaction -----------------------------------------------

# Q11.
# The raster file "spr_tmp_nc.tif" in the "data" folder contains 
#   annual mean temperature (°C) data for North Carolina. 
# Load this raster and extract the temperature values 
#   at each sampling site in `sf_site`. 
# Then, identify how many sites have temperature values greater than 16°C.
#
# ENTER YOUR ANSWER HERE:


# Q12. Create 3-km buffers around each site in `sf_site_four` (see Q3). 
# Be sure to first transform the coordinate reference system to UTM Zone 17N (EPSG: 32617) 
# so that the buffer distance is measured in meters.


# Q13. Project the cropped cropland raster (`spr_crop_four`) 
# to the same UTM coordinate reference system (EPSG: 32617). 
# Assign the projected raster to `spr_crop_proj`.
# Use an appropriate re-sampling method in light of the raster data type.


# Q14. Create a map displaying the projected cropland raster (`spr_crop_proj`) 
# with 3-km site buffers (`sf_buff_proj`) overlaid.


# Q15. Calculate the proportion of cropland within each 3-km site buffer. 
# Store the result as `df_crop_frac`, and identify the `site_id` 
# with the highest cropland fraction.
