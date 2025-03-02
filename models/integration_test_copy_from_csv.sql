{{ config(
    materialized='table',
    post_hook=[
      "{{ copy_from_file(model_name=this, file_path='./integration_test_copy_from_csv.csv', file_type='CSV') }}"    
    ],
    tags=['integration_tests']
) }}

select 4 as id, 'rockmelon' as fruit where false