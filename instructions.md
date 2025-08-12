# Guide to the R Shiny App: Orienting Yourself with the Scoring Radio Buttons

This guide is intended to help applicants understand the scoring system within the interactive R Shiny application. The application's scoring is based on criteria that must be evaluated to demonstrate the "instrumental indispensability" of an animal experiment as required by Swiss law.

The scoring uses a four-point system (0-3):

  * **0:** Absent/not justified
  * **1:** Minimal/weak
  * **2:** Moderate/partial
  * **3:** Strong/robust

Some questions in the app are "Yes/No" or multiple-choice checkboxes. The selections you make are fed into an algorithm that calculates several scores and a final decision suggestion:

  * **Suitability score:** This is the mean of three validity measures.
  * **Strain score:** This is based on severity and dignity factors.
  * **Interest score:** This is calculated as (gain × likelihood) / 3 + a bonus for multiple interests.
  * **Decision suggestion:** The final output can be "favours approval," "favours approval (conditional)," "does not favour approval," or "not justifiable".

## Suitability (Scientific Validity)

The suitability score is calculated as follows:
```
suitability_score = (Construct_Validity + Internal_Validity + External_Validity) / 3
```

### Construct validity (model – question fit)

  * **0 (Absent):** The model has little to no resemblance to the biological phenomenon being investigated. For example, studying Alzheimer's disease using a generic mouse strain with no relevant pathology and a behavioral test unrelated to memory.
  * **1 (Minimal):** The model is mentioned but lacks rationale, or there are significant gaps in its relevance. For instance, using a pain model for neuropathy without explaining why the specific nerve injury mimics the human condition.
  * **2 (Moderate):** The model captures some key features of the condition, and a partial justification is provided. An example is using a transgenic mouse that develops amyloid plaques but not tau pathology to study a specific aspect of Alzheimer's disease.
  * **3 (Strong):** You clearly explain how the model mirrors the clinical or biological state, justify outcome measures, and reference relevant literature. An example is choosing the chronic constriction injury (CCI) model for neuropathic pain because it reproduces hyperalgesia and allodynia, and assessing mechanical thresholds with validated von Frey filaments.

### Internal validity (randomisation, blinding, sample size & analysis)

  * **0 (Absent):** There is no randomisation or blinding, sample sizes are arbitrary, and analysis plans are unclear. An example is allocating animals to groups "by cage order" without concealment and planning to analyze data "as we see fit".
  * **1 (Minimal):** Some bias control measures are in place but are incomplete. For example, randomizing animals but not blinding outcome assessors, or calculating sample size without specifying statistical tests.
  * **2 (Moderate):** Randomisation and blinding are described but with exceptions, and sample size calculations are only adequate for primary outcomes. An example is planning random assignment and blinding for behavioral tests but not for histology, or an analysis plan that covers the main endpoint but leaves exploratory outcomes unspecified.
  * **3 (Strong):** Comprehensive bias prevention is described, including randomisation, allocation concealment, blinding where possible, a priori power calculation for all endpoints, and a pre-registered analysis plan. This could involve using random number generators for group assignment, blinding observers for behavioral and histological scoring, and specifying the statistical model and covariates in advance.

### External validity (generalisation and reproducibility)

  * **0 (Absent):** Only one sex and strain are used, with no attempt at replication or justification. For example, using only young male mice of a single inbred strain without explaining why the results would apply more broadly.
  * **1 (Minimal):** Limited measures are taken, such as using both sexes or a second strain, but not both. Another example is planning a single replication in your own lab.
  * **2 (Moderate):** Several measures are taken to enhance generalisability, such as using both sexes, multiple strains, or planning for independent replication. An example is testing both sexes and planning an inter-lab replication on another continent.
  * **3 (Strong):** A comprehensive approach is used, such as a multicentre study with several strains/lines, both sexes, varying ages, and pre-registered replication. For instance, a consortium replicating results across at least three laboratories with different equipment and experimenters to ensure robust external validity.

## Necessity / 3Rs

The app's "Necessity" panel has three Yes/No questions:

  * **Replacement available?** If the answer is "Yes," the app immediately returns "NOT JUSTIFIABLE" because a fit-for-purpose non-animal alternative was indicated. This is a "hard stop" that occurs before any further scoring.
  * **Reduction measures justified?** (Yes/No)
  * **Refinement measures implemented?** (Yes/No)

If you answer "No" to either Reduction or Refinement and your suitability score is ≥ 1.5, the app may downgrade the decision to "Favours approval (conditional)".

## Strain & Severity

The strain score is calculated as follows:
```
strain_score = Severity + (0.5 * Number_of_NonPathocentric_Items)
```
### Prospective severity grade (0–3)

Severity is related to the pain, suffering, or harm experienced by the animals, as classified by Swiss law:

  * **0 (none):** No pain or harm is expected, and animals are killed painlessly. An example is taking tissue samples postmortem.
  * **1 (mild):** Transient or slight discomfort is expected, with full recovery and no lasting harm. Examples include short-term restraint for imaging or minor blood sampling.
  * **2 (moderate):** Moderate, temporary pain or harm is expected, but it is alleviated and full recovery occurs. This includes surgery with post-operative analgesia or the induction of mild disease models.
  * **3 (severe):** Severe pain, suffering, or harm is expected, with difficult recovery or no recovery at all. Examples include inducing a debilitating disease with significant weight loss or performing painful procedures without adequate relief.

You should choose the highest severity grade you expect for any animal in the experiment.

### Nonpathocentric strain

You should select any of the following that apply to your experiment. These factors do not involve pain or suffering but still impact an animal's dignity:

  * **Excessive instrumentalization:** The animals are used purely as tools, such as living incubators or large numbers used for minor manipulations.
  * **Humiliation / substantial loss of control:** Animals are placed in unnatural positions that induce stress or a loss of agency, for example, full body restraint without the ability to withdraw.
  * **Major interference with appearance or abilities:** Procedures that significantly alter the animal's physical form or capabilities, such as the surgical removal of limbs or genetic modifications that cause severe deformities.

Each selection adds 0.5 points to the strain score.

## Legitimate Societal Interests & Anticipated Gain

The interest score is calculated as follows:
```
interest_score = (Anticipated_Gain * Likelihood) / 3 + (0.25 * Number_of_Societal_Interests)
```
### Interests served

Select all that apply:

  * **Preservation/Protection of life & health:** The project addresses disease mechanisms, treatments, or diagnostics that could improve human or animal health.
  * **New knowledge on fundamental biological processes:** This refers to basic research aimed at understanding biological mechanisms without an immediate therapeutic application.
  * **Protection of the natural environment:** Studies that address environmental preservation, biodiversity, or ecosystem health.
  * **Advances in 3R methods:** Research that develops or improves non-animal or less harmful techniques (e.g., organoids, in silico models).

### Anticipated gain (0–3)

Rate the amount of new knowledge or societal benefit you expect:

  * **0 (None):** Negligible or no knowledge gain, or a confirmatory replication without added value.
  * **1 (Low):** Incremental insight with limited broader impact, such as a minor methodological optimization.
  * **2 (Moderate):** A significant advancement within a field, like identifying a new molecular pathway or target.
  * **3 (High):** A paradigm-shifting discovery or the development of a new therapy with wide application.

### Likelihood of achieving objectives (0–3)

Rate the chance that the experiment will answer the research question:

  * **0 (Very low):** A high risk of failure, or a pilot study with unknown feasibility.
  * **1 (Low):** Some evidence exists, but there is significant uncertainty and weak preliminary data.
  * **2 (Moderate):** A reasonable chance of success, with preliminary data supporting the hypothesis.
  * **3 (High):** Strong preliminary evidence and robust methods provide high confidence.

## Putting it All Together

The application uses a fixed sequence of rules to determine the decision suggestion.

  * If a validated, fit-for-purpose non-animal alternative exists (Replacement = Yes), the project is automatically rated as "NOT JUSTIFIABLE". No further scoring is considered.
  * If the Interest score is greater than or equal to the Strain score, the Suitability score is at least 1.5, and both the Reduction and Refinement questions are answered "Yes," the app suggests **FAVOURS APPROVAL**.
  * If the Interest score is greater than or equal to the Strain score, but one or more of the other conditions are not met, the app suggests **FAVOURS APPROVAL (conditional)**. This indicates that the proportionality is acceptable, but improvements are needed in study design or 3Rs implementation.
  * If the Interest score is less than the Strain score, the app suggests **DOES NOT FAVOUR APPROVAL**.

The pseudocode for this logic is as follows:

```
if (Replacement == "Yes") {
    decision = "NOT JUSTIFIABLE — a fit-for-purpose non-animal alternative was indicated (Replace)."
} else if (Interest_Score >= Strain_Score && Suitability >= 1.5 && Reduction == "Yes" && Refinement == "Yes") {
    decision = "FAVOURS APPROVAL — anticipated gain appears proportionate to strain, with acceptable suitability and application of 3Rs."
} else if (Interest_Score >= Strain_Score) {
    decision = "FAVOURS APPROVAL (conditional) — proportionate on balance; strengthen suitability and 3R implementation."
} else {
    decision = "DOES NOT FAVOUR APPROVAL — anticipated gain does not outweigh expected strain."
}
```

The final decision suggestion is intended to guide your reflection and inform discussions with institutional review boards or animal welfare officers.

### Example Scenario

Let's consider a project testing a novel analgesic in a chronic neuropathic pain model in mice.

**Scores:**

  * **Construct validity:** 3, because the CCI model is justified for reproducing allodynia and hyperalgesia, and von Frey thresholds are used as a validated outcome measure.
  * **Internal validity:** 3, due to a study design with randomisation, allocation concealment, full blinding, a priori power calculation, and a pre-registered analysis plan.
  * **External validity:** 2, because both sexes are included and an independent replication in another lab is planned.
  * **Suitability score:** (3 + 3 + 2) / 3 = 2.67 (which is ≥ 1.5).
  * **Replacement:** No, with justification provided.
  * **Reduction:** Yes, by using a within-subject design, reusing tissues, and sharing surplus animals.
  * **Refinement:** Yes, by administering multimodal analgesia, acclimating animals, using non-aversive handling, and defining humane endpoints.
  * **Severity grade:** 2 (moderate).
  * **Non-pathocentric strain factors:** None selected.
  * **Strain score:** 2 + (0 × 0.5) = 2.
  * **Interests served:** Preservation/protection of life & health (1 selection).
  * **Anticipated gain:** 2.
  * **Likelihood of success:** 2.
  * **Interest score:** (2 × 2) / 3 + 0.25 × 1 = 1.33 + 0.25 = 1.58.

**Decision outcome:**
In this case, since the interest score (1.58) is less than the strain score (2), the app suggests **DOES NOT FAVOUR APPROVAL**.

**Modified scenario:**
If the anticipated gain was 3, the likelihood was 3, and two interests were served (life/health and advances in 3R methods):

  * **Interest score:** (3 × 3) / 3 + 0.25 × 2 = 3 + 0.5 = 3.5.
  * Since the interest score (3.5) is greater than or equal to the strain score (2), the suitability score is ≥ 1.5, and both Reduction and Refinement are "Yes," the app would suggest **FAVOURS APPROVAL**.

This example highlights how a thoughtful study design and thorough documentation can strengthen an application and improve the outcome of the harm-benefit analysis.
