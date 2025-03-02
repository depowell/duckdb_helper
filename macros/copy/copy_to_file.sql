-- macros/copy/copy_to_file.sql
-- purpose: copy data from a model to a file
-- parameters:
--   - model_name: name of the model to copy data from
--   - file_path: path to the file to copy data to
--   - file_type: type of the file to copy data to
-- supported file types: JSON, CSV, PARQUET
-- usage example:
  -- {{ config(
  --     post_hook=[
  --       """{{ copy_to_file(
  --       model_name=this,
  --       file_path='./filename.csv',
  --       file_type='CSV') }}"""  
  --     ]
  -- ) }}

  -- select *
  -- from (values
  --     (1, 'apple'),
  --     (2, 'banana'),
  --     (3, 'cherry')
  -- ) as t(id, fruit)
{% macro copy_to_file(model_name, file_path, file_type) %}
-- file_type must be in supported types
{% if file_type not in ['JSON', 'CSV', 'PARQUET'] %}
  {{ exceptions.raise_compiler_error("Invalid file_type. Must be one of: JSON, CSV, PARQUET") }}
{% endif %}
copy (
  select * from {{ model_name }}
) to '{{ file_path }}'
( format {{ file_type }} );
{% endmacro %}
