-- unittest to verify expected output from macros/utils/string_capitalize.sql

with input_values as (

  select
    {{ string_capitalize('TEST_STRING') }} as actual_value
    , 'Test_string'::varchar as expected_value
    
)

select * from input_values
where actual_value <> expected_value
