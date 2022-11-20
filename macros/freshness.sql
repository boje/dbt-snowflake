{% macro collect_freshness(source, loaded_at_field, filter) %}
  {{ return(adapter.dispatch('collect_freshness', 'dbt')(source, loaded_at_field, filter))}}
{% endmacro %}

{% macro default__collect_freshness(source, loaded_at_field, filter) %}
  {% call statement('collect_freshness', fetch_result=True, auto_begin=False) -%}
    select
      max({{ current_timestamp() }}) as max_loaded_at,
      /*max({{ loaded_at_field }}) as max_loaded_at_orig,*/
      {{ current_timestamp() }} as snapshotted_at
    from {{ source }}
    {% if filter %}
    where {{ filter }}
    {% endif %}
    where (select count(*) from {{ source }}) >= (select max(number_of_rows) from raw.jaffle_shop.number_of_rows where lower(table_name) = '{{ source }}')
  {% endcall %}
  {{ return(load_result('collect_freshness').table) }}
{% endmacro %}