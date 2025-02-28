-- unittest to verify expected output from macros/utils/string_upper.sql

with input_values as (

  select
    {{ string_upper('test_string') }} as actual_value
    , 'TEST_STRING'::varchar as expected_value
    
)

select * from input_values
where actual_value <> expected_value
