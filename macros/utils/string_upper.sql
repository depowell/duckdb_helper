-- this macro will convert a input string to uppercase
-- expected input: string i.e 'hello'
-- expected output: string "HELLO"
{%- macro string_upper(input_string) -%}
-- convert input string to upper case and cast to text data type 
-- https://duckdb.org/docs/stable/sql/expressions/cast.html
-- https://duckdb.org/docs/stable/sql/data_types/text
'{{ input_string | upper }}'::varchar
{%- endmacro -%}
