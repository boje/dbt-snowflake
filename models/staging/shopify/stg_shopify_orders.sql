with customers as (

{% set schemas = run_query("select lower(table_schema), lower(table_name) from raw.information_schema.tables where table_schema ilike 'shopify_account%' and table_name ilike 'or%'") %}
    
    {% if execute %}
    {% set list_of_sources = [] %}
      {% for schema in schemas %}
            {%- do list_of_sources.append(source(schema[0] , 'orders')) -%}
      {% endfor %}
    {% endif %}

    {{- dbt_utils.union_relations(
    list_of_sources,
    column_override={'id': 'string'}
    )
    -}}

),

final as (

    select
        *
    from customers

)

select * from final