-- # test macros\export\copy_from_file.sql
{{ config(
    tags=['integration_tests']
) }}

with
original_data as (
    select *
    from {{ ref('integration_test_copy_from_csv') }}
),
imported_csv as (
    select *
    from read_csv('./data.csv')
)

select 
    coalesce(original_data.id, -9999)     as orig_id,
    coalesce(original_data.fruit, '')     as orig_fruit,
    coalesce(imported_csv.id, -9999)      as csv_id,
    coalesce(imported_csv.fruit, '')      as csv_fruit
from original_data
full outer join imported_csv
    on original_data.id = imported_csv.id
where
    original_data.id  is null
    or imported_csv.id is null
    or original_data.fruit <> imported_csv.fruit
