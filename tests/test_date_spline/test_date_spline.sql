{# 
--   Test: test_date_spline.sql
--   Purpose: Verify that date_spline('2025-02-28','2025-03-01') 
        --    returns the correct set of dates.
#}

-- 1. Generate the actual date set via the macro
with actual_values as (
    {{ date_spline('2025-02-28','2025-03-10') }}
),

-- 2. Generate the expected date set with a recursive CTE
expected_values as (
    with recursive series as (
        select '2025-02-28'::DATE as date_at
        union all
        select date_at + interval 1 day 
        from series
        where date_at < '2025-03-10'::DATE
    )
    select date_at
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
