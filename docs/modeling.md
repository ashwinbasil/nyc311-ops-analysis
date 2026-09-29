# Data model

## Staging: `stg_311_requests`

The staging model limits the public source to eight operational agencies, standardizes complaint-type labels, and calculates elapsed time from creation to closure. Negative times are invalid; a null `closed_date` is an open request rather than an error.

## Intermediate: `int_agency_daily`

One row per agency and request date. It provides request volume, mean and p90 valid resolution time, open requests, and closed records excluded by the validity rule.

## Marts

| Model | Grain | Purpose |
| --- | --- | --- |
| `mart_agency_performance` | agency / year / month | Dashboard KPI time series |
| `mart_borough_trends` | borough / complaint type / year | Geographic and demand analysis |
| `mart_capacity_risk` | agency / year / month | Operational monitoring flag |

`mart_capacity_risk` is a transparent heuristic, not a predictive model. It is `HIGH RISK` when resolution time worsens from the previous month and the open-request rate exceeds 15%.
