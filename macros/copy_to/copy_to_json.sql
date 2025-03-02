-- macros/copy_to_json.sql
{% macro copy_to_json(model_name, file_path) %}
  copy (
    select *
    from {{ model_name }}
  ) to '{{ file_path }}'
  (format JSON);
{% endmacro %}