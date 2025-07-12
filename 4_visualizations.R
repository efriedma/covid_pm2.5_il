# 4_visualizations.R
# Safe correlation plot with per-column reason logging using aggregate_data

# If running 0_setup.R beforehand is not preferred
source("0_setup.R")

# Load data if needed
# aggregate_data <- read_csv(file.path(output_dir, "aggregate_data.csv"))

# -----------------------------------
# Step 1: Identify dropped columns with reasons
# -----------------------------------

# Compute per-column stats
column_sd <- sapply(aggregate_data, sd, na.rm = TRUE)
column_na <- colSums(is.na(aggregate_data))

# Define threshold: “mostly NA” if only 0 or 1 non-missing values remain
na_threshold <- nrow(aggregate_data) - 1

# Reason 1: Constant (zero variance or all NA)
reason_constant <- names(column_sd[is.na(column_sd) | column_sd == 0])

# Reason 2: Mostly NA (>= na_threshold missing)
reason_mostly_na <- names(column_na[column_na >= na_threshold])

# Build drop‐log
drop_log <- tibble(
  column = union(reason_constant, reason_mostly_na),
  reason = case_when(
    column %in% reason_constant & column %in% reason_mostly_na ~ "constant & mostly NA",
    column %in% reason_constant                              ~ "constant (zero variance)",
    column %in% reason_mostly_na                            ~ "mostly NA",
    TRUE                                                     ~ "unknown"
  )
)

# Write drop‐log to file
log_path <- file.path(output_dir, "dropped_columns_log.txt")
write_lines("Dropped Columns from Correlation Matrix:\n", log_path)
write_lines(format(drop_log, justify = "left"), log_path, append = TRUE)

message("🧹 ", nrow(drop_log), " columns dropped and logged: ", log_path)

# -----------------------------------
# Step 2: Prepare filtered dataset
# -----------------------------------

valid_data <- aggregate_data %>%
  # remove any columns flagged for dropping
  select(-any_of(drop_log$column)) %>%
  # drop rows with remaining NAs
  drop_na()

# -----------------------------------
# Step 3: Compute & plot correlation
# -----------------------------------

# Compute correlation matrix
cor_matrix <- cor(valid_data, use = "complete.obs")

# Verify the plot to be saved
corrplot(
  cor_matrix,
  method      = "color",
  col         = colorRampPalette(c("red", "white", "blue"))(200),
  type        = "upper",
  order       = "hclust",
  addCoef.col = "black",
  tl.col      = "black",
  tl.srt      = 45,
  number.cex  = 0.6,
  diag        = FALSE
)

pdf(
  file   = file.path(plots_dir, "correlation_plot.pdf"),
  width  = 10,
  height = 8
)
corrplot(
  cor_matrix,
  method      = "color",
  col         = colorRampPalette(c("red", "white", "blue"))(200),
  type        = "upper",
  order       = "hclust",
  addCoef.col = "black",
  tl.col      = "black",
  tl.srt      = 45,
  number.cex  = 0.8,
  diag        = FALSE
)

