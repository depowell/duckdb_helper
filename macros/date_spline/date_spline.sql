{%- macro date_spline(start_val, end_val) -%}
with recursive series(n) as (
    select '{{ start_val }}'::DATE as n
    union all
    select n::DATE + interval 1 day from series
    where n::DATE < '{{ end_val }}'::DATE
)
select n as date_at from series
{%- endmacro -%}
