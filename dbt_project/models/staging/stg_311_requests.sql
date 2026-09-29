with base as (
    select
        cast(unique_key as string) as request_id,
        upper(agency) as agency,
        case
            when upper(complaint_type) like 'NOISE%' then 'NOISE'
            when upper(complaint_type) in ('GENERAL CONSTRUCTION', 'GENERAL CONSTRUCTION/PLUMBING') then 'GENERAL CONSTRUCTION'
            when upper(complaint_type) in ('HEATING', 'HEAT/HOT WATER') then 'HEAT/HOT WATER'
            when upper(complaint_type) in ('PAINT/PLASTER', 'PAINT - PLASTER') then 'PAINT/PLASTER'
            else upper(complaint_type)
        end as complaint_type_clean,
        borough, created_date, closed_date,
        extract(year from created_date) as request_year,
        timestamp_diff(closed_date, created_date, hour) as resolution_hours,
        status
    from {{ source('nyc311', 'service_requests') }}
    where agency in ('NYPD', 'HPD', 'DOT', 'DSNY', 'DEP', 'DOB', 'DPR', 'DOHMH')
      and created_date is not null
)
select *,
    case
        when resolution_hours < 0 then false
        when complaint_type_clean in ('NEW TREE REQUEST', 'OVERGROWN TREE/BRANCHES', 'DAMAGED TREE', 'MAINTENANCE OR FACILITY') and resolution_hours between 0 and 52560 then true
        when resolution_hours between 0 and 8760 then true
        else false
    end as is_valid_resolution
from base
