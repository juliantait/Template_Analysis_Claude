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
- The LaTeX caption must be **usefully descriptive**: what is plotted, for which sample or experiment. Not "Treatment effects".
- Treatment labels in legends and axes refer to the same treatments as the paper and are spelled identically across all figures. Casing is free inside the figure — normal case ("Low stakes", "High stakes") is fine here, even though running text always uses ALL CAPS (LOW, HIGH).

## Notes (written in LaTeX, below the float)
- As compact as possible while self-explanatory to a reader who has only read the abstract. Cover, where not already obvious: unit of observation; sample and any conditioning; treatment abbreviations spelled out; what the error bars show; test type and sidedness; units.
- State only what the reader cannot infer. Do not restate what the axis label already carries (currency when the axis reads "Punishment (\euro)") or what the facing page defines.
- **State the fact and stop** — say what was measured or which conditions were shown; the reader draws the consequence unaided. Spell a consequence out only where genuinely counter-intuitive.
- Note length scales with the figure's **isolation, not its importance**: a figure in running text leans on the adjacent prose and stays terse; one parked in a figures-only appendix earns a fuller note.
- Any p-value in a note follows the paper's formatting convention (three decimals, `p<.001` floor).

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

### Two-colour treatment scheme (paper-wide)
- A binary treatment contrast always uses the **same two colours across the whole paper**, whatever the dimension: first/left group `palette_lots[1]` (blue), second/right group `palette_lots[2]` (pink-red). Use the `col_treat_a` / `col_treat_b` constants in `Scripts/config_toolkit.R`.
- The mapping is by position in the contrast, not by treatment name — so two different binary dimensions (e.g. stakes and matching) reuse the same pair and the reader learns one visual code.
- Fix the factor level order once in cleaning so the colour assignment cannot drift between scripts.
- **Single-colour fills are reserved for non-treatment x-axes** (scenario categories, belief histograms, pooled distributions). Never colour a non-treatment axis with the treatment pair.
- More than two arms: extend along `palette_lots` in order, keeping positions stable across figures.

## Export
- Use `save_graph(plot, filename)` from `Scripts/config_toolkit.R`.
- Default: 300 DPI, PNG format, 10x6 inches.
- Captions and notes are added in LaTeX, not in the .png file.
- Figures must be exportable at journal resolution without manual edits.

**Rule of thumb:** if a referee can understand the result without reading the main text, the figure is JEBO-ready.
