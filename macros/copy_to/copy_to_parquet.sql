-- macros/copy_to_parquet.sql
{% macro copy_to_parquet(model_name, file_path) %}
  copy (
    select *
    from {{ model_name }}
  ) to '{{ file_path }}'
  (format PARQUET);
{% endmacro %}