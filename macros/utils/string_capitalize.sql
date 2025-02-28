-- this macro will convert a input string to capitalized or proper case
-- expected input: string i.e 'HELLO'
-- expected output: string "Hello"
{%- macro string_capitalize(input_string) -%}
-- cast to text data type 
-- https://duckdb.org/docs/stable/sql/expressions/cast.html
-- https://duckdb.org/docs/stable/sql/data_types/text
'{{ input_string | capitalize }}'::varchar
{%- endmacro -%}
