# ================================================
# project_maxent_model_all_scenarios.R
# ================================================

library(terra)
library(maxnet)

# -------------------------------
# Define input model
# -------------------------------
model_path <- "data/enmeval_models/best_maxent_model_extended.rds"
maxent_model <- readRDS(model_path)

# -------------------------------
# Define scenarios and paths
# -------------------------------
scenarios <- list(
  "rcp245_lu1" = "data/rasters/projection_stack/245_LU1/predictor_stack_rcp245_lu1.tif",
  "rcp245_lu2" = "data/rasters/projection_stack/245_LU2/predictor_stack_rcp245_lu2.tif",
  "rcp585_lu1" = "data/rasters/projection_stack/585_LU1/predictor_stack_rcp585_lu1.tif",
  "rcp585_lu2" = "data/rasters/projection_stack/585_LU2/predictor_stack_rcp585_lu2.tif"
)

# Output directory
out_dir <- "data/rasters/predictions/projection_suitability/"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# -------------------------------
# Project for each scenario
# -------------------------------
for (scenario in names(scenarios)) {
  
  input_raster <- rast(scenarios[[scenario]])
  output_path <- file.path(out_dir, paste0("suitability_", scenario, ".tif"))
  
  cat("Projecting for:", scenario, "\n")
  suitability <- predict(input_raster, maxent_model, type = "cloglog", na.rm = TRUE)
  
  writeRaster(suitability, output_path, overwrite = TRUE)
  cat("Saved to:", output_path, "\n\n")
}
