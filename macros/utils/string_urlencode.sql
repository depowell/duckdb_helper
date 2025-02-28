-- this macro will convert a input string to a urlencoded string
-- expected input: string i.e 'HE LLO'
-- expected output: string "HE%20LLO"
{%- macro string_urlencode(input_string) -%}
-- cast to text data type 
-- https://duckdb.org/docs/stable/sql/expressions/cast.html
-- https://duckdb.org/docs/stable/sql/data_types/text
'{{ input_string | urlencode }}'::varchar
{%- endmacro -%}
