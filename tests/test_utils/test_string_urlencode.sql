-- unittest to verify expected output from macros/utils/string_urlencode.sql

-- commented out uncomment to test the macro output:
-- {% set actual_value = string_urlencode('test_ string') | trim | replace("'", "") %}
-- {{ log("DEBUG: actual_value = " ~ actual_value, info=True) }}

with input_values as (

  select
    {{ string_urlencode('test_ string') }} as actual_value
    , 'test_%20string'::varchar as expected_value
    
)

select * from input_values
where actual_value <> expected_value
