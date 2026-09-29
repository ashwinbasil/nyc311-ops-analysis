select
    borough, complaint_type_clean, request_year,
    count(*) as total_requests,
    avg(if(is_valid_resolution, resolution_hours, null)) as avg_resolution_hrs
from {{ ref('stg_311_requests') }}
where borough is not null and borough != 'Unspecified'
group by 1, 2, 3
