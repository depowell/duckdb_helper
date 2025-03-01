-- # test macros\export\export_model_as_csv.sql
{{ config(
    tags=['integration_tests']
) }}

with
original_data as (
    select *
    from {{ ref('integration_test_export_csv') }}
),
exported_csv as (
    select *
    from read_csv_auto('./integration_test_export_csv.csv')
)

select 
    coalesce(original_data.id, -9999)     as orig_id,
    coalesce(original_data.fruit, '')     as orig_fruit,
    coalesce(exported_csv.id, -9999)      as csv_id,
    coalesce(exported_csv.fruit, '')      as csv_fruit
from original_data
full outer join exported_csv
    on original_data.id = exported_csv.id
where
    original_data.id  is null
    or exported_csv.id is null
    or original_data.fruit <> exported_csv.fruit
