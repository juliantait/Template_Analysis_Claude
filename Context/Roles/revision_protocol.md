# Revision Protocol

This document governs the multi-cycle revision process that begins after the first referee report. It defines when re-analysis is required, how scripts cascade, how outputs are versioned, when the results review must be repeated, how referee reports and responses are numbered, and the step-by-step revision loop.

An AI agent executing a revision must follow this protocol mechanically. When the protocol says "escalate to user", stop and ask --- do not proceed autonomously.

---

## 1. Re-Analysis Triggers

A referee comment triggers re-analysis when it requires changing the code that produces an output, not merely the prose that describes it. The table below maps common referee requests to the scripts they affect.

| Referee Request | Primary Script(s) | Cascade From | Codebook Update | Results Review Redo |
|---|---|---|---|---|
| Alternative specification (different model, different estimator) | `hypotheses.R` and/or `robustness.R` | No cascade if output-only; cascade if variable changes needed | No | Partial (affected analyses only) |
| Questions sample restrictions (exclusion criteria, subsample definition) | `sample_restrictions.R` | Yes --- cascade to balance, descriptives, hypotheses, robustness, exploratory | Yes (exclusion rules section) | Full |
| Additional robustness checks (new tests, new controls, alternative SEs) | `robustness.R` | No cascade | No | Partial (robustness section only) |
| Variable definition issue (recoding, measurement, composite construction) | `config_cleaning.R` (variable generation section) | Yes --- cascade to sample_restrictions and all analysis scripts | Yes (variable definitions) | Full |
| New exploratory analysis | `exploratory.R` | No cascade | No | Partial (exploratory section only) |
| Data cleaning issue (raw data handling, missing value treatment, merging error) | `config_cleaning.R` + adapter in `Helper/` | Yes --- cascade to all downstream scripts | Yes (raw variable descriptions) | Full |
| Balance table concerns (different covariates, different test, stratification) | `balance_table.R` | No cascade | No | Partial (balance section only) |
| Descriptive statistics changes (new summary, different grouping) | `descriptives.R` | No cascade | No | Partial (descriptives section only) |
| Different identification strategy | ESCALATE TO USER | --- | --- | --- |

### How to Read This Table

- **Primary script(s):** The script(s) that must be edited.
- **Cascade from:** Whether downstream scripts must also be re-run. See Section 2 for the full cascade rules.
- **Codebook update:** Whether `Context/Flow/codebook.md` must be revised to reflect the change.
- **Results review redo:** Whether the results review gate must be repeated and at what scope. See Section 4.

---

## 2. Cascade Rules

The analysis pipeline has a strict dependency chain. When a script changes, every script downstream of it must be re-run, because it may consume objects (data frames, variables, sample flags) produced by the changed script.

### The Dependency Chain

```
config_init.R
  |
config_toolkit.R
  |
config_cleaning.R  (sources Helper/{adapter}.R)
  |
sample_restrictions.R
  |
  +-- balance_table.R
  +-- descriptives.R
  +-- hypotheses.R
  +-- robustness.R
  +-- exploratory.R
```

The analysis scripts (`balance_table.R` through `exploratory.R`) are all direct dependants of `sample_restrictions.R`. They are not chained to each other unless one explicitly sources output from another.

### Cascade Rules

| Script Changed | Re-Run These Scripts | Rationale |
|---|---|---|
| `config_init.R` | All scripts | Path and environment changes propagate everywhere |
| `config_toolkit.R` | All analysis scripts | Theme, palette, or save function changes propagate everywhere |
| `config_cleaning.R` or adapter in `Helper/` | config_cleaning, sample_restrictions, and all analysis scripts | Cleaned data is the foundation; everything downstream consumes it |
| `sample_restrictions.R` | sample_restrictions and all analysis scripts | Sample definition determines every analytical result |
| `balance_table.R` | balance_table only | Terminal node; no other script depends on its output |
| `descriptives.R` | descriptives only | Terminal node |
| `hypotheses.R` | hypotheses only | Terminal node |
| `robustness.R` | robustness only | Terminal node |
| `exploratory.R` | exploratory only | Terminal node |

### Exception: Cross-Dependencies Among Analysis Scripts

If any analysis script (`balance_table.R` through `exploratory.R`) reads an output file produced by another script in that group (e.g., `robustness.R` reads a model object saved by `hypotheses.R`), then changing the upstream script cascades to the downstream one. The agent must check for such cross-dependencies before concluding that a script is a terminal node. Grep for `readRDS`, `load`, `read_csv`, or `source` calls that reference other scripts' outputs.

### Executing a Cascade

When a cascade is triggered:

1. Identify the earliest changed script in the chain.
2. Re-run `main.R` from that script onward (or re-run the full pipeline --- the scripts are idempotent and the full pipeline is the safest option).
3. Do not re-run scripts upstream of the change unless they were also modified.

---

## 3. Output Versioning

### Before Re-Running: Backup

Before re-running any script that produces output, create a versioned backup of the current output subdirectories (`LaTeX/Figures/`, `LaTeX/Tables/`, `LaTeX/Text/`).

**Naming convention:**

```
Output_v{N}/
```

Where `{N}` is the revision cycle number (matching the referee report that triggered the revision). The first revision (responding to `referee_report.md`) produces `Output_v1/`. The second revision (responding to `referee_report_2.md`) produces `Output_v2/`.

**Procedure:**

1. Determine the current revision cycle number `N` (see Section 5).
2. Create the backup directory and copy the output subdirectories:
   ```bash
   mkdir -p Output_v{N}/Figures Output_v{N}/Tables Output_v{N}/Text
   cp -r LaTeX/Figures/ Output_v{N}/Figures/
   cp -r LaTeX/Tables/ Output_v{N}/Tables/
   cp -r LaTeX/Text/ Output_v{N}/Text/
   ```
3. Verify the backup is complete:
   ```bash
   diff -rq LaTeX/Figures/ Output_v{N}/Figures/
   diff -rq LaTeX/Tables/ Output_v{N}/Tables/
   diff -rq LaTeX/Text/ Output_v{N}/Text/
   ```
4. Log the backup in `Context/Flow/research_log.md`:
   ```
   ### {DATE} --- Output backup before revision cycle {N}
   **Decision:** Backed up LaTeX/Figures/, LaTeX/Tables/, LaTeX/Text/ to Output_v{N}/ before re-running scripts.
   **Rationale:** Preserving pre-revision outputs for comparison.
   **Action:** Created Output_v{N}/.
   ```

### After Re-Running: Compare

After re-running scripts, compare the new output against the backup to detect unexpected changes.

**Procedure:**

1. Run a file-level diff:
   ```bash
   diff -rq LaTeX/Figures/ Output_v{N}/Figures/
   diff -rq LaTeX/Tables/ Output_v{N}/Tables/
   diff -rq LaTeX/Text/ Output_v{N}/Text/
   ```
2. For each file that differs, determine whether the change is expected (caused by the script modifications) or unexpected (caused by a cascade effect or unintended side-effect).
3. Log every change in `Context/Flow/research_log.md` using this format:
   ```
   ### {DATE} --- Output comparison after revision cycle {N}

   **Changed files:**
   | File | Expected? | Explanation |
   |------|-----------|-------------|
   | hypotheses_h1_hiding_by_stakes.png | Yes | Referee requested alternative specification |
   | descriptives_values.txt | No | Investigate --- sample restriction change propagated |

   **Action:** [What was done about unexpected changes]
   ```
4. If an unexpected change alters a substantive result (sign flip, significance change, large magnitude shift), stop and investigate before proceeding.

### Deleted Outputs

If a revision removes an analysis (and therefore its output files):

1. Do **not** silently delete the files from `LaTeX/Figures/`, `LaTeX/Tables/`, or `LaTeX/Text/`. They are preserved in `Output_v{N}/`.
2. Log the deletion explicitly in the research log, including which analysis was removed and why.
3. Ensure the referee response document explains the removal.

---

## 4. Results Review Re-Do Criteria

The results review (`Context/Flow/results_review.md`) is the quality gate between analysis and writing. During revision, this gate may need to be repeated.

### Decision Matrix

| What Changed | Results Review Action | Scope |
|---|---|---|
| `config_cleaning.R` or `sample_restrictions.R` was modified | Full redo | All sections of the results review |
| `balance_table.R`, `descriptives.R`, or `hypotheses.R` was modified | Full redo | All sections of the results review |
| Sample changed (different N, different exclusions) | Full redo | All sections of the results review |
| Only `robustness.R` changed | Partial redo | Review only the robustness section |
| Only `exploratory.R` changed | Partial redo | Review only the exploratory section |
| Only `robustness.R` AND `exploratory.R` changed | Partial redo | Review robustness and exploratory sections |
| Only LaTeX/writing changes, no analysis modifications | Skip | No results review needed |
| Only cosmetic script changes (comments, formatting, no output change) | Skip | No results review needed |

### Full Redo Procedure

1. Produce a new results review document: `Context/Flow/results_review_v{N}.md` where `{N}` is the revision cycle number.
2. Do **not** overwrite the original `Context/Flow/results_review.md` or any previous versioned review. These are immutable records.
3. The new review must follow the same structure as the original (see `research_plan.md` for required contents):
   - Summary of each hypothesis and whether it was supported, with effect sizes.
   - Coherence assessment across analyses.
   - Concerns flagged.
   - Changes made to scripts or the research plan during the review.
4. Additionally, the versioned review must include a **comparison section** noting what changed relative to the previous review (e.g., "H1 effect size increased from d=0.15 to d=0.22 after correcting sample restriction").
5. Log the re-review in `Context/Flow/research_log.md`.

### Partial Redo Procedure

1. Produce a focused addendum: `Context/Flow/results_review_v{N}_partial.md`.
2. Cover only the sections affected by the script changes.
3. Reference the most recent full review for unchanged sections.
4. The partial review must still include the comparison section noting what changed.

---

## 5. Referee Report Numbering and History

### File Naming

| Document | First Cycle | Second Cycle | Third Cycle | Pattern |
|---|---|---|---|---|
| Referee report | `referee_report.md` | `referee_report_2.md` | `referee_report_3.md` | `referee_report[_{N}].md` |
| Referee response | `referee_response.md` | `referee_response_2.md` | `referee_response_3.md` | `referee_response[_{N}].md` |

The first report and response have no numeric suffix. Subsequent ones are numbered starting from 2.

### Rules

1. **Immutability.** Once a report or response is created, it must never be modified. These are historical records.
2. **Completeness.** Every report must have a corresponding response before the next report is generated.
3. **Pairing.** `referee_report.md` is paired with `referee_response.md`. `referee_report_2.md` is paired with `referee_response_2.md`. And so on.
4. **Determining the current cycle.** Count the number of existing `referee_report*.md` files. If none exist, you are in the pre-referee phase. If one exists without a corresponding response, you are mid-revision for that cycle. If all reports have matching responses, you are ready for the next referee cycle.

### How to Determine the Cycle Number

```
N = (number of existing referee_report*.md files that have a corresponding referee_response*.md) + 1
```

This `N` is used for:
- Naming `Output_v{N}/` backups.
- Naming `Context/Flow/results_review_v{N}.md` or `Context/Flow/results_review_v{N}_partial.md`.
- Naming the next `referee_response*.md`.
- Adding timeline sub-rows.

---

## 6. The Revision Loop

This is the step-by-step procedure for executing one revision cycle. Follow it in order. Do not skip steps.

### Step 1: Read the Latest Referee Report

- Identify the highest-numbered `referee_report*.md` in the project root.
- Read it in full. Understand every comment before proceeding.

### Step 2: Triage Comments

For each major and minor comment in the report, classify it:

| Classification | Meaning | Action |
|---|---|---|
| **Agree** | The referee is right; the fix is clear | Fix it |
| **Partially agree** | The referee raises a valid point, but the proposed solution is wrong or incomplete | Fix the underlying issue in a different way; explain in the response |
| **Disagree** | The referee is mistaken or the comment reflects a misunderstanding | Prepare a reasoned rebuttal with evidence; explain in the response |

Record the triage in a working document (not saved to the project --- this is scratchpad). Group comments into: (a) those requiring analysis changes, (b) those requiring writing changes only, (c) those requiring a response only.

### Step 2b: Group Into Independent Task Clusters

After triaging, group the comments into **independent task clusters** — sets of comments that can be addressed by separate subagents working in parallel. Two comments belong to the same cluster if they share any dependency (same script, overlapping cascade, or one comment's fix affects another's).

**Procedure:**

1. For each comment requiring analysis changes, identify its primary script(s) and cascade (using the trigger table in Section 1 and cascade rules in Section 2).
2. Build a dependency graph: two comments are **connected** if they touch any of the same scripts (including via cascade).
3. Find the connected components of this graph. Each connected component is one task cluster.
4. Comments requiring writing-only changes can form their own cluster(s), grouped by paper section.
5. Comments requiring response-only (rebuttals, clarifications) form a single cluster.

**Example:**

```
Comment A: change variable definition → config_cleaning → cascades to sample_restrictions and all analysis scripts
Comment B: new robustness check → robustness only
Comment C: different balance table test → balance_table only
Comment D: rewrite discussion section → writing only
Comment E: clarify a claim → response only

Cluster 1: {A, B, C} — all connected via the cascade from config_cleaning
Cluster 2: {D} — writing only, independent
Cluster 3: {E} — response only, independent
```

If Comment A did not exist:

```
Cluster 1: {B} — robustness only
Cluster 2: {C} — balance_table only
Cluster 3: {D} — writing only
Cluster 4: {E} — response only
```

### Step 2c: Spawn Parallel Revision Agents

For each independent task cluster, spawn a **separate Task subagent**. Each agent receives:

1. The relevant referee comments (full text, with comment numbers).
2. The triage classification for each comment (agree / partially agree / disagree).
3. The list of affected scripts and cascade requirements for its cluster.
4. The current content of all scripts it needs to read or modify (copy content in).
5. The current `research_plan.md` and `Context/Flow/codebook.md` (if the cluster requires codebook changes).
6. Instructions to follow Steps 3–5 below for its assigned comments only.
7. Instructions to return: (a) all script modifications as diffs or full replacement content, (b) any codebook updates, (c) a draft point-by-point response for its comments, (d) a list of paper sections that need rewriting.

**Rules:**

- Clusters that modify scripts **must execute sequentially** if they share cascade dependencies. Only truly independent clusters run in parallel.
- The main thread collects all agent outputs and applies them in dependency order (earliest script first).
- If any agent encounters an escalation trigger, it returns immediately with the escalation. The main thread halts all other agents and escalates to the user.
- Writing-only and response-only clusters can always run in parallel with each other and with analysis clusters.

After all agents complete, the main thread proceeds to Step 4 (Backup Outputs) with a unified picture of all changes.

### Step 3: Identify Affected Scripts

For each comment requiring analysis changes:

1. Consult the trigger table in Section 1 to identify the primary script(s).
2. Check whether a cascade is triggered using Section 2.
3. Build a complete list of scripts that must be re-run.
4. If any trigger maps to "ESCALATE TO USER", stop the entire revision loop and ask the user for guidance.

### Step 4: Backup Outputs

- Follow the backup procedure in Section 3.
- Determine `N` using the formula in Section 5.
- Create `Output_v{N}/`.
- Log the backup.

### Step 5: Apply Script Changes

For each affected script:

1. Make the required modifications.
2. Add inline comments explaining what changed and why (reference the referee comment number).
3. If the change affects variable definitions, update `Context/Flow/codebook.md`.

### Step 6: Re-Run the Pipeline

1. Identify the earliest script in the cascade.
2. Re-run from that script onward (or run the full pipeline via `main.R`).
3. Verify that the pipeline completes without errors.

### Step 7: Compare Outputs

- Follow the comparison procedure in Section 3.
- Flag unexpected changes.
- Investigate and resolve unexpected changes before proceeding.

### Step 8: Results Review Re-Do (If Required)

- Consult the decision matrix in Section 4.
- If a full or partial redo is required, execute it and produce the versioned review document.
- If no redo is required, note this in the research log with the justification.

### Step 9: Update the Research Plan

- If any design element changed (hypotheses, variables, sample, analysis strategy), update `research_plan.md`.
- If the change is substantive, add an entry to the "Notes for Future Agents" table in `research_plan.md`.

### Step 10: Rewrite Affected Paper Sections

For each LaTeX section affected by the analysis changes or the referee's comments:

1. Revise the text to reflect the new results.
2. Ensure all tables and figures referenced in the text match the current `LaTeX/Tables/` and `LaTeX/Figures/` contents.
3. **Re-check every quoted scalar against the regenerated `LaTeX/Output/Text/` files** — abstract, prose, footnotes, and figure/table notes alike. A number that no longer has a script-generated source is a stale number; regenerate it rather than adjusting it by hand.
4. If notation changed, grep the whole `LaTeX/` tree for stale variants, including function arguments and sub/superscripts.
5. Ensure that any new analyses are correctly labelled as exploratory if they were not in the pre-analysis plan.
6. Do not patch --- rewrite the affected passages so the paper reads as a coherent whole.

### Step 11: Write the Point-by-Point Response

Create the response document (`referee_response.md`, `referee_response_2.md`, etc.) with the following structure:

```markdown
# Response to Referee Report [N]

We thank the referee for their careful reading and constructive comments.
Below we address each point in turn.

## Major Comments

### Major Comment 1: [Short title from report]

**Referee:** [Quote or paraphrase the comment]

**Classification:** [Agree / Partially agree / Disagree]

**Response:** [Substantive response explaining what was done and why]

**Changes made:**
- [List specific changes: script modifications, new outputs, paper text revisions]

---

[Repeat for each major comment]

## Minor Comments

### Minor Comment 1: [Short title]

**Referee:** [Quote or paraphrase]

**Response:** [Brief response]

**Changes made:**
- [List changes]

---

[Repeat for each minor comment]

## Questions for the Authors

### Question 1: [Short title]

**Referee:** [Quote the question]

**Answer:** [Direct answer with evidence where applicable]

---

[Repeat for each question]

## Summary of All Changes

| Change | Script(s) Affected | Cascade | Output Changed | Paper Section(s) Revised |
|--------|---------------------|---------|----------------|--------------------------|
| [description] | [scripts] | [yes/no] | [files] | [sections] |

```

### Step 12: Log All Decisions

Add entries to `Context/Flow/research_log.md` for:

- Every analysis change made during the revision (one entry per distinct change).
- The overall revision cycle summary (what was done, what the referee asked for, what was changed).
- Any disagreements with the referee and the reasoning.

### Step 13: Update the Timeline

Update `Context/Flow/timeline.md`:

1. Add a sub-row for the current revision cycle:
   ```
   | -- Revise & resubmit (cycle {N}) | | Done | {DATE} | Responded to referee_report[_{N}].md |
   ```
2. If additional work was added (e.g., a new robustness check that will persist), add rows for those tasks.
3. Update "Last updated" at the top of the timeline.

### Step 14: Spawn a Fresh Referee Agent

- Follow the procedure in `Context/Roles/profile_referee.md` and in the "Referee report" section of `research_plan.md`.
- The new referee agent must be a fresh subagent with no context from the revision process.
- The new referee must receive the revised manuscript, the pre-analysis plan, and the previous referee report(s) and response(s) so it can assess whether earlier concerns were addressed.
- The new report is numbered `referee_report_{N+1}.md`.

### Step 15: Evaluate and Repeat

- If the new referee report recommends **minor revision or accept**: make the remaining minor changes, write the final response, and proceed to submission. The loop terminates.
- If the new referee report recommends **major revision**: return to Step 1 and begin a new cycle.
- If the revision cycle count exceeds 3 (i.e., you are about to start cycle 4): ESCALATE TO USER. Three major revision cycles without convergence suggests a structural problem that requires human judgment.

---

## 7. Emergency Scenarios

These situations require deviation from the standard loop. Handle them as specified.

### 7.1 Referee Requests a Fundamentally Different Identification Strategy

**Definition:** The referee argues that the entire empirical approach is inappropriate and proposes a different method (e.g., switching from difference-in-differences to instrumental variables, or from non-parametric tests to structural estimation).

**Action:** ESCALATE TO USER immediately. Do not attempt to implement a new identification strategy autonomously. Present the referee's argument, your assessment of its validity, and the feasibility of the change. The user decides whether to comply, push back, or withdraw.

### 7.2 Data Error Discovered During Revision

**Definition:** While implementing a referee's comment, you discover that the raw data was loaded incorrectly, a merge was wrong, missing values were miscoded, or similar.

**Action:**

1. Stop the current revision loop.
2. Document the error in `Context/Flow/research_log.md` with full detail.
3. Fix `config_cleaning.R` or the adapter in `Helper/` (whichever contains the error).
4. Re-run the entire pipeline from `config_cleaning.R` onward (full cascade).
5. Produce a full results review redo (`Context/Flow/results_review_v{N}.md`).
6. Compare all outputs against the backup. If any substantive result changes (sign, significance, or large magnitude shift), ESCALATE TO USER before continuing with the revision response.
7. If results are stable after fixing the error, resume the revision loop at Step 10 (rewriting paper sections).
8. Disclose the data error and correction in the referee response document.

### 7.3 Referee Report Contradicts a Previous Referee Report

**Definition:** The new referee report makes a recommendation that directly conflicts with a recommendation from a previous cycle (e.g., Referee 1 said "remove the control for X" and Referee 2 says "add a control for X").

**Action:**

1. Document both recommendations side by side in the research log.
2. Evaluate both on their merits. Which is better supported by the literature and the data?
3. In the response document, explicitly acknowledge the conflict:
   ```
   We note that this recommendation conflicts with [Report N, Comment M],
   which advised [the opposite]. We have chosen to [action] because [reasoning].
   We present the analysis both ways in the appendix for transparency.
   ```
4. Where feasible, present both versions (e.g., with and without the control variable) so the referee can evaluate the sensitivity.
5. If the conflict is irreconcilable (the two recommendations are mutually exclusive and both seem equally valid), ESCALATE TO USER.

### 7.4 Revision Cycle Exceeds Three Iterations

**Definition:** You have completed three full revision cycles (i.e., `referee_report_3.md` exists and has a response, and the fourth referee report still recommends major revision).

**Action:** ESCALATE TO USER. Present:

1. A summary of what each revision cycle changed.
2. Which comments have been addressed and which keep recurring.
3. Whether the recurring comments reflect a genuine weakness or a miscommunication.
4. Your assessment of whether further revision is likely to converge or whether a strategic decision is needed (e.g., reframing the paper, targeting a different journal, withdrawing).

### 7.5 Pipeline Fails to Run After Script Changes

**Definition:** After modifying scripts to address referee comments, `main.R` throws an error.

**Action:**

1. Do not proceed with any other revision steps.
2. Debug the error. Common causes: variable name changes in `config_cleaning.R` not propagated to `hypotheses.R`, removed columns in `sample_restrictions.R` that `descriptives.R` still references, package version conflicts.
3. Fix the error and re-run the full pipeline.
4. If the error is caused by a fundamental incompatibility (e.g., the referee's requested analysis requires a package that conflicts with the existing pipeline), document the issue and ESCALATE TO USER if no resolution is found within a reasonable scope.

---

## 8. Timeline Updates During Revision

Each revision cycle produces sub-rows in `Context/Flow/timeline.md` under the "Revise & resubmit" phase.

### Format

```markdown
| **Revise & resubmit** | | In progress | | |
| -- Cycle 1: revision | | Done | 2026-02-20 | Responded to referee_report.md |
| -- Cycle 1: re-referee | | Done | 2026-02-22 | Produced referee_report_2.md |
| -- Cycle 2: revision | | In progress | | Responding to referee_report_2.md |
| -- Cycle 2: re-referee | | Pending | | |
```

### Rules

1. Each cycle has two sub-rows: one for the revision work and one for the re-referee.
2. The parent row ("Revise & resubmit") stays "In progress" until the final referee report recommends minor revision or accept.
3. When a cycle's revision work is complete (response document written), mark it Done with the date.
4. When a cycle's re-referee is complete (new report written), mark it Done with the date.
5. When the loop terminates (referee satisfied), mark the parent row Done with the date of the final referee report.
6. If the loop is escalated to the user, mark the parent row "Blocked" and explain in Notes.
7. Always update "Last updated" at the top of the timeline file.

---

## 9. Revision Cycle Checklist

Use this checklist to verify that every step has been completed before moving to the next referee cycle. The agent must confirm each item.

```
Revision Cycle {N} Checklist:

[ ] Read the latest referee report in full
[ ] Triaged all comments (agree / partially agree / disagree)
[ ] Identified all affected scripts
[ ] Applied cascade rules correctly
[ ] Created Output_v{N}/ backup
[ ] Logged the backup in the research log
[ ] Made all script modifications
[ ] Updated codebook (if applicable)
[ ] Re-ran the pipeline successfully
[ ] Compared outputs against backup
[ ] Investigated and resolved all unexpected output changes
[ ] Completed results review redo (if required) or documented why it was skipped
[ ] Updated research_plan.md (if design changed)
[ ] Revised all affected LaTeX sections
[ ] Verified all table/figure references in text match current LaTeX/Tables/ and LaTeX/Figures/
[ ] Wrote the point-by-point response document
[ ] Logged all decisions in the research log
[ ] Updated the timeline
[ ] Spawned a fresh referee agent for the next cycle
```

---

## 10. File Location Summary

Quick reference for all files produced or consumed during revision.

| File | Location | Created By | Mutable? |
|---|---|---|---|
| `referee_report_*.md` | `Feedback/` | Referee agent / external | No --- immutable |
| `referee_response.md` | Project root | Revising agent (cycle 1) | No --- immutable |
| `referee_response_{N}.md` | Project root | Revising agent (cycle N) | No --- immutable |
| `results_review.md` | `Context/Flow/` | Results review (original) | No --- immutable |
| `results_review_v{N}.md` | `Context/Flow/` | Results review redo (cycle N) | No --- immutable |
| `results_review_v{N}_partial.md` | `Context/Flow/` | Partial results review (cycle N) | No --- immutable |
| `Output_v{N}/` | Project root | Backup before cycle N | No --- immutable |
| `LaTeX/Figures/`, `LaTeX/Tables/`, `LaTeX/Text/` | LaTeX/ | Pipeline | Yes --- overwritten on re-run |
| `Context/Flow/research_log.md` | Context/Flow/ | All agents | Yes --- append only |
| `Context/Flow/timeline.md` | Context/Flow/ | All agents | Yes --- update in place |
| `Context/Flow/codebook.md` | Context/Flow/ | All agents | Yes --- update in place |
| `research_plan.md` | Project root | All agents | Yes --- update in place |
