{% macro dynamic_union_tables(db='RAW') %}
  
    {% set schemas = run_query("select lower(table_schema), lower(table_name) from " ~ db ~ ".information_schema.tables where table_schema ilike 'shopify_account%' and table_name ilike 'or%'") %}
    
    {% if execute %}
      {% for schema in schemas %}
          select '{{ schema[0] }}' as source, * from {{ source(schema[0], schema[1]) }}
          -- depends_on: {{ source(schema[0], schema[1]) }}
      {%- if not loop.last %}
          union all 
      {% endif %}
      {% endfor %}
    {% endif %}
    
{% endmacro %}