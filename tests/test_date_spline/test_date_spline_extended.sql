{# 
--   Test: test_date_spline_extended.sql
--   Purpose: Verify that date_spline_extended('2025-02-28','2025-03-01') 
        --    returns the correct set of dates.
#}

-- 1. Generate the actual date set via the macro
with actual_values as (
    {{ date_spline_extended('2025-02-28','2025-03-10') }}
),

-- 2. Generate the expected date set with a recursive CTE
expected_values as (
    with recursive series(n) as (
        select '2025-02-28'::DATE as n
        union all
        select n::DATE + interval 1 day from series
        where n::DATE < '2025-03-10'::DATE
    )
    select 
        n as date_at,
        extract(year from n) as year,
        extract(quarter from n) as quarter,
        extract(month from n) as month,
        extract(day from n) as day,
        extract(week from n) as week,
        extract(dow from n) as day_of_week,
        extract(doy from n) as day_of_year,
        extract(epoch from n) as epoch,
        n::DATE + interval '1 month' as next_month,
        n::DATE + interval '1 year' as next_year,
        n::DATE - interval '1 month' as prev_month,
        n::DATE - interval '1 year' as prev_year
    from series
)

-- 3. Compare the two sets
select 
    actual_values.date_at  as actual_date,
    expected_values.date_at as expected_date
from actual_values
full outer join expected_values
    on actual_values.date_at = expected_values.date_at
where 
    -- If there's a date in `expected_values` but not in `actual_values` (missing date), 
    -- or a date in `actual_values` but not in `expected_values` (extra date).
    actual_values.date_at is null 
    or expected_values.date_at is null
