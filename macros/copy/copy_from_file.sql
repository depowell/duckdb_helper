-- macros/copy_from_file.sql
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
( format {{ file_type }} );
{% endmacro %}
