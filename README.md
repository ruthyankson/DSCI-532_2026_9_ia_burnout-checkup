# DSCI-532_2026_9_ia_burnout-checkup
A simplified Shiny for R reimplementation of a group analytics project exploring the relationship between AI usage, productivity, and employee burnout risk through interactive filtering and visualization.


## App Purpose
This Shiny for R application is a simplified re-implementation of my group project on AI usage, productivity, and burnout risk in the workplace.

The app allows users to filter employees by job role and explore:
- the relationship between AI tool usage hours and burnout risk score
- the distribution of burnout risk scores
- a table of filtered employee records

## Dashboard Design and Analytical Goals

This dashboard is designed to help explore relationships between AI tool usage, employee productivity, and burnout risk. The visualizations and summary outputs were selected to support quick exploratory insights relevant to workplace wellbeing and responsible AI adoption.

The application focuses on three analytical goals:

1. Examine the relationship between AI usage and burnout risk

The scatter plot visualizes how weekly AI tool usage hours relate to burnout risk scores. This helps identify whether higher AI usage is associated with increased or reduced burnout risk among employees.

2. Understand the distribution of burnout risk

The histogram of burnout risk scores shows how burnout is distributed across employees within the selected job role. This helps identify concentration patterns, such as clusters of high burnout or potential ceiling effects in the measurement scale.

3. Provide detailed inspection of filtered records

The table of filtered employees allows users to inspect individual observations corresponding to the selected filters. This supports transparency and enables closer examination of the data underlying the visual summaries.

Together, these components provide both high-level visual patterns and record-level detail, supporting exploratory analysis of how AI usage may relate to employee wellbeing and productivity.

Observed patterns in the histogram may reveal a ceiling effect in burnout scores, where many employees reach the upper limit of the measurement scale.

## Files
- `app.R` — main Shiny application
- `data/ai_productivity_features.csv` — employee feature data
- `data/ai_productivity_targets.csv` — productivity and burnout target data
- `notebooks/burnout_eda.Rmd/` — exploratory data analysis materials used to inspect variable distributions, data quality, and relationships relevant to the dashboard
- `renv.lock` — project dependency lockfile for reproducible package restoration
- `manifest.json` — deployment metadata for Posit Connect Cloud
- `LICENSE` — MIT License for this repository

## Packages Required
Install the required R packages with:

```r
install.packages(c("shiny", "readr", "dplyr", "ggplot2"))
```

## Environment Management

This project uses renv to manage package dependencies. To restore the environment:

```r
install.packages("renv")
renv::restore()
```

## Run the App Locally

Open `app.R` in Positron or RStudio and run:

```r
shiny::runApp()
```

## Deployment

This app is deployed on Posit Connect Cloud.

## License

This project is licensed under the MIT License.

See the [LICENSE](https://github.com/ruthyankson/DSCI-532_2026_9_ia_burnout-checkup/blob/main/LICENSE) file for details.