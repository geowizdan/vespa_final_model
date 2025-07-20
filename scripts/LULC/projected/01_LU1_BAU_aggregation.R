# ================================================
# aggregate_lulc_LU1_projection.R
# ================================================

library(terra)

# -------------------------------
# Define input paths
# -------------------------------
input_dir  <- "data/rasters/derived/projected_binary_rasters_LULC/LU1-BAU"
output_dir <- "data/rasters/aggregation_LULC/projection_region/LU1-BAU"

# Create output directory if it doesn't exist
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# -------------------------------
# Define input raster filenames
# -------------------------------
input_files <- list(
  urban  = file.path(input_dir, "LU1_urban_binary_2050_updated.tif"),
  forest = file.path(input_dir, "LU1_forest_binary_2050_updated.tif"),
  agri   = file.path(input_dir, "LU1_agriculture_binary_2050_updated.tif")
)

# -------------------------------
# Define output filenames
# -------------------------------
output_files <- list(
  urban_agg  = file.path(output_dir, "LU1_urban_agg_10km.tif"),
  forest_agg = file.path(output_dir, "LU1_forest_agg_10km.tif"),
  agri_agg   = file.path(output_dir, "LU1_agriculture_agg_10km.tif")
)

# -------------------------------
# Aggregation parameters
# -------------------------------
agg_factor <- 10
agg_fun <- "mean"

# -------------------------------
# Load, aggregate, and save each raster
# -------------------------------
for (type in names(input_files)) {
  cat("Processing:", type, "\n")
  
  r <- rast(input_files[[type]])
  
  r_agg <- aggregate(r, fact = agg_factor, fun = agg_fun, na.rm = TRUE)
  
  writeRaster(r_agg, filename = output_files[[paste0(type, "_agg")]], overwrite = TRUE)
  
  cat("✅ Saved:", output_files[[paste0(type, "_agg")]], "\n\n")
}

cat("🎯 All LU1 LULC rasters aggregated to 10 km and saved.\n")
