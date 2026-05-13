# JEBO Graph Style Guidelines

All figures must be publication-ready for the Journal of Economic Behavior & Organization (JEBO) and must use the shared `common_theme` object defined in `Scripts/config_toolkit.R`.

---

## Core principles
- Clarity over decoration: figures should be interpretable in isolation.
- Minimal but structured: no chartjunk, no visual noise.
- Black-and-white robust: readable when printed in greyscale.
- Economics conventions: show means with uncertainty and explicit treatment contrasts.

## Visual design
- Always apply `common_theme` (defined in `Scripts/config_toolkit.R`):
    - `theme_minimal()` with visible axes re-added.
    - Light major gridlines only (`grey95`), no minor gridlines.
    - Axis lines and ticks visible but subtle (`grey30`).
    - Base font size >= 14 for print readability.
- No ad-hoc styling overrides.

## Titles and labels
- Do not include plot titles (titles are added as captions in LaTeX).
- No x-axis title unless axis labels are numeric or otherwise ambiguous.
- Axis titles: explicit economic quantity with units (e.g. "Punishment (EUR)").
- Avoid redundancy (do not repeat "Mean" in both title and axis).

## Data presentation
- Plot means with +/- 1 SE (controlled by `se_plot` in `Scripts/config_toolkit.R`).
- Use points with error bars for cross-sectional comparisons.
- Use lines only for time trends or ordered rounds.

## Legends
- Bottom-centred, horizontal layout (set by `common_theme`).
- No legend title.
- Treatment labels must match paper terminology exactly.

## Colour
- Use colours from `palette_lots` (defined in `Scripts/config_toolkit.R`).
- Restrained, high-contrast, colorblind-safe (Paul Tol bright scheme).
- Must remain interpretable in greyscale.
- Colour should encode treatment only.

## Export
- Use `save_graph(plot, filename)` from `Scripts/config_toolkit.R`.
- Default: 300 DPI, PNG format, 10x6 inches.
- Captions and notes are added in LaTeX, not in the .png file.
- Figures must be exportable at journal resolution without manual edits.

**Rule of thumb:** if a referee can understand the result without reading the main text, the figure is JEBO-ready.
