# ================================
# build_training_stack.R
# ================================

library(terra)

# ------------------------
# Define paths
# ------------------------
bioclim_path <- "data/rasters/raw/bioclim_cropped_filtered/bioclim_masked_extended_europe.tif"
urban_path   <- "data/rasters/aggregation_LULC/training_region/urban_agg_10km.tif"
forest_path  <- "data/rasters/aggregation_LULC/training_region/forest_agg_10km.tif"
agri_path    <- "data/rasters/aggregation_LULC/training_region/agriculture_agg_10km.tif"

output_path  <- "data/rasters/training_stack/predictor_stack_training.tif"

# ------------------------
# Load 5-layer bioclim stack and rename
# ------------------------
bioclim <- rast(bioclim_path)

#check bioclim raster stack

names(bioclim)

# Check number of layers is 5 before renaming
if (nlyr(bioclim) != 5) {
  stop("Bioclim raster stack must have exactly 5 layers.")
}

names(bioclim) <- c("bio_3", "bio_4", "bio_6", "bio_13", "bio_15")

# ------------------------
# Load LULC aggregated rasters
# ------------------------
urban  <- rast(urban_path)
forest <- rast(forest_path)
agri   <- rast(agri_path)

# ------------------------
# Resample LULC rasters to match bioclim grid
# ------------------------
urban_rs  <- resample(urban, bioclim, method = "bilinear")
forest_rs <- resample(forest, bioclim, method = "bilinear")
agri_rs   <- resample(agri, bioclim, method = "bilinear")

# Rename for clarity
names(urban_rs)  <- "prop_urban"
names(forest_rs) <- "prop_forest"
names(agri_rs)   <- "prop_agriculture"

# ------------------------
# Combine into final stack
# ------------------------
predictor_stack <- c(bioclim, urban_rs, forest_rs, agri_rs)

# ------------------------
# Save the stack
# ------------------------
writeRaster(predictor_stack, filename = output_path, overwrite = TRUE)

cat("Predictor stack saved to:", output_path, "\n")
