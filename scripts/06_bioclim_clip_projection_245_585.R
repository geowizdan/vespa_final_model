# ===============================================
# clip_check_bioclim_multiband_scenarios_to_UK.R
# ===============================================

library(terra)

# -------------------------------
# Define paths
# -------------------------------

rcp245_path <- "C:/Users/Dan Buchanan/OneDrive - University of Bristol/VespaData/data/environmental/worldclim_future/rcp45_2041-2060/wc2.1_30s_bioc_UKESM1-0-LL_ssp245_2041-2060.tif"
rast(rcp245_path)
file.exists(rcp245_path)
rcp585_path <- "C:/Users/Dan Buchanan/OneDrive - University of Bristol/VespaData/data/environmental/worldclim_future/rcp85_2041-2060/wc2.1_30s_bioc_UKESM1-0-LL_ssp585_2041-2060.tif"
rast(rcp585_path)
target_mask_path <- "data/rasters/target_raster_shape/predictor_stack_rcp245_lu1.tif"

# -------------------------------
# Load UK target raster
# -------------------------------
target_mask <- rast(target_mask_path)
class(target_mask)
# -------------------------------
# Desired bio variables and band indices
# -------------------------------

target_bios <- c(3, 4, 6, 8, 13, 15)
short_names <- paste0("bio_", target_bios)

# -------------------------------
# Function to load and process multiband climate file
# -------------------------------
process_multiband_bioclim <- function(input_raster, output_path, label) {
  cat("📦 Processing:", label, "\n")
  
  # Load full 19-band raster
  bioclim_full <- rast(input_raster)
  cat("ℹ️  Number of bands loaded:", nlyr(bioclim_full), "\n")
  
  # Subset by index
  bioclim_subset <- bioclim_full[[target_bios]]
  names(bioclim_subset) <- short_names
  cat("✅ Subset to:\n")
  print(names(bioclim_subset))
  
  # Clip and mask
  bioclim_clipped <- mask(crop(bioclim_subset, target_mask), target_mask)
  
  # Final check
  cat("📋 Final layer names before saving:\n")
  print(names(bioclim_clipped))
  
  # Save
  writeRaster(bioclim_clipped, output_path, overwrite = TRUE)
  cat("💾 Saved clipped raster to:", output_path, "\n\n")
}

# -------------------------------
# Process both scenarios
# -------------------------------
# -------------------------------
# Step 3: Run for RCP 4.5 and 8.5
# -------------------------------
process_multiband_bioclim(rcp245_path, "data/rasters/bioclim/projected_region/bioclim_ssp245_uk_clipped.tif", "RCP 4.5")
process_multiband_bioclim(rcp585_path, "data/rasters/bioclim/projected_region/bioclim_ssp585_uk_clipped.tif", "RCP 8.5")

cat("🎯 Bioclim scenario clipping complete.\n")