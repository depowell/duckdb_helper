-- # test macros\export\copy_to_file.sql
{{ config(
    tags=['integration_tests']
) }}

with
original_data as (
    select *
    from {{ ref('integration_test_copy_to_parquet') }}
),
exported_parquet as (
    select *
    from read_parquet('./integration_test_copy_to_parquet.parquet')
)

select 
    coalesce(original_data.id, -9999)     as orig_id,
    coalesce(original_data.fruit, '')     as orig_fruit,
    coalesce(exported_parquet.id, -9999)      as parquet_id,
    coalesce(exported_parquet.fruit, '')      as parquet_fruit
from original_data
full outer join exported_parquet
    on original_data.id = exported_parquet.id
where
    original_data.id  is null
    or exported_parquet.id is null
    or original_data.fruit <> exported_parquet.fruit
