# Lessons — notation & reporting conventions (from coauthor/reviewer comments)

To be folded into the analysis template checks. One bullet per lesson; append as we go.

- P-values at 3 decimals everywhere (prose, footnotes, tables); floor at p<.001; always state the test name and whether one- or two-sided.
- Report statistics at the unit of the statistical test (matching group); never mix observation-level and group-level aggregation within one paragraph.
- Every scalar quoted in prose must be computed in the values scripts (OutputValues convention → simple_values.txt), never hand-derived.
- One symbol, one meaning — do not reuse r for both correlation and disclosure probability; always state Pearson vs Spearman for correlations.
- When notation changes (e.g. pi with y_00 superscript), grep all equations for stale variants, including function arguments (Delta U_i(r, y) vs y_00).
- Demographics balance goes in a footnote, not an appendix table.
- Write "approximately equal shares" unless the randomization is hard-balanced (e.g. Qualtrics evenly-present); verify against actual cell counts.
- Euro macro spacing (\euro 0.18 vs \euro0.18) must be consistent within a paragraph.
- Script-generated tables must apply the same p-value formatting conventions as prose (3 decimals, <0.001 floor); fix formatting in the generating script, not the tex.
- Correlations must state the type (Pearson/Spearman) and the unit of observation; use the independent unit (participant, not participant x block); never reuse a symbol already defined in the theory (r).
- All estimates reported to three decimals; coefficients with |value| below 0.0005 are displayed as 0.000 (plain rounding to zero, never inequality notation like <0.001 or >-0.001); p-values are never displayed as 0.000 — anything below .001 gets the p<.001 floor. Coefficients may round to zero, p-values may not.
- Figure and table titles must be usefully descriptive (what is plotted/estimated, for which experiment or sample), and notes as compact as possible while still self-explanatory to a reader who has only read the abstract: unit of observation, sample and any conditioning, treatment abbreviations spelled out (LOW/HIGH, PARTNERS/STRANGERS), what error bars show, test types (and one- vs two-sided), and units (euro, percentage points).
- Treatment groups get a consistent two-colour scheme paper-wide: left group palette_lots[1] blue, right group palette_lots[2] pink — LOW/HIGH stakes and STRANGERS/PARTNERS alike. Single-colour fills are reserved for non-treatment x-axes (disclosure scenarios, belief histograms).
- Notes state only what the reader cannot already infer: do not restate what the figure's own axis labels carry (currency when the axis reads "Punishment (\euro)") or what the surrounding section defines on the facing page (model symbols in the theory tables). Self-explanatory does not mean self-contained — brevity wins wherever the immediate context already answers the question.
- State the fact and stop; do not spell out its consequence. A note says what was measured or which scenarios were shown, and the reader draws the follow-up ("hence only two series in panel (a)", "so the legend applies throughout") unaided. A consequence earns its own clause only where it is genuinely counter-intuitive.
- Note length scales with the float's isolation, not its importance. A figure or table set in running text — the main text, or a prose appendix section such as the exploratory analyses — can lean on the adjacent paragraphs and should stay terse. One parked in a figures-only or tables-only appendix, reached from the text by nothing more than a bracketed "see Fig. X", has no adjacent prose to lean on and earns a correspondingly fuller note.
