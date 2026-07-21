# Reviewer Guide

Thank you for agreeing to review
**"Predicting High-Burden Central-Compartment Lymph Node Metastasis
(>=3 positive nodes) in Papillary Thyroid Carcinoma: A Habitat Radiomics
Framework Based on Reconstructed Contrast-Enhanced CT"** (Sun et al.,
submitted to *BMC Medical Imaging*).

This guide explains how to navigate the public code-and-data archive
that accompanies the manuscript so that you can verify every reported
statistic.

> **Note on open peer review.** BMC Medical Imaging uses an open peer
> review process: reviewer reports and reviewer names are published
> alongside the article on acceptance. This repository is **publicly
> available** at
> https://github.com/sharp33/thyroid-habitat-radiomics, in line with
> BMC's data-sharing policy. You do not need to request access; you may
> clone or browse the repository directly.

---

## What is in this repository

| Path | What it is | What to verify |
| --- | --- | --- |
| `README.md` | Top-level project description | Sanity check the structure |
| `LICENSE` | MIT license for code (data is restricted, see `ACCESS.md`) | License terms |
| `ACCESS.md` | Full data access policy | Data availability compliance |
| `CITATION.cff` | Citation metadata | Citation format |
| `requirements.txt` | Python dependencies | Reproducibility |
| `clinical.csv` | 119 patients x 9 clinical variables | Table 1 (baseline statistics) |
| `label.csv` | Per-patient imaging filename, label, cohort split | Table 1, group allocation |
| `Original_Resolution_Data/` | Pipeline on raw-resolution CT (244 files) | Table S2 (secondary / transparency) |
| `Super_Resolution_Data/` | Pipeline on 3D SR-reconstructed CT (246 files) | Table 1, Table 2, Table S2, Table S3, Figure 3, Figure 4, Figure S5 |

> **Which pipeline to look at for which number.** The
> `Super_Resolution_Data/` subfolder is the **primary** analysis that
> produced every main-text figure and table (Table 1 / Table 2 / Table
> S3 derived from the same `clinical.csv` + `label.csv`; Table 2 / Table
> S2 / Figure 3 / Figure 4D / Figure S5 derived from the per-sample
> prediction CSVs in `Super_Resolution_Data/results/`). The
> `Original_Resolution_Data/` subfolder is the same pipeline on the
> raw-resolution CT, included only for transparency in Table S2; it is
> **not** the source of any main-text figure or table. The habitat
> XGBoost test AUC is 0.913 on the super-resolution pipeline (the
> number reported in the manuscript) and 0.867 on the raw-resolution
> pipeline.

> The **raw contrast-enhanced CT volumes** (1.nii.gz to 119.nii.gz) and
> the manual segmentation masks are **NOT** in this repository. They are
> available from the corresponding author on reasonable request subject
> to institutional data-sharing agreements.

## How to verify each reported number

### Table 1: Baseline clinical characteristics

1. Open `clinical.csv` (119 rows) and `label.csv` (119 rows).
2. The per-cohort split (`train` / `test`) and per-patient label are in
   `label.csv`.
3. Run `Super_Resolution_Data/Step4. Clinical_baseline_statistical_analysis.ipynb`
   (or equivalently `Original_Resolution_Data/Step4. ...`) end-to-end.
   The notebook reads `clinical.csv` and `label.csv`, computes the
   baseline statistics table, and exports it to `clinic_sel.csv` and
   `stats.csv` (in `Super_Resolution_Data/`) or `stats1.csv` (in
   `Original_Resolution_Data/` — the two files are byte-identical, only
   the filename differs).
4. Compare the rendered table against Table 1 of the manuscript.
5. The per-cohort train / test split is fixed across the manuscript, the
   Support Information, and the Provenance Documents.

### Table 2: Classifier performance on the test cohort

1. Open the per-sample prediction CSVs in
   `Super_Resolution_Data/results/` and
   `Original_Resolution_Data/results/`. There are 45 files in each,
   one per (model, cohort) pair.
2. Run `Super_Resolution_Data/Step6. Metrics_summary-Nomogram.ipynb`
   end-to-end. The notebook aggregates the per-sample CSVs into the
   per-model metrics table. Table 2 of the manuscript reports the
   numbers from `Super_Resolution_Data/results/`.

### Table S2: 7 classifiers x 2 resolutions

Same procedure as Table 2, but combining the results from both
`Original_Resolution_Data/results/` and `Super_Resolution_Data/results/`.

### Table S3: Univariable logistic regression

Run `Super_Resolution_Data/Step4. Clinical_baseline_statistical_analysis.ipynb`
(or equivalently `Original_Resolution_Data/Step4. ...`) and compare the
univariable logistic regression output against Table S3 of the
manuscript.

### Figure 3: ROC, DCA, calibration curves

1. The figure source SVGs are in `Super_Resolution_Data/img/` and
   `Original_Resolution_Data/img/`. There are 161 SVGs in each
   (covering Clinic, Habitat, INTRA, and Nomogram across 7 classifiers
   and 2 resolutions).
2. Open the relevant SVGs in a browser or vector graphics editor. The
   filenames encode the model and metric, e.g.
   `Habitat_model_XGBoost_roc_label.svg` is the ROC curve for the
   Habitat model with XGBoost.

### Figure 4: Nomogram

1. `Super_Resolution_Data/nomogram.png` is the nomogram figure
   (Figure 4D of the manuscript). `Original_Resolution_Data/nomogram.png`
   is the corresponding figure on the raw-resolution pipeline (for
   Table S2 reference only; **not** the source of Figure 4D).
2. The nomogram was built from the Habitat Rad-score + Sex only.
3. To verify the nomogram, run
   `Super_Resolution_Data/Step6. Metrics_summary-Nomogram.ipynb`
   end-to-end. The notebook reconstructs the nomogram from the LASSO
   coefficients and the trained logistic regression.

### Figure S5: DeLong tests

1. Open `Super_Resolution_Data/Step6. Metrics_summary-Nomogram.ipynb`,
   **Cell 20** (the Sun & Xu (2014) analytic DeLong implementation
   `_compute_midrank` / `_fastDeLong` / `sunxu_delong_test`) and Cell 21
   (the comparison vs the legacy onekey_algo DeLong). The same code
   reads `Super_Resolution_Data/results/Habitat_XGBoost_test.csv`,
   `Super_Resolution_Data/results/Nomo_test.csv`,
   `Super_Resolution_Data/results/Clinic_LR_test.csv`, and the
   repository-root `label.csv` via relative paths.
2. The DeLong Z-statistics reported in the manuscript are:
   - Habitat vs. Nomogram: Z = −0.155, p = 0.877
   - Habitat vs. Clinical: Z = +5.89, p < 0.0001
   - Nomogram vs. Clinical: Z = +5.68, p < 0.0001
3. These can be re-derived by re-running Cell 20 of the notebook. The
   `_dump_delong.py` and `delong_code.txt` files in
   `Super_Resolution_Data/` are a copy of the same code for reference.

## Re-running the analysis end-to-end

If you want to re-run the analysis from scratch (rather than inspecting
the pre-computed outputs):

1. Install the Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. **Install the `onekey_algo` package from the institution's
   distribution channel** (this is the radiomics pipeline orchestrator
   used in the manuscript; it is not on PyPI). Without `onekey_algo`,
   the Step1 / Step2 / Step6 notebooks cannot be re-executed end-to-end.
3. **Edit `Original_Resolution_Data/config.yaml` and
   `Super_Resolution_Data/config.yaml`**. The repository ships with
   sanitized paths (`REPLACE_ME/...`) so the pipelines will not run
   without your local data. To re-run, replace the placeholders with
   the absolute path to your local copy of the raw CT volumes and the
   `label.csv` file. The raw CT volumes are available from the
   corresponding author on reasonable request.
4. **Launch Jupyter and run the notebooks in order**:
   - Step0: Generate_synthetic_data
   - Step1: Rad-intratumoral
   - Step2: Habitat
   - Step3: Habitat_feature_visualization
   - Step4: Clinical_baseline_statistical_analysis
   - Step5: Clinical
   - Step6: Metrics_summary-Nomogram
5. The notebook outputs will overwrite the files in `features/`,
   `models/`, `results/`, and `img/`. To compare against the
   manuscript, use the `Provenance Documents` provided in the
   manuscript submission system; those capture the exact values that
   were reported.

## Where to get help

- **Repository structure / code questions**: Open a GitHub Issue on
  this repository. The corresponding author will respond within 48
  hours. (Because the repository is public, GitHub Issues are visible
  to any visitor; please do not include confidential material in
  issues.)
- **Raw CT volumes, manual segmentation masks**: Email the
  corresponding author (see the manuscript title page).
- **Anything else**: Email the corresponding author.

## A note on the access window

This repository is **publicly available** for the duration of the peer
review process and indefinitely after publication. No access request
is required at any stage. If the manuscript is rejected, the
repository will remain public for the historical record; the
corresponding author may pin a notice to that effect on the main page.
