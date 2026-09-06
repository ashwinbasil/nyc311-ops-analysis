CREATE OR REPLACE VIEW intermediate.int_agency_daily AS
SELECT
  agency,
  DATE(created_date) AS request_date,
  request_year,
  COUNT(*) AS total_requests,
  AVG(CASE WHEN is_valid_resolution THEN resolution_hours END) AS avg_resolution_hrs,
  APPROX_QUANTILES(CASE WHEN is_valid_resolution THEN resolution_hours END, 100)[OFFSET(90)] AS p90_resolution_hrs,
  COUNTIF(closed_date IS NULL) AS still_open,
  COUNTIF(is_valid_resolution = FALSE AND closed_date IS NOT NULL) AS data_error_count
FROM staging.stg_311_requests
GROUP BY agency, request_date, request_year