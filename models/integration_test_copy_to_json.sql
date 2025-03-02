{{ config(
    post_hook=[
      "{{ copy_to_file(this, './integration_test_copy_to_json.json', 'JSON') }}"
    ],
    tags=['integration_tests']
) }}

select *
from (values
    (1, 'apple'),
    (2, 'banana'),
    (3, 'cherry')
) as t(id, fruit)

