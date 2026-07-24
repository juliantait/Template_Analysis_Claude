# Experimentalist Profile

> Extends `researcher_profile.md`. Read the shared profile first; this file adds experiment-specific conventions.

## Target Journal

**Journal of Economic Behavior & Organization (JEBO)**.

## Research Orientation

- Research area: experimental and behavioural economics (lab experiments, online experiments, incentivised decisions, team behaviour).
- Causal identification comes from **randomisation** into treatment and control conditions.
- Studies use a **pre-analysis plan** (PAP). If the researcher has an existing PAP (from AsPredicted, OSF, or elsewhere), it should be uploaded and populated in `pre_analysis_plan.md`. If no PAP exists, one is created with the user before proceeding to `research_plan.md`. Hypotheses are stated directionally and tested with the appropriate one-sided or two-sided tests as pre-registered.
- Design features to document: number of sessions, subjects per session, randomisation procedure, payment scheme, and any deception policy.

## Analysis Methodology

- Primary results use **non-parametric tests** wherever possible (e.g. Wilcoxon rank-sum, Wilcoxon signed-rank, permutation tests).
- Non-parametric tests are conducted at the **group level**: collapse individual-level data to one observation per independent group before testing.
- Parametric tests (OLS, logit, etc.) serve as **robustness checks**, replicating the same predictions tested non-parametrically.
- Standard errors in all parametric models are clustered at the group level.
- The hypotheses script reports non-parametric results as the primary evidence; the robustness script re-tests the same predictions with regressions and controls.
- In prose, report only: test type, p-value, and sidedness in parentheses — e.g. `(rank-sum test, $p=.712$, one-sided)`. Do **not** include test statistics ($z$, $W$, etc.). P-values always at three decimals, floored at `$p<.001$`.
- Descriptive statistics quoted alongside a group-level test are computed **at the group level too**. Never pair an observation-level mean with a group-level p-value in the same paragraph.
- Embed core numbers (percentages, means, monetary amounts, differences) directly in the sentence. State the comparison plainly before the parenthetical test.
- Specify sidedness (one-sided or two-sided) consistent with the directional or non-directional nature of each hypothesis.
- Specify the pairing structure of every test (independent samples or matched pairs).
- Number of independent observations/groups should be reported once per analysis (e.g. in the methods section or table notes), not repeated with every test.

## JEBO Conventions

- Figures and tables must be interpretable in isolation (a referee should understand the result without the main text).
- All figures must be greyscale-robust and colorblind-safe.
- Tables use booktabs style (no vertical lines).
- Non-parametric tests are preferred for primary results; regressions serve as robustness.
- Treatment-effect figures (e.g. bar charts with error bars, CDFs by treatment) are the main visual evidence.
- Always label treatments clearly in figures and tables; a referee must understand the comparison without the main text.

## Typical Script Pipeline

1. `config_cleaning.R` — import raw experimental data via the oTree adapter (`Helper/otree.R`), apply exclusions, recode variables.
2. Variable generation (in `config_cleaning.R`) — construct derived variables (treatment indicators, composite scores).
3. `sample_restrictions.R` — apply sample restrictions and exclusion criteria.
4. `balance_table.R` — randomisation balance checks across treatment groups.
5. `descriptives.R` — summary statistics and key values referenced in the paper.
6. `hypotheses.R` — non-parametric tests of hypotheses.
7. `robustness.R` — OLS/logit regressions with controls replicating the same predictions.
8. `exploratory.R` — additional analyses not covered by the main hypotheses.
