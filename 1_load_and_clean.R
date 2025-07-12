# 1_load_and_clean.R
# Load and Filter Original Dataset for Illinois

# If running 0_setup.R beforehand is not preferred
source("0_setup.R")

master_data_path <- file.path(data_dir, "Wu All Code - All States - Most Variables.csv")

# Load dataset
raw_data <- read.csv(master_data_path, stringsAsFactors = FALSE)

# Filter for Illinois only
data_il <- raw_data %>%
  filter(Province_State == "Illinois" & !is.na(Province_State))

# Save subset
write_csv(data_il, file.path(output_dir, "illinois_only.csv"))

message("✅ Saved Illinois subset to: ", output_dir)
