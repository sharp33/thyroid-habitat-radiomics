# Data Access Policy

This repository contains code and **de-identified clinical and radiomics
data** used in the manuscript *"Predicting High-Burden Central-Compartment
Lymph Node Metastasis (>=3 positive nodes) in Papillary Thyroid Carcinoma: A
Habitat Radiomics Framework Based on Reconstructed Contrast-Enhanced CT"*
(Sun et al., submitted to *BMC Medical Imaging*).

The repository is **publicly available** under the terms below, in
accordance with the data-sharing policy of BMC Medical Imaging (a BioMed
Central open-access journal).

The raw contrast-enhanced CT volumes (`1.nii.gz` - `119.nii.gz`) are
**NOT** included in this repository.

---

## Repository status

- **Public.** This repository is set to public, and all contents are
  openly accessible to readers of the published article, peer reviewers
  during the review process, and any member of the public.
- BMC Medical Imaging uses **open peer review**: the reviewer reports
  and reviewer names are published alongside the article on acceptance.
  Reviewers may use this repository directly during their review.

## What is included

| Path | Content | Sensitivity |
| --- | --- | --- |
| `clinical.csv` | 119 patients, 9 clinical variables (age, sex, thyroid function panel, antibody titers, Hashimoto comorbidity) | De-identified. Re-identification risk is non-trivial in a 119-patient cohort; users must comply with the data-use terms below. |
| `label.csv` | Per-patient imaging filename, label (high-burden vs low-burden), cohort split | De-identified |
| `Original_Resolution_Data/features/` | Radiomic feature CSVs (PyRadiomics, IBSI-compliant) | Aggregated features |
| `Super_Resolution_Data/features/` | Same as above, on 3D SR-reconstructed CT | Aggregated features |
| `Original_Resolution_Data/models/` | Trained joblib `.pkl` files for 7 classifiers | Models |
| `Super_Resolution_Data/models/` | Same as above, on 3D SR-reconstructed CT | Models |
| `Original_Resolution_Data/results/` | Per-sample train / test prediction CSVs | De-identified |
| `Super_Resolution_Data/results/` | Same as above, on 3D SR-reconstructed CT | De-identified |
| `Original_Resolution_Data/img/` | ROC, DCA, calibration, nomogram, LASSO, MCCV, confusion-matrix SVGs | Figures only |
| `Super_Resolution_Data/img/` | Same as above, on 3D SR-reconstructed CT | Figures only |
| `Original_Resolution_Data/nomogram.png` | Nomogram figure (Figure 4D) | Figure only |
| `Super_Resolution_Data/nomogram.png` | Same as above, on 3D SR-reconstructed CT | Figure only |
| `*.ipynb` | Step 0-6 notebooks (analysis pipeline) | Code only |
| `_dump_delong.py`, `delong_code.txt` | Sun-Xu 2014 DeLong implementation | Code only |

## What is NOT included

- **Raw contrast-enhanced CT volumes** (`1.nii.gz` - `119.nii.gz`).
  These are the source images used for the radiomics pipeline. They are
  available from the corresponding author on reasonable request subject
  to institutional data-sharing agreements.
- **Manual segmentation masks** (ROI delineations). Same access route as
  the raw volumes.
- **Jupyter checkpoint files** (`.ipynb_checkpoints/`). Excluded via
  `.gitignore`.

## License and reuse

- The **code** in this repository (notebooks, `.py` files, configuration
  files, `_dump_delong.py`, `delong_code.txt`) is released under the
  **MIT License** (see [LICENSE](./LICENSE)). You are free to use,
  modify, and redistribute the code under the terms of that license.

- The **data** files in this repository (clinical.csv, label.csv, the
  contents of `features/`, `models/`, `results/`, `img/`, and any
  figure or nomogram file) are made available for **non-commercial
  academic research use** under the following terms:

  1. You may use the data to verify the findings of the associated
     manuscript and to conduct non-commercial academic research.
  2. You may not redistribute the data files to a third party; please
     direct interested researchers to this repository.
  3. You may not attempt to re-identify the patients from the data.
  4. You must cite the associated manuscript and this repository in any
     publication that makes use of the data.

  For uses outside these terms, contact the corresponding author (see
  the manuscript title page) to negotiate a data-use agreement.

## Long-term archival (recommended)

GitHub is suitable for code and active development but does not issue
DOIs. For a long-term, citable archival snapshot of this repository, the
authors recommend depositing the contents of this repository at Zenodo
(or a similar DOI-bearing repository) at the time of article
acceptance. The Zenodo DOI can then be added to the data availability
statement of the published article. The corresponding author will
arrange this deposit upon acceptance.

## Ethics

This study was conducted in accordance with the Declaration of Helsinki.
The data-sharing arrangement described in this document was approved by
the Institutional Review Board of The Affiliated Hospital of Qingdao
University. The decision to make the de-identified data publicly
available was made in compliance with the original informed consent
provisions of the participating patients.
