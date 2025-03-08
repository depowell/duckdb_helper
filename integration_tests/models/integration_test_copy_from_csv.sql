{{ config(
    materialized='table',
    post_hook=[
      "{{ duckdb_helper.copy_from_file(model_name=this, file_path='./data.csv', file_type='CSV') }}"    
    ],
    tags=['integration_tests']
) }}

select 4 as id, 'rockmelon' as fruit where false