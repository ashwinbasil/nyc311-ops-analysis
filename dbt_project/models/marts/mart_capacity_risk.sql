with performance as (
    select * from {{ ref('mart_agency_performance') }}
), with_prior_month as (
    select *, lag(avg_resolution_hrs) over (partition by agency order by request_year, request_month) as prev_month_resolution
    from performance
)
select *,
    avg_resolution_hrs - prev_month_resolution as resolution_trend,
    case
        when avg_resolution_hrs > prev_month_resolution and open_rate_pct > 15 then 'HIGH RISK'
        when avg_resolution_hrs > prev_month_resolution then 'WATCH'
        else 'STABLE'
    end as capacity_risk_flag
from with_prior_month
