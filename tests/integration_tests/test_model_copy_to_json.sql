-- # test macros\export\copy_to_file.sql
{{ config(
    tags=['integration_tests']
) }}

with
original_data as (
    select *
    from {{ ref('integration_test_copy_to_json') }}
),
exported_json as (
    select *
    from read_json('./integration_test_copy_to_json.json')
)

select 
    coalesce(original_data.id, -9999)     as orig_id,
    coalesce(original_data.fruit, '')     as orig_fruit,
    coalesce(exported_json.id, -9999)      as json_id,
    coalesce(exported_json.fruit, '')      as json_fruit
from original_data
full outer join exported_json
    on original_data.id = exported_json.id
where
    original_data.id  is null
    or exported_json.id is null
    or original_data.fruit <> exported_json.fruit
