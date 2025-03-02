-- macros/copy_to_csv.sql
{% macro copy_to_csv(model_name, file_path) %}
  copy (
    select *
    from {{ model_name }}
  ) to '{{ file_path }}'
  (format CSV, header true);
{% endmacro %}