# Data Quality Notes

## Resolution Time Validity Rules
- Negative resolution_hours = timestamp corruption, always excluded.
- Standard cap: 0-8760 hours (1 year) for validity.
- Extended cap: 0-52560 hours (6 years) for DPR tree/park complaint types 
  (NEW TREE REQUEST, OVERGROWN TREE/BRANCHES, DAMAGED TREE, MAINTENANCE OR FACILITY)
  — legitimate long-cycle work tied to budget/seasonal planning, not data error.

## Known Issues
- DOHMH 2010-2012: timestamp corruption concentrated in SMOKING, 
  NON-RESIDENTIAL HEAT, FOOD ESTABLISHMENT, FOOD POISONING complaint types.
  Avg resolution_hours shows large negative values (~100+ years), 
  indicating closed_date recorded before created_date. Excluded via validity flag.
  ~7-10% of DOHMH volume affected in early years.

## Key Findings
- DOHMH: acute capacity failure, COVID-driven. Resolution time ~4x worse 
  (92hrs to 362hrs) Feb 2020 to June 2021.
- DPR: chronic capacity failure, pre-dates COVID. Resolution time 1000+ hrs 
  baseline even in 2020 pre-pandemic months. Structural understaffing signal.
