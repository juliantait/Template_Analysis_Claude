# JEBO Table Style Guidelines

All tables must be publication-ready for the Journal of Economic Behavior & Organization (JEBO). Tables should be interpretable on their own, follow economics conventions, and prioritise clarity over compactness.

---

## Core principles
- Tables must be self-contained: a reader should understand design, contrasts, and tests without the main text.
- Structure matters more than density.
- Use booktabs-style rules only (no vertical lines).
- Consistent terminology with hypotheses and figures.
- Appendix tables should still meet main-text quality.

---

## General formatting rules
- Always use `\begin{table}...\end{table}` (not bare tabulars).
- Use `\centering`; font size typically `\scriptsize` or `\footnotesize`.
- Double midrules at top and bottom (`\midrule \midrule`) for regression tables.
- Avoid column numbers unless strictly necessary.
- Align coefficients and SEs vertically; SEs always in parentheses below estimates.
- British English spelling throughout.
- Round estimates/means to 2 decimal places; p-values and SEs to 3 decimal places.

---

## Regression tables (parametric)
- Group columns by **design** (e.g. Stakes vs Matching).
- Subdivide by **outcome** (e.g. Hiding, Punishment).
- Use panels with functional meaning:
  - Panel A: Treatment and interaction effects
  - Panel B: Controls
- Treatments appear before interactions.
- Interactions explicitly labelled (e.g. `High stakes x Report`).
- Controls grouped and ordered logically (e.g. Male, Age, Order dummy).
- Fixed effects and sample size reported at the bottom.
- Avoid redundant labels like "Dependent variable:" or "Model:".

---

## Descriptive and non-parametric tables
- Report: N, Mean(s), exact p-values.
- Clearly distinguish paired vs unpaired tests.
- Hypothesis direction stated explicitly (e.g. HIGH < LOW).
- Panels reflect treatments or designs, not outcomes.
- Notes must define test statistics and interpretation of means.

---

## Balance and summary tables
- Group by treatment arms.
- Report overall column and joint test p-values.
- Avoid overprecision.
- Do not mix outcomes and covariates without clear separation.

---

## Notes and interpretation
- Notes belong below the table, never inside cells.
- Always specify: test type, pairing structure, direction of comparison, sidedness.
- Keep notes concise and technical.
- Implement notes in LaTeX using `\begin{minipage}` or `threeparttable`.

---

## Export
- Use `save_table(content, filename)` from `Scripts/config_toolkit.R`.
- Output as `.tex` files to `LaTeX/Tables/`.
- No manual spacing hacks beyond `\addlinespace`.
- Same variable names and ordering across all tables.

---

## Provenance rule: R output → LaTeX

When a table in `LaTeX/` is a direct, unmodified `\input` of an R-generated `.tex` file, keep the `\input` line as-is.

**When you manually reformat or redesign an R-generated table for the paper**, you must:

1. **Inline** the new table content directly in the LaTeX file.
2. **Comment out** the original `\input` line immediately above the inlined table.

Example:
```latex
% \input{Tables/balance_means_by_fee_level.tex}
\begin{table}[htbp]
... (reformatted table content) ...
\end{table}
```

This ensures any future agent or collaborator can trace numbers back to the R source and uncomment the `\input` to restore the raw version.

---

**Rule of thumb:** if a referee can reconstruct the empirical comparison from the table alone, it is JEBO-ready.
