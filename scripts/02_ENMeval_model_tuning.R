# ===============================
# Step 0: Load required libraries
# ===============================
library(terra)
library(tidyr)
library(ENMeval)
library(readr)
library(dplyr)

# ===============================
# Step 1: Load environmental predictors (5 bioclim + 3 LULC)
# ===============================
envs <- rast("data/rasters/training_stack/predictor_stack_training.tif")

# Optional: confirm predictor names
print(names(envs))  # Should be: bio_3, bio_4, ..., prop_agriculture

# ===============================
# Step 2: Load cleaned occurrence data
# ===============================
occs <- read_csv("data/table_inputs/vespa_occ_combined_10km.csv") %>%
  select(longitude, latitude) %>%
  rename(x = longitude, y = latitude) %>%
  drop_na()

# ===============================
# Step 3: Run ENMeval model tuning
# ===============================
set.seed(123)

eval <- ENMevaluate(
  occs = occs,
  envs = envs,
  algorithm = "maxnet",
  partitions = "block",
  tune.args = list(
    fc = c("L", "LQ", "LQH"),
    rm = seq(0.5, 2, 0.5)
  ),
  raster.preds = FALSE,
  n.bg = 10000,
  parallel = TRUE,
  numCores = 2
)

# ===============================
# Step 4: Review and save results
# ===============================
results_table <- eval@results
write_csv(results_table, "data/enmeval_models/enmeval_model_comparison_extended.csv")

# Identify best model by AICc
bestmod_index <- which.min(results_table$AICc)
best_model <- eval@models[[bestmod_index]]

# Save best model for downstream projection
saveRDS(best_model, "data/enmeval_models/best_maxent_model_extended.rds")

# Console summary
cat("✅ ENMeval complete. Best model index:", bestmod_index, "\n")
print(results_table[bestmod_index, ])
