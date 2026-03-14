library(shiny)
library(readr)
library(dplyr)
library(ggplot2)

# Load data
features <- read_csv("ai_productivity_features.csv", show_col_types = FALSE)
targets <- read_csv("ai_productivity_targets.csv", show_col_types = FALSE)

# Join datasets
df <- left_join(features, targets, by = "Employee_ID")
