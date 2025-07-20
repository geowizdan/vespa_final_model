# ================================================
# build_projection_stack_245_LU1.R
# ================================================

library(terra)

# -------------------------------
# Define input paths
# -------------------------------
bioclim_path <- "data/rasters/bioclim/projected_region/unclipped_bioclim_8_rasters/ssp585_8_bioclim_rast.tif"

urban_path  <- "data/rasters/aggregation_LULC/projection_region/LU2-MIT/LU2_urban_agg_10km.tif"
forest_path <- "data/rasters/aggregation_LULC/projection_region/LU2-MIT/LU2_forest_agg_10km.tif"
agri_path   <- "data/rasters/aggregation_LULC/projection_region/LU2-MIT/LU2_agriculture_agg_10km.tif"

output_path <- "data/rasters/projection_stack/245_LU1/predictor_stack_rcp585_lu2.tif"

# Template raster (only used for extent and resolution)
target_shape_path <- "C:/Users/Dan Buchanan/OneDrive - University of Bristol/VespaData/data/derived/test_run/predictor_stack_rcp245_lu1.tif"
# -------------------------------
# Load bioclim raster and assign names
# -------------------------------
bioclim <- rast(bioclim_path)
names(bioclim)
names(bioclim) <- c("bio_3", "bio_4", "bio_6", "bio_8", "bio_13", "bio_15")

template <- rast(target_shape_path)

# -------------------------------
# Load LULC rasters
# -------------------------------
urban  <- rast(urban_path)
forest <- rast(forest_path)
agri   <- rast(agri_path)

# -------------------------------
# Resample LULC rasters to match bioclim
# -------------------------------
urban_rs  <- resample(urban,  bioclim, method = "bilinear")
forest_rs <- resample(forest, bioclim, method = "bilinear")
agri_rs   <- resample(agri,   bioclim, method = "bilinear")

names(urban_rs)  <- "prop_urban"
names(forest_rs) <- "prop_forest"
names(agri_rs)   <- "prop_agriculture"

# -------------------------------
# Stack and save
# -------------------------------
predictor_stack <- c(bioclim, urban_rs, forest_rs, agri_rs)


# Project entire stack to match template's resolution and grid
predictor_stack_aligned <- project(predictor_stack, template, method = "bilinear")

# Then mask to exact land-sea shape (if needed)
predictor_stack_masked <- mask(predictor_stack_aligned, template)
# -------------------------------
# Write final aligned projection stack
# -------------------------------
writeRaster(predictor_stack_masked, output_path, overwrite = TRUE)
cat("Projection stack saved to:", output_path, "\n")
