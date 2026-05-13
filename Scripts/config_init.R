# Config init: Clear environment, set working directory, and configure paths
cat("  -> Init (clearing environment, setting paths)\n")

rm(list = ls())

# Set working directory to project root
# Update this path when setting up a new project
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# === OUTPUT PATHS ===
OUTPUT_ROOT <- file.path(getwd(), "LaTeX", "Output")

# === SYNC DESTINATIONS ===
# Destinations to replicate Output structure (e.g. Overleaf). Add or remove paths.
SYNC_DESTINATIONS <- c(
  # path.expand("~/Overleaf/your-project/Output")
)

# Reset package namespaces (prevents cached modifications from prior runs)
if ("package:knitr" %in% search()) detach("package:knitr", unload = TRUE)
if ("package:kableExtra" %in% search()) detach("package:kableExtra", unload = TRUE)
