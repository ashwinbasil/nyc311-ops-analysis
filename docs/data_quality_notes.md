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

## Volume Anomaly
- DPR Aug 2020: total_requests spiked to 59,113 (vs 10-18k surrounding months).
  Driver: DAMAGED TREE complaints alone = 45,011 in month.
  Likely tied to Tropical Storm Isaias (NYC area, Aug 4 2020), which caused
  widespread tree damage. Confirmed as real event-driven surge, not data error.
