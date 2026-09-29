# NYC 311 Operations Analysis

An analytics engineering project that measures NYC agency service-request demand, resolution performance, and emerging operational risk. It uses the public NYC 311 dataset in BigQuery, transforms it with dbt, and exposes the curated marts to Power BI.

## Questions this project answers

- Which agencies receive the most requests, and how does demand change over time?
- How long do agencies take to resolve requests, including the 90th percentile?
- Where are open requests accumulating?
- Which agencies show a month-over-month deterioration in resolution time?
- How do complaint patterns differ by borough?

## Architecture

```text
BigQuery public NYC 311 data
          |
          v
stg_311_requests -> int_agency_daily -> reporting and risk marts -> Power BI
```

## Repository layout

- `dbt_project/` — executable dbt project and tests.
- `sql/` — standalone BigQuery SQL equivalents of the transformation layers.
- `docs/` — data-quality decisions and model documentation.
- `powerbi/` — Power BI report (`nyc311_dashboard.pbix`).

## Quick start

Install dbt:

```bash
python -m pip install dbt-bigquery
```

Create or update `~/.dbt/profiles.yml` (never commit credentials):

```yaml
nyc311_ops_analysis:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: YOUR_GCP_PROJECT
      dataset: nyc311_analytics_dev
      location: US
      threads: 4
```

Run the project:

```bash
cd dbt_project
dbt deps
dbt build
```

The project reads directly from `bigquery-public-data.new_york_311.311_service_requests`, so no source-data ingestion is required.

## Important data-quality decisions

- Negative resolution times are excluded: they indicate a corrupted timestamp.
- Most resolutions must fall between 0 and 8,760 hours (one year).
- Four DPR tree/park complaint types allow up to six years for legitimate long-cycle work.
- Reporting is limited to requests created before 1 November 2021 to reproduce the original analysis window.

See [data-quality notes](docs/data_quality_notes.md) and [model documentation](docs/modeling.md).

## Findings to validate in the dashboard

- DOHMH resolution time deteriorated sharply during the COVID period.
- DPR had a persistent long-resolution baseline that pre-dated COVID.
- August 2020 DPR volume surged because of damaged-tree requests following Tropical Storm Isaias; it is treated as a real operational event, not a data error.

## License

MIT. See `LICENSE`.
