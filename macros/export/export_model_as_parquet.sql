-- macros/export_model_as_parquet.sql
{% macro export_model_as_parquet(model_name, file_path) %}
  copy (
    select *
    from {{ model_name }}
  ) to '{{ file_path }}'
  (format PARQUET);
{% endmacro %}