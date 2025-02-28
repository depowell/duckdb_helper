-- this macro will convert a input string to lowercase
-- expected input: string i.e 'HELLO'
-- expected output: string "hello"
{%- macro string_lower(input_string) -%}
-- convert input string to lower case and cast to text data type 
-- https://duckdb.org/docs/stable/sql/expressions/cast.html
-- https://duckdb.org/docs/stable/sql/data_types/text
lower('{{ input_string }}')::varchar
{%- endmacro -%}
