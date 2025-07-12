
# 0_setup.R
# Project Setup: Load Packages and Define Paths

# ---- Load required packages (install if missing) ----
required_packages <- c(
  "broom",
  "corrplot",
  "e1071",
  "ggplot2",
  "httr",
  "RCurl",
  "RColorBrewer",
  "tidyverse"
)

for (pkg in required_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
  }
  library(pkg, character.only = TRUE)
}

# Optional: install mapping package if not already present
if (!requireNamespace("urbnmapr", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
  devtools::install_github("UrbanInstitute/urbnmapr")
}
library(urbnmapr)

# ---- Define consistent project paths ----
project_dir <- "~/"
data_dir    <- file.path(project_dir, "data/raw")
output_dir  <- file.path(project_dir, "data/processed")
plots_dir   <- file.path(project_dir, "plots")
maps_dir    <- file.path(project_dir, "maps")

# Create directories if they don't exist
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(plots_dir,  recursive = TRUE, showWarnings = FALSE)
dir.create(maps_dir,   recursive = TRUE, showWarnings = FALSE)

setwd(project_dir)
