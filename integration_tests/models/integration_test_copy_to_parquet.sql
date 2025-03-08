{{ config(
    post_hook=[
      "{{ duckdb_helper.copy_to_file(this, './data.parquet', 'PARQUET') }}"
    ],
    tags=['integration_tests']
) }}

select *
from (values
    (1, 'apple'),
    (2, 'banana'),
    (3, 'cherry')
) as t(id, fruit)

