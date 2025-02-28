-- macros/export_model_as_parquet.sql
{% macro export_model_as_csv(model_name, file_path) %}
  copy (
    select *
    from {{ model_name }}
  ) to '{{ file_path }}'
  (format 'csv', header true);
{% endmacro %}