# Config toolkit: packages, themes, colour palette, save functions, helpers
cat("  -> Toolkit (packages, theme, save functions)\n")

# --- PACKAGES ---------------------------------------------------------------

# Helper: install if missing
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg)
}

# Core
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

# Plotting
library(cowplot)
library(patchwork)
install_if_missing("showtext")
library(showtext)

# Statistical tests
library(coin)
install_if_missing("fixest")
library(fixest)
install_if_missing("lmtest")
library(lmtest)
install_if_missing("sandwich")
library(sandwich)

# Tables
library(stargazer)
library(knitr)
library(kableExtra)
library(xtable)

# --- COLOUR PALETTE ----------------------------------------------------------
palette_lots <- c(
  "#4477AA",  # Dark blue
  "#EE6677",  # Pink-red
  "#228833",  # Dark green
  "#AA3377",  # Purple
  "#66CCEE",  # Cyan
  "#D55E00",  # Orange-red
  "#004488"   # Very dark blue
)

# Paper-wide two-colour treatment scheme. Any binary treatment contrast uses
# these two colours, in this order (first/left group = A, second/right = B),
# whatever the dimension. Single-colour fills are reserved for non-treatment
# x-axes (scenario categories, histograms). See Context/Flow/Tools/skill_graphs.md.
col_treat_a <- palette_lots[1]  # Dark blue
col_treat_b <- palette_lots[2]  # Pink-red

# Usage: scale_fill_manual(values = treatment_colours(levels(data$treatment)))
treatment_colours <- function(levels) {
  setNames(palette_lots[seq_along(levels)], levels)
}

# --- GGPLOT THEME ------------------------------------------------------------
common_theme <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold",
                              family = "", margin = margin(b = 10)),
    axis.title = element_text(size = 14),
    axis.text  = element_text(size = 14, colour = "black"),
    panel.grid.major   = element_line(colour = "grey95", linewidth = 0.3),
    panel.grid.minor   = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.line  = element_line(colour = "grey30", linewidth = 0.6),
    axis.ticks = element_line(colour = "grey30", linewidth = 0.6),
    legend.position  = "bottom",
    legend.direction = "horizontal",
    legend.box       = "horizontal",
    legend.margin    = margin(t = 5),
    legend.text      = element_text(size = 14),
    legend.title     = element_blank(),
    strip.text       = element_text(size = 14, face = "bold"),
    strip.background = element_blank()
  )

# --- SAVE FUNCTIONS ----------------------------------------------------------
# Each function writes to ALL paths in output_paths (local + sync destinations).
output_paths <- c(OUTPUT_ROOT, SYNC_DESTINATIONS)

save_graph <- function(plot, filename, width = 10, height = 6, dpi = 300) {
  for (path in output_paths) {
    dir.create(file.path(path, "Figures"), recursive = TRUE, showWarnings = FALSE)
    ggsave(file.path(path, "Figures", paste0(filename, ".png")),
           plot = plot, width = width, height = height, dpi = dpi)
  }
}

save_table <- function(content, filename) {
  for (path in output_paths) {
    dir.create(file.path(path, "Tables"), recursive = TRUE, showWarnings = FALSE)
    writeLines(content, file.path(path, "Tables", paste0(filename, ".tex")))
  }
}

save_text <- function(text, filename) {
  for (path in output_paths) {
    dir.create(file.path(path, "Text"), recursive = TRUE, showWarnings = FALSE)
    writeLines(text, file.path(path, "Text", paste0(filename, ".txt")))
  }
}

# --- CHECKPOINT --------------------------------------------------------------
checkpoint_path <- file.path(getwd(), "Data", "checkpoint_prepared.RData")

save_checkpoint <- function(envir = parent.frame()) {
  save(list = ls(envir = envir), file = checkpoint_path, envir = envir)
  cat(sprintf("  -> Checkpoint saved: %s\n", checkpoint_path))
}

load_checkpoint <- function(envir = parent.frame()) {
  if (!file.exists(checkpoint_path)) {
    stop("No checkpoint found. Run the full pipeline (main.R) first.")
  }
  load(checkpoint_path, envir = envir)
  cat(sprintf("  -> Checkpoint loaded: %s\n", checkpoint_path))
}

# --- HELPERS -----------------------------------------------------------------
p_to_stars <- function(p) {
  ifelse(p < 0.001, "***", ifelse(p < 0.01, "**", ifelse(p < 0.05, "*", ifelse(p < 0.1, "+", ""))))
}

# --- NUMBER FORMATTING -------------------------------------------------------
# Single source of truth for reported numbers. Every table, note, and quoted
# scalar goes through these — fix formatting here or in the generating script,
# never by hand-editing a .tex file.

# P-values for table cells: 3 decimals, no leading zero, floored at .001.
# Never ".000" — anything below .001 becomes "<.001".
fmt_p <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.001, "<.001", sub("^0", "", sprintf("%.3f", p))))
}

# P-values for prose and notes: "p=.034" / "p<.001".
fmt_p_prose <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.001, "p<.001", paste0("p=", fmt_p(p))))
}

# Estimates (coefficients, means, differences, SEs): 3 decimals. Values below
# 0.0005 print as 0.000 — plain rounding, never "<0.001".
fmt_est <- function(x, digits = 3) {
  x <- ifelse(abs(x) < 0.5 * 10^(-digits), 0, x)  # kill "-0.000"
  ifelse(is.na(x), "", sprintf(paste0("%.", digits, "f"), x))
}

# --- GLOBAL OPTIONS ----------------------------------------------------------
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)
se_plot <- 1.0
options(warn = -1)
