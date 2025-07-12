
# 2_transform.R
# Feature Engineering and Variable Selection

# If running 0_setup.R beforehand is not preferred
source("0_setup.R")

data_il <- read_csv(file.path(output_dir, "illinois_only.csv"))

# Compute % confirmed cases
data_il <- data_il %>%
  mutate(Pct_Pop_Confirmed = Confirmed / population)

# Columns to keep
selected_vars <- c(
  "fips.x", "Combined_Key", "Lat", "Long_", "population", "popdensity", "q_popdensity",
  "mean_pm25", "Confirmed", "Pct_Pop_Confirmed", "Deaths", "Recovered", "Active",
  "Incidence_Rate", "Case.Fatality_Ratio", "Last_Update", "education",
  "medianhousevalue", "pct_owner_occ", "medhouseholdincome", "poverty", "pct_asian",
  "pct_blk", "hispanic", "pct_native", "pct_white", "older_pecent", "mean_bmi",
  "smoke_rate", "totalTestResults_county", "beds", "mean_winter_temp",
  "mean_summer_temp", "mean_winter_rm", "mean_summer_rm"
)

# ---- Cleaning selected variables ----
aggregate_data <- data_il %>%
  select(any_of(selected_vars)) %>%
  rename_with(~ str_replace_all(., "\\s+", "_")) %>%
  rename_with(~ str_replace_all(., "\\.", "_"))

# Save aggregate data
write_csv(aggregate_data, file.path(output_dir, "aggregate_data.csv"))

message("✅ Transformed and saved filtered data")
