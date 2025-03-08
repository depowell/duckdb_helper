-- macros/copy/copy_from_file.sql
-- purpose: copy data from a file into a table model
-- parameters:
--   - model_name: name of the model to copy data into
--   - file_path: path to the file to copy data from
--   - file_type: type of the file to copy data from
-- supported file types: JSON, CSV, PARQUET
-- usage example:
  -- {{ config(
  --     materialized='table',
  --     post_hook=[
  --       """{{ copy_from_file(
  --       model_name=this,
  --       file_path='./filename.csv',
  --       file_type='CSV') }}"""
  --     ]
  -- ) }}
  -- -- use manual file schema, until we have a way to infer.
  -- select 4 as id, 'rockmelon' as fruit where false
{% macro copy_from_file(model_name, file_path, file_type) %}
-- file_type must be in supported types
{% if file_type not in ['JSON', 'CSV', 'PARQUET'] %}
  {{ exceptions.raise_compiler_error("Invalid file_type. Must be one of: JSON, CSV, PARQUET") }}
{% endif %}
-- Access the model table explicitly
{% set table_name = model_name.identifier %}
-- Now execute the copy command using the model table name
copy {{ table_name }}
from '{{ file_path }}'
  {% if file_type == 'JSON' %}
    ( format JSON, array true );
  {% else %}
    ( format {{ file_type }} );
  {% endif %}
{% endmacro %}
