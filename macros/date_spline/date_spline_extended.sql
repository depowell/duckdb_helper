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