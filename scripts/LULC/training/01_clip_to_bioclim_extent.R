# ================================
# clip_clc_to_training.R
# ================================

library(terra)

# ------------------------
# Step 1: Inspect working directory
# ------------------------
cat("Working directory:\n")
print(getwd())
cat("\nFiles and folders:\n")
print(list.files())

# ------------------------
# Step 2: Define input/output paths
# ------------------------
clc_path <- "data/rasters/raw/land_use/U2018_CLC2018_V2020_20u1.tif"  # Raw CORINE raster
mask_path <- "data/rasters/raw/bioclim_cropped_filtered/bioclim_masked_extended_europe.tif"  # Bioclim raster as mask
output_path <- "data/rasters/raw/land_use/clc_training_clipped.tif"

# ------------------------
# Step 3: Load rasters
# ------------------------
clc <- rast(clc_path)
mask <- rast(mask_path)

# ------------------------
# Step 4: Reproject CLC to match CRS of mask (if needed)
if (!compareGeom(clc, mask, stopOnError = FALSE)) {
  cat("Reprojecting CLC to match mask CRS...\n")
  clc <- project(clc, mask, method = "near")
}

# ------------------------
# Step 5: Align grid and extent using resample
cat("Resampling CLC to match grid and resolution of mask...\n")
clc_aligned <- resample(clc, mask, method = "near")

# ------------------------
# Step 6: Apply spatial mask
cat("Applying mask...\n")
clc_masked <- mask(clc_aligned, mask)

# ------------------------
# Step 7: Reproject to WGS84 (EPSG:4326)
cat("Reprojecting to WGS84 (EPSG:4326)...\n")
clc_wgs84 <- project(clc_masked, "EPSG:4326", method = "near")

# ------------------------
# Step 8: Save output raster
writeRaster(clc_wgs84, output_path, overwrite = TRUE)
cat("✅ CLC clipped, aligned, and reprojected to WGS84:\n", output_path, "\n")
