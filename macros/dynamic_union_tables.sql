{% macro dynamic_union_tables() %}


   {%- for i in range(1, 3) %}
      --select * from raw.shopify_account_{{i}}.orders
        select * from {{ source('shopify_account_'~i, 'orders') }}
      {%- if not loop.last %}
          union all 
      {% endif %}
  
  {%- endfor %}

    
{% endmacro %}