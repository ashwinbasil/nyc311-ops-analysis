CREATE OR REPLACE VIEW marts.mart_agency_performance AS
SELECT
  agency,
  request_year,
  EXTRACT(MONTH FROM request_date) AS request_month,
  SUM(total_requests) AS total_requests,
  AVG(avg_resolution_hrs) AS avg_resolution_hrs,
  AVG(p90_resolution_hrs) AS p90_resolution_hrs,
  SUM(still_open) AS still_open,
  SUM(data_error_count) AS data_error_count,
  ROUND(SAFE_DIVIDE(SUM(still_open), SUM(total_requests)) * 100, 2) AS open_rate_pct
FROM intermediate.int_agency_daily
WHERE request_date < DATE('2021-11-01')
GROUP BY agency, request_year, request_month;

CREATE OR REPLACE VIEW marts.mart_borough_trends AS
SELECT
  borough,
  complaint_type_clean,
  request_year,
  COUNT(*) AS total_requests,
  AVG(CASE WHEN is_valid_resolution THEN resolution_hours END) AS avg_resolution_hrs
FROM staging.stg_311_requests
WHERE borough IS NOT NULL AND borough != 'Unspecified'
GROUP BY borough, complaint_type_clean, request_year;

CREATE OR REPLACE VIEW marts.mart_capacity_risk AS
SELECT
  agency,
  request_year,
  request_month,
  total_requests,
  avg_resolution_hrs,
  open_rate_pct,
  LAG(avg_resolution_hrs) OVER (PARTITION BY agency ORDER BY request_year, request_month) AS prev_month_resolution,
  avg_resolution_hrs - LAG(avg_resolution_hrs) OVER (PARTITION BY agency ORDER BY request_year, request_month) AS resolution_trend,
  CASE 
    WHEN avg_resolution_hrs > LAG(avg_resolution_hrs) OVER (PARTITION BY agency ORDER BY request_year, request_month) 
     AND open_rate_pct > 15 THEN 'HIGH RISK'
    WHEN avg_resolution_hrs > LAG(avg_resolution_hrs) OVER (PARTITION BY agency ORDER BY request_year, request_month) THEN 'WATCH'
    ELSE 'STABLE'
  END AS capacity_risk_flag
FROM marts.mart_agency_performance;