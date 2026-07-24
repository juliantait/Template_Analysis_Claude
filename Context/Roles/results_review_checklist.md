# Results Review Checklist

> **When to use:** After all analysis scripts (`balance_table.R` through `exploratory.R`) have run and output has been generated in `LaTeX/Figures/`, `LaTeX/Tables/`, and `LaTeX/Text/`. This checklist must be completed before any writing begins. It replaces the vague instruction to "stress-test the empirical strategy" with a concrete, item-by-item review protocol.
>
> **How to use:** Work through every item in order. For each check, tick the box when satisfied, or follow the failure action if the check does not pass. Record your findings as you go — they feed directly into the `results_review.md` artefact produced at the end.
>
> **Inputs required:** All files in `LaTeX/Figures/`, `LaTeX/Tables/`, and `LaTeX/Text/`. The pre-analysis plan (`pre_analysis_plan.md`), the research plan (`research_plan.md`), and the codebook (`Context/Flow/codebook.md`).

---

## 1. Balance & Randomisation

These checks determine whether the identification strategy is credible. A failed randomisation check does not necessarily invalidate the study, but it must be addressed before writing.

**Source:** `LaTeX/Tables/balance_*.tex`, `LaTeX/Text/balance_*.txt`, and any output from `balance_table.R`.

- [ ] **Treatment arms are balanced on observables.** Check each variable in the balance table. For each, confirm that the difference between arms is not statistically significant at the 5% level and that the magnitude of any difference is substantively small.
  - *What to look for:* p-values below .05, standardised mean differences above 0.25 SD, or patterns where multiple variables lean the same direction even if none is individually significant.
  - *If this fails:* Log which variables are imbalanced and the magnitude. Assess whether the imbalance is severe enough to warrant adding controls in the robustness regressions. If severe (>0.5 SD or significant at 1%), flag as a concern that must be disclosed in the paper and add the imbalanced variable(s) as controls in `robustness.R`. Re-run robustness checks before proceeding. Record the decision in `Context/Flow/research_log.md`.

- [ ] **No joint significance of imbalance.** If the balance table includes an omnibus test (joint F-test or chi-squared test across all baseline variables), confirm it is not significant.
  - *What to look for:* A joint test p-value below .10.
  - *If this fails:* This is a stronger signal than any individual imbalance. Flag for disclosure in the paper. Consider whether re-randomisation or stratification issues exist in the design. Log in `Context/Flow/research_log.md`.

- [ ] **Attrition is not systematic across treatment arms.** Check whether dropout rates differ by treatment condition.
  - *What to look for:* Differential attrition rates across arms. Even small differences matter if they correlate with the outcome.
  - *If this fails:* Quantify the differential attrition. Check whether attriters differ from completers on observable characteristics. If differential attrition is present, flag as a concern that may require bounds analysis (Lee bounds) or at minimum disclosure and discussion. Escalate to the user if attrition exceeds 15% in any arm or if differential attrition exceeds 5 percentage points.

- [ ] **Sample sizes per arm match expectations.** Compare the realised sample sizes in the balance table against the target sample sizes in the pre-analysis plan (Section 6 of `pre_analysis_plan.md`).
  - *What to look for:* Shortfalls relative to the planned sample, or unexplained asymmetry across arms.
  - *If this fails:* Log the discrepancy. If the sample is materially smaller than planned, note the power implications (the study may be underpowered for the planned effect size). Flag for disclosure.

---

## 2. Descriptive Coherence

These checks verify that the data behave as expected and that the descriptive statistics support the rest of the analysis. Surprises here often signal data-quality problems or misspecified variables.

**Source:** `LaTeX/Tables/descriptives_*.tex`, `LaTeX/Text/descriptives_*.txt`, `LaTeX/Figures/descriptives_*.png`, and any output from `descriptives.R`.

- [ ] **Summary statistics are plausible.** For each key variable, confirm that means, standard deviations, minima, and maxima fall within theoretically sensible ranges.
  - *What to look for:* Means outside plausible bounds, standard deviations of zero (no variation), negative values for variables that should be non-negative, values exceeding defined scale endpoints.
  - *If this fails:* Trace the problem back to the data-preparation scripts (`config_cleaning.R` and the active adapter in `Helper/`). Fix the variable construction and re-run. Log the correction in `Context/Flow/research_log.md`.

- [ ] **No floor or ceiling effects.** For bounded dependent variables, check whether the distribution is piled up at the boundary.
  - *What to look for:* More than 25% of observations at the minimum or maximum of the scale. Highly skewed distributions that would violate parametric assumptions.
  - *If this fails:* Log the distributional concern. Consider whether the variable needs transformation (e.g., Tobit instead of OLS) or whether the paper should note the bounded distribution as a limitation. If severe, check that non-parametric tests (which are robust to this) are the primary evidence, and that any parametric robustness checks account for the censoring.

- [ ] **No unexpected bimodality or clustering.** Inspect distributions (histograms, density plots) for unexpected multimodal structure.
  - *What to look for:* Two or more distinct peaks, especially if they correspond to known subgroups (e.g., treatment arms, demographic splits).
  - *If this fails:* Investigate the source. If the bimodality reflects a meaningful subgroup, this may warrant exploratory subgroup analysis. If it reflects a data error (e.g., mixing two different scales), fix at source. Log in `Context/Flow/research_log.md`.

- [ ] **Full-sample and subgroup descriptives are consistent.** Where descriptives are reported for the full sample and for subgroups (e.g., by treatment arm), verify that the subgroup statistics aggregate correctly to the full-sample statistics.
  - *What to look for:* Weighted averages of subgroup means should approximate the overall mean. Subgroup sample sizes should sum to the total N.
  - *If this fails:* This typically signals a coding error in sample restrictions or subsetting. Trace back to `sample_restrictions.R` and `descriptives.R`. Fix and re-run.

- [ ] **Key values referenced in subsequent analyses match.** Confirm that any numbers cited in hypothesis-test output or robustness tables (e.g., group means, sample sizes) are consistent with what appears in the descriptive output.
  - *What to look for:* Discrepant means, percentages, or Ns between descriptive and analytical output files.
  - *If this fails:* Identify which script produces the discrepant number. The most common cause is different sample restrictions being applied inconsistently across scripts. Fix in the relevant script and re-run.

---

## 3. Hypothesis Verdicts

This is the core of the review. For each pre-registered hypothesis, determine whether the evidence supports it, partially supports it, or does not support it. Be honest — do not shade verdicts to make the story tidier.

**Source:** `LaTeX/Tables/hypotheses_*.tex`, `LaTeX/Text/hypotheses_*.txt`, `LaTeX/Figures/hypotheses_*.png`, and any output from `hypotheses.R`. Cross-reference against the hypotheses listed in `pre_analysis_plan.md` (Section 1) and `research_plan.md`.

- [ ] **Every pre-registered hypothesis has a corresponding test.** Map each hypothesis in the PAP to a specific test in the output. No hypothesis should be left untested.
  - *What to look for:* Hypotheses in the PAP that have no matching output, or tests in the output that do not correspond to any pre-registered hypothesis.
  - *If this fails:* If a hypothesis was not tested, add the test to `hypotheses.R` and re-run. If a test appears that is not pre-registered, it belongs in `exploratory.R` and must be labelled as exploratory. Log any moves in `Context/Flow/research_log.md`.

- [ ] **Direction of each effect matches the prediction.** For each hypothesis, check whether the observed effect goes in the predicted direction.
  - *What to look for:* Effects in the opposite direction from what was hypothesised. Also note null effects where a strong directional prediction was made.
  - *If this fails:* Record the direction honestly. A wrong-direction effect is still a finding and must be reported. Do not reframe the hypothesis post hoc to match the data.

- [ ] **Statistical significance is assessed correctly.** For each test, confirm: (a) the correct test was used (as specified in the PAP), (b) sidedness matches the directional nature of the hypothesis, (c) the p-value is reported to the correct precision (three decimal places, no leading zero, floor at p<.001 — see Section 9).
  - *What to look for:* One-sided tests used for non-directional hypotheses (or vice versa). Wrong test type (e.g., paired test on independent samples). Rounding errors in p-values.
  - *If this fails:* Fix the test specification in `hypotheses.R` and re-run. Log the correction.

- [ ] **Effect sizes are meaningful, not just statistically significant.** For each significant result, assess the practical magnitude of the effect. Compare to relevant benchmarks from the literature if available.
  - *What to look for:* Statistically significant effects that are trivially small in magnitude (e.g., a 0.5 percentage point difference in a donation task). Also flag large effect sizes that seem implausible for the context.
  - *If this fails:* Log the concern. If the effect is significant but trivially small, the paper must discuss practical significance, not just statistical significance. If the effect is implausibly large, investigate whether there is a coding or scaling error before accepting the result.

- [ ] **Verdict assigned for each hypothesis.** Classify each as: **Supported** (correct direction, statistically significant, meaningful effect size), **Partially supported** (correct direction but marginal significance, or significant but small effect, or significant on some measures but not others), or **Not supported** (wrong direction, not significant, or trivially small). Record the verdict, the test used, the p-value, and the effect size.
  - *What to look for:* Ambiguous cases where the classification could go either way. Be conservative — if in doubt, classify as "partially supported" rather than "supported."
  - *If this fails:* N/A — this is a recording step. But if you cannot assign a clear verdict, flag the ambiguity for discussion in the paper.

---

## 4. Robustness

These checks determine whether the main findings hold up under alternative analytical choices. Results that survive only one specification are fragile and must be flagged.

**Source:** `LaTeX/Tables/robustness_*.tex`, `LaTeX/Text/robustness_*.txt`, and any output from `robustness.R`.

- [ ] **Results survive alternative specifications.** For each main finding, check whether the corresponding robustness regression produces the same qualitative conclusion (same direction, similar magnitude, still significant or at least pointing the same way).
  - *What to look for:* Sign flips, large changes in magnitude (e.g., coefficient halves when controls are added), or loss of significance in robustness specifications.
  - *If this fails:* Log which specification causes the result to break. Determine whether the alternative specification is reasonable — if it is, the fragility is a genuine concern. If the alternative specification is clearly misspecified, document why. Either way, this must be discussed in the paper.

- [ ] **Coefficients are stable when controls are added.** Compare the treatment coefficient across specifications with and without controls. Large swings suggest omitted variable bias or multicollinearity.
  - *What to look for:* The treatment coefficient changing by more than 20-30% when controls are added. This does not automatically invalidate the result, but it signals that the controls are absorbing variance that may be correlated with treatment assignment.
  - *If this fails:* Check whether the balance table flagged imbalance on these controls. If so, the instability is expected and the controlled specification is preferred. If the balance table was clean, investigate why the controls are absorbing treatment-correlated variance. Log the finding.

- [ ] **Non-parametric and parametric results agree.** Since the experimentalist profile uses non-parametric tests as primary evidence and regressions as robustness, the two approaches should broadly agree.
  - *What to look for:* Cases where the non-parametric test is significant but the regression is not (or vice versa). Directional disagreements.
  - *If this fails:* Investigate the source of the discrepancy. Common causes: (a) the non-parametric test operates on group-level averages while the regression uses individual-level data, (b) the regression includes controls that absorb the effect, (c) distributional assumptions matter. Determine which result is more credible for the data structure and log the reasoning.

- [ ] **Primary specification is identified.** If results differ across specifications, confirm that the pre-analysis plan or research plan designates a primary specification. The paper should lead with this specification and report alternatives as sensitivity checks.
  - *What to look for:* Ambiguity about which specification is primary. Cherry-picking the most favourable specification as "primary" after seeing results.
  - *If this fails:* Defer to the PAP. If the PAP does not specify, the simplest specification consistent with the design (no controls, or only pre-registered controls) is the primary. Log the decision.

- [ ] **Multiple testing corrections applied where needed.** If multiple hypotheses are tested, check whether corrections (e.g., Bonferroni, Holm, Benjamini-Hochberg) have been applied, especially if the PAP committed to them.
  - *What to look for:* PAP commits to correction but the scripts do not apply it. Multiple hypotheses tested at the 5% level without adjustment. Results that are significant uncorrected but would not survive correction.
  - *If this fails:* Apply the correction specified in the PAP (or Holm if no method was specified). If results do not survive correction, log this — the paper must report both corrected and uncorrected results.

---

## 5. Exploratory Findings

Exploratory results are not pre-registered and must be presented as such. But strong exploratory findings can add value to the paper if handled correctly.

**Source:** `LaTeX/Tables/exploratory_*.tex`, `LaTeX/Text/exploratory_*.txt`, `LaTeX/Figures/exploratory_*.png`, and any output from `exploratory.R`.

- [ ] **Strong exploratory results identified.** Scan all exploratory output for results that are statistically significant, meaningful in magnitude, and theoretically interpretable.
  - *What to look for:* Effect sizes comparable to or larger than the main pre-registered findings. Patterns that illuminate mechanisms or heterogeneity.
  - *If this fails:* N/A — absence of strong exploratory results is fine. The paper does not need exploratory results.

- [ ] **No exploratory results contradict the main findings.** Check whether any exploratory analysis produces evidence that undermines or complicates the pre-registered results.
  - *What to look for:* Subgroup analyses where the main effect reverses. Exploratory specifications where the main treatment coefficient flips sign. Patterns that suggest the main effect is driven by a specific subgroup rather than being general.
  - *If this fails:* Log the contradicting result. The paper must disclose it — burying inconvenient exploratory findings is as problematic as burying inconvenient confirmatory findings. Assess whether the contradiction changes the narrative.

- [ ] **Subgroup analyses are adequately powered.** If exploratory analyses split the sample into subgroups, check whether each subgroup has enough observations for the test to be informative.
  - *What to look for:* Subgroups with fewer than 20-30 observations per arm (for non-parametric tests at the group level, this may mean very few independent observations). Wide confidence intervals that span zero even for large point estimates.
  - *If this fails:* Flag underpowered subgroup analyses. They can be reported but must be presented with appropriate caveats about power. Do not claim null effects in underpowered subgroups — a non-significant result in an underpowered test is uninformative.

- [ ] **Exploratory results are clearly separated from confirmatory results.** Verify that the output file naming and structure make clear which analyses are exploratory.
  - *What to look for:* Exploratory output files should follow the naming convention `exploratory_*`. No exploratory results should appear in the hypotheses or robustness output files.
  - *If this fails:* Move misplaced analyses to the correct script. If an exploratory analysis has been run in `hypotheses.R` or `robustness.R`, relocate it to `exploratory.R` and re-run.

---

## 6. Cross-Analysis Coherence

These checks verify that the full body of evidence tells a consistent story. Contradictions between sections of the analysis often signal errors, but sometimes signal genuine complexity that the paper must address.

- [ ] **Descriptives and hypothesis tests agree.** The group means visible in the descriptive output should be consistent with the direction and magnitude of the hypothesis-test results.
  - *What to look for:* Descriptive statistics showing treatment A > treatment B, but the hypothesis test reporting the opposite. Means that imply a large difference but a non-significant test (possibly a power issue), or a tiny difference but a significant test (possibly inflated by outliers or clustering).
  - *If this fails:* Trace the discrepancy. The most likely cause is different sample restrictions, different levels of aggregation, or different variable definitions being used in different scripts. Fix at source and re-run.

- [ ] **Hypothesis tests and robustness checks agree.** The qualitative conclusions from the non-parametric primary tests should match the parametric robustness checks.
  - *What to look for:* Qualitative disagreement — one says the effect exists, the other says it does not. Also note quantitative disagreement where the effect sizes are very different.
  - *If this fails:* See the guidance in Section 4 above. Investigate the source and determine which result is more credible. Log the finding.

- [ ] **Robustness checks and exploratory analyses are consistent.** If an exploratory analysis touches on the same variables or subgroups as a robustness check, the results should not contradict each other.
  - *What to look for:* An exploratory subgroup analysis showing a different pattern from what the robustness regression implies for that subgroup.
  - *If this fails:* Investigate. Often this reflects different model specifications or variable coding. Determine the correct specification and ensure consistency.

- [ ] **The overall narrative holds.** Step back and assess whether the full set of results supports a coherent story. Identify what that story is, in two to three sentences.
  - *What to look for:* Results that do not fit together. A narrative that requires too many caveats, exceptions, or "except when" qualifications. A story that would not survive a sceptical referee's reading.
  - *If this fails:* This is not something to "fix" mechanically. Log the concern. If the results genuinely do not tell a clean story, the paper must reflect that — overclaiming coherence that does not exist is a worse problem than honestly reporting mixed results.

---

## 7. Technical Quality

These checks address the mechanical correctness of the statistical implementation. Errors here undermine all results regardless of their substantive interpretation.

- [ ] **Standard errors are correctly clustered.** Verify that standard errors in all regression output are clustered at the level specified in the PAP and researcher profile (typically the group/session level for experiments).
  - *What to look for:* Unclustered standard errors in models where clustering is required. Clustering at the wrong level (e.g., individual level when the randomisation was at the session level).
  - *If this fails:* Fix the clustering in `robustness.R` (and `hypotheses.R` if parametric tests are used there). Re-run and check whether any significance conclusions change. Log the correction.

- [ ] **Multiple testing corrections applied correctly.** Cross-reference the correction method used against what the PAP specifies.
  - *What to look for:* The PAP specifies Holm but the scripts apply Bonferroni (or no correction at all). Corrections applied to the wrong family of tests.
  - *If this fails:* Implement the correct correction. Re-run and update verdicts if any result loses significance after correction.

- [ ] **Missing data handled consistently.** Verify that the same observations are included or excluded across all analyses, or that differences in sample composition are documented and explained.
  - *What to look for:* Different Ns across tables that are not explained by the analytical design (e.g., a regression with fewer observations than the descriptive table, without an explanation).
  - *If this fails:* Trace missing observations. Common causes: listwise deletion in regressions dropping observations with missing controls, inconsistent NA handling across scripts. Harmonise the sample or document why different analyses use different samples.

- [ ] **Sample sizes match across analyses.** Compare the total N and per-arm Ns reported in: (a) the balance table, (b) the descriptive statistics, (c) the hypothesis tests, (d) the robustness regressions.
  - *What to look for:* Any discrepancy that is not explained by the analytical design.
  - *If this fails:* Identify where the leak occurs. Check `sample_restrictions.R` for exclusions that may be applied inconsistently. Fix and re-run affected scripts.

- [ ] **Output files are complete and correctly named.** Verify that all expected output files exist in `LaTeX/Figures/`, `LaTeX/Tables/`, and `LaTeX/Text/`, and that they follow the naming convention defined in `CLAUDE.md`.
  - *What to look for:* Missing files that should have been generated. Files with incorrect naming patterns. Empty files.
  - *If this fails:* Re-run the relevant script. If a file was not generated, check the script for conditional logic that may have skipped the output. Fix and re-run.

---

## 8. Red Flags

These are warning signs that, individually, do not prove a problem but collectively suggest something may be wrong. Any red flag that fires should be investigated before proceeding.

- [ ] **No implausibly large effect sizes.** Check whether any estimated effect is larger than what is typical in the literature for this type of intervention or treatment.
  - *What to look for:* Cohen's d > 0.8 in a context where the literature typically finds d = 0.2-0.4. Treatment effects that explain a disproportionate share of outcome variance. Percentage differences that strain credulity.
  - *If this fails:* Do not dismiss large effects automatically — they may be genuine. But verify: (a) the variable is correctly coded, (b) the sample is not artificially restricted, (c) outliers are not driving the result. If the effect survives scrutiny, it may be a genuine finding, but the paper should discuss why it is larger than prior work.

- [ ] **No suspicious p-value clustering.** Check whether reported p-values cluster just below the .05 threshold.
  - *What to look for:* Multiple tests with p-values between .03 and .05, and few or none between .05 and .08. This pattern is consistent with (though not proof of) specification searching.
  - *If this fails:* Log the pattern. Check whether the results are robust to alternative specifications — if they are, the clustering may be coincidental. If the results are fragile, flag as a concern.

- [ ] **No results that depend on a single specification.** For each main finding, confirm that it holds across at least two analytical approaches (e.g., non-parametric and parametric, with and without controls).
  - *What to look for:* A result that is significant in exactly one specification and non-significant in all others.
  - *If this fails:* Flag the fragile result. The paper should not make strong claims based on a single-specification finding. If this is a pre-registered hypothesis, report the result honestly and discuss the fragility.

- [ ] **No unexplained sample-size changes across analyses.** Verify that every difference in N between analyses is accounted for.
  - *What to look for:* A drop in N from the descriptive analysis to the hypothesis test, or from the hypothesis test to the robustness regression, with no explanation.
  - *If this fails:* Trace the observations that are being dropped. Common causes: missing values on control variables, different exclusion criteria, subsetting errors. Fix or document.

- [ ] **No contradictions between output files and script logic.** Spot-check that the output files are consistent with what the scripts claim to produce.
  - *What to look for:* A script comment saying "two-sided test" but the output reporting a one-sided p-value. A script fitting a logit but the output labelled as OLS. Labels in graphs or tables that do not match the variable definitions in the codebook.
  - *If this fails:* Fix the script or the output labels as appropriate. Re-run.

---

## 9. Reporting & Notation Compliance

These checks verify that the output already obeys the paper's reporting conventions, before any of it is quoted in prose. Fixing formatting at this gate is cheap; fixing it after the manuscript quotes the numbers is not. Conventions are defined in `Context/Roles/researcher_profile.md`.

- [ ] **P-values are formatted correctly in every output file.** Three decimals, no leading zero, floored at `p<.001`.
  - *What to look for:* P-values printed as `0.000`, at two decimals, with inconsistent leading zeros, or in scientific notation. Formatting that differs between `.txt` values files and `.tex` tables.
  - *If this fails:* Fix in the **generating script** using `fmt_p()` / `fmt_p_prose()` from `config_toolkit.R` — never by editing the `.tex`. Re-run.

- [ ] **Estimates are rounded to three decimals, with no inequality notation.** Coefficients, means, differences, and SEs.
  - *What to look for:* Two-decimal estimates, mixed precision across tables, or a near-zero coefficient displayed as `<0.001` or `>-0.001` instead of `0.000`. Also `-0.000`.
  - *If this fails:* Route the numbers through `fmt_est()` in the generating script and re-run.

- [ ] **Every test is labelled with its name and sidedness.** In script output and in the notes that will be carried into LaTeX.
  - *What to look for:* Output reporting a bare p-value with no test named, or no one/two-sided statement. A one-sided p-value where the hypothesis is non-directional.
  - *If this fails:* Add the label in the script. Cross-check sidedness against the research basis document.

- [ ] **Aggregation unit is consistent and stated.** Each reported statistic sits at the unit of the test that accompanies it.
  - *What to look for:* A group-level test paired with an observation-level mean in the same table or text block. Descriptives at the individual level feeding a paragraph whose tests are at the group level.
  - *If this fails:* Recompute the descriptive at the testing unit, or split the reporting so each unit is stated explicitly. Log the choice.

- [ ] **Correlations state type and unit.** Pearson or Spearman, plus the unit of observation.
  - *What to look for:* An unlabelled correlation; a correlation computed on non-independent units (e.g. participant × block) where the participant is the independent unit.
  - *If this fails:* Recompute at the independent unit and label the type in the output.

- [ ] **Every scalar the paper will quote exists in `LaTeX/Output/Text/`.** Walk the planned results narrative and confirm each number has a script-generated source.
  - *What to look for:* Numbers that only appear in console output, or that would have to be derived by hand from a table (differences, ratios, percentage changes).
  - *If this fails:* Add the value to the values script (`OutputValues` → `save_text()`), re-run, and quote from the regenerated file.

- [ ] **Notation is unique and current.** One symbol, one meaning across theory, scripts, and output labels.
  - *What to look for:* A symbol serving two concepts (e.g. a correlation and a model probability). Stale variants left behind after a notation change, including inside function arguments and sub/superscripts.
  - *If this fails:* Rename, then grep the whole `LaTeX/` tree and the scripts for every occurrence of the old form.

- [ ] **Figures use the paper-wide treatment colour scheme.** Same two colours for every binary contrast; single-colour fills only on non-treatment x-axes.
  - *What to look for:* A figure where the colour mapping flips between treatments, or where a non-treatment category axis is coloured with the treatment pair.
  - *If this fails:* Fix the factor level order in cleaning and use `col_treat_a` / `col_treat_b`. Re-run the plotting script.

- [ ] **Labels and orderings match across output.** Treatment names, variable names, and row/column ordering are identical in every figure and table.
  - *What to look for:* The same treatment appearing under two different labels, or variables ordered differently between tables. Note that casing may legitimately differ between running text (ALL CAPS) and float internals (normal case) — what must not vary is the label itself, or the casing convention within the floats.
  - *If this fails:* Harmonise labels at the cleaning stage, not per-script, and re-run.

- [ ] **Treatment names are ALL CAPS everywhere in running text.** Prose, footnotes, captions, and float notes.
  - *What to look for:* A treatment written as "the low-stakes condition" in one paragraph and "LOW" in the next; capitals dropped in captions or notes.
  - *If this fails:* Fix in the LaTeX source. Figures and tables themselves are exempt — do not re-run scripts to capitalise axis labels or column headers.

---

## Summary Verdict

After completing all checks above, assign an overall verdict using the template below.

### Verdict Categories

| Verdict | Meaning | Criteria |
|---------|---------|----------|
| **Green** | Results are solid. Proceed to writing. | All checks pass or have been resolved. No unresolved red flags. Hypothesis verdicts are clear. Cross-analysis coherence is strong. |
| **Amber** | Results are usable but require caveats or additional work. | Some checks failed but have been addressed with logged fixes. Minor residual concerns remain (e.g., one underpowered subgroup analysis, one marginal result). The paper can proceed but must disclose the concerns. |
| **Red** | Results have serious problems. Do not proceed to writing. | One or more critical failures: broken randomisation, implausible effect sizes that resist diagnosis, fundamental disagreement between primary and robustness analyses, or missing pre-registered tests. Return to the analysis scripts, fix the problems, re-run, and repeat this checklist. |

### Verdict Template

```
## Overall Verdict: [Green / Amber / Red]

**Justification:**
[Two to four sentences explaining the verdict. Reference specific checklist items that informed the decision.]

**Unresolved Concerns (if Amber):**
- [Concern 1 — brief description and how it will be handled in the paper]
- [Concern 2 — ...]

**Blocking Issues (if Red):**
- [Issue 1 — what must change before re-review]
- [Issue 2 — ...]
```

---

## Producing the `results_review.md` Artefact

Once the checklist is complete, produce a `results_review.md` file and save it to `Context/Flow/`. This file is **required** before writing can begin (see the Results Review gate in `research_plan.md`).

### Required contents of `results_review.md`

The review document must contain all of the following sections:

1. **Hypothesis Summary Table.** For each pre-registered hypothesis, report:

   | Hypothesis | Prediction | Result | Direction | p-value (test, sidedness) | Effect Size | Verdict |
   |------------|------------|--------|-----------|---------------------------|-------------|---------|
   | H1         | ...        | ...    | ...       | ...                       | ...         | Supported / Partially supported / Not supported |

2. **Coherence Assessment.** A narrative paragraph assessing whether the descriptive statistics, hypothesis tests, robustness checks, and exploratory analyses tell a consistent story. Flag any contradictions and explain how they were resolved (or why they remain unresolved).

3. **Balance and Attrition.** A summary of the randomisation checks: was balance achieved? Was attrition symmetric? Were any corrections applied?

4. **Robustness Summary.** For each main finding, state whether it survived the robustness checks. Identify any fragile results.

5. **Exploratory Highlights.** List any exploratory findings that are strong enough to discuss in the paper, and any that complicate the main story.

6. **Concerns and Caveats.** A numbered list of any residual concerns, limitations, or caveats that must be acknowledged in the paper.

7. **Changes Made During Review.** A log of any changes to scripts, variable definitions, sample restrictions, or the research plan that were made as a result of this review. For each change, state what was changed, why, and which script was affected.

8. **Overall Verdict.** The Green/Amber/Red verdict with justification (copied from the verdict template above).

### Process

1. Complete every item in this checklist, recording findings as you go.
2. If any check triggers a fix (script change, re-run, additional analysis), make the fix, re-run the affected scripts, and re-verify the relevant checks.
3. Log all changes in `Context/Flow/research_log.md`.
4. Update `research_plan.md` if any design or analysis decisions changed.
5. Compile findings into `Context/Flow/results_review.md` using the structure above.
6. Update `Context/Flow/timeline.md` to mark the Results Review phase as Done.
7. Only then may writing begin.
