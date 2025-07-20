# ================================================
# export_maxent_gui_layers.R
# ================================================

library(terra)

# -------------------------------
# Input raster stack
# -------------------------------
r <- rast("data/rasters/training_stack/updated/predictor_stack_training_updated.tif")

# -------------------------------
# Output directory
# -------------------------------
out_dir <- "data/maxent_gui/environmental"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# -------------------------------
# Function to export a single layer
# -------------------------------
write_float_asc <- function(r_layer, name) {
  # Replace NA with -9999
  values(r_layer)[is.na(values(r_layer))] <- -9999
  NAflag(r_layer) <- -9999
  
  # Write as 32-bit float ASCII raster
  writeRaster(
    r_layer,
    filename = file.path(out_dir, paste0(name, ".asc")),
    filetype = "AAIGrid",
    datatype = "FLT4S",
    NAflag = -9999,
    overwrite = TRUE
  )
}

# -------------------------------
# Export all 9 layers individually
# -------------------------------
layer_names <- names(r)

for (i in seq_along(layer_names)) {
  write_float_asc(r[[i]], layer_names[i])
}

cat("All layers exported to:", out_dir, "\n")
