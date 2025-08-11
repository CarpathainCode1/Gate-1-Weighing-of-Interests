# R Shiny Application – Instrumental Indispensability Checker

This repository contains an interactive **R Shiny application** that implements the *instrumental indispensability* assessment required under Swiss law before animal experiments may be licensed.

In Switzerland, animal studies are permitted only when the applicant can demonstrate that the proposed work is scientifically suitable, necessary, and appropriate. Only then do licensing bodies compare the expected strain on animals with the anticipated gain in knowledge.

The Swiss Animal Welfare Act and its implementing guidelines require researchers to respect animal dignity and apply the **3Rs** (*Replacement, Reduction, Refinement*). The Swiss Academy of Medical Sciences (SAMS) updated its weighing-of-interests guidance in 2022, and in 2025 SAMS and the Federal Food Safety and Veterinary Office published new ethical guidelines clarifying these obligations.

This app operationalises those documents to help applicants prepare comprehensive submissions.

---

## Features

- **Project information** – Title, objective, and research hypotheses (Form A §20–22).
- **Suitability assessment** – Three 0–3 anchor ratings:
  - Construct validity
  - Internal validity
  - External validity
  The suitability score is the mean of these three ratings.
- **Necessity / 3Rs** – Three Yes/No questions:
  - Replacement available? (If “Yes” → **Not justifiable**)
  - Reduction measures justified? (Yes/No)
  - Refinement measures implemented? (Yes/No)
- **Strain & severity** – Severity grade (0–3) plus 0.5 points for each non‑pathocentric factor selected (excessive instrumentalisation, humiliation/loss of control, major interference with appearance/abilities).
- **Societal interests & anticipated gain** – Choose any of four societal interests, rate gain and likelihood (0–3 each). Interest score is calculated as:
  ```
  interest_score = (gain × likelihood) / 3 + 0.25 × (# interests selected)
  ```
- **Automated scoring & decision suggestion** – Decision logic:
  1. If Replacement = Yes → “NOT JUSTIFIABLE”
  2. Else if `interest_score ≥ strain_score` and `suitability ≥ 1.5` and Reduction = Yes and Refinement = Yes → “FAVOURS APPROVAL”
  3. Else if `interest_score ≥ strain_score` → “FAVOURS APPROVAL (conditional)”
  4. Else → “DOES NOT FAVOUR APPROVAL”
- **Narrative generation** – Auto‑produces a Form A‑style text summary.
- **Audit trail** – When run locally, saves scores and summary to timestamped files.

---

## Installation

1. Install **R** (>= 4.0) and RStudio.
2. Install dependencies:
   ```r
   install.packages(c("shiny", "bslib", "glue"))
   ```
3. Clone or download this repository and save `app.R` into a folder (e.g. `gate1_app/`).

---

## Running the App

From RStudio:

```r
setwd("path/to/gate1_app")
shiny::runApp(".")
```

The app will open in your browser. You can also deploy it to a Shiny Server for institutional use.

---

## How to Use

The interface is organised into five tabs:

1. **Project** – Title, objective, and hypotheses.
2. **Instrumental indispensability** – Rate construct, internal, and external validity (0–3 each). Answer Yes/No for replacement, reduction, and refinement.
3. **Strain & severity** – Choose severity grade (0–3) and select any non‑pathocentric strain factors.
4. **Societal interests & gain** – Select interests served, rate gain and likelihood (0–3 each).
5. **Summary** – View suitability, strain, and interest scores, decision suggestion, and download a narrative report.

---

## Example Scenario

**Testing a novel analgesic in a chronic neuropathic pain mouse model:**

- Construct validity = 3, Internal = 3, External = 2 → Suitability = 2.67
- Replacement = No, Reduction = Yes, Refinement = Yes
- Severity = 2, no non‑pathocentric factors → Strain score = 2
- Interests = life/health only (1 selection), Gain = 2, Likelihood = 2 → Interest score = (2×2)/3 + 0.25×1 = 1.58

Since interest_score (1.58) < strain_score (2) → “DOES NOT FAVOUR APPROVAL”.

If Gain and Likelihood were both 3 and two societal interests selected → Interest score = 3.5 ≥ Strain score → “FAVOURS APPROVAL”.

---

## Limitations

- Decision-support only — does not replace ethics review.
- Thresholds and weights reflect the script logic and may be adapted to institutional requirements.

---

## License

© 2025 Your Organisation. MIT License – see [LICENSE](LICENSE) for details.

---

## Citation

If you use or adapt this app, please cite the accompanying paper describing the methodology.

**Reference:** [Animal experimentation – SAMS](https://www.samw.ch/en/Projects/Overview-of-projects/Animal-experimentation.html)
