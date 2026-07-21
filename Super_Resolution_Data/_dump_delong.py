"""Dump the DeLong-related cells of Step6 notebook for offline review.

This script is a developer convenience: it prints Cell 6, 16, 20, 21
(legacy onekey_algo DeLong + the Sun & Xu (2014) analytic DeLong
re-implementation + the comparison + the v2->v4 explanation) of the
super-resolution Step6 notebook to stdout, so they can be inspected
without launching Jupyter.

Path is relative to this script's directory, so the script works from
any clone of the repository.
"""
import json
import os
import sys

sys.stdout.reconfigure(encoding='utf-8')

# This script lives in Super_Resolution_Data/, so the target notebook is
# in the same directory.
_here = os.path.dirname(os.path.abspath(__file__))
path = os.path.join(_here, 'Step6. Metrics_summary-Nomogram.ipynb')

with open(path, 'r', encoding='utf-8') as f:
    nb = json.load(f)

for i, cell in enumerate(nb['cells']):
    src = ''.join(cell.get('source', []))
    low = src.lower()
    if any(kw in low for kw in ['delong', 'sun', 'sunxu', 'sun & xu',
                                 'bootstrap_delong', 'pvalue_2',
                                 'z_statistic', 'placement_value',
                                 'midrank', 'fastdelong']):
        print(f'=== CELL {i} ({cell["cell_type"]}) ===')
        print(src[:4000])
        print('---END---')
