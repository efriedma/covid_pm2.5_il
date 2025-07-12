
# 5_mapping.R
# Data pre-processing pipeline based on wxwx1993/PM_COVID

library(dplyr)
library(scales)
library(grid)

date_of_study = "08-06-2020" 

# Historical data 
covid_hist = read.csv(text=getURL("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/03-30-2020.csv"))
covid_hist_il = subset(covid_hist, Province_State == "Illinois" & is.na(Province_State) == F)

# Import outcome data from Johns Hopkins CSSE (Center for Systems Science and Engineering)
covid = read.csv(text=getURL(paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",date_of_study,".csv")))
covid_il = subset(covid, Province_State == "Illinois" & is.na(Province_State) == F)
covid_il = rbind(covid_il,subset(covid_hist_il, (!(Province_State %in% covid_il$Province_State))  & Confirmed == 0 & Deaths == 0 & is.na(FIPS)==F))
covid_il$Province_State = str_pad(covid_il$Province_State, 5, pad = "0")

covid_il = subset(covid_il, FIPS >= 17000 & FIPS <= 17999)

# Load long-term PM2.5 exposure data
county_pm = read.csv(text=getURL("https://raw.githubusercontent.com/wxwx1993/PM_COVID/master/Data/county_pm25.csv"))
county_pm_il = subset(county_pm, fips >= 17000 & fips <= 17999)

# Compute 17-year average PM2.5 concentration
county_pm_avg_il = county_pm_il %>%
  group_by(fips) %>% 
  summarise(mean_pm25 = mean(pm25))

# Mapping
county_pm_avg_il <- county_pm_avg_il %>% rename("county_fips" = fips)

attach(counties)
counties <- transform(counties, county_fips = as.numeric(county_fips))
sapply(counties, mode)

il_counties <- subset(counties, county_fips >= 17000 & county_fips <= 17999) # created for left joining...

# Long-Term PM_2.5 Exposure
pm25_map <- county_pm_avg_il %>%
  left_join(il_counties, by = "county_fips") %>%
  filter(state_name == "Illinois") %>%
  ggplot(aes(long, lat, group = group, fill = mean_pm25)) +
  geom_polygon(color = "white", size = 0.25) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(
    low    = "#FF0000",
    high   = "#330000",
    labels = number_format(accuracy = 0.01),
    guide  = guide_colorbar(title.position = "top")
  ) +
  labs(
    fill = "Long-term PM 2.5\nexposure",
    x    = "long",
    y    = "lat"
  ) +
  theme_gray() +
  theme(
    legend.key.width = unit(0.5, "in")
  )
pm25_map

# Save PM2.5 map at 600 dpi, 10×8 inches
ggsave(
  filename = file.path(maps_dir, "pm25_map.png"),
  plot     = pm25_map,
  width    = 10,
  height   = 8,
  units    = "in",
  dpi      = 600
)

county_covid_il <- covid_il%>% rename("county_fips" = FIPS)

covid_pct_map <- county_covid_il %>%
  left_join(il_counties, by = "county_fips") %>%
  filter(state_name == "Illinois") %>%
  mutate(Pct_Cases = Incidence_Rate / 100000) %>%
  ggplot(aes(long, lat, group = group, fill = Pct_Cases)) +
  geom_polygon(color = "white", size = 0.25) +
  coord_map("albers", lat0 = 39, lat1 = 45) +
  scale_fill_gradient(
    low    = "#D9E6F2",    # light slate
    high   = "#08306B",    # deep navy
    labels = scales::percent_format(accuracy = 0.01),
    guide  = guide_colorbar(title.position = "top")
  ) +
  labs(fill = "Confirmed cases \nas % of county population", x = "long", y = "lat") +
  theme_gray() +
  theme(
    panel.grid.minor   = element_blank(),
    legend.position    = "right",
    legend.key.width   = unit(0.5, "in")
  )
covid_pct_map

# Save COVID map at 600 dpi, 10×8 inches
ggsave(
  filename = file.path(maps_dir, "covid_pct_map.png"),
  plot     = covid_pct_map,
  width    = 10,
  height   = 8,
  units    = "in",
  dpi      = 600
)


