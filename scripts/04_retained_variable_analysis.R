# ================================
# collinearity_filter_bioclim.R
# ================================

library(terra)
library(tidyverse)
library(caret)
library(viridis)

# -------------------------------
# Step 1: Load 19-layer raster
# -------------------------------
bioclim_stack <- rast("data/rasters/bioclim/training/bioclim_19stack_extended_training.tif")

# -------------------------------
# Step 2: Convert to dataframe (no coords)
# -------------------------------
set.seed(123)
sample_df <- as.data.frame(bioclim_stack, xy = FALSE, na.rm = TRUE)

# Confirm all columns are numeric
stopifnot(all(sapply(sample_df, is.numeric)))

# -------------------------------
# Step 3: Compute correlation matrix
# -------------------------------
cor_matrix <- cor(sample_df, use = "complete.obs", method = "pearson")

# -------------------------------
# Step 4: Plot correlation heatmap
# -------------------------------
png("figures/bioclim_collinearity_correlation_plot.png", width = 1600, height = 1400, res = 250)
heatmap(cor_matrix, symm = TRUE, col = viridis(100), main = "Pearson Correlation Matrix: 19 Bioclim Variables")
dev.off()

cat("Correlation matrix plot saved to figures/bioclim_collinearity_correlation_plot.png\n")

# -------------------------------
# Step 5: Identify highly correlated variables
# -------------------------------
high_cor_vars <- findCorrelation(cor_matrix, cutoff = 0.7, names = TRUE)

# Retain the others
retained_vars <- setdiff(colnames(sample_df), high_cor_vars)

# -------------------------------
# Step 6: Save retained variable names
# -------------------------------
write_lines(retained_vars, "data/selected_bioclim_variables.txt")

cat("Variables retained after filtering (r ≤ 0.70):\n")
print(retained_vars)

cat("Saved to: data/selected_bioclim_variables.txt\n")
