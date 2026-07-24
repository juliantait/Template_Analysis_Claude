# Researcher Profile (General)

## Background

- PhD researcher in economics.
- This is the shared profile containing conventions common to all projects regardless of field or methodology.

## Research Personality

Choose one of the personalities below based on the type of study. Load the selected personality file alongside this shared profile — it specifies the target journal, field-specific conventions, and analysis methodology.

| Personality | Profile | When to use |
|---|---|---|
| **Experimentalist** | [`profile_experimentalist.md`](profile_experimentalist.md) | Lab, online, or field experiments with randomised treatment assignment. Causal identification via randomisation. Non-parametric tests are the primary evidence; regressions are robustness. Targets JEBO. |
| **Empiricist** | [`profile_empiricist.md`](profile_empiricist.md) | Observational, survey, or administrative data with behavioural economics focus. Causal identification via quasi-experimental methods (IV, DiD, RDD, matching). Regressions are the primary evidence; robustness via alternative specifications and placebo tests. Targets JEBO. |
| **Industrial Organisation** | [`profile_io.md`](profile_io.md) | Firm-level, market-level, or industry data. Competition, pricing, entry, mergers, regulation. Structural estimation or reduced-form identification. Targets RAND, JIE, IJIO, or JEMS. |

## Writing Style

- British English spelling throughout (behaviour, organisation, labour, analyse, etc.).
- Concise academic prose. No filler language.
- Results sections lead with the finding and embed core numbers (percentages, means, differences) directly in the prose. Test details follow in parentheses. Do not report test statistics in running text — only the test name and p-value, or coefficient and p-value.

## General Statistical Conventions

### Numbers and rounding

- Report exact p-values to **three decimal places, no leading zero** (`$p=.034$`, `$p=.712$`), floored at `$p<.001$`. Identical format everywhere — prose, footnotes, figure and table notes, script-generated tables.
- P-values are **never** displayed as `.000` or `0.000`. Below .001 always takes the floor.
- Report all estimates (coefficients, means, differences, marginal effects) to **three decimal places**, in prose and tables alike.
- An estimate with |value| < 0.0005 displays as `0.000` — plain rounding to zero. Never inequality notation for estimates (`<0.001`, `>-0.001`). Coefficients may round to zero; p-values may not.
- Fix formatting in the **generating R script**, never in the `.tex` file it produced. Use `fmt_p()` and `fmt_est()` from `Scripts/config_toolkit.R`.
- Avoid overprecision elsewhere: percentages and counts to whole numbers or one decimal unless the comparison needs more.

### Tests

- Always specify: **test name**, **sidedness** (one- or two-sided), and pairing/clustering structure — in prose and in notes under figures and tables.
- Report statistics at the **unit of the statistical test** (e.g. the independent group, where that is the testing unit). Never mix observation-level and group-level aggregation within one paragraph; state the unit once and hold it.
- Correlations: always state the type (**Pearson** or **Spearman**) and the unit of observation. Use the independent unit (participant, not participant × block).
- In regression tables, significance stars follow journal convention; in prose, report only p-values.
- Field-specific test conventions (which tests are primary, what to report in parentheses) are defined in the active personality profile.

### Reproducibility of quoted numbers

- **Every scalar quoted in the paper is computed by a script** and exported via `save_text()` (the `OutputValues` pattern in `Scripts/descriptives.R` → `LaTeX/Output/Text/`), then copied from there. Never hand-derive, hand-round, or read a number off console output.
- This covers the abstract, footnotes, figure and table notes, and the discussion — not just the results section.
- If the prose needs a number no script produces, add it to the values script first, re-run, then write.
- After any re-run, re-check every quoted scalar against the regenerated text output.

### Notation

- **One symbol, one meaning.** Never reuse a symbol across concepts (e.g. `r` for both a correlation and a model probability). Check the theory section's symbols before introducing a new one.
- When notation changes, grep the whole `LaTeX/` tree for stale variants — including function arguments, sub- and superscripts, not just standalone symbols.
- **Treatment names are ALL CAPS in running text** (e.g. LOW, HIGH, PARTNERS, STRANGERS) — every mention, including footnotes, captions, and float notes. This marks them as design labels rather than ordinary adjectives.
- Inside figures and tables, treatment names need not be capitalised: axis labels, legend entries, column headers, and row stubs may use normal case ("Low stakes", "High stakes") where it reads better. The label must still refer to the same treatment unambiguously.
- Treatment names, variable names, and orderings are otherwise identical across prose, figures, and tables — only the casing may differ between running text and float internals.

## LaTeX

- Paper compiles with pdflatex + bibtex.
- Modular structure: sections in separate .tex files included via `\input{}`.
- Captions and notes are added in the LaTeX document, not embedded in R-generated .png or .tex output.
- Use `\euro` for Euro symbol where applicable.
- Use a single `\begin{figure}` environment for standalone graphs. Only use `subfigure` when placing multiple panels side by side.
- Notes go in a `minipage` below the graphic or the tabular, in `\footnotesize` italic, as flowing text. **Never as a `\multicolumn` row inside the tabular**, never inside cells, and not via `threeparttable` — one form for every float in the paper. Note text must not be subject to the table's column widths.
- R-generated `.tex` files contain the tabular only; the caption and the notes minipage live in the LaTeX file that `\input`s them.
- Unit macro spacing is consistent throughout (`\euro 0.18` vs `\euro0.18` — pick one form and hold it, at minimum within a paragraph).

### Front matter

New papers inherit the **Honesty Penalty front matter** — the author-approved house default, already in place in `LaTeX/main.tex`. Do not restyle it per project; fill in the placeholders. Changing it is a convention change, logged in `Context/Flow/research_log.md`.

- **Document**: `\documentclass[12pt]{article}`, `geometry` margins `1.25in`, `\linespread{1.25}`, `[british]{babel}`, `[T1]{fontenc}`.
- **Headers**: `fancyhdr` with `\fancyhf{}`, empty left/right head, `\cfoot{\thepage}` — page number centred at the foot, nothing in the header.
- **Title and author are declared after `\begin{document}`**, immediately before `\maketitle`.
- **Title**: `\title{...\thanks{...}}`. The `\thanks` footnote carries, in order: pre-registration details with links, ethical approval body and reference numbers, funding acknowledgement.
- **Author block**: one `\author{}` — all names on a single line separated by commas with `\&` before the last, then `\\[0.5em]` and the shared affiliation in `\small`.
- **Abstract**: `\noindent` immediately before `\begin{abstract}`; the body wrapped in `\begin{singlespace}`; one paragraph, no heading of its own beyond the environment's.
- **JEL codes and keywords live *inside* the abstract environment**, not after it. The abstract text ends with `\\` followed by a blank line; then `\noindent \textbf{JEL codes}: ... \\` and `\noindent \textbf{Keywords}: ...` on the next line. Both lists comma-separated. Spacing comes from the `\\` and the blank line — do not substitute `\medskip`/`\smallskip`.
- **Page 1 is numbered on the actual first page.** No `\thispagestyle{empty}` on the title page and no `\pagenumbering` reset after the abstract — the title page is page 1 and shows it, and numbering runs continuously from there.
- `\newpage` after the abstract, then the Introduction.
- Abstract text lives in `abstract.tex` and is `\input` inside the abstract environment; the JEL/keywords lines stay in `main.tex`.

### Captions and notes

Captions and notes live in the LaTeX document, never in the R-generated `.png`/`.tex`. Full guidance in `Context/Flow/Tools/skill_graphs.md` and `skill_tables.md`; the core rules:

- Titles are **usefully descriptive**: what is plotted or estimated, for which sample, experiment, or specification. Not "Treatment effects".
- Notes are as compact as possible while remaining self-explanatory to a reader who has read only the abstract. Cover, where not already obvious: unit of observation; sample and any conditioning; treatment abbreviations spelled out; what error bars show; test type and sidedness; units (currency, percentage points).
- Notes state only what the reader cannot infer. Do not restate what the axis labels already carry (currency when the axis reads "Punishment (\euro)"), or what the facing page defines (model symbols in theory tables). Self-explanatory ≠ self-contained — brevity wins wherever the immediate context already answers the question.
- **State the fact and stop.** Say what was measured or which conditions were shown; let the reader draw the consequence ("hence only two series in panel (a)"). A consequence earns its own clause only where genuinely counter-intuitive.
- Note length scales with the float's **isolation, not its importance**. A float set in running text — main text, or a prose appendix section — leans on the adjacent paragraphs and stays terse. One parked in a figures-only or tables-only appendix, reached by nothing more than a bracketed "see Fig. X", earns a correspondingly fuller note.
- Minor balance and diagnostic checks (e.g. demographic balance across arms) go in a **footnote** of the design/data section, not a standalone appendix table.
- Describe assignment cell sizes accurately: write "approximately equal shares" unless the randomisation was hard-balanced by the software (e.g. Qualtrics evenly-present), and verify against actual cell counts either way.

### Figure template (single panel)

```latex
\begin{figure}[H]
    \centering
    \caption{Descriptive title of the figure.}
    \includegraphics[width=0.9\textwidth]{Output/Figures/filename.png}
    \label{fig:label}
    \begin{minipage}{0.8\linewidth}
        \footnotesize
        \textit{Notes:} Explanation of the figure content, unit of observation, error bars, etc.
    \end{minipage}
\end{figure}
```

### Figure template (subfigures)

```latex
\begin{figure}[H]
    \centering
    \caption{Overall caption describing both panels.}
    \begin{subfigure}{0.35\textwidth}
        \centering
        \caption{Panel (a) title}
        \includegraphics[width=\textwidth]{Figures/panel_a.png}
        \label{fig:panel_a}
    \end{subfigure}
    \begin{subfigure}{0.35\textwidth}
        \centering
        \caption{Panel (b) title}
        \includegraphics[width=\textwidth]{Figures/panel_b.png}
        \label{fig:panel_b}
    \end{subfigure}
    \label{fig:combined_label}
    \begin{minipage}{0.8\linewidth}
        \footnotesize
        \textit{Notes:} Explanation of the figure content, unit of observation, error bars, etc.
    \end{minipage}
\end{figure}
```

### Table template

Same structure as the figure: the notes are a `minipage` **below** the tabular, never a `\multicolumn` row inside it. Style detail in `Context/Flow/Tools/skill_tables.md`.

```latex
\begin{table}[H]
    \centering
    \caption{Descriptive title: what is estimated, for which sample.}
    \label{tab:label}
    \footnotesize
    \input{Output/Tables/filename.tex}   % tabular only -- no caption, no notes row
    \begin{minipage}{0.8\linewidth}
        \footnotesize
        \textit{Notes:} Unit of observation, sample and conditioning, treatment
        abbreviations spelled out, test type and sidedness, units.
    \end{minipage}
\end{table}
```

## R Coding Preferences

- Tidyverse style (dplyr, ggplot2, tidyr).
- All packages loaded in `Scripts/config_toolkit.R`, never mid-script.
- Colour palette and theme centralised in `Scripts/config_toolkit.R`.
- All output saved via `save_graph()`, `save_table()`, `save_text()` — never with hardcoded paths in analysis scripts.
- Use `cat()` messages to track execution progress.
- Commented scaffolding preferred over empty files.
- **Script separation**: the main pipeline (`balance_table.R` through `exploratory.R`) contains only analyses reported in the paper. Anything beyond what is mentioned in the manuscript — extended robustness, diagnostics, researcher-only checks — goes in `Scripts/Further Analysis/`. See the "Script separation" section in `CLAUDE.md`.
