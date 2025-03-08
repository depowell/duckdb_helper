-- # test macros\export\copy_from_file.sql
{{ config(
    tags=['integration_tests']
) }}

with
original_data as (
    select *
    from {{ ref('integration_test_copy_from_json') }}
),
imported_json as (
    select *
    from read_json_auto('./data.json')
)

select 
    coalesce(original_data.id, -9999)     as orig_id,
    coalesce(original_data.fruit, '')     as orig_fruit,
    coalesce(imported_json.id, -9999)      as csv_id,
    coalesce(imported_json.fruit, '')      as csv_fruit
from original_data
full outer join imported_json
    on original_data.id = imported_json.id
where
    original_data.id  is null
    or imported_json.id is null
    or original_data.fruit <> imported_json.fruit
