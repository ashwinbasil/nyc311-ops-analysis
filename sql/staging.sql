CREATE OR REPLACE VIEW staging.stg_311_requests AS
SELECT
  unique_key AS request_id,
  UPPER(agency) AS agency,
  CASE 
    WHEN UPPER(complaint_type) LIKE 'NOISE%' THEN 'NOISE'
    WHEN UPPER(complaint_type) IN ('GENERAL CONSTRUCTION','GENERAL CONSTRUCTION/PLUMBING') THEN 'GENERAL CONSTRUCTION'
    WHEN UPPER(complaint_type) IN ('HEATING','HEAT/HOT WATER') THEN 'HEAT/HOT WATER'
    WHEN UPPER(complaint_type) IN ('PAINT/PLASTER','PAINT - PLASTER') THEN 'PAINT/PLASTER'
    ELSE UPPER(complaint_type)
  END AS complaint_type_clean,
  borough,
  created_date,
  closed_date,
  EXTRACT(YEAR FROM created_date) AS request_year,
  TIMESTAMP_DIFF(closed_date, created_date, HOUR) AS resolution_hours,
  CASE 
    WHEN TIMESTAMP_DIFF(closed_date, created_date, HOUR) BETWEEN 0 AND 8760 THEN TRUE
    ELSE FALSE
  END AS is_valid_resolution,
  status
FROM `bigquery-public-data.new_york_311.311_service_requests`
WHERE agency IN ('NYPD','HPD','DOT','DSNY','DEP','DOB','DPR','DOHMH')
  AND created_date IS NOT NULL