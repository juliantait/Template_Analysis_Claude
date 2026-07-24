# Industrial Organisation Profile

> Extends `researcher_profile.md`. Read the shared profile first; this file adds IO-specific conventions.

## Target Journals

**RAND Journal of Economics**, **Journal of Industrial Economics (JIE)**, **International Journal of Industrial Organization (IJIO)**, **Journal of Economics & Management Strategy (JEMS)**, **Review of Industrial Organization (RIO)**.

Select the specific target journal at the start of the project and note it in `research_plan.md`.

## Research Orientation

- Research area: industrial organisation (competition, pricing, market structure, entry and exit, mergers and acquisitions, regulation, vertical relationships, innovation, platform markets).
- Causal identification comes from **structural estimation**, **reduced-form quasi-experimental methods**, or a combination of both.
- Structural work builds on explicit models of firm or consumer behaviour (e.g. discrete-choice demand models, entry games, auction models, dynamic oligopoly). The model is estimated and used for counterfactual analysis.
- Reduced-form work exploits policy changes, market shocks, or institutional variation for identification (IV, DiD, RDD, event studies).
- Pre-registration is uncommon in IO. A research intention document should be populated in `research_intention.md` before proceeding to `research_plan.md`. It captures the economic model or identification strategy, data sources, market definition, and empirical specifications.
- Data features to document: source (administrative, proprietary, scraped, public), market definition, unit of observation (firm, product, market, transaction), time period, and any data-construction decisions (market boundaries, product definitions, geographic aggregation).

## Analysis Methodology

### Structural Approach

- Specify the economic model explicitly: decision problem, equilibrium concept, functional-form assumptions, and distributional assumptions.
- Estimation method: maximum likelihood, GMM, simulated methods of moments, Bayesian approaches, or indirect inference.
- Instruments: exclusion restrictions must be justified economically, not just statistically. BLP-style instruments (characteristics of rival products, cost shifters) should be stated and defended.
- Counterfactual simulations: clearly separate estimation results from counterfactual exercises. State the policy experiment, the assumptions maintained in the counterfactual, and what is allowed to change.
- Model fit: report goodness-of-fit measures (predicted vs actual shares, prices, or other moments). Compare model predictions to data patterns not used in estimation where possible.
- In prose, embed coefficient estimates and economic magnitudes (elasticities, markups, welfare changes) directly. Provide standard errors or confidence intervals for key parameters.

### Reduced-Form Approach

- Primary results use **regression-based methods** (OLS, IV, DiD, RDD, event studies) as in the empiricist profile, but applied to firm- or market-level data.
- Standard errors clustered at the appropriate level (firm, market, industry, region-time).
- Identification assumptions must be discussed and tested (parallel trends, instrument relevance and validity, bandwidth sensitivity).
- Robustness checks: alternative market definitions, alternative clustering, placebo tests, sensitivity to sample period or geographic scope, falsification tests using pre-treatment outcomes.

### Common Conventions

- Report economic magnitudes, not just statistical significance. Elasticities, markups, consumer/producer surplus changes, and welfare effects are central to IO papers. Estimates at three decimals, p-values at three decimals floored at `$p<.001$` (shared profile conventions).
- State the unit of observation (firm, product, market, transaction) for every reported statistic and keep quoted numbers at the unit of the estimation; do not mix market-level and transaction-level aggregation within a paragraph or table.
- Market definition and boundaries should be stated explicitly and sensitivity-tested.
- Data construction decisions (how products, firms, or markets are defined) should be transparent and logged in the codebook.
- Discuss and, where possible, quantify the role of key assumptions (functional form, market definition, cost structure).

## IO Journal Conventions

- Figures and tables must be interpretable in isolation.
- All figures must be greyscale-robust and colorblind-safe.
- Tables use booktabs style (no vertical lines).
- Structural papers: present parameter estimates with standard errors, then counterfactual results in separate tables or panels. Model-fit statistics should be visible.
- Reduced-form papers: present as in empiricist profile — coefficient estimates, clustered standard errors, significance stars.
- Figures focus on **market patterns** (price trends, concentration measures, entry/exit rates), **identification** (event-study plots, RDD scatter, binned scatter), and **counterfactual comparisons** (simulated vs actual, with and without policy).
- Always label: market/industry definition, time period, unit of observation, and data source in table notes.

## Typical Script Pipeline

1. `config_cleaning.R` — import raw data (firm-level, product-level, market-level) via the CSV adapter (`Helper/csv.R`), merge sources, define market boundaries, recode variables.
2. Variable generation (in `config_cleaning.R`) — construct derived variables: market shares, concentration indices (HHI, CR4), price indices, instruments, cost proxies.
3. `sample_restrictions.R` — apply sample restrictions (market definition, time period, minimum observations per firm/market).
4. `balance_table.R` — summary statistics by market, time period, or treatment/control groups (if quasi-experimental).
5. `descriptives.R` — descriptive patterns: market structure trends, price distributions, entry/exit rates, concentration dynamics.
6. `hypotheses.R` — primary specifications: structural estimation or main reduced-form regressions.
7. `robustness.R` — alternative specifications, alternative market definitions, instrument validity tests, sensitivity analyses.
8. `exploratory.R` — counterfactual simulations (structural), heterogeneity by market type or time period, mechanism tests.

## Typical LaTeX Sections

IO papers often differ from experimental papers in structure. The standard section mapping is:

| LaTeX file | IO content |
|---|---|
| `introduction.tex` | Motivation, contribution, preview of results |
| `theory.tex` | Economic model (or institutional background for reduced-form) |
| `experiment.tex` → rename to `data.tex` | Data sources, market definition, variable construction, summary statistics |
| `results.tex` | Estimation results (structural parameters or reduced-form coefficients) |
| `discussion.tex` | Counterfactual exercises, welfare analysis, policy implications |
| `appendix.tex` | Estimation details, additional robustness, data appendix |

Note: rename `experiment.tex` to `data.tex` (or `industry.tex` / `institutional_background.tex`) at project setup. Update the `\input{}` call in `main.tex` accordingly.
