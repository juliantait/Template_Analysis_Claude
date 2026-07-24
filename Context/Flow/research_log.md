# Decision Log

All analytical and design decisions made during the project, with rationale. Append new entries at the bottom. Never delete or modify previous entries.

## Entry Template

Copy this template for each new decision. Prefix the title with the appropriate emoji so entries are scannable at a glance.

| Emoji | Category      |
| ----- | ------------- |
| 🔧    | Code fix      |
| 📊    | New analysis  |
| ✏️     | Writing       |
| 🧹    | Cleanup       |
| 📋    | Documentation |
| ⚙️     | Pipeline      |

```
### YYYY-MM-DD — [emoji] [Short decision title]

**Decision:** What was decided.

**Rationale:** Why this choice was made.

**Alternatives considered:** What other options were on the table and why they were rejected.

**Action:** What changed in the codebase or documentation as a result.
```

---

### 2026-02-21 — 📋 Analysis category definitions and further analyses appendix

**Decision:** Formalised the distinction between robustness, exploratory, and further analysis across the template. Added a "Further Analyses" LaTeX appendix for work that is interesting to the authors but not relevant for the paper.

**Rationale:** The existing documentation conflated robustness (tests of existing findings) with exploratory (new questions beyond hypotheses). Agents entering the project could not reliably distinguish them. Additionally, there was no structured place for analyses that were investigated, found informative, but ultimately dropped — these need a home with a brief paragraph explaining why they didn't make the cut.

**Alternatives considered:** Putting the definitions only in `context.md` without updating the R script headers. Rejected because agents often read only the script they're working in and may never consult the context file. Also considered a single catch-all appendix, but separating standard appendix material (tables/figures referenced in the paper) from further analyses (available upon request) matches journal conventions.

**Action:** Updated `Context/context.md` (analysis category definitions), `Scripts/robustness.R`, `Scripts/exploratory.R`, and `Scripts/Further Analysis/further_analysis.R` (header comments). Created `LaTeX/app_further.tex` and wired it into `LaTeX/main.tex` (commented out by default). Added change log enforcement section to `CLAUDE.md` with emoji-prefixed entry format. Updated `Context/Flow/research_log.md` entry template.

### 2026-02-23 — 📋 Added Feedback folder for referee reports and external comments

**Decision:** Created a `Feedback/` directory for storing all external feedback received during the project. Established a naming convention using `referee_report_` and `comments_` prefixes to distinguish journal referee reports from other feedback sources.

**Rationale:** The template had no structured location for incoming feedback. Referee reports, seminar comments, and committee feedback are key inputs to the revision protocol but had no defined home. A dedicated folder with clear naming conventions ensures feedback is easy to find, consistently organised, and feeds cleanly into `Context/Roles/revision_protocol.md`.

**Alternatives considered:** Storing feedback inside `Context/Flow/` alongside the research log. Rejected because feedback is external input, not internally generated documentation. Also considered a flat naming scheme without prefixes, but the `referee_report_` / `comments_` distinction makes the origin immediately scannable.

**Action:** Created `Feedback/` with `.gitkeep`. Added Feedback section to `Context/context.md` with naming convention, examples, and rules. Added Feedback section and directory entry to `README.md`. Updated directory tree in `Context/context.md` and `README.md`. Updated `Context/Roles/subagent_protocol.md` document file-writing protocol to reference `Feedback/` for external feedback. Updated `Context/Roles/revision_protocol.md` file location summary.

### 2026-02-23 — 🧹 Fixed outdated numbered script references across Context files

**Decision:** Replaced all remaining numbered script references (`00_packages.R`, `01_settings.R`, `02`–`04`, `05`–`09`, etc.) with the current script names (`config_toolkit.R`, `config_cleaning.R`, `sample_restrictions.R`, `balance_table.R`, `descriptives.R`, `hypotheses.R`, `robustness.R`, `exploratory.R`).

**Rationale:** Script names were renamed from numbered prefixes to descriptive names in an earlier restructure, but several Context files still referenced the old names. Agents reading these files would get incorrect script references.

**Alternatives considered:** None — the old names are simply wrong and must be corrected.

**Action:** Updated references in `Context/Roles/skill_graphs.md`, `Context/Roles/skill_tables.md`, `Context/Roles/researcher_profile.md`, `Context/Roles/subagent_protocol.md`, `Context/Roles/results_review_checklist.md`, `Context/Roles/revision_protocol.md`, and `Context/context.md` (output naming examples table).

### 2026-07-24 — 📋 Folded paper-revision reporting conventions into the template

**Decision:** Integrated the reporting, notation, and float-design conventions collected in `lessons_from_mistakes_paper.md` into the template's standing guidance. Key rules: p-values at three decimals with a `p<.001` floor everywhere (superseding the previous two-decimal-unless-p<.01 rule); all estimates at three decimals with near-zero values shown as plain `0.000`; formatting fixed in the generating R script rather than the `.tex`; statistics reported at the unit of the statistical test; every quoted scalar computed by a script and exported via `save_text()`; one symbol, one meaning; a paper-wide two-colour treatment scheme; and a set of caption/notes standards (descriptive titles, notes stating only what the reader cannot infer, note length scaling with the float's isolation).

**Rationale:** These conventions were learned the expensive way — through coauthor and reviewer comments on a completed paper. They are all project-agnostic, so encoding them once in the template prevents every future project from rediscovering them. Placement was chosen so an agent meets each rule where it is actually needed: the summary in `CLAUDE.md` (read every session), the authoritative detail in the researcher profile, the float-specific rules in the graph and table skills, executable helpers in the toolkit, and verification items in the results review gate.

**Alternatives considered:** (a) Keeping `lessons_from_mistakes_paper.md` as a standalone file agents are told to read — rejected because nothing in the workflow routes an agent to it at the moment a rule applies. (b) Putting everything in `CLAUDE.md` — rejected as it would bloat the entry point and duplicate the profile. (c) Documenting the formatting rules in prose only, without R helpers — rejected because a rule that is not executable gets applied inconsistently across scripts; `fmt_p()`/`fmt_est()` make compliance the default.

**Action:** Updated `CLAUDE.md` (new "Reporting rules (non-negotiable)" section under Analysis Conventions; new Task-Specific Context entries for writing and for captions/notes). Rewrote the statistical conventions in `Context/Roles/researcher_profile.md` (numbers/rounding, tests, reproducibility of quoted numbers, notation) and added a "Captions and notes" subsection plus a unit-macro spacing rule to the LaTeX section. Extended `Context/Flow/Tools/skill_graphs.md` (caption/notes rules, two-colour treatment scheme) and `Context/Flow/Tools/skill_tables.md` (three-decimal rounding, script-side formatting, titles/notes rules, demographic balance in a footnote). Added `col_treat_a`/`col_treat_b`/`treatment_colours()` and `fmt_p()`/`fmt_p_prose()`/`fmt_est()` to `Scripts/config_toolkit.R`. Added the reproducibility rule to the `Scripts/descriptives.R` header. Added Section 9 "Reporting & Notation Compliance" (nine items) to `Context/Roles/results_review_checklist.md`. Updated the p-value examples in `Context/Roles/profile_experimentalist.md` and `profile_empiricist.md`, added aggregation-unit rules to all three personality profiles, and updated the conventions paragraph in `README.md`.

### 2026-07-24 — 📋 Treatment-name casing convention

**Decision:** Treatment names are written in ALL CAPS at every mention in running text (LOW, HIGH, PARTNERS, STRANGERS), including footnotes, captions, and float notes. Inside figures and tables — axis labels, legend entries, column headers, row stubs, panel titles — normal case is permitted ("Low stakes", "High stakes"), provided the choice is applied consistently across all floats.

**Rationale:** Capitalisation marks a treatment as a design label rather than an ordinary adjective, which removes the ambiguity between "the low stakes" (a quantity) and LOW (a condition). Inside floats the surrounding structure already signals that a label is a treatment, and small caps in axis text hurt readability, so the constraint is relaxed there.

**Alternatives considered:** Requiring ALL CAPS everywhere including figures and tables — rejected as it makes axis and header text harder to read without adding information the float's structure does not already supply. Leaving casing to the writer's discretion — rejected because inconsistent casing across sections reads as sloppiness to referees and was one of the original review comments.

**Action:** Added the rule to the Notation subsection of `Context/Roles/researcher_profile.md`, to the reporting rules block in `CLAUDE.md`, and to the label guidance in `Context/Flow/Tools/skill_graphs.md` and `skill_tables.md`. Added a dedicated checklist item (plus a casing clarification to the existing label-consistency item) in Section 9 of `Context/Roles/results_review_checklist.md`.

### 2026-07-24 — 📋 Float notes always in a minipage below the tabular

**Decision:** Notes under tables and figures are always set in a `minipage` below the tabular or graphic, in `\footnotesize` flowing text. They are never a `\multicolumn` row inside the tabular, never inside cells, and `threeparttable` is not used. R-generated `.tex` files carry the tabular only — caption and notes belong to the LaTeX file that `\input`s them.

**Rationale:** A note set as a table row inherits the tabular's column widths and line-breaking, so long notes stretch the table or wrap awkwardly, and the note width changes whenever a column is added. A minipage keeps the note at a fixed measure, flowing as ordinary paragraph text, and makes every float in the paper look identical. Keeping notes out of the R output also means note wording can be revised without re-running the pipeline.

**Alternatives considered:** Allowing `threeparttable` as an equivalent option (the previous wording did) — rejected because two permitted forms produce visibly different floats within one paper. Letting `stargazer`/`kableExtra` emit their own note rows — rejected for the same column-width reason; those note options must now be suppressed explicitly.

**Action:** Rewrote the notes rule in `Context/Roles/researcher_profile.md` (LaTeX section) and added a table template alongside the existing figure templates. Updated the "Titles, notes and interpretation" and "Export" sections of `Context/Flow/Tools/skill_tables.md` (minipage-only rule, `stargazer(notes = NULL)` / no `kableExtra::footnote()`, tabular-only output, corrected the stale `LaTeX/Tables/` path to `LaTeX/Output/Tables/`) and added a table template there. Added a bullet to the reporting rules in `CLAUDE.md`. Also corrected the figure template's `\includegraphics` path to `Output/Figures/`.

### 2026-07-24 — 📋 Adopted the Honesty Penalty front matter as the house default

**Decision:** The front matter of the Honesty Penalty paper is the default for all new papers produced from this template. `LaTeX/main.tex` now reproduces it with placeholders: 12pt article at 1.25in margins with `\linespread{1.25}`; `fancyhdr` with an empty header and `\cfoot{\thepage}`; title and author declared after `\begin{document}`; `\thanks` footnote carrying pre-registration, ethics approval and funding; a single author block with names on one line and the affiliation in `\small`; a `\noindent`-led abstract wrapped in `singlespace`; **JEL codes and keywords set inside the abstract environment**, separated from the abstract text by `\\` plus a blank line, with the JEL line ending in `\\`; and **page 1 numbered on the actual first page** — no `\thispagestyle{empty}`, no `\pagenumbering` reset.

**Rationale:** The previous starter front matter differed from the author's approved layout in three visible ways: it suppressed the title-page number and restarted numbering at the introduction, it placed the JEL/keywords block outside the abstract using `\medskip`/`\smallskip`, and it lacked `eurosym` despite the profile mandating `\euro`. Encoding the approved layout once means new projects inherit it rather than re-deriving it, and the reference paper stays the single source of truth for what the front matter should look like.

**Alternatives considered:** Keeping the template's larger preamble (`siunitx`, `array`, `threeparttable`, `inputenc`) alongside the reference layout — rejected: `threeparttable` contradicts the minipage-notes convention adopted earlier today, `inputenc` is redundant under modern LaTeX, and `siunitx`/`array` were unused scaffolding. `float` was kept because the house figure and table templates use `[H]`, and `assumption` was kept as an extra theorem environment. Also considered leaving `abstract.tex` to carry the JEL/keywords block — rejected because the abstract file should hold abstract prose only, so the block stays in `main.tex` where the spacing convention is visible.

**Action:** Rewrote `LaTeX/main.tex` to match the reference front matter (preamble, title/author/abstract/JEL/keywords, page numbering); added `eurosym`, `enumitem`, `multirow`, `xcolor`; dropped `inputenc`, `threeparttable`, `array`, `siunitx` and the unused `main`/Take-away theorem environment. Updated `LaTeX/abstract.tex` to state that the JEL/keywords block belongs in `main.tex`. Brought the commented float scaffolding in `LaTeX/results.tex`, `app_tables.tex`, `app_figures.tex`, and `app_further.tex` into line with the minipage-notes convention (caption above the content, notes in a minipage below, no `threeparttable`/`tablenotes`). Added a "Front matter" subsection to `Context/Roles/researcher_profile.md`, a "Front matter" entry to the Task-Specific Context in `CLAUDE.md`, and a description in the Phase 5 section of `README.md`. Verified with `latexmk`: compiles clean, page 1 carries the number, JEL/keywords render inside the abstract block.
