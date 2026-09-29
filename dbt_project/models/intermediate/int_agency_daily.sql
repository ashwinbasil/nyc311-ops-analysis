select
    agency,
    date(created_date) as request_date,
    request_year,
    count(*) as total_requests,
    avg(if(is_valid_resolution, resolution_hours, null)) as avg_resolution_hrs,
    approx_quantiles(if(is_valid_resolution, resolution_hours, null), 100)[offset(90)] as p90_resolution_hrs,
    countif(closed_date is null) as still_open,
    countif(is_valid_resolution = false and closed_date is not null) as data_error_count
from {{ ref('stg_311_requests') }}
group by 1, 2, 3
