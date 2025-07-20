# ================================
# aggregate_land_cover.R
# ================================

library(terra)

# ------------------------
# Define input rasters
# ------------------------
urban_r <- rast("data/rasters/kde/training/binary/urban_binary_2018.tif")
forest_r <- rast("data/rasters/kde/training/binary/forest_binary_2018.tif")
agri_r <- rast("data/rasters/kde/training/binary/agriculture_binary_2018.tif")

# ------------------------
# Confirm resolution and CRS
# ------------------------
print(res(urban_r))  # Should be ~0.008333
print(crs(urban_r))  # Should be EPSG:4326

# ------------------------
# Aggregation function
# ------------------------
agg_factor <- 10  # from 1 km → 10 km
agg_fun <- "mean"  # calculates % land cover in each 10 km cell

urban_agg <- aggregate(urban_r, fact = agg_factor, fun = agg_fun, na.rm = TRUE)
forest_agg <- aggregate(forest_r, fact = agg_factor, fun = agg_fun, na.rm = TRUE)
agri_agg <- aggregate(agri_r, fact = agg_factor, fun = agg_fun, na.rm = TRUE)

# ------------------------
# Save outputs
# ------------------------
writeRaster(urban_agg, "data/rasters/aggregation_LULC/training_region/urban_agg_10km.tif", overwrite = TRUE)
writeRaster(forest_agg, "data/rasters/aggregation_LULC/training_region/forest_agg_10km.tif", overwrite = TRUE)
writeRaster(agri_agg, "data/rasters/aggregation_LULC/training_region/agriculture_agg_10km.tif", overwrite = TRUE)

cat("Aggregation complete. All rasters saved as 10 km proportion surfaces.\n")
