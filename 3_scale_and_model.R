# 3_scale_and_model.R
# Linear Modeling on Predictors

# If running 0_setup.R beforehand is not preferred
source("0_setup.R")

# Fitting on raw Illinois only data
m1_raw <- lm(
  Pct_Pop_Confirmed ~ popdensity + q_popdensity + education +
    pct_owner_occ + medhouseholdincome + pct_asian + pct_white +
    older_pecent + mean_bmi + beds +
    mean_winter_temp + mean_summer_temp,
  data = data_il,
  na.action = na.exclude
)

summary(m1_raw)

resid_raw <- resid(m1_raw)         # length 102
keep      <- !is.na(resid_raw)     # logical, length 102

plot_df <- data_il[keep, ] %>%     # now keep is the right length
  mutate(
    Residual  = resid_raw[keep],
    FittedPct = predict(m1_raw)[keep]
  )

# Plotting residual vs PM2.5
model_scatter_plot <- ggplot(plot_df, aes(x = mean_pm25, y = Residual)) +
  geom_point(aes(color = factor(q_popdensity), size = popdensity)) + xlim(6, 12) + ylim(-0.01, 0.01) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(
    title    = "Model Residuals",
    subtitle = "Actual % Confirmed − Predicted % Confirmed",
    x        = "Long-Term Mean PM2.5 (µg/m³)",
    y        = "Residual (%-points)",
    size     = "Population Density",
    color    = "Pop-Density Quartile"
  ) +
  theme_bw()
model_scatter_plot

# Ensure plots directory exists
if (!dir.exists(plots_dir)) {
  dir.create(plots_dir, recursive = TRUE)
}

# Save the scatter plot to plots_dir
ggsave(
  filename = file.path(plots_dir, "residual_vs_pm25.png"),
  width    = 8,
  height   = 6,
  dpi      = 300
)

message("✅ Model scatter plot created and saved.")
