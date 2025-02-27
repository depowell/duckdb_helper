  {% macro test_uppercase_macro() %}
    {% set result = my_macro('test_string') %}
    {% if result != 'TEST_STRING' %}
      {{ exceptions.raise_compiler_error("Macro failed") }}
    {% endif %}
  {% endmacro %}