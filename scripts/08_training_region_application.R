# ================================================
# predict_training_region_suitability.R
# ================================================

library(terra)
library(maxnet)

# -------------------------------
# Define input paths
# -------------------------------
predictor_stack_path <- "data/rasters/training_stack/updated/predictor_stack_training_updated.tif"
model_path <- "data/enmeval_models/best_maxent_model_extended.rds"
output_path <- "data/rasters/predictions/training_region_habitat_suitability.tif"

# -------------------------------
# Step 1: Load trained model
# -------------------------------
maxent_model <- readRDS(model_path)

# -------------------------------
# Step 2: Load predictor stack
# -------------------------------
predictor_stack <- rast(predictor_stack_path)

# Confirm layer names
print(names(predictor_stack))

# -------------------------------
# Step 3: Predict habitat suitability (cloglog)
# -------------------------------
suitability <- predict(predictor_stack, maxent_model, type = "cloglog", na.rm = TRUE)

# -------------------------------
# Step 4: Save output raster
# -------------------------------
writeRaster(suitability, output_path, overwrite = TRUE)

cat("Habitat suitability prediction complete.\nSaved to:", output_path, "\n")
