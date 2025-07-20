# =============================================
# build_updated_training_stack.R
# =============================================

library(terra)

# -------------------------------
# Define file paths
# -------------------------------
bioclim_path <- "data/rasters/bioclim/training/bioclim_19stack_extended_training.tif"

urban_path   <- "data/rasters/aggregation_LULC/training_region/urban_agg_10km.tif"
forest_path  <- "data/rasters/aggregation_LULC/training_region/forest_agg_10km.tif"
agri_path    <- "data/rasters/aggregation_LULC/training_region/agriculture_agg_10km.tif"

output_path  <- "data/rasters/training_stack/updated/predictor_stack_training_updated.tif"

# -------------------------------
# Load full 19-layer bioclim raster
# -------------------------------
bioclim_full <- rast(bioclim_path)

# Subset the selected bioclim layers
selected_vars <- c("bio_3", "bio_4", "bio_6", "bio_8", "bio_13", "bio_15")
bioclim_subset <- bioclim_full[[selected_vars]]
names(bioclim_subset)
# -------------------------------
# Load aggregated land use rasters
# -------------------------------
urban  <- rast(urban_path)
forest <- rast(forest_path)
agri   <- rast(agri_path)

# -------------------------------
# Resample LULC rasters to match bioclim
# -------------------------------
urban_rs  <- resample(urban, bioclim_subset, method = "bilinear")
forest_rs <- resample(forest, bioclim_subset, method = "bilinear")
agri_rs   <- resample(agri, bioclim_subset, method = "bilinear")

names(urban_rs)  <- "prop_urban"
names(forest_rs) <- "prop_forest"
names(agri_rs)   <- "prop_agriculture"

# -------------------------------
# Combine all layers into final stack
# -------------------------------
predictor_stack <- c(bioclim_subset, urban_rs, forest_rs, agri_rs)

# -------------------------------
# Save the stack
# -------------------------------
writeRaster(predictor_stack, filename = output_path, overwrite = TRUE)

cat("Updated predictor stack saved to:\n", output_path, "\n")
