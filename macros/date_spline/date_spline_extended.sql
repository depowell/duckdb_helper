-- macros/date_spline/date_spline_extended.sql
-- purpose: generate a date spline with extended date parts
-- parameters:
--   - start_val: start date of the spline
--   - end_val: end date of the spline
-- usage example:
-- {{ date_spline_extended('2025-02-28', '2025-03-10') }}
-- -- returns:
-- -- | date_at    | year | quarter | month | day | week | day_of_week | day_of_year | epoch | next_month | next_year | prev_month | prev_year |
-- -- |------------|------|---------|-------|-----|------|-------------|-------------|-------|------------|-----------|------------|-----------|
-- -- | 2025-02-28 | 2025 | 1       | 2     | 28  | 9    | 0           | 59          | 1698694400 | 2025-03-28 | 2026-02-28 | 2025-01-28 | 2024-02-28 |
{%- macro date_spline_extended(start_val, end_val) -%}
with recursive series(n) as (
    select '{{ start_val }}'::DATE as n
    union all
    select n::DATE + interval 1 day from series
    where n::DATE < '{{ end_val }}'::DATE
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
{%- endmacro -%}