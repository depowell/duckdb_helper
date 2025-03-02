{{ config(
    post_hook=[
      "{{ export_model_as_parquet(this, './integration_test_export_parquet.parquet') }}"
    ],
    tags=['integration_tests']
) }}

select *
from (values
    (1, 'apple'),
    (2, 'banana'),
    (3, 'cherry')
) as t(id, fruit)

