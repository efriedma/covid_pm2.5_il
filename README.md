
# COVID-19 and PM₂.₅ Analysis in Illinois

Data pre-processing is based on the work of [wxwx1993/PM_COVID](https://github.com/wxwx1993/PM_COVID).

---

## 📁 Repository Structure

```
covid_pm2.5_il_analysis/  
├─ data/  
│  ├─ raw/           ← original downloaded CSVs  
│  └─ processed/     ← cleaned and feature-engineered outputs  
├─ plots/            ← ggplot2 charts (.png, .pdf)  
├─ maps/             ← choropleth maps (.png)  
├─ output/           ← tables, logs, model outputs  
└─ covid_pm2.5_il.Rproj  
```

---

## 🛠️ Prerequisites

- **R** (≥ 4.0)  
- Packages (will auto-install in `0_setup.R`):
  `broom`, `corrplot`, `e1071`, `ggplot2`, `httr`, `RCurl`, `RColorBrewer`, `tidyverse`, `urbnmapr`

---

## 🚀 Usage

1. **Clone** this repo:  
   ```bash
   git clone github.com/efriedma/covid_pm2.5_il
   cd covid_pm2.5_il
   ```
2. **Adjust** the path definitions in `scripts/0_setup.R` if needed.  
3. **Run** each script in order (from the project root):
   ```r
   source("covid_pm2.5_il/0_setup.R")          # install & load packages, set paths
   source("covid_pm2.5_il/1_load_and_clean.R") # import & clean raw data
   source("covid_pm2.5_il/2_transform.R")      # feature engineering
   source("covid_pm2.5_il/3_scale_and_model.R")# regression & scatter plot
   source("covid_pm2.5_il/4_visualizations.R") # correlation analysis
   source("covid_pm2.5_il/5_mapping.R")        # county-level maps
   ```
4. **Inspect** your outputs under `data/processed`, `plots/`, `maps/`, and `output/`.

---

## 🔗 Acknowledgments

- Adapted data pipeline from [wxwx1993/PM_COVID](https://github.com/wxwx1993/PM_COVID)  
- Johns Hopkins CSSE COVID-19 data  
- **urbnmapr** for Illinois county shapefiles  
