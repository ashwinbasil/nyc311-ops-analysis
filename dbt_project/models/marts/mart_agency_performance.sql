select
    agency, request_year, extract(month from request_date) as request_month,
    sum(total_requests) as total_requests,
    avg(avg_resolution_hrs) as avg_resolution_hrs,
    avg(p90_resolution_hrs) as p90_resolution_hrs,
    sum(still_open) as still_open,
    sum(data_error_count) as data_error_count,
    round(safe_divide(sum(still_open), sum(total_requests)) * 100, 2) as open_rate_pct
from {{ ref('int_agency_daily') }}
where request_date < date('2021-11-01')
group by 1, 2, 3
