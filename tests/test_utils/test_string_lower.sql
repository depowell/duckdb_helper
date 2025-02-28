-- unittest to verify expected output from macros/utils/string_lower.sql

with input_values as (

  select
    {{ string_lower('TEST_STRING') }} as actual_value
    , 'test_string'::varchar as expected_value
    
)

select * from input_values
where actual_value <> expected_value
