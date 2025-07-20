# ================================
# stack_bioclim_extended_training.R
# ================================

library(terra)

# -------------------------------
# Define input paths
# -------------------------------
ref_mask_path <- "data/rasters/raw/bioclim_cropped_filtered/bioclim_masked_extended_europe.tif"
bioclim_dir   <- "data/rasters/raw/worldclim_baseline/wc2.1_30s_bio"

# -------------------------------
# Load mask/reference raster
# -------------------------------
ref_mask <- rast(ref_mask_path)

# -------------------------------
# Load all 19 .tif bioclim rasters
# -------------------------------
bioclim_files <- list.files(bioclim_dir, pattern = "\\.tif$", full.names = TRUE)

# Extract numerical order from filenames
bio_order <- as.numeric(gsub(".*bio_(\\d+)\\.tif$", "\\1", basename(bioclim_files)))

# Order file list numerically by bio number
bioclim_files_ordered <- bioclim_files[order(bio_order)]

# Load rasters in correct order
bioclim_stack_raw <- rast(bioclim_files_ordered)

#check names

names(bioclim_stack_raw)
# Rename layers
names(bioclim_stack_raw) <- paste0("bio_", sort(bio_order))


#check names

names(bioclim_stack_raw)
# Load as individual layers
bioclim_stack_raw <- rast(bioclim_files)

# -------------------------------
# Mask and crop to training region
# -------------------------------
bioclim_stack <- mask(crop(bioclim_stack_raw, ref_mask), ref_mask)


# -------------------------------
# Save for later use (optional)
# -------------------------------
writeRaster(bioclim_stack, "data/rasters/bioclim/training/bioclim_19stack_extended_training.tif", overwrite = TRUE)

cat("Bioclim 19-layer stack created and saved.\n")
