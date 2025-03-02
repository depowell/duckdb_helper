{{ config(
    post_hook=[
      "{{ copy_to_file(model_name=this, file_path='./integration_test_copy_to_csv.csv', file_type='CSV') }}"    
    ],
    tags=['integration_tests']
) }}

select *
from (values
    (1, 'apple'),
    (2, 'banana'),
    (3, 'cherry')
) as t(id, fruit)

