-- macros/copy_to_file.sql
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
